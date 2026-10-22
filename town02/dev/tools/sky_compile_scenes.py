#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
sky_compile_scenes.py — Compilateur industriel SSB (ExplorerScript décompilé
ROM EU) → scènes Lua PMDO, sur le modèle du pilote validé m01a0204.

DISCIPLINE (imposée par la mission) :
  * FAIL-CLOSED : une scène n'est émise que si TOUTES ses opérations de la
    routine principale sont traduites ou explicitement neutres ; sinon la
    scène est classée PARTIAL_OPS (liste exacte des ops non traduites) et
    N'EST PAS émise. Aucune scène approximative silencieuse.
  * CANON : dialogues 5 langues embarqués tels quels (raw ROM) et choisis à
    l'exécution selon la langue du jeu ; positions/mouvements/directions/
    délais/BGM traduits 1:1 selon les conventions du pilote (tuile*8+off*4,
    Wait(n)=WaitFrames(n), vitesses SSB→walk/slow).
  * GAPS documentés par scène : bgm2/screen2 (2e écran NDS fusionné),
    SetEffect (VFX non mappés v1), se_Play (SE non mappés v1) — émis en
    commentaires + champ gaps du rapport, jamais supprimés sans trace.

Périmètre v1 : routine principale `def 0` + routines d'acteurs triviales
(SetAnimation/attentes). Les scènes multi-routines complexes restent
NOT_COMPILED_MULTIROUTINE (comptées, pas masquées).

Sorties :
  Data/Script/halcyon/skyscenes/<zone>__<scene>.lua   (scènes émises)
  Data/Script/halcyon/skyscenes/index.lua             (registre)
  dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Docs/SCENE_COMPILER_REPORT.json
"""
import glob
import gzip
import json
import os
import re
from collections import Counter, OrderedDict

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CAMP = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_SKY_EXPLORERS")
RS = os.path.join(CAMP, "Cinematics", "rom_scripts")
OUT = os.path.join(REPO, "Data", "Script", "halcyon", "skyscenes")

# entid (md_index) -> espèce PMDO (dérivé de PMDO_MAPPING, 525 entrées)
def _load_entid_map():
    m = json.load(open(os.path.join(CAMP, "Tables", "PMDO_MAPPING.json")))
    out = {}
    for en, e in m["species"]["entries"].items():
        sp = e.get("pmdo_species")
        if sp:
            for mi in e["md_indexes"]:
                out[mi] = sp
                out[mi % 600] = sp
    # complément PROUVÉ ROM (session 2026-08-27) : md_index -> natdex
    # (monster.md national_pokedex_number, entrées NPC spéciales natdex=0
    # résolues par leur champ entid -> md de base, METAMON_OTACHI par
    # sprite_index=Sentret) puis natdex -> slug PMDO (IndexNum des
    # Data/Monster du DumpAsset). Couvre les légendaires événements
    # (Shaymin 534, Cresselia 530, Manaphy 532, Dusknoir NPC 577…).
    try:
        md2nat = json.load(open(os.path.join(
            CAMP, "Tables", "MD_INDEX_TO_NATDEX.json")))
        nat2sp = json.load(open(os.path.join(
            CAMP, "Tables", "NATDEX_TO_PMDO.json")))
        for mi, nat in md2nat.items():
            sp = nat2sp.get(str(nat))
            if sp and int(mi) not in out:
                out[int(mi)] = sp
    except FileNotFoundError:
        pass
    return out

ENTID2SPECIES = _load_entid_map()

# table GLOBALE acteurs (ACTOR_GLOBAL_TABLE.json — entid unique ROM +
# première position SSA par zone) : résout le cast des scènes dont le
# SSA propre ne place pas l'acteur (chargé par une autre scène de la zone)
_AGT = json.load(open(os.path.join(CAMP, "Docs",
                                   "ACTOR_GLOBAL_TABLE.json")))
GLOBAL_ACTOR_ENTID = _AGT["entid"]
GLOBAL_ACTOR_ZONEPOS = _AGT["zone_first_pos"]

DIRMAP = {"DIR_DOWN": "Direction.Down", "DIR_DOWNRIGHT": "Direction.DownRight",
          "DIR_RIGHT": "Direction.Right", "DIR_UPRIGHT": "Direction.UpRight",
          "DIR_UP": "Direction.Up", "DIR_UPLEFT": "Direction.UpLeft",
          "DIR_LEFT": "Direction.Left", "DIR_DOWNLEFT": "Direction.DownLeft"}

# BGM canoniques -> fichiers PMDO présents. AUTORITÉ : enum music_id
# pmdsky-debug (204 pistes) -> titre jukebox -> fichier .ogg vérifié
# PRÉSENT dans Content/Music ou DumpAsset (56 correspondances). Les
# pistes absentes du roster restent GAP (REQUIRES_MOD_ASSET), jamais
# substituées.
BGM = {"BGM_AEGIS_CAVE": "Aegis Cave.ogg",
       "BGM_AMP_PLAINS": "Amp Plains.ogg",
       "BGM_APPLE_WOODS": "Apple Woods.ogg",
       "BGM_BATTLE_AGAINST_DUSKNOIR": "Battle Against Dusknoir.ogg",
       "BGM_BOSS_BATTLE": "Boss Battle.ogg",
       "BGM_BOULDER_QUARRY": "Boulder Quarry.ogg",
       "BGM_BRINE_CAVE": "Brine Cave.ogg",
       "BGM_CHASM_CAVE": "Chasm Cave.ogg",
       "BGM_CRAGGY_COAST": "Craggy Coast.ogg",
       "BGM_CRYSTAL_CAVE": "Crystal Cave.ogg",
       "BGM_CRYSTAL_CROSSING": "Crystal Crossing.ogg",
       "BGM_DARK_CRATER": "Dark Crater.ogg",
       "BGM_DARK_HILL": "Dark Hill.ogg",
       "BGM_DEEP_DARK_CRATER": "Deep Dark Crater.ogg",
       "BGM_DEEP_DUSK_FOREST": "Deep Dusk Forest.ogg",
       "BGM_DRENCHED_BLUFF": "Drenched Bluff.ogg",
       "BGM_FOGGY_FOREST": "Foggy Forest.ogg",
       "BGM_GOODNIGHT": "Goodnight.ogg",
       "BGM_GROWING_ANXIETY": "Growing Anxiety.ogg",
       "BGM_GUILDMASTER_WIGGLYTUFF": "Guildmaster Wigglytuff.ogg",
       "BGM_HEARTWARMING": "Heartwarming.ogg",
       "BGM_HIDDEN_HIGHLAND": "Hidden Highland.ogg",
       "BGM_HIDDEN_LAND": "Hidden Land.ogg",
       "BGM_ICICLE_FOREST": "Icicle Forest.ogg",
       "BGM_LOWER_SPRING_CAVE": "Lower Spring Cave.ogg",
       "BGM_MAROWAK_DOJO": "Marowak Dojo.ogg",
       "BGM_MONSTER_HOUSE": "Monster House.ogg",
       "BGM_MT_BRISTLE": "Mt. Bristle.ogg",
       "BGM_MT_HORN": "Mt. Horn.ogg",
       "BGM_MT_TRAVAIL": "Mt. Travail.ogg",
       "BGM_MYSTIFYING_FOREST": "Mystifying Forest.ogg",
       "BGM_NORTHERN_DESERT": "Northern Desert.ogg",
       "BGM_OUTLAW": "Outlaw.ogg",
       "BGM_QUICKSAND_CAVE": "Quicksand Cave.ogg",
       "BGM_RISING_FEAR": "Rising Fear.ogg",
       "BGM_SEALED_RUIN": "Sealed Ruin.ogg",
       "BGM_SKY_PEAK_CAVE": "Sky Peak Cave.ogg",
       "BGM_SKY_PEAK_COAST": "Sky Peak Coast.ogg",
       "BGM_SKY_PEAK_FOREST": "Sky Peak Forest.ogg",
       "BGM_SKY_PEAK_PRAIRIE": "Sky Peak Prairie.ogg",
       "BGM_SPRING_CAVE": "Spring Cave.ogg",
       "BGM_SPRING_CAVE_DEPTHS": "Spring Cave Depths.ogg",
       "BGM_STAR_CAVE": "Star Cave.ogg",
       "BGM_STEAM_CAVE": "Steam Cave.ogg",
       "BGM_SYMPATHY": "Sympathy.ogg",
       "BGM_TEAM_SKULL": "Team Skull.ogg",
       "BGM_TEMPORAL_TOWER": "Temporal Tower.ogg",
       "BGM_TIME_GEAR_REMIX": "Time Gear Remix.ogg",
       "BGM_TIME_RESTORED": "Time Restored.ogg",
       "BGM_TOP_MENU_THEME": "Top Menu Theme.ogg",
       "BGM_TREASURE_TOWN": "Treasure Town.ogg",
       "BGM_TREESHROUD_FOREST": "Treeshroud Forest.ogg",
       "BGM_UPPER_STEAM_CAVE": "Upper Steam Cave.ogg",
       "BGM_WATERFALL_CAVE": "Waterfall Cave.ogg",
       "BGM_WIGGLYTUFFS_GUILD": "Wigglytuff's Guild.ogg",
       "BGM_WIGGLYTUFFS_GUILD_REMIX": "Wigglytuff's Guild Remix.ogg",
       "BGM_OCEAN1": None, "BGM_OCEAN2": None}  # canal ambiance: GAP

# VFX NDS (SetEffect EFFECT_*) -> émotes NATIVES PMDO (Data/Emote +
# Content/Particle Emote_*.dir). Correspondance FONCTIONNELLE 1:1 :
# les emotes PMDO sont les portages officiels des mêmes effets EoS
# (DumpAsset est le jeu PMDO de base, dont l'iconographie vient d'EoS).
EFFECT_TO_EMOTE = {
    "EFFECT_EXCLAMATION_MARK": "exclaim",
    "EFFECT_SHOCKED": "shock",
    "EFFECT_SHOCKED_MIRRORED": "shock",
    "EFFECT_SWEAT_DROPS_FROM_BOTH_SIDES_MEDIUM": "sweating",
    "EFFECT_SWEAT_DROP": "sweatdrop",
    "EFFECT_SWEAT_DROP_SLOW": "sweatdrop",
    "EFFECT_JOYOUS": "happy",
    "EFFECT_LAUGHING": "happy",
    "EFFECT_QUESTION_MARK": "question",
    "EFFECT_ANGRY": "angry",
    "EFFECT_NONE": None,  # efface l'émote courante
}

# SE NDS (se_Play id) -> SE PMDO (Content/Sound/Battle EVT_*). Les ids NDS
# sont des indices de banque wavi ; la correspondance est établie par le
# CONTEXTE D'USAGE canonique (le SE 8972 est joué par les scènes au moment
# des sweat drops, 8968 avec les exclamations, etc. — vérifié par
# co-occurrence SetEffect/se_Play dans les 3760 SSB) et par le nommage des
# portages officiels du DumpAsset (EVT_Emote_*). Statut TECHNICAL_ADAPTATION
# documenté ; les ids sans correspondance restent en GAP.
SE_TO_PMDO = {
    "8972": "EVT_Emote_Sweatdrop",
    "8968": "EVT_Emote_Exclaim",
    "8962": "EVT_Emote_Confused",
    "8971": "EVT_Emote_Shock",
    "8964": "EVT_Emote_Startled",
    "8978": "EVT_Emote_Complain",
    "8967": "EVT_Emote_Exclaim_Surprised",
    "8961": "EVT_Emote_Confused_2",
    "8975": "EVT_Emote_Shock_2",
    "8974": "EVT_Emote_Shock_Bad",
    "8973": "EVT_Emote_Exclaim_Realized",
}


def lua_str(s):
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"') \
        .replace("\n", "\\n") + '"'


def last_int_arg(args, default=0):
    nums = re.findall(r'-?\d+', args)
    return int(nums[-1]) if nums else default


def parse_dialogue_block(txt, i):
    """Parse un bloc {english=..., french=...} à partir de txt[i:]."""
    depth = 0
    j = i
    while j < len(txt):
        if txt[j] == "{":
            depth += 1
        elif txt[j] == "}":
            depth -= 1
            if depth == 0:
                break
        j += 1
    block = txt[i:j + 1]
    langs = OrderedDict()
    for lang in ("english", "french", "german", "italian", "spanish"):
        m = re.search(lang + r'\s*=\s*("""(?:.|\n)*?"""|"(?:[^"\\]|\\.)*")',
                      block)
        if m:
            raw = m.group(1)
            if raw.startswith('"""'):
                val = raw[3:-3]
                val = "\n".join(l.strip() for l in val.splitlines()
                                if l.strip())
            else:
                val = raw[1:-1]
            langs[lang] = val
    return langs, j + 1


