# PMD Red specific resolution

The generic `converter/rom/` package inspects any GBA cartridge; this
package adds the PMD-Red-specific logic that decides which pointer
table is which.

## How the resolver works

1. `converter/rom/inspection.py` enumerates every plausible pointer
   table in the ROM (a run of ≥ 4 consecutive word-aligned ARM ROM
   pointers).
2. For each *role* we care about (dungeon-info table, ground-map
   table, cutscene table…), a `TableSpec` in `specs.py` declares a
   structural fingerprint: expected entry count (from a pret enum
   name), expected compression signature of the pointed payloads,
   plausible payload size range.
3. `table_resolver.resolve()` scores every candidate against every
   spec and keeps the best match above a threshold. When nothing
   matches, the spec resolves to `UNRESOLVED` with a specific reason.
   No fabricated result is ever produced.

The pret checkout is optional. When it is present under
`dev/external/pret_pmd_red/` (git-ignored), the resolver uses its
`include/constants/*.h` enums to know the *expected size* of each
table. When it is absent, the resolver still runs, but relies only on
compression/size fingerprints; the reasons string tells the user which
enum was missing so they can clone pret and rerun.

## What the repo contains (and does not contain)

- **Contains**: format recipes (`converter/rom/`), structural specs
  (`converter/pmdred/specs.py`), resolver logic
  (`converter/pmdred/table_resolver.py`), tests using synthetic byte
  blobs.
- **Does not contain**: any byte from the ROM, any ROM offset picked
  from the ROM, any pret file, any Nintendo asset. The pret checkout
  and the ROM stay on the user's machine and are git-ignored.

## Adding a new role

To teach the resolver a new table:

```python
TableSpec(
    role="my_new_table",
    pret_enum_for_count="MyEnumInPret",   # optional
    target_compression=CompressionKind.LZ77,  # optional
    target_min_bytes=256, target_max_bytes=4096,  # optional
    notes="what this table is",
)
```

Append it to `DEFAULT_SPECS`. Rerun `python -m converter.pipeline`;
the resolver's report gains a row for the new role.
