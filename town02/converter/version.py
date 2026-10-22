"""Single source of truth for the converter version.

Bumped whenever the extraction/decoding logic changes in a way that can
affect the bytes of emitted artefacts, so provenance manifests stay
comparable across runs.
"""
__version__ = "0.1.0"
