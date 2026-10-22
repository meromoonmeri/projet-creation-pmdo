# CINÉMATIQUE — Après la défaite de Tornadus (Gardien du Mont Venteux)
## New Era : Abyss to Ascension — Fin de la traversée du Mont Venteux, transition vers les Ruines Fendues (Aegis Cave)

---

## 0. Rappels de conformité (avant d'exécuter)

- **Continuité établie :** Tornadus est le Gardien du Mont Venteux (`SV.Chapter5.MountGuardianDefeated`), déjà référencé dans les dialogues PNJ existants (`mount_windswept_entrance_ch_5.lua` : Tropius/Penticus, Noctowl/Phileas, etc. réagissent déjà différemment selon cet état). Cette cinématique doit poser cet état à `true` et rester cohérente avec ces dialogues déjà écrits — ne pas les contredire.
- **Légendaire justifié :** conforme à la règle « légendaire réservé à un enjeu narratif fort » — climax du Chapitre 5, pas une apparition gratuite.
- **Foreshadowing à noter explicitement :** les perturbations que Tornadus décrit (vents instables, agressivité anormale de la faune, vibrations des montagnes) sont la **même chaîne de foreshadowing** que celle posée aux relais du Ch5 et reprise avec Zarude au Ch6 — elles paient au Ch7 avec la révélation Groudon. Ne pas laisser cette scène isolée : elle doit sembler être un maillon, pas un épisode à part.
- **Cohérence future à vérifier :** si Tornadus doit devenir affrontable en revanche via le système déjà implémenté (`LegendZones.lua`, sur le modèle de `verdant_oath`/Zarude), le signaler comme point à câbler plus tard — ne pas l'implémenter ici sans vérifier d'abord la structure exacte du système existant.
- **Durée estimée :** 7 actes, largement au-dessus du minimum de 3-4 minutes — c'est cohérent avec le statut de climax de chapitre, pas un défaut à corriger.
- **Musique :** toutes les pistes citées ci-dessous doivent être vérifiées comme existant réellement dans `Content/Music/` avant intégration. Si une piste n'existe pas, le signaler et proposer la plus proche déjà utilisée dans le projet plutôt que d'inventer un nom de fichier.

---

## 1. Distribution des réactions par personnalité (cohérent avec les dialogues déjà écrits)

| Personnage | Espèce | Registre de réaction à Tornadus |
|---|---|---|
| Penticus | Tropius (Maître de Guilde) | Autorité calme, analyse immédiate de la gravité |
| Phileas | Noctowl (érudit) | Sidération savante, incrédulité, réflexion historique |
| Reinier | Girafarig (vétéran) | Calme posé, reconnaît que ça dépasse une simple mission |
| Kino | Breloom (conteur) | Déjà en train de penser aux implications légendaires/historiques |
| Rin | Audino (soigneuse) | Inquiétude tournée vers les habitants de Metano |
| Coco | Snubbull (franche) | Reste terre-à-terre, désamorce sans le vouloir |
| Ganlon | Cranidos (fier) | Sang-froid affiché, sérieux en dessous |
| Shuca | Mareep (électrique/nerveuse) | Blague nerveuse pour détendre |
| Hyko | Growlithe (loyal/naïf) | Fasciné, oublie presque la gravité de la rencontre |
| Almotz | Zigzagoon (journaliste) | Euphorie totale, écrit frénétiquement |

---

## 2. Script de cutscene

**Fichier :** `Data/Script/halcyon/ground/mount_windswept_guardian/mount_windswept_guardian_ch_5.lua` (fonction de post-combat, appelée depuis la victoire déjà scriptée du combat)

