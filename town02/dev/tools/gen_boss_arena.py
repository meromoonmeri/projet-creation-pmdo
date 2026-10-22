#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_boss_arena.py — Générateur procédural d'arènes de boss RogueEssence (PMDO)

"Décrire le boss + biome -> obtenir une vraie arène jouable (.rsmap)".

Entrées :
  --boss      nom du boss (ex: Lugia, Groudon, Tornadus, Regigigas, Rayquaza)
  --type      type d'arène (plateforme_celeste, temple_antique, volcan,
              ruines_englouties, foret_mystique, dimension_obscure)
  --taille    petite(20) | moyenne(30) | grande(50)   (en tuiles)
  --difficulte 1..5  (obstacles, zones dangereuses, position du boss)
  --sortie    nom du fichier .rsmap (défaut: arene_<boss>)
  --graine    seed aléatoire (reproductible). Défaut: aléatoire.

Sorties :
  - un .rsmap valide RogueEssence (terrain + décor + collision + entités)
  - mode debug : --png (image), --ascii (grille), --valider (auto-check)

Architecture générée (composition unique par seed) :
  - murs extérieurs fermés, sol accessible, aucun cul-de-sac
  - spawn joueur + partenaire, spawn boss
  - zone centrale de combat, zones d'esquive, obstacles, zones stratégiques
  - identité visuelle liée au biome (auto-tilesets officiels)

Le générateur ne produit JAMAIS seulement une image : il construit une vraie
structure de données .rsmap (dict) exploitable directement par RogueEssence,
et n'écrit l'image ASCII/PNG qu'en mode debug.
"""
from __future__ import annotations
import argparse, json, os, random, io, sys, struct

# ---------------------------------------------------------------------------
# Thèmes : (auto-tileset sol, auto-tileset mur, élément, musique par défaut)
# ---------------------------------------------------------------------------
THEMES = {
    'plateforme_celeste': {'floor': 'sky_tower_floor', 'wall': 'sky_tower_wall',
                            'element': 'normal', 'music': 'Boss Battle!.ogg'},
    'temple_antique':     {'floor': 'concealed_ruins_floor', 'wall': 'concealed_ruins_wall',
                            'element': 'normal', 'music': 'Aegis Cave.ogg'},
    'volcan':             {'floor': 'magma_cavern_2_floor', 'wall': 'magma_cavern_2_wall',
                            'element': 'fire', 'music': 'Boss Battle!.ogg'},
    'ruines_englouties':  {'floor': 'brine_cave_floor', 'wall': 'brine_cave_wall',
                            'element': 'water', 'music': 'Boss Battle!.ogg'},
    'foret_mystique':     {'floor': 'mystifying_forest_floor', 'wall': 'mystifying_forest_wall',
                            'element': 'grass', 'music': 'Boss Battle!.ogg'},
    'dimension_obscure':  {'floor': 'dark_wasteland_floor', 'wall': 'dark_wasteland_wall',
                            'element': 'dark', 'music': 'Boss Battle!.ogg'},
}

# Boss -> type d'arène par défaut (identité visuelle liée au Pokémon)
DEFAULT_ARENA = {
    'groudon': 'volcan', 'lugia': 'ruines_englouties', 'tornadus': 'plateforme_celeste',
    'regigigas': 'temple_antique', 'rayquaza': 'plateforme_celeste',
    'regice': 'temple_antique', 'regirock': 'temple_antique', 'registeel': 'temple_antique',
}

# Élément par boss (pour le CurrentForm / tactique)
BOSS_ELEMENT = {
    'groudon':'ground','lugia':'psychic','tornadus':'flying','regigigas':'normal',
    'rayquaza':'dragon','regice':'ice','regirock':'rock','registeel':'steel',
}

# ---------------------------------------------------------------------------
# Composantes de base d'un .rsmap (format RogueEssence vérifié octet par octet)
# ---------------------------------------------------------------------------
ASSEMBLY = 'RogueEssence'

def tile_data(cell_id, autotileset, x, y):
    """Une tuile de la grille Tiles[x][y].Data/Effect (patron make_ruines_arenes)."""
    return {
        'Data': {'ID': cell_id, 'TileTex': {'AutoTileset': autotileset, 'Associates': [],
                                            'Layers': [], 'NeighborCode': 511}, 'StableTex': False},
        'Effect': {'TileLoc': {'X': x, 'Y': y}, 'ID': '', 'Revealed': False, 'Owner': 0,
                   'TileStates': []},
    }

def empty_tile():
    """Cellule vide d'une couche décor (aucun pixel)."""
    return {'AutoTileset': '', 'Associates': [], 'Layers': [], 'NeighborCode': -1}

