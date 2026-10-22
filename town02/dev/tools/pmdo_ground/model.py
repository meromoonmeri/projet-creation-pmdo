#!/usr/bin/env python3
"""Serializable domain model for the deterministic procedural level designer.

Phase 2 fields are additive: old Phase 1 project JSON remains loadable.
"""
from __future__ import annotations
from dataclasses import asdict, dataclass, field
from typing import Any


@dataclass
class AssetProfile:
    asset_id: str
    source_file: str
    kind: str
    tile_size: int = 0
    sample_count: int = 0
    dominant_rgb: list[int] = field(default_factory=lambda: [0, 0, 0])
    mean_luma: float = 0.0
    mean_saturation: float = 0.0
    alpha_coverage: float = 1.0
    edge_density: float = 0.0
    detail_score: float = 0.0
    symmetry_score: float = 0.0
    usage_blocked_ratio: float | None = None
    role_scores: dict[str, float] = field(default_factory=dict)
    tags: list[str] = field(default_factory=list)
    rarity: float = 0.5
    cluster_id: str = ""
    compatible: list[dict[str, Any]] = field(default_factory=list)
    confidence: float = 0.0
    overridden: bool = False
    # Phase 2 evidence. These fields describe observations, not invented lore.
    usage_count: int = 0
    usage_contexts: list[dict[str, Any]] = field(default_factory=list)
    cooccurring_assets: list[dict[str, Any]] = field(default_factory=list)
    evidence_sources: list[str] = field(default_factory=list)
    material_hints: list[str] = field(default_factory=list)
    ambiguous: bool = False
    uncertainty_reasons: list[str] = field(default_factory=list)
    bridge_clusters: list[str] = field(default_factory=list)

    def to_dict(self):
        return asdict(self)


@dataclass
class DesignBrief:
    name: str
    slug: str
    intent: str
    floors: int = 20
    difficulty: str = "normal"
    boss: bool = False
    mini_bosses: int = 0
    relays: int = 0
    seed: int = 0
    theme_tokens: list[str] = field(default_factory=list)
    mood_start: str = "lisible"
    mood_end: str = "intense"
    topology_start: str = "balanced"
    topology_end: str = "complex"
    water_policy: str = "auto"
    decoration_bias: float = 0.5
    danger_bias: float = 0.5
    constraints: list[str] = field(default_factory=list)
    requested_specials: list[dict[str, Any]] = field(default_factory=list)
    # Phase 2 design axes inferred from natural language.
    composition_preferences: list[str] = field(default_factory=list)
    visual_keywords: list[str] = field(default_factory=list)
    spectacle_bias: float = 0.55
    surprise_budget: float = 0.08
    boss_species: str | None = None
    boss_category: str = "auto"
    narrative_prompt: str = ""

    def to_dict(self):
        return asdict(self)


@dataclass
class Room:
    room_id: int
    kind: str
    x: int
    y: int
    width: int
    height: int
    cells: list[list[int]]
    importance: float = 0.0
    locked: bool = False
    tags: list[str] = field(default_factory=list)
    # Function precedes decoration and explains why this geometry exists.
    function: str = "exploration"
    visual_role: str = "neutral"
    entrances: list[list[int]] = field(default_factory=list)
    design_reason: str = ""

    def to_dict(self):
        return asdict(self)


@dataclass
class FloorPlan:
    floor: int
    seed: int
    width: int
    height: int
    archetype: str
    phase: str
    special: str | None
    subtheme: str
    rooms: list[Room]
    edges: list[list[int]]
    tiles: list[str]
    entrance: list[int]
    exit: list[int]
    points_of_interest: list[dict[str, Any]] = field(default_factory=list)
    decorations: list[dict[str, Any]] = field(default_factory=list)
    quality: dict[str, Any] = field(default_factory=dict)
    repair_log: list[dict[str, Any]] = field(default_factory=list)
    locked_regions: list[dict[str, Any]] = field(default_factory=list)
    # Phase 2 explainable composition model.
    identity: dict[str, Any] = field(default_factory=dict)
    composition_regions: list[dict[str, Any]] = field(default_factory=list)
    spatial_beats: list[dict[str, Any]] = field(default_factory=list)
    landmarks: list[dict[str, Any]] = field(default_factory=list)
    decoration_groups: list[dict[str, Any]] = field(default_factory=list)
    decisions: list[dict[str, Any]] = field(default_factory=list)
    visual_quality: dict[str, Any] = field(default_factory=dict)

    def idx(self, x, y):
        return y * self.width + x

    def get(self, x, y):
        return self.tiles[self.idx(x, y)]

    def set(self, x, y, value):
        self.tiles[self.idx(x, y)] = value

    def to_dict(self):
        return asdict(self)


@dataclass
class RelayPlan:
    relay_id: str
    order: int
    after_floor: int
    previous_segment: int
    next_segment: int
    source_ground: str
    ground_file: str
    script_file: str
    north_route: dict[str, Any]
    south_route: dict[str, Any]
    services: list[str] = field(default_factory=lambda: ["soin", "stockage", "sauvegarde"])
    required_entities: list[str] = field(default_factory=lambda: ["Kangaskhan_Rock", "North_Exit", "South_Exit", "Main_Entrance_Marker"])
    composition: dict[str, Any] = field(default_factory=dict)
    decisions: list[dict[str, Any]] = field(default_factory=list)
    validation: dict[str, Any] = field(default_factory=dict)

    def to_dict(self):
        return asdict(self)


@dataclass
class BossEncounterPlan:
    arena_id: str
    source_ground: str
    ground_file: str
    ground_script_file: str
    scene_script_file: str
    preview_file: str
    battle_segment: int
    boss_species: str
    boss_category: str
    player_position: list[int]
    boss_position: list[int]
    distance_tiles: int
    companions: list[dict[str, Any]] = field(default_factory=list)
    flow: list[str] = field(default_factory=lambda: ["arrivee", "introduction", "dialogue_precombat", "transition_combat", "combat", "victoire", "conclusion", "fin_donjon"])
    dialogue: dict[str, Any] = field(default_factory=dict)
    completion: dict[str, Any] = field(default_factory=dict)
    validation: dict[str, Any] = field(default_factory=dict)
    decisions: list[dict[str, Any]] = field(default_factory=list)

    def to_dict(self):
        return asdict(self)


@dataclass
class DungeonPlan:
    schema_version: str
    brief: DesignBrief
    asset_cluster: str
    asset_selection: dict[str, Any]
    progression: list[dict[str, Any]]
    floors: list[FloorPlan]
    quality_summary: dict[str, Any]
    compiler: dict[str, Any] = field(default_factory=dict)
    art_direction: dict[str, Any] = field(default_factory=dict)
    artistic_quality_summary: dict[str, Any] = field(default_factory=dict)
    decision_log: list[dict[str, Any]] = field(default_factory=list)
    relays: list[RelayPlan] = field(default_factory=list)
    dungeon_profile: dict[str, Any] = field(default_factory=dict)
    reference_knowledge: dict[str, Any] = field(default_factory=dict)
    boss_encounter: BossEncounterPlan | None = None
    generated_grounds: list[dict[str, Any]] = field(default_factory=list)

    def to_dict(self):
        return asdict(self)
