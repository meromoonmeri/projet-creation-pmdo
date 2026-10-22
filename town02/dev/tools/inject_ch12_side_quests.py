#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
inject_ch12_side_quests.py — Ajoute les quêtes secondaires et contrats de guilde
pour les 4 donjons secondaires du Chapitre 12 (Suite Arc Fugitif).
"""
import os, sys

MOD_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SQ_PATH = os.path.join(MOD_ROOT, "Data/Script/halcyon/SideQuests.lua")
SJ_PATH = os.path.join(MOD_ROOT, "Data/Script/halcyon/SecondaryJobs.lua")

CH12_SQ_LUA = """  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE (24 LIGNES AVEC PARTENAIRE/HÉROS) : Creux Cendré ===
  {
    id = 'q12_cendres', ch = 12, giver = 'Slugma', target = 'Slugma',
    unlock_dungeon = 'ashen_hollow', dungeon_name = "Creux Cendré",
    titre = "La cendre sacrée",
    ask = {
      {'Slugma', 'Sad',     'Pfff... Pfff... Les cendres de notre grotte sont devenues toxiques.'},
      {'Teammate1', 'Surprised','Limagma ? Pourquoi votre creux volcanique dégage-t-il cette fumée ?'},
      {'Slugma', 'Worried', 'Grotadmorv d Alola le Toxique a contaminé le cœur du Creux Cendré.'},
      {'Slugma', 'Normal',  'Ce vallon calciné est notre refuge de chaleur au nord des montagnes.'},
      {'Slugma', 'Angry',   'Ses boues acides étouffent tous les foyers de lave de notre tribu !'},
      {'Slugma', 'Sad',     'Sans chaleur pure, nos corps de lave vont se solidifier.'},
      {'Teammate1', 'Worried', 'Une contamination acide ? C est un danger pour toute la montagne !'},
      {'PLAYER',    'Determined','(Je regarde la fumée noire : nous allons purifier ce foyer volcanique.)'},
      {'Slugma', 'Worried', 'Si Grotadmorv ne quitte pas le cratère, la chaleur s éteindra.'},
      {'Slugma', 'Sad',     'Nous cherchons des explorateurs qui ne craignent pas les brûlures.'},
      {'Teammate1', 'Determined','Laisse-nous faire ! Nous allons gravir le creux et chasser la boue !'},
      {'Slugma', 'Inspired','Vrai ? Merci ! Sauvez la flamme de notre tribu !'}
    },
    accept = {{'Slugma', 'Happy',   'Génial ! Votre courage réchauffe déjà nos cœurs !'},
      {'Teammate1', 'Happy', 'Gardez votre chaleur, le cratère sera bientôt purifié !'},
      {'Slugma', 'Normal',  'Le creux est niché au pied du grand volcan fumant du nord.'}},
    refuse = {{'Slugma', 'Sad',     'Je comprends... La fumée acide est redoutable.'},
      {'Teammate1', 'Sad',   'Nous allons d abord préparer des remèdes contre le poison.'}},
    pending= {{'Slugma', 'Worried', 'Le Creux Cendré a-t-il retrouvé sa chaleur pure ?'},
      {'Teammate1', 'Determined','Nous montons vers le repaire de Grotadmorv !'}},
    solve  = {{'Slugma', 'Worried', 'Le Creux Cendré a-t-il retrouvé sa chaleur pure ?'},
      {'Teammate1', 'Determined','Nous montons vers le repaire de Grotadmorv !'}},
    done   = {
      {'Slugma', 'Inspired','OH ! LA CHALEUR REVIENT ! Les cendres sont redevenues douces !'},
      {'Teammate1', 'Happy', 'Grotadmorv d Alola a accepté de nettoyer sa boue acide !'},
      {'PLAYER',    'Happy', '(La lave claire brille à nouveau dans le vallon volcanique.)'},
      {'Slugma', 'Happy',   'Nos corps de lave pétillent de joie grâce à vous deux !'},
      {'Slugma', 'Surprised','Vous avez résisté aux boues les plus corrosives du cratère ?'},
      {'Teammate1', 'Inspired','Aucune fumée ne peut voiler notre détermination !'},
      {'Slugma', 'Happy',   'Notre clan vous considérera toujours comme des frères de flamme !'},
      {'Slugma', 'Inspired','Voici un trésor minéral né des cendres sacrées !'},
      {'Slugma', 'Normal',  'Que la chaleur vous protège dans le grand nord !'}
    },
    undertow = "mission personnelle de déblocage donjon avec partenaire et héros",
  },
  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE (24 LIGNES AVEC PARTENAIRE/HÉROS) : Faille Gelée ===
  {
    id = 'q12_faille', ch = 12, giver = 'Snorunt', target = 'Snorunt',
    unlock_dungeon = 'frozen_rift', dungeon_name = "Faille Gelée",
    titre = "Le cristal de glace",
    ask = {
      {'Snorunt', 'Sad',     'Brrr... Brrr... Le vent de la faille glace même nos cœurs.'},
      {'Teammate1', 'Surprised','Stalgamin ? Pourquoi tremblez-vous dans votre propre caverne de glace ?'},
      {'Snorunt', 'Worried', 'Séracrawl le Roc Glacé a bloqué le grand puits de la Faille Gelée.'},
      {'Snorunt', 'Normal',  'Cette faille est le chemin par lequel remonte l air tempéré du sous-sol.'},
      {'Snorunt', 'Angry',   'Son immense corps de glace obstrue tout, provoquant un gel éternel !'},
      {'Snorunt', 'Sad',     'Nos petits n arrivent plus à creuser dans cette glace trop dure.'},
      {'Teammate1', 'Worried', 'Un gel qui bloque le passage de la chaleur ? C est un désastre !'},
      {'PLAYER',    'Determined','(Je sers les poings : nous devons dégager le puits de la faille.)'},
      {'Snorunt', 'Worried', 'Si Séracrawl ne se déplace pas, la faille sera scellée à jamais.'},
      {'Snorunt', 'Sad',     'Pouvez-vous descendre dans le blizzard pour lui parler ?'},
      {'Teammate1', 'Determined','Comptez sur nous ! Nous allons traverser le givre et ouvrir le puits !'},
      {'Snorunt', 'Inspired','Vrai ? Merci de tout cœur, braves explorateurs !'}
    },
    accept = {{'Snorunt', 'Happy',   'Youpi ! Votre présence nous réchauffe déjà !'},
      {'Teammate1', 'Happy', 'Abriter les petits, la chaleur va remonter du sous-sol !'},
      {'Snorunt', 'Normal',  'La faille s ouvre dans le grand glacier au nord des crêtes.'}},
    refuse = {{'Snorunt', 'Sad',     'Brrr... Je comprends, le froid là-bas est terrible.'},
      {'Teammate1', 'Sad',   'Nous allons chercher des provisions contre le gel d abord.'}},
    pending= {{'Snorunt', 'Worried', 'Le puits de la Faille Gelée est-il toujours bloqué par le roc ?'},
      {'Teammate1', 'Determined','Nous glissons vers la salle de Séracrawl !'}},
    solve  = {{'Snorunt', 'Worried', 'Le puits de la Faille Gelée est-il toujours bloqué par le roc ?'},
      {'Teammate1', 'Determined','Nous glissons vers la salle de Séracrawl !'}},
    done   = {
      {'Snorunt', 'Inspired','YOUPI ! LE COURANT CHAUD REMONTE ! La glace s adoucit !'},
      {'Teammate1', 'Happy', 'Séracrawl a accepté de déplacer sa masse pour libérer le puits !'},
      {'PLAYER',    'Happy', '(Un air tiède s échappe des profondeurs de la caverne de glace.)'},
      {'Snorunt', 'Happy',   'Nos petits peuvent à nouveau creuser leurs abris dans le givre !'},
      {'Snorunt', 'Surprised','Vous avez réussi à déplacer le plus lourd géant de glace ?'},
      {'Teammate1', 'Inspired','Ensemble, nous déplaçons des montagnes de glace !'},
      {'Snorunt', 'Happy',   'Tribu de Stalgamin vous offre sa reconnaissance éternelle !'},
      {'Snorunt', 'Inspired','Prenez ce cristal de givre d une pureté inestimable !'},
      {'Snorunt', 'Normal',  'Que vos pas soient légers sur la neige du nord !'}
    },
    undertow = "mission personnelle de déblocage donjon avec partenaire et héros",
  },
  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE (24 LIGNES AVEC PARTENAIRE/HÉROS) : Crête Chuchotante ===
  {
    id = 'q12_crete', ch = 12, giver = 'Pidgeotto', target = 'Pidgeotto',
    unlock_dungeon = 'whispering_crag', dungeon_name = "Crête Chuchotante",
    titre = "Le vent d'acier",
    ask = {
      {'Pidgeotto', 'Sad',     'Roucou... Les vents des crêtes portent des cris menaçants.'},
      {'Teammate1', 'Surprised','Roucoups ? Pourquoi les oiseaux n osent-ils plus voler vers le sommet ?'},
      {'Pidgeotto', 'Worried', 'Corvaillus l Acier a revendiqué toute la Crête Chuchotante.'},
      {'Pidgeotto', 'Normal',  'Cette crête est notre halte naturelle lors de la traversée des monts.'},
      {'Pidgeotto', 'Angry',   'Ses ailes d acier provoquent des tempêtes qui plaquent tout au sol !'},
      {'Pidgeotto', 'Sad',     'Les migrations de printemps sont bloquées en bas de falaise.'},
      {'Teammate1', 'Worried', 'Les migrations interrompues ? C est tout le ciel qui est en danger !'},
      {'PLAYER',    'Determined','(Je regarde vers la crête : allons libérer l espace aérien.)'},
      {'Pidgeotto', 'Worried', 'Si Corvaillus ne partage pas le vent, aucun oiseau ne passera.'},
      {'Pidgeotto', 'Sad',     'Nous cherchons des explorateurs au pied ferme pour l affronter.'},
      {'Teammate1', 'Determined','Laisse-nous faire ! Nous allons monter sur la crête et lui parler !'},
      {'Pidgeotto', 'Inspired','Vrai ? Merci ! Que le vent vous porte !'}
    },
    accept = {{'Pidgeotto', 'Happy',   'Génial ! Vous êtes l espoir du ciel !'},
      {'Teammate1', 'Happy', 'Prévenez les nuées, le couloir aérien va rouvrir !'},
      {'Pidgeotto', 'Normal',  'La crête est accessible par le sentier venteux du grand mont nordique.'}},
    refuse = {{'Pidgeotto', 'Sad',     'Je comprends... Ses ailes d acier sont redoutables.'},
      {'Teammate1', 'Sad',   'Nous reviendrons quand nos ailes seront plus vaillantes.'}},
    pending= {{'Pidgeotto', 'Worried', 'Les vents de la Crête Chuchotante sont-ils toujours hostiles ?'},
      {'Teammate1', 'Determined','Nous atteignons le sommet où règne Corvaillus !'}},
    solve  = {{'Pidgeotto', 'Worried', 'Les vents de la Crête Chuchotante sont-ils toujours hostiles ?'},
      {'Teammate1', 'Determined','Nous atteignons le sommet où règne Corvaillus !'}},
    done   = {
      {'Pidgeotto', 'Inspired','ROUCOU ! LE CIEL EST DÉGAGÉ ! Les courants sont redevenus calmes !'},
      {'Teammate1', 'Happy', 'Corvaillus a compris que le ciel appartient à tous les oiseaux !'},
      {'PLAYER',    'Happy', '(Je vois des nuées de Roucoups reprendre leur vol majestueux.)'},
      {'Pidgeotto', 'Happy',   'La migration peut enfin reprendre grâce à votre exploit !'},
      {'Pidgeotto', 'Surprised','Vous avez tenu tête au monarque d acier des plus hautes falaises ?'},
      {'Teammate1', 'Inspired','Rien ne peut arrêter notre élan quand nous volons ensemble !'},
      {'Pidgeotto', 'Happy',   'Tous les oiseaux de passage chanteront vos louanges !'},
      {'Pidgeotto', 'Inspired','Voici une plume d argent rare en gage de gratitude !'},
      {'Pidgeotto', 'Normal',  'Que les vents du nord vous soient toujours favorables !'}
    },
    undertow = "mission personnelle de déblocage donjon avec partenaire et héros",
  },
  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE (24 LIGNES AVEC PARTENAIRE/HÉROS) : Marais Crépusculaire ===
  {
    id = 'q12_marais', ch = 12, giver = 'Wooper_Girl', target = 'Wooper_Girl',
    unlock_dungeon = 'twilight_marsh', dungeon_name = "Marais Crépusculaire",
    titre = "La tourbe du couchant",
    ask = {
      {'Wooper_Girl', 'Sad',     'Ouin... Ouin... La boue claire du marais s est changée en tourbe noire.'},
      {'Teammate1', 'Surprised','Axoloto ? Pourquoi votre marais semble-t-il figé au crépuscule ?'},
      {'Wooper_Girl', 'Worried', 'Bourrinos la Tourbe a piétiné les sources claires du Marais Crépusculaire.'},
      {'Wooper_Girl', 'Normal',  'C est un marécage paisible où nous cultivons nos baies d humidité.'},
      {'Wooper_Girl', 'Angry',   'Ses sabots lourds écrasent tout sur leur passage dans la boue !'},
      {'Wooper_Girl', 'Sad',     'Plus aucune baie ne pousse dans cette tourbe trop dense.'},
      {'Teammate1', 'Worried', 'Les baies qui sont détruites ? Toute la faune du marais va souffrir !'},
      {'PLAYER',    'Determined','(Je regarde la boue sombre : nous devons apaiser le grand étalon.)'},
      {'Wooper_Girl', 'Worried', 'Il faut persuader Bourrinos de quitter les champs de baies.'},
      {'Wooper_Girl', 'Sad',     'Pouvez-vous traverser les fondrières pour nous aider ?'},
      {'Teammate1', 'Determined','Compte sur nous ! Nous allons libérer les sources du marais !'},
      {'Wooper_Girl', 'Inspired','Vrai ? Merci ! Sauvez notre jardin de boue !'}
    },
    accept = {{'Wooper_Girl', 'Happy',   'Youpi ! Votre gentillesse est immense !'},
      {'Teammate1', 'Happy', 'Préparez les semences, le marais va redevenir fertile !'},
      {'Wooper_Girl', 'Normal',  'Le marais s étend à la lisière des grands bois tourbeux du nord.'}},
    refuse = {{'Wooper_Girl', 'Sad',     'Ouin... Je comprends, on s enfonce trop vite dans la boue.'},
      {'Teammate1', 'Sad',   'Nous allons d abord chercher des bottes de marche.'}},
    pending= {{'Wooper_Girl', 'Worried', 'Le Marais Crépusculaire est-il toujours foulé par Bourrinos ?'},
      {'Teammate1', 'Determined','Nous traversons la tourbe pour rencontrer Bourrinos !'}},
    solve  = {{'Wooper_Girl', 'Worried', 'Le Marais Crépusculaire est-il toujours foulé par Bourrinos ?'},
      {'Teammate1', 'Determined','Nous traversons la tourbe pour rencontrer Bourrinos !'}},
    done   = {
      {'Wooper_Girl', 'Inspired','YOUPI ! LA BOUE CLAIRE REVIENT ! La tourbe s est aérée !'},
      {'Teammate1', 'Happy', 'Bourrinos a accepté de galoper plus loin dans les plaines vides !'},
      {'PLAYER',    'Happy', '(Les baies d humidité recommencent à germer dans la vase tiède.)'},
      {'Wooper_Girl', 'Happy',   'Notre récolte de baies est sauvée grâce à vous !'},
      {'Wooper_Girl', 'Surprised','Vous avez réussi à calmer la charge du grand Bourrinos ?'},
      {'Teammate1', 'Inspired','Notre sang-froid apaise les plus fortes tempêtes !'},
      {'Wooper_Girl', 'Happy',   'Notre clan d Axoloto n oubliera jamais votre dévouement !'},
      {'Wooper_Girl', 'Inspired','Voici un lot de baies rares cultivées par notre tribu !'},
      {'Wooper_Girl', 'Normal',  'Bonne continuation dans votre voyage, amis héros !'}
    },
    undertow = "mission personnelle de déblocage donjon avec partenaire et héros",
  },
