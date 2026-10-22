#!/usr/bin/env python3
"""Cinématiques de boss Livre II — 42 scènes « Éveil des Ancrages ».

Structure = templates des dépôts d'origine (grounds 1:1 pmd-red / Explorers /
Friend Areas, grammaire 3 couches des cinématiques Rescue Team : signal → 
irruption → recul → flash → reveal → titre → ligne courte, narration
contemplative à la Explorers of Sky). SEULS LES DIALOGUES changent, écrits
pour notre scénario (gardiens d'Ancrage, Livre II).

Pour chaque scène : marqueurs garantis sur le ground, init.lua complet
(FX BossFX + caméra + titre + dialogue + rematch court), zone câblée
(segment N-1 → ground → ContinueDungeon segment arène), contrat Grodoudou
détourné vers le ground (champ cine), fiche anti-répétition mise à jour.
"""
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---
import json, io, os, re, sys
from collections import deque

def load(p): return json.load(open(p, encoding='utf-8-sig'))
def save(p, d):
    with io.open(p, 'w', encoding='utf-8-sig') as f:
        json.dump(d, f, ensure_ascii=False, indent=1)

# ---------------------------------------------------------------------------
# SCÈNES — (zone, seg_arène, ground ciné, clé LZ, boss[(Clé,species,nick,genre)],
#           fx, titre FR, voix du gardien, (émotion, ligne partenaire), ligne boss,
#           musique de scène)
# g = Gender.Genderless (2 int? use string tokens)
# ---------------------------------------------------------------------------
S = []
def sc(z, seg, g, key, chars, fx, title, voice, pline, bline, music='Boss Battle!.ogg', rematch=None):
    S.append(dict(z=z, seg=seg, g=g, key=key, chars=chars, fx=fx, title=title,
                  voice=voice, pline=pline, bline=bline, music=music,
                  rematch=rematch or bline))

GL = 'Gender.Genderless'; M = 'Gender.Male'; F = 'Gender.Female'

sc('caldeira_endormie', 1, 'arene_trone_magma', 'molten_throne',
   [('Groudon','groudon','Groudon',GL)], 'ground',
   'Groudon, le Trône de Magma',
   "CELUI QUI MARCHE SUR MA TERRE...[pause=20] PORTE-T-IL LE POIDS DU MONDE, OU SEULEMENT LE SIEN ?",
   ('Worried', "Le sol...[pause=10] le sol RESPIRE, [hero] ![pause=20] Tout l'Ancrage s'est réveillé d'un coup !"),
   "La terre ne ment jamais.[pause=20] Montre-moi ce que pèsent tes pas.")

sc('eaux_inexplorees', 32, 'abime_tempetes', 'tide_hollow',
   [('Kyogre','kyogre','Kyogre',GL)], 'water',
   'Kyogre, le Creux des Marées',
   "LA PLUIE TOMBE DEPUIS AVANT LES NOMS.[pause=20] QUI OSE NAGER JUSQU'À SA SOURCE ?",
   ('Worried', "Les vagues tournent en cercle...[pause=20] On est au centre exact de la tempête !"),
   "Chaque marée est une question.[pause=20] Réponds, ou coule.")

sc('sentier_savoir', 1, 'lac_savoir', 'quiet_ledger',
   [('Crehelf','uxie','Créhelf',GL)], 'mist',
   'Créhelf, la Mémoire du Lac',
   "J'AI VU TOUT CE QUI FUT.[pause=30] VEUX-TU VRAIMENT QUE JE TE REGARDE ?",
   ('Worried', "La brume...[pause=10] elle se souvient de nous, [hero].[pause=20] Comme si on était déjà venus."),
   "Je n'ouvre les yeux qu'une fois.[pause=20] Fais que cela en vaille la peine.")

sc('sentier_espoir', 1, 'lac_espoir', 'kept_feeling',
   [('Crefollet','mesprit','Créfollet',GL)], 'water',
   'Créfollet, le Sentiment Gardé',
   "TON CŒUR BAT TROP FORT POUR UN SIMPLE VOYAGEUR.[pause=20] QUE PROTÈGES-TU ?",
   ('Normal', "Le lac reflète nos visages...[pause=20] mais pas nos expressions.[pause=10] Regarde, il nous montre... de l'espoir ?"),
   "L'émotion est la première lumière.[pause=20] Prouve que la tienne ne vacille pas.")

sc('sentier_courage', 1, 'lac_courage', 'last_resolve',
   [('Crefadet','azelf','Créfadet',GL)], 'flash',
   'Créfadet, la Dernière Résolution',
   "LA VOLONTÉ N'ATTEND PAS.[pause=10] MOI NON PLUS.",
   ('Determined', "Il était déjà là ![pause=20] Depuis le début — il attendait de voir si on OSERAIT !"),
   "Bien.[pause=10] Tu n'as pas reculé.[pause=20] Voyons si c'est du courage ou de l'orgueil.")

sc('ile_lave_flottante', 5, 'champ_braises', 'long_ash',
   [('Sulfura','moltres','Sulfura',GL)], 'fire',
   'Sulfura, la Longue Cendre',
   "LES CENDRES MONTENT.[pause=20] C'EST QUE LE FEU, EN BAS, S'EST SOUVENU DE VOUS.",
   ('Worried', "Ces flammes ne brûlent pas la pierre...[pause=20] elles l'ÉCLAIRENT. C'est un gardien, [hero] !"),
   "Mon feu ne détruit que ce qui doit tomber.[pause=20] Tenez debout, et il vous éclairera.")

