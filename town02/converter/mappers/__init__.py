"""IR -> PMDO mappers.

Each mapper takes an IR object (Ground_IR, Cinematic_IR, Asset_IR)
and returns a staged PMDO artefact (bytes for .rsground, text for Lua,
etc.) plus a provenance update. Mappers document their target PMDO
mechanism and downgrade provenance when a source feature has no exact
runtime equivalent in PMDO 0.8.12.
"""
