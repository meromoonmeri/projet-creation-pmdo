#!/usr/bin/env python3
"""Intelligent PMDO Ground composition from abstract geometry and learned cells."""
from __future__ import annotations
import base64
import copy
import hashlib
import html
import json
import math
import random
from collections import Counter, defaultdict, deque
from pathlib import Path
from statistics import mean, pstdev
from .assets import _tile_entries
from .ground_library import interpret_ground_intent, select_ground_sources

_TILE_PAYLOAD_CACHE = {}


def load_json(path):
    return json.loads(Path(path).read_text(encoding="utf-8-sig"))


def _has_visual(cell):
    return bool(cell.get("AutoTileset")) or any(layer.get("Frames") for layer in cell.get("Layers", []))


def _valid_visual_cell(cell):
    return all(
        tile_layer.get("FrameLength", 1) > 0 and all(frame.get("Sheet") for frame in tile_layer.get("Frames", []))
        for tile_layer in cell.get("Layers", [])
    )


def _layer_role(name):
    text = str(name).casefold()
    if any(word in text for word in ("river", "water", "lac", "rivière")):
        return "water"
    if any(word in text for word in ("object", "fringe", "decor", "rock", "rocher")):
        return "decoration"
    if any(word in text for word in ("shadow", "ombre")):
        return "shadow"
    if any(word in text for word in ("cliff", "wall", "mur", "ceiling", "plafond")):
        return "structure"
    return "base"


def _water_cells(obj):
    result = set()
    width = len(obj.get("obstacles", []))
    height = len(obj.get("obstacles", [[]])[0]) if width else 0
    for layer in obj.get("Layers", []):
        if _layer_role(layer.get("Name", "")) != "water":
            continue
        tiles = layer.get("Tiles", [])
        if len(tiles) != width or not tiles or len(tiles[0]) != height:
            continue
        for x, column in enumerate(tiles):
            for y, cell in enumerate(column):
                if _has_visual(cell):
                    result.add((x, y))
    return result


def _classes(obj):
    obstacles = obj.get("obstacles", [])
    width, height = len(obstacles), len(obstacles[0]) if obstacles else 0
    water = _water_cells(obj)
    return [[
        "water" if (x, y) in water else "wall" if obstacles[x][y].get("Tags", 0) else "open"
        for y in range(height)
    ] for x in range(width)]


def _mask(classes, x, y):
    target = classes[x][y]
    width, height = len(classes), len(classes[0])
    mask = 0
    for bit, (dx, dy) in enumerate(((0, -1), (1, 0), (0, 1), (-1, 0), (1, -1), (1, 1), (-1, 1), (-1, -1))):
        nx, ny = x + dx, y + dy
        if 0 <= nx < width and 0 <= ny < height and classes[nx][ny] == target:
            mask |= 1 << bit
    return mask


def _topology_role(classes, x, y):
    current = classes[x][y]
    signature = _transition_signature(classes, x, y)
    same = [value == current for value in signature]
    count = sum(same)
    if count == 4:
        return "interior"
    if count == 3:
        missing = "NESW"[same.index(False)]
        return f"edge_toward_{missing}"
    if count == 2:
        indices = [index for index, value in enumerate(same) if value]
        return "straight_ns" if indices == [0, 2] else "straight_ew" if indices == [1, 3] else "corner"
    if count == 1:
        return f"endcap_{'NESW'[same.index(True)]}"
    return "isolated"


def _transition_signature(classes, x, y):
    width, height = len(classes), len(classes[0])
    return tuple(
        classes[x + dx][y + dy] if 0 <= x + dx < width and 0 <= y + dy < height else "outside"
        for dx, dy in ((0, -1), (1, 0), (0, 1), (-1, 0))
    )


