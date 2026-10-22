# PMD Red EU `s01` — séquence complète validée en mode dormant

**Statut : `FULL_SOURCE_SEQUENCE_RUNTIME_VALIDATED_DORMANT`**

La scène `s01` n'est plus bloquée au simple prélude dans son harness : la
continuation source complète est maintenant exécutée avec PMDO 0.8.12.

## Séquence vérifiée

La ROM EU impose l'ordre suivant :

```text
CMD_BYTE_22 (fade palette, 30)
SPECIAL_TEXT_PERSONALITY_QUIZ
BGM_FADEOUT (30)
CMD_BYTE_23 (fade palette, 30)
RET
```

Le module `Data/Script/halcyon/pmdred_eu/scene/s01.lua` expose maintenant une
option explicite `execute_personality_quiz`. Le chemin par défaut reste
bloqué et ne prétend pas être complet ; seul ce chemin de validation opt-in
exécute le quiz intégré existant `pmdred_quiz_flow`.

La séquence utilise donc le vrai système New Era `personality_test` comme
système de quiz, sans créer un second moteur ni connecter le harness à la
Nouvelle Partie normale.

## Runtime réel

- PMDO 0.8.12 ;
- 175 événements contigus ;
- 729 frames ;
- 9 réponses, dont la branche `BraveQuest2B` ;
- 11 menus de choix ;
- 16 pages de texte quiz ;
- résultat déterministe : personnalité `naive`, recommandation `eevee` ;
- sortie `NORMAL_EXIT`, code 0 ;
- aucun watchdog, SIGSEGV, `Missing Data`, exception Lua ou `Lua Trace`.

La preuve machine est dans `validation.json`. Les empreintes des journaux
runtime ignorés sont conservées dans cette validation pour éviter de mettre
les logs générés dans Git.

## Limite volontaire

Cette validation ne route pas la scène dans la Nouvelle Partie New Era. Le
contrat d'intégration impose un gate narratif post-démarrage avant toute
activation du quiz Red ; `personality_test.CharacterSelect()` reste donc
inchangé et le harness ne crée pas de campagne parallèle.

La prochaine étape produit est de définir et valider ce gate depuis la
progression New Era, puis de connecter cette séquence complète sans modifier
les chapitres 1–5 protégés. Cette scène n'est pas comptée comme campagne PMD Red
complète tant que cette intégration n'est pas certifiée.
