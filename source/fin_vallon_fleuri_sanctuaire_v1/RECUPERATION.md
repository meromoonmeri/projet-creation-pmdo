# Récupération partielle — Fin Vallon Fleuri (FVF1)

Origine : commit `934a1b4e9b5a9875362ef394798ceef80db67867` (`Add files via upload`, 14 octobre 2026). Le commit avait aplati à la racine des fichiers provenant de plusieurs lots ; les fichiers identifiés avec certitude pour FVF1 ont été replacés ici sans retouche des pixels.

## Fichiers restaurés

- `bruts/decor_magenta.png` ← ancien `decor_magenta (3).png` : décor généré de la clairière-sanctuaire fleurie, sur fond magenta (hash vérifié contre le blob du commit source). L’image anciennement attribuée ici (`decor_magenta (1).png`) est la variante à veines rouges conservée dans les alternatives ETT2.
- `bruts/sol_complet.png` ← ancien `sol_complet.png` : brut de sol prairie ; le doublon exact `sol_complet (1).png` était associé à l'entrée EVF1.
- `viewer_template.html` ← ancien `viewer_template.html`. Le fichier `viewer_template (1).html` était strictement identique (même blob Git) ; un seul exemplaire est conservé.

Le template confirme le lot **Fin Vallon Fleuri — Sanctuaire de la Clairière Fleurie V1**, préfixe `FVF1`, entrée associée `EVF1`, format `768 × 576`, référence annoncée `D73P11A`. Il décrit le ruisseau et les fleurs Sky Peak attendus.

## Éléments absents du dernier commit

Le commit ne contenait ni `build.py`, ni tests, ni référence `D73P11A.png`, ni manifest, ni calques exportés/ORA, ni scène de revue, ni Ground. Le template HTML seul n'est pas un aperçu exécutable : il attend un JSON de spécification et ces ressources. Aucun pixel natif n'est revendiqué pour le décor généré.

## Reconstruction multicalque depuis les bruts restaurés — 14 octobre 2026

Le build commun `source/vallons_fleuris_v1/build.py` compose maintenant FVF1 **depuis ces deux bruts exacts** (décor et sol), sans régénération et sans substitution par une zone voisine. L'échelle est uniforme, sans étirement, vers 768 × 576 px / 96 × 72 cases. Sorties locales :

- `renders/fin_vallon_fleuri_sanctuaire_v1/FVF1_fin_vallon_fleuri_sanctuaire_v1_calques.ora` : ORA avec sol complet, décor terrestre, eau, fleurs et scintillements ;
- `renders/fin_vallon_fleuri_sanctuaire_v1/manifest.json` : sources, empreintes, provenance, masque d'eau, positions, calques et statuts ;
- `renders/fin_vallon_fleuri_sanctuaire_v1/review/FVF1_scene_animee.webp` : carte complète animée, et `review/FVF1_scene_t000.png` ;
- viewer commun : `apercu_vallons_fleuris_v1.html?map=FVF1`.

L'eau est remplie par la couleur exacte `(131,218,230)`, sans écume blanche ni dilatation générale de la rive. Les scintillements proviennent de `Metano_Town_River_Sparkles.tile` à leur taille native 8 × 8, sans rotation/miroir/agrandissement/recoloration. Le motif rose floral 7 × 7 utilise la palette de `SkyPeak4thPass.tile`, mais sa silhouette est générée. Seules les têtes détectées et sélectionnées sont animées ; les autres fleurs peintes dans le décor généré restent statiques. Le cycle A‑B‑A‑C utilise des poses B/C synthétisées par translations d'un pixel : les quatre GIF Sky Peak cités dans l'historique sont absents, donc aucune pose n'est déclarée native. Le rip Sky Peak reste une référence, pas une revendication de pixels. La référence D73P11A demeure absente. `art_approved`, `canonical_flower_frames_verified` et `runtime_tested` sont `false` ; aucune collision runtime/Ground n'est revendiquée.

Reconstruction et vérification : `.venv/bin/python source/vallons_fleuris_v1/build.py`, puis `.venv/bin/python source/vallons_fleuris_v1/test_build.py`.
