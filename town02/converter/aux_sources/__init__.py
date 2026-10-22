"""Auxiliary source loaders (pret/pmd-red, SkyTemple docs).

These modules read technical documentation the user has cloned locally
(git-ignored under dev/external/). The converter uses them to validate
what it extracts from the ROM (e.g. "does this candidate pointer table
have the expected number of dungeons?") without ever copying the
auxiliary sources into this repository.

If the auxiliary source is not present, loaders return None and the
pipeline degrades gracefully (Provenance status downgraded to
RECONSTRUCTED with an explicit reason, per the honesty rule).
"""
from converter.aux_sources.pret import PretCheckout, load_pret_checkout

__all__ = ["PretCheckout", "load_pret_checkout"]
