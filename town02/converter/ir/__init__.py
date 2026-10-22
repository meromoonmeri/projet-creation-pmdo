"""Intermediate representation (IR).

Neutral dataclasses that describe extracted ROM content without any
dependency on the target engine (PMDO). Mapping to PMDO happens later,
in converter/mappers/.
"""
from converter.ir.provenance import AuxRef, Provenance, Status

__all__ = ["AuxRef", "Provenance", "Status"]
