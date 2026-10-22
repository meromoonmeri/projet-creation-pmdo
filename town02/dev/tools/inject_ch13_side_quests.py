#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os, sys

MOD_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SQ_PATH = os.path.join(MOD_ROOT, "Data/Script/halcyon/SideQuests.lua")
SJ_PATH = os.path.join(MOD_ROOT, "Data/Script/halcyon/SecondaryJobs.lua")

CH13_SQ_LUA = """  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE (24 LIGNES AVEC PARTENAIRE/HÉROS) : Caverne Grelottante ===
  {
    id = 'q13_caverne', ch = 13, giver = 'Snorunt', target = 'Snorunt',
    unlock_dungeon = 'shivering_cavern', dungeon_name = "Caverne Grelottante",
    titre = "Le gel éternel",
    ask = {
      {'Snorunt', 'Sad',     'Brrr... Brrr... Notre grotte de glace tremble de frissons de givre.'},
      {'Teammate1', 'Surprised','Stalgamin ? Pourquoi votre clan semble-t-il gelé par le vent du nord ?'},
      {'Snorunt', 'Worried', 'Blizzarroi le Gel Éternel a scellé la source tiède de la Caverne Grelottante.'},
      {'Snorunt', 'Normal',  'Cette caverne abrite les parois de cristal où nous grandissons.'},
      {'Snorunt', 'Angry',   'Ses tempêtes de neige transforment tout en statues de givre !'},
      {'Snorunt', 'Sad',     'Nos feux de camp s éteignent avant même d être allumés.'},
      {'Teammate1', 'Worried', 'Un gel éternel ? Tout le nord risque de geler complètement !'},
      {'PLAYER',    'Determined','(Je hoche la tête : nous devons réchauffer cette caverne de givre.)'},
      {'Snorunt', 'Worried', 'Si Blizzarroi ne se calme pas, la grotte sera condamnée.'},
      {'Snorunt', 'Sad',     'Pouvez-vous descendre dans le blizzard et ouvrir la source ?'},
      {'Teammate1', 'Determined','Laisse-nous faire ! Nous allons traverser la caverne et apaiser le gel !'},
      {'Snorunt', 'Inspired','Vrai ? Merci de tout cœur ! Que la flamme vous guide !'}
    },
    accept = {{'Snorunt', 'Happy',   'Youpi ! Votre chaleur nous protège déjà !'},
      {'Teammate1', 'Happy', 'Abriter les petits, la source chaude va bientôt remonter !'},
      {'Snorunt', 'Normal',  'La caverne s ouvre au fond de la crevasse nordique.'}},
    refuse = {{'Snorunt', 'Sad',     'Brrr... Je comprends, ce froid peut paralyser.'},
      {'Teammate1', 'Sad',   'Nous allons d abord rassembler des provisions chaudes.'}},
    pending= {{'Snorunt', 'Worried', 'La Caverne Grelottante est-elle toujours paralysée par le gel ?'},
      {'Teammate1', 'Determined','Nous glissons vers le sanctuaire de Blizzarroi !'}},
    solve  = {{'Snorunt', 'Worried', 'La Caverne Grelottante est-elle toujours paralysée par le gel ?'},
      {'Teammate1', 'Determined','Nous glissons vers le sanctuaire de Blizzarroi !'}},
    done   = {
      {'Snorunt', 'Inspired','YOUPI ! LE GIVRE FONCTIONNE ! L eau tiède recommence à couler !'},
      {'Teammate1', 'Happy', 'Blizzarroi a accepté de réduire ses tempêtes de neige éternelle !'},
      {'PLAYER',    'Happy', '(Un air doux s échappe des stalactites de cristal du nord.)'},
      {'Snorunt', 'Happy',   'Nos petits jouent à nouveau sur les parois brillantes !'},
      {'Snorunt', 'Surprised','Vous avez vraiment vaincu le grand Blizzarroi des cavernes ?'},
      {'Teammate1', 'Inspired','Notre amitié ne gèlera jamais devant les blizzards !'},
      {'Snorunt', 'Happy',   'La tribu de Stalgamin vous proclame protecteurs du nord !'},
      {'Snorunt', 'Inspired','Prenez ce joyau de givre ancien en reconnaissance !'},
      {'Snorunt', 'Normal',  'Bonne continuation sur les terres glacées !'}
    },
    undertow = "mission personnelle de déblocage donjon avec partenaire et héros",
  },
  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE (24 LIGNES AVEC PARTENAIRE/HÉROS) : Crête de la Tempête ===
  {
    id = 'q13_crete', ch = 13, giver = 'Manectric', target = 'Manectric',
    unlock_dungeon = 'tempest_ridge', dungeon_name = "Crête de la Tempête",
    titre = "Le tonnerre du col",
    ask = {
      {'Manectric', 'Sad',     'Grrr... Les éclairs de la haute crête grondent sans discontinuer.'},
      {'Teammate1', 'Surprised','Élecsprint ? Pourquoi ces foudres bloquent-elles le passage nordique ?'},
      {'Manectric', 'Worried', 'Fulguris le Tonnerre a déchaîné un orage sur la Crête de la Tempête.'},
      {'Manectric', 'Normal',  'Cette crête est notre relais pour capter la lumière du sommet.'},
      {'Manectric', 'Angry',   'Ses foudres féroces empêchent quiconque de franchir le col !'},
      {'Manectric', 'Sad',     'Nos patrouilles ne peuvent plus traverser la foudre.'},
      {'Teammate1', 'Worried', 'Un orage infranchissable ? C est un danger pour toute la région !'},
      {'PLAYER',    'Determined','(Je regarde vers la crête : allons apaiser la foudre.)'},
      {'Manectric', 'Worried', 'Il faut convaincre Fulguris de retenir sa foudre royale.'},
      {'Manectric', 'Sad',     'Avez-vous la vitesse suffisante pour monter sur la crête ?'},
      {'Teammate1', 'Determined','Bien sûr ! Nous allons gravir la crête et calmer l orage !'},
      {'Manectric', 'Inspired','Oh, quel courage ! Que l éclair guide vos pas !'}
    },
    accept = {{'Manectric', 'Happy',   'Excellent ! Votre détermination brille comme la foudre !'},
      {'Teammate1', 'Happy', 'Prévenez les patrouilles, le col sera bientôt rouvert !'},
      {'Manectric', 'Normal',  'La crête monte directement après les grands monts électrisés.'}},
    refuse = {{'Manectric', 'Sad',     'Je comprends... Ses éclairs sont trop puissants.'},
      {'Teammate1', 'Sad',   'Nous allons d abord chercher de l équipement isolant.'}},
    pending= {{'Manectric', 'Worried', 'Les foudres de la Crête de la Tempête se sont-elles tues ?'},
      {'Teammate1', 'Determined','Nous montons vers le sommet où règne Fulguris !'}},
    solve  = {{'Manectric', 'Worried', 'Les foudres de la Crête de la Tempête se sont-elles tues ?'},
      {'Teammate1', 'Determined','Nous montons vers le sommet où règne Fulguris !'}},
    done   = {
      {'Manectric', 'Inspired','INCROYABLE ! LE CIEL ORAGEUX S EST CALMÉ !'},
      {'Teammate1', 'Happy', 'Fulguris a accepté de laisser le col en paix pour les voyageurs !'},
      {'PLAYER',    'Happy', '(La lumière naturelle revient éclairer les rochers de la crête.)'},
      {'Manectric', 'Happy',   'Vous avez rouvert le grand passage des sommets nordiques !'},
      {'Manectric', 'Surprised','Vous avez tenu tête au monarque des nuages foudroyants ?'},
      {'Teammate1', 'Inspired','Aucun orage ne peut dissiper notre lien d amitié !'},
      {'Manectric', 'Happy',   'Les patrouilles chanteront votre courage à jamais !'},
      {'Manectric', 'Inspired','Voici une pierre de foudre pure en gage de gratitude !'},
      {'Manectric', 'Normal',  'Que la foudre éclaire toujours votre route !'}
    },
    undertow = "mission personnelle de déblocage donjon avec partenaire et héros",
  },
  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE (24 LIGNES AVEC PARTENAIRE/HÉROS) : Fourré Creux ===
  {
    id = 'q13_fourre', ch = 13, giver = 'Gloom', target = 'Gloom',
    unlock_dungeon = 'hollow_thicket', dungeon_name = "Fourré Creux",
    titre = "Les racines de l'ombre",
    ask = {
      {'Gloom', 'Sad',     'Snif... Snif... Les ronces du fourré ont envahi tous les sentiers.'},
      {'Teammate1', 'Surprised','Ortide ? Pourquoi les bois sont-ils devenus si impraticables ?'},
      {'Gloom', 'Worried', 'Zarude le Rôdeur a resserré l écorce du Fourré Creux.'},
      {'Gloom', 'Normal',  'Ce fourré est une ancienne plantation sauvage des profondeurs.'},
      {'Gloom', 'Angry',   'Ses lianes sombres étouffent toute la lumière qui traverse le feuillage !'},
      {'Gloom', 'Sad',     'Les petits Pokémon des bois sont pris au piège à l intérieur.'},
      {'Teammate1', 'Worried', 'Des petits piégés par les lianes ? Nous devons intervenir !'},
      {'PLAYER',    'Determined','(Je hoche la tête : nous allons libérer les sous-bois.)'},
      {'Gloom', 'Worried', 'Si Zarude ne desserre pas ses ronces, la forêt mourra.'},
      {'Gloom', 'Sad',     'Pouvez-vous traverser le fourré pour lui faire entendre raison ?'},
      {'Teammate1', 'Determined','Laisse-nous faire ! Nous allons ouvrir le fourré et sauver les petits !'},
      {'Gloom', 'Inspired','Vrai ? Merci infiniment, braves explorateurs !'}
    },
    accept = {{'Gloom', 'Happy',   'Snif ! Votre bonté est immense !'},
      {'Teammate1', 'Happy', 'Gardez espoir, la lumière va revenir dans le fourré !'},
      {'Gloom', 'Normal',  'Le fourré commence au nord des anciennes ruines végétales.'}},
    refuse = {{'Gloom', 'Sad',     'Snif... Je comprends, ses lianes sont trop tranchantes.'},
      {'Teammate1', 'Sad',   'Nous reviendrons avec des outils pour trancher les ronces.'}},
    pending= {{'Gloom', 'Worried', 'Le Fourré Creux est-il toujours prisonnier des ronces ?'},
      {'Teammate1', 'Determined','Nous avançons vers l antre de Zarude !'}},
    solve  = {{'Gloom', 'Worried', 'Le Fourré Creux est-il toujours prisonnier des ronces ?'},
      {'Teammate1', 'Determined','Nous avançons vers l antre de Zarude !'}},
    done   = {
      {'Gloom', 'Inspired','OH ! LES LIANES S OUVRENT ! La lumière pénètre le sous-bois !'},
      {'Teammate1', 'Happy', 'Zarude a compris qu il devait laisser la forêt respirer !'},
      {'PLAYER',    'Happy', '(Les petits Pokémon des bois s élancent libres dans la clairière.)'},
      {'Gloom', 'Happy',   'Le fourré est redevenu un refuge paisible grâce à vous !'},
      {'Gloom', 'Surprised','Vous avez su apaiser la fureur du protecteur des ronces ?'},
      {'Teammate1', 'Inspired','Notre sincérité touche même les cœurs les plus sauvages !'},
      {'Gloom', 'Happy',   'La forêt entière bénit votre présence bienveillante !'},
      {'Gloom', 'Inspired','Voici un lot de baies miracles de nos bois !'},
      {'Gloom', 'Normal',  'Bon voyage dans vos prochaines explorations !'}
    },
    undertow = "mission personnelle de déblocage donjon avec partenaire et héros",
  },
  -- === QUÊTE DÉBLOCAGE DONJON SECONDAIRE (24 LIGNES AVEC PARTENAIRE/HÉROS) : Marais Silencieux ===
  {
    id = 'q13_marais', ch = 13, giver = 'Wooper_Girl', target = 'Wooper_Girl',
    unlock_dungeon = 'silent_marsh', dungeon_name = "Marais Silencieux",
    titre = "La tourbière muette",
    ask = {
      {'Wooper_Girl', 'Sad',     'Ouin... Ouin... Le marais a perdu toute sa voix et ses chants.'},
      {'Teammate1', 'Surprised','Axoloto ? Pourquoi votre tourbière est-elle plongée dans ce silence ?'},
      {'Wooper_Girl', 'Worried', 'Muplodocus de Hisui l Acier a scellé les brumes du Marais Silencieux.'},
      {'Wooper_Girl', 'Normal',  'C est un marais sacré où résonnent les chants de pluie de notre clan.'},
      {'Wooper_Girl', 'Angry',   'Sa coquille d acier lourd étouffe tous les sons et assèche la vase !'},
      {'Wooper_Girl', 'Sad',     'Sans musique, nos œufs d Axoloto n éclosent plus.'},
      {'Teammate1', 'Worried', 'Des œufs qui n éclosent plus ? C est une tragédie pour votre clan !'},
      {'PLAYER',    'Determined','(Je regarde la brume muette : allons ramener la chanson du marais.)'},
      {'Wooper_Girl', 'Worried', 'Il faut persuader Muplodocus d ouvrir sa coquille d acier.'},
      {'Wooper_Girl', 'Sad',     'Avez-vous le courage d entrer dans la tourbière silencieuse ?'},
      {'Teammate1', 'Determined','Compte sur nous ! Nous allons libérer la musique du marais !'},
      {'Wooper_Girl', 'Inspired','Vrai ? Merci ! Que le chant des pluies vous guide !'}
    },
    accept = {{'Wooper_Girl', 'Happy',   'Youpi ! Vous êtes nos sauveurs !'},
      {'Teammate1', 'Happy', 'Préparez vos chants, la musique va revenir !'},
      {'Wooper_Girl', 'Normal',  'Le marais s étend au-delà des bois d ombre nordiques.'}},
    refuse = {{'Wooper_Girl', 'Sad',     'Ouin... Je comprends, ce silence est oppressant.'},
      {'Teammate1', 'Sad',   'Nous reviendrons quand nous serons prêts à briser ce silence.'}},
    pending= {{'Wooper_Girl', 'Worried', 'Le Marais Silencieux a-t-il retrouvé sa voix ?'},
      {'Teammate1', 'Determined','Nous avançons vers le sanctuaire d acier de Muplodocus !'}},
    solve  = {{'Wooper_Girl', 'Worried', 'Le Marais Silencieux a-t-il retrouvé sa voix ?'},
      {'Teammate1', 'Determined','Nous avançons vers le sanctuaire d acier de Muplodocus !'}},
    done   = {
      {'Wooper_Girl', 'Inspired','YOUPI ! LES CHANTS DE PLUIE REVIENNENT ! La tourbière chante !'},
      {'Teammate1', 'Happy', 'Muplodocus d Hisui a accepté de faire résonner sa coquille pour nous !'},
      {'PLAYER',    'Happy', '(Les petits Axoloto commencent à éclore dans la vase joyeuse.)'},
      {'Wooper_Girl', 'Happy',   'Notre clan renaît grâce à votre exploit inoubliable !'},
      {'Wooper_Girl', 'Surprised','Vous avez ému le cœur d acier du gardien de Hisui ?'},
      {'Teammate1', 'Inspired','La musique de notre amitié brise toutes les armures !'},
      {'Wooper_Girl', 'Happy',   'Nous chanterons toujours votre légende dans le marais !'},
      {'Wooper_Girl', 'Inspired','Prenez cette perle d humidité d une valeur sacrée !'},
      {'Wooper_Girl', 'Normal',  'Que la joie accompagne tous vos pas dans le nord !'}
    },
    undertow = "mission personnelle de déblocage donjon avec partenaire et héros",
  },
"""

