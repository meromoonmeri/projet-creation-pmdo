from __future__ import annotations

import re
import sqlite3
import zipfile
from collections import Counter
from pathlib import Path
from typing import Iterator

from .constants import TILE_FIELDS
from .util import atomic_write_json, sha256_file

INSERT_RE = re.compile(r"INSERT INTO `([^`]+)` VALUES ")
STANDARD_ID_RE = re.compile(r"^s\d+$")

TARGET_TABLES = {
    "map_general", "map_data", "map_switchovers", "map_standard_data",
    "map_npcs", "map_tiles", "npc", "item", "story", "story_segment",
    "story_param",
}


def parse_insert_rows(statement: str) -> Iterator[tuple]:
    """Parse one mysqldump INSERT VALUES statement without evaluating SQL.

    This handles MySQL backslash escapes, quoted commas/parentheses, NULL, ints,
    and floats. PMU's dump emits every INSERT on one physical line.
    """
    marker = statement.find(" VALUES ")
    if marker < 0:
        return
    i = marker + 8
    n = len(statement)
    escapes = {"0": "\0", "b": "\b", "n": "\n", "r": "\r", "t": "\t", "Z": "\x1a"}
    while i < n:
        while i < n and statement[i] != "(":
            i += 1
        if i >= n:
            return
        i += 1
        row: list[object] = []
        while i < n:
            while i < n and statement[i].isspace():
                i += 1
            if i >= n:
                raise ValueError("Truncated SQL tuple")
            if statement[i] == "'":
                i += 1
                value: list[str] = []
                while i < n:
                    char = statement[i]
                    if char == "'":
                        i += 1
                        break
                    if char == "\\" and i + 1 < n:
                        i += 1
                        char = statement[i]
                        value.append(escapes.get(char, char))
                        i += 1
                    else:
                        value.append(char)
                        i += 1
                parsed: object = "".join(value)
            else:
                start = i
                while i < n and statement[i] not in ",)":
                    i += 1
                token = statement[start:i].strip()
                if token.upper() == "NULL":
                    parsed = None
                elif any(char in token for char in ".eE"):
                    parsed = float(token)
                else:
                    parsed = int(token)
            row.append(parsed)
            while i < n and statement[i].isspace():
                i += 1
            if i >= n:
                raise ValueError("Truncated SQL tuple after value")
            if statement[i] == ",":
                i += 1
                continue
            if statement[i] == ")":
                i += 1
                yield tuple(row)
                break
            raise ValueError(f"Unexpected SQL character at {i}: {statement[i:i + 40]!r}")