```lua
--------------------------------------------------------------------
-- POST-COMBAT : APRÈS LA DÉFAITE DE TORNADUS
-- Climax du Chapitre 5 — transition vers les Ruines Fendues
--------------------------------------------------------------------
function mount_windswept_guardian_ch_5.TornadusAftermath()
	local hero = CH('PLAYER')
	local partner = CH('Teammate1')
	local growlithe = CH('Teammate2') -- Hyko
	local zigzagoon = CH('Teammate3') -- Almotz

	GAME:CutsceneMode(true)
	AI:DisableCharacterAI(partner)

	----------------------------------------------------------------
	-- ACTE 1 : LE CALME APRÈS LA TEMPÊTE
	----------------------------------------------------------------
	SOUND:FadeOutBGM(60)
	GAME:WaitFrames(40)

	-- Le vent retombe, la caméra se stabilise sur l'arène
	GAME:MoveCamera(256, 240, 60, false)
	GAME:WaitFrames(60)

	-- Tornadus atterrit face aux héros
	local tornadus = CharacterEssentials.MakeCharactersFromList({
		{'Tornadus', 256, 200, Direction.Down}
	})
	GROUND:CharSetAnim(tornadus, "Idle", true)
	GAME:WaitFrames(30)

	-- Silence tendu : caméra resserrée sur le trio hero/partner/Tornadus
	GAME:MoveCamera(256, 220, 40, false)
	GAME:WaitFrames(40)

	GROUND:CharAnimateTurnTo(tornadus, Direction.Down, 4)
	UI:SetSpeaker(tornadus)
	UI:SetSpeakerEmotion("Serious") -- vérifier disponibilité pour Tornadus, sinon "Normal"
	UI:WaitShowDialogue("...Vous êtes bien plus puissants que je ne l'imaginais.")

	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Je n'ai jamais attaqué les explorateurs par plaisir.[pause=20] Comprenez-moi bien.")
	UI:WaitShowDialogue("Depuis plusieurs semaines, une agitation inhabituelle parcourt toute la région.")
	UI:WaitShowDialogue("Les vents sont devenus instables.[pause=15] Les courants aériens changent sans prévenir.")
	UI:WaitShowDialogue("Les Pokémon sauvages deviennent plus agressifs.[pause=15] Même les montagnes... semblent vibrer.")

	GAME:WaitFrames(20)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("En tant que gardien des cieux, j'ai pensé que ces perturbations venaient des expéditions menées ici.")
	UI:WaitShowDialogue("J'ai donc décidé d'empêcher quiconque d'atteindre ce sommet.")
	GAME:WaitFrames(15)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Mais après vous avoir affrontés... je comprends que vous n'êtes pas responsables.")

	----------------------------------------------------------------
	-- ACTE 2 : L'ARRIVÉE DE LA GUILDE
	----------------------------------------------------------------
	GAME:WaitFrames(30)
	-- Bruit de pas / voix au loin (SE d'ambiance si disponible)
	SOUND:PlayBattleSE("EVT_Emote_Notice")

	local tropius, noctowl, girafarig, breloom, audino, snubbull, cranidos, mareep =
	CharacterEssentials.MakeCharactersFromList({
		{'Tropius', 200, 320, Direction.Up},
		{'Noctowl', 224, 320, Direction.Up},
		{'Girafarig', 248, 320, Direction.Up},
		{'Breloom', 272, 320, Direction.Up},
		{'Audino', 296, 320, Direction.Up},
		{'Snubbull', 200, 340, Direction.Up},
		{'Cranidos', 224, 340, Direction.Up},
		{'Mareep', 248, 340, Direction.Up}
	})

	-- Arrivée en groupe, caméra qui suit le mouvement (pas de téléportation sèche)
	local arr = {}
	for i, c in ipairs({tropius, noctowl, girafarig, breloom, audino, snubbull, cranidos, mareep}) do
		arr[#arr+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames(i * 5)
			GROUND:MoveToPosition(c, c.Position.X, 260, false, 0.9)
		end)
	end
	TASK:JoinCoroutines(arr)
	GAME:WaitFrames(20)

	-- Tous découvrent Tornadus : silence, caméra élargie sur tout le groupe
	GAME:MoveCamera(256, 240, 80, false)
	GAME:WaitFrames(80)

	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Stunned") -- vérifier dispo, sinon "Surprised"
	UI:WaitShowDialogue("...Un... Pokémon légendaire.")

	GAME:WaitFrames(20)
	GROUND:CharSetEmote(noctowl, "surprise", 1)
	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("...")

	----------------------------------------------------------------
	-- ACTE 3 : LES EXCUSES DE LA GUILDE
	----------------------------------------------------------------
	GAME:WaitFrames(30)
	local walk1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(noctowl, 232, 232, false, 0.8) end)
	TASK:JoinCoroutines({walk1})

	GROUND:CharAnimateTurnTo(noctowl, Direction.Down, 4)
	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Respectful") -- sinon "Normal"
	UI:WaitShowDialogue("Si notre Guilde est réellement responsable des troubles qui agitent cette montagne...")
	UI:WaitShowDialogue("...alors nous vous présentons nos excuses.[pause=20] Notre seul objectif est de protéger cette région.")
	UI:WaitShowDialogue("Nous n'avons jamais souhaité troubler son équilibre.")

	GAME:WaitFrames(30)
	GROUND:CharAnimateTurnTo(tornadus, Direction.Down, 4)
	UI:SetSpeaker(tornadus)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("...Non.")
	GAME:WaitFrames(15)
	UI:WaitShowDialogue("Vous n'êtes pas responsables.")
	UI:WaitShowDialogue("Les perturbations sont bien plus anciennes que votre Guilde.")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Quelque chose bouleverse progressivement l'équilibre naturel de cette région.[pause=20] Même moi, j'en ignore la cause.")
	UI:WaitShowDialogue("Je n'ai fait qu'interpréter ces événements de la mauvaise manière.")

	----------------------------------------------------------------
	-- ACTE 4 : TOUR DE PAROLE (variation de portrait par personnage)
	----------------------------------------------------------------
	GAME:WaitFrames(20)

	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Serious")
	UI:WaitShowDialogue("Si même Tornadus ignore l'origine des perturbations... alors ce problème dépasse tout ce que nous avions imaginé.")

	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Je vous remercie d'avoir accepté de nous parler, malgré notre affrontement.")

	UI:SetSpeaker(girafarig)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Cette histoire dépasse largement une simple mission d'exploration.")

	UI:SetSpeaker(breloom)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("...J'ai déjà trois théories historiques qui me viennent en tête. Aucune n'est rassurante.")

	UI:SetSpeaker(audino)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Si ces catastrophes continuent de s'intensifier... je m'inquiète surtout pour les habitants de Metano Town.")

	UI:SetSpeaker(snubbull)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("On va bien finir par trouver une solution. On en a vu d'autres.")

	UI:SetSpeaker(cranidos)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("...La situation devient préoccupante. Je ne le dirai qu'une fois.")

	UI:SetSpeaker(mareep)
	UI:SetSpeakerEmotion("Happy") -- nerveuse, blague pour détendre
	UI:WaitShowDialogue("Au moins, si le ciel doit tomber, ma laine fera un excellent paratonnerre !")

	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("Wouf... je... je viens de parler à un Pokémon légendaire. Enfin, il a parlé. J'ai surtout écouté.")

	GAME:WaitFrames(15)
	GROUND:CharSetEmote(zigzagoon, "star", 1)
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Incroyable... incroyable... incroyable !")
	UI:WaitShowDialogue("J'ai parlé avec un véritable Pokémon légendaire !")
	UI:WaitShowDialogue("Ce chapitre du journal va être fantastique !")
	-- Almotz écrit frénétiquement, sans lever les yeux
	GeneralFunctions.DoAnimation(zigzagoon, "Write") -- vérifier existence, sinon "Idle" + emote "sparkle"

	----------------------------------------------------------------
	-- ACTE 5 : LE DÉPART DE TORNADUS
	----------------------------------------------------------------
	GAME:WaitFrames(30)
	GAME:MoveCamera(256, 210, 60, false)
	GROUND:CharTurnToCharAnimated(tornadus, hero, 4)

	UI:SetSpeaker(tornadus)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Vous avez prouvé votre valeur.")
	UI:WaitShowDialogue("Continuez votre voyage.[pause=20] Les réponses que vous cherchez se trouvent plus loin...")

	GROUND:CharTurnToCharAnimated(tornadus, tropius, 4)
	UI:WaitShowDialogue("Prenez soin des vôtres.")

	GAME:WaitFrames(15)
	UI:SetSpeakerEmotion("Happy") -- léger sourire
	UI:WaitShowDialogue("Adieu...[pause=20] et bon courage pour la suite.")

	-- Flash blanc, envol, disparition
	SOUND:PlayBattleSE("EVT_Battle_Flash")
	GAME:FadeOut(false, 30) -- fondu blanc si supporté, sinon fondu standard
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_2") -- rafale de vent
	GAME:WaitFrames(30)
	GAME:FadeIn(20)
	GROUND:Hide(tornadus.EntName)

	GAME:WaitFrames(30) -- silence qui revient

	----------------------------------------------------------------
	-- ACTE 6 : LA SCÈNE COMIQUE
	----------------------------------------------------------------
	GAME:MoveCamera(256, 240, 40, false)
	GAME:WaitFrames(40)

	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Stunned")
	UI:WaitShowDialogue("...Nous venons vraiment de rencontrer un Pokémon légendaire.")

	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("......")

	GAME:WaitFrames(20)
	-- Les jeunes recrues, totalement insouciantes, en fond
	UI:SetSpeaker(snubbull)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Bon... on mange quand ?")

	GROUND:CharSetEmote(growlithe, "question", 1)
	UI:SetSpeaker(growlithe)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Vous croyez qu'il a laissé tomber une plume quelque part ?")

	UI:SetSpeaker(mareep)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("J'aurais dû lui demander un autographe...")

	-- Almotz continue d'écrire, sans lever les yeux
	UI:SetSpeaker(zigzagoon)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("...et c'est là qu'il a dit « adieu et bon courage », un grand moment pour l'histoire de la Guilde...")

	GAME:WaitFrames(20)
	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Serious")
	UI:WaitShowDialogue("Vous réalisez au moins ce qui vient de se passer ?")

	GAME:WaitFrames(20) -- petit silence
	SOUND:PlayBattleSE("EVT_Emote_Happy") -- rire collectif si SE disponible
	UI:ResetSpeaker(false)
	UI:SetCenter(true)
	UI:WaitShowDialogue("Toute la Guilde éclate de rire. La tension retombe d'un coup.")
	UI:SetCenter(false)
	UI:ResetSpeaker()

	----------------------------------------------------------------
	-- ACTE 7 : REPRENDRE LA ROUTE
	----------------------------------------------------------------
	GAME:WaitFrames(20)
	UI:SetSpeaker(tropius)
	UI:SetSpeakerEmotion("Serious")
	UI:WaitShowDialogue("Nous avons déjà perdu beaucoup de temps.")

	GROUND:CharAnimateTurnTo(girafarig, Direction.Up, 4)
	UI:SetSpeaker(girafarig)
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("Les Ruines Fendues sont juste derrière cette montagne.")

	UI:SetSpeaker(noctowl)
	UI:SetSpeakerEmotion("Determined")
	UI:WaitShowDialogue("Notre mission n'est pas terminée.")
	UI:WaitShowDialogue("En formation. On avance.")

	-- Mise en formation et déplacement collectif vers le nord
	GAME:WaitFrames(15)
	local depart = {}
	depart[1] = TASK:BranchCoroutine(function() GROUND:MoveInDirection(hero, Direction.Up, 120, false, 1) end)
	depart[2] = TASK:BranchCoroutine(function() GAME:WaitFrames(4) GROUND:MoveInDirection(partner, Direction.Up, 120, false, 1) end)
	for i, c in ipairs({tropius, noctowl, girafarig, breloom, audino, snubbull, cranidos, mareep, growlithe, zigzagoon}) do
		depart[#depart+1] = TASK:BranchCoroutine(function()
			GAME:WaitFrames(8 + i * 3)
			GROUND:MoveInDirection(c, Direction.Up, 110, false, 1)
			GAME:GetCurrentGround():RemoveTempChar(c)
		end)
	end
	local coro_cam_final = TASK:BranchCoroutine(function() GAME:MoveCamera(256, 120, 140, false) end)
	depart[#depart+1] = coro_cam_final
	TASK:JoinCoroutines(depart)

	GAME:WaitFrames(40)
	-- Caméra reste sur le sommet désormais désert
	GAME:WaitFrames(60)

	SOUND:FadeOutBGM(40)
	GAME:FadeOut(false, 60)
	GAME:WaitFrames(60)

	-- Nettoyage et flags
	SV.Chapter5.MountGuardianDefeated = true
	GAME:CutsceneMode(false)
	AI:EnableCharacterAI(partner)
	AI:SetCharacterAI(partner, "origin.ai.ground_partner", CH('PLAYER'), partner.Position)

	-- Transition vers l'entrée des Ruines Fendues (Aegis Cave)
	GAME:FadeIn(0)
end
```

