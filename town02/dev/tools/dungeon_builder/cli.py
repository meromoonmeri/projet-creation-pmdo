"""Command line interface of the Dungeon Builder.

    python3 tools/dungeon_builder.py audit
    python3 tools/dungeon_builder.py preview sinister_woods --floor 7 --count 10
    python3 tools/dungeon_builder.py validate sinister_woods --count 10
    python3 tools/dungeon_builder.py generate sinister_woods
    python3 tools/dungeon_builder.py generate-all --chapters 6-32
"""
from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path
from typing import List, Optional, Sequence

from .definitions import (DefinitionError, DungeonDefinition, find_definition, list_definitions,
                          load_definition)
from .dtef import DtefError, available_packages, resolve as resolve_dtef
from .grounds import check_grounds
from .profiles import BUILTIN_PROFILES, customize
from .report import build_report, write_report
from .rng import DungeonRng
from .validation import Thresholds, validate_floor
from .zone_export import build_zone, write_zone

ROOT = Path(__file__).resolve().parents[2]


def _profiles_for_floor(definition: DungeonDefinition, floor: int):
    segment = definition.segment_for_floor(floor)
    choices = definition.profiles_for(segment, floor)
    return [customize(choice.name, choice.overrides) for choice in choices], segment


def cmd_audit(args) -> int:
    print("Architecture profiles (all built from native RogueElements steps):")
    for name, profile in sorted(BUILTIN_PROFILES.items()):
        merge_range = (max(1, profile.combine_rate // 10), max(2, profile.combine_rate // 5))
        print(f"  - {name:12s} path={profile.path:9s} connect={profile.connect_percent:3d}% "
              f"merge-attempts={merge_range[0]}-{merge_range[1] - 1} tags={','.join(profile.tags)}")
    print()
    packages = available_packages()
    print(f"DTEF packages imported in Data/AutoTile (mod-owned): {len(packages)}")
    for name, package in sorted(packages.items()):
        print(f"  - {name}: {package.floor} / {package.wall} / {package.secondary}")
    from .dtef import base_tilesets, check_tileset_uniqueness
    base = sorted(base_tilesets())
    triplets = sorted({n[:-6] for n in base if n.endswith("_floor")
                       and f"{n[:-6]}_wall" in base and f"{n[:-6]}_secondary" in base})
    print(f"base PMDO tilesets already referenced by shipped data: {len(base)} "
          f"({len(triplets)} complete biome triplets)")
    print("  " + ", ".join(triplets))
    print()
    definitions = list_definitions()
    print(f"Dungeon definitions in DungeonDefs/canonical: {len(definitions)}")
    for path in definitions:
        try:
            definition = load_definition(path)
            print(f"  - {definition.id:20s} ch.{definition.chapter:<3d} "
                  f"{definition.floors:>3d} floors, {len(definition.segments)} segments")
        except DefinitionError as exc:
            print(f"  - {path.name}: INVALID ({exc})")
    loaded = []
    for path in definitions:
        try:
            loaded.append(load_definition(path))
        except DefinitionError:
            continue
    for problem in check_tileset_uniqueness(loaded):
        print(f"  ! {problem}")
    return 0


def cmd_verify_source(args) -> int:
    """Validate the emitted zones against the engine's own C# sources."""
    from .source_conformance import default_source_roots, run
    roots = [Path(p) for p in args.sources] if args.sources else default_source_roots()
    missing = [str(r) for r in roots if not r.exists()]
    if missing:
        print("engine sources not found: " + ", ".join(missing), file=sys.stderr)
        print("clone them with: git clone --recurse-submodules "
              "https://github.com/PMDCollab/PMDC.git", file=sys.stderr)
        return 2
    only = None
    if args.only_ours:
        only = sorted({load_definition(p).id for p in list_definitions()
                       if _safe_id(p)})
    report = run(roots, only=only)
    print(f"{report.types_checked} engine types indexed, {report.objects_checked} objects checked")
    print(f"unknown $types: {len(report.unknown_types)}")
    for kind in report.unknown_types[:20]:
        print(f"  ! {kind}")
    print(f"unknown members: {len(report.unknown_members)}")
    for type_name, member, zone in report.unknown_members[:20]:
        print(f"  ! {type_name}.{member}  ({zone})")
    print(f"namespace/assembly mismatches: {len(report.wrong_namespace)}")
    for emitted, expected, zone in report.wrong_namespace[:20]:
        print(f"  ! {emitted} -> expected {expected} ({zone})")
    return 0 if report.ok else 1


def _safe_id(path) -> bool:
    try:
        load_definition(path)
        return True
    except DefinitionError:
        return False


def cmd_preflight(args) -> int:
    """Check that every asset referenced by the generated zones exists."""
    from .runtime_check import preflight_all, runtime_kit, write_report
    results = preflight_all()
    for result in sorted(results, key=lambda r: (r.ok, r.dungeon)):
        flag = "OK  " if result.ok else "FAIL"
        print(f"[{flag}] {result.dungeon:22s} tilesets={result.tilesets:>2d} "
              f"checks={result.checks:>3d} problems={len(result.problems)}")
        if not result.ok and args.verbose:
            for problem in result.problems:
                print(f"        {problem}")
    good = sum(1 for r in results if r.ok)
    print(f"\n{good}/{len(results)} zones with every reference resolved")
    if args.report:
        for path in write_report(results):
            print(f"report: {path}")
    if args.kit:
        for path in runtime_kit():
            print(f"runtime kit: {path}")
    return 0 if good == len(results) else 1


def cmd_bind_narrative(args) -> int:
    """Check (and fix) cutscenes that send the player back into a rebuilt dungeon."""
    from .narrative_binding import rebind, scan
    report = scan()
    print(f"{len(report.references)} EnterDungeon references to Builder-owned dungeons")
    for reference in report.references:
        flag = "OK " if reference.valid else "BAD"
        print(f"  [{flag}] {reference.dungeon:16s} seg={reference.segment} floor={reference.floor} "
              f"{reference.path}")
    if report.unresolved and (args.apply or args.dry_run):
        report = rebind(report, dry_run=not args.apply)
        for path in report.rewritten:
            print(f"  {'rebound' if args.apply else 'would rebind'} {path}")
    for reference in report.unresolved:
        print(f"  ! unresolved: {reference.path} -> {reference.dungeon} "
              f"seg {reference.segment} ({reference.reason})")
    return 0 if not report.unresolved else 1


def cmd_post_audit(args) -> int:
    """Re-open every generated zone and verify what is really inside."""
    from .postaudit import audit_all_zones, write_report
    audits = audit_all_zones()
    for audit in sorted(audits, key=lambda a: (a.ok, a.chapter, a.dungeon)):
        flag = "OK  " if audit.ok else "FAIL"
        print(f"[{flag}] {audit.dungeon:22s} {audit.floors_written:>3d}/{audit.floors_expected:<3d}F "
              f"seg={audit.segments} profiles={len(audit.profiles)} grids={audit.grid_variants} "
              f"paths={','.join(audit.path_steps) or '-'} end={audit.boss_mode or '-'}")
        if not audit.ok and args.verbose:
            for problem in audit.problems:
                print(f"        {problem}")
    good = sum(1 for a in audits if a.ok)
    print(f"\n{good}/{len(audits)} zones conform")
    if args.report:
        for path in write_report(audits):
            print(f"report: {path}")
    return 0 if good == len(audits) else 1


def cmd_integrate(args) -> int:
    """Restore archived canonical scenes and re-attach their narrative content."""
    from .integration import integrate, refresh_definition
    from .scenes import parse_inventory
    inventory = parse_inventory()
    definitions = []
    if args.dungeon:
        definitions.append(load_definition(find_definition(args.dungeon)))
    else:
        for path in list_definitions():
            try:
                definitions.append(load_definition(path))
            except DefinitionError:
                continue
    total_grounds = total_scripts = 0
    for definition in definitions:
        result = integrate(definition, inventory, dry_run=args.dry_run)
        if not (result.restored_grounds or result.restored_scripts or result.missing):
            continue
        total_grounds += len(result.restored_grounds)
        total_scripts += len(result.restored_scripts)
        verb = "would restore" if args.dry_run else "restored"
        print(f"[{definition.id}] {verb} grounds={result.restored_grounds} "
              f"scripts={result.restored_scripts}")
        for note in result.notes:
            print(f"    {note}")
        for missing in result.missing:
            print(f"    ! no canonical asset found for '{missing}'")
        if not args.dry_run:
            narrative = refresh_definition(definition)
            if narrative:
                print(f"    narrative.transferred={narrative.get('transferred')}")
    print(f"{total_grounds} grounds and {total_scripts} script folders "
          f"{'would be ' if args.dry_run else ''}restored")
    return 0


def cmd_takeover(args) -> int:
    """Audit (and optionally execute) the replacement of a legacy implementation."""
    from .audit import audit_all
    from .takeover import apply_plan, can_apply, scan, write_report
    from .scenes import parse_inventory
    inventory = parse_inventory()
    definitions = []
    if args.dungeon:
        definitions.append(load_definition(find_definition(args.dungeon)))
    else:
        for path in list_definitions():
            try:
                definitions.append(load_definition(path))
            except DefinitionError:
                continue
    scope = {d.id for d in definitions}
    audits, _ = audit_all()
    readiness = {a.dungeon: a.readiness for a in audits}

    plans = []
    for definition in definitions:
        plan = scan(definition, inventory, scope)
        plans.append(plan)
        if args.dungeon or plan.artefacts:
            print(f"[{definition.id}] harvest={len(plan.by_action('HARVEST'))} "
                  f"transfer={len(plan.by_action('TRANSFER'))} "
                  f"replace={len(plan.by_action('REPLACE'))} "
                  f"protect={len(plan.by_action('PROTECT'))}")
        if args.verbose:
            for artefact in plan.artefacts:
                print(f"    {artefact.action:9s} {artefact.path}")
        if args.apply or args.dry_run:
            zone_exists = (ROOT / "Data" / "Zone" / f"{definition.id}.json").exists()
            blockers = can_apply(plan, definition, readiness.get(definition.id, "UNKNOWN"),
                                 zone_exists)
            if blockers:
                print(f"    apply refused: {'; '.join(blockers)}")
                continue
            removed = apply_plan(plan, dry_run=not args.apply)
            verb = "removed" if args.apply else "would remove"
            for path in removed:
                print(f"    {verb} {path}")
    if args.report:
        for path in write_report(plans):
            print(f"report: {path}")
    return 0


def cmd_audit_all(args) -> int:
    """Step 6 gate: load every definition and report PASS/FAIL with exact blockers."""
    from .audit import audit_all, write_report
    audits, global_problems = audit_all(Path(args.folder) if args.folder else None)
    for audit in sorted(audits, key=lambda a: (a.status == "FAIL", a.chapter, a.dungeon)):
        head = f"[{audit.status}] ch{audit.chapter:<3d} {audit.dungeon or audit.file:22s}"
        print(f"{head} {audit.floors:>3d}F seg={audit.segments} dtef={audit.dtef or '-':22s} "
              f"species={audit.species:>3d} end={audit.boss_mode or '-'}")
        if args.verbose:
            for blocker in audit.blockers:
                print(f"        {blocker}")
    passed = sum(1 for a in audits if a.status == "PASS")
    print(f"\n{passed}/{len(audits)} PASS, {len(audits) - passed} FAIL")
    for problem in global_problems:
        print(f"! {problem}")
    if args.report:
        for path in write_report(audits, global_problems):
            print(f"report: {path}")
    return 0


def cmd_ground(args) -> int:
    """Produce the dungeon's fixed Grounds (midpoint, arena) from validated templates."""
    from .ground_pipeline import build_fixed_ground, render_preview, GroundPipelineError
    definition = load_definition(find_definition(args.dungeon))
    midpoint = definition.midpoint or {}
    if args.role == "midpoint":
        template = midpoint.get("template")
        if not template:
            print("this dungeon declares no midpoint template", file=sys.stderr)
            return 2
        ground_id = midpoint.get("ground") or f"{definition.id}_midpoint"
        sheet = args.sheet or midpoint.get("sheet") or ""
        if not sheet:
            print("no target tile sheet: give --sheet or midpoint.sheet", file=sys.stderr)
            return 2
        try:
            build = build_fixed_ground(
                template=template, ground_id=ground_id, target_sheet=sheet,
                name={"en": f"{definition.name.get('en', definition.id)} — Rest Point",
                      "fr": f"{definition.name.get('fr', definition.id)} — Point de Repos"},
                music=definition.music,
                comment=(f"Midpoint fixe de {definition.name.get('en', definition.id)} : structure du "
                         f"template validé '{template}' (checkpoint/soin/sauvegarde/repos), "
                         f"retexturée avec '{sheet}'."),
                dry_run=args.dry_run,
                required_objects=tuple(midpoint.get("required_objects", ())))
        except GroundPipelineError as exc:
            print(f"ground pipeline error: {exc}", file=sys.stderr)
            return 2
        print(f"{'[dry-run] ' if args.dry_run else ''}{ground_id}: "
              f"{build.remapped_tiles} tiles retextured from {build.distinct_tiles} distinct "
              f"source tiles, entities {build.entities}")
        for note in build.notes:
            print(f"  - {note}")
        for problem in build.problems:
            print(f"  ! {problem}")
        if args.preview and build.path and not args.dry_run:
            out = ROOT / ".runtime-cache" / f"{ground_id}.png"
            render_preview(build.path, out)
            print(f"preview: {out}")
        return 0 if build.ok else 1
    print(f"unknown role '{args.role}'", file=sys.stderr)
    return 2


def cmd_verify(args) -> int:
    """Prove profile parity and export conformance (steps 1 and 2 of the pipeline)."""
    from .conformance import check_all_profiles, check_zone_conformance, markdown_report
    parity = check_all_profiles()
    for row in parity.rows:
        print(f"  {row['profile']:12s} -> {row['path_step']:38s} sim={row['simulator']}")
    for issue in parity.issues:
        print(f"  ! {issue.profile}: {issue.detail}")
    print(f"parity: {'OK' if parity.ok else 'FAILED'} ({len(parity.checked)} profiles)")

    conformance = None
    if args.dungeon:
        definition = load_definition(find_definition(args.dungeon))
        export = build_zone(definition, DungeonRng(seed=args.seed))
        conformance = check_zone_conformance(export.zone_json,
                                             exclude=[f"{definition.id}.json"])
        print(f"conformance: {'OK' if conformance.ok else 'FAILED'} "
              f"({conformance.checked_types} distinct $types)")
        for allowed in conformance.allowed_new_types:
            print(f"  + {allowed}")
        for kind in conformance.unknown_types:
            print(f"  ! unknown type {kind}")
        for kind, fields in conformance.unknown_fields:
            print(f"  ! unknown fields on {kind}: {fields}")
    if args.report:
        path = ROOT / "docs" / "dungeon_builder" / "PROFILE_PARITY.md"
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(markdown_report(parity, conformance), encoding="utf-8")
        print(f"report: {path}")
    return 0 if parity.ok and (conformance is None or conformance.ok) else 1


def cmd_prototype(args) -> int:
    if args.seed is not None:
        print("--seed is not accepted by the engine prototype: PMDO supplies fresh runtime seeds",
              file=sys.stderr)
        return 2
    workdir = Path(args.workdir).resolve()
    runner = ROOT / "tools" / "runtime" / "run_engine_prototype.sh"
    completed = subprocess.run([str(runner), str(workdir), str(args.per_profile)], cwd=ROOT)
    if completed.returncode:
        return completed.returncode
    report = workdir / "ENGINE_PROTOTYPE_REPORT.md"
    print(f"engine-native prototype report: {report}")
    if args.report:
        target = ROOT / "docs" / "dungeon_builder" / "ENGINE_PROTOTYPE_NATIVE.md"
        target.write_text(report.read_text(encoding="utf-8"), encoding="utf-8")
        print(f"persisted report: {target}")
    return 0


def cmd_preview(args) -> int:
    definition = load_definition(find_definition(args.dungeon))
    profiles, segment = _profiles_for_floor(definition, args.floor)
    rng = DungeonRng(seed=args.seed, label=f"preview:{definition.id}:{args.floor}")
    report, results = validate_floor(args.floor, profiles, rng, args.count,
                                     Thresholds(), keep_results=True)
    print(f"# preview {definition.id} floor {args.floor} (segment '{segment.name}')")
    print(f"root seed (debug): {rng.seed}")
    for variant, result in zip(report.accepted(), results):
        m = variant.metrics
        print(f"\n--- variant seed={variant.seed} profile={variant.profile} "
              f"rooms={m.rooms} halls={m.halls} branches={m.branches} dead_ends={m.dead_ends} "
              f"loops={m.loops} size={m.width}x{m.height} stairs_dist={m.stair_distance} "
              f"reachable={m.reachable_ratio}")
        if args.ascii:
            print(result.ascii_art())
    print(f"\naccepted={len(report.accepted())}/{args.count} rejected={report.rejected} "
          f"distinct_signatures={report.distinct_signatures} "
          f"max_similarity={report.max_pair_similarity}")
    return 0 if report.ok else 1


def _validate_all_floors(definition: DungeonDefinition, count: int, rng: DungeonRng,
                         thresholds: Optional[Thresholds] = None):
    validations = []
    for floor in range(1, definition.floors + 1):
        segment = definition.segment_for_floor(floor)
        if floor in segment.fixed_floors:
            continue
        profiles, _ = _profiles_for_floor(definition, floor)
        validation, _ = validate_floor(floor, profiles, rng, count, thresholds)
        validations.append(validation)
    return validations


def cmd_validate(args) -> int:
    definition = load_definition(find_definition(args.dungeon))
    rng = DungeonRng(seed=args.seed, label=f"validate:{definition.id}")
    validations = _validate_all_floors(definition, args.count, rng)
    failures = [v for v in validations if not v.ok]
    for validation in validations:
        status = "OK " if validation.ok else "FAIL"
        print(f"[{status}] floor {validation.floor:>2d} profile={validation.profile:12s} "
              f"accepted={len(validation.accepted())} rejected={validation.rejected} "
              f"signatures={validation.distinct_signatures} "
              f"max_sim={validation.max_pair_similarity}")
        for note in validation.notes:
            print(f"        {note}")
    grounds = check_grounds(definition)
    print(f"\nfixed grounds: {'OK' if grounds.ok else 'PROBLEMS'}")
    for note in grounds.notes:
        print(f"  - {note}")
    for problem in grounds.problems:
        print(f"  ! {problem}")
    return 0 if not failures and grounds.ok else 1


def cmd_generate(args) -> int:
    if args.seed is not None and not args.dry_run:
        print("--seed is debug-only and requires --dry-run; production authoring seeds are forbidden",
              file=sys.stderr)
        return 2
    definition_path = find_definition(args.dungeon)
    from .canonical_gate import assert_generation_ready
    try:
        assert_generation_ready(definition_path)
    except ValueError as exc:
        print(str(exc), file=sys.stderr)
        print("Use 'preview' for non-production experiments; production was not modified.",
              file=sys.stderr)
        return 3
    definition = load_definition(definition_path)
    rng = DungeonRng(seed=args.seed, label=f"generate:{definition.id}")
    try:
        export = build_zone(definition, rng, strict_dtef=not args.no_dtef_check)
    except DtefError as exc:
        print(f"DTEF error: {exc}", file=sys.stderr)
        return 2
    grounds = check_grounds(definition)
    validations = _validate_all_floors(definition, args.count, rng)
    failures = [v for v in validations if not v.ok]

    if failures and not args.force:
        print(f"{len(failures)} floors failed validation; nothing written "
              f"(use --force to override)", file=sys.stderr)
        for validation in failures:
            print(f"  floor {validation.floor}: {validation.notes}", file=sys.stderr)
        return 1
    if not grounds.ok and not args.force:
        print("fixed Ground/boss scene problems; nothing written:", file=sys.stderr)
        for problem in grounds.problems:
            print(f"  {problem}", file=sys.stderr)
        return 1

    if args.dry_run:
        print(f"[dry-run] would write {export.zone_path}")
    else:
        path = write_zone(export, update_index=not args.no_index, definition=definition)
        print(f"wrote {path}")

    report = build_report(definition, export, validations, grounds, rng.debug_info())
    if not args.dry_run or args.report:
        for path in write_report(report):
            print(f"report: {path}")
    return 0


def cmd_reconcile_sinister(args) -> int:
    from .reconcile_sinister import reconcile_files
    result = reconcile_files(write=bool(args.apply))
    print(f"Sinister Woods: {result['floors']} procedural floors, "
          f"{len(result['fixed_segments'])} fixed runtime segment(s)")
    print("definition written" if args.apply else "dry-run; definition unchanged")
    return 0


def cmd_stage_sinister_final(args) -> int:
    from .canonical_battle import stage_sinister
    report = stage_sinister(Path(args.workdir))
    print(json.dumps(report, ensure_ascii=False, indent=2))
    return 0


def cmd_extract_red_source(args) -> int:
    from .red_source import write_manifest
    output = Path(args.output) if args.output else (
        ROOT / "docs" / "canonical" / "red" / f"{args.dungeon_id}_rom_manifest.json")
    path = write_manifest(Path(args.source), args.folder, output)
    print(f"manifest: {path}")
    return 0


def cmd_extract_red_all(args) -> int:
    from .red_batch import DEFAULT_OUTPUT, extract_all
    output = Path(args.output_dir) if args.output_dir else DEFAULT_OUTPUT
    report = extract_all(Path(args.source), output, write=bool(args.apply))
    print(json.dumps(report["summary"], ensure_ascii=False, indent=2))
    print(f"output: {output}" if args.apply else "dry-run; no manifests written")
    return 0


def cmd_scope_111(args) -> int:
    from .scope_registry import OUTPUT, build, write
    output = Path(args.output) if args.output else OUTPUT
    if args.apply:
        write(Path(args.pret_source), Path(args.pmdodump_source), output)
        payload = json.loads(output.read_text(encoding="utf-8"))
        print(f"output: {output}")
    else:
        payload = build(Path(args.pret_source), Path(args.pmdodump_source))
        print("dry-run; registry not written")
    print(json.dumps(payload["summary"], ensure_ascii=False, indent=2))
    return 0


def _run_story_batch(args, module) -> int:
    if args.route_dir:
        if not args.apply:
            raise ValueError("--route-dir requires --apply")
        report = module.record_routes(Path(args.route_dir), promote=bool(args.promote))
        promoted = int(report.get("summary", {}).get("promoted", 0))
        action = f"route evidence recorded; {promoted} candidate(s) promoted"
    elif args.runtime_jsonl:
        if not args.apply:
            raise ValueError("--runtime-jsonl requires --apply")
        report = module.record_runtime(Path(args.runtime_jsonl),
                                       Path(args.runtime_report) if args.runtime_report else None)
        action = "native runtime evidence recorded"
    else:
        report = module.build(write=bool(args.apply))
        action = "staged definitions/zones written" if args.apply else "dry-run; staging unchanged"
    print(json.dumps(report["summary"], ensure_ascii=False, indent=2))
    print(action)
    return 0


def cmd_batch_red_story_01(args) -> int:
    from . import red_story_batch
    return _run_story_batch(args, red_story_batch)


def cmd_batch_red_story_02(args) -> int:
    from . import red_story_batch_02
    return _run_story_batch(args, red_story_batch_02)


def cmd_canonical_audit(args) -> int:
    from .canonical_gate import inspect_all, write_report
    results = inspect_all()
    config_ready = sum(result.config_ready for result in results)
    runtime_ready = sum(result.runtime_ready for result in results)
    print(f"canonical config ready: {config_ready}/{len(results)}")
    print(f"canonical runtime ready: {runtime_ready}/{len(results)}")
    for result in results:
        state = "READY" if result.runtime_ready and result.batch_approved else "BLOCKED"
        print(f"[{state:7s}] {result.dungeon:24s} "
              f"config={result.config_state} runtime={result.runtime_state} "
              f"blockers={len(result.blockers)}")
        if args.verbose:
            for blocker in result.blockers:
                print(f"    - {blocker}")
    if args.report:
        print(f"report: {write_report(results)}")
    return 0 if config_ready == len(results) else 1


def cmd_generate_all(args) -> int:
    from .audit import audit_all
    from .canonical_gate import assert_batch_ready
    lo, hi = (int(x) for x in args.chapters.split("-"))
    selected_paths = []
    for path in list_definitions():
        try:
            candidate = load_definition(path)
        except DefinitionError:
            selected_paths.append(path)
            continue
        if lo <= candidate.chapter <= hi:
            selected_paths.append(path)
    try:
        assert_batch_ready(selected_paths)
    except ValueError as exc:
        print(str(exc), file=sys.stderr)
        print("generate-all is fail-closed until canonical provenance and runtime gates pass.",
              file=sys.stderr)
        return 3
    ready = set()
    if not args.include_blocked:
        audits, _ = audit_all()
        ready = {a.dungeon for a in audits if a.readiness == "READY_FOR_GENERATION"}
        print(f"{len(ready)} dungeons are READY_FOR_GENERATION")
    exit_code = 0
    for path in list_definitions():
        try:
            definition = load_definition(path)
        except DefinitionError as exc:
            print(f"skip {path.name}: {exc}")
            continue
        if not (lo <= definition.chapter <= hi):
            continue
        if ready and definition.id not in ready:
            print(f"skip {definition.id}: not READY_FOR_GENERATION")
            continue
        if args.skip_existing and (ROOT / "Data" / "Zone" / f"{definition.id}.json").exists():
            zone_text = (ROOT / "Data" / "Zone" / f"{definition.id}.json").read_text(
                encoding="utf-8-sig")[:4000]
            if "tools/dungeon_builder" in zone_text:
                print(f"skip {definition.id}: already rebuilt by the Builder")
                continue
        print(f"\n=== {definition.id} (chapter {definition.chapter})")
        sub = argparse.Namespace(dungeon=str(path), seed=None, count=args.count,
                                 force=args.force, dry_run=args.dry_run, report=True,
                                 no_index=args.no_index, no_dtef_check=False)
        exit_code |= cmd_generate(sub)
    return exit_code


def cmd_wire_scenes(args) -> int:
    """Câblage narratif : scripts de zone canoniques + Grounds recâblés."""
    from . import wiring

    plan_result = wiring.plan()
    outcome = wiring.apply(plan_result, write=bool(args.apply))
    verb = "écrit" if args.apply else "à écrire"
    print(f"{len(plan_result.dungeons)} donjons câblés")
    print(f"  scripts de zone {verb}      : {len(outcome['zone_scripts'])}")
    print(f"  scripts hérités archivés    : {len(outcome['archived'])}")
    print(f"  scripts de Ground générés   : {len(outcome['ground_scripts'])}")
    print(f"  appels de Ground recâblés   : {len(outcome['ground_fixes'])}")
    print(f"  GroundMaps complétées       : {len(outcome['ground_maps'])}")
    if args.verbose:
        for fix in plan_result.ground_fixes:
            target = "fin de run" if fix.new is None else f"{fix.new[0]} seg {fix.new[1]}"
            print(f"    {fix.path}: {fix.old[0]} seg {fix.old[1]} -> {target}")
    for item in plan_result.unresolved:
        print(f"  NON RÉSOLU: {item}")
    if args.report:
        path = ROOT / "docs" / "dungeon_builder" / "NARRATIVE_WIRING.md"
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(wiring.report(plan_result), encoding="utf-8")
        print(f"rapport: {path.relative_to(ROOT)}")
    if not args.apply:
        print("(simulation : relancer avec --apply pour écrire)")
    return 0 if plan_result.ok else 1


def cmd_verify_exclusivity(args) -> int:
    """Les 51 zones sont-elles les seules implémentations actives du périmètre ?"""
    from . import exclusivity

    if args.quarantine:
        moved = exclusivity.quarantine_legacy_zone_scripts(write=True)
        for item in moved:
            print(f"archivé: {item}")

    result = exclusivity.scan()
    for key, value in result.counts.items():
        print(f"  {key:26} {value}")
    for finding in result.findings:
        if finding.severity == "error" or args.verbose:
            print(f"  [{finding.severity}] {finding.check}: {finding.subject} — {finding.detail}")
    if args.report:
        base = ROOT / "docs" / "dungeon_builder"
        base.mkdir(parents=True, exist_ok=True)
        (base / "EXCLUSIVITY_CH6_32.md").write_text(exclusivity.render(result), encoding="utf-8")
        (base / "EXCLUSIVITY_CH6_32.json").write_text(
            json.dumps(result.to_dict(), ensure_ascii=False, indent=2), encoding="utf-8")
        print(f"rapport: docs/dungeon_builder/EXCLUSIVITY_CH6_32.md")
    if result.errors:
        print(f"ÉCHEC: {len(result.errors)} implémentation(s) concurrente(s) active(s)")
        return 1
    print(f"OK: 51 zones du Builder, aucune ancienne implémentation active "
          f"({len(result.blocked)} point(s) bloqué(s) en attente de décision narrative)")
    return 0


def cmd_canon_scenes(args) -> int:
    """Rejouer les cinématiques canoniques PMD Red sur leurs Grounds."""
    from . import red_scenes, wiring

    plan_result = wiring.plan()
    expected = wiring._expected_targets(plan_result)
    index = {}
    for ground, spec in expected.items():
        if spec["mode"] == "end_run":
            index[ground] = {"kind": "end_run", "target": spec["dungeon"]}
        else:
            zone, segment, _floor = spec["target"]
            index[ground] = {"kind": "enter_zone", "target": zone, "segment": segment}

    outcome = red_scenes.apply(index, write=bool(args.apply))
    ports = outcome["ports"]
    invented = [p for p in ports if p.invented_before]
    print(f"{len(ports)} Grounds canoniques")
    print(f"  scripts {'écrits' if args.apply else 'à écrire'} : {len(outcome['written'])}")
    print(f"  scènes inventées archivées : {len(outcome['archived'])}")
    print(f"  répliques canoniques sans texte importé : {outcome['missing_text_keys']}")
    if args.verbose:
        for port in invented:
            print(f"    inventé -> canon : {port.ground} ({port.scene.upper()}, {port.role})")
    if args.report:
        path = ROOT / "docs" / "dungeon_builder" / "CANON_SCENES.md"
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(red_scenes.report(outcome), encoding="utf-8")
        print(f"rapport: {path.relative_to(ROOT)}")
    if not args.apply:
        print("(simulation : relancer avec --apply pour écrire)")
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="dungeon_builder",
                                     description="Configuration-driven dungeon builder on top of RogueElements")
    sub = parser.add_subparsers(dest="command", required=True)

    sub.add_parser("audit", help="list profiles, DTEF packages and definitions").set_defaults(func=cmd_audit)

    vsrc = sub.add_parser("verify-source",
                          help="validate the zones against the engine C# sources")
    vsrc.add_argument("--sources", nargs="*", default=None)
    vsrc.add_argument("--only-ours", action="store_true",
                      help="restrict to the dungeons this Builder owns")
    vsrc.set_defaults(func=cmd_verify_source)

    pre = sub.add_parser("preflight", help="verify every asset referenced by the zones")
    pre.add_argument("--report", action="store_true")
    pre.add_argument("--verbose", action="store_true")
    pre.add_argument("--kit", action="store_true", help="write the runtime validation script")
    pre.set_defaults(func=cmd_preflight)

    bind = sub.add_parser("bind-narrative",
                          help="verify/repair cutscenes pointing at rebuilt dungeons")
    bind.add_argument("--apply", action="store_true")
    bind.add_argument("--dry-run", action="store_true")
    bind.set_defaults(func=cmd_bind_narrative)

    post = sub.add_parser("post-audit", help="verify every generated zone on disk")
    post.add_argument("--report", action="store_true")
    post.add_argument("--verbose", action="store_true")
    post.set_defaults(func=cmd_post_audit)

    integrate_parser = sub.add_parser("integrate",
                                      help="restore archived canonical scenes + their cutscenes")
    integrate_parser.add_argument("dungeon", nargs="?", default=None)
    integrate_parser.add_argument("--dry-run", action="store_true")
    integrate_parser.set_defaults(func=cmd_integrate)

    takeover = sub.add_parser("takeover",
                              help="audit/replace the legacy implementation of a dungeon")
    takeover.add_argument("dungeon", nargs="?", default=None)
    takeover.add_argument("--report", action="store_true")
    takeover.add_argument("--verbose", action="store_true")
    takeover.add_argument("--dry-run", action="store_true")
    takeover.add_argument("--apply", action="store_true",
                          help="delete the REPLACE artefacts (guarded)")
    takeover.set_defaults(func=cmd_takeover)

    audit_all_parser = sub.add_parser("audit-all",
                                      help="PASS/FAIL audit of every dungeon definition")
    audit_all_parser.add_argument("--folder", default=None)
    audit_all_parser.add_argument("--report", action="store_true")
    audit_all_parser.add_argument("--verbose", action="store_true")
    audit_all_parser.set_defaults(func=cmd_audit_all)

    canonical_audit = sub.add_parser(
        "canonical-audit",
        help="fail-closed ROM/provenance/runtime production gate",
    )
    canonical_audit.add_argument("--report", action="store_true")
    canonical_audit.add_argument("--verbose", action="store_true")
    canonical_audit.set_defaults(func=cmd_canonical_audit)

    red_extract = sub.add_parser(
        "extract-red-source",
        help="extract a provenance-bearing canonical manifest from pret/pmd-red",
    )
    red_extract.add_argument("dungeon_id", help="output identifier, e.g. sinister_woods")
    red_extract.add_argument("--source", required=True, help="pret/pmd-red checkout")
    red_extract.add_argument("--folder", required=True, help="data/dungeon folder, e.g. SinisterWoods")
    red_extract.add_argument("--output", default=None)
    red_extract.set_defaults(func=cmd_extract_red_source)

    red_extract_all = sub.add_parser(
        "extract-red-all",
        help="bulk-extract all 51 PMD Red manifests without generating zones",
    )
    red_extract_all.add_argument("--source", required=True, help="pret/pmd-red checkout")
    red_extract_all.add_argument("--output-dir", default=None)
    red_extract_all.add_argument("--apply", action="store_true")
    red_extract_all.set_defaults(func=cmd_extract_red_all)

    scope_111 = sub.add_parser(
        "scope-111",
        help="build the machine inventory for 64 PMD Red EU + 47 PMDODump",
    )
    scope_111.add_argument("--pret-source", required=True)
    scope_111.add_argument("--pmdodump-source", required=True)
    scope_111.add_argument("--output", default=None)
    scope_111.add_argument("--apply", action="store_true")
    scope_111.set_defaults(func=cmd_scope_111)

    red_story_01 = sub.add_parser(
        "batch-red-story-01",
        help="stage Tiny Woods and Thunderwave Cave from their ROM manifests",
    )
    red_story_01.add_argument("--apply", action="store_true")
    red_story_01.add_argument("--runtime-jsonl", default=None)
    red_story_01.add_argument("--runtime-report", default=None)
    red_story_01.add_argument("--route-dir", default=None)
    red_story_01.add_argument("--promote", action="store_true")
    red_story_01.set_defaults(func=cmd_batch_red_story_01)

    red_story_02 = sub.add_parser(
        "batch-red-story-02",
        help="stage Silent Chasm and Great Canyon from their ROM manifests",
    )
    red_story_02.add_argument("--apply", action="store_true")
    red_story_02.add_argument("--runtime-jsonl", default=None)
    red_story_02.add_argument("--runtime-report", default=None)
    red_story_02.add_argument("--route-dir", default=None)
    red_story_02.add_argument("--promote", action="store_true")
    red_story_02.set_defaults(func=cmd_batch_red_story_02)

    reconcile_sinister = sub.add_parser(
        "reconcile-sinister",
        help="rebuild the Sinister Woods definition from its PMD Red manifest",
    )
    reconcile_sinister.add_argument("--apply", action="store_true")
    reconcile_sinister.set_defaults(func=cmd_reconcile_sinister)

    stage_final = sub.add_parser(
        "stage-sinister-final",
        help="stage a pixel-exact D04P02 battle map outside production",
    )
    stage_final.add_argument("--workdir", default="/tmp/sinister-final-stage")
    stage_final.set_defaults(func=cmd_stage_sinister_final)

    ground = sub.add_parser("ground", help="build a fixed Ground (midpoint/arena) from its template")
    ground.add_argument("dungeon")
    ground.add_argument("--role", default="midpoint", choices=["midpoint"])
    ground.add_argument("--sheet", default=None, help="target tile sheet (Content/Tile/<name>.tile)")
    ground.add_argument("--preview", action="store_true")
    ground.add_argument("--dry-run", action="store_true")
    ground.set_defaults(func=cmd_ground)

    verify = sub.add_parser("verify", help="profile/step parity + exported GenSteps conformance")
    verify.add_argument("dungeon", nargs="?", default=None)
    verify.add_argument("--seed", type=int, default=None)
    verify.add_argument("--report", action="store_true")
    verify.set_defaults(func=cmd_verify)

    proto = sub.add_parser(
        "prototype",
        help="run the isolated prototype inside the real PMDO/RogueElements engine",
    )
    proto.add_argument("--per-profile", type=int, default=16,
                       help="runtime seeds per profile (10-16; total remains 20-50)")
    proto.add_argument("--seed", type=int, default=None,
                       help="forbidden for this proof; PMDO supplies runtime seeds")
    proto.add_argument("--workdir", default="/tmp/dungeon-builder-engine-prototype")
    proto.add_argument("--report", action="store_true",
                       help="also persist the engine report under docs/dungeon_builder")
    proto.set_defaults(func=cmd_prototype)

    preview = sub.add_parser("preview", help="generate variants of one floor without writing anything")
    preview.add_argument("dungeon")
    preview.add_argument("--floor", type=int, required=True)
    preview.add_argument("--count", type=int, default=10)
    preview.add_argument("--seed", type=int, default=None, help="debug only; never used in production")
    preview.add_argument("--ascii", action="store_true", help="print the layouts")
    preview.set_defaults(func=cmd_preview)

    validate = sub.add_parser("validate", help="validate every floor of a dungeon")
    validate.add_argument("dungeon")
    validate.add_argument("--count", type=int, default=10)
    validate.add_argument("--seed", type=int, default=None)
    validate.set_defaults(func=cmd_validate)

    generate = sub.add_parser("generate", help="write Data/Zone/<id>.json for one dungeon")
    generate.add_argument("dungeon")
    generate.add_argument("--count", type=int, default=10)
    generate.add_argument("--seed", type=int, default=None)
    generate.add_argument("--force", action="store_true")
    generate.add_argument("--dry-run", action="store_true")
    generate.add_argument("--report", action="store_true")
    generate.add_argument("--no-index", action="store_true")
    generate.add_argument("--no-dtef-check", action="store_true")
    generate.set_defaults(func=cmd_generate)

    canon = sub.add_parser("canon-scenes",
                           help="rejouer les cinématiques canoniques PMD Red sur leurs Grounds")
    canon.add_argument("--apply", action="store_true")
    canon.add_argument("--report", action="store_true")
    canon.add_argument("--verbose", action="store_true")
    canon.set_defaults(func=cmd_canon_scenes)

    wire = sub.add_parser("wire-scenes",
                          help="câblage narratif canonique (scripts de zone + Grounds)")
    wire.add_argument("--apply", action="store_true", help="écrire les fichiers")
    wire.add_argument("--report", action="store_true")
    wire.add_argument("--verbose", action="store_true")
    wire.set_defaults(func=cmd_wire_scenes)

    excl = sub.add_parser("verify-exclusivity",
                          help="vérifier qu'aucune ancienne implémentation Ch.6-32 n'est active")
    excl.add_argument("--report", action="store_true")
    excl.add_argument("--verbose", action="store_true")
    excl.add_argument("--quarantine", action="store_true",
                      help="archiver les scripts de zone des substituts supprimés")
    excl.set_defaults(func=cmd_verify_exclusivity)

    batch = sub.add_parser("generate-all", help="batch build a chapter range")
    batch.add_argument("--chapters", default="6-32")
    batch.add_argument("--count", type=int, default=10)
    batch.add_argument("--force", action="store_true")
    batch.add_argument("--dry-run", action="store_true")
    batch.add_argument("--no-index", action="store_true")
    batch.add_argument("--include-blocked", action="store_true",
                       help="also try dungeons that are not READY (not recommended)")
    batch.add_argument("--skip-existing", action="store_true",
                       help="skip dungeons already rebuilt by the Builder")
    batch.set_defaults(func=cmd_generate_all)
    return parser


def main(argv: Optional[Sequence[str]] = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    try:
        return args.func(args)
    except (DefinitionError, DtefError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2
