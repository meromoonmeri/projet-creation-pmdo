# WORKFLOW — `fin_monde_inverse_giratina_v2` (`FMI2`)

## 1. Objectif & Références Canoniques
- **Titre** : Fin Monde Inverse de Giratina — Archipel du Neant Abyssal (4:3)
- **Biome** : Monde Inverse de Giratina / Distortion World (ref. finalisland + Waterfall_Cave_ledge_TDS + D42P41A)
- **Format** : `768 × 576 px` (`4:3`, `96 × 72` cellules de `8 × 8 px`, `TexSize = 1`).
- **Contrainte stricte** : **Aucun artefact, aucune structure artificielle d'autel/stèle, aucun coffre ni objet en fin de zone** — uniquement le décor naturel et gravitationnel du biome.
- **Spécificités Monde Inversé (`EMI1` / `FMI2`)** :
  - **Néant bleu abyssal animé en background** : courants dimensionnels bleu nuit / cyan bioluminescent et particules gravitationnelles en boucle fermée (`16` phases).
  - **Îles flottantes & arbres/racines à l'envers** : îlots suspendus dans le vide avec arbres et racines poussant vers le bas (tête en bas).
  - **Cascades inversées** : chutes d'eau cyan-azur qui coulent **vers le haut (à contre-gravité)** avec écume et gouttelettes ascendantes.
  - **Chemins à l'envers** : sentier rocheux continu Sud → Nord où la caméra suit le joueur à travers les ponts rocheux suspendus.

## 2. Architecture Multicalque PMDO (`0.8.12.0`)
1. `FMI2_00_SOL` (`Layer=0`) : fond abyssal / sol praticable continu.
2. `FMI2_01_RELIEF` (`Layer=1`) : parois des îles flottantes, berges des cascades inversées et reliefs bloquants.
3. `FMI2_02_COURONNES` (`Layer=2`) : îles flottantes inversées en surplomb, arbres/racines à l'envers et couronnes hautes.
4. `FMI2_03_ANIMATION` (`Layer=3`) : animation bouclée (`16` phases × `5 ticks` = `80 ticks`, `loop_closed: true`) — cascades inversées ascendantes + néant bleu abyssal animé + gouttelettes en lévitation.
5. `FMI2_04_TOP` (`Layer=4`) : calque supérieur vide réservé moteur (`0` tuile).

## 3. Commandes de Reproductibilité
```bash
.venv/bin/python source/fin_monde_inverse_giratina_v2/build.py
.venv/bin/python source/fin_monde_inverse_giratina_v2/package.py
```