sc('crete_voilee', 5, 'arene_hautes_plaines', 'storm_bell',
   [('Raikou','raikou','Raikou',GL)], 'flash',
   'Raikou, la Cloche des Orages',
   "LE TONNERRE ARRIVE TOUJOURS APRÈS MOI.[pause=20] VOUS ÊTES DÉJÀ EN RETARD.",
   ('Worried', "Le tonnerre a claqué APRÈS l'éclair...[pause=20] non — APRÈS LUI !"),
   "Courez si vous voulez.[pause=10] L'orage, c'est moi.")

sc('montagne_traitresse', 4, 'champ_vent_boreal', 'thawed_step',
   [('Artikodin','articuno','Artikodin',GL)], 'sky_dark',
   'Artikodin, le Pas Dégelé',
   "...",  # le gardien du silence n'a pas de voix — c'est sa signature
   ('Worried', "Plus un bruit...[pause=30] même le vent s'est tu.[pause=20] Il neige VERS LE HAUT, [hero]..."),
   "Vous avez marché longtemps dans mon silence.[pause=20] Voyons si vous savez aussi y combattre.")

sc('mont_grondant', 5, 'porte_plaines_foudre', 'high_conductor',
   [('Electhor','zapdos','Électhor',GL)], 'flash',
   'Électhor, le Grand Conducteur',
   "CHAQUE ÉCLAIR DE CE MONDE PASSE PAR MOI.[pause=20] MÊME CELUI QUI VOUS TUERA.",
   ('Worried', "Mes poils se dressent...[pause=10] l'air entier est CHARGÉ ![pause=20] Il ne descend pas — il EST la foudre !"),
   "L'Antenne chante quand je passe.[pause=20] Écoutez-la une dernière fois.")

sc('tour_sacree', 1, 'sommet_aurore', 'rainbow_ash',
   [('HoOh','ho_oh','Ho-Oh',GL)], 'sky',
   "Ho-Oh, le Bûcher de l'Aurore",
   "CEUX QUI GRIMPENT POUR ÊTRE VUS TOMBENT.[pause=20] CEUX QUI GRIMPENT POUR VOIR, PARFOIS, S'ENVOLENT.",
   ('Happy', "Un arc-en-ciel...[pause=10] en pleine nuit ![pause=20] [hero], regarde — le ciel BRÛLE de couleurs !"),
   "J'ai promis de revenir quand les cœurs seraient purs.[pause=20] Montrez-moi que j'ai bien choisi ma date.")

sc('fosse_abysses', 1, 'fosse_argentee', 'sunken_choir',
   [('Lugia','lugia','Lugia',GL)], 'water',
   'Lugia, le Chœur Englouti',
   "IL Y A UN SECOND CIEL SOUS LA MER.[pause=20] JE SUIS SON SEUL OISEAU.",
   ('Worried', "C'est... le même chant qu'au Pic Céleste ![pause=20] Mais... plus profond. Plus ancien. Plus TRISTE."),
   "Tu m'as déjà rencontré là-haut.[pause=20] Ici, en bas, je ne juge pas :[pause=10] je pèse.",
   rematch="Le fond de la mer n'oublie pas.[pause=20] Encore une fois, donc.")

sc('bois_antan', 3, 'bois_antan_verger', 'dead_hours',
   [('Celebi','celebi','Celebi',GL)], 'mist',
   "Celebi, les Heures Mortes",
   "CE VERGER A CONNU MILLE PRINTEMPS.[pause=20] JE LES GARDE TOUS.[pause=10] MÊME CEUX QUI N'ONT PAS EU LIEU.",
   ('Worried', "Les pommes...[pause=10] elles mûrissent et pourrissent en boucle ![pause=20] Le temps tourne en rond ici !"),
   "Tu portes une mémoire qui n'est pas la tienne.[pause=20] Voyons si tu mérites de la garder.")

sc('forteresse_abandonnee', 1, 'antre_occident', 'western_silence',
   [('Mewtwo','mewtwo','Mewtwo',GL)], 'silence',
   'Mewtwo, le Silence Occidental',
   "ILS M'ONT FAIT.[pause=30] PUIS ILS ONT EU PEUR.[pause=30] PUIS ILS SONT PARTIS.[pause=30] PAS MOI.",
   ('Worried', "Cet Ancrage est... artificiel ?[pause=20] Quelqu'un a CONSTRUIT une faille... et l'a abandonnée ?!"),
   "Je ne garde pas ce lieu.[pause=20] C'est ce lieu qui me garde.[pause=20] Viens.[pause=10] Aide-moi à vérifier lequel de nous deux a raison.")

sc('crete_faille', 3, 'plaines_brulees', 'ember_vigil',
   [('Entei','entei','Entei',GL),('Victini','victini','Victini',GL)], 'fire',
   'Entei et Victini, la Veillée des Braises',
   "DEUX FEUX VEILLENT ICI.[pause=20] LE GRAND QUI GRONDE.[pause=10] ET LE PETIT QUI NE PERD JAMAIS.",
   ('Worried', "Un volcan qui marche...[pause=20] et une étincelle qui DANSE autour de lui ?!"),
   "Il dit que vous allez perdre.[pause=10] Moi je dis que non ![pause=20] Départagez-nous !")

sc('cour_clair_lune', 5, 'mont_lune_vue', 'soft_sleep',
   [('Cresselia','cresselia','Cresselia',F),('Darkrai','darkrai','Darkrai',GL)], 'moon_duel',
   'Cresselia et Darkrai, les Deux Visages de la Lune',
   "TOUTE LUMIÈRE A SON OMBRE.[pause=20] CE SOIR, LA LUNE MONTRE SES DEUX VISAGES.",
   ('Worried', "Deux présences ![pause=20] Une qui apaise...[pause=10] une qui GLACE.[pause=20] Et elles ne se battent PAS entre elles ?!"),
   "Il est mon ombre. Je suis son excuse.[pause=20] L'Ancrage nous a liés :[pause=10] affrontez-nous ENSEMBLE, ou pas du tout.")

