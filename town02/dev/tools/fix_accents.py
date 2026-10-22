# -*- coding: utf-8 -*-
"""Reaccentue les textes affiches d'un fichier Lua.

   N'agit QUE sur les chaines passees a say/think/narrate/crowd/
   WaitShowDialogue : les commentaires et le code sont laisses intacts.

   Les mots ambigus (a/à, la/là, ou/où, du/dû, sur/sûr, des/dès) ne sont
   PAS traites automatiquement : ils dependent du sens. Ils sont listes
   pour relecture manuelle.
"""
import re, sys

# Mots dont l'accentuation est certaine, quel que soit le contexte.
SURS = {
 'etoile':'étoile','etoiles':'étoiles','arretee':'arrêtée','arrete':'arrête',
 'arreter':'arrêter','tombee':'tombée','fissure':'fissuré','repare':'réparé',
 'remercies':'remerciés','grave':'gravé','commence':'commencé','apres':'après',
 'brule':'brûlé','vallee':'vallée','etait':'était','etaient':'étaient','ete':'été',
 'EMPECHE':'EMPÊCHÉ','passes':'passés','ramenee':'ramenée','entiere':'entière',
 'meme':'même','memes':'mêmes','ca':'ça','deja':'déjà','decide':'décidé',
 'hesite':'hésité','reussi':'réussi','fermes':'fermés','fermee':'fermée',
 'repondu':'répondu','derriere':'derrière','tenebres':'ténèbres','legende':'légende',
 'annees':'années','annee':'année','lumiere':'lumière','premiere':'première',
 'derniere':'dernière','maniere':'manière','eloigne':'éloigné','ecoute':'écoute',
 'protege':'protégé','proteger':'protéger','regarde':'regardé','realise':'réalisé',
 'celeste':'céleste','eclair':'éclair','eclairs':'éclairs','tempete':'tempête',
 'foret':'forêt','cote':'côté','plutot':'plutôt','bientot':'bientôt',
 'traverse':'traversé','arrive':'arrivé','trouve':'trouvé','donne':'donné',
 'parle':'parlé','pense':'pensé','change':'changé','termine':'terminé',
 'verite':'vérité','realite':'réalité','etrange':'étrange','probleme':'problème',
 'systeme':'système','misere':'misère','securite':'sécurité','interieur':'intérieur',
 'exterieur':'extérieur','geant':'géant','ile':'île','iles':'îles','role':'rôle',
 'controle':'contrôle','gout':'goût','cout':'coût','tres':'très','pres':'près',
 'succede':'succédé','repete':'répété','espere':'espère','prefere':'préfère',
 'colere':'colère','frere':'frère','mere':'mère','pere':'père','fiere':'fière',
 'siecle':'siècle','modele':'modèle','fidele':'fidèle','regle':'règle',
 'reve':'rêve','reves':'rêves','tete':'tête','fete':'fête','bete':'bête',
 'etre':'être','peut-etre':'peut-être','maitre':'maître','connaitre':'connaître',
 'paraitre':'paraître','disparaitre':'disparaître','apparaitre':'apparaître',
 'chaine':'chaîne','traine':'traîne','traitre':'traître','gene':'gêne',
 'enquete':'enquête','conquete':'conquête','requete':'requête','honnete':'honnête',
 'ecran':'écran','elan':'élan','emotion':'émotion','energie':'énergie',
 'epoque':'époque','equipe':'équipe','etage':'étage','etat':'état','eveil':'éveil',
 'evenement':'événement','evidence':'évidence','experience':'expérience',
 'general':'général','heros':'héros','idee':'idée','journee':'journée',
 'matinee':'matinée','soiree':'soirée','pensee':'pensée','armee':'armée',
 'montee':'montée','descente':'descente','entree':'entrée','sortie':'sortie',
 'cle':'clé','cles':'clés','the':'thé',
 # NB : 'ne'->'ne' et 'pre'->'pre' RETIRES : ils transformaient la
 # negation « ne » et la preposition en participes. Bug constate le
 # 2026-08-02 (21 occurrences fautives).
 'mele':'mêlé','melee':'mêlée','revele':'révélé','revelee':'révélée',
 'decouvrir':'découvrir','decouverte':'découverte','defaire':'défaire',
 'defendre':'défendre','dela':'delà','desole':'désolé','desolee':'désolée',
 'etoilee':'étoilée','fatigue':'fatigué','fatiguee':'fatiguée',
 'oublie':'oublié','oubliee':'oubliée','prete':'prête','prets':'prêts',
 'reste':'resté','restee':'restée','sauve':'sauvé','sauvee':'sauvée',
 'sauves':'sauvés',
 'coucher':'coucher','frappent':'frappent','soleil':'soleil',
}
AMBIGUS = {'a','la','ou','du','des','sur','mur','cru','crue','tache','pecheur','jeune'}

PATTERNS = [
 r'((?:say|think)\([^,]+,\s*\'[^\']*\',\s*")((?:[^"\\]|\\.)*)(")',
 r'((?:narrate|crowd)\(\s*")((?:[^"\\]|\\.)*)(")',
 r'(WaitShowDialogue\(\s*")((?:[^"\\]|\\.)*)(")',
]

def fix_text(t, amb):
    def repl(m):
        w = m.group(0); lw = w.lower()
        if lw in AMBIGUS:
            amb.add(w); return w
        if lw in SURS:
            new = SURS[lw]
            if w.isupper(): return new.upper()
            if w[0].isupper(): return new[0].upper() + new[1:]
            return new
        return w
    return re.sub(r"[A-Za-zÀ-ÿ']+", repl, t)

def main(path):
    src = open(path, encoding='utf-8').read()
    amb = set(); n = [0]
    def outer(m):
        before, body, after = m.group(1), m.group(2), m.group(3)
        fixed = fix_text(body, amb)
        if fixed != body: n[0] += 1
        return before + fixed + after
    out = src
    for p in PATTERNS:
        out = re.sub(p, outer, out)
    open(path, 'w', encoding='utf-8').write(out)
    print(f"{path} : {n[0]} repliques reaccentuees")
    if amb:
        print("  a relire a la main (accent dependant du sens) :", sorted(amb))

for p in sys.argv[1:]: main(p)
