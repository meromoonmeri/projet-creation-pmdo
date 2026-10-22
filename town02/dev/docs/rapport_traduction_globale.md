# Rapport d'avancement — traduction française globale

Date : 24 juillet 2026

## Ce qui vient d'être traduit

### Test de personnalité

Le script `Data/Script/halcyon/ground/personality_test/init.lua` est maintenant en français pour tous les textes actifs :

- introduction du monde des Pokémon ;
- instructions de sélection ;
- choix héros/partenaire ;
- choix garçon/fille/non-binaire ;
- choix de capacité ;
- avertissements de type ;
- avertissements d'animations manquantes ;
- confirmation des noms ;
- nom de l'équipe ;
- option de saut vers le chapitre 2.

### Noms visibles des données

Des noms français ont été ajoutés pour les catégories qui n'avaient pas de `LocalTexts.fr` :

- 19 zones, dont tous les donjons ;
- 14 rangs ;
- 5 statuts de carte ;
- 3 statuts ;
- 11 couleurs de skin ;
- l'émote `Eating` ;
- les noms d'objets qui n'avaient pas encore de nom français.

Les noms principaux des donjons sont désormais :

- Relic Forest → **Forêt des Reliques** ;
- Illuminant Riverbed → **Lit de Rivière Lumineux** ;
- Crooked Cavern → **Caverne Tortueuse** ;
- Apricorn Grove → **Forêt des Noigrumes** ;
- Vast Steppe → **Grande Steppe** ;
- Searing Tunnel → **Tunnel Incandescent** ;
- Mt. Windswept → **Mont Venteux** ;
- Aegis Cave → **Aegis Cave**.

## Ce qui reste encore à faire pour une traduction réellement globale

Le mod complet contient encore beaucoup de phrases écrites directement dans les scripts Lua. Un audit statique détecte environ **755 lignes contenant probablement de l'anglais visible** dans les scènes et scripts de terrain actifs.

Les fichiers prioritaires sont :

- `ground/guild_bottom_right_bedroom/init.lua` ;
- `ground/metano_town/metano_town_ch_2.lua` ;
- `ground/metano_town/metano_town_ch_3.lua` ;
- `ground/guild_second_floor/init.lua` ;
- `ground/metano_town/metano_town_ch_4.lua` ;
- `ground/guild_heros_room/init.lua` ;
- `ground/relic_forest/relic_forest_ch_1.lua` ;
- `ground/guild_second_floor/guild_second_floor_ch_1.lua` ;
- `ground/ledian_dojo/init.lua` ;
- `PartnerEssentials.lua` ;
- `event_single.lua` ;
- `event_battle.lua` ;
- `beginner_lesson_evt.lua`.

Ces textes comprennent notamment :

- dialogues de PNJ ;
- menus de la guilde ;
- dialogues de personnalité ;
- messages de mission ;
- messages du bureau de poste ;
- textes d'événements génériques ;
- descriptions d'objets désormais complétées pour les 58 entrées qui étaient absentes ;
- titres des 36 panneaux de la leçon pour débutants désormais ajoutés en français.

## Important

La traduction du chapitre 5 est beaucoup plus avancée et ses textes visibles ont été finalisés. En revanche, dire que **tout le mod** est maintenant en français serait faux tant que les quelque 755 lignes de PNJ/menus des autres chapitres n'ont pas été migrées et traduites.

La prochaine passe doit être faite par blocs fonctionnels :

1. test de personnalité et sélection de départ — fait ;
2. noms de données et noms de donjons — fait ;
3. menus et PNJ de la guilde ;
4. Metano et ses maisons ;
5. bureau de poste et missions ;
6. chapitres 1 à 4 ;
7. relecture en jeu des descriptions d'objets, statuts, rangs et cartes ;
8. contrôle final des clés françaises et test en jeu.

## Validation après cette passe

- 178 fichiers Lua : 0 erreur de syntaxe ;
- JSON `Data` : valides ;
- fichiers `.resx` : valides ;
- 43 cartes de terrain présentes.

La validation en jeu PMDO reste nécessaire après chaque bloc de traduction.

## Passe procédurale globale — 24 juillet 2026

Une passe structurée a été appliquée aux appels de dialogue, de voix off, de menus et de conversations des scripts Lua :

- 94 fichiers Lua traités ;
- 1 299 appels de texte traduits ou normalisés ;
- guilde, almanach, PartnerEssentials, Metano, missions, bureau de poste et événements inclus ;
- validation syntaxique : 178 Lua, 0 erreur.

Les textes de diagnostic et les scripts de test restent séparés du contenu joueur. Une vérification en jeu est encore recommandée pour les textes construits dynamiquement.