"""

CH12_SJ_LUA = """  {
    chapter = 12, zone = 'ashen_hollow', segment = 0, floor = 10,
    client = 'slugma', client_gender = RogueEssence.Data.Gender.Male,
    target = 'slugma', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'A', reward = 'money',
    title = "Les cendres du cratère",
    flavor = "Des boues acides empoisonnent la lave du Creux Cendré au nord des montagnes.\nUne mission de purification est requise.",
  },
  {
    chapter = 12, zone = 'frozen_rift', segment = 0, floor = 12,
    client = 'snorunt', client_gender = RogueEssence.Data.Gender.Female,
    target = 'snorunt', target_gender = RogueEssence.Data.Gender.Female,
    difficulty = 'S', reward = 'money',
    title = "Le puits de glace",
    flavor = "Un monarque de glace obstrue le puits thermique de la Faille Gelée.\nLibérez le passage pour faire remonter l'air doux.",
  },
  {
    chapter = 12, zone = 'whispering_crag', segment = 0, floor = 11,
    client = 'pidgeotto', client_gender = RogueEssence.Data.Gender.Male,
    target = 'pidgeotto', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'S', reward = 'money',
    title = "Les ailes d'acier",
    flavor = "Des tempêtes violentes bloquent la route des oiseaux migrateurs sur la Crête Chuchotante.\nSécurisez l'espace aérien.",
  },
  {
    chapter = 12, zone = 'twilight_marsh', segment = 0, floor = 12,
    client = 'wooper', client_gender = RogueEssence.Data.Gender.Female,
    target = 'wooper', target_gender = RogueEssence.Data.Gender.Female,
    difficulty = 'A', reward = 'money',
    title = "La tourbe sombre",
    flavor = "Les champs de baies du Marais Crépusculaire sont ravagés par un étalon lourd.\nProtégez nos cultures marécageuses.",
  },
