# Générateur procédural d'arènes de boss (RogueEssence / PMDO)

`gen_boss_arena.py` — décrire un boss + un biome → obtenir une **vraie arène
jouable** (`.rsmap` RogueEssence), générée dynamiquement, sans template fixe.

## Utilisation

```bash
python3 tools/gen_boss_arena.py \
    --boss lugia --type ruines_englouties --taille 30 --difficulte 3 \
    --sortie Data/Map/arene_lugia.rsmap --valider --png
```

### Entrées
| Option | Valeurs | Défaut |
|---|---|---|
| `--boss` | nom (lugia, groudon, tornadus, regigigas, rayquaza, …) | tornadus |
| `--type` | `plateforme_celeste`, `temple_antique`, `volcan`, `ruines_englouties`, `foret_mystique`, `dimension_obscure` | auto (selon boss) |
| `--taille` | `20` (petite), `30` (moyenne), `50` (grande) | 30 |
| `--difficulte` | `1..5` (obstacles, zones dangereuses, position) | 2 |
| `--sortie` | chemin `.rsmap` | `Data/Map/arene_<boss>.rsmap` |
| `--graine` | seed (reproductible) | aléatoire |

### Mode debug
- `--ascii` : grille ASCII (B=boss, P=joueur, T=partenaire, O=obstacle, ~=danger).
- `--valider` : validation automatique (murs fermés, sol connecté, positions valides, boss accessible).
- `--png` : export image preview (aperçu debug, pas le rendu final).

## Ce que le générateur produit (un vrai `.rsmap`)

1. **Structure complète RogueEssence** identique aux arènes officielles :
   - `Tiles` (terrain : `floor`/`unbreakable` avec auto-tilesets de biome)
   - `Layers` (décor)
   - `EntryPoints` (spawn joueur + partenaire)
   - `MapTeams` (spawn boss, Foe)
   - `MapEffect.OnMapStarts` (BattlePositionEvent)
   - `BlankBG`, `Background`, `DiscoveryArray`, `Decorations`, etc.
2. **Logique d'arène** :
   - spawn joueur / partenaire / boss
   - zone centrale de combat (boss au centre)
   - zones d'esquive + zones stratégiques (autour du boss)
   - murs fermés, sol connecté (aucun cul-de-sac), aucun blocage
3. **Génération intelligente** par type d'arène :
   - `plateforme_celeste` : plateformes flottantes (tornadus, rayquaza)
   - `temple_antique` : piliers en quadrants, allée centrale (regis)
   - `volcan` : fissures de lave dangereuses + plateforme rocheuse (groudon)
   - `ruines_englouties` : anneau d'eau + colonnes antiques (lugia)
   - `foret_mystique` : îlots d'arbres, clairière centrale
   - `dimension_obscure` : murs fluides
4. **Identité visuelle** : auto-tilesets officiels par biome (sky_tower,
   concealed_ruins, magma_cavern_2, brine_cave, mystifying_forest,
   dark_wasteland) + élément + musique par boss.

## Génération unique
Une composition différente à chaque `--graine` (placement des obstacles,
fissures, îlots), tout en restant **toujours valide** : le générateur
répare automatiquement la connexité du sol (ponts entre îlots) et garantit
que joueur/partenaire/boss sont sur des cases marchables.

## Validation
Stress-té : 360 combinaisons (8 boss × 3 tailles × 5 difficultés × 3 seeds)
→ 0 échec. `--valider` vérifie en sortie : murs fermés, sol connecté, aucune
case inaccessible, boss/partenaire/joueur sur sol, positions dans les limites.

## Note
Les arènes de démonstration (`arene_<boss>.rsmap`) générées lors des tests ne
sont **pas commitées** : l'outil est le livrable, chaque arène se régénère à
la volée avec le bon seed.
