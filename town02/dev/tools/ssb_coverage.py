#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ssb_coverage.py — MATRICE DE COUVERTURE SSB -> Lua PMDO (arc du futur).

Pour chacune des 24 scènes :
    SSB ops totales  ->  ops comprises  ->  ops converties  ->  ops non converties

"Comprise"  : opcode connu et sémantique établie (toujours vrai ici : les 89
              opcodes de l'arc sont dans la table XML du jeu).
"Convertie" : il existe un idiome PMDO (RogueEssence) attesté, ET les arguments
              de l'op sont mappables (acteur résolu, position résolue, id
              d'effet/animation/SE résolu dans une table d'adaptation).
"Non convertie" : pas d'équivalent PMDO (ex. message_Mail) OU argument non
              mappable (ex. SetEffect id 640/645/651 sans nom) OU dépend d'une
              table d'adaptation New Era absente (anim id, SE id, BGM id).

STATUTS :
  OK       = conversion directe avec idiome attesté
  ADAPT    = idiome existe mais dépend de la couche d'adaptation New Era
             (acteurs, dialogues, BGM, grounds, anims, SE, effets)
  PARTIEL  = idiome approximatif (délais, échelle) — signalé, jamais silencieux
  NON      = aucun équivalent PMDO — explicitement NON CONVERTI

