"""Converter test suite.

These tests exercise the pipeline architecture WITHOUT any ROM: they
verify that each stage refuses to lie when its inputs are missing, and
that the honest reporting (SKIPPED / UNIMPLEMENTED / FAIL) is emitted
with a specific reason.
"""
