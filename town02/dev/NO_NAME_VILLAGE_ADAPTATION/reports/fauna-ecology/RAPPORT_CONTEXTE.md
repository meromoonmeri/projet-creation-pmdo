# Population contextuelle + audit des HELD — rapport

Commit `c61c21ca`, poussé et vérifié contre le distant.

---

## 0. Le sandbox a été réinitialisé — et la stratégie a tenu

Au démarrage de cette étape, `git log` affichait le commit de base : **tout le
travail avait disparu du disque**. `/tmp/reconv` (1,7 Go), `/tmp/fauna-backup`
(1,3 Go), l'archive de 233 Mo et `.runtime-cache` (466 Mo) : détruits.

C'est exactement le scénario contre lequel on s'est prémuni.

| Élément | Sort |
|---|---|
| Dépôt | restauré depuis le distant → `42ab801a` |
| **Patch d'entités (58 Ko, Git)** | **intact, sha256 vérifiés** |
| 1 642 entités (positions, ScriptVars, profils) | **entièrement récupérables** |
| 34 `init.lua` câblés (Git) | **intacts** |
| `NNVEcology.lua`, `NNVDuel.lua`, `nnv_wild.json`, `index.idx` | **intacts** |
| `/tmp/reconv`, backups, archive 233 Mo | perdus (reproductibles) |

Le pari des deux niveaux se vérifie : ce qui était irremplaçable pesait 58 Ko
et était dans Git. Le reste est régénérable depuis la source.

## 1. Audit des 109 HELD — 0 promu, et c'est la bonne réponse

`tools/audit_held_species.py` produit une fiche par colonie avec les 12 champs
demandés : espèce, room, biome de référence, saisons, jour/nuit, météo, preuve
de terrain par saison, positions candidates, profil, interactions, duel
possible, statut et raison exacte.

| Statut | Individus | Colonies |
|---|---:|---:|
| READY | **0** | 0 |
| HELD | **109** | 73 |
| NO_PROOF | **57** | 31 |

**Raison unique et vérifiable** : la libération d'un HELD saisonnier exige la
variante de Ground de *sa* saison, **convertie et rendue**. Le placement d'été
ne prouve rien pour l'hiver — la neige recouvre l'eau, les feuilles tombent,
les cellules praticables changent. Or `/tmp/reconv` a été détruit : il n'existe
aujourd'hui **aucune** variante, pas même l'été.

Chaîne nécessaire, chiffrée : télécharger `data.win` (~240 Mo) → extraction
structurée (466 Mo) → convertir `autumn`+`winter` de **15 rooms** (~1 min 23
par room et par saison) → rendus 4992×4992 → atlas saisonnier → replacement.

Je ne devine pas. **109 restent HELD, 57 restent NO_PROOF, Cradily et Sandshrew
restent HELD.** Le compteur reste à 1 642.

## 2. Le système contextuel est en place

`config/fauna-context.json` décrit, pour les **25 espèces**, trois tables :
`seasons`, `time`, `weather`. `tools/sync_fauna_context.py` les compile en
`E.DENSITY` dans le Lua — le JSON est éditable, le moteur est généré.

Trois leviers, appliqués aux entités **déjà placées** (aucun individu n'est
déplacé) :

1. **Présence** — saison + heure décident de la visibilité.
2. **Densité** — quelle proportion d'une colonie est active. Seuil déterministe
   basé sur le `rank` : pas de clignotement, pas d'aléatoire par frame.
3. **Activité** — la météo module les pauses. Swinub sous la neige devient
   *plus* actif ; tout le monde se met à l'abri sous l'orage.

### Le monde change réellement — rm83, 87 individus

| Contexte | Actifs | Espèces | Composition |
|---|---:|---:|---|
| été / jour / clair | **83** | 7 | vivillon 51, magikarp 17, barboach 4 |
| été / **nuit** / clair | **22** | 3 | magikarp 14, barboach 6, **illumise 2** |
| été / jour / **orage** | **18** | 5 | magikarp 12, barboach 3 |
| automne / jour / clair | 50 | 5 | vivillon 29, magikarp 14 |
| automne / nuit / brouillard | 16 | 2 | magikarp 11, barboach 5 |
| **hiver** / jour / neige | **3** | 2 | barboach 2, fletchling 1 |
| printemps / jour / pluie | 43 | 7 | magikarp 17, vivillon 16 |

Les papillons disparaissent la nuit, les lucioles la remplacent, l'orage vide
la surface mais pas l'eau, l'hiver dépeuple la forêt. La faune aquatique reste
aquatique en toute circonstance.

## 3. Un vrai bug trouvé par la simulation massive

Première simulation sur les **34 Grounds** (contre rm83 seul auparavant) :
**4 491 trajectoires clonées sur 28 464 paires**.

Cause réelle : `phase = index du membre dans SA colonie`. Deux colonies de la
même espèce dans la même room produisaient des phases identiques → mêmes
séquences pause/direction → **groupes se déplaçant comme un seul objet**.
Ma simulation précédente utilisait un index global et masquait le défaut.

