"""Format decoders.

Each module documents the format shape (offsets, header layout, opcode
tables), reads a blob extracted by s01, and returns IR objects. Every
decoder is honest: what it does not understand is preserved verbatim
via UnknownOpcode / raw-bytes fields so a later run can lift it.

The decoders describe *how to read GBA format containers*. They do not
contain any Nintendo copyrighted content; they contain the recipe by
which the converter reads the user's local ROM.
"""