SCHEMA = """
PRAGMA journal_mode=WAL;
PRAGMA synchronous=OFF;
PRAGMA temp_store=MEMORY;
CREATE TABLE maps (
 map_id TEXT PRIMARY KEY, version INTEGER, revision INTEGER, max_x INTEGER, max_y INTEGER,
 name TEXT, moral INTEGER, music TEXT, indoors TEXT, weather INTEGER, darkness INTEGER,
 hunger_enabled INTEGER, recruitment_enabled INTEGER, exp_enabled INTEGER, time_limit INTEGER,
 min_npcs INTEGER, max_npcs INTEGER, npc_spawn_time INTEGER,
 up_map INTEGER, down_map INTEGER, left_map INTEGER, right_map INTEGER,
 instanced INTEGER, sql_present INTEGER NOT NULL DEFAULT 1
) WITHOUT ROWID;
CREATE TABLE tiles (
 map_id TEXT NOT NULL, x INTEGER NOT NULL, y INTEGER NOT NULL,
 ground INTEGER, ground_anim INTEGER, mask INTEGER, mask_anim INTEGER,
 mask2 INTEGER, mask2_anim INTEGER, fringe INTEGER, fringe_anim INTEGER,
 fringe2 INTEGER, fringe2_anim INTEGER, type INTEGER, data1 INTEGER, data2 INTEGER,
 data3 INTEGER, string1 TEXT, string2 TEXT, string3 TEXT, light INTEGER,
 ground_tileset INTEGER, ground_anim_tileset INTEGER, mask_tileset INTEGER,
 mask_anim_tileset INTEGER, mask2_tileset INTEGER, mask2_anim_tileset INTEGER,
 fringe_tileset INTEGER, fringe_anim_tileset INTEGER, fringe2_tileset INTEGER,
 fringe2_anim_tileset INTEGER,
 PRIMARY KEY(map_id, x, y)
) WITHOUT ROWID;
CREATE TABLE map_npcs (
 map_id TEXT NOT NULL, slot INTEGER NOT NULL, number INTEGER, spawn_x INTEGER,
 spawn_y INTEGER, min_level INTEGER, max_level INTEGER, appearance_rate INTEGER,
 start_status INTEGER, start_status_counter INTEGER, start_status_chance INTEGER,
 PRIMARY KEY(map_id, slot)
) WITHOUT ROWID;
CREATE TABLE npc_defs (
 num INTEGER PRIMARY KEY, name TEXT, attack_say TEXT, sprite INTEGER, spawn_secs INTEGER,
 behavior INTEGER, range_value INTEGER, drop_chance INTEGER, frequency INTEGER,
 move_rate INTEGER, iq INTEGER, script TEXT, recruitment_rate INTEGER,
 species INTEGER, form INTEGER, sex INTEGER, shiny INTEGER
);
CREATE TABLE item_defs (
 num INTEGER PRIMARY KEY, raw_json TEXT NOT NULL
);
CREATE TABLE stories (
 num INTEGER PRIMARY KEY, segment_count INTEGER, name TEXT, exit_map INTEGER
);
CREATE TABLE story_segments (
 story_num INTEGER, segment INTEGER, action INTEGER, param INTEGER,
 PRIMARY KEY(story_num, segment)
) WITHOUT ROWID;
CREATE TABLE story_params (
 story_num INTEGER, segment INTEGER, name TEXT, value TEXT,
 PRIMARY KEY(story_num, segment, name)
) WITHOUT ROWID;
"""

MAP_UPDATES = {
    "map_general": ("version=?, revision=?, max_x=?, max_y=?", (1, 2, 3, 4)),
    "map_data": (
        "name=?, moral=?, music=?, indoors=?, weather=?, darkness=?, hunger_enabled=?, "
        "recruitment_enabled=?, exp_enabled=?, time_limit=?, min_npcs=?, max_npcs=?, npc_spawn_time=?",
        tuple(range(1, 14)),
    ),
    "map_switchovers": ("up_map=?, down_map=?, left_map=?, right_map=?", (1, 2, 3, 4)),
    "map_standard_data": ("instanced=?", (1,)),
}


def _standard(row: tuple) -> bool:
    return bool(row and isinstance(row[0], str) and STANDARD_ID_RE.fullmatch(row[0]))


