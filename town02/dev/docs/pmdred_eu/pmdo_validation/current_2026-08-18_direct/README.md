# Runtime PMDO courant — 27 Grounds dungeon-backed

Validation fraîche du checkout du 2026-08-18. Ce dossier archive une preuve
runtime **sans promotion** des candidats.

## Autorités

- ROM EU : `0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd`;
- candidat/staging : `RESERVE/pmdred_direct/` ;
- scheduler : `Data/Script/halcyon/RedDirectGroundAnimation.lua` ;
- fixture : `tools/build_pmdred_eu_runtime_fixture.py` ;
- terminaison : `tools/run_pmdred_eu_pmdo_termination_gate.py` ;
- comparaison : `tools/compare_pmdred_eu_pmdo_renders.py` ;
- PMDO : 0.8.12, exécutable hashé par le lock runtime.

## Résultat

- Grounds chargés : **27/27** ;
- échantillons CANM : **131** ;
- pixels exacts : **131/131** ;
- captures opaques : **131/131** ;
- verdicts runtime : `SAFE` ;
- entrées : 27 ;
- transitions inter-entrées : 26 ;
- sorties/nettoyages : PASS ;
- terminaison : `NORMAL_EXIT`, code 0 ;
- watchdog : aucun signal ;
- processus résiduel : aucun.

Ce résultat établit `RUNTIME_TESTED` pour la restitution graphique et le
scheduler des 27 candidats dans le checkout courant. Il ne certifie pas la
chaîne produit complète : événements EU, acteurs, scripts de scène, musique,
entrées/sorties narratives et transitions restent non migrés. Les candidats
restent donc sous `RESERVE/pmdred_direct/` et ne passent pas à `CERTIFIED` ou
`PROMOTED`.

Les fichiers de preuve et leurs hashes sont listés dans
`evidence_hashes.sha256`.
