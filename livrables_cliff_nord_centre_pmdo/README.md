# Pack 10 Falaises Nord Centrées au Premier Plan (Style `cliffdaytest` Sans Roche) — 100 % Textures Canoniques Métano (PMDO 0.8.12)

## Architecture demandée : Falaise au Premier Plan (`cliffdaytest` centré) · Zéro Paroi Rocheuse · 100 % Textures Canoniques
- **Falaise au premier plan à l’arrivée (`Entrance_Sud`)** : dans les 10 versions (`01` à `10`), le plateau herbeux nu **`Grass Métano`** occupe tout l’avant-plan Sud et s’avance vers le centre-Nord surplombant le paysage marin et céleste.
- **Aucune paroi rocheuse verticale (`vertical_rock_face_pixels = 0`)** : on ne voit **que la fine bordure nordique canonique** (`Metano_Town_Cliffs.tile` `(518..534, 18..34)` & `(456..472, 164..180)`) donnant directement sur la mer animée Chunsoft (8 phases) et le ciel Jour/Nuit à 3 plans de nuages `RepeatX`.
- **3 calques de terrain canoniques séparés (`generated_terrain_rgb_pixels == 0`)** :
  1. `01_Herbe_Metano_Native` (`L01_herbe_native.png`) — `Metano_Town_Base.tile` `(0,640,128,768)`
  2. `02_Brins_Metano_Natifs` (`L02_brins_natifs.png`) — `Metano_Town_Base.tile` `(16,776,32,792)` & `(48,792,64,808)`
  3. `03_Bordure_Nord_Metano_Native` (`L03_bordure_nord_native.png`) — `Metano_Town_Cliffs.tile` lèvre de crête côtière native
- **Audit mathématique indépendant** : `python3 source/cliff_nord_centre_v1/verify_canonique.py` reconstruit bit-à-bit les `60` calques (`30 Jour` + `30 Nuit`) depuis les planches officielles certifiées SHA-256.

## Crédits & Statut
- **Palikadude** & contributeurs (*PMDO Halcyon*), **Abyss to Ascension**, **Spike Chunsoft**.
- Statut : `art_approved: false`, `runtime_tested: false`.