def import_sql_dump(content_zip: Path, database_path: Path, report_path: Path) -> dict:
    database_path.parent.mkdir(parents=True, exist_ok=True)
    if database_path.exists():
        database_path.unlink()
    wal = database_path.with_name(database_path.name + "-wal")
    shm = database_path.with_name(database_path.name + "-shm")
    wal.unlink(missing_ok=True)
    shm.unlink(missing_ok=True)
    con = sqlite3.connect(database_path)
    con.executescript(SCHEMA)
    counts: Counter[str] = Counter()
    source_rows: Counter[str] = Counter()
    skipped_statements: Counter[str] = Counter()
    try:
        with zipfile.ZipFile(content_zip) as archive, archive.open("pmu_data.sql") as raw_stream:
            for raw_line in raw_stream:
                line = raw_line.decode("utf-8", "replace").rstrip("\r\n")
                match = INSERT_RE.match(line)
                if not match:
                    continue
                table = match.group(1)
                if table not in TARGET_TABLES:
                    continue
                # map_tiles dominates the 1.15 GiB dump. PK order places map IDs
                # together; skip statements with no possible standard map row.
                if table in {"map_tiles", "map_npcs"} and "('s" not in line:
                    skipped_statements[table] += 1
                    continue
                if table in MAP_UPDATES:
                    assignment, positions = MAP_UPDATES[table]
                    for row in parse_insert_rows(line):
                        source_rows[table] += 1
                        if not _standard(row):
                            continue
                        map_id = row[0]
                        con.execute("INSERT OR IGNORE INTO maps(map_id) VALUES (?)", (map_id,))
                        values = tuple(row[index] for index in positions) + (map_id,)
                        con.execute(f"UPDATE maps SET {assignment} WHERE map_id=?", values)
                        counts[table] += 1
                elif table == "map_tiles":
                    batch: list[tuple] = []
                    placeholders = ",".join("?" for _ in range(31))
                    for row in parse_insert_rows(line):
                        source_rows[table] += 1
                        if _standard(row):
                            if len(row) != 31:
                                raise ValueError(f"map_tiles row has {len(row)} fields, expected 31")
                            batch.append(row)
                            counts[table] += 1
                            if len(batch) >= 5000:
                                con.executemany(f"INSERT INTO tiles VALUES ({placeholders})", batch)
                                batch.clear()
                    if batch:
                        con.executemany(f"INSERT INTO tiles VALUES ({placeholders})", batch)
                    con.commit()
                elif table == "map_npcs":
                    batch = [row for row in parse_insert_rows(line) if _standard(row)]
                    source_rows[table] += len(batch)  # lower bound: skipped non-standard rows are irrelevant to scope
                    if batch:
                        con.executemany("INSERT INTO map_npcs VALUES (?,?,?,?,?,?,?,?,?,?,?)", batch)
                        counts[table] += len(batch)
                elif table == "npc":
                    for row in parse_insert_rows(line):
                        source_rows[table] += 1
                        con.execute("INSERT INTO npc_defs VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", row)
                        counts[table] += 1
                elif table == "item":
                    import json
                    for row in parse_insert_rows(line):
                        source_rows[table] += 1
                        con.execute("INSERT INTO item_defs VALUES (?,?)", (row[0], json.dumps(row, ensure_ascii=False)))
                        counts[table] += 1
                elif table == "story":
                    rows = list(parse_insert_rows(line))
                    con.executemany("INSERT INTO stories VALUES (?,?,?,?)", rows)
                    source_rows[table] += len(rows); counts[table] += len(rows)
                elif table == "story_segment":
                    rows = list(parse_insert_rows(line))
                    con.executemany("INSERT INTO story_segments VALUES (?,?,?,?)", rows)
                    source_rows[table] += len(rows); counts[table] += len(rows)
                elif table == "story_param":
                    rows = list(parse_insert_rows(line))
                    con.executemany("INSERT INTO story_params VALUES (?,?,?,?)", rows)
                    source_rows[table] += len(rows); counts[table] += len(rows)
        con.commit()
        integrity = con.execute("PRAGMA integrity_check").fetchone()[0]
        map_count = con.execute("SELECT COUNT(*) FROM maps").fetchone()[0]
        expected_tiles = con.execute("SELECT SUM((max_x+1)*(max_y+1)) FROM maps").fetchone()[0]
        actual_tiles = con.execute("SELECT COUNT(*) FROM tiles").fetchone()[0]
        missing_tiles = con.execute(
            "SELECT COUNT(*) FROM maps m WHERE (SELECT COUNT(*) FROM tiles t WHERE t.map_id=m.map_id) != (m.max_x+1)*(m.max_y+1)"
        ).fetchone()[0]
        report = {
            "status": "EXTRACTED" if integrity == "ok" else "PARTIAL",
            "scope": "canonical standard maps matching ^s[0-9]+$",
            "source": {
                "path": str(content_zip),
                "sha256": sha256_file(content_zip),
                "member": "pmu_data.sql",
                "member_uncompressed_bytes": zipfile.ZipFile(content_zip).getinfo("pmu_data.sql").file_size,
            },
            "database": str(database_path),
            "integrity_check": integrity,
            "counts": dict(sorted(counts.items())),
            "source_rows_observed": dict(sorted(source_rows.items())),
            "statements_skipped_by_scope": dict(sorted(skipped_statements.items())),
            "standard_map_count": map_count,
            "expected_tile_count": expected_tiles,
            "actual_tile_count": actual_tiles,
            "maps_with_tile_count_mismatch": missing_tiles,
        }
        atomic_write_json(report_path, report)
        return report
    finally:
        con.close()