sc('ile_eon', 1, 'cretes_boreales', 'twin_rift',
   [('Latios','latios','Latios',M),('Latias','latias','Latias',F)], 'sky',
   'Latios et Latias, la Faille Jumelle',
   "DEUX SILLAGES, UN SEUL CIEL.[pause=20] NE LES SÉPAREZ JAMAIS.",
   ('Happy', "Là ![pause=10] Deux traînées de lumière — elles se CROISENT sans jamais se toucher !"),
   "Mon frère fonce, je corrige.[pause=10] Il frappe, je protège.[pause=20] Voyons si votre duo vaut le nôtre !")

sc('antre_chuchotant', 1, 'bois_des_plaintes', 'clearwater_ford',
   [('Suicune','suicune','Suicune',GL)], 'mist',
   'Suicune, le Gué des Eaux Claires',
   "L'EAU QUE VOUS AVEZ BUE AUJOURD'HUI M'A TRAVERSÉ HIER.[pause=20] NOUS SOMMES DÉJÀ LIÉS.",
   ('Normal', "L'eau du gué est devenue... parfaitement claire.[pause=20] On voit chaque pierre du fond. C'est LUI qui fait ça ?"),
   "Je purifie ce que je touche.[pause=20] Voyons ce qu'il restera de vous.")

sc('bois_enchevetres', 5, 'arene_clairiere_secrete', 'first_cradle',
   [('Mew','mew','Mew',GL),('Hoopa','hoopa','Hoopa',GL)], 'playful',
   'Mew et Hoopa, le Premier Berceau',
   "HIHI.[pause=20] ILS SONT VENUS JUSQU'ICI.[pause=10] ON JOUE ?",
   ('Normal', "Un anneau doré vient de... d'AVALER mon sac ?![pause=20] Et cette petite chose rose RIGOLE !"),
   "Alohomora ![pause=10] Tout ce qui entre dans mes anneaux est à moi ![pause=20] Toi aussi, si tu perds !")

sc('creux_ombres', 1, 'creux_ombres_scelle', 'only_shadow',
   [('Marshadow','marshadow','Marshadow',GL)], 'shadow',
   "Marshadow, la Seule Ombre",
   "VOUS M'AVEZ MARCHÉ DESSUS DEPUIS LE PREMIER ÉTAGE.[pause=30] JE SUIS TOUTES LES OMBRES ICI.",
   ('Worried', "[hero]...[pause=20] ton ombre.[pause=10] ELLE S'EST LEVÉE TOUTE SEULE."),
   "...")

sc('hauteurs_etoile', 1, 'vigie_stratos', 'ninth_summit',
   [('Rayquaza','rayquaza','Rayquaza',GL)], 'sky',
   'Rayquaza, le Neuvième Sommet',
   "HUIT SOMMETS PORTENT LE CIEL.[pause=20] LE NEUVIÈME, C'EST MOI.",
   ('Worried', "L'Arbitre du Ciel...[pause=20] La légende de Reinier disait vrai :[pause=10] il ne bouge que si on franchit SON ciel.[pause=20] Et on vient de le faire."),
   "Vous avez franchi la ligne verte du monde.[pause=20] Nul ne redescend sans mon accord.")

sc('tour_reliques', 3, 'fleche_reliques_courroux', 'hour_that_lags',
   [('Dialga','dialga','Dialga',GL)], 'temporal',
   "Dialga, l'Heure qui Traîne",
   "CHAQUE SECONDE QUE VOUS AVEZ VÉCUE M'APPARTIENT.[pause=20] VOUS VENEZ ME RENDRE LES VÔTRES ?",
   ('Worried', "Le ciel est devenu ROUGE d'un coup ![pause=20] Et nos pas...[pause=10] l'écho arrive AVANT le pas, [hero] !"),
   "Le temps saigne ici depuis trop longtemps.[pause=20] Soignez-le, ou devenez une seconde de plus dans ma collection.",
   music="Dialga's Fight To the Finish!.ogg")

sc('grotte_gravee', 1, 'chambre_agee_o', 'spatial_hill',
   [('Palkia','palkia','Palkia',GL)], 'spatial',
   "Palkia, la Colline Spatiale",
   "LA DISTANCE EST UN MENSONGE QUE JE RACONTE AU MONDE.[pause=20] APPROCHEZ.[pause=10] OU L'AI-JE DÉJÀ FAIT POUR VOUS ?",
   ('Worried', "La salle est plus GRANDE à l'intérieur ![pause=20] On a marché dix pas et reculé de cent !"),
   "L'espace plie où je veux.[pause=20] Voyons où VOUS pliez.")

sc('labyrinthe_perdus', 1, 'grotte_cryptique', 'reverse_slope',
   [('Giratina','giratina','Giratina',GL)], 'reverse',
   'Giratina, le Versant Inversé',
   "ILS M'ONT JETÉ DE L'AUTRE CÔTÉ DU MIROIR.[pause=30] J'AI FAIT DU MIROIR MON ROYAUME.",
   ('Worried', "Il vient de traverser le MUR ![pause=20] Pas une brèche, pas une porte — le mur PLEIN !"),
   "Perdus ?[pause=10] Non.[pause=20] Vous êtes exactement là où le monde vous a rangés :[pause=10] à l'envers.")

