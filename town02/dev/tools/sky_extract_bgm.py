#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sky_extract_bgm.py — extrait les musiques de la ROM Sky EU vers
Content/Music/*.ogg (chaîne 100 % locale, mêmes conventions que
l'extraction Red validée : FluidSynth + ffmpeg imageio).

Chaîne : SOUND/BGM/bgmNNNN.smd (séquence DSE) -> MIDI (skytemple-dse
smdl_to_midi) ; bgmNNNN.swd + bgm.swd (banque principale) -> SF2
(swdl_to_sf2) ; rendu libfluidsynth (pygame-ce) ; encodage libvorbis.

L'INDEX bgmNNNN == la valeur de l'enum music_id pmdsky-debug (prouvé :
bgm0021 = B_DUN_KAIGANNOD « côte/plage » = MUSIC_BEACH_CAVE=21 ;
bgm0057 = B_DUN_KAKUSARET « caché » = MUSIC_CONCEALED_RUINS=57 ;
bgm0059 = B_DUN_AKUMUNONA « cauchemar » = MUSIC_IN_THE_NIGHTMARE=59).

Usage : audio-venv/bin/python sky_extract_bgm.py <id> <"Titre.ogg"> ...
"""
import os
import subprocess
import sys

sys.path.insert(0, '/tmp/skytemple-dse')

REPO = os.path.dirname(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
ROM = os.path.join(REPO, '.runtime-cache', 'sky-rom',
                   'Pokemon Mystery Dungeon - Explorers of Sky (Europe) '
                   '(En,Fr,De,Es,It).nds')
OUT_MUSIC = os.path.join(REPO, 'Content', 'Music')


def main():
    import ctypes
    import ctypes.util
    import glob
    # libfluidsynth embarquée pygame-ce — find_library (ldconfig) ne la
    # voit pas : préchargement + patch de résolution (technique validée
    # par l'extraction Red)
    libs = sorted(glob.glob(os.path.join(
        os.path.dirname(sys.executable), '..', 'lib', 'python*',
        'site-packages', 'pygame_ce.libs', 'libfluidsynth-*')))
    assert libs, 'libfluidsynth introuvable'
    lib_path = os.path.abspath(libs[0])
    ctypes.CDLL(lib_path, mode=ctypes.RTLD_GLOBAL)
    _orig_find = ctypes.util.find_library
    ctypes.util.find_library = lambda name: (
        lib_path if 'fluid' in name else _orig_find(name))
    import fluidsynth  # noqa: E402  (après chargement de la lib)
    from ndspy.rom import NintendoDSRom
    from skytemple_dse.dse.smdl.model import Smdl
    from skytemple_dse.dse.swdl.model import Swdl
    from skytemple_dse.midi.smdl_to_midi import smdl_to_midi
    from skytemple_dse.sf2.swdl_to_sf2 import swdl_to_sf2
    import imageio_ffmpeg

    rom = NintendoDSRom.fromFile(ROM)
    main_bank = Swdl(rom.getFileByName('SOUND/BGM/bgm.swd'))

    args = sys.argv[1:]
    pairs = [(int(args[i]), args[i + 1]) for i in range(0, len(args), 2)]
    for mid, title in pairs:
        smd = Smdl(rom.getFileByName(f'SOUND/BGM/bgm{mid:04d}.smd'))
        swd = Swdl(rom.getFileByName(f'SOUND/BGM/bgm{mid:04d}.swd'))
        internal = smd.header.file_name
        midi = smdl_to_midi(smd)
        mid_p = f'/tmp/bgm{mid:04d}.mid'
        midi.save(mid_p)
        sf2 = swdl_to_sf2(swd, main_bank)
        sf2_p = f'/tmp/bgm{mid:04d}.sf2'
        with open(sf2_p, 'wb') as f:
            sf2.write_to(f)
        # rendu 2 passes (boucle = 2 itérations comme l'extraction Red)
        wav_p = f'/tmp/bgm{mid:04d}.wav'
        fs = fluidsynth.Synth(samplerate=44100)
        sfid = fs.sfload(sf2_p)
        # rendu offline via API séquenceur fichier
        subprocess_ok = False
        try:
            import mido
            mf = mido.MidiFile(mid_p)
            import numpy as np
            import wave
            fs.program_select(0, sfid, 0, 0)
            samples = []
            for msg in mf:
                if msg.time > 0:
                    n = int(msg.time * 44100)
                    if n > 0:
                        samples.append(fs.get_samples(n))
                if msg.is_meta:
                    continue
                if msg.type == 'note_on':
                    fs.noteon(msg.channel, msg.note, msg.velocity)
                elif msg.type == 'note_off':
                    fs.noteoff(msg.channel, msg.note)
                elif msg.type == 'program_change':
                    fs.program_change(msg.channel, msg.program)
                elif msg.type == 'control_change':
                    fs.cc(msg.channel, msg.control, msg.value)
                elif msg.type == 'pitchwheel':
                    fs.pitch_bend(msg.channel, msg.pitch)
            samples.append(fs.get_samples(44100))  # queue de release
            data = np.concatenate(samples).astype(np.int16)
            with wave.open(wav_p, 'wb') as w:
                w.setnchannels(2)
                w.setsampwidth(2)
                w.setframerate(44100)
                w.writeframes(data.tobytes())
            subprocess_ok = True
        finally:
            fs.delete()
        if not subprocess_ok:
            print(f'bgm{mid:04d}: rendu FAIL')
            continue
        ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
        out_p = os.path.join(OUT_MUSIC, title)
        subprocess.run([ffmpeg, '-y', '-loglevel', 'error', '-i', wav_p,
                        '-c:a', 'libvorbis', '-qscale:a', '5',
                        '-ar', '44100', '-ac', '2', out_p], check=True)
        sz = os.path.getsize(out_p)
        print(f'bgm{mid:04d} ({internal}) -> {title} ({sz} octets)')


if __name__ == '__main__':
    main()
