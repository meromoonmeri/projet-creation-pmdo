import io
import json
import threading
import unittest
from unittest.mock import patch
import urllib.parse
import zipfile
import struct
import zlib

from source.serveur_apercus.serve import (
    Blob,
    CREATION_UPSTREAM_COMMIT,
    CREATION_UPSTREAM_NAME,
    CREATION_UPSTREAM,
    CREATION_UPSTREAM_CACHE,
    LoadedArchive,
    _layered_archive_page,
    _patch_palkia_static_composite,
    _preview_url,
    _resolve_template,
    _selector_from_manifest,
    build_archive_plan,
    ROOT,
    UPSTREAM,
    UPSTREAM_CACHE,
    UPSTREAM_NAME,
    UPSTREAM_COMMIT,
    UpstreamError,
    UpstreamRepository,
    build_catalog,
    build_layer_plan,
    match_preview,
    safe_member_name,
    _compose_png_rgba,
    _decode_rgba_png,
    _png_chunk,
    _PNG_SIGNATURE,
)


def empty_repository():
    repo = object.__new__(UpstreamRepository)
    repo.cache_dir = UPSTREAM_CACHE
    repo.source_specs = {
        UPSTREAM_NAME: {
            "key": "pmdo", "short": "projet-pmdo", "url": UPSTREAM,
            "base_commit": UPSTREAM_COMMIT, "cache_dir": UPSTREAM_CACHE,
            "catalog": "branch_catalog.json",
        },
        CREATION_UPSTREAM_NAME: {
            "key": "creation", "short": "projet-creation-pmdo", "url": CREATION_UPSTREAM,
            "base_commit": CREATION_UPSTREAM_COMMIT, "cache_dir": CREATION_UPSTREAM_CACHE,
            "catalog": "branch_catalog_creation.json",
        },
    }
    repo.source_names = {spec["key"]: name for name, spec in repo.source_specs.items()}
    repo._source_cache_dirs = {UPSTREAM_NAME: UPSTREAM_CACHE}
    repo._git_lock = threading.RLock()
    repo.files = {}
    repo.file_variants = {}
    repo.previews = []
    repo._preview_keys = set()
    repo.archives = []
    repo._archive_keys = set()
    repo.archive_by_id = {}
    repo.archive_id_by_path = {}
    repo.archive_id_by_source_path = {}
    repo.archive_preview = {}
    repo.related_layer_archive = {}
    repo.branch_sources = []
    repo.branch_head_counts = {}
    repo._known_commits = {
        UPSTREAM_NAME: {UPSTREAM_COMMIT},
        CREATION_UPSTREAM_NAME: {CREATION_UPSTREAM_COMMIT},
    }
    repo._commit_info = {
        (UPSTREAM_NAME, UPSTREAM_COMMIT): ("main", ""),
        (CREATION_UPSTREAM_NAME, CREATION_UPSTREAM_COMMIT): ("main", ""),
    }
    repo._fetched_commits = set()
    repo._dynamic_blob_cache = {}
    repo._virtual_archive_cache = {}
    repo._virtual_composite_cache = {}
    repo.commit = UPSTREAM_COMMIT
    return repo