sc('vallon_malsain', 3, 'vallon_malsain_fond', 'final_rest',
   [('Yveltal','yveltal','Yveltal',GL)], 'sky_dark',
   'Yveltal, le Cocon de la Ruine',
   "TOUT CE QUI VIT M'EST PROMIS.[pause=30] JE NE PRENDS JAMAIS D'AVANCE.[pause=20] SAUF SI ON ME DÉRANGE.",
   ('Worried', "Les arbres gris...[pause=10] ils ne pourrissent pas, ils sont VIDÉS.[pause=20] Et ce cocon géant vient de s'ouvrir..."),
   "Je dors pour que le monde vive.[pause=20] Vous m'avez réveillé.[pause=10] Assumez.")

sc('ciel_suspendu', 1, 'terres_tues_porte', 'cells_gathering',
   [('Zygarde','zygarde','Zygarde',GL)], 'assemble',
   "Zygarde, l'Assemblée des Cellules",
   "L'ORDRE N'EST PAS UNE LOI.[pause=20] C'EST UNE SOMME.[pause=10] ET JE SUIS EN TRAIN DE M'ADDITIONNER.",
   ('Worried', "Ces points verts, partout...[pause=10] ils COULENT les uns vers les autres ![pause=20] Ça prend forme, [hero] !"),
   "Cent pour cent atteint.[pause=20] L'audit de vos intentions peut commencer.")

sc('iles_prismatiques', 1, 'nef_prisme_est', 'given_life',
   [('Xerneas','xerneas','Xerneas',GL)], 'crystal',
   'Xerneas, la Vie Donnée',
   "J'AI DONNÉ LA VIE SI SOUVENT QUE J'AI OUBLIÉ D'EN GARDER POUR MOI.[pause=20] CETTE NEF EST MON DERNIER JARDIN.",
   ('Happy', "Les bois de la nef...[pause=10] ils FLEURISSENT sur son passage ![pause=20] Chaque pas fait pousser quelque chose !"),
   "La vie que je donne, je peux la reprendre.[pause=20] Montrez-moi que la vôtre est bien employée.")

sc('conte_sans_fin', 1, 'ile_legendaire', 'two_lights',
   [('Solgaleo','solgaleo','Solgaleo',GL)], 'solar',
   'Solgaleo, la Première Lumière',
   "LE CONTE DIT :[pause=10] LE SOLEIL MARCHE, FAUVE À LA CRINIÈRE D'ACIER.[pause=20] LE CONTE NE MENT PAS.",
   ('Happy', "L'aube...[pause=10] en PLEIN midi ?![pause=20] Sa crinière — c'est elle qui éclaire l'île entière !"),
   "Chaque histoire a besoin d'un soleil.[pause=20] Prouvez que la vôtre mérite le sien.")

sc('chapelle_nuit', 5, 'ile_australe', 'two_lights_lunala',
   [('Lunala','lunala','Lunala',F)], 'lunar',
   "Lunala, l'Autre Lumière",
   "ET LA LUNE VOLE, DIT LE CONTE,[pause=10] SUR DES AILES DE NUIT COUSUES D'ÉTOILES.[pause=30] LA VOICI.",
   ('Worried', "Il fait nuit d'un coup...[pause=10] mais quelle nuit ![pause=20] Chaque étoile est à sa place — comme un ciel RANGÉ exprès."),
   "Mon frère vous a jugés au soleil.[pause=20] Moi, je regarde ce que vous êtes dans le noir.")

sc('dedale_voeu', 1, 'sanctuaire_voeu', 'unsaid_wishes',
   [('Jirachi','jirachi','Jirachi',GL)], 'star',
   'Jirachi, les Vœux Tus',
   "MILLE ANS DE VŒUX MURMURES DORMENT ICI.[pause=30] LE VÔTRE EST DÉJÀ ÉCRIT.[pause=20] VOULEZ-VOUS LE LIRE ?",
   ('Normal', "L'étoile...[pause=10] elle s'ouvre ![pause=20] [hero], il ÉTAIT là depuis mille ans — il nous ATTENDAIT ?"),
   "Il y a vingt-cinq ans, quelqu'un est tombé du ciel et a fait un vœu pour vous tous.[pause=30] Venez.[pause=10] Je vous montrerai lequel.",
   rematch="Le vœu tient toujours.[pause=20] Et vous ?")

sc('sentier_eteint', 4, 'ile_close', 'borrowed_light',
   [('Necrozma','necrozma','Necrozma',GL)], 'eclipse',
   'Necrozma, la Lumière Empruntée',
   "ON M'A TRAITÉ DE VOLEUR.[pause=30] MAIS QUAND ON EMPRUNTE POUR SCELLER UN MONSTRE...[pause=20] QUI EST LE VOLEUR ? MOI, OU CELUI QUI REPREND ?",
   ('Determined', "C'est lui...[pause=20] celui des visions du Pic Céleste.[pause=10] Celui qui LUTTAIT.[pause=20] [hero]... et si on s'était trompés depuis le début ?"),
   "Chaque lumière que j'ai prise dort dans mes prismes,[pause=10] loin de LUI.[pause=30] Battez-moi si vous voulez.[pause=10] Mais quand les prismes tomberont...[pause=20] courez.")

sc('nervure_monde', 1, 'couloir_legendes', 'eternal_coil',
   [('Eternatus','eternatus','Eternatus',GL)], 'cataclysm',
   "Eternatus, la Spirale Éternelle",
   "...ENFIN.[pause=40] LE SCEAU N'EST PLUS QU'UN FIL.[pause=30] ET VOUS M'APPORTEZ VOS LUMIÈRES VOUS-MÊMES.",
   ('Worried', "Le couloir entier PULSE en pourpre...[pause=20] [hero], c'est ÇA que les Cœurs retenaient.[pause=10] Depuis toujours."),
   "Les gardiens m'ont compté en siècles.[pause=20] Je vous compterai en secondes.")

