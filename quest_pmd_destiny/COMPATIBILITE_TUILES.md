# Compatibilité des tuiles town02 avec la quest PMDO Destiny

Généré le 2026-10-27 par `OUTILS/importer_tiles_town02.py`.

## Politique appliquée

- **Palikadude/Halcyon (contenu tiers) : NON redistribué.** Les 190 fichiers qui y sont identiques (ou homonymes) sont remplacés par des **placeholders neutres** (damier gris) de **mêmes dimensions, mêmes coordonnées (x,y), mêmes tailles de sous-images** : les maps se chargent et restent jouables, sans aucun pixel d'origine.
- **Créations Abyss Ascension : conservées à l'identique** (1165 fichiers copiés sans modification).
- `Content/Tile/index.idx` **régénéré** depuis les `.tile` présents (format exact repris de `renders/*/package/INSTALLER.py`).

## Basculer un fichier

Éditer `OUTILS/surcharge_provenance_tiles.json` (`"nom.ext": "propre"` ou `"neutre"`), puis relancer ce script. Cas ambigus par défaut neutre : `Title_Screen_Background.dir`, `Metano_Town_Base.tile`.

## Noms conservés dont l'origine n'a pas pu être vérifiée (33)

Ces fichiers ne sont pas dans Palikadude/Halcyon : ils sont donc traités comme vos créations, mais leur nom évoque du matériel existant. À confirmer ; passez en `"neutre"` dans la surcharge pour tout retirer.

- `10-PMD SKY.tile`
- `Arena_mount_windswept_guardian_Base.tile`
- `LandslideCave.tile`
- `MountWindsweptMiniboss_Base.tile`
- `MountWindsweptMiniboss_Fringe.tile`
- `MountWindsweptMiniboss_Objects.tile`
- `MountWindsweptMiniboss_Objects_Under.tile`
- `MountWindsweptMiniboss_Shadows.tile`
- `Mount_Windswept_Base.tile`
- `Mount_Windswept_Fringe.tile`
- `Mount_Windswept_Mountain.tile`
- `Mount_Windswept_Objects.tile`
- `Mount_Windswept_Objects_Under.tile`
- `Mount_Windswept_Shadows.tile`
- `PMD_TREES.tile`
- `SoutheasternIslandsTs.tile`
- `mount_windswept_guardian_Base.tile`
- `mount_windswept_guardian_Chunsoft_framebuffer_(cell-local_cycles)_1.tile`
- `mount_windswept_guardian_Chunsoft_framebuffer_(cell-local_cycles)_10.tile`
- `mount_windswept_guardian_Chunsoft_framebuffer_(cell-local_cycles)_11.tile`
- `mount_windswept_guardian_Chunsoft_framebuffer_(cell-local_cycles)_12.tile`
- `mount_windswept_guardian_Chunsoft_framebuffer_(cell-local_cycles)_2.tile`
- `mount_windswept_guardian_Chunsoft_framebuffer_(cell-local_cycles)_3.tile`
- `mount_windswept_guardian_Chunsoft_framebuffer_(cell-local_cycles)_4.tile`
- `mount_windswept_guardian_Chunsoft_framebuffer_(cell-local_cycles)_5.tile`
- `mount_windswept_guardian_Chunsoft_framebuffer_(cell-local_cycles)_6.tile`
- `mount_windswept_guardian_Chunsoft_framebuffer_(cell-local_cycles)_7.tile`
- `mount_windswept_guardian_Chunsoft_framebuffer_(cell-local_cycles)_8.tile`
- `mount_windswept_guardian_Chunsoft_framebuffer_(cell-local_cycles)_9.tile`
- `mount_windswept_guardian_Fringe.tile`
- `mount_windswept_guardian_Objects.tile`
- `mount_windswept_guardian_Objects_Under.tile`
- `mount_windswept_guardian_Shadows.tile`

## Restaurer l'art complet en local

Vous possédez town02 : copiez simplement les `.tile`/`.dir` d'origine par-dessus les placeholders (mêmes noms) — les coordonnées sont identiques, la restauration est sans risque.
