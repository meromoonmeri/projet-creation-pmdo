# Vague 9 — « L'Annexe de la Toupie » : l'étage mystère du Bazar Secret (2026-07-27)

Réponse à la demande : « les étages mystère de Pokémon Sky dans les donjons,
avec l'OST de Spinda Café et les différents PNJ ».

## Sources vérifiées AVANT implémentation (comme demandé)

- **pret/pmd-sky** : le Bazar Secret est natif — `src/dungeon_logic_6.c`,
  `IsSecretBazaarNpcBehavior()` liste les 5 PNJ canoniques (Kirlia, Mime Jr.,
  Swalot, Lickilicky, Shedinja). Ground NDS non convertible directement.
- **PMDO base (DumpAsset)** : mécanique native équivalente trouvée —
  `FLOOR_GEN_SCRIPT.Mysteriosity` (event_mapgen) : tuile secrète `tile_mystery`
  + statut `mysterious_distortion` → téléporte vers un segment caché de la
  même zone (`SegLoc(SegDiff, 0)`). Utilisée par 12 zones du jeu de base.
- **Chez nous** : OST `Spinda's Cafe.ogg` ✅, ground `cafe_toupie` (tileset
  SpindaCafe, vague 4) ✅, template de salle secrète `secret_tropical_path` ✅.

## Ce qui a été construit (100 % mécanique native, zéro hack)

1. **Assets importés** : `tile_mystery.json` + `mysterious_distortion.json`
   (+ index Tile/MapStatus). VFX référencés (Portal_Small, Distortion) = jeu
   de base, déjà utilisés par BossFX.
2. **La salle** : `annexe_toupie.rsmap` (40×28) — fenêtre du café découpée du
   ground `cafe_toupie` (tuiles SpindaCafe identity-mapped), OST Spinda's
   Cafe, entrée bas-centre, sortie escaliers atteignable (fix flood-fill),
   aucune équipe hostile.
3. **La mécanique** : `FLOOR_GEN_SCRIPT.NewEraMystery` — version New Era de
   Mysteriosity (sans SV.magnagate) : 6 % de base **+1 % par Ancrage
   stabilisé** (max +5) — le Réseau « reconnaît » les habitués. Même pose de
   tuile, mêmes filtres (salle principale, jamais la salle de boss).
4. **Les 5 PNJ** (`SpawnAnnexeNPCs`, pattern canonique SpawnRandomTutor :
   MobSpawn + MobSpawnInteractable + PlaceRandomMobsStep allié, Unrecruitable) :

| Rôle Bazar Secret (Sky) | PNJ New Era | Service (dialogue FR) |
|---|---|---|
| Kirlia (accueil) | **Toupim** le Spinda voyageur | patron, lore : « cousin du comptoir de Metano, je creuse des succursales là où on en a besoin » |
| Mime Jr. (repos) | **Pausette** | sieste mimée → FullRestore de l'équipe (1×/visite) |
| Swalot (échoppe) | **Gobble** | vend une Pomme 100 Poké (« garantie sans acide. Ou presque. ») |
| Lickilicky (nettoyage) | **Lustro** | offre un objet « poli » trouvé dans la poussière (Oran/Lum/Graine Rappel/Noigrume) |
| Shedinja (sortie) | **Passe-Mue** | évasion du donjon (« les murs n'existent que si on les regarde ») |

5. **12 donjons équipés** (segment caché + tuile sur le segment principal +
   sortie douce dans ExitSegment + index à jour) : les 3 donjons ch5, Forêt
   Lugubre, les 4 donjons ch7-10, Caldeira Endormie, Crête Voilée, Forêt de
   l'Embuscade, Toundra Désolée.

## Audits
Carte : entrée/sortie sur sol atteignable (fix : sortie déplacée hors d'une
poche décorative) ; 12/12 zones (tuile + segment + spawns + hook + index) ;
5 espèces + items vérifiés dans les données ; APIs vérifiées contre le code du
jeu de base (FullRestore/GivePlayerItem/RemoveFromPlayerMoney/EndSegment) ;
Lua dépôt entier OK.
