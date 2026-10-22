# Audit de couverture PMD-RED-PMDO-PORT — 245 Grounds

Source : `meromoonmeri/PMD-RED-PMDO-PORT/output/Grounds` au commit `03199fe5a025debfcba2f58c0a476a948a819fee`.

## Verdict

**Aucun Ground source ne manque dans la réserve locale.**

- upstream : 245 Grounds ;
- `RESERVE/red_grounds` : 245 Grounds ;
- `RESERVE/red_tiles` : 245 tilesets ;
- références de frames : 2 673 843 ;
- Grounds avec plusieurs frames : 136 ;
- Sheet manquante : 0.

## Pourquoi une comparaison par nom signalait 33 absences

Le dépôt source fournit 33 cartes sous un nom fonctionnel français, tandis que la réserve locale les conserve sous leur identifiant ROM brut. Exemple :

- `tour_ciel_sommet.rsground` ↔ `d13p03.rsground` ;
- `parvis_celeste.rsground` ↔ `d13p01.rsground` ;
- `mont_cendre_pied.rsground` ↔ `d09p01.rsground` ;
- `sanctuaire_voeu.rsground` ↔ `d23p01.rsground`.

Il s’agissait donc de **33 alias de noms**, pas de 33 fichiers absents. Les ajouter une seconde fois aurait créé 33 doublons lourds et dépassé inutilement le budget de taille.

La correspondance exhaustive est enregistrée dans :

`docs/canonical/red/upstream_ground_aliases.json`

## Garde-fou

```bash
python3 tools/audit_red_port_coverage.py
```

Le contrôle vérifie les 245 Grounds, les 245 tilesets, les 33 alias nommés et la résolution de chaque `Sheet` utilisée par chaque frame.

## Distinction importante

La couverture graphique est complète. Cela ne signifie pas que les 245 cartes sont toutes activées dans `Data/Ground` ou que chaque donjon possède déjà son JSON jouable. La réserve est complète ; l’intégration narrative et procédurale reste volontairement réalisée paquet par paquet pour éviter les doublons et les croisements de lieux.