def layer(name, w, h, fill=None):
    """Une couche décor .rsmap (Layer). `fill` = dict AutoTileset ou None."""
    return {'Name': name, 'Layer': 0, 'Visible': True,
            'Tiles': [[empty_tile() for _ in range(h)] for _ in range(w)]}

def default_rand():
    return {'$type': 'RogueElements.ReRandom, RogueElements', 'FirstSeed': 0,
            's': [16294208416658607535, 7960286522194355700, 487617019471545679, 17909611376780542444]}

# ---------------------------------------------------------------------------
# Générateur procédural d'arène
# ---------------------------------------------------------------------------
class ArenaGen:
    def __init__(self, boss, arena_type, size, difficulty, seed):
        self.boss = boss.lower()
        self.arena_type = arena_type or DEFAULT_ARENA.get(self.boss, 'temple_antique')
        self.size = size
        self.diff = max(1, min(5, difficulty))
        self.rng = random.Random(seed)
        self.seed = seed
        t = THEMES[self.arena_type]
        self.floor_ts, self.wall_ts = t['floor'], t['wall']
        self.element = t['element']
        self.music = t['music']
        # grille : 0 = vide/interdit, 1 = sol, 2 = obstacle, 3 = danger
        self.grid = [[0]*size for _ in range(size)]

    # ---- réparation de connexité : relie tous les îlots de sol ----------
    def _reconnecter(self):
        """Force la connexité du sol : aucun îlot isolé, aucune case vide qui
        coupe un accès. Relie chaque îlot au composant principal par un pont."""
        from collections import deque
        W = self.size
        sol = [(x, y) for x in range(W) for y in range(W) if self.grid[x][y] == 1]

        # composants connexes du sol
        def composants():
            rest = set(sol); comps = []
            while rest:
                start = rest.pop(); seen = {start}; q = deque([start])
                while q:
                    x, y = q.popleft()
                    for dx, dy in ((1,0),(-1,0),(0,1),(0,-1)):
                        n = (x+dx, y+dy)
                        if n in rest: rest.discard(n); seen.add(n); q.append(n)
                comps.append(seen)
            return comps

        comps = composants()
        if not comps: return
        principal = max(comps, key=len)
        for comp in comps:
            if comp is principal: continue
            # relier un point du composant au plus proche du principal
            c_point = min(comp, key=lambda p: min(abs(p[0]-q[0])+abs(p[1]-q[1]) for q in principal))
            p_point = min(principal, key=lambda q: abs(q[0]-c_point[0])+abs(q[1]-c_point[1]))
            # tracer un pont orthogonal entre c_point et p_point
            x0, y0 = c_point; x1, y1 = p_point
            for x in range(min(x0, x1), max(x0, x1)+1):
                if self.grid[x][y0] != 1: self.grid[x][y0] = 1
            for y in range(min(y0, y1), max(y0, y1)+1):
                if self.grid[x1][y] != 1: self.grid[x1][y] = 1

    # ---- génération de la forme (composition unique) ---------------------
    def _carve(self):
        W = self.size
        # Murs extérieurs fermés
        for x in range(W):
            self.grid[x][0] = 0
            self.grid[x][W-1] = 0
            self.grid[0][x] = 0
            self.grid[W-1][x] = 0
        # Sol plein intérieur
        for x in range(1, W-1):
            for y in range(1, W-1):
                self.grid[x][y] = 1
        # Position centrale du boss
        self.boss_c = (W//2, W//2)
        self.grid[self.boss_c[0]][self.boss_c[1]] = 1

        # Plateformes / arches selon le type
        if self.arena_type == 'plateforme_celeste':
            self._piliers_ecartes()
        elif self.arena_type == 'volcan':
            self._fissures_dangereuses()
        elif self.arena_type == 'ruines_englouties':
            self._colonnes_et_eau()
        elif self.arena_type == 'foret_mystique':
            self._arbres_par_ilots()
        elif self.arena_type == 'temple_antique':
            self._piliers_quadrant()
        elif self.arena_type == 'dimension_obscure':
            self._murs_fluides()

        # Zones d'esquive stratégiques (couloirs ouverts) selon difficulté
        self._esquive_zones()

    def _piliers_ecartes(self):
        W = self.size
        for i in range(self.diff + 2):
            x = self.rng.randrange(2, W-2); y = self.rng.randrange(2, W-2)
            if (x, y) != self.boss_c:
                self.grid[x][y] = 0  # vide céleste (plateformes flottantes)
        # plateformes au sol
        for i in range(self.diff + 3):
            x = self.rng.randrange(2, W-2); y = self.rng.randrange(2, W-2)
            if self.grid[x][y] == 1 and (x, y) != self.boss_c:
                self.grid[x][y] = 2

    def _fissures_dangereuses(self):
        W = self.size
        # fissures de lave (zones dangereuses) traversant
        n = self.diff + 1
        for _ in range(n):
            start = self.rng.randrange(1, W-1)
            x, y = start, 1
            while y < W-1:
                if (x, y) != self.boss_c:
                    self.grid[x][y] = 3 if self.rng.random() < 0.6 else 0
                x = max(1, min(W-2, x + self.rng.choice([-1, 0, 0, 1])))
                y += 1
        # plateforme centrale rocheuse autour du boss
        cx, cy = self.boss_c
        for dx in (-1, 0, 1):
            for dy in (-1, 0, 1):
                if self.grid[cx+dx][cy+dy] == 1:
                    self.grid[cx+dx][cy+dy] = 2 if self.rng.random() < 0.4 else 1

    def _colonnes_et_eau(self):
        W = self.size
        # anneau d'eau autour d'une plateforme centrale
        cx, cy = self.boss_c
        for dx in range(-2, 3):
            for dy in range(-2, 3):
                if abs(dx)+abs(dy) in (3, 4) and 0 <= cx+dx < W and 0 <= cy+dy < W:
                    self.grid[cx+dx][cy+dy] = 0  # eau (vide)
        # colonnes antiques
        for i in range(self.diff + 2):
            x = self.rng.randrange(2, W-2); y = self.rng.randrange(2, W-2)
            if self.grid[x][y] == 1 and (x, y) != self.boss_c:
                self.grid[x][y] = 2

    def _arbres_par_ilots(self):
        W = self.size
        # îlots séparés par des groupes d'arbres
        for i in range(self.diff + 3):
            x = self.rng.randrange(1, W-1); y = self.rng.randrange(1, W-1)
            if (x, y) != self.boss_c and self.grid[x][y] == 1:
                self.grid[x][y] = 2  # arbre (obstacle)
        # clairière centrale dégagée
        cx, cy = self.boss_c
        for dx in range(-2, 3):
            for dy in range(-2, 3):
                if 0 <= cx+dx < W and 0 <= cy+dy < W and (cx+dx, cy+dy) != self.boss_c:
                    if self.grid[cx+dx][cy+dy] == 2:
                        self.grid[cx+dx][cy+dy] = 1

    def _piliers_quadrant(self):
        W = self.size
        # piliers dans chaque quadrant, allée centrale dégagée
        cx, cy = self.boss_c
        for dx in range(-3, 4):
            for dy in range(-3, 4):
                if abs(dx)+abs(dy) <= 2:  # allée centrale
                    continue
                if 0 <= cx+dx < W and 0 <= cy+dy < W and (cx+dx, cy+dy) != self.boss_c:
                    if self.rng.random() < 0.35:
                        self.grid[cx+dx][cy+dy] = 2

    def _murs_fluides(self):
        W = self.size
        for _ in range(self.diff * 2):
            x = self.rng.randrange(2, W-2); y = self.rng.randrange(2, W-2)
            if (x, y) != self.boss_c and self.grid[x][y] == 1:
                self.grid[x][y] = 2

    def _esquive_zones(self):
        # s'assurer des chemins ouverts vers le boss (connexité) depuis le sud
        W = self.size
        cx, cy = self.boss_c
        for y in range(cy, W-1):
            if self.grid[cx][y] in (2, 3):
                self.grid[cx][y] = 1
        # un couloir de sécurité latéral
        for x in range(cx-1, -1, -1):
            if self.grid[x][cy] in (2, 3):
                self.grid[x][cy] = 1
        for x in range(cx+1, W):
            if self.grid[x][cy] in (2, 3):
                self.grid[x][cy] = 1

    # ---- coordonnées spawn ----------------------------------------------
    def _spawns(self):
        W = self.size
        cx, cy = self.boss_c
        # joueur/partenaire au sud du boss, sur du sol
        p = None
        for dist in range(1, W):
            y = cy + dist
            if y < W-1 and self.grid[cx][y] == 1:
                p = (cx, y); break
        if p is None:
            p = (cx, cy+1)
        self.player = (p[0], p[1])
        # partenaire : à côté du joueur, mais garanti sur du sol (sinon au joueur)
        self.partner = (max(1, p[0]-1), p[1])
        if self.grid[self.partner[0]][self.partner[1]] != 1:
            self.partner = (min(W-2, p[0]+1), p[1])
        if self.grid[self.partner[0]][self.partner[1]] != 1:
            self.partner = (p[0], max(1, p[1]-1))
        if self.grid[self.partner[0]][self.partner[1]] != 1:
            self.partner = (p[0], p[1])  # repli : même case que le joueur
        # zones d'esquive (points marquables) : cases libres autour
        self.escape = []
        for dx in range(-2, 3):
            for dy in range(-2, 3):
                x, y = cx+dx, cy+dy
                if 0 <= x < W and 0 <= y < W and self.grid[x][y] == 1 and (x, y) != self.boss_c:
                    self.escape.append((x, y))
        self.strategic = [self.escape[i] for i in range(0, len(self.escape), max(1, len(self.escape)//4))]

    # ---- construction .rsmap --------------------------------------------
    def build(self):
        W = self.size
        self._carve()
        self._reconnecter()
        self._spawns()
        # grille de terrain : sol = floor, tout le reste = mur (unbreakable)
        tiles = []
        for x in range(W):
            col = []
            for y in range(W):
                g = self.grid[x][y]
                if g == 1:
                    col.append(tile_data('floor', self.floor_ts, x, y))
                else:
                    col.append(tile_data('unbreakable', self.wall_ts, x, y))
            tiles.append(col)
        # couches décor (légères, cohérentes avec le biome)
        deco = layer('Base', W, W)
        # quelques tuiles décor au sol (motif léger) sur les cases centrales
        # on garde le décor quasi-vide : le terrain autotiles suffit, comme les
        # arènes officielles (cloven_ruins_regice n'a qu'une couche vide).
        layers = [deco]
        # équipe boss
        from_boss = self._boss_team()
        # entités
        obj = {
            '$type': 'RogueEssence.Dungeon.Map, ' + ASSEMBLY,
            'Name': {'DefaultText': self.boss.title() + ' Arena', 'LocalTexts': {}},
            'Released': True, 'Comment': 'Arène générée procéduralement (gen_boss_arena.py). '
                'Boss=%s, type=%s, taille=%dx%d, difficulté=%d, seed=%d.'
                % (self.boss, self.arena_type, W, W, self.diff, self.seed),
            'Begun': False, 'ID': self.boss, 'MapTeams': [from_boss], 'AllyTeams': [],
            'rand': default_rand(), 'AssetName': self.boss,
            'ScriptEvents': {}, 'Music': self.music, 'TileSight': 0, 'CharSight': 0,
            'Status': {}, 'MapEffect': self._map_effect(),
            'TeamSpawns': [], 'MoneyAmount': {'Min': 0, 'Max': 0},
            'ItemSpawns': {'Spawns': {'spawns': {}, 'spawnTotal': 0}},
            'BlankBG': {'AutoTileset': self.wall_ts, 'Associates': [], 'Layers': [], 'NeighborCode': -1},
            'TextureMap': {}, 'Element': self.element,
            'Background': {'$type': 'RogueEssence.Dungeon.MapBG, ' + ASSEMBLY, 'MapLoc': {'X': 0, 'Y': 0},
                'BGAnim': {'AnimIndex': '', 'FrameTime': 1, 'StartFrame': -1, 'EndFrame': -1,
                            'AnimDir': -1, 'Alpha': 255, 'AnimFlip': 0},
                'BGMovement': {'X': 0, 'Y': 0}, 'Parallax': '0, 0', 'RepeatX': False, 'RepeatY': False},
            'ViewCenter': None, 'ViewOffset': {'X': 0, 'Y': 0}, 'HideMinimap': False,
            'NoRescue': True, 'NoSwitching': False, 'MapTurns': 0,
            'CurrentTurnMap': {'CurrentOrder': {'TurnTier': 0, 'Faction': 0, 'TurnIndex': 0}, 'TurnToChar': []},
            'DiscoveryArray': [[False]*W for _ in range(W)],
            'Layers': layers, 'Decorations': [{'Name': 'New Deco', 'Layer': 0, 'Visible': True, 'Anims': []}],
            'Tiles': tiles, 'EdgeView': 0,
            'EntryPoints': [{'Loc': {'X': self.player[0], 'Y': self.player[1]}, 'Dir': 4},
                            {'Loc': {'X': self.partner[0], 'Y': self.partner[1]}, 'Dir': 4}],
            'Items': [],
        }
        return {'Version': '0.8.9.0', 'Object': obj}

    def _boss_team(self):
        bx, by = self.boss_c
        species = self.boss
        element = BOSS_ELEMENT.get(self.boss, 'normal')
        player = {
            'Element1': element, 'Element2': 'none', 'TurnWait': 0, 'TiersUsed': 0,
            'TurnUsed': False, 'movementSpeed': 0, 'dead': False,
            'serializationLoc': {'X': bx, 'Y': by}, 'serializationDir': 0,
            'ProxyName': '', 'ProxySprite': {'Species': '', 'Form': -1, 'Skin': '', 'Gender': -1},
            'CurrentForm': {'Species': species, 'Form': 0, 'Skin': 'normal', 'Gender': 0},
            'ProxyAtk': -1, 'ProxyDef': -1, 'ProxyMAtk': -1, 'ProxyMDef': -1, 'ProxySpeed': -1,
            'Skills': [], 'Intrinsics': [], 'EquippedItem': {'ID': 'held_power_band', 'Cursed': False,
                'HiddenValue': '', 'Amount': 0, 'Price': 0},
            'Absentee': False, 'ChargeBoost': 0, 'HP': 100, 'HPRemainder': 0, 'Fullness': 100,
            'FullnessRemainder': 0, 'MaxFullness': 100, 'StatusEffects': {}, 'MissChain': 0,
            'EXPMarked': False, 'Tactic': {'Name': {'DefaultText': 'Dumb Wander', 'LocalTexts': {}},
                'Released': False, 'Comment': '', 'ID': 'wander_dumb', 'Assignable': False,
                'Plans': []},
            'Mobility': 0, 'CantWalk': False, 'ItemDisabled': False, 'IntrinsicDisabled': False,
            'CanRemoveStuck': False, 'StopItemAtHit': False, 'MovesScrambled': False,
            'ChargeSaver': False, 'WaitToAttack': False, 'CantInteract': False,
            'EnemyOfFriend': False, 'AttackFriend': False, 'TileSight': -1, 'CharSight': -1,
            'Unidentifiable': False, 'Unlocatable': False, 'SeeAllChars': False, 'SeeItems': False,
            'SeeWallItems': False, 'SeeTraps': False, 'CharStates': [],
            'BackRef': {'Assembly': False, 'Index': -1}, 'Nickname': self.boss.title(),
            'OriginalUUID': '', 'OriginalTeam': '', 'BaseForm': {'Species': species, 'Form': 0,
                'Skin': 'normal', 'Gender': 0}, 'Level': 30, 'EXP': 0, 'MaxHPBonus': 0,
            'AtkBonus': 0, 'DefBonus': 0, 'MAtkBonus': 0, 'MDefBonus': 0, 'SpeedBonus': 0,
            'BaseSkills': [], 'BaseIntrinsics': [], 'FormIntrinsicSlot': -1, 'Relearnables': {},
            'Discriminator': 0, 'MetAt': '', 'MetLoc': {'ID': '', 'StructID': {'Segment': -1, 'ID': -1},
                'EntryPoint': -1}, 'DefeatAt': '', 'DefeatLoc': {'ID': '', 'StructID': {'Segment': -1, 'ID': -1},
                'EntryPoint': -1}, 'IsFounder': False, 'IsPartner': False, 'NameLocked': False,
            'IsFavorite': False, 'Unrecruitable': True, 'ActionEvents': [], 'ScriptVars': None,
        }
        return {'$type': 'RogueEssence.Dungeon.MonsterTeam, ' + ASSEMBLY, 'Players': [player],
                'Guests': [], 'inventory': [], 'Name': '', 'LeaderIndex': 0, 'FoeConflict': 0}

    def _map_effect(self):
        return {
            'UniversalStates': [], 'BeforeTryActions': [], 'BeforeActions': [], 'OnActions': [],
            'BeforeExplosions': [], 'BeforeHits': [], 'OnHits': [], 'OnHitTiles': [],
            'AfterActions': [], 'ElementEffects': [], 'OnEquips': [], 'OnPickups': [],
            'BeforeStatusAdds': [], 'OnStatusAdds': [], 'OnStatusRemoves': [],
            'OnMapStatusAdds': [], 'OnMapStatusRemoves': [],
            'OnMapStarts': [{
                'Key': {'str': [-15]},
                'Value': {'$type': 'PMDC.Dungeon.BattlePositionEvent, PMDC',
                    'StartLocs': [{'Loc': {'X': 0, 'Y': 0}, 'Dir': 4}, {'Loc': {'X': -2, 'Y': 0}, 'Dir': 4},
                                  {'Loc': {'X': 0, 'Y': -1}, 'Dir': 4}, {'Loc': {'X': -2, 'Y': -1}, 'Dir': 4}],
                    'Positions': [{'X': 0, 'Y': 0}, {'X': -2, 'Y': 0}, {'X': 0, 'Y': -1}, {'X': -2, 'Y': -1}]},
            }],
            'OnTurnStarts': [], 'OnTurnEnds': [], 'OnMapTurnEnds': [], 'OnWalks': [],
            'OnDeaths': [], 'OnRefresh': [], 'OnMapRefresh': [], 'ModifyHPs': [],
            'RestoreHPs': [], 'InitActionData': [],
        }

    # ---- validation + debug ----------------------------------------------
    def ascii(self):
        W = self.size
        out = []
        for y in range(W):
            row = ''
            for x in range(W):
                g = self.grid[x][y]
                if (x, y) == self.boss_c: row += 'B'
                elif (x, y) == self.player: row += 'P'
                elif (x, y) == self.partner: row += 'T'
                elif g == 0: row += '#'
                elif g == 2: row += 'O'
                elif g == 3: row += '~'
                else: row += '.'
            out.append(row)
        return '\n'.join(out)

    def validate(self):
        W = self.size
        errors = []
        # 1. boss et joueur sur sol
        if self.grid[self.boss_c[0]][self.boss_c[1]] != 1:
            errors.append('boss pas sur sol')
        for label, pos in (('player', self.player), ('partner', self.partner)):
            if self.grid[pos[0]][pos[1]] != 1:
                errors.append('%s pas sur sol' % label)
        # 2. connexité du sol (aucune case inaccessible)
        from collections import deque
        start = self.player
        seen = {start}; q = deque([start])
        sol = {(x, y) for x in range(W) for y in range(W) if self.grid[x][y] == 1}
        while q:
            x, y = q.popleft()
            for dx, dy in ((1,0),(-1,0),(0,1),(0,-1)):
                nx, ny = x+dx, y+dy
                if 0 <= nx < W and 0 <= ny < W and self.grid[nx][ny] == 1 and (nx, ny) not in seen:
                    seen.add((nx, ny)); q.append((nx, ny))
        inaccessibles = sol - seen
        if inaccessibles:
            errors.append('%d case(s) sol inaccessibles' % len(inaccessibles))
        # 3. murs fermés
        for x in range(W):
            if self.grid[x][0] != 0 or self.grid[x][W-1] != 0: errors.append('mur haut/bas ouvert')
            if self.grid[0][x] != 0 or self.grid[W-1][x] != 0: errors.append('mur gauche/droit ouvert')
        # 4. boss atteignable
        if self.boss_c not in seen:
            errors.append('boss inaccessible')
        # 5. positions dans les limites
        for label, pos in (('boss', self.boss_c), ('player', self.player), ('partner', self.partner)):
            if not (0 <= pos[0] < W and 0 <= pos[1] < W):
                errors.append('%s hors limites' % label)
        return errors

    def png(self, out):
        try:
            from PIL import Image
        except ImportError:
            print('PIL absent, PNG ignoré'); return
        W = self.size
        S = 24
        img = Image.new('RGB', (W*S, W*S), (0,0,0))
        px = img.load()
        # palette simple par type de case
        for y in range(W):
            for x in range(W):
                g = self.grid[x][y]
                if (x, y) == self.boss_c: c = (200,0,0)
                elif (x, y) == self.player: c = (0,200,0)
                elif (x, y) == self.partner: c = (0,0,200)
                elif g == 0: c = (40,40,40)
                elif g == 2: c = (120,90,60)
                elif g == 3: c = (200,120,0)
                else: c = (190,190,190)
                for i in range(S):
                    for j in range(S):
                        px[x*S+i, y*S+j] = c
        img.save(out)
        print('PNG ->', out)


def main():
    ap = argparse.ArgumentParser(description='Générateur procédural d\'arènes de boss RogueEssence')
    ap.add_argument('--boss', default='tornadus')
    ap.add_argument('--type', default=None, help='plateforme_celeste/temple_antique/volcan/ruines_englouties/foret_mystique/dimension_obscure')
    ap.add_argument('--taille', type=int, default=30, choices=[20, 30, 50])
    ap.add_argument('--difficulte', type=int, default=2)
    ap.add_argument('--sortie', default=None)
    ap.add_argument('--graine', type=int, default=None)
    ap.add_argument('--png', action='store_true')
    ap.add_argument('--ascii', action='store_true')
    ap.add_argument('--valider', action='store_true')
    a = ap.parse_args()

    seed = a.graine if a.graine is not None else random.randrange(1 << 30)
    gen = ArenaGen(a.boss, a.type, a.taille, a.difficulte, seed)
    doc = gen.build()
    out = a.sortie or ('Data/Map/arene_%s.rsmap' % a.boss.lower())

    # sérialisation compacte (format .rsmap officiel : utf-8-sig, pas d'indent)
    with io.open(out, 'w', encoding='utf-8-sig') as f:
        json.dump(doc, f, ensure_ascii=False, separators=(',', ':'))

    print('Arène générée : %s (%s) %dx%d, difficulté %d, seed %d' % (a.boss, gen.arena_type, a.taille, a.taille, a.difficulte, seed))
    print('  fichier : %s' % out)
    print('  biome  : sol=%s mur=%s élément=%s' % (gen.floor_ts, gen.wall_ts, gen.element))
    print('  boss@%s  joueur@%s  partenaire@%s' % (gen.boss_c, gen.player, gen.partner))
    print('  zones d\'esquive : %d  zones stratégiques : %d' % (len(gen.escape), len(gen.strategic)))

    if a.ascii:
        print('\n--- Grille ASCII ---')
        print(gen.ascii())
    if a.valider or a.png:
        errors = gen.validate()
        print('\n--- Validation ---')
        if errors:
            print('  %d erreur(s) :' % len(errors))
            for e in errors: print('   -', e)
        else:
            print('  OK : arène valide (aucune erreur)')
        if a.png:
            pngout = out.replace('.rsmap', '.png')
            gen.png(pngout)

    # re-parse pour vérifier le JSON valide
    with open(out, encoding='utf-8-sig') as f:
        json.load(f)
    print('  JSON .rsmap valide : OK')


if __name__ == '__main__':
    main()