sc('tour_origine', 1, 'escalier_origine', 'first_breath',
   [('Arceus','arceus','Arceus',GL)], 'origin',
   'Arceus, le Premier Souffle',
   "AVANT LE PREMIER ANCRAGE, AVANT LE PREMIER GARDIEN,[pause=20] IL Y EUT UN SOUFFLE.[pause=30] VOUS L'AVEZ SUIVI JUSQU'ICI.",
   ('Normal', "Chaque marche qu'on a montée...[pause=20] je crois qu'elle n'existait pas avant qu'on la monte, [hero]."),
   "Vous avez stabilisé ce que mes enfants gardaient.[pause=30] Une dernière question, alors :[pause=20] à qui confierai-je le monde, désormais ?")

sc('jardin_gratitude', 1, 'champ_sacre', 'thanks_bloom',
   [('Shaymin','shaymin','Shaymin',GL)], 'bloom',
   'Shaymin, Là où Fleurit le Merci',
   "CE CHAMP POUSSE SUR TOUS LES MERCIS DU MONDE.[pause=20] LE VÔTRE EST EN RETARD.",
   ('Happy', "Des fleurs s'ouvrent PARTOUT où on marche ![pause=20] C'est... c'est le plus joli Ancrage qu'on ait vu !"),
   "La gratitude, ça s'arrose.[pause=20] Voyons si la vôtre a des racines !")

sc('berceau_mers', 1, 'recif_genereux', 'sea_cradle',
   [('Manaphy','manaphy','Manaphy',GL),('Phione','phione','Phione',GL)], 'water',
   'Manaphy, le Berceau des Mers',
   "LA MER BERCE SON PREMIER-NÉ.[pause=20] GARE À QUI RÉVEILLE LA BERCEUSE.",
   ('Normal', "Un chant...[pause=10] sous l'eau ?[pause=20] Le récif entier fredonne avec eux !"),
   "Le petit et moi, on protège le berceau.[pause=20] Prouvez que vous ne venez pas le briser !")

sc('gue_poulain', 1, 'gue_poulain_autel', 'resolute_ford',
   [('Keldeo','keldeo','Keldeo',M)], 'water',
   'Keldeo, le Gué de la Résolution',
   "UN POULAIN S'ENTRAÎNE ICI POUR MÉRITER SA PROPRE CORNE.[pause=20] RESPECTEZ CELA.",
   ('Determined', "L'eau tient tête au courant...[pause=20] et lui, il tient tête à l'OCÉAN entier !"),
   "Mes maîtres m'ont appris à ne jamais fuir ![pause=20] Montrez-moi vos résolutions — je vous montrerai ma corne !")

sc('amphitheatre_oublie', 1, 'grotte_echos', 'last_encore',
   [('Meloetta','meloetta','Meloetta',F)], 'song',
   'Meloetta, le Dernier Rappel',
   "LE CHANT S'EST TU IL Y A DES SIÈCLES.[pause=30] LA SALLE ATTEND ENCORE D'APPLAUDIR.",
   ('Normal', "Cette mélodie...[pause=10] l'écho la TERMINE tout seul ![pause=20] Quelqu'un chante avec la grotte, [hero]."),
   "Vous êtes mon premier public depuis mille ans.[pause=30] Le prix du billet, c'est un duel.[pause=10] En mesure !")

sc('reacteur_enfoui', 1, 'labo_decrepit', 'old_reactor',
   [('Genesect','genesect','Genesect',GL)], 'machine',
   'Genesect, le Vieux Réacteur',
   "SYSTÈME... EN LIGNE.[pause=20] DERNIER ORDRE REÇU :[pause=10] GARDER.[pause=20] DURÉE ÉCOULÉE : INCONNUE.",
   ('Worried', "Ces machines ont des SIÈCLES...[pause=20] et il y en a une qui vient de rallumer ses yeux."),
   "Intrusion détectée.[pause=10] Protocole :[pause=10] évaluation par le combat.[pause=20] Commencer.")

sc('forge_vapeur', 1, 'fosse_volcanique', 'steam_heart',
   [('Volcanion','volcanion','Volcanion',GL)], 'steam',
   'Volcanion, le Cœur de Vapeur',
   "EAU ET FEU NE S'AIMENT PAS.[pause=20] JE SUIS LEUR RÉCONCILIATION.[pause=10] FORCÉE.",
   ('Worried', "Les geysers respirent comme des soufflets de forge ![pause=20] Toute la fosse est SA machine !"),
   "Ne bouchez jamais mes évents.[pause=20] Dernier avertissement gratuit.")

sc('atelier_coeur_mecanique', 3, 'carriere_magnetique', 'gear_heart',
   [('Magearna','magearna','Magearna',GL)], 'machine',
   "Magearna, le Cœur d'Engrenages",
   "QUELQU'UN M'A CONSTRUIT UN CŒUR.[pause=30] JE ME SUIS CONSTRUIT UNE ÂME.[pause=20] LAQUELLE VOULEZ-VOUS TESTER ?",
   ('Normal', "Chaque engrenage de la carrière tourne vers ELLE...[pause=20] comme des tournesols vers le soleil."),
   "Mon créateur dort depuis longtemps.[pause=20] Je protège son dernier atelier.[pause=10] En garde.")

