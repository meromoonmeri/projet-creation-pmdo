# Plan de traduction française — New Era : Abyss to Ascension

Méthode conforme au Text Guide PMDO (https://wiki.pmdo.pmdcollab.org/Text_Guide) :
le moteur charge automatiquement `strings.fr.resx` / `stringsEx.fr.resx` quand la langue
du jeu est le français, avec repli sur l'anglais pour toute clé absente. Aucun texte FR
codé en dur dans les Lua.

## Périmètre mesuré (base working-copy)

| Lot | Volume | Mécanisme | Priorité |
|---|---|---|---|
| **A. `Strings/stringsEx.resx`** | 1 795 clés (dialogues génériques : missions, pinch talk, job board, tutoriels donjon) | Créer `Strings/stringsEx.fr.resx` | 1 — visible partout en jeu |
| **B. `strings.resx` des ground maps** | 522 clés réparties sur ~40 maps (metano_town 279, post_office 73, relic_forest 16 ✔ fait, guild_first_floor, etc.) | Remplir les `strings.fr.resx` déjà présents (squelettes vides) | 2 |
| **C. Dialogues codés en dur dans les .lua** | **3 706** appels `UI:WaitShowDialogue("…")` (cinématiques ch. 1-5) | Extraction vers resx par map (`STRINGS.MapStrings['KEY']`) puis traduction — le mécanisme est déjà utilisé par les `init.lua` du mod (ex. commentaire modèle ligne 17-18 de `relic_forest/init.lua`) | 3 — le plus gros chantier, à faire chapitre par chapitre |
| **D. Menus custom** | `menu/character_menu.lua`, services (config, debug, menu_tools), `mission_gen.lua` (titres de jobs, lieux) | Mixte : resx + tables Lua de libellés | 2 |
| **E. Noms Pokémon/objets/lieux** | Noms d'espèces affichés via les données Monster (21 fichiers custom dans `Data/Monster/`) | Utiliser exclusivement les noms officiels FR (ex. Golbat→Nosferalto, Crobat→Nostenfer) ; table de correspondance à générer | transversal |

## Pilote livré (commit `9c3f98d`)

`Data/Script/halcyon/ground/relic_forest/strings.fr.resx` : 16 clés traduites
(cinématique d'ouverture + quiz de personnalité). Valide le squelette resx existant
et la chaîne de production (script Python d'injection + validation XML).

## Ordre d'exécution proposé

1. **Lot A** (stringsEx) par tranches de ~200 clés, en commençant par : job board,
   commentaires de mission, pinch talk (les plus vus en jeu).
2. **Lot B** : metano_town → post_office → guild → reste.
3. **Lot D** en parallèle du B (petits volumes).
4. **Lot C** : pilote sur le chapitre 1 (extraction + traduction d'une seule map d'abord,
   ex. `guild_first_floor_ch_1.lua`), validation en jeu, puis industrialisation.

## Règles de style

- Tutoiement entre membres de la guilde ; vouvoiement des PNJ envers les clients/étrangers selon contexte.
- Conserver tels quels les tags moteur : `[pause=N]`, `[color=…]`, `\n`, `[player]`, `[mission_item]`, etc.
- Typographie française : espaces avant `!?;:`, guillemets « » dans les dialogues narratifs si le moteur les rend correctement (à vérifier en jeu au premier test — sinon repli sur "…").
- Noms propres du mod (Metano, Altere, Hyko, Penticus, Rin…) : inchangés.