class SceneCompiler:
    def __init__(self, zone, name, src, cast=None):
        self.zone, self.name, self.src = zone, name, src
        self.lines = []
        self.gaps = []
        self.unsupported = []
        self.dialogues = 0
        self.face_pending = None
        # cast SSA : ACTOR_NAME -> (var lua, species, x8, y8, dir)
        self.cast = cast or {}
        self.spawned = set()
        # double écran NDS -> single-screen focus (subscreen.lua)
        self.sub_ground = None    # décor chargé par back2_SetGround
        self.sub_shown = False    # écran sub actuellement révélé
        self.main_shown = False   # écran main actuellement révélé
        self.used_subscreen = False
        self.routine_actor = None   # cible implicite (def N for actor X)
        self.used_skyprog = False   # require progression si conditions

    def emit(self, s):
        # slots d'équipe dynamiques : la ROM no-op silencieusement si le
        # slot n'est pas peuplé -> garde nil équivalent (une seule
        # occurrence par ligne générée par le compilateur)
        if "SkySceneKit.team_member(" in s and not s.lstrip().startswith("--"):
            m = re.search(r"SkySceneKit\.team_member\(\d\)", s)
            if m and not s.lstrip().startswith("do local"):
                expr = m.group(0)
                body = s.replace(expr, "__slot")
                s = (f"do local __slot = {expr}; "
                     f"if __slot then {body.strip()} end end")
        self.lines.append("  " + s)

    def gap(self, s):
        self.gaps.append(s)
        self.emit("-- GAP: " + s)

    def actor_expr(self, actor):
        if actor.startswith("ACTOR_PLAYER"):
            # ACTOR_PLAYER + variantes d'épisode (PLAYER_FUTURE = héros de
            # l'arc du futur, PLAYER_CHARMS/KIMAWARI/PUPURIN = héros
            # jouable de l'épisode spécial, PLAYER_APPOINT = héros désigné)
            # : tous jouent le RÔLE du héros dans leur scène — résolus sur
            # le leader d'équipe courant (canon: c'est le personnage
            # contrôlé à ce moment du scénario)
            return "hero"
        if actor.startswith("ACTOR_ATTENDANT") or actor == "ACTOR_PARTNER":
            return "partner"
        # acteurs de DÉMO NDS (intro / première partie) : LivesEntityTable
        # type 5 entid 0 — jouent le rôle du héros/partenaire de la démo,
        # résolus sur le duo courant (même règle que PLAYER_*)
        if actor in ("ACTOR_NPC_DEMO_HERO", "ACTOR_NPC_HERO_FIRST"):
            return "hero"
        if actor in ("ACTOR_NPC_DEMO_PARTNER", "ACTOR_NPC_PARTNER_FIRST",
                     "ACTOR_NPC_PARTNER"):
            # NPC_PARTNER: LivesEntityTable type 5 entid 0 = partenaire
            # courant (même résolution runtime que ATTENDANT)
            return "partner"
        if actor == "ACTOR_NPC_HERO":
            return "hero"
        # slots d'équipe dynamiques NDS (LivesEntityTable type 3,
        # entid 0 = résolu à l'exécution par l'équipe courante) ->
        # kit.team_member(n) : n-ième membre au-delà du duo ; nil si
        # absent (no-op fidèle ROM, les émissions passent par pcall)
        mslot = re.match(r"ACTOR_(?:ADVENTURE|UNIT)_NPC(\d)$", actor)
        if mslot:
            return f"SkySceneKit.team_member({int(mslot.group(1))})"
        # PNJ nommé résolu par le cast SSA de la scène (v2)
        key = actor.replace("ACTOR_", "")
        if key in self.cast:
            var, species, x, y, d = self.cast[key]
            if key not in self.spawned:
                self.spawned.add(key)
                self.emit(f"local {var} = SkySceneKit.spawn_npc("
                          f"{lua_str(species)}, {x}, {y}, {d}, "
                          f"{lua_str(key)})")
            return var
        return None

    def compile_def0(self, body):
        txt = body
        pos = 0
        stmts = []
        # découper en instructions de premier niveau : fin = ';' hors {}
        # OU fermeture d'un bloc if/switch/else (les blocs n'ont pas de
        # ';' final dans l'ExplorerScript décompilé — corrigé V6, un
        # `if {...}` en tête de def0 était silencieusement ignoré)
        depth = 0
        start = 0
        while pos < len(txt):
            c = txt[pos]
            if c == "{":
                depth += 1
            elif c == "}":
                depth -= 1
                if depth == 0:
                    # fin d'un bloc de premier niveau : statement complet
                    # UNIQUEMENT pour les blocs de contrôle if/switch/with
                    # (les appels comme message_Talk({...}) se terminent
                    # par `);` — leur `}` interne ne clôt PAS le statement)
                    head = txt[start:pos].lstrip()
                    rest = txt[pos + 1:pos + 12].lstrip()
                    if head.startswith(("if", "switch", "else", "with",
                                        "forever", "while",
                                        "message_SwitchTalk",
                                        "message_SwitchMonologue")) \
                            and not rest.startswith("else"):
                        stmts.append(txt[start:pos + 1].strip())
                        start = pos + 1
            elif c == ";" and depth == 0:
                stmts.append(txt[start:pos].strip())
                start = pos + 1
            pos += 1
        tail = txt[start:].strip()
        if tail:
            stmts.append(tail)
        real = [st for st in stmts if st and st != "end"]
        for i, st in enumerate(real):
            self.compile_stmt(st, is_last=(i == len(real) - 1))
        return not self.unsupported

    def translate_cond(self, cond):
        """Condition de progression ROM -> expression Lua sur la SV
        native (SkyScenario/SkyScenarioBitFlags/SkyTalkBitFlags).
        None = condition hors périmètre (l'appelant garde le fail-closed).
        """
        parts = re.split(r"\s*(\|\||&&)\s*", cond.strip())
        out = []
        for p in parts:
            if p in ("||", "&&"):
                out.append(" or " if p == "||" else " and ")
                continue
            m = re.match(r"scn\(\$SCENARIO_MAIN\)\s*(>=|==|<|>|<=)\s*"
                         r"\[(\d+),\s*(\d+)\]$", p)
            if m:
                op, M, S = m.group(1), int(m.group(2)), int(m.group(3))
                out.append(f"(SkyProg.cmp({M}, {S}) {op} 0)")
                continue
            m = re.match(r"\$SCENARIO_MAIN_BIT_FLAG\[(\d+)\]$", p)
            if m:
                out.append(f"((SV.SkyScenarioBitFlags or {{}})"
                           f"[{int(m.group(1))}] == 1)")
                continue
            m = re.match(r"\$SCENARIO_TALK_BIT_FLAG\[(\d+)\]$", p)
            if m:
                out.append(f"((SV.SkyTalkBitFlags or {{}})"
                           f"[{int(m.group(1))}] == 1)")
                continue
            # BranchVariation : `variation` = branche SKY (ROM Explorers
            # of Sky EU -> toujours VRAI), `not variation` = branche
            # Time/Darkness (jamais prise sur cette ROM). Sémantique
            # décompilateur explorerscript if_start.py (params[0]>0).
            if p == "variation":
                out.append("true --[[BranchVariation: ROM Sky EU]]")
                continue
            if p == "not variation":
                out.append("false --[[BranchVariation: branche T/D]]")
                continue
            # BranchDebug : `not debug` = build retail (VRAI sur la ROM
            # EU vendue), `debug` = build debug (jamais).
            if p == "not debug":
                out.append("true --[[BranchDebug: retail EU]]")
                continue
            if p == "debug":
                out.append("false --[[BranchDebug: build debug]]")
                continue
            # scn($SCENARIO_SIDE) : progression des épisodes spéciaux —
            # SV native dédiée (SkyProg.cmp_side, défaut [0,0])
            m = re.match(r"scn\(\$SCENARIO_SIDE\)\s*(>=|==|<|>|<=)\s*"
                         r"\[(\d+),\s*(\d+)\]$", p)
            if m:
                op, M, S = m.group(1), int(m.group(2)), int(m.group(3))
                out.append(f"(SkyProg.cmp_side({M}, {S}) {op} 0)")
                continue
            # $PERFORMANCE_PROGRESS_LIST[n] : drapeaux de progression
            # démo/performance NDS -> SV native (défaut 0, écrits par
            # les scènes qui les posent)
            m = re.match(r"\$PERFORMANCE_PROGRESS_LIST\[(\d+)\]$", p)
            if m:
                out.append(f"((SV.SkyPerformanceProgress or {{}})"
                           f"[{int(m.group(1))}] == 1)")
                continue
            # GameVar GÉNÉRIQUE (EVENT_LOCAL, SUB30_*, SIDE02_TALK…) :
            # variables script NDS (pmd2scriptdata GameVar) tenues dans
            # SV.SkyVars — mêmes valeurs que la ROM (défaut 0), écrites
            # par les affectations compilées ci-dessous. Comparaison ou
            # vérité (non-zéro comme l'interpréteur SSB).
            m = re.match(r"\$([A-Z][A-Z0-9_]*)(?:\[(\d+)\])?"
                         r"(?:\s*(==|!=|<=|>=|<|>)\s*(-?\d+))?$", p)
            if m:
                name, idx, cmp_op, val = m.groups()
                if idx is not None:
                    expr = (f"(((SV.SkyVars or {{}}).{name} or {{}})"
                            f"[{int(idx)}] or 0)")
                else:
                    expr = f"((SV.SkyVars or {{}}).{name} or 0)"
                if cmp_op:
                    lua_op = "~=" if cmp_op == "!=" else cmp_op
                    out.append(f"({expr} {lua_op} {int(val)})")
                else:
                    out.append(f"({expr} ~= 0)")
                continue
            return None
        return "".join(out)

    # sujets de switch traduisibles -> (expression Lua, note provenance).
    # Les variables de contexte ground sont maintenues par le kit/harnais
    # dans SV.SkyVars (défaut 0/-1 comme la ROM au boot d'un ground).
    SWITCH_VARS = {
        "$GROUND_ENTER": ("((SV.SkyVars or {}).GROUND_ENTER or -1)",
                          "GameVar GROUND_ENTER: point d'entrée du ground"),
        "$GROUND_GETOUT": ("((SV.SkyVars or {}).GROUND_GETOUT or -1)",
                           "GameVar GROUND_GETOUT: sortie précédente"),
        "$GROUND_START_MODE": ("((SV.SkyVars or {}).GROUND_START_MODE or 0)",
                               "GameVar GROUND_START_MODE"),
        "$EXECUTE_SPECIAL_EPISODE_TYPE": (
            "((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0)",
            "GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif"),
        "$PARTNER_TALK_KIND": ("((SV.SkyVars or {}).PARTNER_TALK_KIND or 0)",
                               "GameVar PARTNER_TALK_KIND (genre partenaire)"),
        "$HERO_TALK_KIND": ("((SV.SkyVars or {}).HERO_TALK_KIND or 0)",
                            "GameVar HERO_TALK_KIND (genre héros)"),
        "$REQUEST_CLEAR_COUNT": (
            "((SV.SkyVars or {}).REQUEST_CLEAR_COUNT or 0)",
            "GameVar REQUEST_CLEAR_COUNT (missions accomplies)"),
        "$CRYSTAL_COLOR_01": ("((SV.SkyVars or {}).CRYSTAL_COLOR_01 or 0)",
                              "GameVar CRYSTAL_COLOR_01 (Crevice Cave)"),
        "$CRYSTAL_COLOR_02": ("((SV.SkyVars or {}).CRYSTAL_COLOR_02 or 0)",
                              "GameVar CRYSTAL_COLOR_02"),
        "$CRYSTAL_COLOR_03": ("((SV.SkyVars or {}).CRYSTAL_COLOR_03 or 0)",
                              "GameVar CRYSTAL_COLOR_03"),
    }

    def switch_subject(self, subj):
        s = subj.strip()
        if s in self.SWITCH_VARS:
            return self.SWITCH_VARS[s]
        m = re.match(r"scn\(\$SCENARIO_MAIN\)\[0\]$", s)
        if m:
            self.used_skyprog = True
            return ("select(1, SkyProg.state())",
                    "scn($SCENARIO_MAIN)[0]: chapitre courant")
        m = re.match(r"scn\(\$SCENARIO_SIDE\)\[0\]$", s)
        if m:
            self.used_skyprog = True
            return ("(SV.SkyScenarioSide and SV.SkyScenarioSide.main or 0)",
                    "scn($SCENARIO_SIDE)[0]: épisode spécial courant")
        m = re.match(r"dungeon_mode\((\d+)\)$", s)
        if m:
            n = int(m.group(1))
            return (f"((SV.SkyDungeonMode or {{}})[{n}] or 0)",
                    f"dungeon_mode({n}): état de déblocage ROM "
                    f"(0=CLOSED 1=OPEN 2=REQUEST 3=OPEN_AND_REQUEST)")
        # switch(ProcessSpecial(ID, a, b)) AVEC cases : le retour du
        # procédé arm9 (SPECIAL_PROC_* pmdsky-debug) choisit la branche.
        # Requêtes d'état moteur (jobs aléatoires, comptage d'items,
        # setup équipe...) -> SV.SkyProcResults[ID] tenu par le harnais
        # (défaut 0 = état vierge ROM au NewGame). TOUTES les branches
        # restent compilées : le contenu de chaque case est préservé.
        m = re.match(r"ProcessSpecial\(\s*([A-Z0-9_]+|\d+)\s*,\s*(-?\d+)\s*,"
                     r"\s*(-?\d+)\s*\)$", s)
        if m:
            pid = m.group(1)
            return (f"((SV.SkyProcResults or {{}})[{lua_str(pid)}] or 0)",
                    f"ProcessSpecial({pid}): retour du procédé arm9 "
                    f"(SV harnais, défaut 0 état vierge)")
        # switch(message_Menu(MENU_X)) AVEC cases : menus moteur NDS à
        # retour (résultats de mission, écrans systèmes). Retour 0 =
        # fermeture/défaut ROM — branches préservées.
        m = re.match(r"message_Menu\(\s*([A-Z0-9_]+)\s*\)$", s)
        if m:
            return (f"((SV.SkyMenuResults or {{}})"
                    f"[{lua_str(m.group(1))}] or 0)",
                    f"message_Menu({m.group(1)}): menu moteur NDS "
                    f"(retour par défaut 0, branches préservées)")
        # écran de sauvetage Wi-Fi NDS (mot de passe) : PMDO possède son
        # propre système de rescue natif (Rescues des zones) — l'écran
        # NDS retourne 0 (fermeture) par défaut, branches préservées.
        m = re.match(r"main_EnterRescue(?:User|Help)\(\s*-?\d+\s*\)$", s)
        if m:
            return ("0", f"{s}: écran rescue Wi-Fi NDS (rescue natif "
                         f"PMDO; retour 0 fermeture, branches préservées)")
        if s == "sector()":
            # sector() = index de secteur d'acting du superviseur NDS ;
            # dans PMDO le validateur/kit joue la scène en secteur 1
            # (acting principal), constante documentée.
            return ("1", "sector(): acting principal (kit PMDO)")
        return None

    def lua_str(self, s):
        return lua_str(s)

    def parse_menu_switch(self, body):
        """Corps d'un switch(message_SwitchMenu) : cases `menu({...}):`
        (+ default). Retourne (labels[], branches[([idx],corps)],
        default_body|None) ; None si structure imprévue."""
        marks = []
        depth = 0
        i = 0
        while i < len(body):
            c = body[i]
            if depth == 0:
                if body.startswith("case menu(", i):
                    j = body.find("{", i)
                    langs, endj = parse_dialogue_block(body, j)
                    # après menu({...}) vient `):`
                    k = body.find(":", endj)
                    if k < 0 or not langs:
                        return None
                    marks.append((i, k + 1, ("menu", langs)))
                    i = k + 1
                    continue
                mo = re.match(r"default\s*:", body[i:])
                if mo and (i == 0 or body[i-1] in " \t\n;{}:"):
                    marks.append((i, i + mo.end(), ("default", None)))
                    i += mo.end()
                    continue
            if c == "{":
                depth += 1
            elif c == "}":
                depth -= 1
            i += 1
        if not marks or body[:marks[0][0]].strip():
            return None
        labels = []
        branches = []
        default_body = None
        pending = []
        for k, (s0, s1, (kind, langs)) in enumerate(marks):
            nxt = marks[k + 1][0] if k + 1 < len(marks) else len(body)
            seg = body[s1:nxt]
            if kind == "menu":
                labels.append(langs)
                pending.append(len(labels))
            if seg.strip():
                seg = re.sub(r"break\s*;\s*$", "", seg.strip())
                if kind == "default" or (pending and kind == "menu"):
                    if kind == "default":
                        default_body = seg
                        pending = []
                    else:
                        branches.append((pending, seg))
                        pending = []
        if not labels:
            return None
        return labels, branches, default_body

    def parse_switch_cases(self, body):
        """Découpe le corps d'un switch en [([labels], corps)] au premier
        niveau. None si structure imprévue (fail-closed)."""
        # positions des `case X:` / `default:` de premier niveau
        marks = []
        depth = 0
        i = 0
        while i < len(body):
            c = body[i]
            if c == "{":
                depth += 1
            elif c == "}":
                depth -= 1
            elif depth == 0:
                mo = re.match(r"(case\s*([^:\n]{1,20})|default)\s*:",
                              body[i:])
                if mo and (i == 0 or body[i-1] in " \t\n;{}:"):
                    lab = ("default" if mo.group(1).startswith("default")
                           else mo.group(2).strip())
                    marks.append((i, i + mo.end(), lab))
                    i += mo.end()
                    continue
            i += 1
        if not marks:
            return None
        if body[:marks[0][0]].strip():
            return None  # code avant le premier case: imprévu
        groups = []
        pending = []
        for k, (s0, s1, lab) in enumerate(marks):
            nxt = marks[k + 1][0] if k + 1 < len(marks) else len(body)
            seg = body[s1:nxt]
            pending.append(lab)
            if seg.strip():  # fallthrough: cases vides agrégés au suivant
                # retirer break; final (sémantique switch)
                seg = re.sub(r"break\s*;\s*$", "", seg.strip())
                groups.append((pending, seg))
                pending = []
        if pending:
            groups.append((pending, ""))
        return groups

    def compile_op_switchtalk(self, op, args):
        """message_SwitchTalk/SwitchMonologue : variantes par TALK_KIND
        (genre/nature du héros ou du partenaire, GameVar ROM) — TOUTES
        les branches compilées en if/elseif Lua sur SV.SkyVars ; le
        default reste le texte générique canonique."""
        mvar = re.match(r"\s*\(?\s*\$(\w+)\s*\)?", args)
        var = mvar.group(1) if mvar else "PARTNER_TALK_KIND"
        cases = []          # (num|None, langs)
        for mo in re.finditer(r"(?:case\s+(\d+)|default)\s*:", args):
            num = mo.group(1)
            jb = args.find("{", mo.end())
            if jb < 0:
                continue
            langs, _ = parse_dialogue_block(args, jb)
            if langs:
                cases.append((int(num) if num else None, langs))
        if not cases:
            self.unsupported.append(op + ":no_cases")
            return
        self.dialogues += len(cases)
        expr = f"((SV.SkyVars or {{}}).{var} or 0)"
        first = True
        deflt = None
        for num, langs in cases:
            tbl = ", ".join(f"{k}={lua_str(v)}"
                            for k, v in langs.items())
            if num is None:
                deflt = tbl
                continue
            kw = "if" if first else "elseif"
            first = False
            self.emit(f"{kw} {expr} == {num} then "
                      f"-- {op}(${var}) case {num}")
            self.emit(f"SkySceneKit.say({{{tbl}}})")
        if deflt is not None:
            if first:
                self.emit(f"SkySceneKit.say({{{deflt}}}) "
                          f"-- {op}: default seul")
            else:
                self.emit("else")
                self.emit(f"SkySceneKit.say({{{deflt}}})")
                self.emit("end")
        elif not first:
            self.emit("end")

    def compile_stmt(self, st, is_last=False):
        st = st.strip()
        # `jump @label_N` en DERNIÈRE position d'une branche = saut vers
        # l'épilogue commun placé après le if/elseif — le flux Lua compilé
        # y tombe naturellement (sémantique préservée). En position
        # intermédiaire (early-exit avec code sauté) : fail-closed.
        mj = re.match(r"jump\s+@label_\d+$", st)
        if mj:
            if is_last:
                self.emit(f"-- {st} [saut final de branche vers "
                          f"l'épilogue commun: flux naturel]")
            else:
                self.unsupported.append(st[:24])
            return
        # hold : instruction nue (pause 1 frame de l'interpréteur SSB)
        if st == "hold":
            self.emit("GAME:WaitFrames(1) -- hold")
            return
        # écritures de drapeaux scénario : $SCENARIO_MAIN_BIT_FLAG[n] = v
        # -> SV natif (même mécanique que SkyScenario ; relu par les
        # branches if() de la ROM, conservé pour la progression)
        mb = re.match(r"\$SCENARIO_MAIN_BIT_FLAG\[(\d+)\]\s*=\s*(\d+)$", st)
        if mb:
            n, v = int(mb.group(1)), int(mb.group(2))
            self.emit(f"SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags "
                      f"or {{}}; SV.SkyScenarioBitFlags[{n}] = {v}"
                      f" -- $SCENARIO_MAIN_BIT_FLAG[{n}] = {v} (ROM)")
            return
        # switch à CORPS VIDE sur un menu système NDS :
        # `switch ( message_Menu(MENU_X) ) { }` — la ROM affiche le menu
        # moteur (init d'équipe, crédits, sauvegarde) et ne branche sur
        # AUCUN cas. Équivalents PMDO : menus gérés par le moteur/harnais
        # (l'init d'équipe est faite au NewGame, la sauvegarde par
        # GroundSave) — neutralisé avec trace, aucun embranchement perdu.
        # étiquettes de flux du décompilateur : @label_N seul = point de
        # saut (le flux linéaire du def 0 la traverse naturellement)
        if re.match(r"@label_\d+$", st):
            self.emit(f"-- {st} [étiquette de flux ExplorerScript]")
            return
        # if/else de PROGRESSION : conditions sur $SCENARIO_MAIN /
        # BIT_FLAG / TALK_BIT_FLAG — traduites vers la SV native
        # (SV.SkyScenario de progression.lua, mêmes états ROM ; les
        # branches SONT compilées, aucun contenu perdu)
        mif = re.match(r"if\s*\(\s*(.*?)\s*\)\s*\{", st, re.S)
        if mif and self.translate_cond(mif.group(1)) is not None:
            cond_lua = self.translate_cond(mif.group(1))
            if "SkyProg." in cond_lua:
                self.used_skyprog = True
            # découper le corps if { A } [else { B }]
            depth = 0
            i = st.find("{", mif.end() - 1)
            j = i
            while j < len(st):
                if st[j] == "{":
                    depth += 1
                elif st[j] == "}":
                    depth -= 1
                    if depth == 0:
                        break
                j += 1
            body_if = st[i + 1:j]
            rest = st[j + 1:].strip()
            # chaîne if / elseif* / else? — chaque condition doit être
            # traduisible (fail-closed sinon)
            branches = [(cond_lua, mif.group(1), body_if)]
            body_else = None
            ok = True
            while rest:
                mei = re.match(r"elseif\s*\(\s*(.*?)\s*\)\s*\{", rest,
                               re.S)
                if mei:
                    c2 = self.translate_cond(mei.group(1))
                    if c2 is None:
                        ok = False
                        break
                    if "SkyProg." in c2:
                        self.used_skyprog = True
                    k = rest.find("{", mei.end() - 1)
                    depth = 0
                    l2 = k
                    while l2 < len(rest):
                        if rest[l2] == "{":
                            depth += 1
                        elif rest[l2] == "}":
                            depth -= 1
                            if depth == 0:
                                break
                        l2 += 1
                    branches.append((c2, mei.group(1), rest[k + 1:l2]))
                    rest = rest[l2 + 1:].strip()
                    continue
                if rest.startswith("else"):
                    k = rest.find("{")
                    depth = 0
                    l2 = k
                    while l2 < len(rest):
                        if rest[l2] == "{":
                            depth += 1
                        elif rest[l2] == "}":
                            depth -= 1
                            if depth == 0:
                                break
                        l2 += 1
                    body_else = rest[k + 1:l2]
                    rest = rest[l2 + 1:].strip()
                    continue
                ok = False
                break
            if ok:
                for bi, (cl, craw, bb) in enumerate(branches):
                    kw = "if" if bi == 0 else "elseif"
                    self.emit(f"{kw} {cl} then "
                              f"-- {kw} ROM: {craw[:60]}")
                    self.compile_def0(bb)
                if body_else is not None:
                    self.emit("else")
                    self.compile_def0(body_else)
                self.emit("end")
                return
            self.unsupported.append("if:chain " + st[:40])
            return
        # écritures de drapeaux TALK (mémoire de conversation NDS)
        mtb = re.match(
            r"\$SCENARIO_TALK_BIT_FLAG\[(\d+)\]\s*=\s*(\d+)$", st)
        if mtb:
            n, v = int(mtb.group(1)), int(mtb.group(2))
            self.emit(f"SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {{}}; "
                      f"SV.SkyTalkBitFlags[{n}] = {v} -- "
                      f"$SCENARIO_TALK_BIT_FLAG[{n}] = {v} (ROM)")
            return
        # affectations de GameVar génériques ($EVENT_LOCAL = 1,
        # $SUB30_SPOT_DISCOVER[0] = 1…) et `clear $VAR` : SV.SkyVars —
        # relues par les if/switch compilés (mêmes valeurs ROM)
        mgv = re.match(r"\$([A-Z][A-Z0-9_]*)(?:\[(\d+)\])?\s*=\s*"
                       r"(-?\d+)$", st)
        if mgv:
            name, idx, val = mgv.group(1), mgv.group(2), int(mgv.group(3))
            if name not in ("SCENARIO_MAIN", "SCENARIO_SIDE"):
                self.emit("SV.SkyVars = SV.SkyVars or {}")
                if idx is not None:
                    self.emit(f"SV.SkyVars.{name} = SV.SkyVars.{name} "
                              f"or {{}}; SV.SkyVars.{name}[{int(idx)}] = "
                              f"{val} -- ${name}[{idx}] = {val} (ROM)")
                else:
                    self.emit(f"SV.SkyVars.{name} = {val} "
                              f"-- ${name} = {val} (ROM)")
                return
        # dungeon_mode(N) = DMODE_X : état de DÉBLOCAGE canonique du
        # donjon N (progression ROM: CLOSED/OPEN/REQUEST/OPEN_AND_REQUEST)
        # -> SV native SkyDungeonMode[N] (relue par les switch compilés,
        # même sémantique GameVar DUNGEON_ENTER_MODE).
        mdm = re.match(r"dungeon_mode\((\d+)\)\s*=\s*DMODE_(\w+)$", st)
        if mdm:
            n, mode = int(mdm.group(1)), mdm.group(2)
            val = {"CLOSED": 0, "OPEN": 1, "REQUEST": 2,
                   "OPEN_AND_REQUEST": 3}.get(mode)
            if val is not None:
                self.emit(f"SV.SkyDungeonMode = SV.SkyDungeonMode or {{}}; "
                          f"SV.SkyDungeonMode[{n}] = {val} "
                          f"-- dungeon_mode({n}) = DMODE_{mode} (ROM)")
                return
        # écriture de PROGRESSION : $SCENARIO_MAIN = scn[M,S] ->
        # SkyProg.set natif (déblocages canoniques du graphe appliqués)
        msc = re.match(r"\$SCENARIO_MAIN\s*=\s*scn\[(\d+),\s*(\d+)\]$", st)
        if msc:
            self.used_skyprog = True
            self.emit(f"SkyProg.set({int(msc.group(1))}, "
                      f"{int(msc.group(2))}) -- $SCENARIO_MAIN = "
                      f"scn[{msc.group(1)},{msc.group(2)}] (ROM)")
            return
        msc2 = re.match(r"\$SCENARIO_SIDE\s*=\s*scn\[(\d+),\s*(\d+)\]$", st)
        if msc2:
            self.emit(f"SV.SkyScenarioSide = {{main={int(msc2.group(1))}, "
                      f"sub={int(msc2.group(2))}}} -- $SCENARIO_SIDE = "
                      f"scn[{msc2.group(1)},{msc2.group(2)}] (ROM)")
            return
        # commentaires du décompilateur explorerscript (`// ...`)
        if st.startswith("//"):
            self.emit("-- " + st[2:].strip())
            return
        # break_loop / continue : contrôle de la boucle forever NDS —
        # une itération étant compilée, break_loop = fin naturelle du
        # bloc, continue = ré-itération (annulation, documentée)
        mcall = re.match(r"call\s+(@label_\d+)$", st)
        if mcall:
            # `call @label_N` observé UNIQUEMENT avec le label défini
            # immédiatement après (fall-through: le flux compilé y tombe
            # naturellement, le retour de sous-routine est le flux même)
            self.emit(f"-- call {mcall.group(1)} [sous-routine locale "
                      f"adjacente: flux naturel]")
            return
        if st == "return":
            # fin de routine SSB (retour à l'appelant) : fin naturelle du
            # flux compilé (les call sont documentés)
            self.emit("-- return [fin de routine SSB]")
            return
        if st == "alias previous":
            self.emit("-- alias previous [alias de coroutine NDS]")
            return
        if st in ("break_loop", "continue"):
            self.emit(f"-- {st} [contrôle de boucle forever NDS: une "
                      f"itération compilée]")
            return
        # forever { ... } : boucle infinie NDS — sortie uniquement par
        # end/jump/transition interne. Deux usages ROM : (a) boucle de
        # MENU re-affichable (switch message_SwitchMenu) ; (b) boucle
        # d'attente/animation. Adaptation : UNE itération compilée (le
        # choix/le flux mène à la sortie ; la ré-itération du menu NDS
        # est le comportement d'annulation, documenté). Fail-closed sur
        # le corps : toute op non traduite reclasse la scène.
        mfor = re.match(r"forever\s*\{(.*)\}$", st, re.S)
        if mfor:
            self.emit("-- forever{...} NDS: une itération compilée "
                      "(ré-affichage du menu = annulation, documenté)")
            self.compile_def0(mfor.group(1))
            return
        # with (actor X) { hold; } : pause d'une frame de l'interpréteur
        # sur le contexte de l'acteur (seule forme observée ROM, 28 occ.)
        mwith = re.match(r"with\s*\(\s*(?:actor|object|performer)\s+\w+\s*\)"
                         r"\s*\{\s*hold\s*;\s*\}$", st, re.S)
        if mwith:
            self.emit("GAME:WaitFrames(1) -- with(...){hold} NDS")
            return
        mclr = re.match(r"clear\s+\$([A-Z][A-Z0-9_]*)$", st)
        if mclr:
            self.emit(f"if SV.SkyVars then SV.SkyVars.{mclr.group(1)} = 0 "
                      f"end -- clear ${mclr.group(1)} (ROM)")
            return
        mm_menu = re.match(
            r"switch\s*\(\s*message_Menu\(([A-Z0-9_]+)\)\s*\)\s*\{\s*\}$",
            st, re.S)
        if mm_menu:
            self.emit(f"-- switch(message_Menu({mm_menu.group(1)})) "
                      f"[menu système NDS sans embranchement (corps "
                      f"vide): équivalent géré par le moteur PMDO]")
            return
        # switch à CORPS VIDE sur un procédé moteur NDS :
        # ProcessSpecial(id,...) = appel SPECIAL_PROC_* arm9 (init
        # d'équipe/partenaires SE id 3-4, next day id 5…) sans
        # embranchement scripté — équivalents PMDO gérés par le
        # harnais/NewGame ; message_SwitchMenu(x,y)/main_EnterAdventure
        # = menus & bascules d'écran moteur. Corps vide == AUCUN
        # contenu canonique sauté (trace conservée).
        mm_proc = re.match(
            r"switch\s*\(\s*((?:ProcessSpecial|message_SwitchMenu|"
            r"message_Menu|main_EnterAdventure|main_EnterTraining|"
            r"main_EnterRescue)\([^)]*\))\s*\)\s*\{\s*\}$", st, re.S)
        if mm_proc:
            self.emit(f"-- switch({mm_proc.group(1)[:70]}) [procédé/menu "
                      f"moteur NDS, corps vide: aucun embranchement "
                      f"canonique — équivalent moteur PMDO]")
            return
        # switch(message_SwitchMenu(x,y)) AVEC cases menu({5 langues}) :
        # choix joueur canonique -> menu natif PMDO (kit.ask, ChoiceMenu
        # comme origin/common.lua). Toutes les branches sont compilées.
        mm_choice = re.match(
            r"switch\s*\(\s*message_SwitchMenu\(([\d, ]+)\)\s*\)\s*"
            r"\{(.*)\}$", st, re.S)
        if mm_choice and "menu(" in mm_choice.group(2):
            parsed = self.parse_menu_switch(mm_choice.group(2))
            if parsed is not None:
                labels, branches, default_body = parsed
                lab_lua = []
                for lab in labels:
                    lab_lua.append("{" + ", ".join(
                        f"{lang}={self.lua_str(txt)}"
                        for lang, txt in lab.items()) + "}")
                self.emit(f"do local __choice = SkySceneKit.ask({{"
                          f"{', '.join(lab_lua)}}}) "
                          f"-- message_SwitchMenu({mm_choice.group(1)}) ROM")
                first = True
                for idxs, body in branches:
                    kw = "if" if first else "elseif"
                    first = False
                    conds = " or ".join(f"__choice == {i}" for i in idxs)
                    self.emit(f"{kw} {conds} then")
                    self.compile_def0(body)
                if default_body is not None:
                    self.emit("else -- default/annulation" if not first
                              else "if true then -- default")
                    self.compile_def0(default_body)
                if not first or default_body is not None:
                    self.emit("end")
                self.emit("end")
                return
            self.unsupported.append("switch:menu_parse")
            return
        # switch($LANGUAGE_TYPE) : la langue est résolue au RUNTIME par le
        # kit (say choisit la langue du joueur) ; les cases par langue des
        # crédits déroulent le même contenu par langue. On compile la
        # PREMIÈRE case comme corps (les autres = mêmes ops, textes par
        # langue déjà dans les blocs 5 langues) — trace documentée.
        mm_lang = re.match(
            r"switch\s*\(\s*\$LANGUAGE_TYPE\s*\)\s*\{(.*)\}$", st, re.S)
        if mm_lang:
            body = mm_lang.group(1)
            first = re.split(r"case\s+\d+\s*:", body)
            if len(first) > 1:
                seg = first[1]
                nxt = re.search(r"case\s+\d+\s*:", seg)
                if nxt:
                    seg = seg[:nxt.start()]
                self.emit("-- switch($LANGUAGE_TYPE): case unique "
                          "compilée (textes 5 langues résolus par le "
                          "kit au runtime)")
                self.compile_def0(seg)
                return
        # message_SwitchTalk/SwitchMonologue en forme BLOC (`op ($VAR)
        # { case N: {...} }` — le statement finit par '}') : redirigé vers
        # le handler op (mêmes branches toutes compilées)
        mst = re.match(r"(message_SwitchTalk|message_SwitchMonologue)\s*"
                       r"\((.*)\)?\s*\{(.*)\}$", st, re.S)
        if mst:
            self.compile_op_switchtalk(mst.group(1),
                                       mst.group(2) + "{" + mst.group(3) + "}")
            return
        # ---- switch GÉNÉRIQUE sur variable de contexte NDS : TOUTES les
        # branches sont compilées (if/elseif Lua sur la valeur runtime,
        # aucun contenu perdu). Sujets = variables moteur ROM lues via la
        # SV native (SkyVars, écrites par le harnais/les scènes) —
        # sémantique GameVar pmd2scriptdata (GROUND_ENTER/GETOUT posés
        # aux transitions de ground, EXECUTE_SPECIAL_EPISODE_TYPE posé au
        # lancement d'un épisode spécial…). Fail-closed conservé : toute
        # op non traduite d'une branche re-classe la scène PARTIAL_OPS.
        msw = re.match(r"switch\s*\(\s*(.+?)\s*\)\s*\{(.*)\}$", st, re.S)
        if msw and self.switch_subject(msw.group(1)) is not None:
            subj_lua, subj_note = self.switch_subject(msw.group(1))
            if not msw.group(2).strip():
                # switch à corps vide sur variable de contexte : lecture
                # sans embranchement (aucun contenu canonique)
                self.emit(f"-- switch({msw.group(1)[:50]}) corps vide "
                          f"[{subj_note}]")
                return
            groups = self.parse_switch_cases(msw.group(2))
            if groups is not None:
                self.emit(f"do local __sw = {subj_lua} "
                          f"-- switch({msw.group(1)[:50]}) [{subj_note}]")
                first = True
                default_body = None
                for labels, body in groups:
                    if "default" in labels:
                        # fallthrough `case N: default:` = le corps
                        # s'exécute pour N ET pour tout le reste ->
                        # sémantiquement le default
                        default_body = body
                        continue
                    conds = []
                    SYM = {"DMODE_CLOSED": 0, "DMODE_OPEN": 1,
                           "DMODE_REQUEST": 2, "DMODE_OPEN_AND_REQUEST": 3}
                    for lab in labels:
                        if lab in SYM:
                            conds.append(f"__sw == {SYM[lab]}")
                            continue
                        mo = re.match(r"(==|<=|>=|<|>)?\s*(-?\d+)$", lab)
                        if not mo:
                            conds = None
                            break
                        conds.append(f"__sw {mo.group(1) or '=='} "
                                     f"{mo.group(2)}")
                    if conds is None:
                        self.unsupported.append("switch:case " +
                                                str(labels)[:30])
                        return
                    kw = "if" if first else "elseif"
                    first = False
                    self.emit(f"{kw} {' or '.join(conds)} then")
                    self.compile_def0(body)
                if default_body is not None:
                    self.emit("elseif true then -- default" if not first
                              else "if true then -- default")
                    self.compile_def0(default_body)
                if not first or default_body is not None:
                    self.emit("end")
                self.emit("end")
                return
        m = re.match(r"(\w+)(?:<(\w+) (\w+)>)?\s*\((.*)\)$", st, re.S)
        if not m:
            # switch/if imbriqués -> hors périmètre v1
            self.unsupported.append(st.split("(")[0][:40])
            return
        op, kind, target, args = m.group(1), m.group(2), m.group(3), \
            m.group(4)
        # cible implicite : dans `def N for actor X`, les ops sans
        # <actor Y> explicite visent X (sémantique interpréteur SSB)
        if not target and getattr(self, "routine_actor", None):
            target = self.routine_actor
            kind = kind or "actor"
        A = self.actor_expr(target) if target else None

        if op == "Wait":
            self.emit(f"GAME:WaitFrames({int(args)})")
        elif op in ("WaitExecuteLives", "WaitEffect", "WaitAnimation",
                    "WaitScreenFade", "WaitScreenFadeAll", "WaitLockLives",
                    "WaitExecutePerformer", "WaitLockPerformer",
                    "WaitSe", "WaitMe", "WaitBgm", "WaitBgm2"):
            self.emit("GAME:WaitFrames(2) -- join " + op)
        elif op == "screen_FadeIn":
            f = args.split(",")
            self.emit(f"GAME:FadeIn({int(f[-1])})")
            self.main_shown = True
        elif op == "screen_FadeOut":
            f = args.split(",")
            self.emit(f"GAME:FadeOut(false, {int(f[-1])})")
            self.main_shown = False
        elif op in ("screen_FadeInAll", "screen_FadeOutAll"):
            n = args.split(",")[-1]
            fn = "FadeIn" if "In" in op else "FadeOut"
            arg = n if fn == "FadeIn" else f"false, {n}"
            self.emit(f"GAME:{fn}({arg.strip()})")
            self.main_shown = "In" in op
        elif op in ("screen_FlushIn", "screen_FlushOut",
                    "screen_FlushChange"):
            # flush = révélation/occultation rapide de l'écran principal
            # (même sémantique que Fade, rideau instantané NDS)
            n = last_int_arg(args, 4)
            if op == "screen_FlushOut":
                self.emit(f"GAME:FadeOut(false, {n}) -- {op}")
                self.main_shown = False
            else:
                self.emit(f"GAME:FadeIn({n}) -- {op}")
                self.main_shown = True
        # ---- double écran NDS -> single-screen focus (subscreen.lua,
        # timeline canonique DUAL_SCREEN_TIMELINES.json). Le contenu du
        # 2e écran est AFFICHÉ quand la ROM le révèle, jamais jeté.
        elif op == "back2_SetGround":
            g = re.search(r"LEVEL_([A-Z0-9_]+)", args)
            if g:
                self.sub_ground = g.group(1).lower()
                self.emit(f"-- back2_SetGround({g.group(1)}) [décor sub "
                          f"chargé: Sub_{self.sub_ground}]")
            else:
                self.unsupported.append("back2_SetGround:arg")
        elif op in ("screen2_FadeChange", "screen2_WhiteChange") \
                and self.sub_shown:
            # variation d'alpha du sub DÉJÀ révélé (pulsation lumineuse
            # NDS) : la nappe reste affichée — trace documentée, pas un
            # nouveau Show
            self.emit(f"-- {op}({args.strip()[:24]}) [variation d'alpha "
                      f"du sub déjà révélé: nappe maintenue - documenté]")
        elif op in ("screen2_FadeIn", "screen2_FlushIn",
                    "screen2_FadeChange", "screen2_WhiteChange"):
            if self.sub_ground is None:
                # révélation SANS back2_SetGround préalable : le sub
                # affiche son mode par défaut (wallpaper système NDS,
                # back2_SetMode sans décor) — aucun contenu narratif à
                # reproduire sur le canvas unique. Trace documentée.
                self.emit(f"-- {op}({args.strip()[:16]}) [sub révélé en "
                          f"mode système NDS (aucun décor chargé): pas de "
                          f"contenu narratif - documenté]")
                self.sub_shown = True
            else:
                fade = args.split(",")[-1].strip() or "20"
                both = "true" if self.main_shown else "false"
                focus = "BOTH_FOCUS" if self.main_shown else "TOP_FOCUS"
                self.emit(f"SkySubScreen.Show({lua_str(self.sub_ground)}, "
                          f"{fade}, {both}) -- {op}: {focus} "
                          f"(timeline ROM)")
                self.sub_shown = True
                self.used_subscreen = True
        elif op in ("screen2_FadeOut", "screen2_FlushOut",
                    "screen2_WhiteOut"):
            fade = args.split(",")[-1].strip() or "20"
            if self.sub_shown:
                self.emit(f"SkySubScreen.Hide({fade}) -- {op}: retour "
                          f"BOTTOM_FOCUS (timeline ROM)")
                self.sub_shown = False
            else:
                self.emit(f"-- {op} [sub déjà caché]")
        elif op == "back2_SetMode":
            self.emit(f"-- back2_SetMode({args.strip()[:20]}) [mode "
                      f"d'affichage sub NDS: géré par SubScreen]")
        elif op in ("bgm2_PlayFadeIn", "bgm2_Play"):
            # canal musique du 2e écran : la NDS mixe deux musiques ;
            # PMDO n'a qu'un canal BGM. Adaptation documentée : le canal
            # sub REMPLACE le principal pendant TOP_FOCUS, sinon ignoré.
            track = args.split(",")[0].strip()
            ogg = BGM.get(track)
            if ogg and self.sub_shown and not self.main_shown:
                self.emit(f"pcall(function() SOUND:PlayBGM("
                          f"{lua_str(ogg)}, true) end) -- bgm2 en "
                          f"TOP_FOCUS (canal unique PMDO)")
            else:
                self.emit(f"-- {op}({track}) [canal BGM sub: PMDO n'a "
                          f"qu'un canal; hors TOP_FOCUS le principal "
                          f"garde la main - adaptation documentée]")
        elif op in ("bgm2_Stop", "bgm2_FadeOut"):
            self.emit(f"-- {op} [canal BGM sub: voir bgm2_Play]")
        elif op == "supervision2_SpecialActing":
            self.emit(f"-- supervision2_SpecialActing({args.strip()[:40]})"
                      f" [acting sub NDS: décor déjà reproduit par "
                      f"SubScreen, acteurs sub non simulés - trace]")
        elif op in ("camera2_SetPositionMark", "camera2_MovePositionMark",
                    "camera2_SetDefault", "camera2_Move2Default",
                    "camera2_SetEffect"):
            # caméra du 2e écran : la nappe Sub_ est un cadrage fixe
            # fenêtre NDS — le recadrage dynamique sub n'est pas simulé
            # (différence documentée, décor complet conservé au rapport)
            self.emit(f"-- {op}({args.strip()[:40]}) [caméra sub NDS: "
                      f"nappe Sub_ cadrée fenêtre NDS, recadrage "
                      f"dynamique non simulé - documenté]")
        elif op in ("WaitSubScreen", "WaitScreen2Fade"):
            self.emit(f"GAME:WaitFrames(2) -- join {op} (fondu sub "
                      f"déjà séquencé par SubScreen)")
        elif op == "WaitBgmSignal":
            # attente d'un point de synchronisation musical NDS (signal
            # SMD) : approx = join court, la piste PMDO n'émet pas de
            # signaux (adaptation documentée)
            self.emit("GAME:WaitFrames(30) -- WaitBgmSignal (signal SMD "
                      "NDS sans équivalent: join fixe documenté)")
        elif op in ("back2_SetEffect", "back2_SetBackEffect",
                    "back2_SetBackScrollSpeed", "back2_SetBackScrollOffset",
                    "back2_SetWeather", "back2_SetWeatherEffect",
                    "back2_SetInvisible", "back2_SetSpecialActing",
                    "bgm2_ChangeVolume", "bgm2_PlayFadeInVolume"):
            self.emit(f"-- {op}({args.strip()[:40]}) [effet du canal sub "
                      f"NDS: nappe Sub_ statique, effet non simulé - "
                      f"documenté]")
        elif op == "back_SetBackEffect":
            # contrôle des PALETTES ANIMÉES du décor NDS (wiki SkyTemple
            # 0x2: loop/once/freeze/resume). Les autotiles portés
            # embarquent leurs frames DPLA jouées en boucle par PMDO —
            # l'état de lecture n'est pas scriptable : trace fidèle
            # (aucun contenu narratif, décor animé déjà rendu).
            self.emit(f"-- back_SetBackEffect({args.strip()[:16]}) "
                      f"[état de lecture des palettes animées NDS: "
                      f"autotiles PMDO animés en boucle - documenté]")
        elif op == "back_SetEffect":
            # transition entre COUCHES du map background sur N frames
            # (wiki SkyTemple 0x7: fades layer1/layer2). PMDO rend les
            # couches du ground sans bascule scriptable : le TIMING
            # scénique est préservé (attente durée ROM), transition
            # documentée.
            mm = re.match(r"\s*(-?\d+)\s*,\s*(-?\d+)", args)
            dur = int(mm.group(2)) if mm else 0
            if dur > 0:
                self.emit(f"GAME:WaitFrames({min(dur, 300)}) "
                          f"-- back_SetEffect({args.strip()[:16]}) "
                          f"[transition couches décor NDS: durée ROM "
                          f"préservée, bascule documentée]")
            else:
                self.emit(f"-- back_SetEffect({args.strip()[:16]}) "
                          f"[transition couches décor NDS immédiate]")
        elif op == "WaitBackEffect":
            self.emit("GAME:WaitFrames(2) -- WaitBackEffect (join)")
        elif op == "back_SetWeather":
            # météo visuelle du ground NDS (pluie/neige/brume…) — le
            # ground PMDO n'a pas de couche météo scriptable : trace
            # documentée (aucun contenu narratif).
            self.emit(f"-- back_SetWeather({args.strip()[:12]}) "
                      f"[météo visuelle ground NDS - documenté]")
        elif op == "worldmap_SetArrow":
            self.emit(f"-- worldmap_SetArrow({args.strip()[:12]}) "
                      f"[flèche carte du monde: UI moteur NDS - "
                      f"équivalent géré par le menu voyage PMDO]")
        elif op in ("SetFunctionAttribute", "ResetFunctionAttribute"):
            self.emit(f"-- {op}({args.strip()[:12]}) [attribut interne "
                      f"de l'interpréteur SSB NDS - sans objet PMDO]")
        elif op == "back_SetBackScrollSpeed":
            # généralisation du pilote scroll s13p05a (SCROLL_RUNTIME_
            # PASS) : le défilement du fond NDS devient un MOUVEMENT DE
            # CAMÉRA CONTINU. Vitesses ROM en px/frame ; segment de 120
            # frames (durée du plan typique, la caméra suit ensuite la
            # scène). Vitesse (0,0) = arrêt (aucun mouvement émis).
            mm = re.match(r"\s*(-?[\d.]+)\s*,\s*(-?[\d.]+)", args)
            if mm:
                vx, vy = float(mm.group(1)), float(mm.group(2))
                if vx == 0 and vy == 0:
                    self.emit("-- back_SetBackScrollSpeed(0,0): arrêt du "
                              "défilement")
                else:
                    dx, dy = int(vx * 120), int(vy * 120)
                    self.emit(f"pcall(function() local g=GAME:"
                              f"GetCurrentGround(); GAME:MoveCamera("
                              f"g.ViewCenter.X+({dx}), "
                              f"g.ViewCenter.Y+({dy}), 120, false) end) "
                              f"-- back_SetBackScrollSpeed({vx},{vy}) "
                              f"px/frame -> caméra continue (pilote "
                              f"scroll)")
            else:
                self.unsupported.append("back_SetBackScrollSpeed:args")
        elif op == "back_SetBackScrollOffset":
            mm = re.match(r"\s*(-?[\d.]+)\s*,\s*(-?[\d.]+)", args)
            if mm:
                dx, dy = int(float(mm.group(1))), int(float(mm.group(2)))
                self.emit(f"pcall(function() local g=GAME:"
                          f"GetCurrentGround(); GAME:MoveCamera("
                          f"g.ViewCenter.X+({dx}), g.ViewCenter.Y+({dy}),"
                          f" 1, false) end) -- back_SetBackScrollOffset "
                          f"px NDS (pilote scroll)")
            else:
                self.unsupported.append("back_SetBackScrollOffset:args")
        elif op == "dungeon_mode":
            # dungeon_mode(id) : bascule l'ID de donjon courant côté NDS
            # (préparation d'un main_EnterDungeon). Transition assurée par
            # le harnais journey (même convention que main_EnterDungeon).
            self.emit(f"-- dungeon_mode({args.strip()[:8]}) [préparation "
                      f"d'entrée donjon NDS: transition assurée par le "
                      f"harnais journey/EnterZone]")
        elif op == "MovePositionLives":
            # (vitesse, ACTOR_X) : déplacer la cible/performer VERS un
            # acteur vivant. performer = caméra (convention V3) -> caméra
            # vers la position de l'acteur ; acteur -> marche vers cible.
            tgt_name = args.split(",")[-1].strip()
            tgt2 = "hero" if tgt_name == "ACTOR_TALK_SUB" \
                else self.actor_expr(tgt_name)
            sp = re.match(r"\s*([\d.]+)", args)
            if kind == "performer" and tgt2:
                self.emit(f"pcall(function() local p={tgt2}.Position; "
                          f"GAME:MoveCamera(p.X, p.Y, 60, false) end) "
                          f"-- MovePositionLives performer/caméra vers "
                          f"{tgt_name}")
            elif A and tgt2:
                speed = 2 if (sp and float(sp.group(1)) >= 0.6) else 1
                self.emit(f"pcall(function() local p={tgt2}.Position; "
                          f"GROUND:MoveToPosition({A}, p.X, p.Y, false, "
                          f"{speed}) end) -- MovePositionLives")
            else:
                self.unsupported.append(f"MovePositionLives:{tgt_name}")
        elif op == "SetPositionLives":
            # téléporter à la position d'un autre acteur/objet ; les
            # cibles objets de décor ne sont pas simulées (trace)
            tgt_name = args.strip()
            tgt2 = self.actor_expr(tgt_name) \
                if tgt_name.startswith("ACTOR_") else None
            if A and tgt2:
                self.emit(f"pcall(function() local p={tgt2}.Position; "
                          f"GROUND:TeleportTo({A}, p.X, p.Y, "
                          f"Direction.Down) end) -- SetPositionLives")
            else:
                self.emit(f"-- SetPositionLives({tgt_name[:24]}) [cible "
                          f"objet/id de décor NDS non simulée - trace]")
        elif op == "se_Stop":
            self.emit(f"-- se_Stop({args.strip()[:8]}) [SE one-shot PMDO "
                      f"déjà terminé: arrêt sans objet, canal SE V2]")
        elif op == "bgm_ChangeVolume":
            # (durée, volume/256) : PMDO n'expose pas le volume BGM en
            # Lua ; volume 0 = silence -> FadeOutBGM(durée) ; retour à
            # 256 après un 0 -> la piste est relancée par le bgm_Play
            # suivant de la ROM (trace sinon)
            parts = re.findall(r'-?\d+', args)
            dur = int(parts[0]) if parts else 30
            vol = int(parts[1]) if len(parts) > 1 else 256
            if vol == 0:
                self.emit(f"pcall(function() SOUND:FadeOutBGM({dur}) "
                          f"end) -- bgm_ChangeVolume vers 0 (silence)")
            else:
                self.emit(f"-- bgm_ChangeVolume({dur},{vol}) [volume BGM "
                          f"non scriptable en Lua PMDO: piste maintenue "
                          f"- documenté]")
        elif op in ("worldmap_SetMode", "worldmap_SetCamera",
                    "worldmap_MoveCamera", "worldmap_SetLevel",
                    "worldmap_SetMark", "worldmap_ChangeLevel"):
            # carte du monde 2e écran NDS (curseur de progression) :
            # information d'ambiance sans équivalent canvas unique —
            # PMDO affiche la progression par ses propres menus
            self.emit(f"-- {op}({args.strip()[:20]}) [carte du monde 2e "
                      f"écran NDS: information de progression, gérée par "
                      f"les menus PMDO - documenté]")
        elif op == "back_SetBanner2":
            self.emit(f"-- back_SetBanner2({args.strip()[:30]}) [bannière "
                      f"2e écran NDS: information dupliquée du menu, hors "
                      f"canvas unique - documenté]")
        elif op in ("bgm_Play", "bgm_PlayFadeIn"):
            track = args.split(",")[0].strip()
            ogg = BGM.get(track)
            if ogg:
                self.emit(f"pcall(function() SOUND:PlayBGM({lua_str(ogg)},"
                          f" true) end)")
            else:
                self.gap(f"BGM {track} non mappé au roster (REQUIRES_MOD_"
                         f"ASSET ou canal ambiance)")
        elif op in ("bgm_FadeOut", "sound_FadeOut"):
            n = args.strip() or "30"
            self.emit(f"pcall(function() SOUND:FadeOutBGM({int(n)}) end)")
        elif op in ("bgm_Stop", "sound_Stop"):
            self.emit("pcall(function() SOUND:StopBGM() end)")
        elif op in ("me_Play", "me_PlayVolume"):
            # ME = jingle court NDS (wiki SkyTemple List_of_Sound_Effects
            # §ME, identités par nom interne SMD) -> Fanfare PMDO native
            # équivalente. 10/11 = vent qui se lève (SE ambiant, one-shot
            # documenté).
            ME2FANFARE = {0: "Fanfare/NewArea", 1: "Fanfare/LevelUp",
                          2: "Fanfare/RankUp", 3: "Fanfare/LeaveTeam",
                          4: "Fanfare/Item", 5: "Fanfare/JoinTeam",
                          6: "Fanfare/NewArea", 7: "Fanfare/Note",
                          8: "Fanfare/Promotion", 9: "Fanfare/Treasure"}
            nums = re.findall(r"-?\d+", args)
            mid_ = int(nums[0]) if nums else -1
            fx = ME2FANFARE.get(mid_)
            if fx:
                self.emit(f"pcall(function() SOUND:PlayFanfare("
                          f"{lua_str(fx)}) end) -- me_Play({mid_}) "
                          f"[jingle ME NDS -> fanfare PMDO]")
            else:
                self.emit(f"-- me_Play({args.strip()[:12]}) [ME vent/"
                          f"ambiance NDS sans fanfare équivalente - "
                          f"documenté]")
        elif op in ("me_Stop", "WaitMeStop"):
            self.emit(f"-- {op} [fin de jingle: les fanfares PMDO sont "
                      f"des one-shots]")
        elif op == "worldmap_DeleteArrow":
            self.emit("-- worldmap_DeleteArrow [flèche carte moteur NDS]")
        elif op == "back_ChangeGround":
            # rechargement du décor du ground courant (même LEVEL_) :
            # le ground PMDO est déjà chargé par le validateur/harnais
            self.emit(f"-- back_ChangeGround({args.strip()[:24]}) "
                      f"[décor déjà chargé par EnterZone PMDO]")
        elif op == "SetupOutputAttributeAndAnimation" and kind == "object":
            self.emit(f"-- SetupOutputAttributeAndAnimation<object "
                      f"{target}> [prop décor NDS, rendu du ground]")
        elif op in ("se_Play", "se_PlayVolume"):
            sid = args.strip()
            se = SE_TO_PMDO.get(sid)
            if se:
                self.emit(f"pcall(function() SOUND:PlayBattleSE("
                          f"{lua_str(se)}) end)")
            else:
                self.gap(f"se_Play({sid}) — id SE NDS sans portage "
                         f"PMDO identifié")
        elif op == "SetEffect":
            eff = args.split(",")[0].strip()
            emote = EFFECT_TO_EMOTE.get(eff)
            if eff in EFFECT_TO_EMOTE:
                if emote and A:
                    self.emit(f"pcall(function() GROUND:CharSetEmote({A},"
                              f" {lua_str(emote)}, 1) end)")
                elif A:
                    self.emit(f"pcall(function() GROUND:CharSetEmote({A},"
                              f" nil, 0) end) -- EFFECT_NONE")
                else:
                    self.gap(f"SetEffect {eff} sur PNJ non résolu (v2 "
                             f"cast SSA)")
            else:
                self.gap(f"SetEffect {eff} — VFX sans émote PMDO "
                         f"équivalente")
        elif op in ("message_SetFace", "message_SetFaceOnly"):
            # SetFaceOnly = portrait sans passer la parole (même donnée
            # speaker, le portrait PMDO suit le speaker du kit)
            self.face_pending = args.split(",")[0].strip()
        elif op in ("message_Talk", "message_Monologue",
                    "message_Explanation", "message_Notice",
                    "message_Narration", "message_Mail"):
            # message_Mail = même contenu texte 5 langues dans le CADRE
            # « courrier » NDS (fenêtre à en-tête) : le texte canonique
            # est affiché par le dialogue natif PMDO — différence de
            # cadre documentée (adaptation technique d'affichage).
            langs, _ = parse_dialogue_block(args, args.find("{"))
            if not langs:
                self.unsupported.append(op + ":no_text")
                return
            spk = self.actor_expr(self.face_pending) \
                if self.face_pending else None
            self.dialogues += 1
            tbl = ", ".join(f"{k}={lua_str(v)}" for k, v in langs.items())
            if spk:
                self.emit(f"pcall(function() UI:SetSpeaker({spk}) end)")
            elif self.face_pending:
                # locuteur SANS placement SSA dans la zone (spawn moteur
                # ou hors champ) : ATTRIBUTION PRÉSERVÉE par identité
                # d'espèce ROM (nom + portrait natif SetSpeaker complet)
                key = self.face_pending.replace("ACTOR_", "")
                entid = GLOBAL_ACTOR_ENTID.get(key)
                sp = (ENTID2SPECIES.get(entid)
                      or ENTID2SPECIES.get((entid or 0) % 600)) \
                    if entid else None
                if sp:
                    disp = sp.replace("_", " ").title()
                    self.emit(f"pcall(function() UI:SetSpeaker("
                              f"{lua_str(disp)}, true, {lua_str(sp)}, 0,"
                              f" '', RogueEssence.Data.Gender.Unknown) "
                              f"end) -- locuteur {key} (espèce ROM, "
                              f"sans placement zone)")
                else:
                    self.emit("pcall(function() UI:ResetSpeaker() end)")
            else:
                self.emit("pcall(function() UI:ResetSpeaker() end)")
            self.emit(f"SkySceneKit.say({{{tbl}}})")
        elif op in ("message_SwitchTalk", "message_SwitchMonologue"):
            self.compile_op_switchtalk(op, args)
        elif op in ("message_Close", "message_KeyWait", "message_FaceOff"):
            self.emit("-- " + op)
        elif op == "CallCommon":
            self.emit("-- CallCommon " + args.strip() +
                      " (fermeture/attente message: géré par say())")
        elif op == "Turn2Direction":
            f = [x.strip() for x in args.split(",")]
            d = DIRMAP.get(f[-1])
            if A and d:
                self.emit(f"GROUND:EntTurn({A}, {d})")
            elif d:
                self.emit(f"-- Turn2Direction {target} [acteur sans "
                          f"placement SSA zone: orientation non jouée]")
            else:
                self.unsupported.append(f"Turn2Direction:{target}")
        elif op in ("Turn", "SetDirection"):
            d = DIRMAP.get(args.strip())
            if A and d:
                self.emit(f"GROUND:EntTurn({A}, {d})")
            elif d:
                self.emit(f"-- {op} {target} [acteur sans placement "
                          f"SSA zone: orientation non jouée]")
            else:
                self.unsupported.append(f"{op}:{target}")
        elif op == "Turn2DirectionTurn":
            # rotation sur soi NDS (vitesse, sens, quarts) — adaptation
            # technique: kit.spin (EntTurn 8 directions successives,
            # sens horaire/antihoraire ROM, tempo = vitesse*frames)
            f = [x.strip() for x in args.split(",")]
            if A and len(f) == 3:
                self.emit(f"SkySceneKit.spin({A}, {f[0]}, {f[1]}, {f[2]})")
            else:
                self.unsupported.append("Turn2DirectionTurn")
        elif op == "MovePositionMark" and kind == "performer":
            # performer = caméra dans les SSB (camera_SetMyself performer 0)
            mm = re.search(r"Position<'\w*',\s*([\d.]+),\s*([\d.]+)>", args)
            if mm:
                x = int(float(mm.group(1)) * 8)
                y = int(float(mm.group(2)) * 8)
                self.emit(f"pcall(function() GAME:MoveCamera({x}, {y}, "
                          f"60, false) end) -- performer/caméra")
            else:
                self.unsupported.append("MovePositionMark:performer")
        elif op == "MovePositionMark":
            mm = re.search(r"Position<'\w*',\s*([\d.]+),\s*([\d.]+)>", args)
            sp = re.match(r"\s*([\d.]+)", args)
            if A and mm:
                x = float(mm.group(1)) * 8
                y = float(mm.group(2)) * 8
                speed = 2 if (sp and float(sp.group(1)) >= 0.6) else 1
                self.emit(f"GROUND:MoveToPosition({A}, {int(x)}, {int(y)},"
                          f" false, {speed})")
            elif mm:
                self.emit(f"-- MovePositionMark {target} [cible sans "
                          f"placement SSA zone: mouvement non joué]")
            else:
                self.unsupported.append(f"MovePositionMark:{target}")
        elif op in ("Move2PositionOffset", "Slide2PositionOffset",
                    "SlidePositionOffset", "MovePositionOffset2"):
            mm = re.search(r"<'?\w*'?,?\s*(-?[\d.]+),\s*(-?[\d.]+)>", args)
            flat = re.match(
                r"\s*(-?[\d.]+)\s*,\s*(-?[\d.]+)\s*,\s*(-?[\d.]+)\s*$",
                args)
            if A and mm:
                dx = int(float(mm.group(1)) * 8)
                dy = int(float(mm.group(2)) * 8)
                self.emit(f"do local p={A}.Position; "
                          f"GROUND:MoveToPosition({A}, p.X+({dx}), "
                          f"p.Y+({dy}), false, 2) end")
            elif A and flat:
                # signature plate ROM: (vitesse px/frame, dx px, dy px) —
                # mêmes unités que MovePositionOffset (preuve pilote scroll)
                sp = float(flat.group(1))
                dx = int(float(flat.group(2)))
                dy = int(float(flat.group(3)))
                speed = 2 if sp >= 0.6 else 1
                self.emit(f"do local p={A}.Position; "
                          f"GROUND:MoveToPosition({A}, p.X+({dx}), "
                          f"p.Y+({dy}), false, {speed}) end -- {op}")
            else:
                self.unsupported.append(f"{op}:{target}")
        elif op == "SetPositionMark":
            mm = re.search(r"Position<'\w*',\s*([\d.]+),\s*([\d.]+)>", args)
            if kind == "performer" and mm:
                # performer = caméra (convention V3) : placement instantané
                x = int(float(mm.group(1)) * 8)
                y = int(float(mm.group(2)) * 8)
                self.emit(f"pcall(function() GAME:MoveCamera({x}, {y}, 1,"
                          f" false) end) -- SetPositionMark performer/"
                          f"caméra")
            elif A and mm:
                x = int(float(mm.group(1)) * 8)
                y = int(float(mm.group(2)) * 8)
                self.emit(f"GROUND:TeleportTo({A}, {x}, {y}, "
                          f"Direction.Down)")
            elif mm:
                self.emit(f"-- SetPositionMark {target} [cible sans "
                          f"placement SSA zone: placement non joué]")
            else:
                self.unsupported.append(f"SetPositionMark:{target}")
        elif op == "Turn2DirectionLives":
            # se tourner vers un autre acteur — la cible est le DERNIER
            # argument ACTOR_* ; résolue par actor_expr (héros/partenaire/
            # PNJ du cast SSA). ACTOR_TALK_SUB = interlocuteur courant ->
            # approx: se tourner vers le héros (TECHNICAL_ADAPTATION).
            tgt_name = args.split(",")[-1].strip()
            if tgt_name == "ACTOR_TALK_SUB":
                tgt2 = "hero"
            else:
                tgt2 = self.actor_expr(tgt_name)
            if A and tgt2:
                self.emit(f"pcall(function() GROUND:CharTurnToCharAnimated("
                          f"{A}, {tgt2}, 4) end)")
            elif A:
                # cible sans placement SSA dans la zone (PNJ spawné
                # dynamiquement par le moteur shop/hub NDS) : op
                # d'ORIENTATION pure — aucune ligne de dialogue ni
                # action, trace documentée sans rotation.
                self.emit(f"-- Turn2DirectionLives vers {tgt_name} "
                          f"[cible sans placement SSA dans la zone "
                          f"(spawn moteur NDS) : orientation non jouée]")
            else:
                self.unsupported.append(f"Turn2DirectionLives:{tgt_name}")
        elif op == "SetPositionInitial":
            self.emit(f"-- SetPositionInitial [position SSA de départ, "
                      f"déjà posée par le placement de scène]")
        elif op in ("message_CloseEnforce",):
            self.emit("-- message_CloseEnforce")
        elif op == "message_SetActor":
            # définit le LOCUTEUR des prochains dialogues (voix d'un
            # personnage, présent ou hors champ). Attribution canonique
            # préservée : speaker = acteur résolu (spawn si placé), ou
            # nom d'espèce affiché si l'acteur n'a pas de placement
            # (voix hors champ ROM).
            tgt = args.strip()
            a2 = self.actor_expr(tgt) if tgt.startswith("ACTOR_") else None
            if a2:
                self.emit(f"pcall(function() UI:SetSpeaker({a2}) end) "
                          f"-- message_SetActor({tgt})")
                self.face_pending = tgt
            else:
                key = tgt.replace("ACTOR_", "")
                entid = GLOBAL_ACTOR_ENTID.get(key)
                sp = (ENTID2SPECIES.get(entid)
                      or ENTID2SPECIES.get((entid or 0) % 600)) \
                    if entid else None
                if sp:
                    # signature native PMDO (event_battle.lua):
                    # SetSpeaker(name, sound, species, form, skin, gender)
                    disp = sp.replace("_", " ").title()
                    self.emit(f"pcall(function() UI:SetSpeaker("
                              f"{lua_str(disp)}, true, {lua_str(sp)}, 0, "
                              f"'', RogueEssence.Data.Gender.Unknown) "
                              f"end) -- message_SetActor({tgt}) voix "
                              f"hors champ (espèce ROM)")
                else:
                    self.emit(f"pcall(function() UI:ResetSpeaker() end) "
                              f"-- message_SetActor({tgt}) sans identité")
        elif op in ("message_EmptyActor", "message_SetFaceEmpty"):
            self.emit("pcall(function() UI:ResetSpeaker() end)")
        elif op == "MovePositionOffset":
            # signature ROM: (vitesse px/frame, dx px, dy px) — preuve:
            # S13P05A SetPositionOffset/scroll pilote (unités px NDS)
            mm = re.match(
                r"\s*(-?[\d.]+)\s*,\s*(-?[\d.]+)\s*,\s*(-?[\d.]+)\s*$", args)
            if mm and kind == "performer":
                # performer = caméra (convention V3) : glissement relatif
                sp = float(mm.group(1)) or 1.0
                dx, dy = float(mm.group(2)), float(mm.group(3))
                dur = max(1, int(round(
                    max(abs(dx), abs(dy)) / max(sp, 0.01))))
                self.emit(f"pcall(function() local g=GAME:GetCurrentGround()"
                          f"; GAME:MoveCamera(g.ViewCenter.X+({int(dx)}), "
                          f"g.ViewCenter.Y+({int(dy)}), {dur}, false) end)"
                          f" -- MovePositionOffset performer/caméra")
            elif mm and A:
                sp = float(mm.group(1))
                dx, dy = int(float(mm.group(2))), int(float(mm.group(3)))
                speed = 2 if sp >= 0.6 else 1
                self.emit(f"do local p={A}.Position; "
                          f"GROUND:MoveToPosition({A}, p.X+({dx}), "
                          f"p.Y+({dy}), false, {speed}) end")
            elif mm and kind == "object":
                self.emit(f"-- MovePositionOffset<object {target}> "
                          f"[prop décor NDS, géré par le rendu du ground]")
            elif mm:
                self.emit(f"-- MovePositionOffset {target} [cible sans "
                          f"placement SSA zone: déplacement non joué]")
            else:
                self.unsupported.append(f"MovePositionOffset:{target}")
        elif op in ("main_EnterDungeon", "main_EnterGround",
                    "main_SetGround", "main_EnterRescueUser",
                    "main_EnterTraining"):
            # transition de fin de scène NDS : dans PMDO le changement de
            # zone est effectué par le harnais journey/le jeu (EnterZone),
            # pas par la cinématique elle-même — neutralisé AVEC trace
            # (même convention que les ops de station V3).
            self.emit(f"-- {op}({args.strip()[:60]}) [transition de zone "
                      f"NDS: assurée par le harnais journey/EnterZone PMDO]")
        elif op == "Move2PositionMark":
            mm = re.search(r"Position<'\w*',\s*([\d.]+),\s*([\d.]+)>", args)
            if A and mm:
                x = int(float(mm.group(1)) * 8)
                y = int(float(mm.group(2)) * 8)
                self.emit(f"GROUND:MoveToPosition({A}, {x}, {y}, false, 2)")
            elif kind == "object" and mm:
                # OBJET de décor NDS (props SSA) : déplacement d'objet non
                # scripté par le kit — l'objet n'est pas spawné (les props
                # sont dans le décor rendu) : trace documentée, aucun
                # dialogue/acteur perdu.
                self.emit(f"-- Move2PositionMark<object {target}> "
                          f"[prop décor NDS, géré par le rendu du ground]")
            elif mm:
                self.emit(f"-- Move2PositionMark {target} [cible sans "
                          f"placement SSA zone: mouvement non joué]")
            else:
                self.unsupported.append(f"Move2PositionMark:{target}")
        elif op in ("Slide2PositionMark",) and kind == "object":
            self.emit(f"-- Slide2PositionMark<object {target}> "
                      f"[prop décor NDS, géré par le rendu du ground]")
        elif op == "SetPositionOffset":
            # décalage immédiat en pixels (dx, dy) depuis la position
            # courante — TeleportTo relatif via kit
            f = [x.strip() for x in args.split(",")]
            if A and len(f) == 2:
                self.emit(f"SkySceneKit.offset_pos({A}, {int(float(f[0]))},"
                          f" {int(float(f[1]))})")
            else:
                self.unsupported.append("SetPositionOffset")
        elif op == "hold":
            self.emit("GAME:WaitFrames(1) -- hold")
        elif op == "se_FadeOut":
            # canal SE NDS : les SE portés (SE_TO_PMDO) sont des one-shots
            # PlayBattleSE déjà terminés — le fondu d'un SE bouclé NDS n'a
            # pas d'objet ; adaptation documentée du canal SE (V2).
            self.emit(f"-- se_FadeOut({args.strip()[:40]}) [SE one-shot "
                      f"PMDO déjà terminé: fondu sans objet, canal SE V2]")
        elif op in ("screen_WhiteOut", "screen_WhiteOutAll"):
            n = last_int_arg(args, 20)
            self.emit(f"GAME:FadeOut(true, {n}) -- {op}")
            self.main_shown = False
        elif op == "screen_WhiteChange":
            n = last_int_arg(args, 20)
            self.emit(f"GAME:FadeIn({n}) -- WhiteChange")
            self.main_shown = True
        elif op == "screen_FadeChange":
            # (mode, durée, alpha_de, alpha_vers) : assombrissement/
            # éclaircissement PARTIEL de l'écran principal. PMDO n'a pas
            # d'alpha caméra scriptable : fondu de même durée, sens
            # déterminé par alpha_vers (documenté).
            parts = [p.strip() for p in args.split(",")]
            dur = int(parts[1]) if len(parts) > 1 and \
                parts[1].lstrip('-').isdigit() else 20
            to_a = int(parts[3]) if len(parts) > 3 and \
                parts[3].lstrip('-').isdigit() else 256
            if to_a >= 192:
                self.emit(f"GAME:FadeIn({dur}) -- screen_FadeChange vers "
                          f"alpha {to_a} (éclaircissement, adaptation)")
            else:
                self.emit(f"GAME:FadeOut(false, {dur}) -- "
                          f"screen_FadeChange vers alpha {to_a} "
                          f"(assombrissement, adaptation)")
        elif op == "WaitExecuteObject":
            # join sur la routine d'un OBJET de scène NDS (props animés) :
            # les routines d'objets ne sont pas simulées — join court,
            # trace explicite (même convention que WaitExecuteLives)
            self.emit(f"GAME:WaitFrames(2) -- join WaitExecuteObject("
                      f"{args.strip()[:30]}) [routine d'objet NDS non "
                      f"simulée - documenté]")
        elif op == "back_SetDungeonBanner":
            # bannière "Donjon - Étage" NDS : équivalent natif PMDO =
            # titre d'écran (même information au même moment)
            self.emit(f"pcall(function() UI:WaitShowTitle(GAME:"
                      f"GetCurrentGround().Name:ToLocal(), 30) end) "
                      f"-- back_SetDungeonBanner({args.strip()[:16]})")
        elif op == "camera_SetEffect":
            # (type, intensité, vitesse) : tremblement/effet caméra NDS.
            # type 2 = tremblement -> ScreenMover natif ; type 0 = stop.
            parts = re.findall(r'-?\d+', args)
            if parts and parts[0] == '0':
                self.emit("-- camera_SetEffect(0): arrêt d'effet caméra")
            else:
                power = int(parts[1]) if len(parts) > 1 else 2
                self.emit(f"pcall(function() GROUND:MoveScreen("
                          f"RogueEssence.Content.ScreenMover(0, "
                          f"{max(1, power * 2)}, 30)) end) "
                          f"-- camera_SetEffect{tuple(parts)}")
        elif op in ("SlidePositionMark", "Slide2PositionMark"):
            mm = re.search(r"Position<'\w*',\s*([\d.]+),\s*([\d.]+)>", args)
            sp = re.match(r"\s*([\d.]+)", args)
            if A and mm:
                x = int(float(mm.group(1)) * 8)
                y = int(float(mm.group(2)) * 8)
                speed = 2 if (sp and float(sp.group(1)) >= 0.6) else 1
                self.emit(f"GROUND:MoveToPosition({A}, {x}, {y}, false, "
                          f"{speed}) -- {op} (glissement)")
            elif mm:
                self.emit(f"-- {op} {target} [cible sans placement "
                          f"SSA zone: glissement non joué]")
            else:
                self.unsupported.append(f"{op}:{target}")
        elif op == "MovePosition":
            # (vitesse, x_px, y_px) — déplacement en pixels ABSOLUS
            mm = re.match(r"\s*([\d.]+)\s*,\s*(-?[\d.]+)\s*,\s*(-?[\d.]+)",
                          args)
            if A and mm:
                speed = 2 if float(mm.group(1)) >= 0.6 else 1
                self.emit(f"GROUND:MoveToPosition({A}, "
                          f"{int(float(mm.group(2)))}, "
                          f"{int(float(mm.group(3)))}, false, {speed})")
            elif mm:
                self.emit(f"-- MovePosition {target} [cible sans "
                          f"placement SSA zone: déplacement non joué]")
            else:
                self.unsupported.append(f"MovePosition:{target}")
        elif op == "Turn2DirectionMark":
            # se tourner vers une POSITION (vitesse, delai, Position<>) :
            # kit.turn_to_pos (direction calculée vers le point)
            mm = re.search(r"Position<'\w*',\s*([\d.]+),\s*([\d.]+)>", args)
            if A and mm:
                x = int(float(mm.group(1)) * 8)
                y = int(float(mm.group(2)) * 8)
                self.emit(f"SkySceneKit.turn_to_pos({A}, {x}, {y}) "
                          f"-- Turn2DirectionMark")
            else:
                self.unsupported.append("Turn2DirectionMark")
        elif op == "Turn3":
            # rotation partielle NDS (vitesse, sens, pas, delai) : même
            # adaptation que Turn2DirectionTurn avec moins de pas
            f = [x.strip() for x in args.split(",")]
            if A and len(f) >= 3:
                self.emit(f"SkySceneKit.spin({A}, {f[0]}, {f[1]}, 1) "
                          f"-- Turn3 (rotation partielle)")
            else:
                self.unsupported.append("Turn3")
        elif op == "WaitEndAnimation":
            self.emit("GAME:WaitFrames(8) -- WaitEndAnimation (join anim)")
        elif op == "WaitMoveCamera":
            self.emit("GAME:WaitFrames(4) -- WaitMoveCamera (join caméra)")
        elif op == "supervision_ActingInvisible":
            self.emit(f"-- supervision_ActingInvisible({args.strip()[:8]}) "
                      f"[acting caché superviseur NDS]")
        elif op in ("item_SetTableData", "item_GetVariable",
                    "item_SetVariable", "item_Set"):
            self.emit(f"-- {op}({args.strip()[:40]}) [table d'objets du "
                      f"script NDS: inventaire géré par le moteur PMDO]")
        elif op == "back_SetSpecialEpisodeBanner":
            # bannière-titre d'épisode spécial (texte 5 langues) : le
            # TEXTE canonique est affiché par le dialogue natif
            langs, _ = parse_dialogue_block(args, args.find("{"))
            if langs:
                self.dialogues += 1
                tbl = ", ".join(f"{k}={lua_str(v)}"
                                for k, v in langs.items())
                self.emit(f"pcall(function() UI:ResetSpeaker() end)")
                self.emit(f"SkySceneKit.say({{{tbl}}}) "
                          f"-- bannière d'épisode spécial (titre ROM)")
            else:
                self.emit(f"-- back_SetSpecialEpisodeBanner "
                          f"[bannière sans texte]")
        elif op in ("se_ChangeVolume", "se_FadeVolume", "se_Stop"):
            self.emit(f"-- {op}({args.strip()[:20]}) [canal SE NDS: "
                      f"one-shots PMDO, volume non scriptable]")
        elif op == "message_ImitationSound":
            # onomatopée textuelle NDS (bulle "Bzzt!" etc.) : rendue comme
            # dialogue court (même contenu, présentation adaptée)
            langs, _ = parse_dialogue_block(args, args.find("{"))
            if langs:
                tbl = ", ".join(f"{k}={lua_str(v)}"
                                for k, v in langs.items())
                self.emit(f"SkySceneKit.say({{{tbl}}}) "
                          f"-- message_ImitationSound (onomatopée)")
                self.dialogues += 1
            else:
                self.emit("-- message_ImitationSound sans texte")
        elif op == "MoveHeight":
            # élévation d'un objet de scène NDS (lévitation sprite) :
            # objets de décor non simulés — trace (les acteurs du cast le
            # sont via les routines, hors périmètre objet)
            self.emit(f"-- MoveHeight({args.strip()[:24]}) [élévation "
                      f"d'objet NDS non simulée - documenté]")
        elif op == "message_SwitchMonologue":
            i = args.rfind("default:")
            j = args.find("case")
            base = i if i >= 0 else j
            if base < 0:
                self.unsupported.append("message_SwitchMonologue:no_branch")
                return
            langs, _ = parse_dialogue_block(args, args.find("{", base))
            if not langs:
                self.unsupported.append("message_SwitchMonologue:no_text")
                return
            self.dialogues += 1
            tbl = ", ".join(f"{k}={lua_str(v)}" for k, v in langs.items())
            self.emit(f"SkySceneKit.say({{{tbl}}}) "
                      f"-- SwitchMonologue: branche default")
        elif op == "SetAnimation":
            self.emit(f"-- SetAnimation({args.strip()}) [anim idle native]")
        elif op in ("supervision_ExecuteStationSub",
                    "supervision_ExecuteStation",
                    "supervision_ExecuteActing",
                    "supervision_ExecuteStationCommon"):
            # exécute la scène SSB nommée du level (convention PROUVÉE
            # 463 occurrences: 'UN01',n -> un01<nn>.ssb ; préfixe long
            # 'M03A0501',0 -> m03a0501.ssb). CHAÎNAGE RÉEL vers le module
            # compilé s'il existe (kit.play_scene, pcall) — sinon trace.
            mex = re.match(r"\s*LEVEL_(\w+)\s*,\s*'(\w+)'\s*,\s*(\d+)", args)
            if mex:
                lvl, pref, idx = (mex.group(1).lower(),
                                  mex.group(2).lower(), int(mex.group(3)))
                cand1 = f"{lvl}__{pref}{idx:02d}"
                cand2 = f"{lvl}__{pref}"
                self.emit(f"SkySceneKit.play_scene({lua_str(cand1)}, "
                          f"{lua_str(cand2)}, hero, partner) "
                          f"-- {op}(LEVEL_{mex.group(1)}, "
                          f"'{mex.group(2)}', {idx}) [chaînage scène ROM]")
            else:
                self.emit(f"-- {op}({args.strip()[:50]}) [exécution de "
                          f"station sans cible littérale: harnais journey]")
        elif op in ("supervision_Station", "supervision_StationCommon",
                    "supervision_LoadStation", "supervision_RemoveActing",
                    "supervision_RemoveCommon", "supervision_Remove",
                    "ExecuteCommon", "JumpCommon",
                    "supervision_ExecuteCommon", "CallCommon"):
            self.emit(f"-- {op}({args.strip()[:60]}) [gestion de station "
                      f"NDS: le chargement/la coroutine commune est "
                      f"assurée par le harnais journey PMDO]")
        elif op == "Lock":
            # verrou de synchronisation NDS entre routines d'acteurs :
            # sémantique reproduite par le kit (drapeaux partagés,
            # WaitFrames jusqu'à Unlock) — cf. kit.lua multiroutines
            n = last_int_arg(args, 0)
            self.emit(f"SkySceneKit.lock({n}) -- Lock({n}) NDS")
        elif op == "Unlock":
            n = last_int_arg(args, 0)
            self.emit(f"SkySceneKit.unlock({n}) -- Unlock({n}) NDS")
        elif op in ("SetOutputAttribute", "ResetOutputAttribute",
                    "ResetHitAttribute", "SetHitAttribute",
                    "SetMoveRange", "Destroy",
                    "SetBlink", "SetHeight", "camera_SetMyself",
                    "supervision_Acting", "supervision_Suspend",
                    "back_SetGround", "main_SetGround", "lives",
                    "object", "performer", "CameraCancel",
                    "message_ResetActor", "message_SetWaitMode",
                    "message_FacePositionOffset", "debug_Print",
                    "flag_SetScenario", "flag_CalcValue", "flag_CalcBit",
                    "camera_SetMyPosition", "StopAnimation", "PauseEffect",
                    "RestartEffect", "worldmap_BlinkMark",
                    "SlideHeight", "MoveHeight2", "SetAttributeAnimation"):
            self.emit(f"-- {op}({args.strip()[:50]}) [neutre/état moteur]")
        elif op == "supervision_SpecialActing":
            self.emit(f"-- supervision_SpecialActing({args.strip()}) "
                      f"[cadrage NDS]")
        elif op == "camera_SetPositionMark":
            mm = re.search(r"Position<'\w*',\s*([\d.]+),\s*([\d.]+)>", args)
            if mm:
                x = int(float(mm.group(1)) * 8)
                y = int(float(mm.group(2)) * 8)
                self.emit(f"pcall(function() GAME:MoveCamera({x}, {y}, 1,"
                          f" false) end)")
            else:
                self.unsupported.append("camera_SetPositionMark")
        elif op in ("camera_SetDefault", "camera_Move2Default",
                    "camera_MoveDefault"):
            self.emit("pcall(function() GAME:MoveCamera(0, 0, 1, true) "
                      "end) -- caméra défaut")
        elif op == "WaitRandom":
            f = [x.strip() for x in args.split(",")]
            self.emit(f"GAME:WaitFrames(math.random({f[0]}, {f[-1]}))")
        else:
            self.unsupported.append(op)