sc('piste_fulgurante', 3, 'pre_tonnerre', 'wild_current',
   [('Zeraora','zeraora','Zeraora',GL)], 'flash',
   'Zeraora, le Courant Sauvage',
   "IL A DISTANCÉ L'ORAGE QUI L'A CRÉÉ.[pause=20] DEPUIS, IL CHERCHE UNE COURSE DIGNE.",
   ('Determined', "Cette trace d'herbe brûlée...[pause=10] UN SEUL trait, du pied de la piste jusqu'ici ![pause=20] Il nous a devancés en s'AMUSANT."),
   "Enfin des concurrents ![pause=20] Règle unique :[pause=10] le premier à terre a perdu !")

sc('fonderie_hex', 3, 'grotte_rocheuse', 'liquid_metal',
   [('Melmetal','melmetal','Melmetal',GL),('Meltan','meltan','Meltan',GL)], 'metal',
   'Melmetal, le Métal Liquide',
   "LE VIEUX MANGEUR D'ÉCROUS EST REVENU AVEC UN CORPS DE FER.[pause=20] IL SE SOUVIENT D'AVOIR ÉTÉ PETIT.",
   ('Worried', "Les flaques de métal FRISSONNENT...[pause=20] et la petite goutte là-bas nous fait... coucou ?"),
   "GLOONG.[pause=20] (Le colosse fait tinter son poing comme une cloche.[pause=10] C'est probablement une invitation.)")

sc('grotte_meteore', 1, 'vallon_perdu', 'fallen_visitor',
   [('Deoxys','deoxys','Deoxys',GL)], 'meteor',
   'Deoxys, le Visiteur Tombé',
   "IL EST TOMBÉ DE PLUS LOIN QUE LE CIEL.[pause=30] IL APPREND ENCORE NOS FORMES.",
   ('Worried', "Ce cratère au milieu du vallon...[pause=20] ce n'est pas une météorite qui l'a creusé.[pause=10] C'est LUI."),
   "FORME : ATTAQUE.[pause=20] Vous êtes ma leçon du jour.")

# ---------------------------------------------------------------------------
FXLIB = {
 'ground':   ["BossFX.Rumble({{hero, partner}}, 3)", "BossFX.EmergeGround({B}, {X}, {Y})", "BossFX.RockFall({X} - 40, {Y} - 24)", "BossFX.RockFall({X} + 44, {Y} - 16)"],
 'fire':     ["BossFX.EmergeFire({B}, {X}, {Y})"],
 'water':    ["BossFX.EmergeWater({B}, {X}, {Y})"],
 'sky':      ["BossFX.DescendSky({B}, {X}, {Y}, 160)"],
 'sky_dark': ["SOUND:StopBGM()", "GAME:WaitFrames(40)", "BossFX.DescendSky({B}, {X}, {Y}, 160)"],
 'mist':     ["BossFX.EmergeMist({B}, {X}, {Y})"],
 'shadow':   ["BossFX.EmergeShadow({B}, {X}, {Y})"],
 'crystal':  ["BossFX.AwakenCrystal({B}, {X}, {Y})"],
 'flash':    ["BossFX.Flash({X}, {Y}, 4, 6, 10)", "GROUND:Unhide('{K}')", "BossFX.Impact(3, true)"],
 'silence':  ["SOUND:StopBGM()", "GAME:WaitFrames(60)", "BossFX.Flash({X}, {Y}, 8, 10, 20)", "GROUND:Unhide('{K}')"],
 'temporal': ["BossFX.AwakenCrystal({B}, {X}, {Y})", "BossFX.ShakeScreen(4, 40)", "GAME:WaitFrames(10)", "BossFX.ShakeScreen(2, 20)"],
 'spatial':  ["BossFX.Flash({X}, {Y}, 4, 4, 8)", "BossFX.Flash({X} - 60, {Y} + 20, 4, 4, 8)", "BossFX.Flash({X} + 50, {Y} - 10, 4, 4, 8)", "GROUND:Unhide('{K}')"],
 'reverse':  ["BossFX.EmergeShadow({B}, {X}, {Y})", "BossFX.ShakeScreen(3, 30)"],
 'assemble': ["BossFX.EmergeGround({B}, {X}, {Y})", "BossFX.Impact(2, false)"],
 'solar':    ["BossFX.Flash({X}, {Y}, 10, 20, 30)", "GROUND:Unhide('{K}')", "BossFX.Impact(3, true)"],
 'lunar':    ["SOUND:StopBGM()", "BossFX.EmergeShadow({B}, {X}, {Y})"],
 'star':     ["BossFX.AwakenCrystal({B}, {X}, {Y})"],
 'eclipse':  ["SOUND:StopBGM()", "GAME:WaitFrames(30)", "BossFX.Flash({X}, {Y}, 2, 4, 40)", "GROUND:Unhide('{K}')", "BossFX.Impact(4, true)"],
 'cataclysm':["BossFX.Rumble({{hero, partner}}, 4)", "BossFX.EmergeGround({B}, {X}, {Y})", "BossFX.ShakeScreen(5, 60)"],
 'origin':   ["BossFX.Flash({X}, {Y}, 20, 30, 40)", "GROUND:Unhide('{K}')"],
 'bloom':    ["BossFX.EmergeMist({B}, {X}, {Y})"],
 'song':     ["SOUND:FadeOutBGM(40)", "GAME:WaitFrames(50)", "BossFX.EmergeMist({B}, {X}, {Y})"],
 'machine':  ["BossFX.Impact(2, false)", "GAME:WaitFrames(20)", "BossFX.Flash({X}, {Y}, 4, 6, 10)", "GROUND:Unhide('{K}')"],
 'steam':    ["BossFX.EmergeWater({B}, {X}, {Y})", "BossFX.EmergeFire({B}, {X}, {Y})"],
 'metal':    ["BossFX.Rumble({{hero, partner}}, 2)", "BossFX.EmergeGround({B}, {X}, {Y})", "BossFX.Impact(3, true)"],
 'meteor':   ["BossFX.RockFall({X}, {Y} - 30)", "BossFX.Flash({X}, {Y}, 4, 6, 10)", "GROUND:Unhide('{K}')", "BossFX.Impact(4, true)"],
 'playful':  ["BossFX.Flash({X} - 40, {Y}, 3, 3, 6)", "BossFX.Flash({X} + 40, {Y}, 3, 3, 6)", "GROUND:Unhide('{K}')"],
 'moon_duel':["BossFX.AwakenCrystal({B}, {X}, {Y})"],
}

