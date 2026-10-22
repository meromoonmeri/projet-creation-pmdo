"""Offline structural simulator of RogueElements' grid floor generation.

Nothing in this package ships to the game.  It exists so the Dungeon Builder
can *prove*, before writing a zone, that a given set of RogueElements
parameters produces varied, traversable topologies.
"""
from .geometry import Rect  # noqa: F401
from .gridplan import GridPlan, FloorPlan  # noqa: F401
from .pipeline import FloorMetrics, FloorResult, draw_floor, measure, place_stairs, signature, similarity  # noqa: F401
from .rooms import RandRange, RoomGen  # noqa: F401