class PreviewHelpersTest(unittest.TestCase):
    def test_recent_branch_catalog_is_pinned_and_contains_branch_only_maps(self):
        catalog_path = ROOT / "source" / "serveur_apercus" / "branch_catalog.json"
        catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
        self.assertEqual(catalog["baseCommit"], UPSTREAM_COMMIT)
        self.assertGreaterEqual(len(catalog["branches"]), 10)
        previews = {item["path"] for branch in catalog["branches"] for item in branch["previews"]}
        previews.update(item["path"] for branch in catalog["branches"] for item in branch.get("extraPreviews", []))
        archives = {item["path"] for branch in catalog["branches"] for item in branch["archives"]}
        self.assertIn("apercu_entree_ile_zenith_v1.html", previews)
        self.assertIn("apercu_entree_foret_brumeuse_sud_nord_v1.html", previews)
        self.assertIn("renders/zone_guilde_treehouse_v3/index.html", previews)
        self.assertIn("renders/zone_guilde_treehouse_v4/index.html", previews)
        self.assertIn("livrable_entree_ile_zenith_v1.zip", archives)
        assets = {item["path"] for branch in catalog["branches"] for item in branch["assets"]}
        self.assertIn("renders/entree_ile_zenith_v1/EIZ1_walkability.png", assets)
        self.assertIn("renders/entree_ile_zenith_v1/anim/EIZ1_12_runes_portail_f00.png", assets)
        self.assertIn("renders/zone_guilde_treehouse_v3/ZGT3_concept_imagegen.png", assets)
        self.assertIn("renders/zone_guilde_treehouse_v4/ZGT4_village_768x576_palette_T00P01.png", assets)
        self.assertEqual(len(previews), 54)
        self.assertEqual(len(archives), 99)
        self.assertEqual(len(assets), 743)

    def test_branch_catalog_fallback_when_main_tree_index_is_unavailable(self):
        with (
            patch.object(UpstreamRepository, "_open_partial_clone"),
            patch.object(UpstreamRepository, "_load_index", side_effect=UpstreamError("GitHub HTTP 500")),
        ):
            repo = UpstreamRepository()

        catalog = build_catalog(repo)
        preview_paths = {item["path"] for item in catalog["previews"]}
        self.assertTrue(catalog["source"]["available"])
        self.assertTrue(catalog["source"]["indexFallback"])
        self.assertTrue(repo.index_errors)
        self.assertGreater(catalog["counts"]["branchPreviews"], 0)
        self.assertGreater(catalog["counts"]["branchArchives"], 0)
        self.assertIn("apercu_vallons_fleuris_v1.html", preview_paths)

    def test_branch_catalog_registers_referenced_assets_from_their_source_commit(self):
        catalog = json.loads((ROOT / "source" / "serveur_apercus" / "branch_catalog.json").read_text(encoding="utf-8"))
        branch = next(item for item in catalog["branches"] if item["ref"].startswith("arena/01a108a6"))
        expected = next(item for item in branch["assets"] if item["path"] == "renders/entree_ile_zenith_v1/EIZ1_walkability.png")
        page_branch = next(item for item in catalog["branches"] if item["ref"].startswith("arena/01a106dc"))
        expected_page = next(item for item in page_branch["extraPreviews"] if item["path"] == "renders/zone_guilde_treehouse_v3/index.html")

        repo = empty_repository()
        repo._load_branch_catalog()

        blob = repo.resolve_blob(expected["path"], (UPSTREAM_NAME, branch["commit"]))
        self.assertIsNotNone(blob)
        self.assertEqual(blob.sha, expected["sha"])
        self.assertEqual(blob.commit, branch["commit"])
        self.assertEqual(blob.source_ref, branch["ref"])
        page = repo.resolve_blob(expected_page["path"], (UPSTREAM_NAME, page_branch["commit"]))
        self.assertIsNotNone(page)
        self.assertEqual(page.sha, expected_page["sha"])
        self.assertEqual(page.commit, page_branch["commit"])

    def test_creation_branch_catalog_includes_requested_maps_and_verified_archives(self):
        catalog_path = ROOT / "source" / "serveur_apercus" / "branch_catalog_creation.json"
        catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
        self.assertEqual(catalog["sourceRepo"], CREATION_UPSTREAM_NAME)
        self.assertEqual(catalog["baseCommit"], CREATION_UPSTREAM_COMMIT)
        self.assertEqual(catalog["headCount"], 24)
        self.assertGreaterEqual(len(catalog["branches"]), 10)
        previews = {
            item["path"]
            for branch in catalog["branches"]
            for item in branch["previews"] + branch.get("extraPreviews", [])
        }
        for path in (
            "apercu_vallons_fleuris_v1.html",
            "apercu_entree_tour_temporelle_sud_nord_v2.html",
            "apercu_fin_tour_temporelle_noire_or_v2.html",
            "apercu_tour_temporelle_roche_noire_or_complet.html",
            "apercu_faille_spatiale_palkia_pmdo.html",
        ):
            self.assertIn(path, previews)
        archives = {
            item["path"]
            for branch in catalog["branches"]
            for item in branch.get("archives", [])
        }
        self.assertEqual(sum(path.lower().endswith(".zip") for path in archives), 10)
        self.assertEqual(sum(path.lower().endswith(".ora") for path in archives), 6)
        self.assertIn("renders/entree_crevasse_enneigee_sud_nord_v1/ECE1_calques_png_8px.zip", archives)
        self.assertIn("renders/fin_vallon_fleuri_sanctuaire_v1/FVF1_fin_vallon_fleuri_sanctuaire_v1_calques.ora", archives)
        self.assertIn("renders/entree_tour_temporelle_sud_nord_v2/ETT2_entree_tour_temporelle_v2_calques.ora", archives)
        self.assertIn("renders/fin_tour_temporelle_noire_or_v2/FTN2_fin_tour_temporelle_noire_or_v2_calques.ora", archives)

    def test_same_preview_path_keeps_repo_and_commit_identity(self):
        repo = empty_repository()
        repo._load_branch_catalog()
        path = "apercu_entree_bassin_chauffant_sud_nord_v1.html"
        first = next(blob for blob in repo.file_variants[path] if blob.source_repo == UPSTREAM_NAME)
        second = next(blob for blob in repo.file_variants[path] if blob.source_repo == CREATION_UPSTREAM_NAME)
        self.assertNotEqual(first.sha, second.sha)
        self.assertEqual(repo.resolve_blob(path, (UPSTREAM_NAME, first.commit)), first)
        self.assertEqual(repo.resolve_blob(path, (CREATION_UPSTREAM_NAME, second.commit)), second)
        second_url = _preview_url(second)
        parsed = urllib.parse.urlsplit(second_url)
        context = repo.source_context(parsed.query)
        self.assertEqual(context, (CREATION_UPSTREAM_NAME, second.commit))

    def test_nested_branch_preview_has_a_map_title_and_category(self):
        class FakeRepository:
            previews = [Blob("renders/zone_guilde_treehouse_v3/index.html", "b" * 40, 100)]
            archives = []
            archive_by_id = {}
            archive_preview = {}
            related_layer_archive = {}
            branch_sources = []

        item = next(item for item in build_catalog(FakeRepository())["previews"]
                    if item["path"] == "renders/zone_guilde_treehouse_v3/index.html")
        self.assertEqual(item["title"], "ZGT3 — Village arboricole de guilde")
        self.assertEqual(item["category"], "Zones & lieux")
        self.assertEqual(item["url"], "/renders/zone_guilde_treehouse_v3/index.html")

    def test_treehouse_v4_gallery_title_avoids_source_style_alias(self):
        class FakeRepository:
            previews = [Blob("renders/zone_guilde_treehouse_v4/index.html", "e" * 40, 100)]
            archives = []
            archive_by_id = {}
            archive_preview = {}
            related_layer_archive = {}
            branch_sources = []

        item = next(x for x in build_catalog(FakeRepository())["previews"]
                    if x["path"] == "renders/zone_guilde_treehouse_v4/index.html")
        self.assertEqual(item["title"], "Village arboricole — aperçu généré 8 px")
        self.assertNotIn("Halcyon", item["title"])

    def test_gallery_items_do_not_emit_unverified_alias_metadata(self):
        class FakeRepository:
            previews = [Blob("apercu_vallons_fleuris_v1.html", "a" * 40, 100)]
            archives = []
            archive_by_id = {}
            archive_preview = {}
            related_layer_archive = {}
            branch_sources = []

        item = next(x for x in build_catalog(FakeRepository())["previews"]
                    if x["path"] == "apercu_vallons_fleuris_v1.html")
        self.assertNotIn("aliases", item)
        self.assertNotIn("aliasLabel", item)

    def test_ora_fallback_maps_only_the_missing_requested_frames(self):
        repo = object.__new__(UpstreamRepository)
        def fake_resolve(path, context=None):
            return Blob(path, "c" * 40, 1200, commit=context[1] if context else CREATION_UPSTREAM_COMMIT,
                        source_ref="arena/75cecc86", source_repo=CREATION_UPSTREAM_NAME)
        repo.resolve_blob = fake_resolve
        context = (CREATION_UPSTREAM_NAME, "d" * 40)
        self.assertEqual(
            repo._ora_fallback_for_path(
                "renders/fin_vallon_fleuri_sanctuaire_v1/layers/00_sol_complet.png", context
            )[1],
            "data/layer_00.png",
        )
        self.assertEqual(
            repo._ora_fallback_for_path(
                "renders/entree_vallon_fleuri_sud_nord_v1/animation/eau_metano_native/EVF1_eau_metano_phase_4.png", context
            )[1],
            "data/layer_02.png",
        )
        self.assertEqual(
            repo._ora_fallback_for_path(
                "renders/entree_tour_temporelle_sud_nord_v2/animation/nuages/ETT2_01_nuages_f23.png", context
            )[1],
            "data/layer01.png",
        )
        self.assertEqual(
            repo._ora_fallback_for_path(
                "renders/fin_tour_temporelle_noire_or_v2/animation/nuages_orage_rouges/FTN2_00_nuages_orage_rouges_f09.png", context
            )[1],
            "data/01_nuages_orage_rouges.png",
        )
        self.assertEqual(
            repo._ora_fallback_for_path(
                "renders/fin_tour_temporelle_noire_or_v2/FTN2_nuages_orage_rouges_10frames.webp", context
            )[1],
            "data/01_nuages_orage_rouges.png",
        )
        self.assertEqual(
            repo._ora_fallback_for_path(
                "renders/fin_tour_temporelle_noire_or_v2/FTN2_trou_noir_seul_10frames.webp", context
            )[1],
            "data/02_trou_noir_spirale.png",
        )
        composite = repo._ora_composite_fallback_for_path(
            "renders/fin_tour_temporelle_noire_or_v2/FTN2_trou_noir_spirale_10frames.webp", context
        )
        self.assertIsNotNone(composite)
        self.assertEqual(composite[1], ("data/01_nuages_orage_rouges.png", "data/02_trou_noir_spirale.png"))
        self.assertIsNone(repo._ora_fallback_for_path(
            "renders/entree_tour_temporelle_sud_nord_v2/animation/nuages/ETT2_01_nuages_f23.png",
            (UPSTREAM_NAME, UPSTREAM_COMMIT),
        ))

    def test_png_layer_composition_keeps_alpha_and_color(self):
        def rgba_png(pixel):
            header = struct.pack(">IIBBBBB", 1, 1, 8, 6, 0, 0, 0)
            return (
                _PNG_SIGNATURE
                + _png_chunk(b"IHDR", header)
                + _png_chunk(b"IDAT", zlib.compress(b"\x00" + bytes(pixel)))
                + _png_chunk(b"IEND", b"")
            )

        composite = _compose_png_rgba(rgba_png((0, 0, 255, 255)), rgba_png((255, 0, 0, 128)))
        _, _, pixels = _decode_rgba_png(composite)
        self.assertEqual(tuple(pixels), (128, 0, 127, 255))

    def test_palkia_viewer_uses_a_composite_when_every_layer_is_missing(self):
        original = """if (pose0Preview) {
        ctx.drawImage(pose0Preview, 0, 0, m.width, m.height);
      }
      statusEl.textContent = `✓ ${m.layers.length} / ${m.layers.length} calques temps réel prêts (échelle 1:1)`;
      if (showCollisions && m.walk_grid) {"""
        patched = _patch_palkia_static_composite(original)
        self.assertIn("m._pose0Preview = pose0Preview", patched)
        self.assertIn("!m.layers.some", patched)
        self.assertIn("Composite pose 0 affiché", patched)

    def test_archive_name_matches_same_project_preview(self):
        slugs = {"entree_jungle_sud_nord_v1": "apercu_entree_jungle_sud_nord_v1.html"}
        found, score = match_preview(
            "renders/entree_jungle_sud_nord_v1/EJN1_calques_png_8px.zip",
            slugs,
            list(slugs),
        )
        self.assertEqual(found, "apercu_entree_jungle_sud_nord_v1.html")
        self.assertEqual(score, 1.0)

    def test_archive_member_paths_are_confined(self):
        self.assertEqual(safe_member_name("calques/sol.png"), "calques/sol.png")
        self.assertEqual(safe_member_name("./calques/sol.png"), "calques/sol.png")
        self.assertIsNone(safe_member_name("../secrets.txt"))
        self.assertIsNone(safe_member_name("calques/../../secrets.txt"))
        self.assertIsNone(safe_member_name("/absolute/path.png"))

    def test_frame_placeholders_support_x_and_n(self):
        names = [
            "animation/eau/eau_f0.png",
            "animation/eau/eau_f1.png",
            "animation/eau/eau_f2.png",
            "animation/cascade/cascade_f00.png",
            "animation/cascade/cascade_f01.png",
            "animation/cascade/cascade_f02.png",
        ]
        self.assertEqual(
            _resolve_template("animation/eau/eau_fX.png", names),
            names[:3],
        )
        self.assertEqual(
            _resolve_template("animation/cascade/cascade_fNN.png", names),
            names[3:],
        )

    def test_manifest_reconstructs_ordered_and_timed_layers(self):
        manifest = {
            "size_px": [16, 16],
            "scene_loop_ticks": 120,
            "layer_order_bottom_to_top": [
                "animation/eau/eau_fX.png",
                "calques/sol.png",
            ],
            "water": {"phases": 3, "frame_length_ticks": 6},
        }
        payload = io.BytesIO()
        with zipfile.ZipFile(payload, "w") as zf:
            zf.writestr("manifest.json", json.dumps(manifest))
            zf.writestr("animation/eau/eau_f0.png", b"not-a-decoded-image")
            zf.writestr("animation/eau/eau_f1.png", b"not-a-decoded-image")
            zf.writestr("animation/eau/eau_f2.png", b"not-a-decoded-image")
            zf.writestr("calques/sol.png", b"not-a-decoded-image")

        archive = LoadedArchive(Blob("fixture.zip", "a" * 40, payload.tell()), payload.getvalue())
        plan = build_layer_plan(archive, manifest)
        self.assertIsNotNone(plan)
        self.assertEqual((plan["width"], plan["height"]), (16, 16))
        self.assertEqual(len(plan["layers"]), 2)
        self.assertEqual(plan["layers"][0]["files"], [
            "animation/eau/eau_f0.png",
            "animation/eau/eau_f1.png",
            "animation/eau/eau_f2.png",
        ])
        self.assertEqual(plan["layers"][0]["timing"], "6 ticks/phase")
        self.assertEqual(plan["layers"][1]["files"], ["calques/sol.png"])
        archive.zip.close()

    def test_layer_records_support_fnn_and_per_layer_timing(self):
        manifest = {
            "size_px": [24, 24],
            "layers": [
                {"file": "animation/cascade/eau_fNN.png", "phases": 3, "ticks": 4},
                {"file": "calques/sol.png", "phases": 1, "ticks": 60},
            ],
        }
        payload = io.BytesIO()
        with zipfile.ZipFile(payload, "w") as zf:
            zf.writestr("animation/cascade/eau_f00.png", b"frame")
            zf.writestr("animation/cascade/eau_f01.png", b"frame")
            zf.writestr("animation/cascade/eau_f02.png", b"frame")
            zf.writestr("calques/sol.png", b"static")
        archive = LoadedArchive(Blob("fixture.zip", "b" * 40, payload.tell()), payload.getvalue())
        plan = build_layer_plan(archive, manifest)
        self.assertIsNotNone(plan)
        self.assertEqual(len(plan["layers"][0]["files"]), 3)
        self.assertEqual(plan["layers"][0]["timing"], "4 ticks/phase")
        archive.zip.close()

    def test_cross_animation_selector_preserves_two_independent_tick_cycles(self):
        selector = _selector_from_manifest({
            "selection": "frames[((tick//7)%14)*32 + ((tick//8)%32)]",
            "period_ticks": 12544,
        }, 448)
        self.assertEqual(selector["mode"], "cross")
        self.assertEqual(selector["outerTicks"], 7)
        self.assertEqual(selector["innerTicks"], 8)
        self.assertEqual(selector["periodTicks"], 12544)

    def test_manifest_map_package_composes_matching_animation_and_keeps_reference_separate(self):
        manifest = {
            "maps": [
                {"id": "foret_entree", "size": [2, 2], "layers": ["maps/foret.png"]},
                {"id": "plaines_entree", "size": [2, 2], "layers": ["maps/plaines.png"]},
            ],
            "animations": {
                "foret": {
                    "frames": ["animations/foret/f00.png", "animations/foret/f01.png"],
                    "size": [2, 2],
                    "frame_ticks": 6,
                    "period_ticks": 12,
                    "selection": "frames[(tick//6)%2]",
                    "blend": "add RGB555 16/16",
                },
                "reference_desert": {
                    "frames": ["animations/reference/f00.png", "animations/reference/f01.png"],
                    "size": [2, 2],
                    "frame_ticks": 4,
                    "placed": False,
                },
            },
        }
        payload = io.BytesIO()
        with zipfile.ZipFile(payload, "w") as zf:
            for name in (
                "maps/foret.png", "maps/plaines.png",
                "animations/foret/f00.png", "animations/foret/f01.png",
                "animations/reference/f00.png", "animations/reference/f01.png",
            ):
                zf.writestr(name, b"png-fixture")
        archive = LoadedArchive(Blob("maps.zip", "c" * 40, payload.tell()), payload.getvalue())
        plan = build_archive_plan(archive, manifest)
        self.assertEqual([scene["id"] for scene in plan["scenes"]], ["foret_entree", "plaines_entree"])
        self.assertEqual(len(plan["scenes"][0]["layers"]), 2)
        self.assertEqual(plan["scenes"][0]["layers"][1]["blend"], "lighter")
        self.assertEqual(plan["scenes"][0]["layers"][1]["selector"]["mode"], "cycle")
        self.assertEqual(len(plan["scenes"][1]["layers"]), 1)
        self.assertEqual(plan["extraAnimations"][0]["placed"], False)
        page = _layered_archive_page("fixture-id", archive, plan, "manifest.json").decode("utf-8")
        self.assertIn('id="static-fallback"', page)
        self.assertIn('/archive-content/fixture-id/maps/foret.png', page)
        self.assertIn('id="load-status"', page)
        archive.zip.close()

    def test_d22_manifest_layers_and_night_light_are_resolved_in_order(self):
        manifest = {
            "maps": [{
                "id": "plaines_nuit",
                "asset": "d22_plaines_nuit",
                "size": [2, 2],
                "layers": [
                    {"title": "Ciel", "frames": 2, "ticks": 4},
                    {"title": "Sol", "frames": 1, "ticks": 60},
                ],
                "light": {"frames": 2, "ticks": 12},
            }],
        }
        prefix = "PNG/d22_plaines_nuit/d22_plaines_nuit"
        members = [
            f"{prefix}_00_000.png", f"{prefix}_00_001.png",
            f"{prefix}_01_000.png",
            f"{prefix}_lumiere_000.png", f"{prefix}_lumiere_001.png",
        ]
        payload = io.BytesIO()
        with zipfile.ZipFile(payload, "w") as zf:
            for name in members:
                zf.writestr(name, b"png-fixture")
        archive = LoadedArchive(Blob("plaines.zip", "d" * 40, payload.tell()), payload.getvalue())
        plan = build_archive_plan(archive, manifest)
        layers = plan["scenes"][0]["layers"]
        self.assertEqual([layer["name"] for layer in layers], ["Ciel", "Sol", "Lumière compilée (calque séparé)"])
        self.assertEqual([len(layer["files"]) for layer in layers], [2, 1, 2])
        self.assertEqual(layers[0]["timing"], "4 ticks/phase")
        self.assertEqual(layers[2]["timing"], "12 ticks/phase")
        self.assertEqual(layers[2]["blend"], "lighter")
        archive.zip.close()


if __name__ == "__main__":
    unittest.main()