def _water_palette_bounds(classes):
    width, height = len(classes), len(classes[0])
    water = {(x, y) for x in range(width) for y in range(height) if classes[x][y] == "water"}
    if not water:
        return None
    depth = {}
    queue = deque()
    for point in water:
        x, y = point
        if any((x + dx, y + dy) not in water for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))):
            depth[point] = 1
            queue.append(point)
    while queue:
        x, y = queue.popleft()
        for point in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
            if point in water and point not in depth:
                depth[point] = depth[(x, y)] + 1
                queue.append(point)
    threshold = max(3, max(depth.values(), default=3) // 2)
    deep = {point for point, value in depth.items() if value >= threshold}
    components = []
    while deep:
        component = {deep.pop()}
        queue = deque(component)
        while queue:
            x, y = queue.popleft()
            for point in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
                if point in deep:
                    deep.remove(point)
                    component.add(point)
                    queue.append(point)
        components.append(component)
    core = max(components, key=len) if components else water
    margin = max(4, threshold + 2)
    return (
        max(0, min(x for x, _ in core) - margin), min(width - 1, max(x for x, _ in core) + margin),
        max(0, min(y for _, y in core) - margin), min(height - 1, max(y for _, y in core) + margin),
    )


def _first_frame_signature(layers, x, y):
    for layer in layers:
        for tile_layer in layer["Tiles"][x][y].get("Layers", []):
            frames = tile_layer.get("Frames", [])
            if frames and frames[0].get("Sheet"):
                frame = frames[0]
                return (frame["Sheet"], int(frame.get("TexLoc", {}).get("X", 0)), int(frame.get("TexLoc", {}).get("Y", 0)))
    return None


def _frame_content_signature(repo, layers, x, y):
    frame_signature = _first_frame_signature(layers, x, y)
    if frame_signature is None or repo is None:
        return frame_signature
    sheet, tex_x, tex_y = frame_signature
    source = repo / "Content/Tile" / f"{sheet}.tile"
    cache_key = source.as_posix()
    if cache_key not in _TILE_PAYLOAD_CACHE:
        _TILE_PAYLOAD_CACHE[cache_key] = dict(_tile_entries(source)[1]) if source.exists() else {}
    payload = _TILE_PAYLOAD_CACHE[cache_key].get((tex_y << 32) | (tex_x & 0xFFFFFFFF))
    return hashlib.sha256(payload).hexdigest() if payload is not None else None


def build_cell_grammar(obj, repo=None):
    classes = _classes(obj)
    pools = defaultdict(list)
    transitions = Counter()
    aligned = _aligned_layers(obj)
    base_layers = [layer for layer in aligned if _layer_role(layer.get("Name", "")) == "base"]
    water_layers = [layer for layer in aligned if _layer_role(layer.get("Name", "")) == "water"]
    terrain_layers = [layer for layer in aligned if _layer_role(layer.get("Name", "")) in ("base", "water", "structure")]
    open_signatures = Counter(
        _frame_content_signature(repo, base_layers, x, y)
        for x in range(len(classes)) for y in range(len(classes[0]))
        if classes[x][y] == "open" and _mask(classes, x, y) == 255
    )
    open_signatures.pop(None, None)
    dominant_open = {signature for signature, _ in open_signatures.most_common(2)}
    path_signature = next((signature for signature, count in open_signatures.most_common()[2:] if count >= max(8, sum(open_signatures.values()) // 250)), None)
    water_signatures = Counter(
        _frame_content_signature(repo, water_layers, x, y)
        for x in range(len(classes)) for y in range(len(classes[0]))
        if classes[x][y] == "water"
    )
    water_signatures.pop(None, None)
    dominant_water = {signature for signature, _ in water_signatures.most_common(3)}
    water_bounds = _water_palette_bounds(classes)
    for x in range(len(classes)):
        for y in range(len(classes[0])):
            cell_class = classes[x][y]
            # Collision-open source cells with no terrain frame are editor void,
            # not legitimate floor variants. Objects alone cannot define soil.
            if cell_class in ("open", "water") and not any(_has_visual(layer["Tiles"][x][y]) and _valid_visual_cell(layer["Tiles"][x][y]) for layer in terrain_layers):
                continue
            source_transition = _transition_signature(classes, x, y)
            if water_bounds and (cell_class == "water" or "water" in source_transition):
                left, right, top, bottom = water_bounds
                if not (left <= x <= right and top <= y <= bottom):
                    continue
            surface = _frame_content_signature(repo, water_layers if cell_class == "water" else base_layers, x, y)
            functional_class = cell_class
            if cell_class == "open":
                source_mask = _mask(classes, x, y)
                if surface == path_signature:
                    functional_class = "path"
                elif source_mask == 255 and dominant_open and surface not in dominant_open:
                    continue
            elif cell_class == "water" and _mask(classes, x, y) == 255 and dominant_water and surface not in dominant_water:
                continue
            pools[(functional_class, _mask(classes, x, y), source_transition)].append((x, y))
            transitions[(functional_class, source_transition)] += 1
    return classes, pools, transitions


def _ellipse_value(x, y, cx, cy, rx, ry):
    return ((x - cx) / max(1, rx)) ** 2 + ((y - cy) / max(1, ry)) ** 2


def _carve_disk(classes, cx, cy, rx, ry, value="open"):
    cells = []
    for x in range(max(1, round(cx - rx - 1)), min(len(classes) - 1, round(cx + rx + 2))):
        for y in range(max(1, round(cy - ry - 1)), min(len(classes[0]) - 1, round(cy + ry + 2))):
            if _ellipse_value(x, y, cx, cy, rx, ry) <= 1:
                classes[x][y] = value
                cells.append((x, y))
    return cells


def _carve_path(classes, points, radius=2):
    result = set()
    for (x1, y1), (x2, y2) in zip(points, points[1:]):
        x, y = round(x1), round(y1)
        dx = 1 if x2 > x else -1 if x2 < x else 0
        dy = 1 if y2 > y else -1 if y2 < y else 0
        while (x, y) != (round(x2), round(y2)):
            for ox in range(-radius, radius + 1):
                for oy in range(-radius, radius + 1):
                    if ox * ox + oy * oy <= radius * radius and 0 < x + ox < len(classes) - 1 and 0 < y + oy < len(classes[0]) - 1:
                        classes[x + ox][y + oy] = "open"
                        result.add((x + ox, y + oy))
            if x != round(x2):
                x += dx
            elif y != round(y2):
                y += dy
        result.add((x, y))
    return result


def _water_regions(classes, centers, rng, path, count):
    regions = []
    for index, (cx, cy) in enumerate(centers[:count]):
        rx, ry = rng.randint(4, 7), rng.randint(3, 5)
        candidates = set()
        for x in range(2, len(classes) - 2):
            for y in range(2, len(classes[0]) - 2):
                wobble = (((x * 13 + y * 7 + index * 19) % 9) - 4) / 22
                if classes[x][y] == "open" and _ellipse_value(x, y, cx, cy, rx, ry) <= 1 + wobble and all(abs(x - px) + abs(y - py) > 3 for px, py in path):
                    candidates.add((x, y))
        # Keep one coherent native pool instead of isolated visual water cells.
        components = []
        remaining = set(candidates)
        while remaining:
            component = {remaining.pop()}
            queue = deque(component)
            while queue:
                x, y = queue.popleft()
                for point in _neighbors4(x, y, len(classes), len(classes[0])):
                    if point in remaining:
                        remaining.remove(point)
                        component.add(point)
                        queue.append(point)
            components.append(component)
        cells = sorted(max(components, key=len) if components else [])
        for x, y in cells:
            classes[x][y] = "water"
        regions.append(cells)
    return regions


def _abstract_clearing(width, height, rng, lake_count):
    classes = [["wall" for _ in range(height)] for _ in range(width)]
    cx, cy = width / 2, height / 2
    for x in range(width):
        for y in range(height):
            noise = ((x * 17 + y * 31 + rng.randrange(7)) % 11) / 90
            if _ellipse_value(x, y, cx, cy, width * .43, height * .39) <= 1 - noise:
                classes[x][y] = "open"
    path_x = width // 2
    waypoints = [(path_x, height - 3), (path_x - 2, height * .66), (path_x + 2, height * .36), (path_x, 2)]
    path = _carve_path(classes, waypoints, 2)
    centers = [(width * .27, height * .32), (width * .72, height * .39), (width * .29, height * .69), (width * .72, height * .71), (width * .51, height * .24)]
    waters = _water_regions(classes, centers, rng, path, lake_count)
    anchors = {"entrance": [path_x, height - 3], "exit": [path_x, 2], "poi": [path_x, height // 2]}
    regions = [{"kind": "clearing", "center": [path_x, height // 2], "role": "primary_open_space"}] + [{"kind": "lake", "index": i + 1, "cell_count": len(cells)} for i, cells in enumerate(waters)]
    return classes, anchors, path, waters, regions


def _abstract_canyon(width, height, rng):
    classes = [["wall" for _ in range(height)] for _ in range(width)]
    points = [(width // 2, height - 3)]
    for index in range(1, 4):
        points.append((round(width * (.26 if index % 2 else .74) + rng.randint(-2, 2)), round(height - 3 - index * (height - 6) / 4)))
    points.append((width // 2, 2))
    path = _carve_path(classes, points, 2)
    regions = []
    for index, point in enumerate(points[1:-1]):
        cells = _carve_disk(classes, point[0], point[1], rng.randint(4, 5), rng.randint(3, 4))
        regions.append({"kind": "canyon_pocket", "center": list(point), "cell_count": len(cells)})
    # A compact native rock mass interrupts the entrance→exit sightline while
    # a deliberately carved side bypass preserves navigation.
    center_x, center_y = width // 2, height // 2
    bypass = _carve_path(classes, [
        (center_x, center_y + 5),
        (center_x - 5, center_y),
        (center_x, center_y - 5),
    ], 1)
    path |= bypass
    blocker = []
    for x in range(center_x - 1, center_x + 2):
        for y in range(center_y - 1, center_y + 2):
            point = (x, y)
            classes[x][y] = "wall"
            path.discard(point)
            blocker.append(point)
    regions.append({
        "kind": "sightline_blocker", "center": [width // 2, height // 2],
        "cell_count": len(blocker), "context_effect": "forces_short_side_bypass",
    })
    return classes, {"entrance": list(points[0]), "exit": list(points[-1]), "poi": list(points[len(points) // 2])}, path, [], regions


def _abstract_courtyard(width, height, rng):
    classes = [["wall" for _ in range(height)] for _ in range(width)]
    cx, cy = width // 2, height // 2
    for x in range(round(width * .18), round(width * .82)):
        for y in range(round(height * .20), round(height * .80)):
            classes[x][y] = "open"
    # Protected court, readable approach around a central monument, and a
    # secondary lateral loop. The focal mass changes how the room is crossed.
    center = _carve_disk(classes, cx, cy, 8, 6)
    left_approach = (cx - 5, cy)
    right_approach = (cx + 5, cy)
    path = _carve_path(classes, [(cx, height - 3), (cx - 5, cy + 5), (cx - 5, cy - 5), (cx, 2)], 2)
    path |= _carve_path(classes, [left_approach, (cx - 5, cy + 5), (cx + 5, cy + 5), right_approach], 2)
    path |= _carve_path(classes, [left_approach, (round(width * .18), cy)], 2)
    path |= _carve_path(classes, [right_approach, (round(width * .82), cy)], 2)
    monument = []
    for x in range(cx - 2, cx + 3):
        for y in range(cy - 2, cy + 3):
            classes[x][y] = "wall"
            path.discard((x, y))
            monument.append((x, y))
    # Four pillars are functional masses, not scattered decoration.
    pillars = []
    for px in (cx - 9, cx + 9):
        for py in (cy - 7, cy + 7):
            for x in range(px - 1, px + 2):
                for y in range(py - 1, py + 2):
                    classes[x][y] = "wall"
                    pillars.append((x, y))
    regions = [
        {"kind": "central_court", "center": [cx, cy], "cell_count": len(center)},
        {"kind": "central_monument", "center": [cx, cy], "cell_count": len(monument), "context_effect": "forces_split_approach"},
        {"kind": "pillar_group", "cell_count": len(pillars), "intentional_symmetry": True},
    ]
    return classes, {"entrance": [cx, height - 3], "exit": [cx, 2], "poi": [cx - 4, cy]}, path, [], regions


def _abstract_cavern(width, height, rng, water_count):
    classes = [["wall" for _ in range(height)] for _ in range(width)]
    centers = [(width * .23, height * .67), (width * .48, height * .45), (width * .75, height * .28), (width * .72, height * .72)]
    regions = []
    for index, (cx, cy) in enumerate(centers):
        cells = _carve_disk(classes, cx, cy, rng.randint(7, 11), rng.randint(5, 8))
        regions.append({"kind": "cavern_chamber", "index": index + 1, "center": [round(cx), round(cy)], "cell_count": len(cells)})
    path = set()
    for left, right in zip(centers, centers[1:]):
        path |= _carve_path(classes, [left, right], 2)
    entrance, exit_point = [round(centers[0][0]), height - 3], [round(centers[-2][0]), 2]
    path |= _carve_path(classes, [entrance, centers[0]], 2)
    path |= _carve_path(classes, [centers[-2], exit_point], 2)
    direct_line = _line_cells(entrance, exit_point)
    los_mid = direct_line[len(direct_line) // 2]
    blocker = []
    for x in range(los_mid[0] - 1, los_mid[0] + 2):
        for y in range(los_mid[1] - 1, los_mid[1] + 2):
            classes[x][y] = "wall"
            path.discard((x, y))
            blocker.append((x, y))
    regions.append({"kind": "sightline_crystal_mass", "center": list(los_mid), "cell_count": len(blocker)})
    water_centers = [(centers[-1][0], centers[-1][1]), (centers[1][0] + 5, centers[1][1] + 4)]
    waters = _water_regions(classes, water_centers, rng, path, water_count)
    regions += [{"kind": "subterranean_pool", "index": i + 1, "cell_count": len(cells)} for i, cells in enumerate(waters)]
    return classes, {"entrance": entrance, "exit": exit_point, "poi": [round(centers[1][0]), round(centers[1][1])]}, path, waters, regions


def _abstract_arena(width, height, rng):
    classes = [["wall" for _ in range(height)] for _ in range(width)]
    cx, cy = width // 2, height // 2
    _carve_disk(classes, cx, cy, min(15, width * .34), min(11, height * .34))
    entrance = [cx, min(height - 3, cy + 8)]
    boss = [cx, max(2, entrance[1] - 6)]
    path = _carve_path(classes, [entrance, boss], 2)
    return classes, {"entrance": entrance, "exit": entrance, "poi": boss, "boss": boss}, path, [], [{"kind": "combat_stage", "center": [cx, cy], "distance": 6}]


def _abstract_layout(concept, width, height, rng, water_count):
    if concept == "clearing_lakes":
        return _abstract_clearing(width, height, rng, water_count)
    if concept == "winding_canyon":
        return _abstract_canyon(width, height, rng)
    if concept == "ancient_courtyard":
        return _abstract_courtyard(width, height, rng)
    if concept == "boss_arena":
        return _abstract_arena(width, height, rng)
    if concept == "crystal_cavern":
        return _abstract_cavern(width, height, rng, max(1, water_count // 2))
    return _abstract_cavern(width, height, rng, 0)


def _neighbors4(x, y, width, height):
    for nx, ny in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
        if 0 <= nx < width and 0 <= ny < height:
            yield nx, ny


def _reachable(classes, start):
    seen = {tuple(start)}
    queue = deque([tuple(start)])
    while queue:
        x, y = queue.popleft()
        for point in _neighbors4(x, y, len(classes), len(classes[0])):
            if classes[point[0]][point[1]] == "open" and point not in seen:
                seen.add(point)
                queue.append(point)
    return seen


def _shortest_path(classes, start, end):
    queue = deque([tuple(start)])
    previous = {tuple(start): None}
    while queue:
        point = queue.popleft()
        if point == tuple(end):
            break
        for neighbor in _neighbors4(*point, len(classes), len(classes[0])):
            if classes[neighbor[0]][neighbor[1]] == "open" and neighbor not in previous:
                previous[neighbor] = point
                queue.append(neighbor)
    if tuple(end) not in previous:
        return []
    result, current = [], tuple(end)
    while current is not None:
        result.append(current)
        current = previous[current]
    return list(reversed(result))


def _repair_geometry(classes, anchors, primary_path):
    repairs = []
    # Remove one-cell spikes before tile resolution.
    snapshot = copy.deepcopy(classes)
    for x in range(1, len(classes) - 1):
        for y in range(1, len(classes[0]) - 1):
            same = sum(snapshot[nx][ny] == snapshot[x][y] for nx, ny in _neighbors4(x, y, len(classes), len(classes[0])))
            if same == 0 and (x, y) not in primary_path:
                replacement = Counter(snapshot[nx][ny] for nx, ny in _neighbors4(x, y, len(classes), len(classes[0]))).most_common(1)[0][0]
                classes[x][y] = replacement
                repairs.append({"action": "remove_single_cell_spike", "position": [x, y], "from": snapshot[x][y], "to": replacement})
    # Critical route always wins over masses and water.
    for x, y in primary_path:
        if classes[x][y] != "open":
            repairs.append({"action": "clear_primary_route", "position": [x, y], "from": classes[x][y]})
            classes[x][y] = "open"
    reachable = _reachable(classes, anchors["entrance"])
    for label in ("exit", "poi"):
        target = tuple(anchors[label])
        if target not in reachable:
            _carve_path(classes, [anchors["entrance"], anchors[label]], 2)
            repairs.append({"action": "connect_critical_anchor", "anchor": label})
            reachable = _reachable(classes, anchors["entrance"])
    # Open cells must be gameplay space, not unreachable visual holes.
    all_open = {(x, y) for x in range(len(classes)) for y in range(len(classes[0])) if classes[x][y] == "open"}
    remaining = all_open - reachable
    while remaining:
        start = next(iter(remaining))
        component = {start}
        queue = [start]
        remaining.remove(start)
        while queue:
            point = queue.pop()
            for neighbor in _neighbors4(*point, len(classes), len(classes[0])):
                if neighbor in remaining:
                    remaining.remove(neighbor)
                    component.add(neighbor)
                    queue.append(neighbor)
        if len(component) < 20:
            for x, y in component:
                classes[x][y] = "wall"
            repairs.append({"action": "seal_unreachable_open_pocket", "cell_count": len(component), "origin": list(start)})
        else:
            source = min(component, key=lambda point: min(abs(point[0]-x)+abs(point[1]-y) for x,y in reachable))
            target = min(reachable, key=lambda point: abs(point[0]-source[0])+abs(point[1]-source[1]))
            _carve_path(classes, [source, target], 2)
            repairs.append({"action": "connect_open_region", "cell_count": len(component), "from": list(source), "to": list(target)})
        reachable = _reachable(classes, anchors["entrance"])
    return repairs


def _hamming(left, right):
    return (left ^ right).bit_count()


def _coherent_source_choice(cells, preferred, rng, quality=None):
    if quality:
        best = max(quality.get(point, 0) for point in cells)
        if best > 0:
            cells = [point for point in cells if quality.get(point, 0) == best]
    if not preferred:
        return cells[rng.randrange(len(cells))]
    def distance(point):
        return sum(abs(point[0] - target[0]) + abs(point[1] - target[1]) for target in preferred)
    minimum = min(distance(point) for point in cells)
    nearest = [point for point in cells if distance(point) == minimum]
    return nearest[rng.randrange(len(nearest))]


def _pick_source(pools, cell_class, mask, signature, rng, preferred=None, quality=None):
    exact = pools.get((cell_class, mask, signature), [])
    if exact:
        return _coherent_source_choice(exact, preferred, rng, quality), True, 0, "exact_class_mask_transition_local_adjacency"
    same_class = [(key_mask, key_signature, cells) for (key_class, key_mask, key_signature), cells in pools.items() if key_class == cell_class]
    if not same_class and cell_class == "path":
        same_class = [(key_mask, key_signature, cells) for (key_class, key_mask, key_signature), cells in pools.items() if key_class == "open"]
    if not same_class and cell_class in ("wall", "water"):
        same_class = [(key_mask, key_signature, cells) for (key_class, key_mask, key_signature), cells in pools.items() if key_class in ("wall", "water")]
    if not same_class:
        raise ValueError(f"No source cell for class {cell_class}")
    def distance(row):
        key_mask, key_signature, _ = row
        transition = sum(a != b for a, b in zip(signature, key_signature))
        return _hamming(mask, key_mask) + transition * 2
    minimum = min(distance(row) for row in same_class)
    nearest = [cells for row_mask, row_signature, cells in same_class if distance((row_mask, row_signature, cells)) == minimum]
    cells = [point for group in nearest for point in group]
    return _coherent_source_choice(cells, preferred, rng, quality), False, minimum, "nearest_same_functional_class_local_adjacency"


def _empty_cell():
    return {"AutoTileset": "", "Associates": [], "Layers": [], "NeighborCode": -1}


def _aligned_layers(obj):
    width = len(obj.get("obstacles", []))
    height = len(obj.get("obstacles", [[]])[0]) if width else 0
    return [layer for layer in obj.get("Layers", []) if len(layer.get("Tiles", [])) == width and layer.get("Tiles") and len(layer["Tiles"][0]) == height]


def _extract_motifs(obj):
    classes = _classes(obj)
    motifs = []
    for layer in _aligned_layers(obj):
        if _layer_role(layer.get("Name", "")) != "decoration":
            continue
        tiles = layer["Tiles"]
        points = {(x, y) for x, column in enumerate(tiles) for y, cell in enumerate(column) if _has_visual(cell)}
        while points:
            start = min(points)
            points.remove(start)
            component = {start}
            queue = [start]
            while queue:
                x, y = queue.pop()
                for nx in range(x - 1, x + 2):
                    for ny in range(y - 1, y + 2):
                        if (nx, ny) in points:
                            points.remove((nx, ny))
                            component.add((nx, ny))
                            queue.append((nx, ny))
            x0, x1 = min(x for x, _ in component), max(x for x, _ in component)
            y0, y1 = min(y for _, y in component), max(y for _, y in component)
            if not (2 <= len(component) <= 24 and x1 - x0 <= 8 and y1 - y0 <= 8):
                continue
            cells = []
            unsafe = False
            for x, y in sorted(component):
                cell = copy.deepcopy(tiles[x][y])
                if any(not frame.get("Sheet") for tile_layer in cell.get("Layers", []) for frame in tile_layer.get("Frames", [])):
                    unsafe = True
                    break
                cells.append({"offset": [x - x0, y - y0], "cell": cell, "source_class": classes[x][y]})
            if unsafe:
                continue
            signature = hashlib.sha256(json.dumps([[row["offset"], row["source_class"]] for row in cells]).encode()).hexdigest()[:12]
            motifs.append({
                "motif_id": f"{obj.get('AssetName','ground')}:{layer.get('Name')}:{x0}:{y0}",
                "signature": signature, "layer_name": layer.get("Name"),
                "width": x1 - x0 + 1, "height": y1 - y0 + 1,
                "cells": cells, "source_origin": [x0, y0],
            })
    return motifs


def _distance_to_critical(point, critical):
    return min(abs(point[0] - x) + abs(point[1] - y) for x, y in critical)


def _apply_motifs(data, classes, motifs, anchors, primary_path, rng, target_count=8):
    obj = data["Object"]
    width, height = len(classes), len(classes[0])
    layers = {layer.get("Name"): layer for layer in obj.get("Layers", [])}
    critical = set(primary_path) | {tuple(anchors[key]) for key in ("entrance", "exit", "poi")}
    occupied, groups, use = set(), [], Counter()
    candidates = []
    for x in range(2, width - 10):
        for y in range(2, height - 10):
            near_mass = any(classes[nx][ny] != "open" for nx, ny in _neighbors4(x, y, width, height))
            if near_mass and _distance_to_critical((x, y), critical) >= 4:
                candidates.append((x, y))
    rng.shuffle(candidates)
    for motif in sorted(motifs, key=lambda row: (-len(row["cells"]), -(row["width"] * row["height"]), row["signature"])):
        if len(groups) >= target_count:
            break
        if use[motif["signature"]] >= 2:
            continue
        layer = layers.get(motif["layer_name"])
        if layer is None:
            # Cross-library compatible layer: retain metadata, create empty grid.
            source_layer = next((row for row in obj.get("Layers", []) if row.get("Name") == motif["layer_name"]), None)
            if source_layer is None:
                continue
            layer = source_layer
        for x0, y0 in candidates:
            placements = [(x0 + row["offset"][0], y0 + row["offset"][1], row) for row in motif["cells"]]
            if any(not (0 <= x < width and 0 <= y < height) or (x, y) in occupied or (x, y) in critical or classes[x][y] != row["source_class"] for x, y, row in placements):
                continue
            for x, y, row in placements:
                layer["Tiles"][x][y] = copy.deepcopy(row["cell"])
                occupied.add((x, y))
            groups.append({
                "group_id": f"DG{len(groups)+1:02d}", "motif_id": motif["motif_id"],
                "signature": motif["signature"], "layer": motif["layer_name"],
                "origin": [x0, y0], "cell_count": len(placements),
                "transformed": False,
                "purpose": "major_native_cluster" if len(placements) >= 8 else "supporting_native_cluster" if len(placements) >= 4 else "mass_edge_accent",
                "reason": "motif multicellule natif placé sans rotation et hors route critique",
            })
            use[motif["signature"]] += 1
            break
    return groups


def _prototype_entity(repo, object_name=None, marker_name=None):
    source = load_json(repo / "Data/Ground/searing_tunnel_midpoint.rsground")["Object"]
    for layer in source.get("Entities", []):
        rows = layer.get("GroundObjects", []) if object_name else layer.get("Markers", [])
        for row in rows:
            if row.get("EntName") == (object_name or marker_name):
                return copy.deepcopy(row)
    return None


def _set_collider(entity, cell, size=16):
    entity["Collider"] = {"X": cell[0] * 8, "Y": cell[1] * 8, "Width": size, "Height": size}
    return entity


def _component_count(classes, target):
    points = {(x, y) for x in range(len(classes)) for y in range(len(classes[0])) if classes[x][y] == target}
    count = 0
    while points:
        count += 1
        start = points.pop()
        queue = [start]
        while queue:
            x, y = queue.pop()
            for point in _neighbors4(x, y, len(classes), len(classes[0])):
                if point in points:
                    points.remove(point)
                    queue.append(point)
    return count


def _asset_refs(data):
    sheets, animated, water_animated, water_visual = set(), 0, 0, 0
    for layer in data["Object"].get("Layers", []):
        role = _layer_role(layer.get("Name", ""))
        for column in layer.get("Tiles", []):
            for cell in column:
                if cell.get("AutoTileset"):
                    sheets.add(cell["AutoTileset"])
                if role == "water" and _has_visual(cell):
                    water_visual += 1
                for tile_layer in cell.get("Layers", []):
                    frames = tile_layer.get("Frames", [])
                    is_animated = len(frames) > 1
                    animated += is_animated
                    water_animated += role == "water" and is_animated
                    for frame in frames:
                        if frame.get("Sheet"):
                            sheets.add(frame["Sheet"])
    return sheets, animated, water_animated, water_visual


def _line_cells(start, end):
    x1, y1 = start
    x2, y2 = end
    points = []
    dx, dy = abs(x2 - x1), -abs(y2 - y1)
    sx, sy = 1 if x1 < x2 else -1, 1 if y1 < y2 else -1
    error = dx + dy
    while True:
        points.append((x1, y1))
        if (x1, y1) == (x2, y2):
            break
        doubled = 2 * error
        if doubled >= dy:
            error += dy
            x1 += sx
        if doubled <= dx:
            error += dx
            y1 += sy
    return points


def _geometry_metrics(classes, anchors, regions, primary_path):
    reachable = _reachable(classes, anchors["entrance"])
    objective = anchors.get("boss", anchors["exit"])
    shortest = _shortest_path(classes, anchors["entrance"], objective)
    open_points = [(x, y) for x in range(len(classes)) for y in range(len(classes[0])) if classes[x][y] == "open"]
    neighbor_counts = [sum(classes[nx][ny] == "open" for nx, ny in _neighbors4(x, y, len(classes), len(classes[0]))) for x, y in shortest]
    all_open_degrees = [sum(classes[nx][ny] == "open" for nx, ny in _neighbors4(x, y, len(classes), len(classes[0]))) for x, y in open_points]
    choke_points = sum(value <= 2 for value in neighbor_counts[2:-2])
    junctions = sum(value >= 3 for value in neighbor_counts)
    dead_ends = sum(value <= 1 for value in all_open_degrees)
    graph_edges = sum(all_open_degrees) / 2
    loop_density = max(0, graph_edges - len(open_points) + 1) / max(1, len(open_points))
    widths = []
    for x, y in shortest:
        radius = 0
        for distance in range(1, 5):
            if all(0 <= x + dx < len(classes) and 0 <= y + dy < len(classes[0]) and classes[x + dx][y + dy] == "open" for dx, dy in ((distance, 0), (-distance, 0), (0, distance), (0, -distance))):
                radius = distance
            else:
                break
        widths.append(radius * 2 + 1)
    return {
        "reachable_ratio": len(reachable) / max(1, len(open_points)),
        "shortest_path_length": len(shortest),
        "path_directness": (abs(anchors["entrance"][0] - objective[0]) + abs(anchors["entrance"][1] - objective[1])) / max(1, len(shortest)),
        "boss_distance": abs(anchors["entrance"][0] - anchors["boss"][0]) + abs(anchors["entrance"][1] - anchors["boss"][1]) if "boss" in anchors else None,
        "path_width_mean": mean(widths) if widths else 0,
        "path_width_variation": pstdev(widths) if len(widths) > 1 else 0,
        "choke_points": choke_points,
        "junctions": junctions,
        "dead_end_count": dead_ends,
        "circulation_loop_density": round(loop_density, 4),
        "direct_line_of_sight_clear": all(classes[x][y] == "open" for x, y in _line_cells(anchors["entrance"], objective)),
        "open_ratio": len(open_points) / max(1, len(classes) * len(classes[0])),
        "functional_region_count": len(regions),
        "primary_path_protected": all(classes[x][y] == "open" for x, y in primary_path),
    }


def _validate_ground(repo, data, classes, anchors, regions, primary_path, resolution, decoration_groups, concept):
    obj = data["Object"]
    width, height = len(classes), len(classes[0])
    errors, warnings = [], []
    if obj.get("TexSize") != 1:
        errors.append({"code": "UNSUPPORTED_TEX_SIZE", "value": obj.get("TexSize")})
    if any(len(layer.get("Tiles", [])) != width or any(len(column) != height for column in layer.get("Tiles", [])) for layer in obj.get("Layers", [])):
        errors.append({"code": "LAYER_DIMENSION_MISMATCH"})
    roles = [_layer_role(layer.get("Name", "")) for layer in obj.get("Layers", [])]
    if "base" not in roles:
        errors.append({"code": "MISSING_BASE_LAYER"})
    if "water" in roles and roles.index("water") < roles.index("base"):
        errors.append({"code": "LAYER_ORDER_INVALID", "roles": roles})
    for layer_index, layer in enumerate(obj.get("Layers", [])):
        for x, column in enumerate(layer.get("Tiles", [])):
            for y, cell in enumerate(column):
                for tile_layer in cell.get("Layers", []):
                    if tile_layer.get("FrameLength", 1) <= 0 or any(not frame.get("Sheet") for frame in tile_layer.get("Frames", [])):
                        errors.append({"code": "INVALID_ANIMATION_FRAME", "layer": layer_index, "position": [x, y]})
                        break
    geometry = _geometry_metrics(classes, anchors, regions, primary_path)
    if geometry["reachable_ratio"] < 1 or not geometry["primary_path_protected"]:
        errors.append({"code": "NAVIGATION_DISCONNECTED", "metrics": geometry})
    water_components = _component_count(classes, "water")
    expected_water = sum(region.get("kind") in ("lake", "subterranean_pool") and region.get("cell_count", 0) > 0 for region in regions)
    if water_components != expected_water:
        errors.append({"code": "WATER_COMPONENT_COUNT", "expected": expected_water, "actual": water_components})
    for x in range(1, width - 1):
        for y in range(1, height - 1):
            if classes[x][y] == "water" and sum(classes[nx][ny] == "water" for nx, ny in _neighbors4(x, y, width, height)) == 0:
                errors.append({"code": "ORPHAN_WATER_CELL", "position": [x, y]})
                break
    sheets, animations, water_animations, water_visual = _asset_refs(data)
    missing = [sheet for sheet in sheets if sheet and not (repo / "Content/Tile" / f"{sheet}.tile").exists()]
    if missing:
        errors.append({"code": "MISSING_SHEETS", "sheets": sorted(missing)})
    water_cells = sum(classes[x][y] == "water" for x in range(width) for y in range(height))
    animation_coverage = water_animations / max(1, water_visual)
    if water_cells and not water_animations:
        errors.append({"code": "STATIC_WATER_WHILE_NATIVE_ANIMATION_EXPECTED"})
    fallback_ratio = resolution["fallback_cells"] / max(1, width * height)
    severe_fallbacks = [row for row in resolution["fallback_details"] if row["distance"] > 4]
    if fallback_ratio > .30 or severe_fallbacks:
        errors.append({"code": "WEAK_TOPOLOGY_GRAMMAR_COVERAGE", "ratio": round(fallback_ratio, 4), "severe": severe_fallbacks[:16]})
    entities = [row for layer in obj.get("Entities", []) for row in layer.get("GroundObjects", []) + layer.get("Markers", [])]
    for row in entities:
        collider = row.get("Collider", {})
        if collider.get("X", 0) < 0 or collider.get("Y", 0) < 0 or collider.get("X", 0) >= width * 8 or collider.get("Y", 0) >= height * 8:
            errors.append({"code": "ENTITY_OUT_OF_BOUNDS", "entity": row.get("EntName"), "collider": collider})
    if geometry["path_width_mean"] < 2.5:
        errors.append({"code": "PATH_TOO_NARROW", "mean": geometry["path_width_mean"]})
    if concept == "boss_arena" and (geometry["boss_distance"] is None or geometry["boss_distance"] > 6):
        errors.append({"code": "BOSS_TOO_FAR", "distance": geometry["boss_distance"], "limit": 6})
    if geometry["choke_points"] > max(4, geometry["shortest_path_length"] // 5):
        warnings.append({"code": "EXCESSIVE_CHOKEPOINTS", "count": geometry["choke_points"]})
    if concept != "boss_arena" and geometry["shortest_path_length"] < max(width, height) * .55:
        warnings.append({"code": "PATH_TOO_DIRECT", "length": geometry["shortest_path_length"]})
    if concept in ("winding_canyon", "crystal_cavern", "organic_exploration") and geometry["direct_line_of_sight_clear"]:
        errors.append({
            "code": "UNCONTROLLED_OBJECTIVE_SIGHTLINE",
            "location": {"from": anchors["entrance"], "to": anchors.get("boss", anchors["exit"])},
            "rule": "non_arena_exploration_requires_sightline_interruption",
            "asset": "abstract_geometry_before_tiles",
        })
    if any(group.get("transformed") for group in decoration_groups):
        errors.append({"code": "UNSAFE_DECORATION_TRANSFORM"})
    return {
        "result": "GROUND_VALIDATION_PASS" if not errors else "GROUND_VALIDATION_FAIL",
        "errors": errors, "warnings": warnings,
        "geometry": {key: round(value, 4) if isinstance(value, float) else value for key, value in geometry.items()},
        "navigation_reachable_cells": round(geometry["reachable_ratio"] * sum(classes[x][y] == "open" for x in range(width) for y in range(height))),
        "water_component_count": water_components,
        "referenced_sheet_count": len(sheets), "animation_cell_count": animations,
        "water_animation_coverage": round(animation_coverage, 4),
        "topology_exact_ratio": round(resolution["exact_cells"] / max(1, width * height), 4),
        "topology_fallback_ratio": round(fallback_ratio, 4),
        "decoration_group_count": len(decoration_groups),
        "decoration_motif_diversity": round(len({row["signature"] for row in decoration_groups}) / max(1, len(decoration_groups)), 4),
        "viewport_policy": "local_follow_camera_no_forced_zoom",
        "size_cells": [width, height], "size_pixels": [width * 8, height * 8],
    }


def _build_layers(source_obj, source_classes, width, height):
    layers, excluded = [], []
    for source_layer in source_obj.get("Layers", []):
        tiles = source_layer.get("Tiles", [])
        if len(tiles) != len(source_classes) or not tiles or len(tiles[0]) != len(source_classes[0]):
            excluded.append({"name": source_layer.get("Name"), "reason": "source_layer_grid_not_cell_aligned"})
            continue
        layer = copy.deepcopy(source_layer)
        layer["Tiles"] = [[_empty_cell() for _ in range(height)] for _ in range(width)]
        layers.append(layer)
    return layers, excluded


def _candidate(repo, selection, ground_id, seed, variant, width, height, water_count):
    base_path = repo / selection["base"]["source_file"]
    decor_path = repo / selection["decoration"]["source_file"]
    source = load_json(base_path)
    source_obj = source["Object"]
    source_classes, pools, transitions = build_cell_grammar(source_obj, repo)
    shoreline_layers = [
        layer for layer in _aligned_layers(source_obj)
        if _layer_role(layer.get("Name", "")) in ("structure", "shadow")
    ]
    shoreline_quality = {
        (x, y): sum(_has_visual(layer["Tiles"][x][y]) and _valid_visual_cell(layer["Tiles"][x][y]) for layer in shoreline_layers)
        for x in range(len(source_classes)) for y in range(len(source_classes[0]))
    }
    rng = random.Random(int.from_bytes(hashlib.sha256(f"{seed}|ground-v2|{variant}".encode()).digest()[:8], "little"))
    concept = selection["intent"]["concept"]
    classes, anchors, primary_path, water_regions, regions = _abstract_layout(concept, width, height, rng, water_count)
    repairs = _repair_geometry(classes, anchors, primary_path)
    data = copy.deepcopy(source)
    obj = data["Object"]
    obj["AssetName"] = ground_id
    obj["Name"] = {"DefaultText": ground_id.replace("_", " ").title(), "LocalTexts": {"fr": ground_id.replace("_", " ").title()}}
    obj["Comment"] = f"Ground Smart Dungeon v2 inédit; base {base_path.name}; décor {decor_path.name}; concept {concept}; seed {seed}; variante {variant}."
    obj["TexSize"] = 1
    obj["ViewCenter"] = None
    obj["ViewOffset"] = {"X": 0, "Y": 0}
    layers, excluded_layers = _build_layers(source_obj, source_classes, width, height)
    exact = fallback = distance_total = 0
    fallback_details = []
    sources = [[None for _ in range(height)] for _ in range(width)]
    render_functions = [[None for _ in range(height)] for _ in range(width)]
    for x in range(width):
        for y in range(height):
            mask = _mask(classes, x, y)
            signature = _transition_signature(classes, x, y)
            preferred = []
            if x and sources[x - 1][y] is not None:
                preferred.append((sources[x - 1][y][0] + 1, sources[x - 1][y][1]))
            if y and sources[x][y - 1] is not None:
                preferred.append((sources[x][y - 1][0], sources[x][y - 1][1] + 1))
            functional_class = "path" if classes[x][y] == "open" and (x, y) in primary_path and mask == 255 else classes[x][y]
            render_functions[x][y] = functional_class
            shoreline_target = (
                (classes[x][y] == "water" and any(value != "water" for value in signature))
                or (classes[x][y] != "water" and "water" in signature)
            )
            source_cell, is_exact, distance, rule = _pick_source(
                pools, functional_class, mask, signature, rng, preferred,
                shoreline_quality if shoreline_target else None,
            )
            sources[x][y] = source_cell
            exact += is_exact
            fallback += not is_exact
            distance_total += distance
            if not is_exact:
                fallback_details.append({
                    "target": [x, y], "functional_class": functional_class,
                    "topology_role": _topology_role(classes, x, y),
                    "target_mask": f"{mask:02x}", "transition": list(signature),
                    "source": list(source_cell), "distance": distance, "rule": rule,
                })
    source_layers = {layer.get("Name"): layer for layer in source_obj["Layers"]}
    base_source_layers = [layer for layer in source_obj["Layers"] if _layer_role(layer.get("Name", "")) == "base"]
    prototype_candidates = sorted({
        point for (functional_class, _, _), cells in pools.items()
        if functional_class == "open" for point in cells
    })
    base_prototype = next((
        point for point in prototype_candidates
        if any(_has_visual(layer["Tiles"][point[0]][point[1]]) and _valid_visual_cell(layer["Tiles"][point[0]][point[1]]) for layer in base_source_layers)
    ), None)
    if base_prototype is None:
        raise ValueError("No valid native base-floor prototype in selected Ground")
    path_candidates = sorted({
        point for (functional_class, _, _), cells in pools.items()
        if functional_class == "path" for point in cells
    })
    path_prototype = next((
        point for point in path_candidates
        if any(_has_visual(layer["Tiles"][point[0]][point[1]]) and _valid_visual_cell(layer["Tiles"][point[0]][point[1]]) for layer in base_source_layers)
    ), base_prototype)
    for layer in layers:
        role = _layer_role(layer.get("Name", ""))
        source_layer = source_layers[layer.get("Name")]
        for x in range(width):
            for y in range(height):
                # Walls retain native silhouettes near the playable boundary;
                # deep off-camera wall mass stays quiet instead of wallpapering
                # an object independently on every blocked cell.
                near_walkable = any(
                    0 <= x + dx < width and 0 <= y + dy < height and classes[x + dx][y + dy] != "wall"
                    for dx in range(-2, 3) for dy in range(-2, 3)
                )
                if role == "decoration" and (classes[x][y] != "wall" or not near_walkable):
                    continue
                near_water = classes[x][y] == "water" or any(
                    0 <= x + dx < width and 0 <= y + dy < height and classes[x + dx][y + dy] == "water"
                    for dx in range(-2, 3) for dy in range(-2, 3)
                )
                if role in ("structure", "shadow"):
                    if classes[x][y] == "wall" and not near_walkable:
                        continue
                    if classes[x][y] != "wall" and not near_water:
                        continue
                sx, sy = sources[x][y]
                source_visual = source_layer["Tiles"][sx][sy]
                if role == "base":
                    prototype = path_prototype if (x, y) in primary_path else base_prototype
                    source_visual = source_layer["Tiles"][prototype[0]][prototype[1]]
                if not _valid_visual_cell(source_visual):
                    continue
                layer["Tiles"][x][y] = copy.deepcopy(source_visual)
    obj["Layers"] = layers
    obj["obstacles"] = [[{
        "Bounds": {"X": x * 8, "Y": y * 8, "Width": 8, "Height": 8},
        "Tags": 0 if classes[x][y] == "open" else 1,
    } for y in range(height)] for x in range(width)]
    decor_obj = load_json(decor_path)["Object"]
    motifs = _extract_motifs(decor_obj)
    # Cross-library layers are added only when compatibility was proved.
    if decor_path != base_path and selection["strategy"] == "compatible_cross_library_decoration":
        existing = {layer.get("Name") for layer in obj["Layers"]}
        for source_layer in _aligned_layers(decor_obj):
            if _layer_role(source_layer.get("Name", "")) == "decoration" and source_layer.get("Name") not in existing:
                layer = copy.deepcopy(source_layer)
                layer["Tiles"] = [[_empty_cell() for _ in range(height)] for _ in range(width)]
                obj["Layers"].append(layer)
                existing.add(layer.get("Name"))
    decoration_groups = _apply_motifs(obj and data, classes, motifs, anchors, primary_path, rng, target_count=max(5, round(width * height / 350)))
    # Entity layer is rebuilt; inherited characters/controllers never leak.
    entity_template = copy.deepcopy(source_obj.get("Entities", [{}])[0])
    entity_template.update({"Name": "Smart Dungeon Entities", "MapChars": [], "Spawners": [], "GroundObjects": [], "Markers": []})
    marker = _prototype_entity(repo, marker_name="Main_Entrance_Marker")
    marker["EntName"] = "Main_Entrance_Marker"
    entity_template["Markers"].append(_set_collider(marker, anchors["entrance"]))
    poi_marker = copy.deepcopy(marker)
    poi_marker["EntName"] = "Point_Of_Interest"
    entity_template["Markers"].append(_set_collider(poi_marker, anchors["poi"]))
    if concept != "boss_arena":
        north = _prototype_entity(repo, object_name="North_Exit")
        north["EntName"] = "North_Exit"
        entity_template["GroundObjects"].append(_set_collider(north, anchors["exit"]))
    obj["Entities"] = [entity_template]
    resolution = {
        "exact_cells": exact, "fallback_cells": fallback,
        "mean_distance": round(distance_total / max(1, width * height), 4),
        "fallback_details": fallback_details,
    }
    validation = _validate_ground(repo, data, classes, anchors, regions, primary_path, resolution, decoration_groups, concept)
    if concept != "organic_exploration" and not selection.get("theme_match", False):
        validation["errors"].append({
            "code": "SEMANTIC_REFERENCE_MISMATCH",
            "location": "reference_selection",
            "rule": "requested_biome_requires_nonzero_native_theme_family_match",
            "asset": selection["base"]["ground_id"],
            "concept": concept,
        })
        validation["result"] = "GROUND_VALIDATION_FAIL"
    metrics = validation["geometry"]
    structural_quality = max(0, min(100,
        55 + metrics["reachable_ratio"] * 25
        + min(1, metrics["path_width_variation"] / 2) * 8
        + min(1, metrics["functional_region_count"] / 4) * 7
        + (5 if concept not in ("winding_canyon", "crystal_cavern", "organic_exploration") or not metrics["direct_line_of_sight_clear"] else 0)
        - len(validation["errors"]) * 18
    ))
    artistic_quality = max(0, min(100,
        45 + validation["topology_exact_ratio"] * 25
        + validation["decoration_motif_diversity"] * 10
        + min(1, len(decoration_groups) / 6) * 8
        + selection["confidence"] * 7
        - validation["topology_fallback_ratio"] * 20
        - len(validation["warnings"]) * 3
    ))
    score = (
        (1000 if validation["result"] == "GROUND_VALIDATION_PASS" else 0)
        + validation["topology_exact_ratio"] * 120
        + metrics["reachable_ratio"] * 100
        + min(1, metrics["path_width_variation"] / 2) * 25
        + validation["decoration_motif_diversity"] * 25
        - validation["topology_fallback_ratio"] * 80
        - len(validation["warnings"]) * 4
    )
    metadata = {
        "schema_version": "2.0.0", "ground_id": ground_id,
        "seed": seed, "variant": variant, "concept": concept,
        "intent_analysis": selection["intent"],
        "ambiguity_policy": "conservative_single_library_no_invented_semantics" if selection["intent"]["confidence"] < 0.55 else "resolved_from_explicit_semantic_cues",
        "reference_selection": {
            "base_ground": selection["base"]["ground_id"],
            "decoration_ground": selection["decoration"]["ground_id"],
            "strategy": selection["strategy"], "compatibility": selection["compatibility"],
            "confidence": selection["confidence"], "theme_match": selection.get("theme_match", False),
            "ranked_candidates": selection["ranked_candidates"],
            "base_sha256": hashlib.sha256(base_path.read_bytes()).hexdigest(),
            "decoration_sha256": hashlib.sha256(decor_path.read_bytes()).hexdigest(),
        },
        "geometry": {
            "classes": ["open", "path", "wall", "water"],
            "regions": regions,
            "anchors": anchors,
            "primary_path_cell_count": len(primary_path),
            "repair_log": repairs,
        },
        "tile_grammar": {
            "source_rule_count": len(pools), "transition_rule_count": len(transitions),
            "functional_source_cells": dict(sorted(Counter(key[0] for key, cells in pools.items() for _ in cells).items())),
            "topology_roles": dict(sorted(Counter(f"{classes[x][y]}:{_topology_role(classes,x,y)}" for x in range(width) for y in range(height)).items())),
            "resolution": resolution,
            "neighbor_mask": "8-neighbor_same-class_plus-4-neighbor-transition-signature_plus-source-local-adjacency",
            "orientation_policy": "native_variants_only_no_flip_no_rotation",
        },
        "decoration": {
            "available_native_motifs": len(motifs),
            "groups": decoration_groups,
            "hierarchy": ["macro_mass", "native_multicell_cluster", "micro_detail"],
        },
        "layers": {"kept": [layer.get("Name") for layer in obj["Layers"]], "excluded": excluded_layers},
        "asset_policy": "existing serialized PMDO cells and compatible native motifs only",
        "quality_scores": {
            "technical_validity": 100 if validation["result"] == "GROUND_VALIDATION_PASS" else 0,
            "structural": round(structural_quality, 3),
            "artistic": round(artistic_quality, 3),
            "selection_policy": "validity_then_balanced_minimum_then_combined_quality_not_scalar_only",
        },
        "validation": validation, "score": round(score, 3),
        "decisions": [
            {"stage": "reference_search", "why": "all indexed Grounds filtered by function, alignment, visuals and confidence"},
            {"stage": "macro_geometry", "why": "regions, routes and masses precede tile selection"},
            {"stage": "local_geometry", "why": "class, 8-neighbor mask and transition signature resolve each native cell"},
            {"stage": "decoration", "why": "native multicell motifs, no transform, route-critical exclusion"},
            {"stage": "repair", "why": "single-cell spikes and disconnected anchors corrected before render"},
            {"stage": "viewport", "why": "camera follows locally; no global zoom override"},
        ],
    }
    return data, metadata


def _controller_script(ground_id, concept, exit_ground=None, exit_marker="Main_Entrance_Marker"):
    route = (
        f"GAME:FadeOut(false, 30)\n  GAME:EnterGroundMap('{exit_ground}', '{exit_marker}')"
        if exit_ground else
        "UI:ResetSpeaker()\n  UI:WaitShowDialogue('Cette sortie doit être reliée par le contrat du donjon parent.')"
    )
    return f'''-- Generated Ground controller; route is explicit or intentionally unresolved.
require 'origin.common'
local {ground_id} = {{}}
function {ground_id}.Init(map) DEBUG.EnableDbgCoro() end
function {ground_id}.Enter(map) GAME:FadeIn(20) end
function {ground_id}.Update(map) end
function {ground_id}.North_Exit_Touch(obj, activator)
  {route}
end
return {ground_id}
'''


def _preview_svg(repo, data, metadata, path):
    """Render the serialized native tile frames, not a schematic placeholder."""
    obj = data["Object"]
    classes = _classes(obj)
    width, height, cell = len(classes), len(classes[0]), 8
    colors = {"open": "#79846f", "wall": "#26342b", "water": "#397b9b"}
    sheet_cache, image_defs, uses, missing_frames = {}, {}, [], []

    def payload_for(frame):
        sheet = frame.get("Sheet", "")
        tex = frame.get("TexLoc", {})
        if sheet not in sheet_cache:
            source = repo / "Content/Tile" / f"{sheet}.tile"
            sheet_cache[sheet] = dict(_tile_entries(source)[1]) if source.exists() else {}
        key = (int(tex.get("Y", 0)) << 32) | (int(tex.get("X", 0)) & 0xFFFFFFFF)
        payload = sheet_cache[sheet].get(key)
        if payload is None:
            missing_frames.append({"sheet": sheet, "tex_loc": [tex.get("X", 0), tex.get("Y", 0)]})
        return payload

    for ground_layer in obj.get("Layers", []):
        for x, column in enumerate(ground_layer.get("Tiles", [])):
            for y, tile in enumerate(column):
                for tile_layer in tile.get("Layers", []):
                    frames = tile_layer.get("Frames", [])
                    if not frames:
                        continue
                    payload = payload_for(frames[0])
                    if payload is None:
                        continue
                    digest = hashlib.sha256(payload).hexdigest()[:20]
                    image_id = f"native_{digest}"
                    image_defs.setdefault(image_id, base64.b64encode(payload).decode("ascii"))
                    uses.append(f'<use href="#{image_id}" x="{x*cell}" y="{42+y*cell}"/>')

    parts = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width*cell}" height="{height*cell+42}" viewBox="0 0 {width*cell} {height*cell+42}" style="image-rendering:pixelated">',
        '<rect width="100%" height="100%" fill="#11141a"/>',
        '<defs>',
    ]
    for image_id, payload in sorted(image_defs.items()):
        parts.append(f'<image id="{image_id}" width="8" height="8" href="data:image/png;base64,{payload}"/>')
    parts.append('</defs>')
    # Collision colors remain only as a background for genuinely transparent
    # native frames; every visible foreground pixel comes from a real `.tile`.
    for x in range(width):
        for y in range(height):
            parts.append(f'<rect x="{x*cell}" y="{42+y*cell}" width="{cell}" height="{cell}" fill="{colors[classes[x][y]]}"/>')
    parts.extend(uses)
    for group in metadata["decoration"]["groups"]:
        x, y = group["origin"]
        footprint = group.get("footprint", [1, 1])
        parts.append(f'<rect x="{x*cell+.5}" y="{42+y*cell+.5}" width="{max(cell,footprint[0]*cell)-1}" height="{max(cell,footprint[1]*cell)-1}" fill="none" stroke="#f2bd72" stroke-width="1" opacity=".7"><title>{html.escape(group["motif_id"])}</title></rect>')
    for layer in obj.get("Entities", []):
        for row in layer.get("GroundObjects", []) + layer.get("Markers", []):
            collider = row.get("Collider", {})
            name = row.get("EntName", "")
            color = "#56d3ff" if "Entrance" in name else "#f4ce63" if "Point" in name else "#62c98a"
            parts.append(f'<circle cx="{collider.get("X",0)+8}" cy="{42+collider.get("Y",0)+8}" r="5" fill="{color}"><title>{html.escape(name)}</title></circle>')
    validation = metadata["validation"]
    parts.append(f'<text x="8" y="17" fill="white" font-family="sans-serif" font-size="12">{html.escape(metadata["ground_id"])} — {html.escape(metadata["concept"])}</text>')
    parts.append(f'<text x="8" y="33" fill="#b8c2cf" font-family="sans-serif" font-size="10">raccords {validation["topology_exact_ratio"]:.1%} · motifs {validation["decoration_group_count"]} · chemin {validation["geometry"]["shortest_path_length"]} · frames natives {len(image_defs)}</text>')
    if missing_frames:
        parts.append(f'<title>{len(missing_frames)} frame(s) sans payload de preview; voir validation</title>')
    parts.append('</svg>')
    path.write_text("\n".join(parts), encoding="utf-8")


def generate_ground(repo: Path, output_dir: Path, ground_id: str, intent: str, seed: int, variants: int = 4, reference: str | None = None, width: int = 64, height: int = 48, knowledge: dict | None = None, exit_ground: str | None = None, exit_marker: str = "Main_Entrance_Marker"):
    repo, output_dir = repo.resolve(), output_dir.resolve()
    interpreted = interpret_ground_intent(intent)
    water_count = 0
    import re
    normalized_intent = intent.casefold()
    for word, value in {"un": "1", "une": "1", "deux": "2", "trois": "3", "quatre": "4", "cinq": "5"}.items():
        normalized_intent = re.sub(rf"\b{word}\b", value, normalized_intent)
    match = re.search(r"(\d+)\s*(?:petits?\s+)?(?:lacs?|bassins?|mares?)", normalized_intent)
    if match:
        water_count = max(1, min(5, int(match.group(1))))
    elif interpreted["requires_water"]:
        water_count = 3 if "plusieurs" in normalized_intent else 2
    selection = select_ground_sources(repo, intent, reference, knowledge)
    candidates = []
    for variant in range(max(1, variants)):
        data, metadata = _candidate(repo, selection, ground_id, seed, variant, width, height, water_count)
        candidates.append((data, metadata))
    data, metadata = max(candidates, key=lambda row: (
        row[1]["validation"]["result"] == "GROUND_VALIDATION_PASS",
        min(row[1]["quality_scores"]["structural"], row[1]["quality_scores"]["artistic"]),
        row[1]["quality_scores"]["structural"] + row[1]["quality_scores"]["artistic"],
        row[1]["score"], -row[1]["variant"],
    ))
    metadata["candidate_comparison"] = [{
        "variant": row[1]["variant"], "score": row[1]["score"],
        "quality_scores": row[1]["quality_scores"],
        "validation": row[1]["validation"]["result"],
        "geometry": row[1]["validation"]["geometry"],
        "warnings": row[1]["validation"]["warnings"],
    } for row in candidates]
    output_dir.mkdir(parents=True, exist_ok=True)
    ground_path = output_dir / f"{ground_id}.rsground"
    metadata_path = output_dir / f"{ground_id}.metadata.json"
    preview_path = output_dir / f"{ground_id}.svg"
    controller_path = output_dir / f"{ground_id}.init.lua"
    ground_path.write_text("\ufeff" + json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
    metadata["controller"] = {
        "file": controller_path.name,
        "status": "routed" if exit_ground else "candidate_requires_parent_route",
        "destination": {"ground": exit_ground, "marker": exit_marker} if exit_ground else None,
        "callbacks": ["Init", "Enter", "Update", "North_Exit_Touch"],
    }
    metadata_path.write_text(json.dumps(metadata, ensure_ascii=False, indent=2), encoding="utf-8")
    controller_path.write_text(_controller_script(ground_id, metadata["concept"], exit_ground, exit_marker), encoding="utf-8")
    _preview_svg(repo, data, metadata, preview_path)
    return {
        "ground_file": ground_path.as_posix(), "metadata_file": metadata_path.as_posix(),
        "preview_file": preview_path.as_posix(), "controller_file": controller_path.as_posix(),
        **metadata,
    }