CH13_SJ_LUA = """  {
    chapter = 13, zone = 'shivering_cavern', segment = 0, floor = 10,
    client = 'snorunt', client_gender = RogueEssence.Data.Gender.Male,
    target = 'snorunt', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'A', reward = 'money',
    title = "Le gel éternel",
    flavor = "Un blizzard éternel paralyse la source thermale de la Caverne Grelottante.\nUne expédition de secours est réclamée.",
  },
  {
    chapter = 13, zone = 'tempest_ridge', segment = 0, floor = 12,
    client = 'manectric', client_gender = RogueEssence.Data.Gender.Female,
    target = 'manectric', target_gender = RogueEssence.Data.Gender.Female,
    difficulty = 'S', reward = 'money',
    title = "L'orage de la crête",
    flavor = "Des foudres violentes interdisent le passage sur la Crête de la Tempête.\nApaiser l'orage pour rouvrir le col.",
  },
  {
    chapter = 13, zone = 'hollow_thicket', segment = 0, floor = 11,
    client = 'gloom', client_gender = RogueEssence.Data.Gender.Male,
    target = 'gloom', target_gender = RogueEssence.Data.Gender.Male,
    difficulty = 'S', reward = 'money',
    title = "Les ronces du fourré",
    flavor = "Des lianes sombres emprisonnent les sous-bois du Fourré Creux.\nLibérez les sentiers pour les habitants forestiers.",
  },
  {
    chapter = 13, zone = 'silent_marsh', segment = 0, floor = 12,
    client = 'wooper', client_gender = RogueEssence.Data.Gender.Female,
    target = 'wooper', target_gender = RogueEssence.Data.Gender.Female,
    difficulty = 'A', reward = 'money',
    title = "Le silence du marais",
    flavor = "Le Marais Silencieux est privé de musique par un gardien en armure d'acier.\nRamenez le chant des pluies.",
  },
"""

