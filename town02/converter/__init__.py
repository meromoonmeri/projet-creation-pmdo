"""PMD Red EU -> RogueEssence/PMDO converter.

See converter/README.md for the eight-stage architecture. The ROM is
never redistributed; the user drops it into converter/rom_input/ and the
pipeline authenticates it by SHA-256 before doing anything.
"""
from converter.version import __version__

__all__ = ["__version__"]
