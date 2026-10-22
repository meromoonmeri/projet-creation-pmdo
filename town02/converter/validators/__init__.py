"""Static validators used by stage s06.

Each validator is deliberately narrow, deterministic and fast. It
reports (ok: bool, findings: list[dict]) so s06 can aggregate them
into a single verdict without hiding individual failures.
"""