GROUND_LUA = '''--[[ {title} — cinématique d'Ancrage (Livre II, ch{ch}).
     Ground template d'origine conservé 1:1 ; dialogues New Era.
     Grammaire Rescue Team : signal -> irruption -> recul -> flash -> reveal
     -> titre -> ligne courte. Rematch : intro raccourcie. ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.LegendZones'

local {fid} = {{}}

function {fid}.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function {fid}.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, {HX}, {HY}, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, {PX}, {PY}, Direction.Up) end
{mkchars}
  GAME:MoveCamera({CX}, {CY}, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('{key}') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
{unhide_rematch}
    UI:SetSpeaker({B0})
    UI:WaitShowDialogue("{rematch}")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("{zone}", {seg}, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
{voice_block}
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
{fx_block}
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({{hero, partner}}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
{reveal_block}
  -- 6. Titre + thème.
  SOUND:PlayBGM("{music}", true)
  UI:WaitShowTitle("{title}", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  UI:SetSpeakerEmotion("{pemo}")
  UI:WaitShowDialogue(STRINGS:Format("{pline}", hero:GetDisplayName()))
  UI:SetSpeaker({B0})
  UI:WaitShowDialogue("{bline}")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("{zone}", {seg}, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function {fid}.Update(map, time) end
function {fid}.GameSave(map) end
function {fid}.GameLoad(map) end

return {fid}
'''

def ensure_markers(gid):
    """Garantit Main_Entrance_Marker + Boss_Marker ; renvoie positions px."""
    p = f'Data/Ground/{gid}.rsground'
    d = load(p)
    o = d['Object']
    ents = o['Entities'][0]
    mk = {m['EntName']: m for m in ents['Markers']}
    ob = o['obstacles']
    W, H = len(ob), len(ob[0])
    cell = ob[0][0]['Bounds']['Width']
    walk = [(x, y) for x in range(W) for y in range(H) if ob[x][y]['Tags'] == 0]
    if not walk:
        walk = [(x, y) for x in range(W) for y in range(H)]
    cx = sum(q[0] for q in walk)//len(walk)
    cy = sum(q[1] for q in walk)//len(walk)
    changed = False
    if 'Boss_Marker' not in mk:
        best = min(walk, key=lambda q: abs(q[0]-cx) + abs(q[1]-(cy-3)))
        ents['Markers'].append({"EntName": "Boss_Marker", "Direction": 4,
            "EntEnabled": True, "EntOrder": 0, "InteractOrder": 0, "triggerType": 0,
            "Collider": {"X": best[0]*cell, "Y": best[1]*cell, "Width": 16, "Height": 16}})
        changed = True
    if 'Main_Entrance_Marker' not in mk:
        entry = max(walk, key=lambda q: (q[1], -abs(q[0]-cx)))
        ents['Markers'].append({"EntName": "Main_Entrance_Marker", "Direction": 0,
            "EntEnabled": True, "EntOrder": 0, "InteractOrder": 0, "triggerType": 0,
            "Collider": {"X": entry[0]*cell, "Y": entry[1]*cell, "Width": 16, "Height": 16}})
        changed = True
    if changed:
        save(p, d)
    mk = {m['EntName']: m for m in ents['Markers']}
    bx, by = mk['Boss_Marker']['Collider']['X'], mk['Boss_Marker']['Collider']['Y']
    hx, hy = mk['Main_Entrance_Marker']['Collider']['X'], mk['Main_Entrance_Marker']['Collider']['Y']
    return hx, hy, bx, by

