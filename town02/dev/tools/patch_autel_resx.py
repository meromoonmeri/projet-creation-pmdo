# -*- coding: utf-8 -*-
"""Reecrit les clés CPB du climax ch10 et ajoute les clés de l'arc fugitif.

   Motifs de la reecriture (regles projet) :
     * « Abime » interdit dans un texte affiche avant l'arc 6 -> supprime
     * « humain » : ne jamais designer les personnages des jeux d'origine
       ni evoquer un humain change en Pokemon -> allusion indirecte
     * repliques > 150 caracteres hors [pause=N] -> resserrees
     * Rayquaza n'est pas hostile par haine : il purifie ce qu'il percoit
       comme une agression contre l'equilibre atmospherique.
"""
import re,html,sys,os

FR = {
 "CPB_001":"Vous avez gravi l'Autel des Cieux...[pause=20] Rares sont ceux qui atteignent ces hauteurs.",
 "CPB_002":"Je suis le Gardien des Cieux.[pause=15] Je maintiens l'equilibre de l'air depuis toujours.",
 "CPB_003":"Une secousse monte de la terre jusqu'a ma tour.[pause=20] Je purifierai ce qui la porte.",
 "CPB_004":"Assez...[pause=25] Vous avez tenu bon.[pause=15] Ce n'etait pas de la haine, seulement un devoir.",
 "CPB_005":"Cette lueur dans vos yeux...[pause=20] Je l'ai deja vue, il y a bien longtemps.",
 "CPB_006":"Deux voyageurs venus d'ailleurs se sont tenus la ou vous etes.[pause=20] Ils m'ont affronte, eux aussi.",
 "CPB_007":"Ils m'ont demande d'abattre l'etoile qui tombait sur ce monde.[pause=15] Je l'ai fait.",
 "CPB_008":"Ceux dont parlent les vieux recits ?[pause=15] On les croyait sortis de l'imagination des conteurs.",
 "CPB_009":"Ils etaient bien reels.[pause=20] Et vous portez la meme obstination qu'eux.",
 "CPB_010":"Regardez le ciel ![pause=20] Quelque chose tombe...[pause=15] et ce n'est pas une etoile filante !",
 "CPB_011":"La secousse d'en bas a reveille un debris ancien.[pause=20] Il revient acheve sa chute.",
 "CPB_012":"Tant que je veillerai sur ce ciel,[pause=15] la terre ne brulera pas une seconde fois.",
 "CPB_013":"Rayquaza s'arrache a l'autel et monte droit vers la haute atmosphere.",
 "CPB_014":"Un trait de lumiere fend le ciel.[pause=15] Le debris se disloque en une pluie d'eclats.",
 "CPB_015":"Il a reussi ![pause=15] Regarde tous ces eclats...[pause=10] on dirait une pluie d'etoiles.",
 "CPB_016":"Mais cette lueur pourpre...[pause=20] toute la vallee a du la voir depuis en bas.",
 "CPB_017":"Redescendez vite.[pause=20] Ceux d'en bas n'ont vu qu'un ciel en feu.[pause=15] Ils chercheront un coupable.",
 # --- Arc fugitif : accusation et fuite ---
 "CPF_001":"Ouvrez ![pause=15] La Federation exige des comptes, tout de suite !",
 "CPF_002":"Le ciel s'est embrase juste au-dessus de vous.[pause=20] Personne d'autre n'etait la-haut.",
 "CPF_003":"Ils n'ecouteront pas.[pause=20] Ils ont deja decide de ce qui s'est passe.",
 "CPF_004":"(Nous avons empeche le pire...[pause=20] et c'est nous qu'on vient chercher.)",
 "CPF_005":"Par la porte de derriere.[pause=15] Vite, avant qu'ils fassent le tour du batiment.",
 "CPF_006":"La pluie couvrira nos traces.[pause=20] Reste pres de moi et ne t'arrete pas.",
 "CPF_007":"(La guilde s'eloigne derriere nous.[pause=20] Je ne sais pas si nous la reverrons.)",
 "CPF_008":"La route du sud est encore libre.[pause=15] Apres, il faudra trouver un bateau.",
 "CPF_009":"Cette nuit-la, deux explorateurs quitterent Metano Town sous la pluie, sans se retourner.",
}

