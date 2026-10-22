# Audit d'intégrité global — vérification des bugs corrigés + peigne fin

Build : `2026-08-01-C`

---

## 1. Les 5 bugs de la Genèse : vérifiés éteints

Contrôle sur le code **débarrassé des commentaires** (mes commentaires
d'audit citent les noms des anciens bugs, ce qui fausse un simple `grep`) :

| bug | contrôle | état |
|---|---|---|
| 1. `camFn` / `spriteFn` jamais appelés | 0 occurrence dans le code | **éteint** |
| 2. aucune musique | 1 `PlayBGM` présent | **éteint** |
| 3. 9 espèces inexistantes | 0 occurrence de `Bulbizarre`, `Salameche`, `Carapuce`, `Metamorph` | **éteint** |
| 4. sprites sous fond plein écran | 0 `MakeCharactersFromList`, 0 `GROUND:Hide`, 0 `TeleportTo` | **éteint** |
| 5. `GENV_018` = `GENV_019` | textes désormais différents | **éteint** |

---

## 2. Nouvel outil — `tools/audit_integrite.py`

Les outils existants vérifient la syntaxe et la géométrie. Aucun ne
cherchait les **incohérences qui compilent mais cassent le jeu à
l'exécution**. Le nouvel outil traque 8 familles :

1. **paramètres morts** — un helper reçoit un callback et ne l'appelle jamais
   (*le bug exact de la Genèse*) ;
2. **personnages fantômes** — `MakeCharactersFromList` sur une clé absente
   du casting → erreur Lua en pleine scène ;
3. **clés `.resx` manquantes** → boîte de dialogue **vide** en jeu ;
4. **doublons consécutifs** — même phrase deux fois de suite ;
5. **instances inconnues** — `Hide`/`Unhide` sur un nom inexistant ;
6. **sons uniques** — référence isolée, typo probable ;
7. **scènes de boss sans musique** ;
8. **clés `.resx` orphelines** — texte écrit, jamais affiché.

### Deux passes de durcissement

Le premier jet sortait **3681 « anomalies »** — inexploitable. J'ai réduit
le bruit en deux temps, en vérifiant chaque famille avant de la filtrer :

- **modules globaux sans `.resx`** : normal, ils utilisent du texte littéral ;
- **langues tierces** (`de`, `es`, `it`, `ja`, `ko`, `pt`, `zh`) : héritées
  d'Halcyon, non maintenues ici ;
- **en-têtes `.resx`** (`resmimetype`, `version`, `reader`, `writer`) ;
- **doublons non consécutifs** : deux variantes éloignées sont un choix
  d'écriture, pas une erreur — seules les clés qui se suivent posent problème ;
- **entités posées sur la carte** : l'outil lit désormais les `.rsground`.
  Cette seule correction a fait passer la famille 5 de **36 à 12**.

---

## 3. Bugs RÉELS trouvés et corrigés

### 3.1 Quatre arènes de boss d'histoire sans aucune musique · MAJEUR

| arène | chapitre | boss |
|---|---|---|
| `crystal_sanctuary_boss` | 8 | Diancie |
| `forgotten_marsh_boss` | 9 | le gardien du marais |
| `celestial_peak_boss` | 10 | Lugia |
| `autel_celeste` | 10 | Lugia (autel) |

Vérifié : **0 `PlayBGM` dans tout leur dossier**. Un titre s'affichait, les
effets partaient, le boss parlait — **en silence complet**. Les 42 arènes de
gardiens, elles, ont toutes leur thème.

**Corrigé** : `SOUND:PlayBGM('Boss Battle!.ogg', true)` posé juste **avant**
`WaitShowTitle`, exactement comme dans les arènes de gardiens — le thème et
le nom du boss arrivent ensemble.

### 3.2 `Item_Give_Storage` absente · MOYEN

Appelée dans `metano_town/init.lua` l.1945 (échange d'objets), **absente des
deux `.resx`**. Le joueur recevait son objet et voyait une **boîte vide**.

**Corrigé**, avec le `{0}` attendu par l'appel :
> « Vous avez reçu {0} ! L'objet a été rangé dans votre entrepôt. »

Manque **préexistant** au commit de base `45c445a`.

---

## 4. Faux positifs identifiés — et pourquoi je n'y touche pas

Honnêteté sur ce que l'outil signale encore :

| signalement | verdict |
|---|---|
| **74 clés `Connect_*`** (`post_office`) | Menu réseau. **Préexistantes** au commit de base, jamais traduites depuis Halcyon. Hors périmètre : fonctionnalité multijoueur non utilisée par le scénario. |
| **28 doublons consécutifs** | Vérifiés un par un sur les cas nets : `MT2_009`/`MT2_010` sont sur **deux déclencheurs différents**, `AP4_008`/`AP4_009` dans un **`if/else` exclusif**. Le joueur ne voit jamais les deux. Les autres sont des PNJ de ville qui répètent leur réplique d'un chapitre à l'autre — volontaire. |
| **12 instances** | `Teammate1` est natif au moteur ; les `Slugma_*` sont créés par `GroundChar` direct dans la scène des Limagma ; `Limagma` vient d'une concaténation `'Limagma'..i`. |
| **`gloomy_forest_boss` sans musique** | La musique est dans `gloomy_forest_boss_ch_6.lua` (2 `PlayBGM`), pas dans l'`init`. |
| **32 sons uniques** | Un son n'est pas suspect parce qu'il n'est employé qu'une fois — c'est même souhaitable pour un effet signature. |
| **727 clés orphelines** | Texte écrit mais non affiché. Ce n'est **pas un bug d'exécution** : aucune ne provoque d'erreur. Beaucoup sont des variantes de PNJ prévues pour des états non encore branchés. À traiter comme dette d'écriture, pas comme correctif. |

---

## Validation

Lua **646/646** · `.resx` **576/576** · zones + index **208/208** ·
`verify_bg_format`, `verify_legend`, `verify_scene_positions`,
`validate_all` : tous au vert.

---

## Non testé

**Rien n'est testé en jeu.** L'audit est statique : il prouve qu'un appel
existe, pas que le rendu est beau. Restent à vérifier à l'écran :

- le rythme de la Genèse (durées et silences calculés, jamais vus) ;
- le comportement de `WaitShowBG` avec un `hold` long — s'il bloque au lieu
  de rendre la main, la narration se jouerait après l'image ;
- le rendu de la particule `Ash_Fall` ;
- la génération des 14 étages des chapitres 7-10.