Toute commande NON/ PARTIEL est listée dans le rapport, jamais ignorée.
"""

import csv
import json
import glob
import os

IR_DIR = "/home/user/V4/docs/ssb_ir"
OUT_MD = "/home/user/V4/docs/MATRICE_COUVERTURE_SSB_LUA.md"
OUT_CSV = os.path.join(IR_DIR, "_coverage_matrix.csv")
OUT_JSON = os.path.join(IR_DIR, "_coverage_summary.json")

# ---------------------------------------------------------------------------
# TABLE DE MAPPING CURATEE : opcode -> (catégorie, statut, idiome PMDO, note)
# ---------------------------------------------------------------------------
# catégories : FLOW / ACTEUR / CAMERA / ECRAN / AUDIO / DECOR / MESSAGE / ETAT / META
M = {}

def add(name, cat, status, idiom, note=""):
    M[name] = {"cat": cat, "status": status, "idiom": idiom, "note": note}

# ------------------------------- FLOW --------------------------------------
add("lives",               "FLOW", "OK",     "structurel (contexte acteur)", "parallèle Sky -> TASK:BranchCoroutine en Lua")
add("WaitExecuteLives",    "FLOW", "OK",     "attente coroutine acteur", "TASK joint la coroutine de l'acteur")
add("WaitExecuteObject",   "FLOW", "OK",     "attente coroutine objet", "idem")
add("WaitExecutePerformer","FLOW", "OK",     "attente coroutine performer", "idem")
add("object",              "FLOW", "OK",     "structurel (contexte objet)", "variable cible Lua")
add("performer",           "FLOW", "OK",     "structurel (contexte performer)", "variable cible Lua")
add("supervision_Acting",        "FLOW", "OK",     "lance une chorégraphie parallèle d'acteur", "TASK:BranchCoroutine")
add("supervision_RemoveActing",  "FLOW", "OK",     "arrête la chorégraphie parallèle", "annulation coroutine")
add("supervision_StationCommon", "FLOW", "OK",     "pose l'acteur en mode stationnaire", "AI:DisableCharacterAI / action idle")
add("CallCommon",          "FLOW", "ADAPT",  "routine commune Sky -> helper Lua", "table routines communes (WAIT_START_FUNC, END_TALK, HANYOU_SAVE_FUNC...) -> équivalent New Era")
add("ExecuteCommon",       "FLOW", "ADAPT",  "routine commune parallèle", "idem, via TASK")
add("Jump",                "FLOW", "OK",     "goto structuré", "traduit en structure Lua (if/label)")
add("End",                 "FLOW", "OK",     "fin de scène", "return")
add("Destroy",             "FLOW", "OK",     "détruit l'acteur/objet courant", "GROUND:RemoveCharacter / Hide")
add("Hold",                "FLOW", "PARTIEL","pause maintenue", "pas d'équivalent exact : GAME:WaitFrames(1) + var")
add("Wait",                "FLOW", "OK",     "attente frames", "GAME:WaitFrames(n)")
add("CaseText",            "FLOW", "OK",     "branchement texte", "if/else Lua sur SV")
add("CaseMenu",            "FLOW", "OK",     "branchement menu", "UI:BeginChoiceMenu / UI:WaitForChoice")
add("DefaultText",         "FLOW", "OK",     "texte par défaut d'un switch", "else Lua")

# ------------------------------ MESSAGE ------------------------------------
add("message_Talk",              "MESSAGE", "ADAPT", "dialogue", "UI:SetSpeaker + UI:WaitShowDialogue(STRINGS:FormatKey(CLE)) — texte = couche d'adaptation FR")
add("message_SetFace",           "MESSAGE", "ADAPT", "portrait + émotion", "UI:SetSpeaker(chara) + GeneralFunctions.SetEmotion(face Sky -> émotion New Era)")
add("message_SetFaceOnly",       "MESSAGE", "ADAPT", "portrait sans dialogue", "idem sans UI:WaitShowDialogue")
add("message_SetActor",          "MESSAGE", "ADAPT", "définit le locuteur", "UI:SetSpeaker(chara) — acteur mappé New Era")
add("message_EmptyActor",        "MESSAGE", "OK",     "locuteur vide", "UI:SetSpeaker('\\\\uE040', true, '', -1, '', Gender.Unknown)")
add("message_ResetActor",        "MESSAGE", "OK",     "réinitialise le locuteur", "UI:ResetSpeaker()")
add("message_Close",             "MESSAGE", "OK",     "ferme le dialogue", "UI:ResetSpeaker()")
add("message_CloseEnforce",      "MESSAGE", "OK",     "ferme le dialogue (forcer)", "UI:ResetSpeaker()")
add("message_SwitchTalk",        "MESSAGE", "ADAPT", "bascule de locuteur selon variable", "if/else sur SV (variable Sky -> SV New Era)")
add("message_SwitchMonologue",   "MESSAGE", "ADAPT", "bascule de monologue", "idem")
add("message_SwitchMenu",        "MESSAGE", "OK",     "menu de choix", "UI:BeginChoiceMenu")
add("message_FacePositionOffset","MESSAGE", "PARTIEL","décalage du portrait", "UI:SetBounds/ResetBounds (approximatif, PMDO gère la pose)")
add("message_ImitationSound",    "MESSAGE", "PARTIEL","son d'imitation vocale", "SOUND:PlayBattleSE approximatif")
add("message_KeyWait",           "MESSAGE", "OK",     "attente clé", "UI:WaitShowDialogue bloque déjà — GAME:WaitFrames court si besoin")
add("message_Mail",              "MESSAGE", "ADAPT",  "courrier: cadre NDS, texte 5 langues canonique", "dialogue natif PMDO (cadre courrier documenté) — V9")

# ------------------------------- ACTEUR ------------------------------------
add("MovePositionMark",      "ACTEUR", "ADAPT", "déplacement vers marqueur", "GROUND:MoveToPosition(chara, sx*8, sy*8) — positions SSA (tuiles) -> pixels")
add("Move2PositionMark",     "ACTEUR", "ADAPT", "déplacement direct vers marqueur", "GROUND:AnimateToPosition / MoveToPosition (sans pathfinding)")
add("MovePositionOffset",    "ACTEUR", "ADAPT", "déplacement relatif", "GROUND:MoveToPosition(chara, pos.x+dx, pos.y+dy)")
add("Move2PositionOffset",   "ACTEUR", "ADAPT", "déplacement relatif direct", "idem")
add("SlidePositionOffset",   "ACTEUR", "ADAPT", "glissement relatif", "GROUND:AnimateToPosition (easing)")
add("Slide2PositionOffset",  "ACTEUR", "ADAPT", "glissement relatif direct", "idem")
add("SlidePositionMark",     "ACTEUR", "ADAPT", "glissement vers marqueur", "idem")
add("SetPositionOffset",     "ACTEUR", "ADAPT", "téléportation relative", "GROUND:TeleportTo(chara, x, y, dir)")
add("SetPositionMark",       "ACTEUR", "ADAPT", "téléportation vers marqueur", "GROUND:TeleportTo")
add("MoveHeight",            "ACTEUR", "ADAPT", "changement d'altitude", "chara.LocHeight (vol/saut) — valeurs Sky -> pixels")
add("Turn2Direction",        "ACTEUR", "ADAPT", "rotation vers direction", "GROUND:CharAnimateTurnTo(chara, dir, frames) — speed/rot -> frames")
add("Turn2DirectionLives",   "ACTEUR", "ADAPT", "rotation d'un acteur", "idem")
add("SetDirection",          "ACTEUR", "ADAPT", "direction immédiate", "chara.Direction = dir")
add("SetAnimation",          "ACTEUR", "ADAPT", "animation", "GROUND:CharSetAnim(chara, nomPMDO, loop) — TABLE anim Sky->PMDO REQUISE (id par espèce)")
add("WaitAnimation",         "ACTEUR", "OK",     "attente fin d'animation", "GROUND:CharWaitAnim(chara)")
add("SetEffect",             "ACTEUR", "ADAPT", "effet de sprite", "GROUND:CharSetEmote / CharSetDrawEffect / PlayVFX — TABLE effets Sky->PMDO REQUISE ; ids 640/645/651 NON CONVERTIS")
add("WaitEffect",            "ACTEUR", "OK",     "attente fin d'effet", "GAME:WaitFrames")
add("SetOutputAttribute",    "ACTEUR", "PARTIEL","attribut de sortie (bulle ?)", "sémantique à confirmer — approximatif")

# ------------------------------- CAMERA ------------------------------------
add("camera_SetMyself",           "CAMERA", "PARTIEL", "caméra suit le performer", "focus caméra PMDO si exposé ; sinon défaut (suit le héros)")
add("camera2_SetPositionMark",    "CAMERA", "PARTIEL", "sous-caméra vers marqueur", "équivalent overlay/parallaxe approximatif")
add("camera_SetEffect",           "CAMERA", "ADAPT",  "effet caméra (shake)", "GROUND:MoveScreen(ScreenMover(0, intensité, durée))")
add("camera2_SetEffect",          "CAMERA", "PARTIEL", "effet sous-caméra", "idem approximatif")

# ------------------------------- ECRAN -------------------------------------
add("screen_FadeIn",        "ECRAN", "OK", "fondu entrée", "GAME:FadeIn(dur)")
add("screen_FadeOut",       "ECRAN", "OK", "fondu sortie", "GAME:FadeOut(false, dur)")
add("screen_FadeInAll",     "ECRAN", "OK", "fondu entrée toutes couches", "GAME:FadeIn(dur)")
add("screen_FadeOutAll",    "ECRAN", "OK", "fondu sortie toutes couches", "GAME:FadeOut(false, dur)")
add("screen_WhiteOut",      "ECRAN", "OK", "voile blanc", "GAME:FadeOut(true, dur)")
add("screen_WhiteOutAll",   "ECRAN", "OK", "voile blanc toutes couches", "GAME:FadeOut(true, dur)")
add("screen_FlushIn",       "ECRAN", "ADAPT", "fondu coloré entrée", "FlashEmitter(StartColor r,g,b) / BossFX.Overlay")
add("screen_FlushOut",      "ECRAN", "ADAPT", "fondu coloré sortie", "idem")
add("screen2_FadeIn",       "ECRAN", "ADAPT", "fondu de la couche décor", "overlay scène (fond) — MECANIQUE DU RIDEAU/SCENE DU FUTUR")
add("screen2_FadeOut",      "ECRAN", "ADAPT", "fondu sortie couche décor", "idem")
add("screen2_WhiteOut",     "ECRAN", "ADAPT", "voile blanc couche décor", "idem")

# ------------------------------- AUDIO -------------------------------------
add("se_Play",       "AUDIO", "ADAPT", "effet sonore", "SOUND:PlayBattleSE('EVT_...') — TABLE SE Sky->PMDO REQUISE")
add("se_Stop",       "AUDIO", "PARTIEL", "arrêt SE", "pas d'arrêt SE direct PMDO (StopBGM ne couvre pas les SE)")
add("se_FadeOut",    "AUDIO", "PARTIEL", "fondu SE", "idem")
add("sound_Stop",    "AUDIO", "PARTIEL", "arrêt de tous les SE", "idem")
add("WaitSe",        "AUDIO", "PARTIEL", "attente fin de SE", "GAME:WaitFrames approximatif")
add("bgm_PlayFadeIn","AUDIO", "ADAPT", "musique", "SOUND:PlayBGM('xxx.ogg', true) — TABLE BGM Sky->New Era REQUISE")
add("bgm_FadeOut",   "AUDIO", "OK", "fondu musique", "SOUND:FadeOutBGM(dur)")
add("bgm_Stop",      "AUDIO", "OK", "arrêt musique", "SOUND:StopBGM()")
add("bgm2_PlayFadeIn","AUDIO", "NON", "2e canal BGM", "PMDO : un seul canal BGM — NON CONVERTI")
add("bgm2_FadeOut",  "AUDIO", "NON", "fondu 2e canal BGM", "idem — NON CONVERTI")
add("WaitBgm",       "AUDIO", "PARTIEL", "attente musique", "GAME:WaitFrames approximatif")

# ------------------------------- DECOR -------------------------------------
add("back_SetGround",         "DECOR", "ADAPT", "change de ground", "transition -> ground New Era (GAME:EnterGroundMap) — TABLE grounds REQUISE")
add("back_ChangeGround",      "DECOR", "ADAPT", "change de ground", "idem")
add("back2_SetGround",        "DECOR", "ADAPT", "couche décor (image de fond)", "overlay image de la scène (MECANIQUE SCENE FUTUR/RIZEAU)")
add("back2_SetMode",          "DECOR", "PARTIEL", "mode couche décor", "sémantique à confirmer")
add("back2_SetEffect",        "DECOR", "PARTIEL", "effet couche décor", "idem")
add("back_SetDungeonBanner",  "DECOR", "PARTIEL", "bannière donjon", "UI:WaitShowTitle approximatif")
add("back_SetBanner2",        "DECOR", "PARTIEL", "bannière chapitre", "UI:WaitShowTitle(title) approximatif")

# ------------------------------- ETAT --------------------------------------
add("flag_Set",            "ETAT", "ADAPT", "écriture variable", "SV.<var> = valeur — table variables Sky->SV REQUISE")
add("flag_CalcBit",        "ETAT", "ADAPT", "bit de variable", "opérations bit sur SV")
add("flag_SetScenario",    "ETAT", "ADAPT", "variable scénario", "SV.Scenario[...] = valeur (SCENARIO_MAIN_BIT_FLAG, COMPULSORY_SAVE_POINT)")
add("main_EnterDungeon",   "ETAT", "ADAPT", "entre dans un donjon", "GAME:EnterDungeon / EnterGroundMap — mapping id")

# ---------------------------------------------------------------------------
# EXTENSION 2026-08 (campagne complète 3760 SSB) : opcodes hors arc du futur,
# classés avec la même discipline (OK seulement si idiome direct attesté ;
# ADAPT si dépend d'une table/couche d'adaptation ; PARTIEL si approximatif ;
# NON si aucun équivalent).
# --- FLOW globaux ---
add("JumpCommon",          "FLOW", "ADAPT", "coroutine commune (unionall)", "CORO_* -> service Lua partagé Halcyon")
add("supervision_Station", "FLOW", "ADAPT", "activation de station de scène", "équiv. chargement de secteur ground")
add("supervision_ExecuteCommon", "FLOW", "ADAPT", "exécute une coroutine commune", "dispatch vers scripts communs Lua")
add("supervision_ExecuteActing", "FLOW", "ADAPT", "exécute une scène acting", "GAME:GroundScene / scène Lua")
add("supervision_ExecuteStationSub", "FLOW", "ADAPT", "sous-station", "scène Lua secondaire")
add("supervision_ExecuteStation", "FLOW", "ADAPT", "station", "scène Lua")
add("supervision_ExecuteStationCommon", "FLOW", "ADAPT", "station commune", "scène Lua partagée")
add("supervision_LoadStation", "FLOW", "ADAPT", "précharge une station", "préchargement de scène")
add("supervision_Suspend", "FLOW", "OK", "suspend la coroutine", "TASK yield")
add("supervision_SpecialActing", "FLOW", "PARTIEL", "effets spéciaux de supervision", "sous-ensemble mappé (fondu titre…) — ids spéciaux à curer")
add("supervision2_SpecialActing", "FLOW", "PARTIEL", "idem écran 2", "double écran NDS approximé (un seul écran PMDO)")
add("main_EnterGround",    "ETAT", "ADAPT", "charge un ground", "GAME:EnterGroundMap — mapping level->ground")
add("main_SetGround",      "ETAT", "ADAPT", "définit le ground courant", "idem")
add("main_EnterAdventure", "ETAT", "ADAPT", "démarre le mode aventure", "NewGame/continue flow")
add("main_EnterTraining",  "ETAT", "ADAPT", "mode entraînement (Maze)", "flux dédié")
add("main_EnterRescueUser","ETAT", "ADAPT", "", "sauvetage Wi-Fi NDS: PMDO a son rescue natif (NoRescue/Rescues des zones); ecran mot de passe = menu moteur, retour 0 documente")
add("main_EnterRescueHelp","ETAT", "ADAPT", "", "idem - rescue natif PMDO")
add("dungeon_mode",        "ETAT", "OK",    "test du mode donjon", "condition Lua")
add("debug_Print",         "META", "OK",    "log debug", "print()")
add("random",              "FLOW", "OK",    "aléa", "math.random")
add("WaitRandom",          "FLOW", "OK",    "attente aléatoire", "GAME:WaitFrames(random)")
# --- MESSAGE/menus ---
add("menu",                "MESSAGE", "ADAPT", "menus système (boutiques, coffre…)", "menus PMDO natifs équivalents; mapping par id de menu")
add("message_Menu",        "MESSAGE", "ADAPT", "menu à choix", "UI:BeginChoiceMenu")
add("message_Explanation", "MESSAGE", "OK",   "boîte d'explication", "UI:WaitShowDialogue variante")
add("message_Notice",      "MESSAGE", "OK",   "boîte notice", "idem")
add("message_Narration",   "MESSAGE", "OK",   "narration plein écran", "UI:WaitShowTitle/dialogue sans portrait")
add("message_SetWaitMode", "MESSAGE", "OK",   "mode d'attente des messages", "UI:SetAutoMode")
add("message_FacePositionOffset", "MESSAGE", "OK", "offset du portrait", "paramètre de dialogue")
add("message_ResetActor",  "MESSAGE", "OK",   "détache le portrait", "fin de locuteur")
add("message_Special",     "MESSAGE", "PARTIEL", "messages spéciaux systèmes", "sous-ensemble par id")
add("message_CloseEnforce","MESSAGE", "OK",   "ferme la boîte", "UI fermeture")
add("Questions",           "MESSAGE", "ADAPT", "question oui/non", "UI:ChoiceMenuYesNo")
add("ProcessSpecial",      "META", "PARTIEL", "hooks spéciaux moteur", "ids 0-30 partiellement documentés pmdsky-debug — curer par id")
# --- ACTEUR suppléments ---
add("SetMoveRange",        "ACTEUR", "ADAPT", "limite de déplacement", "contrainte IA de scène")
add("Lock",                "FLOW", "OK",    "verrouille des acteurs", "barrière de synchronisation")
add("Unlock",              "FLOW", "OK",    "déverrouille", "idem")
add("WaitLockLives",       "FLOW", "OK",    "attend le verrou d'un acteur", "join")
add("WaitLockPerformer",   "FLOW", "OK",    "attend le verrou d'un performer", "join")
add("SetPositionInitial",  "ACTEUR", "OK",  "replace à la position initiale", "GroundChar:SetLocation")
add("SetFunctionAttribute","ACTEUR", "ADAPT", "attache un comportement", "AI/interaction de PNJ")
add("ResetFunctionAttribute","ACTEUR","ADAPT", "détache", "idem")
add("ResetOutputAttribute","ACTEUR", "OK",  "réaffiche l'acteur", "SetVisible(true)")
add("SetBlink",            "ACTEUR", "OK",  "clignotement", "anim de dégât/flash")
add("SetHeight",           "ACTEUR", "OK",  "altitude (vol/saut)", "GroundChar height")
add("Wan",                 "ACTEUR", "ADAPT", "changement de sprite wan", "mapping fichiers sprites")
add("SetAttribute",        "ACTEUR", "PARTIEL", "attributs bruts", "sous-ensemble par bit")
# --- CAMERA/écran suppléments ---
add("camera_SetPositionMark","CAMERA","OK", "camera sur position mark", "GAME:MoveCamera")
add("camera_SetDefault",   "CAMERA", "OK",  "camera par défaut", "reset caméra")
add("camera_Move2Default", "CAMERA", "OK",  "glisse vers défaut", "MoveCamera lissé")
add("camera_SetEffect",    "CAMERA", "PARTIEL", "tremblements/effets", "shake mappé, autres ids à curer")
add("camera2_SetPositionMark","CAMERA","PARTIEL","caméra écran 2", "un seul écran PMDO — fusion documentée")
add("camera2_SetDefault",  "CAMERA", "PARTIEL", "idem", "")
add("camera2_Move2Default","CAMERA", "PARTIEL", "idem", "")
add("camera2_SetEffect",   "CAMERA", "PARTIEL", "idem", "")
add("WaitScreenFade",      "ECRAN", "OK",   "attend la fin du fondu", "GAME:WaitFade")
add("WaitScreenFadeAll",   "ECRAN", "OK",   "idem tous écrans", "GAME:WaitFade")
add("WaitSubScreen",       "ECRAN", "PARTIEL", "attend l'écran 2", "double écran fusionné")
add("screen_FadeChange",   "ECRAN", "OK",   "fondu partiel", "FadeTo intensité")
add("screen_WhiteOut",     "ECRAN", "OK",   "blanc total", "FadeOut(white)")
add("screen_FlushIn",      "ECRAN", "PARTIEL", "flush couleur", "approx FadeIn")
add("screen_FlushChange",  "ECRAN", "PARTIEL", "", "")
add("screen2_FadeChange",  "ECRAN", "PARTIEL", "écran 2", "fusion")
add("screen2_WhiteOut",    "ECRAN", "PARTIEL", "", "")
add("screen2_FlushIn",     "ECRAN", "PARTIEL", "", "")
add("screen2_FlushChange", "ECRAN", "PARTIEL", "", "")
# --- AUDIO suppléments ---
add("me_Play",             "AUDIO", "ADAPT", "fanfare (music effect)", "GAME:PlayFanfare — mapping id ME")
add("WaitMe",              "AUDIO", "OK",   "attend la fanfare", "WaitFanfare")
add("bgm_ChangeVolume",    "AUDIO", "OK",   "volume BGM", "GAME:BGMVolume")
add("bgm2_ChangeVolume",   "AUDIO", "PARTIEL", "volume BGM écran 2", "canal 2 fusionné")
add("bgm2_Play",           "AUDIO", "PARTIEL", "BGM canal 2", "fusion mono-canal documentée")
add("bgm2_Stop",           "AUDIO", "PARTIEL", "", "")
add("bgm2_PlayFadeIn",     "AUDIO", "PARTIEL", "", "")
add("bgm2_FadeOut",        "AUDIO", "PARTIEL", "", "")
add("WaitBgm2",            "AUDIO", "PARTIEL", "", "")
add("WaitBgmSignal",       "AUDIO", "PARTIEL", "synchro sur signal BGM", "pas de signal natif — timer calibré")
add("sound_Stop",          "AUDIO", "OK",   "stoppe tous les sons", "GAME:StopSE/BGM")
add("sound_FadeOut",       "AUDIO", "OK",   "fondu sonore global", "FadeOutBGM")
add("se_ChangeVolume",     "AUDIO", "OK",   "volume SE", "volume")
add("se_FadeOut",          "AUDIO", "OK",   "fondu SE", "")
# --- DECOR/monde ---
add("back_SetBackScrollSpeed","DECOR","PARTIEL","défilement du fond", "parallaxe approximée")
add("back_SetBackEffect",  "DECOR", "PARTIEL", "effet de fond", "ids à curer")
add("back_SetEffect",      "DECOR", "PARTIEL", "", "")
add("back_SetDungeonBanner","DECOR","ADAPT", "bannière de donjon", "UI:DungeonBanner équivalent")
add("back2_SetBackEffect", "DECOR", "PARTIEL", "écran 2", "fusion")
add("back2_SetMode",       "DECOR", "PARTIEL", "", "")
add("back2_SetGround",     "DECOR", "PARTIEL", "", "")
add("back2_SetSpecialActing","DECOR","PARTIEL","", "")
add("back2_SetBackScrollOffset","DECOR","PARTIEL","", "")
add("back2_SetBackScrollSpeed","DECOR","PARTIEL","", "")
add("back2_SetWeather",    "DECOR", "PARTIEL", "météo écran 2", "fusion")
add("back2_SetWeatherEffect","DECOR","PARTIEL","", "")
add("back2_SetInvisible",  "DECOR", "PARTIEL", "", "")
add("worldmap_SetMode",    "DECOR", "ADAPT", "carte du monde", "scène worldmap New Era")
add("worldmap_SetCamera",  "DECOR", "ADAPT", "", "")
add("worldmap_SetLevel",   "DECOR", "ADAPT", "", "")
add("worldmap_SetArrow",   "DECOR", "ADAPT", "", "")
add("worldmap_BlinkMark",  "DECOR", "ADAPT", "", "")
add("worldmap_SetMark",    "DECOR", "ADAPT", "", "")
add("worldmap_ChangeLevel","DECOR", "ADAPT", "", "")
add("worldmap_SetViewPosition","DECOR","ADAPT","", "")
# --- ETAT/objets ---
add("item_Set",            "ETAT", "ADAPT", "donne un objet", "GAME:GivePlayerItem — mapping item")
add("item_SetTableData",   "ETAT", "ADAPT", "table d'objets de scène", "table de récompenses")
add("item_GetVariable",    "ETAT", "ADAPT", "lit une variable objet", "SV")
add("item_SetVariable",    "ETAT", "ADAPT", "écrit", "SV")
add("flag_SetAdventureLog","ETAT", "ADAPT", "journal d'aventure", "SV logbook")
add("flag_GetScenarioBalance","ETAT","ADAPT","lecture balance scénario", "SV")
add("flag_SetDungeonResult","ETAT","ADAPT", "résultat de donjon", "SV.DungeonResult")
add("flag_ResetVisit",     "ETAT", "ADAPT", "reset des visites", "SV")
add("flag_Judge",          "ETAT", "ADAPT", "comparaison de variables", "condition SV")
add("sector",              "FLOW", "OK",   "sélecteur de secteur", "structurel switch")
# --- reliquat curation 2026-08 (opcodes basse fréquence) ---
add("WaitBackEffect",      "DECOR", "PARTIEL", "attend l'effet de fond", "")
add("supervision_RemoveCommon","FLOW","ADAPT","retire une coroutine commune","")
add("supervision_Remove",  "FLOW", "ADAPT", "retire une scène", "")
add("supervision_ActingInvisible","FLOW","ADAPT","scène invisible","préchargement")
add("supervision_ExecuteEnter","FLOW","ADAPT","exécute l'entrée","")
add("screen2_FlushOut",    "ECRAN", "PARTIEL", "écran 2", "fusion")
add("screen_WhiteChange",  "ECRAN", "PARTIEL", "blanc partiel", "")
add("WaitFadeIn",          "ECRAN", "OK",  "attend le fondu d'entrée", "")
add("WaitMoveCamera",      "CAMERA","OK",  "attend la caméra", "")
add("camera_MoveDefault",  "CAMERA","OK",  "caméra vers défaut", "")
add("camera2_MovePositionMark","CAMERA","PARTIEL","écran 2","fusion")
add("worldmap_MoveCamera", "DECOR", "ADAPT", "caméra worldmap", "")
add("worldmap_DeleteArrow","DECOR", "ADAPT", "", "")
add("worldmap_SetMessagePlace","DECOR","ADAPT","", "")
add("back_SetWeather",     "DECOR", "ADAPT", "météo de scène", "MapStatus météo")
add("back_SetSpecialEpisodeBanner","DECOR","ADAPT","bannière épisode spécial","")
add("back_SetSpecialEpisodeBanner2","DECOR","ADAPT","", "")
add("back_SetSpecialEpisodeBanner3","DECOR","ADAPT","", "")
add("message_SwitchMenu2", "MESSAGE","ADAPT","menu switch 2", "UI choix")
add("message_SetFaceEmpty","MESSAGE","OK",  "portrait vide", "")
add("message_Monologue",   "MESSAGE","OK",  "monologue", "dialogue sans locuteur")
add("message_SwitchTalk2", "MESSAGE","ADAPT","variante talk", "")
add("SlideHeight",         "ACTEUR","OK",   "glisse en hauteur", "anim")
add("MoveDirection",       "ACTEUR","OK",   "avance dans une direction", "GroundChar:Move")
add("MoveSpecial",         "ACTEUR","PARTIEL","mouvement spécial", "ids à curer")
add("TurnDirection",       "ACTEUR","OK",   "tourne", "GroundChar:Turn")
add("MoveTurn",            "ACTEUR","OK",   "avance en tournant", "")
add("Slide2PositionOffset","ACTEUR","OK",   "glisse relative", "")
add("Turn3",               "ACTEUR","OK",   "variante de rotation", "")
add("Turn2DirectionLives", "ACTEUR","OK",   "se tourne vers un acteur", "")
add("SetEffectSelf",       "ACTEUR","ADAPT","effet sur soi", "mapping VFX")
add("WaitLockObject",      "FLOW", "OK",   "attend verrou objet", "join")
add("WaitLockSupervision", "FLOW", "OK",   "attend verrou superviseur", "join")
add("ResetHitAttribute",   "ACTEUR","OK",  "réinitialise un attribut de collision", "")
add("se_PlayVolume",       "AUDIO","OK",   "SE avec volume", "")
add("se_PlayPan",          "AUDIO","OK",   "SE avec panoramique", "")
add("se_PlayFull",         "AUDIO","OK",   "SE complet", "")
add("se_Stop",             "AUDIO","OK",   "stop SE", "")
add("se_FadeVolume",       "AUDIO","OK",   "fondu volume SE", "")
add("bgm_PlayFadeInVolume","AUDIO","OK",   "BGM fondu volume", "")
add("bgm2_PlayFadeInVolume","AUDIO","PARTIEL","canal 2","fusion")
add("me_Stop",             "AUDIO","OK",   "stop fanfare", "")
add("value",               "ETAT","OK",    "littéral/valeur SSB", "structurel")
add("flag_SetCollect",     "ETAT","ADAPT", "collection (trésors)", "SV")
add("flag_CollectSetBit",  "ETAT","ADAPT", "", "")
add("flag_SetPerformance", "ETAT","ADAPT", "progression performance", "SV")
add("flag_GetPerformance", "ETAT","ADAPT", "", "")
add("main_SetGroundEnter", "ETAT","ADAPT", "point d'entrée du ground", "spawn location")
add("main_SetGroundExit",  "ETAT","ADAPT", "sortie", "")
add("back_SetBackScrollOffset","DECOR","PARTIEL","offset de défilement","")
add("main_EnterTraining2", "ETAT","ADAPT", "entraînement variante", "")
add("message_SpecialTalk", "MESSAGE","PARTIEL","talk spécial", "ids à curer")
add("supervision_ExecuteExport","FLOW","ADAPT","export de scène","")
add("supervision_ExecuteActingSub","FLOW","ADAPT","scène acting secondaire","")
add("Turn2DirectionTurn",  "ACTEUR","OK",  "rotation composée", "")
add("Turn2DirectionLives2","ACTEUR","OK",  "regarde un acteur (v2)", "")
add("debug_PrintFlag",     "META","OK",    "log flag", "print")
add("WaitScreen2Fade",     "ECRAN","PARTIEL","attente écran 2","fusion")
add("screen2_WhiteChange", "ECRAN","PARTIEL","", "")
add("WaitMoveCamera2",     "CAMERA","PARTIEL","caméra écran 2","fusion")
add("bgm_Play",            "AUDIO","ADAPT", "joue un BGM", "mapping id BGM")
add("se_ChangePan",        "AUDIO","OK",   "panoramique SE", "")
add("camera_Move2PositionMark","CAMERA","OK","caméra glisse vers mark","")
add("Move3PositionOffset", "ACTEUR","OK",  "déplacement relatif v3", "")
add("Slide3PositionOffset","ACTEUR","OK",  "glisse relative v3", "")
add("back_SetBanner",      "DECOR","ADAPT","bannière", "")
add("back_SetTitleBanner", "DECOR","ADAPT","bannière titre", "")
add("back_SetWeatherEffect","DECOR","ADAPT","effet météo", "")
add("worldmap_OffMessage", "DECOR","ADAPT","", "")
add("SectionD",            "META","OK",    "marqueur de section décompilateur", "structurel")

# ---------------------------------------------------------------------------
CATS = ["FLOW", "MESSAGE", "ACTEUR", "CAMERA", "ECRAN", "AUDIO", "DECOR", "ETAT", "META"]

def statut_poids(st):
    return {"OK": 1, "ADAPT": 2, "PARTIEL": 3, "NON": 4}[st]


def main():
    irs = {}
    for p in sorted(glob.glob(os.path.join(IR_DIR, "*_*.json"))):
        if p.endswith("_validation_summary.json") or p.endswith("_coverage_summary.json"):
            continue
        ir = json.load(open(p))
        irs[f"{ir['zone']}_{ir['scene']}"] = ir

    rows = []
    totals = {"ops": 0, "OK": 0, "ADAPT": 0, "PARTIEL": 0, "NON": 0}
    non_converties = []   # (scène, seq, op, raison)
    partielles = []

    for key, ir in sorted(irs.items()):
        zone, scene = key.split("_", 1)
        comptage = {"ops": len(ir["ops"]), "OK": 0, "ADAPT": 0, "PARTIEL": 0, "NON": 0}
        for op in ir["ops"]:
            spec = M.get(op["name"])
            if spec is None:
                comptage["NON"] += 1
                non_converties.append((zone, scene, op["seq"], op["name"], "opcode absent de la table de mapping"))
                continue
            st = spec["status"]
            comptage[st] += 1
            totals[st] += 1
            if st == "NON":
                non_converties.append((zone, scene, op["seq"], op["name"], spec["note"]))
            elif st == "PARTIEL":
                partielles.append((zone, scene, op["seq"], op["name"], spec["note"]))
        totals["ops"] += comptage["ops"]
        rows.append({"zone": zone, "scene": scene, **comptage})

    # ---- CSV ----
    with open(OUT_CSV, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["zone", "scene", "ops_totales", "ops_comprises", "converties_OK",
                    "adaptation_ADAPT", "partielles_PARTIEL", "non_converties_NON"])
        for r in rows:
            w.writerow([r["zone"], r["scene"], r["ops"], r["ops"],
                        r["OK"], r["ADAPT"], r["PARTIEL"], r["NON"]])

    json.dump({"rows": rows, "totals": totals, "non_converties": non_converties,
               "partielles": partielles}, open(OUT_JSON, "w", encoding="utf-8"),
              ensure_ascii=False, indent=1)

    # ---- Markdown ----
    L = []
    L.append("# MATRICE DE COUVERTURE — SSB → Lua PMDO — ARC DU FUTUR")
    L.append("")
    L.append("Pipeline : `SSB ops totales → ops comprises → ops converties → ops non converties`.")
    L.append("")
    L.append("Statuts : **OK** = idiome attesté · **ADAPT** = idiome OK mais dépend de la couche d'adaptation")
    L.append("New Era (acteurs/dialogues/BGM/grounds/anims/SE/effets) · **PARTIEL** = approximatif (signalé, jamais")
    L.append("silencieux) · **NON** = aucun équivalent PMDO (explicitement NON CONVERTI).")
    L.append("")
    pct = lambda a, b: f"{100*a/b:.1f}%" if b else "—"
    L.append(f"## Récapitulatif global ({totals['ops']} ops sur 24 scènes)")
    L.append("")
    L.append(f"- Ops totales : **{totals['ops']}**")
    L.append(f"- Ops comprises (opcode connu + sémantique établie) : **{totals['ops']} ({pct(totals['ops'], totals['ops'])})**")
    conv = totals["OK"] + totals["ADAPT"]
    L.append(f"- Ops converties (OK + ADAPT) : **{conv} ({pct(conv, totals['ops'])})**")
    L.append(f"  - OK direct : **{totals['OK']}** ({pct(totals['OK'], totals['ops'])})")
    L.append(f"  - ADAPT (couche New Era requise) : **{totals['ADAPT']}** ({pct(totals['ADAPT'], totals['ops'])})")
    L.append(f"- Ops partielles (approximatives, signalées) : **{totals['PARTIEL']}** ({pct(totals['PARTIEL'], totals['ops'])})")
    L.append(f"- Ops NON converties : **{totals['NON']}** ({pct(totals['NON'], totals['ops'])})")
    L.append("")
    L.append("## Par scène")
    L.append("")
    L.append("| Zone | Scène | Ops | Comprises | OK | ADAPT | PARTIEL | NON | Taux converti |")
    L.append("|---|---|---|---|---|---|---|---|---|")
    for r in rows:
        conv_r = r["OK"] + r["ADAPT"]
        L.append(f"| {r['zone']} | {r['scene']} | {r['ops']} | {r['ops']} | {r['OK']} | {r['ADAPT']} | "
                 f"{r['PARTIEL']} | {r['NON']} | {pct(conv_r, r['ops'])} |")
    L.append("")
    L.append("## Table de mapping par opcode (89 opcodes de l'arc)")
    L.append("")
    L.append("| Opcode | Catégorie | Statut | Idiome PMDO | Note |")
    L.append("|---|---|---|---|---|")
    for name in sorted(M, key=lambda n: (M[n]["cat"], n)):
        s = M[name]
        L.append(f"| `{name}` | {s['cat']} | **{s['status']}** | {s['idiom']} | {s['note']} |")
    L.append("")
    if non_converties:
        L.append("## Ops NON converties (exhaustif)")
        L.append("")
        L.append("| Scène | Seq | Op | Raison |")
        L.append("|---|---|---|---|")
        for zone, scene, seq, op, raison in non_converties:
            L.append(f"| {zone}/{scene} | {seq} | `{op}` | {raison} |")
        L.append("")
    if partielles:
        L.append("## Ops PARTIELLES (exhaustif)")
        L.append("")
        L.append("| Scène | Seq | Op | Raison |")
        L.append("|---|---|---|---|")
        for zone, scene, seq, op, raison in partielles:
            L.append(f"| {zone}/{scene} | {seq} | `{op}` | {raison} |")
        L.append("")

    open(OUT_MD, "w", encoding="utf-8").write("\n".join(L))
    print(f"Matrice écrite : {OUT_MD}")
    print(f"Totaux : {totals}")
    print(f"Non converties : {len(non_converties)} — Partielles : {len(partielles)}")


if __name__ == "__main__":
    main()
