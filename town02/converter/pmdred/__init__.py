"""PMD Red specific resolution logic.

The generic converter/rom/ package inspects any GBA cartridge; the
game-specific "which pointer table is which" work lives here. We keep
it separate so:
  * converter/rom/ stays reusable for other GBA titles later,
  * this package can rely on the local pret checkout (via
    converter/aux_sources/pret.py) as documentation without ever
    copying game content into the repository.

Nothing here reads the ROM directly: the resolver takes an already-
opened RomFile plus the generic InspectionReport and returns a set of
candidates that PASS structural checks (expected entry count, target
compression signatures, target payload plausibility). Concrete decoders
consume these candidates.
"""
