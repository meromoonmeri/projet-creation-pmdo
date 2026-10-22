# Fortune / Alpha / 7DS source acquisition

All three newly pushed LFS objects were downloaded and hash-verified.

| Source | SHA-256 | Bytes | NDS title/code | Changed files | Added files | MAP_BG changed/added | SCRIPT changed/added |
|---|---|---:|---|---:|---:|---:|---:|
| Fortune candidate (`Pokemon Romhack.NDS`) | `5cbcd371bff601c4cc5694e8dd8d82bb7b04c8876f99cc333f70903690e4c63a` | 153095104 | POKEDUN SORA / C2SE | 238 | 250 | 8 / 31 | 198 / 171 |
| Explorers of Alpha 3.x | `e94b66e99eb7b15369e828a625db8cdb13738f839009e46aea9e91dfa70cbf74` | 131322816 | POKEALPHA30 / C2SE | 692 | 610 | 57 / 150 | 567 / 369 |
| 7DS Spanish source | `d62c5701a66cbc7419d7d6c7a6cb834c22044f180411c02b05185313810b4556` | 371870656 | POKEDUN SORA / C2SP | 4045 | 2200 | 43 / 409 | 3963 / 1270 |

Baseline: supplied clean US Explorers of Sky ROM. The detailed manifests list every
added and changed filesystem asset. `PokemonAlpha.NDS.txt` is unambiguously Alpha.
`Pokemon Romhack.NDS` contains the Fortune-style BOSS1..BOSS5 and Giratina additions,
but remains labelled `Fortune candidate` until cross-checked against the official patch
hash/version. The 7DS source is not silently treated as Fortune or Alpha.

This report is source discovery only. It does not claim PMDO import or runtime validation.
