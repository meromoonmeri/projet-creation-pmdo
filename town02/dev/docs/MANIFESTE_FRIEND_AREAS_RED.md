# Manifeste autoritatif — Friend Areas de Rescue Team

## Règle absolue

Les 57 Friend Areas importées de PMD Red sont exclusivement des **zones d’accueil** du système de Grodoudou, conformément à Rescue Team.

Grodoudou vend l’accès à une zone d’accueil. Cet achat permet ensuite d’héberger et de recruter les Pokémon compatibles. Il ne vend ni un combat, ni une revanche, ni un donjon légendaire.

Une Friend Area ne peut donc jamais être :

- un Ground de fin de donjon ;
- une arène de boss ou de légendaire ;
- une salle de cinématique recyclée ;
- le substitut visuel d’un autre lieu ;
- une destination `UnlockDungeon`.

Les rencontres et revanches légendaires appartiennent à leurs donjons canoniques. La Friend Area correspondante peut être une condition d’accueil préalable au recrutement, mais ne remplace jamais le lieu de rencontre.

## État vérifié

- 57/57 Grounds canoniques sont conservés dans `RESERVE/red_grounds` ;
- aucun de ces 57 Grounds n’est référencé comme `.rsmap` de fin de donjon ;
- l’ancien Ground H12P01/Poison Swamp utilisé par le Marais de l’Oubli a été retiré ;
- H17P01/Thunder Meadow (`pre_tonnerre`) a été retiré des scènes et musiques de boss ;
- son `Boss_Marker` et ses spawners d’arène ont été supprimés ;
- il reste actif uniquement comme future zone d’accueil Grodoudou ;
- l’ancien générateur « Friend Areas → arènes de boss » est neutralisé.

## Validation

Exécuter :

```bash
python3 tools/audit_friend_areas.py
```

Le contrôle exige 57 imports en réserve et interdit tout `Boss_Marker` ou contrat d’arène sur une Friend Area active.
