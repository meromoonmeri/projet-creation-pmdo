#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
inject_ch11_side_quests.py — Ajoute les quêtes secondaires et contrats de guilde
pour les 4 donjons secondaires du Chapitre 11 (Arc Fugitif).
"""
import os, sys

MOD_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SQ_PATH = os.path.join(MOD_ROOT, "Data/Script/halcyon/SideQuests.lua")
SJ_PATH = os.path.join(MOD_ROOT, "Data/Script/halcyon/SecondaryJobs.lua")

CH11_SQ_LUA = """  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE (24 LIGNES AVEC PARTENAIRE/HÉROS) : Ravin Pluvieux ===
  {
    id = 'q11_ravin', ch = 11, giver = 'Wooper_Boy', target = 'Wooper_Boy',
    unlock_dungeon = 'rainy_ravine', dungeon_name = "Ravin Pluvieux",
    titre = "L'inondation du ravin",
    ask = {
      {'Wooper_Boy', 'Sad',     'Ouin... Ouin... Le ravin pluvieux déborde de toutes parts.'},
      {'Teammate1', 'Surprised','Axoloto ? Pourquoi l eau monte-t-elle si vite dans votre vallée ?'},
      {'Wooper_Boy', 'Worried', 'Tarpaud la Tempête a invoqué un déluge continu depuis le sommet.'},
      {'Wooper_Boy', 'Normal',  'Le Ravin Pluvieux est une gorge escarpée où coulent nos rivières.'},
      {'Wooper_Boy', 'Angry',   'Mais ses remous furieux menacent d emporter nos nids !'},
      {'Wooper_Boy', 'Sad',     'Nous sommes trop petits pour remonter le torrent contre la pluie.'},
      {'Teammate1', 'Worried', 'Une inondation continue ? C est dangereux pour tous les fugitifs !'},
      {'PLAYER',    'Determined','(Je hoche la tête : nous devons calmer les eaux du ravin.)'},
      {'Wooper_Boy', 'Worried', 'Si Tarpaud ne cesse pas son chant, le ravin sera englouti.'},
      {'Wooper_Boy', 'Sad',     'Nous avons besoin d aventuriers courageux pour l atteindre.'},
      {'Teammate1', 'Determined','Compte sur nous ! Nous allons remonter le ravin et arrêter la tempête !'},
      {'Wooper_Boy', 'Inspired','Vrai ? Merci ! Sauvez notre vallée des eaux !'}
    },
    accept = {{'Wooper_Boy', 'Happy',   'Youpi ! Vous êtes nos héros !'},
      {'Teammate1', 'Happy', 'Fais attention à toi en attendant notre retour !'},
      {'Wooper_Boy', 'Normal',  'Le ravin s ouvre juste après les falaises brumeuses du nord.'}},
    refuse = {{'Wooper_Boy', 'Sad',     'Je comprends... Le torrent fait trop peur.'},
      {'Teammate1', 'Sad',   'Nous reviendrons dès que nous serons prêts.'}},
    pending= {{'Wooper_Boy', 'Worried', 'Le Ravin Pluvieux est-il toujours sous le déluge ?'},
      {'Teammate1', 'Determined','Nous gravissons les torrents pour calmer Tarpaud !'}},
    solve  = {{'Wooper_Boy', 'Worried', 'Le Ravin Pluvieux est-il toujours sous le déluge ?'},
      {'Teammate1', 'Determined','Nous gravissons les torrents pour calmer Tarpaud !'}},
    done   = {
      {'Wooper_Boy', 'Inspired','YOUPI ! LE SOLEIL REVIENT ! Le niveau de l eau a baissé !'},
      {'Teammate1', 'Happy', 'Tarpaud a promis de modérer ses chants de pluie dorénavant !'},
      {'PLAYER',    'Happy', '(Le calme est revenu dans le torrent du ravin.)'},
      {'Wooper_Boy', 'Happy',   'Nos nids sont sauvés grâce à vous deux !'},
      {'Wooper_Boy', 'Surprised','Vous avez vraiment vaincu les remous du grand Tarpaud ?'},
      {'Teammate1', 'Inspired','Aucun torrent ne peut résister à notre détermination !'},
      {'Wooper_Boy', 'Happy',   'Merci infiniment pour notre foyer !'},
      {'Wooper_Boy', 'Inspired','Prenez cette récompense de notre tribu de rivière !'},
      {'Wooper_Boy', 'Normal',  'Bon voyage dans le nord, amis explorateurs !'}
    },
    undertow = "mission personnelle de déblocage donjon avec partenaire et héros",
  },
  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE (24 LIGNES AVEC PARTENAIRE/HÉROS) : Gorge Moussue ===
  {
    id = 'q11_gorge', ch = 11, giver = 'Bellossom', target = 'Bellossom',
    unlock_dungeon = 'mossy_gorge', dungeon_name = "Gorge Moussue",
    titre = "La racine sacrée",
    ask = {
      {'Bellossom', 'Sad',     'Ah... Ah... Les fleurs de la gorge perdent tout leur éclat.'},
      {'Teammate1', 'Surprised','Joliflor ? Que se passe-t-il dans les profondeurs de la gorge ?'},
      {'Bellossom', 'Worried', 'Ludicolo le Déluge a accaparé la source d eau pure de notre racine sacrée.'},
      {'Bellossom', 'Normal',  'La Gorge Moussue est un sanctuaire d ombre où pousse notre flore.'},
      {'Bellossom', 'Angry',   'Sans cette eau, toute notre vallée végétale va se flétrir !'},
      {'Bellossom', 'Sad',     'Nos danses ne suffisent plus à réveiller la terre.'},
      {'Teammate1', 'Worried', 'La flore qui meurt ? Nous ne pouvons pas laisser faire cela !'},
      {'PLAYER',    'Determined','(Je regarde mon partenaire : allons rendre l eau aux plantes.)'},
      {'Bellossom', 'Worried', 'Il faut convaincre Ludicolo de partager le cours d eau de la gorge.'},
      {'Bellossom', 'Sad',     'Pouvez-vous descendre dans la gorge pour nous aider ?'},
      {'Teammate1', 'Determined','Bien sûr ! Nous allons libérer la source sacrée de la gorge !'},
      {'Bellossom', 'Inspired','Oh, quel soulagement ! Que la nature vous guide !'}
    },
    accept = {{'Bellossom', 'Happy',   'Merci ! Votre courage fait refleurir l espoir !'},
      {'Teammate1', 'Happy', 'Préparez vos chants pour fêter le retour de l eau !'},
      {'Bellossom', 'Normal',  'Le sentier de la gorge descend au cœur de la vallée brumeuse.'}},
    refuse = {{'Bellossom', 'Sad',     'Je vois... Les périls de la gorge sont nombreux.'},
      {'Teammate1', 'Sad',   'Nous reviendrons quand nous serons mieux équipés.'}},
    pending= {{'Bellossom', 'Worried', 'L eau claire coule-t-elle à nouveau dans la Gorge Moussue ?'},
      {'Teammate1', 'Determined','Nous approchons du sanctuaire de Ludicolo !'}},
    solve  = {{'Bellossom', 'Worried', 'L eau claire coule-t-elle à nouveau dans la Gorge Moussue ?'},
      {'Teammate1', 'Determined','Nous approchons du sanctuaire de Ludicolo !'}},
    done   = {
      {'Bellossom', 'Inspired','OH ! REGARDEZ ! Les fleurs reprennent leurs couleurs éclatantes !'},
      {'Teammate1', 'Happy', 'Ludicolo a accepté de libérer le ruisseau de la racine sacrée !'},
      {'PLAYER',    'Happy', '(La vallée entière résonne de la fraîcheur retrouvée.)'},
      {'Bellossom', 'Happy',   'C est un miracle végétal grâce à votre exploit !'},
      {'Bellossom', 'Surprised','Vous avez réussi là où tout notre clan avait échoué ?'},
      {'Teammate1', 'Inspired','Notre amitié franchit tous les obstacles !'},
      {'Bellossom', 'Happy',   'Notre jardin secret vous devra toujours reconnaissance !'},
      {'Bellossom', 'Inspired','Voici des trésors de notre récolte de la saison !'},
      {'Bellossom', 'Normal',  'Que vos routes soient toujours fleuries !'}
    },
    undertow = "mission personnelle de déblocage donjon avec partenaire et héros",
  },
  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE (24 LIGNES AVEC PARTENAIRE/HÉROS) : Piste Venteuse ===
  {
    id = 'q11_piste', ch = 11, giver = 'Manectric', target = 'Manectric',
    unlock_dungeon = 'windswept_trail', dungeon_name = "Piste Venteuse",
    titre = "La boussole des vents",
    ask = {
      {'Manectric', 'Sad',     'Grrr... Les vents du col sont devenus incontrôlables.'},
      {'Teammate1', 'Surprised','Élecsprint ? Pourquoi ces rafales bloquent-elles le passage nord ?'},
      {'Manectric', 'Worried', 'Aéromite le Bourrasque a déréglé les courants de la Piste Venteuse.'},
      {'Manectric', 'Normal',  'Ce sentier est la seule route praticable pour traverser les crêtes.'},
      {'Manectric', 'Angry',   'Ses vents violents repoussent tous les voyageurs qui tentent de passer !'},
      {'Manectric', 'Sad',     'Nos éclairs n arrivent pas à percer cette tempête de vent.'},
      {'Teammate1', 'Worried', 'Le passage nord bloqué ? C est crucial pour notre route !'},
      {'PLAYER',    'Determined','(Je sers les poings : nous devons traverser cette tempête.)'},
      {'Manectric', 'Worried', 'Si le vent ne se calme pas, la route restera coupée.'},
      {'Manectric', 'Sad',     'Nous cherchons des explorateurs capables de résister aux rafales.'},
      {'Teammate1', 'Determined','Laisse-nous faire ! Nous allons gravir la piste et calmer le vent !'},
      {'Manectric', 'Inspired','Vrai ? Votre courage honore la guilde !'}
    },
    accept = {{'Manectric', 'Happy',   'Excellent ! Que la force vous accompagne !'},
      {'Teammate1', 'Happy', 'Reste à l abri, le ciel va bientôt s éclaircir !'},
      {'Manectric', 'Normal',  'La piste commence au pied des grandes crêtes rocheuses du nord.'}},
    refuse = {{'Manectric', 'Sad',     'Je comprends... Ces vents peuvent renverser un rocher.'},
      {'Teammate1', 'Sad',   'Nous allons d abord consolider notre appui au sol.'}},
    pending= {{'Manectric', 'Worried', 'Les vents de la Piste Venteuse se sont-ils apaisés ?'},
      {'Teammate1', 'Determined','Nous montons vers le nid d Aéromite !'}},
    solve  = {{'Manectric', 'Worried', 'Les vents de la Piste Venteuse se sont-ils apaisés ?'},
      {'Teammate1', 'Determined','Nous montons vers le nid d Aéromite !'}},
    done   = {
      {'Manectric', 'Inspired','INCROYABLE ! La brise est devenue douce et régulière !'},
      {'Teammate1', 'Happy', 'Aéromite a compris que sa tempête mettait tout le monde en danger !'},
      {'PLAYER',    'Happy', '(La route des crêtes est enfin libre et dégagée.)'},
      {'Manectric', 'Happy',   'Vous avez rouvert le passage vers les terres du nord !'},
      {'Manectric', 'Surprised','Vous avez résisté aux plus puissantes rafales des sommets ?'},
      {'Teammate1', 'Inspired','Ensemble, rien ne peut nous faire reculer !'},
      {'Manectric', 'Happy',   'Les voyageurs du col chanteront votre exploit !'},
      {'Manectric', 'Inspired','Prenez cette récompense d exception de la patrouille !'},
      {'Manectric', 'Normal',  'Bonne route à travers les crêtes nordiques !'}
    },
    undertow = "mission personnelle de déblocage donjon avec partenaire et héros",
  },
  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE (24 LIGNES AVEC PARTENAIRE/HÉROS) : Creux Brumeux ===
  {
    id = 'q11_creux', ch = 11, giver = 'Gloom', target = 'Gloom',
    unlock_dungeon = 'foggy_hollow', dungeon_name = "Creux Brumeux",
    titre = "L'écho dans le brouillard",
    ask = {
      {'Gloom', 'Sad',     'Snif... Snif... Une brume étrange a capturé les échos de la forêt.'},
      {'Teammate1', 'Surprised','Ortide ? Pourquoi semblez-vous tous désorientés par le brouillard ?'},
      {'Gloom', 'Worried', 'Noctunoir le Guetteur a étendu un rideau d ombre sur le Creux Brumeux.'},
      {'Gloom', 'Normal',  'C est une cuvette boisée où nos chants résonnent d habitude.'},
      {'Gloom', 'Angry',   'Maintenant, quiconque y entre perd la notion du temps et du chemin !'},
      {'Gloom', 'Sad',     'Plus personne n ose s aventurer dans les sous-bois du nord.'},
      {'Teammate1', 'Worried', 'Un brouillard qui fait perdre le chemin ? C est un piège !'},
      {'PLAYER',    'Determined','(Je regarde vers la brume : notre complicité sera notre guide.)'},
      {'Gloom', 'Worried', 'Sans une lumière d amitié pure, le creux restera scellé.'},
      {'Gloom', 'Sad',     'Avez-vous le courage de dissiper le brouillard de Noctunoir ?'},
      {'Teammate1', 'Determined','Bien sûr ! Nous allons entrer dans le creux et ramener la clarté !'},
      {'Gloom', 'Inspired','Oh ! Merci, explorateurs au cœur vaillant !'}
    },
    accept = {{'Gloom', 'Happy',   'Snif ! Votre détermination éclaire déjà mon cœur !'},
      {'Teammate1', 'Happy', 'Ne t en fais plus, le soleil va percer le brouillard !'},
      {'Gloom', 'Normal',  'Le creux se trouve au fond du grand ravin forestier du nord.'}},
    refuse = {{'Gloom', 'Sad',     'Snif... Je comprends, ce brouillard est effrayant.'},
      {'Teammate1', 'Sad',   'Nous reviendrons dès que nous serons prêts à l affronter.'}},
    pending= {{'Gloom', 'Worried', 'Le brouillard s est-il levé sur le Creux Brumeux ?'},
      {'Teammate1', 'Determined','Nous progressons vers le cœur du brouillard !'}},
    solve  = {{'Gloom', 'Worried', 'Le brouillard s est-il levé sur le Creux Brumeux ?'},
      {'Teammate1', 'Determined','Nous progressons vers le cœur du brouillard !'}},
    done   = {
      {'Gloom', 'Inspired','OH ! LA CLARTÉ EST REVENUE ! Le brouillard s est dissipé !'},
      {'Teammate1', 'Happy', 'Noctunoir a accepté d apaiser sa surveillance sur la forêt !'},
      {'PLAYER',    'Happy', '(La lumière traverse à nouveau le feuillage du creux.)'},
      {'Gloom', 'Happy',   'Nos chants résonnent de nouveau dans tous les sous-bois !'},
      {'Gloom', 'Surprised','Vous avez traversé les illusions de Noctunoir sans vous perdre ?'},
      {'Teammate1', 'Inspired','Notre lien nous permet de toujours retrouver notre chemin !'},
      {'Gloom', 'Happy',   'La forêt entière vous est éternellement reconnaissante !'},
      {'Gloom', 'Inspired','Voici une prime précieuse pour vous remercier de tout cœur !'},
      {'Gloom', 'Normal',  'Que la clarté accompagne toujours vos explorations !'}
    },
    undertow = "mission personnelle de déblocage donjon avec partenaire et héros",
  },
