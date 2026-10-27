# Récupération des maps des aperçus dans la quest

Généré le 2026-10-27 par `OUTILS/construire_maps_destiny.py`.

- Scripts de build exécutés : **99** (98 OK, 1 échecs).
- Maps récoltées et clampees : **6** (3 lots).
- Maps présentes dans `quest_pmd_destiny/Data/Ground/` : **262**.

## Échecs de build (maps non récupérées)

- `source/zone_zero_v1/build.py` : /home/user/projet-creation-pmdo/.venv/bin/python: can't open file '/tmp/destiny-src/source/zone_zero_v1/build.py': [Errno 2] No such file or directory

## Provenance

Les maps sont régénérées par les scripts `source/**/build.py` de la branche `arena/e39626d2` (méthode documentée dans chaque `renders/<lot>/manifest.json`). Les images de référence servant aux builds restent hors du dépôt et ne sont pas distribuées. `art_approved: false` / `runtime_tested: false` restent la règle.

## Couverture des aperçus — bilan

- **126 maps ZIP + 39 maps de branches + 97 maps régénérées = 262 maps dans la
  quest.** Toutes les maps présentées dans les aperçus et visionneuses
  récupérables automatiquement y sont.
- Les 13 stubs en liens symboliques sont **remplacés par leurs vraies maps**.
- **27 lots d'aperçu sans script de build** : ce sont pour l'essentiel des
  études/prototypes (études d'animations, calques, galeries de sprites) sans
  map à récupérer ; quelques versions intermédiaires (`entree_vapeur_sud_nord_v1`,
  `crooked_statique_v2`, `falaise_metano_temoin`, `mod_guilde_entrees_v1`,
  `northern_calques_v1`) ont leurs maps finales couvertes par d'autres lots ou
  versions déjà dans la quest. Non régénérables en l'état (scripts absents).
- **2 maps WaterfallVillage de town02** (« Reverie Town ») — zone
  `town02_waterfallvillage` **déclarée et compatible quest** : tuiles/BG town02
  déjà importés, script ground `Data/Script/halcyon/ground/WaterfallVillageCapital`
  en place, libellé et index de zones régénérés.
  - `waterfall_cave_1.rsground` (1 817 738 o) **récupéré SANS LFS** et intégré à
    `Data/Ground/` : copie publique `meromoonmeri/PMD-SKY-PMDO-PORT` vérifiée
    **sha256 identique** à l'objet LFS (`37bc9935…`).
  - `WaterfallVillageCapital.rsground` (233 727 831 o, sha256 `afc5081f…`) :
    objet **Git LFS** dont l'hébergeur de contenu n'est pas joignable depuis le
    sandbox. Dès que le fichier réel est fourni (pièce jointe / clone local),
    une commande l'intègre clampé et compatible :
    `python3 OUTILS/integrer_waterfall_town02.py --fichiers WaterfallVillageCapital.rsground`
    (waterfall_cave_1 est alors auto-récupéré sans LFS).
- **Title screen animé PMD Destiny** (« Ray of Hope MIX ») intégré à la quest :
  fonds `Title_Screen_Background_Jour/Nuit.dir` (24 poses), opening du blason
  Œuf Ailé (`Content/Obj/Destiny_Logo_Anime_Opening.dir`), UI `Title.png` /
  `Enter.png`, service `destiny_title_anim`, map-menu `pmd_destiny_menu_jour` +
  ses 10 tilesets DSTJ. Détail : `TITLE_SCREEN_PMD_DESTINY.md`.
