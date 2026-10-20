# KKR1 — Kiosque Kirlia pour le Café Spinda (PMDO 0.8.12 / Spinda V7–V8)

## Nature du livrable

- **Objet** : kiosque de boutique thématique **Kirlia** pour le réseau **Café Spinda** (V7 / V8), généré sur fond `#FF00FF` pur puis **détouré intégralement** (contour extérieur **et** ouverture centrale du guichet 100 % transparents, sans remplissage noir), **sans feuille sculptée ni tasse/café** sur le comptoir de bois, et **sans personnage pré-placé**.
- **Nettoyage de frange** : triple passe inspirée de `cafe_spinda_revisite_v7/livrer_reseau.py` adaptée aux teintes Kirlia (bois miel, coiffure sauge, volant plissé blanc, cornes rubis) — **0 px de magenta pur et 0 px de frange pourpre/violette résiduelle** au bord extérieur comme au bord intérieur du guichet.
- **Échelles et variantes livrées** :
  - **HD (`1024 × 1024`)** : `Kiosque_Kirlia_HD_sans_magenta.png` (fond et guichet 100 % transparents) + `Kiosque_Kirlia_HD_fond_neutre.png` (aperçu sur fond neutre chaud `#3a3028`) ;
  - **Échelle Ground `1×` (`112 × 120 px`, grille `8 px`, `14 × 15` tuiles)** :
    - `Kiosque_Kirlia_1x_complet.png` (objet complet vide),
    - `Kiosque_Kirlia_1x_arriere.png` + `Kiosque_Kirlia_1x_avant.png` (découpe arrière / comptoir avant disjointe pour placer le PNJ Kirlia entre les deux dans l'éditeur PMDO, pieds conseillés à `(56, 108)`),
    - variantes **Nuit V8** assorties (`Kiosque_Kirlia_1x_nuit_*.png`, facteurs RVB `[0.42, 0.35, 0.40]`) ;
  - **Feuilles d'import & banques `.tile` PMDO `0.8.12`** : préfixe unique `KKR1` (`KKR1_00_ARRIERE.tile`, `KKR1_01_AVANT.tile`, `KKR1_02_COMPLET.tile`, `index.idx`, `Mod.xml`, `INSTALLER.py`).
- **Statut honnête** : création générée (pas un sprite natif certifié), `art_approved = false`, `runtime_tested = false` (aucun test exécuté dans le moteur PMDO).
