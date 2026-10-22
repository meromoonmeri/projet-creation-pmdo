"""European `pksdir0` Ground archive + map-files table discovery.

The European PMD Red ROM embeds all Ground resources (BPL/BPC/BMA/BPA)
in a `pksdir0` archive. This module locates that archive **by its magic
signature** (no hand-fed offset), parses its name/data pointer rows and
locates the 262-row map-files dependency table by structural search:
each row is seven u32 fields (bpl, bpc, bma, bpa_0..bpa_3) that are
either NULL or ROM pointers to C strings naming archive resources.

The canonical ground id ("stable ground id") of a map-file row is its
BPL resource name lower-cased (e.g. "D01P02" -> "d01p02"), matching the
convention used by dev/tools/audit_pmdred_eu_rom.py and by all promoted
New Era content.

Nothing from the ROM is copied by this module; it returns offsets,
names and per-resource byte ranges only.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import Optional

from converter.rom.rom_file import RomFile


MAGIC = b"pksdir0\x00"
ROM_BASE = 0x08000000


@dataclass(frozen=True)
class ArchiveResource:
    index: int
    name: str
    data_offset: int          # file-relative offset of the resource bytes
    kind: str                 # bpl | bpc | bma | bpa | unknown
    next_offset: Optional[int]  # start of the next resource (bound)


@dataclass
class EuArchive:
    base_offset: int
    count: int
    resources: list[ArchiveResource] = field(default_factory=list)

    def by_name(self) -> dict[str, ArchiveResource]:
        return {r.name: r for r in self.resources}


@dataclass(frozen=True)
class MapFileRow:
    map_file_id: int
    bpl: Optional[str]
    bpc: Optional[str]
    bma: Optional[str]
    bpas: tuple[Optional[str], ...]

    @property
    def stable_ground_id(self) -> Optional[str]:
        return self.bpl.lower() if self.bpl else None


@dataclass
class MapFilesTable:
    offset: int
    rows: list[MapFileRow] = field(default_factory=list)


def _read_cstr(rom: RomFile, ptr: int, max_len: int = 32) -> Optional[str]:
    if not RomFile.looks_like_rom_pointer(ptr):
        return None
    try:
        off = rom.pointer_to_offset(ptr)
    except Exception:
        return None
    raw = rom.read(off, min(max_len, rom.size - off))
    end = raw.find(b"\x00")
    if end <= 0:
        return None
    try:
        text = raw[:end].decode("ascii")
    except UnicodeDecodeError:
        return None
    if not all(c.isalnum() or c == "_" for c in text):
        return None
    return text


def _classify(name: str, bma_names: set[str], bpc_names: set[str],
              bpl_names: set[str]) -> str:
    if name in bma_names:
        return "bma"
    if name in bpc_names:
        return "bpc"
    if name in bpl_names:
        return "bpl"
    return "bpa"


def find_archive(rom: RomFile) -> Optional[EuArchive]:
    """Locate and parse the pksdir0 Ground archive.

    Scan for the double-magic signature: `pksdir0\\0` at base and again
    at base+16 (the embedded file table header). Returns None when no
    plausible archive exists (non-EU ROM).
    """
    data = rom.read(0, rom.size)

    def try_parse(base: int) -> Optional[list[tuple[str, int]]]:
        count = int.from_bytes(data[base + 8: base + 12], "little")
        table_ptr = int.from_bytes(data[base + 12: base + 16], "little")
        if count <= 0 or count > 4096:
            return None
        try:
            table_off = rom.pointer_to_offset(table_ptr)
        except Exception:
            return None
        rows: list[tuple[str, int]] = []
        for i in range(count):
            name_ptr = int.from_bytes(
                data[table_off + i * 8: table_off + i * 8 + 4], "little")
            data_ptr = int.from_bytes(
                data[table_off + i * 8 + 4: table_off + i * 8 + 8], "little")
            name = _read_cstr(rom, name_ptr)
            if name is None or not RomFile.looks_like_rom_pointer(data_ptr):
                return None
            rows.append((name, rom.pointer_to_offset(data_ptr)))
        return rows

    def looks_like_ground_archive(rows: list[tuple[str, int]]) -> bool:
        """The Ground archive is the only pksdir0 whose names include both
        `...m` (BMA) and `...c` (BPC) suffixed variants of the same stem."""
        names = {n for n, _ in rows}
        stems_m = {n[:-1] for n in names if n.endswith("m")}
        stems_c = {n[:-1] for n in names if n.endswith("c")}
        both = stems_m & stems_c & names
        return len(both) >= 32

    pos = 0
    base = None
    entries: Optional[list[tuple[str, int]]] = None
    while True:
        pos = data.find(MAGIC, pos)
        if pos == -1:
            return None
        if data[pos + 16: pos + 24] == MAGIC:
            cand = try_parse(pos)
            if cand is not None and len(cand) >= 64 \
                    and looks_like_ground_archive(cand):
                base = pos
                entries = cand
                break
        pos += 1

    count = len(entries)

    # Resource kind by name suffix convention (m=BMA, c=BPC, digits=BPA
    # slot planes, bare=BPL). We keep it structural: the BMA/BPC decoders
    # downstream verify the payloads anyway.
    ordered = sorted(range(count), key=lambda i: entries[i][1])
    next_of: dict[int, Optional[int]] = {}
    for j, i in enumerate(ordered):
        next_of[i] = entries[ordered[j + 1]][1] if j + 1 < count else None

    resources = []
    for i, (name, off) in enumerate(entries):
        if name.endswith("m"):
            kind = "bma"
        elif name.endswith("c"):
            kind = "bpc"
        elif name[-1].isdigit() and not name[-2].isdigit() and len(name) > 6:
            kind = "bpa"
        else:
            kind = "bpl"
        resources.append(ArchiveResource(
            index=i, name=name, data_offset=off, kind=kind,
            next_offset=next_of[i],
        ))
    return EuArchive(base_offset=base, count=count, resources=resources)


def find_map_files_table(rom: RomFile, archive: EuArchive) -> Optional[MapFilesTable]:
    """Locate the 7-pointer-per-row map-files dependency table.

    Structural search: find the longest run of 28-byte rows where every
    field is NULL or a ROM pointer to a C string that names an archive
    resource, and where the first three fields (bpl/bpc/bma) are all
    non-NULL and correctly typed.
    """
    names = {r.name for r in archive.resources}
    data = rom.read(0, rom.size)

    def row_at(off: int) -> Optional[MapFileRow]:
        vals = [int.from_bytes(data[off + k * 4: off + k * 4 + 4], "little")
                for k in range(7)]
        fields: list[Optional[str]] = []
        for v in vals:
            if v == 0:
                fields.append(None)
                continue
            s = _read_cstr(rom, v)
            if s is None or s not in names:
                return None
            fields.append(s)
        if fields[0] is None or fields[1] is None or fields[2] is None:
            return None
        if not fields[2].endswith("m") or not fields[1].endswith("c"):
            return None
        return MapFileRow(
            map_file_id=-1, bpl=fields[0], bpc=fields[1], bma=fields[2],
            bpas=tuple(fields[3:7]),
        )

    best_start = None
    best_rows: list[MapFileRow] = []
    off = 0x200
    end = rom.size - 28
    while off <= end:
        first = row_at(off)
        if first is None:
            off += 4
            continue
        rows = [first]
        cursor = off + 28
        while cursor <= end:
            nxt = row_at(cursor)
            if nxt is None:
                break
            rows.append(nxt)
            cursor += 28
        if len(rows) > len(best_rows):
            best_rows = rows
            best_start = off
        off = cursor + 4

    if best_start is None or len(best_rows) < 64:
        return None
    rows = [
        MapFileRow(map_file_id=i, bpl=r.bpl, bpc=r.bpc, bma=r.bma,
                   bpas=r.bpas)
        for i, r in enumerate(best_rows)
    ]
    return MapFilesTable(offset=best_start, rows=rows)