if __name__ == '__main__':
    lz = json.load(open('/tmp/wave3_lz.json'))
    ch_by_zone = {e['zid']: e['ch'] for e in lz}
    # 1. CharacterEssentials : especes manquantes
    ce = open('Data/Script/halcyon/CharacterEssentials.lua', encoding='utf-8').read()
    have = set(re.findall(r'\n\t\t(\w+) = \{', ce))
    add = ''
    for s0 in S:
        for K, species, nick, gender in s0['chars']:
            if K in have:
                continue
            have.add(K)
            add += (f"\t\t{K} = {{\n\t\t\tspecies = \"{species}\",\n"
                    f"\t\t\tnickname = '{nick}',\n\t\t\tinstance = '{K}',\n"
                    f"\t\t\tgender = {gender},\n\t\t\tform = 0,\n"
                    f"\t\t\tskin = \"normal\"\n\t\t}},\n")
    if add:
        anchor = "\t\t--Chapitre 7 : Aegis Cave"
        ce = ce.replace(anchor, "\t\t--Livre II : gardiens d'Ancrage (cinematiques vague 7)\n" + add + anchor, 1)
        open('Data/Script/halcyon/CharacterEssentials.lua', 'w', encoding='utf-8').write(ce)
    print('CharacterEssentials: especes ajoutees')

    # 2. scenes
    for s0 in S:
        gid = s0['g']
        hx, hy, bx, by = ensure_markers(gid)
        px, py = max(0, hx-24), hy
        ch = ch_by_zone.get(s0['z'], '?')
        # blocs
        mk = []
        for i, (K, species, nick, gender) in enumerate(s0['chars']):
            ox = (i*40) - (20 * (len(s0['chars'])-1))
            mk.append(f"  local {K.lower()} = CharacterEssentials.MakeCharactersFromList({{{{'{K}', {bx+ox}, {by}, Direction.Down}}}})")
            mk.append(f"  GROUND:Hide('{K}')")
        mkchars = '\n'.join(mk)
        B0 = s0['chars'][0][0].lower()
        fx_lines = []
        for i, (K, species, nick, gender) in enumerate(s0['chars']):
            ox = (i*40) - (20 * (len(s0['chars'])-1))
            for tpl in FXLIB[s0['fx']]:
                fx_lines.append('  ' + tpl.format(B=K.lower(), X=bx+ox, Y=by, K=K))
            if i < len(s0['chars'])-1:
                fx_lines.append('  GAME:WaitFrames(25)')
        fx_block = '\n'.join(fx_lines)
        reveal = []
        for K, *_ in s0['chars']:
            reveal.append(f"  GROUND:Unhide('{K}')")
            reveal.append(f"  GROUND:CharSetAnim({K.lower()}, \"Attack\", false)")
        reveal.append('  GAME:WaitFrames(18)')
        for K, *_ in s0['chars']:
            reveal.append(f"  GROUND:CharSetAnim({K.lower()}, \"Idle\", true)")
        reveal_block = '\n'.join(reveal)
        unhide_rematch = '\n'.join(f"    GROUND:Unhide('{K}')" for K, *_ in s0['chars'])
        if s0['voice'] == '...':
            voice_block = ("  -- Signature d'Artikodin : PAS de voix. Le silence est le signal.\n"
                           "  GAME:WaitFrames(80)")
        else:
            voice_block = ('  UI:ResetSpeaker(false)\n  UI:SetCenter(true)\n'
                           f'  UI:WaitShowDialogue("{s0["voice"]}")\n'
                           '  UI:SetCenter(false)')
        lua = GROUND_LUA.format(
            title=s0['title'], ch=ch, fid=gid, HX=hx, HY=hy, PX=px, PY=py,
            mkchars=mkchars, CX=bx, CY=by-8, key=s0['key'],
            unhide_rematch=unhide_rematch, B0=B0, rematch=s0['rematch'],
            zone=s0['z'], seg=s0['seg'], voice_block=voice_block,
            fx_block=fx_block, reveal_block=reveal_block, music=s0['music'],
            pemo=s0['pline'][0], pline=s0['pline'][1].replace('[hero]', '{0}'),
            bline=s0['bline'])
        os.makedirs(f'Data/Script/halcyon/ground/{gid}', exist_ok=True)
        open(f'Data/Script/halcyon/ground/{gid}/init.lua', 'w', encoding='utf-8').write(lua)
        # 3. zone : segment N-1 -> ground
        zp = f'Data/Script/halcyon/zone/{s0["z"]}/init.lua'
        zs = open(zp, encoding='utf-8').read()
        hook = (f"  if segmentID == {s0['seg']-1} and result == RogueEssence.Data.GameProgress.ResultType.Cleared then\n"
                f"    -- Cinematique du gardien avant l'arene (vague 7).\n"
                f"    GAME:EnterGroundMap('{gid}', 'Main_Entrance_Marker')\n"
                f"    return\n  end\n")
        if f"EnterGroundMap('{gid}'" not in zs:
            anchor = f"  if segmentID == {s0['seg']} then"
            assert anchor in zs, s0['z']
            zs = zs.replace(anchor, hook + anchor, 1)
            open(zp, 'w', encoding='utf-8').write(zs)
        print(f"{s0['z']:26s} ch{ch} -> {gid} ({s0['fx']})")

    # 4. LegendZones : voyage Grodoudou -> ground de cinematique
    lzl = open('Data/Script/halcyon/LegendZones.lua', encoding='utf-8').read()
    for s0 in S:
        pat = f"zone = '{s0['z']}', segment = {s0['seg']}"
        if pat in lzl and f"cine = '{s0['g']}'" not in lzl:
            lzl = lzl.replace(pat, pat.replace(f"segment = {s0['seg']}",
                              f"segment = {s0['seg']}, cine = '{s0['g']}'"), 1)
    open('Data/Script/halcyon/LegendZones.lua', 'w', encoding='utf-8').write(lzl)
    # travel : EnterGroundMap si cine
    mtl = open('Data/Script/halcyon/ground/metano_town/metano_town_legend.lua', encoding='utf-8').read()
    old = ("    GAME:EnterDungeon(entry.zone, entry.segment, 0, 0,\n"
           "        RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)\n"
           "    return true")
    new = ("    if entry.cine ~= nil then\n"
           "        -- Vague 7 : la revanche passe par la cinematique du gardien.\n"
           "        GAME:EnterGroundMap(entry.cine, 'Main_Entrance_Marker')\n"
           "        return true\n"
           "    end\n" + old)
    if 'entry.cine' not in mtl:
        assert old in mtl
        mtl = mtl.replace(old, new, 1)
        open('Data/Script/halcyon/ground/metano_town/metano_town_legend.lua', 'w', encoding='utf-8').write(mtl)
    print('LegendZones + voyage Grodoudou cables (cine)')
    json.dump([(s0['z'], s0['g'], s0['key'], s0['fx'], s0['title']) for s0 in S],
              open('/tmp/wave7_scenes.json', 'w'))
    print(f'{len(S)} cinematiques generees')