"""

def inject_sq():
    with open(SQ_PATH, "r", encoding="utf-8") as f:
        content = f.read()
    if "id = 'q12_cendres'" in content:
        print("  [SideQuests] Ch12 déjà injecté dans SideQuests.lua.")
        return
    anchor = "    id = 'q11_creux', ch = 11, giver = 'Gloom',"
    if anchor not in content:
        print("  [Erreur] Ancre q11_creux introuvable dans SideQuests.lua.")
        return
    idx = content.find(anchor)
    end_entry = content.find("undertow = \"mission personnelle de déblocage donjon avec partenaire et héros\",\n  },", idx)
    if end_entry == -1:
        print("  [Erreur] Fin de q11_creux introuvable.")
        return
    insert_pos = end_entry + len("undertow = \"mission personnelle de déblocage donjon avec partenaire et héros\",\n  },")
    new_content = content[:insert_pos] + "\n" + CH12_SQ_LUA + content[insert_pos:]
    with open(SQ_PATH, "w", encoding="utf-8") as f:
        f.write(new_content)
    print("  [SideQuests] Quêtes q12_cendres, q12_faille, q12_crete, q12_marais injectées !")

def inject_sj():
    with open(SJ_PATH, "r", encoding="utf-8") as f:
        content = f.read()
    if "zone = 'ashen_hollow'" in content:
        print("  [SecondaryJobs] Ch12 déjà injecté dans SecondaryJobs.lua.")
        return
    anchor = "    title = \"Le brouillard sans fin\","
    idx = content.find(anchor)
    if idx == -1:
        print("  [Erreur] Ancre foggy_hollow introuvable dans SecondaryJobs.lua.")
        return
    end_entry = content.find("  },", idx) + len("  },")
    new_content = content[:end_entry] + "\n" + CH12_SJ_LUA + content[end_entry:]
    with open(SJ_PATH, "w", encoding="utf-8") as f:
        f.write(new_content)
    print("  [SecondaryJobs] Contrats de guilde Ch12 injectés !")

if __name__ == "__main__":
    print("=== INJECTION QUÊTES & CONTRATS CH12 ===")
    inject_sq()
    inject_sj()