"""

CH11_SJ_LUA = """  {
    chapter = 11, zone = 'rainy_ravine', segment = 0, floor = 10,
    client = 'wooper', client_gender = RogueEssence.Data.Gender.Male,
    target = 'wooper', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'A', reward = 'money',
    title = "Le déluge du ravin",
    flavor = "Des pluies torrentielles inondent le Ravin Pluvieux et menacent nos rivières.\nUne équipe de secours est demandée d'urgence.",
  },
  {
    chapter = 11, zone = 'mossy_gorge', segment = 0, floor = 12,
    client = 'bellossom', client_gender = RogueEssence.Data.Gender.Female,
    target = 'bellossom', target_gender = RogueEssence.Data.Gender.Female,
    difficulty = 'A', reward = 'money',
    title = "L'eau de la racine sacrée",
    flavor = "La source sacrée de la Gorge Moussue est accaparée par de redoutables Pokémon.\nAidez-nous à rendre l'eau aux plantes de la vallée.",
  },
  {
    chapter = 11, zone = 'windswept_trail', segment = 0, floor = 11,
    client = 'manectric', client_gender = RogueEssence.Data.Gender.Male,
    target = 'manectric', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'S', reward = 'money',
    title = "La tempête du nord",
    flavor = "Des vents violents bloquent le passage sur la Piste Venteuse vers les crêtes nordiques.\nSécurisez le sentier pour les voyageurs.",
  },
  {
    chapter = 11, zone = 'foggy_hollow', segment = 0, floor = 12,
    client = 'gloom', client_gender = RogueEssence.Data.Gender.Female,
    target = 'gloom', target_gender = RogueEssence.Data.Gender.Female,
    difficulty = 'S', reward = 'money',
    title = "Le brouillard sans fin",
    flavor = "Un rideau de brume obscure désoriente quiconque s'aventure dans le Creux Brumeux.\nDissipez cette menace pour ramener la clarté.",
  },
