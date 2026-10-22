"""Text bank -> Strings/*.resx (staging only, append-only merge).

Placeholder. When implemented, this mapper will:
  1. Read decoded strings from converter/rom_output/02_decode/text/.
  2. Convert their character encoding (GBA text) to UTF-8.
  3. Merge them into Strings/stringsEx.resx (English) and
     Strings/stringsEx.fr.resx (French) using string keys derived from
     the scene id (e.g. SCENE_D01P02_001).
  4. Refuse to overwrite an existing key whose current value differs
     from what we would write, unless --force-strings is passed. This
     protects human-edited translations from being silently reverted.
"""
from __future__ import annotations


def merge_strings(text_bank_ir, *, staging_dir, language: str):
    raise NotImplementedError("strings_to_resx mapper not wired yet.")