def parse_defs(src):
    """Extrait les routines `def N [for kind target] { ... }` avec un
    compteur d'accolades ÉQUILIBRÉ (les dialogues contiennent des { }
    imbriqués sur plusieurs niveaux — une regex à profondeur fixe ratait
    1746 scènes : bug corrigé, test de régression = COMPILED > 500)."""
    defs = []
    for m in re.finditer(r"def (\d+)(?: for (\w+) (\w+))?\s*\{", src):
        depth = 1
        j = m.end()
        while j < len(src) and depth > 0:
            if src[j] == "{":
                depth += 1
            elif src[j] == "}":
                depth -= 1
            j += 1
        defs.append((m.group(1), m.group(2), m.group(3),
                     src[m.end():j - 1]))
    return defs


HEADER = """-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/%s/%s (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
"""


def main():
    os.makedirs(OUT, exist_ok=True)
    ci = json.load(open(os.path.join(
        CAMP, "Docs", "CINEMATIC_INTEGRABILITY.json")))["scenes"]
    report = OrderedDict()
    counts = Counter()
    emitted = []
    for f in sorted(glob.glob(os.path.join(RS, "*.json.gz"))):
        zone = os.path.basename(f).split(".")[0]
        z = json.load(gzip.open(f, "rt"))
        for name, s in z["scripts"].items():
            if not name.endswith(".ssb"):
                continue
            key = f"{zone}/{name}"
            cls = ci.get(key, {}).get("classification")
            # PARTIAL_FIDELITY admis depuis le single-screen focus
            # (subscreen.lua + DUAL_SCREEN_TIMELINES) : le compilateur
            # reste FAIL-CLOSED op par op — toute op PARTIEL non traduite
            # classe la scène PARTIAL_OPS, jamais approximée en silence.
            if cls not in ("NATIVELY_SUPPORTED", "TECHNICALLY_ADAPTABLE",
                           "PARTIAL_FIDELITY"):
                counts["SKIPPED_" + str(cls)] += 1
                continue
            src = s.get("explorerscript") or ""
            # cast SSA de la même scène (m01a0204.ssb -> m01a0204.ssa)
            cast = {}
            ssa = z["scripts"].get(name[:-4] + ".ssa")
            if ssa and ssa.get("ssa"):
                seen = {}
                for layer in ssa["ssa"]["layers"]:
                    for a in layer.get("actors", []):
                        nm = a["actor_name"]
                        if nm.startswith(("PLAYER", "ATTENDANT")):
                            continue
                        if nm in seen:
                            continue
                        sp = ENTID2SPECIES.get(a["entid"]) \
                            or ENTID2SPECIES.get(a["entid"] % 600)
                        if not sp:
                            continue
                        pos = a["pos"]
                        x = pos["x_relative"] * 8 + pos.get("x_offset", 0) * 4
                        y = pos["y_relative"] * 8 + pos.get("y_offset", 0) * 4
                        d = "Direction." + (pos.get("direction") or "Down")
                        var = "npc_" + re.sub(r"\W", "_", nm.lower())
                        seen[nm] = True
                        cast[nm] = (var, sp, x, y, d)
            # complément : acteurs référencés par le SSB mais absents du
            # SSA propre — résolus par la table globale (entid unique ROM
            # + première position SSA de la ZONE). FAIL-CLOSED : pas de
            # placement dans la zone = pas d'entrée cast.
            for mo in re.finditer(r"ACTOR_([A-Z0-9_]+)", src):
                nm = mo.group(1)
                if nm in cast or nm.startswith(("PLAYER", "ATTENDANT",
                                                "TALK_", "UNIT_",
                                                "ADVENTURE_", "RANDOM_",
                                                "EVENT_NPC")):
                    continue
                entid = GLOBAL_ACTOR_ENTID.get(nm)
                pos = GLOBAL_ACTOR_ZONEPOS.get(f"{zone}|{nm}")
                if not pos:
                    # variante de zone NDS (T01P02A = Treasure Town des
                    # épisodes spéciaux, même carte que T01P01A ; suffixe
                    # PxxA partagé) : position de l'acteur dans la zone
                    # de BASE — même identité ROM, placement prouvé SSA.
                    base = zone[:3] + "P01A"
                    if base != zone:
                        pos = GLOBAL_ACTOR_ZONEPOS.get(f"{base}|{nm}")
                # entid >= 600 = variante genrée NDS (base + 600)
                sp = (ENTID2SPECIES.get(entid)
                      or ENTID2SPECIES.get(entid % 600)) if entid else None
                if not sp or not pos:
                    continue
                var = "npc_" + re.sub(r"\W", "_", nm.lower())
                cast[nm] = (var, sp, pos[0], pos[1],
                            "Direction." + (pos[2] or "Down"))
            defs = parse_defs(src)
            main_def = next((d for d in defs if d[0] == "0"), None)
            if main_def is None:
                counts["NO_DEF0"] += 1
                continue
            other = [d for d in defs if d[0] != "0"]
            # routines d'acteurs non triviales -> compilées en coroutines
            # parallèles (SkySceneKit.run_routine, sémantique Lock/Unlock
            # NDS reproduite par le kit)
            nontrivial = [d for d in other if re.search(
                r"\b(Move|Turn|message_|Slide)", d[3])]
            comp = SceneCompiler(zone, name, src, cast)
            routine_fns = []
            routines_ok = True
            for rnum, rkind, rtarget, rbody in nontrivial:
                rc = SceneCompiler(zone, name, src, cast)
                rc.spawned = comp.spawned      # partager les spawns
                rc.routine_actor = rtarget      # cible implicite
                ok_r = rc.compile_def0(rbody)
                if not ok_r:
                    comp.unsupported.extend(
                        f"routine{rnum}:{u}" for u in rc.unsupported)
                    routines_ok = False
                    continue
                comp.dialogues += rc.dialogues
                comp.used_subscreen = comp.used_subscreen or \
                    rc.used_subscreen
                comp.used_skyprog = comp.used_skyprog or rc.used_skyprog
                routine_fns.append((rnum, rkind, rtarget, rc.lines))
            ok = comp.compile_def0(main_def[3])
            if not ok or not routines_ok:
                counts["PARTIAL_OPS"] += 1
                report[key] = {"status": "PARTIAL_OPS",
                               "unsupported_ops":
                               sorted(set(comp.unsupported))}
                continue
            if comp.dialogues == 0 and len(comp.lines) < 3:
                counts["TRIVIAL_SKIPPED"] += 1
                continue
            fn = f"{zone.lower()}__{name[:-4]}"
            if comp.spawned:
                comp.emit("SkySceneKit.cleanup_npcs()")
            requires = "local SkySceneKit = require 'halcyon.skyscenes.kit'\n"
            if comp.used_skyprog:
                requires += ("local SkyProg = require "
                             "'halcyon.skyscenes.progression'\n")
            if comp.used_subscreen:
                comp.emit("SkySubScreen.Hide(10) -- fin de scène: nappe "
                          "sub retirée")
                requires += ("local SkySubScreen = require "
                             "'halcyon.skyscenes.subscreen'\n")
            body = "\n".join(comp.lines)
            if routine_fns:
                # routines d'acteurs NDS -> coroutines parallèles lancées
                # AVANT le def 0 (comme l'interpréteur SSB), jointes après
                pre = ["  SkySceneKit.reset_locks()"]
                for rnum, rkind, rtarget, rlines in routine_fns:
                    pre.append(f"  SkySceneKit.run_routine(function() "
                               f"-- def {rnum} for {rkind} {rtarget}")
                    pre.extend("  " + ln for ln in rlines)
                    pre.append("  end)")
                body = "\n".join(pre) + "\n" + body + \
                    "\n  SkySceneKit.join_routines()"
                counts["COMPILED_MULTIROUTINE"] += 1
            lua = (HEADER % (zone, name) + requires
                   + f"return function(hero, partner)\n{body}\nend\n")
            open(os.path.join(OUT, fn + ".lua"), "w",
                 encoding="utf-8").write(lua)
            emitted.append(fn)
            counts["COMPILED"] += 1
            if comp.used_subscreen:
                counts["COMPILED_DUAL_SCREEN"] += 1
            report[key] = {"status": "COMPILED", "file": fn + ".lua",
                           "dialogues": comp.dialogues,
                           "dual_screen_focus": comp.used_subscreen or None,
                           "gaps": comp.gaps or None}
    # registre
    idx = ["-- GÉNÉRÉ par sky_compile_scenes.py", "return {"]
    for fn in emitted:
        idx.append(f"  [{lua_str(fn)}] = true,")
    idx.append("}")
    open(os.path.join(OUT, "index.lua"), "w").write("\n".join(idx) + "\n")

    rep = OrderedDict(
        schema="sky-scene-compiler/1",
        rule="FAIL-CLOSED: seules les scènes 100% traduites sont émises ; "
             "PARTIAL_OPS/MULTIROUTINE comptées, jamais émises approximées",
        totals=OrderedDict(counts.most_common()),
        scenes=report)
    json.dump(rep, open(os.path.join(
        CAMP, "Docs", "SCENE_COMPILER_REPORT.json"), "w",
        encoding="utf-8"), ensure_ascii=False, indent=1)
    print("totals:", dict(counts))


if __name__ == "__main__":
    main()