"""

def inject_sq():
    with open(SQ_PATH, "r", encoding="utf-8") as f:
        content = f.read()
    if "id = 'q11_ravin'" in content:
        print("  [SideQuests] Ch11 déjà injecté dans SideQuests.lua.")
        return
    anchor = "    id = 'q10_cime', ch = 10, giver = 'Nidoking',"
    if anchor not in content:
        print("  [Erreur] Ancre q10_cime introuvable dans SideQuests.lua.")
        return
    # insert before end of LIST table
    # find where q10_cime entry ends
    idx = content.find(anchor)
    end_entry = content.find("undertow = \"mission personnelle de déblocage donjon avec partenaire et héros\",\n  },", idx)
    if end_entry == -1:
        print("  [Erreur] Fin de q10_cime introuvable.")
        return
    insert_pos = end_entry + len("undertow = \"mission personnelle de déblocage donjon avec partenaire et héros\",\n  },")
    new_content = content[:insert_pos] + "\n" + CH11_SQ_LUA + content[insert_pos:]
    with open(SQ_PATH, "w", encoding="utf-8") as f:
        f.write(new_content)
    print("  [SideQuests] Quêtes q11_ravin, q11_gorge, q11_piste, q11_creux injectées !")

def inject_sj():
    with open(SJ_PATH, "r", encoding="utf-8") as f:
        content = f.read()
    if "zone = 'rainy_ravine'" in content:
        print("  [SecondaryJobs] Ch11 déjà injecté dans SecondaryJobs.lua.")
        return
    anchor = "    title = \"Le silence de la Cime d'Argent\","
    idx = content.find(anchor)
    if idx == -1:
        print("  [Erreur] Ancre forgotten_silver_spire introuvable dans SecondaryJobs.lua.")
        return
    end_entry = content.find("  },", idx) + len("  },")
    new_content = content[:end_entry] + "\n" + CH11_SJ_LUA + content[end_entry:]
    with open(SJ_PATH, "w", encoding="utf-8") as f:
        f.write(new_content)
    print("  [SecondaryJobs] Contrats de guilde Ch11 injectés !")

if __name__ == "__main__":
    print("=== INJECTION QUÊTES & CONTRATS CH11 ===")
    inject_sq()
    inject_sj()