Correction en deux temps :
- `rank` (rang dans la colonie) pour les seuils de densité et les groupes ;
- `phase` = index **global** dans le Ground + décalage par colonie.

Un premier essai avec `% 997` laissait encore 114 clones : le modulo
réintroduisait des collisions. Supprimé.

| | avant | après |
|---|---:|---:|
| Phases dupliquées | 1 157 | **0** |
| Trajectoires clonées | 4 491 | **6** |

## 4. Simulation massive — 1 642 individus, 34 Grounds

| Mesure | Résultat |
|---|---|
| Individus simulés | **1 642** |
| Déplacements (200 passes) | **269 800** |
| Paires comparées | 28 464 |
| Trajectoires clonées | **6** |
| Jamais mobiles | 7 |
| **Profils végétatifs** | **0** |
| Séquences d'états distinctes | 25 |
| États distincts | 19 |

Les **6 clones** et les **7 immobiles** sont **exactement les 7 Bellsprout
sessiles** (rm64 ×3, rm84 ×3, rm73 ×1). Leur immobilité est un état
comportemental nommé — `ancre`, `oscille`, `oriente`, `filtre` — pas une
absence de prise en charge. Zéro végétatif.

## 5. Interactions — un monde calme où les rencontres comptent

225 rencontres potentielles (colonies différentes, ≤ 240 px) :

| Verbe | Occurrences | Part |
|---|---:|---:|
| ignore | 161 | **71,6 %** |
| curieux | 42 | 18,7 % |
| fuit | 12 | 5,3 % |
| grege | 7 | 3,1 % |
| evite | 3 | 1,3 % |

Fletchling s'approche des Vivillon par curiosité, Cutiefly fuit Fletchling,
Volbeat et Illumise se regroupent la nuit. **Aucune rencontre ne dégénère
automatiquement.**

**0 duel possible en été** — et c'est cohérent : Crabrawler, Dwebble et
Piloswine, les seules espèces à duel, sont toutes `HELD_MISSING_SEASON`. Les
duels s'activeront avec l'automne et l'hiver.

## 6. Gardes et régressions

| Garde | Résultat |
|---|---|
| Suite écologie | 5 991 ✅ |
| Cohérence zone/scripts/densité | 26 ✅ |
| Damier `index.idx` | 1 891 tuiles, aucun ✅ |
| Intégrité des 6 `.rsmap` | 6/6, tuiles conformes ✅ |
| Invariant `Data/Zone` | 58 = 58 ✅ |

Régressions injectées :

| # | Test | Détection |
|---|---|---|
| R11 | Espèce exclue (Croagunk) dans le contexte | ✅ `especes inconnues` |
| R12 | Densité nulle toute l'année sur Vivillon | ✅ **garde ajoutée** — `des especes promues deviendraient invisibles` |

R12 a révélé un trou réel : rien n'empêchait d'effacer silencieusement 474
individus certifiés. La garde refuse désormais toute espèce promue rendue
invisible en permanence.

## 7. Validation pixel-perfect — limite honnête

`verify_duel_pixel_identity.py` **refuse de valider** : les rendus 4992×4992 de
référence ont été détruits par le reset. C'est le bon comportement — la garde
ne certifie pas sans preuve.

À la place, j'ai vérifié que les 6 `.rsmap` et leurs planches **n'ont pas
bougé** : nombre de tuiles conforme aux preuves archivées (324/324, 338/338,
323/323, 328/328, 286/286, 292/292), tailles inchangées. Les preuves d'origine
(0 pixel divergent, sha256 identiques) restent valides tant que les fichiers
sont intacts, ce que ce contrôle établit.

La comparaison complète sera rejouable dès que les Grounds seront régénérés.

## 8. Périmètre du commit

```
 M Data/Script/halcyon/NNVEcology.lua
 M NO_NAME_VILLAGE_ADAPTATION/generated/fauna/NNVEcology.lua
 ?? config/fauna-context.json
 ?? reports/fauna-ecology/held-audit.json
 ?? tools/audit_held_species.py
 ?? tools/sync_fauna_context.py
```

**0 fichier modifié dans `Data/Map`, `Data/Zone`, `Content/Tile`.** Aucun
Ground certifié touché. Les suppressions du diff sont uniquement les lignes
remplacées par leur version étendue.

## 9. Réconciliation — inchangée

```
1 808 = 1 642 promus + 109 HELD (saison) + 57 NO_PROOF
```

## 10. Runtime : `NOT_CERTIFIED`

Inchangé. Ni `dotnet` ni `mono`, hôtes .NET bloqués. Les 269 800 déplacements
simulés prouvent **l'algorithme**, pas le jeu.

## 11. Prochaine étape

Pour libérer les 109 HELD, il faut d'abord **régénérer les Grounds** :
`data.win` → extraction → conversion `summer` (34 rooms) puis `autumn`/`winter`
(15 rooms) → rendus → atlas saisonnier → replacement écologique → validation.

C'est un chantier long mais entièrement scripté : tous les outils existent et
sont versionnés. Le patch de 58 Ko permettra de réappliquer les 1 642 entités
dès que les Grounds d'été seront reconstruits.
