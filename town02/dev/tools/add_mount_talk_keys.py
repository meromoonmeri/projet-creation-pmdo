#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
add_mount_talk_keys.py
Cree les cles de dialogue in-donjon ajoutees pour le Mont Venteux :

  3170-3178  Ganlon (Cranidos)  — par segment
  3180-3188  Shuca  (Mareep)    — par segment
  3200-3212  Partenaire         — Mont Venteux + arenes de boss

Referencees par COMMON.PERSONALITY[317..322] et [330..332]
(halcyon/common.lua). Sans ces entrees, StringKey:ToLocal() ne trouve
rien et renvoie la cle brute (Text.cs:886-899) : le joueur verrait
« TALK_FULL_3170 » a l'ecran.

Les cles sont inserees juste apres TALK_PINCH_3162, pour rester
groupees avec le reste du bloc « expedition ».
"""
import re
import sys
import xml.etree.ElementTree as ET

# (cle, FR, EN)
ENTRIES = [
 # ---- Ganlon : premiere moitie du Mont -------------------------
 ("TALK_FULL_3170",
  "Le vent se lève déjà.[pause=0] Attends de voir plus haut.",
  "The wind's picking up already.[pause=0] Wait until we're higher."),
 ("TALK_FULL_3171",
  "Cette montagne ne veut pas de nous.[pause=20] Tant mieux.[pause=0] Ça motive.",
  "This mountain doesn't want us here.[pause=20] Good.[pause=0] Keeps me sharp."),
 ("TALK_FULL_3172",
  "Garde les pattes au sol.[pause=0] Une rafale mal placée,[pause=10] et tu pars avec.",
  "Keep your feet planted.[pause=0] One bad gust,[pause=10] and off you go."),

 # ---- Ganlon : Cretes ------------------------------------------
 ("TALK_FULL_3173",
  "Ici, le vent ne souffle plus.[pause=20] Il MORD.[pause=0] Serre les rangs.",
  "Up here the wind doesn't blow.[pause=20] It BITES.[pause=0] Close ranks."),
 ("TALK_FULL_3174",
  "On voit la steppe d'ici.[pause=20] On est montés haut, [player].[pause=0] Très haut.",
  "You can see the steppe from here.[pause=20] We climbed high, [player].[pause=0] Very high."),
 ("TALK_FULL_3175",
  "Plus qu'une crête.[pause=0] Ne me fais pas redescendre pour aller te chercher.",
  "One more ridge.[pause=0] Don't make me climb back down to fetch you."),

 # ---- Ganlon : arenes de boss ----------------------------------
 ("TALK_FULL_3176",
  "Enfin quelque chose qui vaut le déplacement.[pause=0] Écarte-toi.",
  "Finally, something worth the trip.[pause=0] Stand back."),
 ("TALK_FULL_3177",
  "Il est plus gros que moi.[pause=20] Il n'est pas plus dur que moi.",
  "It's bigger than me.[pause=20] It isn't tougher than me."),
 ("TALK_FULL_3178",
  "Frappe quand il se pose.[pause=0] C'est le seul moment où il est à nous.",
  "Strike when it lands.[pause=0] That's the only moment it's ours."),

 # ---- Shuca : premiere moitie ----------------------------------
 ("TALK_FULL_3180",
  "Le Mont Venteux ![pause=20] Je l'ai dessiné cent fois sans jamais le voir.",
  "Mt. Windswept![pause=20] I've drawn it a hundred times without ever seeing it."),
 ("TALK_FULL_3181",
  "Ma laine gonfle avec le vent...[pause=20] Je dois avoir l'air ridicule.",
  "My wool puffs right up in this wind...[pause=20] I must look ridiculous."),
 ("TALK_FULL_3182",
  "Ganlon marche devant depuis le départ.[pause=0] Il ne le dira jamais,[pause=10] mais c'est exprès.",
  "Ganlon's walked in front since we started.[pause=0] He'll never say it,[pause=10] but it's on purpose."),

 # ---- Shuca : Cretes -------------------------------------------
 ("TALK_FULL_3183",
  "On est plus haut que les nuages ![pause=20] Personne à la guilde ne me croira.",
  "We're above the clouds![pause=20] Nobody at the guild will believe me."),
 ("TALK_FULL_3184",
  "Le vent hurle si fort ici...[pause=20] On dirait presque une voix.",
  "The wind howls so loud up here...[pause=20] It almost sounds like a voice."),
 ("TALK_FULL_3185",
  "J'ai froid,[pause=10] j'ai peur,[pause=10] et je suis heureuse.[pause=20] Tout en même temps !",
  "I'm cold,[pause=10] I'm scared,[pause=10] and I'm happy.[pause=20] All at once!"),

 # ---- Shuca : arenes de boss -----------------------------------
 ("TALK_FULL_3186",
  "Il est... immense.[pause=20] Bon.[pause=0] Je reste.[pause=0] Je reste !",
  "It's... enormous.[pause=20] Okay.[pause=0] I'm staying.[pause=0] I'm staying!"),
 ("TALK_FULL_3187",
  "Je vise les ailes ![pause=0] S'il ne vole plus,[pause=10] il n'est plus intouchable !",
  "I'm aiming for the wings![pause=0] If it can't fly,[pause=10] it isn't untouchable!"),
 ("TALK_FULL_3188",
  "On est quatre.[pause=20] Il est seul.[pause=0] Je me répète ça depuis tout à l'heure.",
  "There are four of us.[pause=20] It's alone.[pause=0] I've been repeating that to myself."),

 # ---- Partenaire : premiere moitie du Mont ---------------------
 ("TALK_FULL_3200",
  "Chaque palier change le vent.[pause=0] Tu le sens aussi,[pause=10] [player] ?",
  "The wind changes at every level.[pause=0] Do you feel it too,[pause=10] [player]?"),
 ("TALK_FULL_3201",
  "On grimpe depuis ce matin,[pause=10] et le sommet n'a pas l'air plus proche.",
  "We've been climbing since morning,[pause=10] and the summit looks no closer."),
 ("TALK_FULL_3202",
  "Reste près de moi dans les passages étroits.[pause=0] Une chute ici,[pause=10] et c'est fini.",
  "Stay close in the narrow stretches.[pause=0] One fall here,[pause=10] and it's over."),

 # ---- Partenaire : blesse (partage 330/331/332) ----------------
 ("TALK_HALF_3203",
  "Le vent me pousse plus fort quand je suis fatigué...[pause=20] Ça va aller.",
  "The wind pushes harder when I'm tired...[pause=20] I'll be fine."),
 ("TALK_PINCH_3204",
  "Je n'arrive plus...[pause=20] à tenir contre les rafales...",
  "I can't...[pause=20] hold against the gusts anymore..."),

 # ---- Partenaire : Cretes --------------------------------------
 ("TALK_FULL_3205",
  "Cette voix qu'on entend depuis la steppe...[pause=20] elle est plus nette ici.",
  "That voice we've heard since the steppe...[pause=20] it's clearer up here."),
 ("TALK_FULL_3206",
  "Regarde en bas.[pause=20] Tout ce chemin,[pause=10] c'est nous qui l'avons fait.",
  "Look down.[pause=20] All that distance,[pause=10] we covered it ourselves."),
 ("TALK_FULL_3207",
  "Quoi qu'il y ait au sommet,[pause=10] on y arrivera ensemble.[pause=0] Comme toujours.",
  "Whatever waits at the summit,[pause=10] we'll reach it together.[pause=0] Like always."),

 # ---- Partenaire : arenes de boss du Mont ----------------------
 ("TALK_FULL_3208",
  "Il garde ce passage.[pause=20] Il ne nous laissera pas passer en discutant.",
  "It's guarding this pass.[pause=20] It won't let us through by talking."),
 ("TALK_FULL_3209",
  "Reste mobile ![pause=0] Il utilise le vent mieux que nous !",
  "Keep moving![pause=0] It uses the wind better than we do!"),
 ("TALK_FULL_3210",
  "On l'affronte à quatre.[pause=0] Ne nous éparpillons pas,[pause=10] [player] !",
  "We face it four against one.[pause=0] Let's not scatter,[pause=10] [player]!"),
 ("TALK_HALF_3211",
  "Il frappe fort...[pause=20] mais il fatigue aussi.[pause=0] Tenons bon !",
  "It hits hard...[pause=20] but it's tiring too.[pause=0] Let's hold!"),
 ("TALK_PINCH_3212",
  "Je ne peux plus encaisser...[pause=20] Il faut faire quelque chose,[pause=10] vite...",
  "I can't take another hit...[pause=20] We need to do something,[pause=10] fast..."),
]

ANCHOR = 'TALK_PINCH_3162'


def esc(s):
    return s.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;')


def block(key, val, comment=None):
    out = '  <data name="%s" xml:space="preserve">\n    <value>%s</value>\n' % (
        key, esc(val))
    if comment:
        out += '    <comment>%s</comment>\n' % esc(comment)
    out += '  </data>\n'
    return out


def patch(path, idx, comment):
    src = open(path, encoding='utf-8-sig').read()
    existing = {d.get('name') for d in ET.fromstring(src).findall('data')}

    # Point d'insertion : juste apres le bloc </data> de l'ancre.
    m = re.search(r'<data name="' + ANCHOR + r'".*?</data>\s*', src, re.DOTALL)
    if not m:
        raise SystemExit('ancre %s introuvable dans %s' % (ANCHOR, path))

    add, skipped = '', []
    for entry in ENTRIES:
        key, val = entry[0], entry[idx]
        if key in existing:
            skipped.append(key)
            continue
        add += block(key, val, comment)

    if not add:
        print('%-24s rien a ajouter' % path.split('/')[-1])
        return

    src = src[:m.end()] + add + src[m.end():]
    ET.fromstring(src)  # le fichier doit rester un XML valide
    open(path, 'w', encoding='utf-8').write(src)
    n = len(ENTRIES) - len(skipped)
    print('%-24s %d cle(s) ajoutee(s)%s' % (
        path.split('/')[-1], n,
        (' / %d deja presentes' % len(skipped)) if skipped else ''))


def main():
    root = sys.argv[1] if len(sys.argv) > 1 else '.'
    patch(root + '/Strings/stringsEx.fr.resx', 1, None)
    patch(root + '/Strings/stringsEx.resx', 2, 'Expedition - Mt. Windswept')


if __name__ == '__main__':
    main()