def inject_sq():
    with open(SQ_PATH, "r", encoding="utf-8") as f:
        content = f.read()
    if "id = 'q13_caverne'" in content:
        print("  [SideQuests] Ch13 déjà injecté dans SideQuests.lua.")
        return
    anchor = "    id = 'q12_marais', ch = 12, giver = 'Wooper_Girl',"
    if anchor not in content:
        print("  [Erreur] Ancre q12_marais introuvable dans SideQuests.lua.")
        return
    idx = content.find(anchor)
    end_entry = content.find("undertow = \"mission personnelle de déblocage donjon avec partenaire et héros\",\n  },", idx)
    if end_entry == -1:
        print("  [Erreur] Fin de q12_marais introuvable.")
        return
    insert_pos = end_entry + len("undertow = \"mission personnelle de déblocage donjon avec partenaire et héros\",\n  },")
    new_content = content[:insert_pos] + "\n" + CH13_SQ_LUA + content[insert_pos:]
    with open(SQ_PATH, "w", encoding="utf-8") as f:
        f.write(new_content)
    print("  [SideQuests] Quêtes q13_caverne, q13_crete, q13_fourre, q13_marais injectées !")

def inject_sj():
    with open(SJ_PATH, "r", encoding="utf-8") as f:
        content = f.read()
    if "zone = 'shivering_cavern'" in content:
        print("  [SecondaryJobs] Ch13 déjà injecté dans SecondaryJobs.lua.")
        return
    anchor = "    title = \"La tourbe sombre\","
    idx = content.find(anchor)
    if idx == -1:
        print("  [Erreur] Ancre twilight_marsh introuvable dans SecondaryJobs.lua.")
        return
    end_entry = content.find("  },", idx) + len("  },")
    new_content = content[:end_entry] + "\n" + CH13_SJ_LUA + content[end_entry:]
    with open(SJ_PATH, "w", encoding="utf-8") as f:
        f.write(new_content)
    print("  [SecondaryJobs] Contrats de guilde Ch13 injectés !")

if __name__ == "__main__":
    print("=== INJECTION QUÊTES & CONTRATS CH13 ===")
    inject_sq()
    inject_sj()
