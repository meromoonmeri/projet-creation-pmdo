# Content/Tile de la quest-banc d'essai

Déposer ici les fichiers `.tile` référencés par les cartes de `../../Data/Ground/`
(liste exacte dans `../../../BIBLIOTHEQUE_MAPS/manifest.json`, champ
`tilesets_tuiles` de chaque carte), puis reconstruire l'index :

```
python ../../../BIBLIOTHEQUE_MAPS/outils/construire_index_tiles.py .
```

Règles : un seul tileset par basename (l'import écrase les homonymes → préfixer) ;
ne pas mélanger sheets 8 px et 24 px dans une même carte ; aucun tileset tiers
sans ligne de provenance validée dans `../../../BIBLIOTHEQUE_MAPS/PROVENANCE.md`.
