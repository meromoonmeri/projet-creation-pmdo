#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ssb_adaptation.py — COUCHE D'ADAPTATION NEW ERA (arc du futur).

Modèle 4 couches (aucune fusion) :
  1. SSB Sky original (bytecode)          — intouché, dans pret/pmd-sky
  2. IR canonique JSON                    — docs/ssb_ir/<ZONE>_<scene>.json
  3. COUCHE D'ADAPTATION NEW ERA          — CE SCRIPT (cast/dialogues/BGM/grounds)
  4. Lua PMDO (RogueEssence)              — généré par le convertisseur

L'IR canonique (couche 2) n'est JAMAIS modifié pour s'adapter à New Era :
tout le remapping (acteurs, textes, musiques, grounds) vit ici, séparément.

Directives utilisateur (verbatim) encodées ici :
  - « dusknoir & groovyle dans new era font équipe ils viennent d'un futur »
  - « dialga dans new era est gentil il est plus corrompu »
  - « tout les evenement de new era se passe 30 ans plus tard »
  - « necrozma dans le futur a absorbé toute la lumiere du monde, la vie en
     somme le monde deviens progressivement neant »
  - « eternatus lui a altérée la réalitée et cela devenu une sorte d'infini »
  - « ces deux boss final sont en quelque sort le climax du jeu au chapitre 32 »
  - P05P01A = repaire de Necrozma (deux yeux rouges dans l'obscurité)
  - p05p03a = poteau d'exécution (héros/partenaire/Grovyle ligotés)

Sorties :
  docs/ssb_adaptation/cast.json        — entités Sky -> acteurs New Era (+ par scène)
  docs/ssb_adaptation/tables.json      — BGM / grounds / faces / variables / routines
  docs/ssb_adaptation/vocabulaire.json — anims / SE / effets (tables REQUISES, non inventées)
  docs/ssb_adaptation/README.md        — modèle 4 couches + statuts
"""

import json
import glob
import os
import collections

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
IR_DIR = os.path.join(ROOT_DIR, "docs", "ssb_ir")
OUT_DIR = os.path.join(ROOT_DIR, "docs", "ssb_adaptation")

# ---------------------------------------------------------------------------
# CAST GLOBAL New Era (directives utilisateur)
# ---------------------------------------------------------------------------
CAST = {
    "NPC_YONOWAARU": {
        "new_era": "NewEra.Dusknoir",
        "role": "ALLIÉ venu du futur (fait équipe avec Grovyle). Jamais antagoniste.",
        "species": "Dusknoir",
        "note": "Les répliques/actions de MÉCHANT de Sky portées par YONOWAARU sont ré-attribuées à Necrozma / ses sbires (couche dialogue). Animations/positions conservées telles quelles.",
    },
    "NPC_YONOWAARU_N8": {
        "new_era": "NewEra.Dusknoir",
        "role": "ALLIÉ venu du futur (variante d'instanciation N8).",
        "species": "Dusknoir",
        "note": "Même acteur que YONOWAARU ; la variante N8 est une seconde instance (même personnage).",
    },
    "NPC_JUPUTORU": {
        "new_era": "NewEra.Grovyle",
        "role": "ALLIÉ venu du futur (fait équipe avec Dusknoir).",
        "species": "Grovyle",
        "note": "Grovyle reste Grovyle (espèce conservée).",
    },
    "NPC_YAMIRAMI": {
        "new_era": "NewEra.Sableye_1",
        "role": "Sbire de Necrozma (garde du futur plongé dans le néant).",
        "species": "Sableye",
    },
    "NPC_YAMIRAMI2": {"new_era": "NewEra.Sableye_2", "role": "Sbire de Necrozma.", "species": "Sableye"},
    "NPC_YAMIRAMI3": {"new_era": "NewEra.Sableye_3", "role": "Sbire de Necrozma.", "species": "Sableye"},
    "NPC_YAMIRAMI4": {"new_era": "NewEra.Sableye_4", "role": "Sbire de Necrozma.", "species": "Sableye"},
    "NPC_YAMIRAMI5": {"new_era": "NewEra.Sableye_5", "role": "Sbire de Necrozma.", "species": "Sableye"},
    "NPC_YAMIRAMI6": {"new_era": "NewEra.Sableye_6", "role": "Sbire de Necrozma.", "species": "Sableye"},
    "NPC_SEREBII": {
        "new_era": "NewEra.Celebi",
        "role": "Gardienne du Passage du Temps / alliée (guide).",
        "species": "Celebi",
    },
    "PLAYER": {
        "new_era": "NewEra.Hero",
        "role": "Héros (présent).",
    },
    "ATTENDANT1": {
        "new_era": "NewEra.Partner",
        "role": "Partenaire (ligoté aux pieux en p05p03a, animation 78 conservée).",
    },
    "PLAYER_FUTURE": {
        "new_era": "NewEra.HeroFuture",
        "role": "Héros du futur (30 ans plus tard — le même, dans le monde devenu néant).",
    },
}

# Règle « antagoniste / maître de l'original -> Necrozma » : dans les scènes où
# l'acteur YONOWAARU joue le rôle d'ANTAGONISTE de la scène (déterminé à partir
# des textes canoniques : geôlier du poteau d'exécution, confrontation au
# Passage du Temps, confession, menaces finales), il est remplacé par
# NECROZMA. Ailleurs il reste Dusknoir (allié).
ANTAGONIST_SCENES = {
    "P05P03A_m17a0302": "Necrozma",
    "P05P03A_m26a06d3": "Necrozma",
    "P09P01A_m19b1001": "Necrozma",
    "P09P01A_m19b1007": "Necrozma",
    "P09P01A_m19b1009": "Necrozma",
    "P09P01A_m19d1072": "Necrozma",
}

# Acteur du « maître » aux yeux rouges : NECROZMA (n'apparaît pas comme entité
# scriptable dans les SSB de l'arc — il EST le décor/l'ombre des scènes P05P01A)
CAST["__MAITRE__"] = {
    "new_era": "NewEra.Necrozma",
    "role": "LE MAÎTRE aux yeux rouges dans l'obscurité (P05P01A). A absorbé toute la lumière du futur.",
    "species": "Necrozma",
    "note": "Maître de l'original (Dialga) -> Necrozma. Dialga est ABSENT de l'arc (gentil dans New Era). Dans les scènes où YONOWAARU est l'antagoniste (ANTAGONIST_SCENES), l'acteur devient Necrozma.",
}

# ---------------------------------------------------------------------------
# TABLES (curation manuelle à partir des IR — valeurs OBSERVÉES, pas inventées)
# ---------------------------------------------------------------------------
BGM_MAP = {
    "InTheFuture":             "In the Future.ogg",
    "PlanetsParalysis":        "In the Future.ogg",
    "OhNo":                    "Growing Anxiety.ogg",
    "TimeGearRemix":           "Time Gear Remix.ogg",
    "TimeGear":                "Time Gear Remix.ogg",
    "MemoriesReturned":        "Time Restored.ogg",
    "OnTheCeiling":            "Growing Anxiety.ogg",
    "InTheHandsOfFate":        "Sympathy.ogg",
    "HiddenHighland":          "Hidden Highland.ogg",
    "AnotherStaticNoise":      "Rising Fear.ogg",
    "InTheDepthsOfThePit":     "In the Depths of the Pit.ogg",
    "WelcomeToTheWorldOfPokemon": "Welcome to the World of Pokémon!.ogg",
    "ThePowerOfDarkness":      "The Power of Darkness.ogg",
    "StrongBlastNoise":        "Rising Fear.ogg",
}

GROUND_MAP = {
    "P05P01A": "p05p01a", "P05P02A": "p05p02a", "P05P02A2": "p05p02a",
    "P05P03A": "p05p03a", "P05P04A": "p05p04a", "P06P01A": "p06p01a",
    "P07P01A": "p07p01a", "P08P01A": "p08p01a", "P09P01A": "p09p01a",
    "S04P01A": "s04p01a",
    # couches décor (back2_SetGround) — à importer depuis le port PMD-SKY-PMDO-PORT
    "V09P04A": "v09p04a", "V10P03C": "v10p03c",
    "V12P01A": "v12p01a", "V13P01A": "v13p01a",
    "V14P01A": "v14p01a", "V14P03A": "v14p03a", "V14P04A": "v14p04a",
}

FACE_MAP = {
    "NORMAL": "Normal", "HAPPY": "Happy", "PAIN": "Pain",
    "SURPRISED": "Surprised", "SAD": "Sad", "WORRIED": "Worried",
    "DETERMINED": "Determined", "ANGRY": "Angry",
    "SIGH": "Sigh", "TEARY-EYED": "TearyEyed", "SHOUTING": "Shouting",
    "INSPIRED": "Inspired",
}

VAR_MAP = {
    "PARTNER_TALK_KIND": "SV.NewEra.PartnerTalkKind",
    "HERO_TALK_KIND": "SV.NewEra.HeroTalkKind",
    "SCENARIO_MAIN": "SV.Scenario.Main",
    "SCENARIO_MAIN_BIT_FLAG": "SV.Scenario.MainBitFlag",
    "COMPULSORY_SAVE_POINT": "SV.Scenario.CompulsorySavePoint",
    "SCENARIO_SIDE": "SV.Scenario.Side",
}

ROUTINE_MAP = {
    "MESSAGE_CLOSE_WAIT_FUNC": "fermer le dialogue et attendre la fin (structurel : UI:ResetSpeaker)",
    "WAIT_START_FUNC": "attendre le démarrage (structurel)",
    "NORMAL_WAIT_END_TALK": "attendre la fin de dialogue (structurel)",
    "HANYOU_SAVE_FUNC": "SAVE POINT obligatoire -> équivalent New Era (GAME:Save / point de contrôle)",
    "BOSS_WIPE_FUNC": "effacement d'écran de boss -> BossFX (wipe)",
    "JUMP_SURPRISE_FUNC_SERIES": "sursaut de surprise -> GROUND:CharSetEmote('exclaim') + CharSetAnim('Hurt')",
    "JUMP_ANGRY_FUNC_SERIES": "colère -> CharSetEmote('angry')",
    "JUMP_HAPPY_FUNC_SERIES": "joie -> CharSetEmote('happy')",
    "LOOK_AROUND_FUNC_SERIES": "regarde autour -> CharAnimateTurnTo séquentiel",
    "LOOK_AROUND_LEFT_FUNC_SERIES": "regarde à gauche",
    "LOOK_AROUND_RIGHT_FUNC_SERIES": "regarde à droite",
    "LOOK_AROUND_DOWN_FUNC_SERIES": "regarde en bas",
    "LOOK_AROUND_FAST_FUNC_SERIES": "regarde autour (rapide)",
    "HEAD_SHAKE_FUNC_SERIES": "hoche la tête -> CharSetAnim('Shake')",
    "EXPLANATION_FUNC_SERIES": "geste d'explication -> CharSetAnim('Talk')",
}


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    irs = []
    for path in glob.glob(os.path.join(IR_DIR, "*_*.json")):
        with open(path, encoding="utf-8") as stream:
            candidate = json.load(stream)
        if isinstance(candidate, dict) and all(key in candidate for key in ("zone", "scene", "ops")):
            irs.append(candidate)

    # vocabulaire observé
    anims = collections.Counter(); ses = collections.Counter(); effs = collections.Counter()
    ents_par_scene = {}
    for ir in irs:
        key = f"{ir['zone']}_{ir['scene']}"
        ents = collections.Counter()
        for op in ir["ops"]:
            for s in op.get("arg_specs", []):
                if s["type"] == "Entity" and isinstance(s["resolved"], str):
                    ents[s["resolved"]] += 1
            if op["name"] == "SetAnimation":
                for s in op["arg_specs"]:
                    if s["spec"] == "id": anims[s["raw"]] += 1
            if op["name"] in ("se_Play", "se_FadeOut", "WaitSe"):
                for s in op["arg_specs"]:
                    if s["spec"] == "se_id": ses[s["raw"]] += 1
            if op["name"] == "SetEffect":
                for s in op["arg_specs"]:
                    if s["spec"] == "effect_id": effs[s["raw"]] += 1
        ents_par_scene[key] = dict(ents)

    # cast par scène (automatique : entités présentes -> cast)
    cast_par_scene = {}
    for key, ents in ents_par_scene.items():
        cast_par_scene[key] = {
            ent: {"new_era": CAST[ent]["new_era"], "role": CAST[ent]["role"]}
            for ent in ents if ent in CAST
        }

    cast = {
        "schema": "newera.adaptation.cast.v1",
        "principe": "1:1 avec la cinématique canonique Sky (chorégraphie, timings, positions, animations, caméra, fades, SFX, BGM, transitions, flags, embranchements, ordre). SEUL LE CAST change. Aucune réécriture narrative.",
        "directives_utilisateur": {
            "dusknoir_grovyle_allies": "dusknoir & groovyle dans new era font équipe ils viennent d'un futur",
            "dialga_gentil": "dialga dans new era est gentil il est plus corrompu (ABSENT de l'arc du futur)",
            "decalage_30_ans": "tout les evenement de new era se passe 30 ans plus tard",
            "necrozma_lumiere": "necrozma dans le futur a absorbé toute la lumiere du monde, la vie en somme le monde deviens progressivement neant",
            "eternatus_realite": "eternatus lui a altérée la réalitée et cela devenu une sorte d'infini",
            "climax_ch32": "ces deux boss final (Necrozma + Eternatus) sont le climax du jeu au chapitre 32",
            "p05p01a_repaire_necrozma": "P05P01A = repaire de Necrozma (deux yeux rouges dans l'obscurité)",
            "p05p03a_poteau_execution": "p05p03a = poteau d'exécution où héros/partenaire/Grovyle sont ligotés (anims/positions 1:1)",
        },
        "cast_global": CAST,
        "cast_par_scene": cast_par_scene,
        "regle_antagoniste": {
            "regle": "antagoniste / maître de l'original -> Necrozma, lorsque le personnage doit être remplacé narrativement",
            "scenes": ANTAGONIST_SCENES,
            "substitutions_dialogue": {
                "Dialga": "Necrozma (le maître du futur ; Dialga absent de l'arc)",
                "Primal Dialga": "Necrozma (la présence sombre aux yeux rouges)",
                "Dusknoir (scènes antagoniste)": "Necrozma (l'acteur YONOWAARU devient Necrozma ; nom dans les dialogues substitué)",
            },
        },
    }

    tables = {
        "schema": "newera.adaptation.tables.v1",
        "bgm": BGM_MAP,
        "grounds": GROUND_MAP,
        "faces": FACE_MAP,
        "variables": VAR_MAP,
        "routines_communes": ROUTINE_MAP,
        "notes": {
            "bgm": "Noms .ogg = convention New Era (à vérifier dans Content/Music du mod ; les BGM canoniques Sky sont à importer ou remplacer).",
            "grounds": "Les grounds P05* importés du port PMD-SKY-PMDO-PORT ; S04P01A = embranchement (le présent) — transition à conserver.",
            "faces": "Mapping face Sky -> émotion portrait PMDO (GeneralFunctions.SetEmotion valide ces noms).",
            "variables": "Variables Sky -> SV New Era (SCENARIO_MAIN_BIT_FLAG[8]=1 et COMPULSORY_SAVE_POINT=14 en fin de m17a0302).",
        },
    }

    vocab = {
        "schema": "newera.adaptation.vocabulaire.v1",
        "statut_global": "TABLES REQUISES — aucun nom inventé. Les tables anim/SE/effet sont à établir depuis les données de la ROM (pmdsky-debug / ROM USA), puis validées.",
        "animations": {
            "ids_observes": {str(k): v for k, v in sorted(anims.items())},
            "statut": "REQUISE : table id animation PMD2 -> nom d'animation PMDO, par acteur. Ids clés : 78 (ligoté/struggling, ATTENDANT1), 17/2/4/12/22 (postures courantes). A établir depuis la ROM, pas inventée.",
        },
        "effets_sonores": {
            "ids_observes": {str(k): v for k, v in sorted(ses.items())},
            "statut": "REQUISE : table id SE PMD2 -> nom SE PMDO (Content/Sound). La plupart des ids sont des voix/SE de battle (89xx).",
        },
        "effets_sprite": {
            "ids_observes": {str(k): v for k, v in sorted(effs.items())},
            "ids_sans_nom_xml": ["640", "645", "651"],
            "statut": "REQUISE : table id effet sprite PMD2 -> emote/VFX PMDO. 640/645/651 absents de la table XML (gap doc) -> NON CONVERTIS tant que non identifiés dans la ROM.",
        },
    }

    for name, obj in [("cast.json", cast), ("tables.json", tables), ("vocabulaire.json", vocab)]:
        with open(os.path.join(OUT_DIR, name), "w", encoding="utf-8") as f:
            json.dump(obj, f, ensure_ascii=False, indent=1)
        print("écrit", name)

    # ------- README -------
    L = []
    L.append("# COUCHE D'ADAPTATION NEW ERA — ARC DU FUTUR")
    L.append("")
    L.append("## Modèle 4 couches (aucune fusion, aucune donnée Sky modifiée)")
    L.append("")
    L.append("```")
    L.append("1. SSB Sky original (bytecode)   pret/pmd-sky — intouché")
    L.append("   ↓")
    L.append("2. IR canonique JSON             docs/ssb_ir/<ZONE>_<scene>.json (validation 100%)")
    L.append("   ↓")
    L.append("3. ADAPTATION NEW ERA            docs/ssb_adaptation/ (cast, tables, dialogues) — CE DOSSIER")
    L.append("   ↓")
    L.append("4. Lua PMDO (RogueEssence)       généré par le convertisseur, jouable dans le mod")
    L.append("```")
    L.append("")
    L.append("## Directives utilisateur (verbatim, encodées dans cast.json)")
    L.append("")
    for k, v in cast["directives_utilisateur"].items():
        L.append(f"- **{k}** : {v}")
    L.append("")
    L.append("## Cast global")
    L.append("")
    L.append("| Entité Sky | Acteur New Era | Rôle |")
    L.append("|---|---|---|")
    for ent, c in CAST.items():
        L.append(f"| `{ent}` | {c['new_era']} | {c['role']} |")
    L.append("")
    L.append("## Règle « antagoniste / maître de l'original → Necrozma »")
    L.append("")
    L.append("Dans Sky le méchant est **Dusknoir** et le maître **Dialga**. Dans New Era :")
    L.append("Dusknoir est **allié**, le maître du futur est **Necrozma** (yeux rouges, P05P01A),")
    L.append("**Dialga est absent** (gentil, non corrompu). **Aucune réécriture narrative** :")
    L.append("la chorégraphie 1:1 est conservée, seul l'acteur change.")
    L.append("")
    L.append("- Scènes où YONOWAARU est l'**antagoniste** (geôlier du poteau, confrontation,")
    L.append("  confession, menaces) : l'acteur devient **Necrozma**.")
    L.append("  " + ", ".join(sorted(ANTAGONIST_SCENES.keys())) + ".")
    L.append("- Scènes où YONOWAARU n'est pas l'antagoniste (rapporte au maître, guide le")
    L.append("  héros du futur) : il reste **Dusknoir**.")
    L.append("- Substitutions dans les dialogues canoniques : 'Dialga' -> 'Necrozma',")
    L.append("  `Primal Dialga` → `Necrozma`, `Dusknoir` → `Necrozma` (scènes antagoniste).")
    L.append("")
    L.append("## Tables d'adaptation")
    L.append("")
    L.append("- **tables.json** : BGM (Sky -> .ogg New Era), grounds (Sky -> ground importé),")
    L.append("  faces (Sky -> émotion portrait PMDO), variables (Sky -> SV New Era),")
    L.append("  routines communes (Sky -> helpers Lua).")
    L.append("- **vocabulaire.json** : ids d'animations / SE / effets OBSERVÉS dans les 24 scènes,")
    L.append("  avec leur fréquence. **Statut : TABLES REQUISES** (à établir depuis la ROM,")
    L.append("  jamais inventées). Les ids 640/645/651 (SetEffect) sont NON CONVERTIS.")
    L.append("")
    L.append("## Pipeline de conversion (prochaine étape)")
    L.append("")
    L.append("```")
    L.append("IR canonique  →  résolution des contextes (lives/performer/object)  →")
    L.append("résolution des acteurs (cast.json) → résolution des tables →")
    L.append("génération Lua (coroutine + GAME/GROUND/UI/SOUND) → compilation → runtime")
    L.append("```")
    open(os.path.join(OUT_DIR, "README.md"), "w", encoding="utf-8").write("\n".join(L))
    print("écrit README.md")


if __name__ == "__main__":
    main()