---

## 3. Notes de production (validation avant de livrer)

- **Émotions à vérifier pour Tornadus :** `Serious`, `Normal`, `Worried`, `Happy` — confirmer leur existence réelle pour l'espèce Tornadus (légendaire, portraits parfois limités). Si `Serious`/`Worried` n'existent pas, replier sur `Normal`/`Angry` selon ce qui est disponible, et le signaler.
- **Émotions `Stunned`/`Respectful` (Noctowl/Tropius) :** à vérifier dans le set de portraits existant du projet — si absentes, utiliser `Surprised`/`Normal` en repli, ne pas inventer un nom de fichier.
- **Musique :** volontairement non forcée dans ce script (le combat vient de se terminer, un silence progressif est plus fort qu'un thème plaqué) — si le projet a une convention de thème « légendaire calme » déjà utilisée ailleurs (Zarude post-victoire, par exemple), l'aligner ici pour cohérence de langage musical entre légendaires.
- **`EVT_Battle_Flash` / `EVT_Emote_Exclaim_2` :** noms de SE repris du fichier `mount_windswept_entrance_ch_5.lua` déjà existant dans le projet — cohérents avec les sons déjà utilisés pour des effets similaires (flash, rafale). Vérifier qu'ils sont bien appelés à l'identique ici.
- **Formation de groupe à la sortie :** décalage volontaire (`i * 3` frames) entre chaque personnage pour éviter un déplacement mécanique en bloc — cohérent avec la règle « pas de mouvement de caméra/personnages figé ».
- **Note de continuité :** cette scène pose `SV.Chapter5.MountGuardianDefeated = true`, déjà consommé par les dialogues PNJ existants du camp (`Tropius_Action`, `Noctowl_Action`, etc. dans `mount_windswept_entrance_ch_5.lua`) — aucune contradiction, c'est la suite logique de ces branches déjà écrites.
- **Foreshadowing posé ici :** description des perturbations par Tornadus → à référencer explicitement dans les scènes Zarude (Ch6) et la révélation Groudon (Ch7), comme déjà cadré dans le plan Ch5→Ch7.
- **Transition finale :** le fondu au noir doit s'enchaîner directement sur le script d'entrée des Ruines Fendues/Aegis Cave — vérifier que ce Ground existe et que son script d'entrée ne rejoue pas une cinématique redondante avec celle-ci (pas de double « arrivée essoufflée »).

---

## 4. Rendu attendu

- Confirmation des noms d'émotes/portraits réellement disponibles pour Tornadus et pour chaque PNJ de la Guilde (remplacements documentés si besoin).
- Confirmation de la musique utilisée (ou absence volontaire de musique justifiée).
- Test réel : vérifier que la formation de sortie ne fait traverser aucun mur/obstacle sur le Ground du sommet.
- `PROJECT_CONTEXT.md` mis à jour avec le nouvel état `SV.Chapter5.MountGuardianDefeated` posé par cette scène et le lien de foreshadowing vers Ch6/Ch7.
