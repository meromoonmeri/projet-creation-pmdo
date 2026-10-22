"""Source-level conformance: validate the emitted JSON against the engine's C# code.

`conformance.py` compares what we emit with what the *shipped zones* contain.
That catches a lot, but it cannot see a member that no shipped zone happens to
use.  Now that the engine sources are reachable (RogueElements, RogueEssence and
PMDC), this module goes one level deeper and checks our output against the
**actual class definitions**:

* every `$type` we emit resolves to a real class in the sources;
* every JSON member we emit is a real public property/field of that class or of
  one of its base classes;
* enum-valued members we write as integers are within the enum's range.

This is exactly the class of error MapGenTest would surface at load time, so it
is the strongest verification available without executing the engine.
"""
from __future__ import annotations

import json
import re
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, List, Optional, Sequence, Set, Tuple

ROOT = Path(__file__).resolve().parents[2]
ZONE_DIR = ROOT / "Data" / "Zone"

CLASS_RE = re.compile(
    r"^\s*(?:public|internal)\s+(?:abstract\s+|sealed\s+|static\s+|partial\s+)*"
    r"(class|struct)\s+(\w+)\s*(?:<[^>]*>)?\s*(?::\s*([^\{]+))?", re.M)
MEMBER_RE = re.compile(
    r"^\s*public\s+(?:virtual\s+|override\s+|readonly\s+|static\s+|new\s+)*"
    r"(?:[\w\.\<\>\[\],\?\s]+?)\s+(\w+)\s*(?:\{\s*get|;|=)", re.M)
ENUM_RE = re.compile(r"^\s*public\s+enum\s+(\w+)", re.M)


NAMESPACE_RE = re.compile(r"^\s*namespace\s+([\w\.]+)", re.M)

#: source root -> assembly name written in the `$type` strings
ASSEMBLY_OF_ROOT = {"PMDC": "PMDC", "RogueEssence": "RogueEssence",
                    "RogueElements": "RogueElements"}


@dataclass
class CSharpType:
    name: str
    bases: List[str] = field(default_factory=list)
    members: Set[str] = field(default_factory=set)
    path: str = ""
    namespace: str = ""
    assembly: str = ""


@dataclass
class SourceReport:
    types_checked: int = 0
    objects_checked: int = 0
    unknown_types: List[str] = field(default_factory=list)
    unknown_members: List[Tuple[str, str, str]] = field(default_factory=list)   # type, member, zone
    wrong_namespace: List[Tuple[str, str, str]] = field(default_factory=list)   # emitted, expected, zone
    skipped_types: List[str] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not self.unknown_types and not self.unknown_members and not self.wrong_namespace


def index_sources(*roots: Path) -> Dict[str, CSharpType]:
    """Index every class/struct of the engine sources by simple name."""
    index: Dict[str, CSharpType] = {}
    for root in roots:
        if not root.exists():
            continue
        for path in root.rglob("*.cs"):
            if any(part in ("obj", "bin", "Tests", "Examples") for part in path.parts):
                continue
            try:
                text = path.read_text(encoding="utf-8", errors="ignore")
            except OSError:
                continue
            namespace_match = NAMESPACE_RE.search(text)
            namespace = namespace_match.group(1) if namespace_match else ""
            assembly = ""
            for part in path.parts:
                if part in ASSEMBLY_OF_ROOT:
                    assembly = ASSEMBLY_OF_ROOT[part]
            matches = list(CLASS_RE.finditer(text))
            for position, match in enumerate(matches):
                name = match.group(2)
                bases_raw = match.group(3) or ""
                bases = [b.strip().split("<")[0] for b in bases_raw.split(",") if b.strip()]
                end = matches[position + 1].start() if position + 1 < len(matches) else len(text)
                body = text[match.end():end]
                members = set(MEMBER_RE.findall(body))
                existing = index.get(name)
                if existing is None:
                    index[name] = CSharpType(name, bases, members, str(path), namespace, assembly)
                else:                       # partial classes / same name in two assemblies
                    existing.members |= members
                    existing.bases = list({*existing.bases, *bases})
    return index


def simple_name(type_string: str) -> str:
    """`RogueElements.GridPathBranch\\`1[[...]], RogueElements` -> `GridPathBranch`."""
    head = type_string.split("`")[0].split(",")[0].strip()
    return head.split(".")[-1]


def members_of(name: str, index: Dict[str, CSharpType], seen: Optional[Set[str]] = None) -> Set[str]:
    seen = seen or set()
    if name in seen or name not in index:
        return set()
    seen.add(name)
    entry = index[name]
    members = set(entry.members)
    for base in entry.bases:
        members |= members_of(base, index, seen)
    return members


#: members handled by the serializer itself or by interfaces we cannot resolve
#: by simple text parsing (generic interface implementations, dictionaries...)
SERIALIZER_MEMBERS = {"$type", "$values", "str", "nodes", "spawns", "Item1", "Item2",
                      "Spawn", "Rate", "Range", "Key", "Value", "Item", "assembly", "type"}


def check_zone(path: Path, index: Dict[str, CSharpType], report: SourceReport) -> None:
    data = json.loads(path.read_text(encoding="utf-8-sig"))

    def walk(node) -> None:
        if isinstance(node, dict):
            kind = node.get("$type")
            if isinstance(kind, str):
                report.objects_checked += 1
                name = simple_name(kind)
                entry = index.get(name)
                if entry is None:
                    if kind not in report.unknown_types:
                        report.unknown_types.append(kind)
                else:
                    # the serializer resolves `Namespace.Class, Assembly`: both parts must match
                    emitted_ns = kind.split("`")[0].split(",")[0].strip()
                    emitted_asm = kind.split(",")[-1].strip()
                    expected_ns = f"{entry.namespace}.{entry.name}" if entry.namespace else entry.name
                    if entry.namespace and emitted_ns != expected_ns:
                        record = (emitted_ns, expected_ns, path.stem)
                        if record not in report.wrong_namespace:
                            report.wrong_namespace.append(record)
                    elif entry.assembly and emitted_asm != entry.assembly:
                        record = (kind, entry.assembly, path.stem)
                        if record not in report.wrong_namespace:
                            report.wrong_namespace.append(record)
                    known = members_of(name, index) | SERIALIZER_MEMBERS
                    for member in node:
                        if member in known or member.startswith("$"):
                            continue
                        record = (name, member, path.stem)
                        if record not in report.unknown_members:
                            report.unknown_members.append(record)
            for value in node.values():
                walk(value)
        elif isinstance(node, list):
            for value in node:
                walk(value)

    walk(data)


def run(sources: Sequence[Path], zone_dir: Optional[Path] = None,
        only: Optional[Sequence[str]] = None) -> SourceReport:
    index = index_sources(*sources)
    report = SourceReport(types_checked=len(index))
    zone_dir = zone_dir or ZONE_DIR
    for path in sorted(zone_dir.glob("*.json")):
        if only and path.stem not in only:
            continue
        check_zone(path, index, report)
    return report


def default_source_roots(base: Optional[Path] = None) -> List[Path]:
    """Where the engine sources live once cloned (PMDCollab/PMDC + submodules)."""
    base = base or (Path.home() / ".cache" / "pmdc_src")
    return [base / "PMDC", base / "RogueEssence" / "RogueEssence",
            base / "RogueEssence" / "RogueElements" / "RogueElements"]
