#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
fill_expedition_talk.py
Remplit les 77 cles TALK_*_31xx laissees a l'etat de marqueurs
(« Cranidos Jerk Expedition Comment 1 ») par de vraies repliques.

Ces cles sont lues par BATTLE_SCRIPT.GuildmateInteract
(event_battle.lua:786-826) quand le joueur parle a Ganlon (Cranidos)
ou Shuca (Mareep) DANS un donjon. Sans ce remplissage, le texte
technique s'affiche tel quel en jeu.

Balises disponibles (verifiees event_battle.lua:340-470) :
  [player]        nom de celui qui parle           (l.362)
  [myname]        nom de l'interlocuteur           (l.363)
  [(Nom)]         nom d'un personnage nomme        (l.352-360)
  [slotN]         nom du membre d'equipe N         (l.385-389)
  [move]          une capacite de la cible         (l.391)
  [kind]          une espece de l'etage            (l.406)
  [item]          un objet de l'etage              (l.421)
  [{Espece}]      filtre : ligne visible seulement
                  si l'INTERLOCUTEUR est ce perso  (l.370-377)

Attention : [move]/[kind]/[item] invalident la ligne si la donnee
manque (valid_quote = false) ; on les utilise avec parcimonie et
jamais sur les pools courts PINCH/HALF, qui n'ont que 3 entrees.
"""
import re
import sys
import xml.etree.ElementTree as ET

FR = {
 # --- 310 Ganlon brusque (loin de Shuca) -------------------------
 "TALK_FULL_3100": "Marche devant si tu veux.[pause=0] Moi je frappe ce qui bouge.",
 "TALK_FULL_3101": "Ce donjon ?[pause=0] Des cailloux et du vent.[pause=10] J'ai connu pire.",
 "TALK_FULL_3102": "Tu comptes discuter longtemps,[pause=10] [player] ?[pause=0] On a un sommet à atteindre.",
 "TALK_FULL_3103": "Un [kind] m'a chargé tout à l'heure.[pause=0] Un.[pause=20] Ça n'a pas duré.",
 "TALK_FULL_3104": "Hmph.[pause=0] Tant que personne ne me ralentit,[pause=10] tout va bien.",
 "TALK_HALF_3100": "C'est rien.[pause=0] Un crâne comme le mien,[pause=10] ça ne se fend pas si facilement.",
 "TALK_HALF_3101": "J'ai encaissé.[pause=0] Et alors ?[pause=20] Continue d'avancer.",
 "TALK_HALF_3102": "Ne me regarde pas comme ça.[pause=0] Je tiens debout,[pause=10] c'est l'essentiel.",
 "TALK_PINCH_3100": "Tch...[pause=20] Ça commence à faire beaucoup,[pause=10] même pour moi...",
 "TALK_PINCH_3101": "Je... ne vais pas tomber ici.[pause=0] Pas devant tout le monde...",
 "TALK_PINCH_3102": "Une Baie...[pause=20] si t'en as une en trop.[pause=0] Je demande pas deux fois.",

 # --- 311 Ganlon timide (a cote de Shuca) ------------------------
 "TALK_FULL_3110": "...Quoi ?[pause=0] Je surveille les angles,[pause=10] c'est tout.[pause=0] C'est mon poste.",
 "TALK_FULL_3111": "[(Mareep)] avance bien.[pause=20] ...Enfin.[pause=0] L'équipe avance bien.",
 "TALK_FULL_3112": "Reste groupé.[pause=0] Si quelqu'un se fait encercler ici,[pause=10] ça finit mal.",
 "TALK_FULL_3113": "Je ne suis pas distrait.[pause=20] Je suis... attentif.[pause=0] Nuance.",
 "TALK_FULL_3114": "On parlera au camp.[pause=0] Ici,[pause=10] j'ai besoin de mes oreilles.",
 "TALK_HALF_3110": "Ça va.[pause=0] Ne le répète pas à [(Mareep)],[pause=10] elle s'inquiéterait pour rien.",
 "TALK_HALF_3111": "Quelques bosses.[pause=0] Rien qui m'empêche de couvrir l'arrière.",
 "TALK_HALF_3112": "Je tiens ma place.[pause=20] Occupe-toi de la tienne.",
 "TALK_PINCH_3110": "Ne dis rien à [(Mareep)]...[pause=20] Je t'en prie.",
 "TALK_PINCH_3111": "Je dois tenir...[pause=0] Si je tombe,[pause=10] elle se retrouve à découvert...",
 "TALK_PINCH_3112": "Encore un peu...[pause=20] Juste... encore un peu...",

 # --- 312 Ganlon gene (Shuca lui parle) --------------------------
 "TALK_FULL_3120": "S-Shuca ?![pause=20] Euh.[pause=0] Oui.[pause=0] Tout est sous contrôle.[pause=10] Totalement.",
 "TALK_FULL_3121": "Tu... tu te débrouilles bien,[pause=10] aujourd'hui.[pause=20] Voilà.[pause=0] C'est dit.",
 "TALK_FULL_3122": "Ne t'éloigne pas trop.[pause=20] C'est une consigne tactique ![pause=0] Rien d'autre.",
 "TALK_FULL_3123": "Hein ?[pause=0] Non, je ne te regardais pas.[pause=20] Je regardais... derrière toi.",
 "TALK_FULL_3124": "Si un truc t'approche,[pause=10] tu cries.[pause=0] Et j'arrive.[pause=20] C'est tout.",
 "TALK_HALF_3120": "Ce n'est rien ![pause=20] Vraiment.[pause=0] Ne fais pas cette tête, Shuca...",
 "TALK_HALF_3121": "J-je vais bien.[pause=0] Arrête de me fixer comme ça,[pause=10] tu me déconcentres.",
 "TALK_HALF_3122": "C'est une égratignure.[pause=20] Une grosse égratignure.[pause=0] Ça arrive.",
 "TALK_PINCH_3120": "Ne...[pause=20] ne me regarde pas comme ça.[pause=0] Je suis censé te protéger,[pause=10] moi...",
 "TALK_PINCH_3121": "Je suis désolé, Shuca.[pause=20] Je devais être plus solide que ça.",
 "TALK_PINCH_3122": "Recule.[pause=20] S'il te plaît.[pause=0] Laisse-moi au moins... faire ça bien.",

 # --- 313 Ganlon en colere (Shuca en PV critiques) ---------------
 "TALK_FULL_3130": "REGARDE dans quel état elle est ![pause=20] Soigne-la.[pause=0] MAINTENANT.",
 "TALK_FULL_3131": "Tu l'as laissée en première ligne.[pause=20] Ne refais jamais ça.",
 "TALK_FULL_3132": "Une Baie.[pause=0] Une Baie, tout de suite ![pause=20] Ne discute pas, [player] !",
 "TALK_FULL_3133": "Si elle tombe ici,[pause=10] je ne te le pardonnerai pas.[pause=0] Jamais.",
 "TALK_FULL_3134": "Je me fiche du sommet ![pause=20] Sors-la de là,[pause=10] c'est tout ce qui compte !",
 "TALK_HALF_3130": "Ne t'occupe pas de moi ![pause=20] C'est ELLE qui a besoin d'aide !",
 "TALK_HALF_3131": "Mes blessures attendront.[pause=0] Les siennes,[pause=10] non.",
 "TALK_HALF_3132": "Bouge ![pause=20] Chaque seconde compte,[pause=10] tu ne le vois pas ?!",
 "TALK_PINCH_3130": "On est... tous les deux à terre...[pause=20] Sors-la d'ici.[pause=0] Elle d'abord.",
 "TALK_PINCH_3131": "Laisse-moi...[pause=20] Prends Shuca et pars.[pause=0] C'est un ordre.",
 "TALK_PINCH_3132": "J'ai... échoué...[pause=20] Ne la laisse pas tomber aussi...",

 # --- 314 Ganlon tendre (il parle a Shuca blessee) ---------------
 "TALK_FULL_3140": "Shuca.[pause=20] Reste derrière moi.[pause=0] Je ne te le demande pas deux fois.",
 "TALK_FULL_3141": "Tu tiens le coup ?[pause=20] ...Non.[pause=0] Ne mens pas.[pause=10] Je le vois bien.",
 "TALK_FULL_3142": "Respire.[pause=20] Je suis là.[pause=0] Rien ne t'atteindra tant que je suis debout.",
 "TALK_FULL_3143": "On rentre.[pause=20] Le sommet attendra.[pause=0] Toi, tu n'attendras pas.",
 "TALK_FULL_3144": "Ne t'excuse pas.[pause=20] Tu es venue jusqu'ici.[pause=0] C'est déjà énorme.",
 "TALK_HALF_3140": "Je saigne un peu,[pause=10] et alors ?[pause=0] Toi, tu tiens à peine debout.",
 "TALK_HALF_3141": "Ne pense pas à moi.[pause=20] Pense à respirer.[pause=0] Juste ça.",
 "TALK_HALF_3142": "On est deux à être amochés.[pause=20] Au moins on est deux.",
 "TALK_PINCH_3140": "Shuca...[pause=20] si l'un de nous doit s'en sortir,[pause=10] ce sera toi.",
 "TALK_PINCH_3141": "Reste éveillée.[pause=20] Parle-moi.[pause=0] N'importe quoi,[pause=10] mais parle-moi.",
 "TALK_PINCH_3142": "J'aurais dû...[pause=20] être devant toi.[pause=0] Depuis le début.",

 # --- 315 Shuca (general) ----------------------------------------
 "TALK_FULL_3150": "C'est ma première vraie expédition, tu sais ![pause=0] J'essaie de tout retenir.",
 "TALK_FULL_3151": "Tu crois qu'on racontera ça à la guilde ?[pause=20] Moi j'ai déjà préparé mon récit !",
 "TALK_FULL_3152": "J'ai des provisions pour tout le monde.[pause=0] Demande,[pause=10] surtout !",
 "TALK_FULL_3153": "Un [kind] ![pause=20] J'en avais seulement vu en dessin...",
 "TALK_FULL_3154": "Mes pattes tremblent un peu.[pause=20] Mais c'est de l'excitation ![pause=0] Promis !",
 "TALK_HALF_3150": "Aïe...[pause=0] Bon.[pause=20] Ça pique, mais je continue !",
 "TALK_HALF_3151": "Je me suis pris un mauvais coup...[pause=0] Ne le dis pas à Ganlon,[pause=10] d'accord ?",
 "TALK_HALF_3152": "Je tiens ![pause=20] Je ne veux pas être celle qui ralentit tout le monde.",
 "TALK_PINCH_3150": "J-je ne vois plus très bien...[pause=20] Il me faudrait une Baie...",
 "TALK_PINCH_3151": "Je voulais aller au sommet...[pause=20] avec vous tous...",
 "TALK_PINCH_3152": "Maman avait raison...[pause=20] c'était peut-être trop tôt pour moi...",

 # --- 316 Shuca parle a Ganlon -----------------------------------
 "TALK_FULL_3160": "Ganlon ![pause=0] Tu as vu comme j'ai visé, cette fois ?[pause=20] Hein ?[pause=0] Tu as vu ?",
 "TALK_FULL_3161": "Tu fais semblant d'être ronchon,[pause=10] mais tu m'as encore couverte tout à l'heure.",
 "TALK_FULL_3162": "Merci d'être là.[pause=20] Voilà.[pause=0] Je le dis maintenant,[pause=10] comme ça c'est fait !",
 "TALK_FULL_3163": "Tu grognes tout le temps,[pause=10] mais tu ne me lâches jamais d'une semelle.",
 "TALK_FULL_3164": "Un jour je serai aussi solide que toi.[pause=20] Tu verras !",
 "TALK_HALF_3160": "Ne fais pas cette tête, Ganlon ![pause=0] Ce n'est qu'une éraflure !",
 "TALK_HALF_3161": "Je sais, je sais...[pause=0] « reste derrière ».[pause=20] J'y retourne, promis.",
 "TALK_HALF_3162": "Tu t'inquiètes ?[pause=20] Toi ?[pause=0] ...Ça me fait plaisir, en fait.",
 "TALK_PINCH_3160": "Ganlon...[pause=20] je crois que j'ai besoin d'aide...",
 "TALK_PINCH_3161": "Ne te fâche pas...[pause=20] j'ai vraiment fait de mon mieux...",
 "TALK_PINCH_3162": "Reste près de moi...[pause=20] s'il te plaît...",
}

EN = {
 "TALK_FULL_3100": "Walk ahead if you want.[pause=0] I hit whatever moves.",
 "TALK_FULL_3101": "This dungeon?[pause=0] Rocks and wind.[pause=10] I've seen worse.",
 "TALK_FULL_3102": "Planning to chat all day,[pause=10] [player]?[pause=0] We have a summit to reach.",
 "TALK_FULL_3103": "A [kind] charged me earlier.[pause=0] One.[pause=20] It didn't last.",
 "TALK_FULL_3104": "Hmph.[pause=0] As long as nobody slows me down,[pause=10] we're fine.",
 "TALK_HALF_3100": "It's nothing.[pause=0] A skull like mine,[pause=10] it doesn't crack that easy.",
 "TALK_HALF_3101": "So I took a hit.[pause=0] And?[pause=20] Keep moving.",
 "TALK_HALF_3102": "Don't look at me like that.[pause=0] I'm standing,[pause=10] that's what counts.",
 "TALK_PINCH_3100": "Tch...[pause=20] That's adding up,[pause=10] even for me...",
 "TALK_PINCH_3101": "I'm... not going down here.[pause=0] Not in front of everyone...",
 "TALK_PINCH_3102": "A Berry...[pause=20] if you've got a spare.[pause=0] I won't ask twice.",

 "TALK_FULL_3110": "...What?[pause=0] I'm watching the flanks,[pause=10] that's all.[pause=0] It's my post.",
 "TALK_FULL_3111": "[(Mareep)] is doing well.[pause=20] ...I mean.[pause=0] The team is doing well.",
 "TALK_FULL_3112": "Stay together.[pause=0] If someone gets surrounded here,[pause=10] it ends badly.",
 "TALK_FULL_3113": "I'm not distracted.[pause=20] I'm... attentive.[pause=0] There's a difference.",
 "TALK_FULL_3114": "We'll talk at camp.[pause=0] Out here,[pause=10] I need my ears.",
 "TALK_HALF_3110": "I'm fine.[pause=0] Don't mention it to [(Mareep)],[pause=10] she'd worry over nothing.",
 "TALK_HALF_3111": "A few bruises.[pause=0] Nothing that stops me covering the rear.",
 "TALK_HALF_3112": "I'm holding my position.[pause=20] Mind your own.",
 "TALK_PINCH_3110": "Don't tell [(Mareep)]...[pause=20] Please.",
 "TALK_PINCH_3111": "I have to hold...[pause=0] If I fall,[pause=10] she's left exposed...",
 "TALK_PINCH_3112": "A little longer...[pause=20] Just... a little longer...",

 "TALK_FULL_3120": "S-Shuca?![pause=20] Uh.[pause=0] Yes.[pause=0] Everything's under control.[pause=10] Totally.",
 "TALK_FULL_3121": "You're... doing well today.[pause=20] There.[pause=0] I said it.",
 "TALK_FULL_3122": "Don't wander off.[pause=20] That's a tactical order![pause=0] Nothing else.",
 "TALK_FULL_3123": "Huh?[pause=0] No, I wasn't looking at you.[pause=20] I was looking... behind you.",
 "TALK_FULL_3124": "If something comes at you,[pause=10] you shout.[pause=0] And I come.[pause=20] That's all.",
 "TALK_HALF_3120": "It's nothing![pause=20] Really.[pause=0] Don't make that face, Shuca...",
 "TALK_HALF_3121": "I-I'm fine.[pause=0] Stop staring at me like that,[pause=10] you're breaking my focus.",
 "TALK_HALF_3122": "It's a scratch.[pause=20] A big scratch.[pause=0] It happens.",
 "TALK_PINCH_3120": "Don't...[pause=20] don't look at me like that.[pause=0] I'm supposed to protect you...",
 "TALK_PINCH_3121": "I'm sorry, Shuca.[pause=20] I should have been tougher than this.",
 "TALK_PINCH_3122": "Step back.[pause=20] Please.[pause=0] At least let me... do this right.",

 "TALK_FULL_3130": "LOOK at the state she's in![pause=20] Heal her.[pause=0] NOW.",
 "TALK_FULL_3131": "You left her on the front line.[pause=20] Never do that again.",
 "TALK_FULL_3132": "A Berry.[pause=0] A Berry, right now![pause=20] Don't argue, [player]!",
 "TALK_FULL_3133": "If she goes down here,[pause=10] I will never forgive you.[pause=0] Ever.",
 "TALK_FULL_3134": "I don't care about the summit![pause=20] Get her out,[pause=10] that's all that matters!",
 "TALK_HALF_3130": "Don't worry about me![pause=20] SHE's the one who needs help!",
 "TALK_HALF_3131": "My wounds can wait.[pause=0] Hers can't.",
 "TALK_HALF_3132": "Move![pause=20] Every second counts,[pause=10] can't you see that?!",
 "TALK_PINCH_3130": "We're... both down...[pause=20] Get her out of here.[pause=0] Her first.",
 "TALK_PINCH_3131": "Leave me...[pause=20] Take Shuca and go.[pause=0] That's an order.",
 "TALK_PINCH_3132": "I... failed...[pause=20] Don't let her fall too...",

 "TALK_FULL_3140": "Shuca.[pause=20] Stay behind me.[pause=0] I won't ask twice.",
 "TALK_FULL_3141": "Are you holding up?[pause=20] ...No.[pause=0] Don't lie.[pause=10] I can see it.",
 "TALK_FULL_3142": "Breathe.[pause=20] I'm here.[pause=0] Nothing reaches you while I'm standing.",
 "TALK_FULL_3143": "We're going back.[pause=20] The summit will wait.[pause=0] You won't.",
 "TALK_FULL_3144": "Don't apologize.[pause=20] You made it this far.[pause=0] That's already huge.",
 "TALK_HALF_3140": "So I'm bleeding a little.[pause=0] You can barely stand.",
 "TALK_HALF_3141": "Don't think about me.[pause=20] Think about breathing.[pause=0] Just that.",
 "TALK_HALF_3142": "We're both banged up.[pause=20] At least there's two of us.",
 "TALK_PINCH_3140": "Shuca...[pause=20] if one of us walks out,[pause=10] it's you.",
 "TALK_PINCH_3141": "Stay awake.[pause=20] Talk to me.[pause=0] Anything,[pause=10] just talk.",
 "TALK_PINCH_3142": "I should have...[pause=20] been in front of you.[pause=0] From the start.",

 "TALK_FULL_3150": "This is my first real expedition![pause=0] I'm trying to remember everything.",
 "TALK_FULL_3151": "Think we'll tell the guild about this?[pause=20] I've already prepared my story!",
 "TALK_FULL_3152": "I packed supplies for everyone.[pause=0] Just ask,[pause=10] really!",
 "TALK_FULL_3153": "A [kind]![pause=20] I'd only ever seen one in a drawing...",
 "TALK_FULL_3154": "My legs are shaking a bit.[pause=20] But it's excitement![pause=0] Promise!",
 "TALK_HALF_3150": "Ow...[pause=0] Okay.[pause=20] That stings, but I'm going on!",
 "TALK_HALF_3151": "I took a bad hit...[pause=0] Don't tell Ganlon,[pause=10] okay?",
 "TALK_HALF_3152": "I'm holding on![pause=20] I don't want to be the one slowing everyone down.",
 "TALK_PINCH_3150": "I-I can't see straight...[pause=20] I could really use a Berry...",
 "TALK_PINCH_3151": "I wanted to reach the summit...[pause=20] with all of you...",
 "TALK_PINCH_3152": "Mom was right...[pause=20] maybe it was too soon for me...",

 "TALK_FULL_3160": "Ganlon![pause=0] Did you see my aim that time?[pause=20] Huh?[pause=0] Did you see?",
 "TALK_FULL_3161": "You act all grumpy,[pause=10] but you covered me again just now.",
 "TALK_FULL_3162": "Thanks for being here.[pause=20] There.[pause=0] Said it now,[pause=10] so it's done!",
 "TALK_FULL_3163": "You grumble constantly,[pause=10] but you never leave my side.",
 "TALK_FULL_3164": "One day I'll be as tough as you.[pause=20] You'll see!",
 "TALK_HALF_3160": "Don't make that face, Ganlon![pause=0] It's just a scrape!",
 "TALK_HALF_3161": "I know, I know...[pause=0] \"stay behind\".[pause=20] Going back, promise.",
 "TALK_HALF_3162": "You're worried?[pause=20] You?[pause=0] ...That actually makes me happy.",
 "TALK_PINCH_3160": "Ganlon...[pause=20] I think I need help...",
 "TALK_PINCH_3161": "Don't be angry...[pause=20] I really did my best...",
 "TALK_PINCH_3162": "Stay close to me...[pause=20] please...",
}


def patch(path, table):
    """Remplace la valeur des cles ciblees, en preservant tout le reste
    du fichier (indentation, commentaires, ordre) : edition textuelle
    ciblee plutot qu'une reserialisation ET complete."""
    src = open(path, encoding='utf-8-sig').read()
    done, missing = 0, []
    for key, val in table.items():
        # Capture le bloc <data name="KEY" ...> ... <value>CONTENU</value>
        pat = re.compile(
            r'(<data name="' + re.escape(key) + r'"[^>]*>\s*<value>)(.*?)(</value>)',
            re.DOTALL)
        new, n = pat.subn(
            lambda m: m.group(1) + esc(val) + m.group(3), src, count=1)
        if n == 0:
            missing.append(key)
        else:
            src, done = new, done + 1
    return src, done, missing


def esc(s):
    return (s.replace('&', '&amp;')
             .replace('<', '&lt;')
             .replace('>', '&gt;'))


def main():
    root = sys.argv[1] if len(sys.argv) > 1 else '.'
    total = 0
    for path, table in ((root + '/Strings/stringsEx.fr.resx', FR),
                        (root + '/Strings/stringsEx.resx', EN)):
        src, done, missing = patch(path, table)
        if missing:
            print('  MANQUANTES dans %s : %s' % (path, missing[:5]))
        # Verification : le XML doit rester valide APRES ecriture.
        ET.fromstring(src)
        open(path, 'w', encoding='utf-8').write(src)
        print('%-34s %d cle(s) remplie(s)' % (path.split('/')[-1], done))
        total += done
    print('TOTAL %d remplacements' % total)


if __name__ == '__main__':
    main()