EN = {
 "CPB_001":"You have climbed the Celestial Altar...[pause=20] Few ever reach these heights.",
 "CPB_002":"I am the Warden of the Skies.[pause=15] I have kept the air in balance since the beginning.",
 "CPB_003":"A tremor rises from the earth to my tower.[pause=20] I will cleanse whatever carries it.",
 "CPB_004":"Enough...[pause=25] You stood your ground.[pause=15] This was never hatred, only duty.",
 "CPB_005":"That light in your eyes...[pause=20] I have seen it before, long ago.",
 "CPB_006":"Two travellers from elsewhere stood where you stand.[pause=20] They faced me too.",
 "CPB_007":"They asked me to strike down the star falling on this world.[pause=15] I did.",
 "CPB_008":"The ones from the old tales?[pause=15] We thought the storytellers made them up.",
 "CPB_009":"They were real.[pause=20] And you carry the same stubbornness they did.",
 "CPB_010":"Look at the sky![pause=20] Something is falling...[pause=15] and it is no shooting star!",
 "CPB_011":"The tremor below has stirred an old fragment.[pause=20] It returns to finish its fall.",
 "CPB_012":"As long as I watch over this sky,[pause=15] the earth will not burn a second time.",
 "CPB_013":"Rayquaza tears away from the altar and climbs straight into the upper sky.",
 "CPB_014":"A shaft of light splits the sky.[pause=15] The fragment breaks into a rain of shards.",
 "CPB_015":"He did it![pause=15] Look at all those shards...[pause=10] like a shower of stars.",
 "CPB_016":"But that purple glow...[pause=20] the whole valley must have seen it from below.",
 "CPB_017":"Go back down quickly.[pause=20] Those below only saw a burning sky.[pause=15] They will want someone to blame.",
 "CPF_001":"Open up![pause=15] The Federation demands answers, right now!",
 "CPF_002":"The sky caught fire directly above you.[pause=20] No one else was up there.",
 "CPF_003":"They will not listen.[pause=20] They have already decided what happened.",
 "CPF_004":"(We stopped the worst of it...[pause=20] and they have come for us.)",
 "CPF_005":"Through the back door.[pause=15] Quickly, before they circle the building.",
 "CPF_006":"The rain will cover our tracks.[pause=20] Stay close and do not stop.",
 "CPF_007":"(The guild is falling away behind us.[pause=20] I do not know if we will see it again.)",
 "CPF_008":"The south road is still open.[pause=15] After that, we will need a boat.",
 "CPF_009":"That night, two explorers left Metano Town in the rain, and did not look back.",
}

def patch(path, table):
    s=open(path,encoding='utf-8').read()
    orig=s
    for k,v in table.items():
        esc=(v.replace('&','&amp;').replace('<','&lt;').replace('>','&gt;'))
        pat=re.compile(rf'(<data name="{k}" xml:space="preserve"><value>).*?(</value></data>)',re.S)
        if pat.search(s):
            s=pat.sub(lambda m: m.group(1)+esc+m.group(2), s, count=1)
        else:
            s=s.replace('</root>', f'  <data name="{k}" xml:space="preserve"><value>{esc}</value></data>\n</root>')
    open(path,'w',encoding='utf-8',newline='').write(s)
    return s!=orig

def check(path):
    s=open(path,encoding='utf-8').read()
    d={m.group(1):html.unescape(m.group(2)) for m in
       re.finditer(r'<data name="([^"]+)"[^>]*><value>(.*?)</value>',s,re.S)}
    bad=[]
    for k,v in d.items():
        net=re.sub(r'\[pause=\d+\]','',v)
        for w in ("Abîme","Abime","Necrozma","Eternatus","prison","humain","Humain"):
            if w in v: bad.append(f"{k}: mot interdit '{w}'")
        if len(net)>150: bad.append(f"{k}: {len(net)} caracteres")
    return len(d),bad

if __name__=="__main__":
    for p,t in (("work/resx/strings.fr.resx",FR),("work/resx/strings.resx",EN)):
        ch=patch(p,t); n,bad=check(p)
        print(f"{p}: {'modifie' if ch else 'inchange'}, {n} cles")
        for b in bad: print("   ANOMALIE",b)
        if not bad: print("   conforme")
