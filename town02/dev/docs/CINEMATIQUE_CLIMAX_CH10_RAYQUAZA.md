# Spécification Narrative : Le Climax du Chapitre 10 — L'Autel des Cieux & Rayquaza
## Adaptation de la Séquence de la Météorite de PMD Red & Clins d'Œil à l'Équipe de Secours d'Origine

Ce document certifie la direction artistique, les beats de mise en scène et la justification scénaristique pour le climax monumental du Chapitre 10 de *New Era: Abyss to Ascension*.

---

## 1. Justification Scénaristique : L'Histoire se Répète
Il y a 30 ans, le monde fut sauvé de la collision avec l'Étoile de la Destruction (la Météorite) grâce à l'intervention héroïque d'un humain transformé en Pokémon et de son partenaire, qui bravèrent la **Tour Céleste** pour convaincre **Rayquaza** de pulvériser le corps céleste d'un Ultralaser.

Aujourd'hui, alors que les perturbations de l'Abîme atteignent leur paroxysme au Chapitre 10, **un résidu de cette même météorite géante** (qui était resté en orbite instable ou a été réveillé par les distorsions cosmiques) menace de s'écraser à nouveau sur la région, plongeant Metano Town dans une panique absolue.

Les protagonistes de *New Era* escaladent la Tour Céleste (ou son équivalent Peak) pour trouver le Gardien des Cieux. Mais Rayquaza, irrité par les troubles magnétiques et climatiques, est dans une rage folle et refuse de les écouter, croyant que les mortels sont responsables du chaos.

---

## 2. Découpage Cinématique Beat-par-Beat (Post-Combat)

Après un duel dantesque où les protagonistes surmontent la puissance du dragon céleste, la cinématique finale s'enclenche :

### Acte I : Le Clin d'Œil à l'Équipe de Secours d'Origine
*   **Visuel** : Rayquaza, blessé et haletant (`GROUND:CharSetAnim(rayquaza, "Pain", true)`), recule de quelques pas. Le vent souffle violemment.
*   **Dialogue (Clin d'œil)** : Rayquaza regarde le Héros dans les yeux. Il est saisi de stupeur en voyant l'étincelle de détermination indomptable qui brille dans son regard.
    *   *Rayquaza* : *"Cet éclat... Cette lueur de détermination indomptable dans tes yeux...[pause=20] Je l'ai déjà vue."*
    *   *Rayquaza* : *"Il y a trente ans... Un autre humain transformé en Pokémon, accompagné d'un partenaire d'un courage sans pareil, s'est tenu exactement là où vous vous tenez. Ils m'ont défié sur cet autel pour prouver leur valeur, puis m'ont supplié de détruire l'étoile de la destruction..."*
    *   *Partenaire* : *"L'Équipe de Secours légendaire du grand cataclysme d'il y a trente ans ?!"*
    *   *Rayquaza* : *"Oui... Vous possédez la même étincelle indomptable. L'héritage de ces sauveurs légendaires coule dans vos veines."*

### Acte II : Le Retour de la Menace Cosmique
*   **Visuel** : Soudain, un tremblement de terre violent secoue l'autel (`SOUND:PlaySE("DUN_Earthquake_Loop")`). Le ciel vire au rouge sang dans un grondement terrifiant.
*   **Dialogue** : Le partenaire regarde vers le ciel et hurle d'effroi. Une météorite géante, incandescente, déchire la haute atmosphère et fond sur la planète.
    *   *Rayquaza* : *"La menace de jadis renaît, réveillée par les perturbations de l'Abîme ! Le résidu de l'étoile est de retour... Mais tant que je serai le Gardien des Cieux, la terre ne sera pas consumée une seconde fois !"*

### Acte III : La Destruction de la Météorite (Cinématique PMD Red)
*   **VFX & Animations** : Rayquaza rassemble ses forces. Il s'entoure d'une aura dorée et d'électricité statique (`SOUND:PlaySE("DUN_Stat_Up")`), puis s'élance à une vitesse fulgurante vers la haute atmosphère, perçant les nuages.
*   **Climax** : Rayquaza ouvre la gueule et charge un **Ultralaser (Hyper Beam)** colossal. Un énorme flash blanc aveugle l'écran, accompagné du bruitage mythique de l'explosion du jeu d'origine (`SOUND:PlaySE("DUN_Explosion")`).
*   **Résolution** : Le flash s'estompe. La météorite a été réduite en poussière cosmique. Le ciel s'illumine d'une pluie de millions d'étoiles filantes scintillantes d'un calme absolu. Le partenaire s'exclame devant la beauté de cette pluie de météores inoffensifs.

### Acte IV : Le Piège se referme (Déclenchement de la Fuite)
*   **Le drame** : Mais à cause de l'onde de choc dévastatrice qui secoue toute la vallée en contrebas, Rayquaza donne un avertissement funeste aux héros :
    *   *Rayquaza* : *"Fuyez, jeunes héros... La tempête géomagnétique arrive. Les humains et les Pokémon de la vallée ne comprendront pas votre triomphe. Ils croiront que votre combat sur mon autel a provoqué la colère divine. Ils vous traqueront comme des fugitifs."*
*   **Bascule** : Cette prédiction s'avère tristement exacte. La Fédération de Metano Town interprète l'explosion céleste comme un sacrilège commis par les héros. Le Chapitre 10 se referme sur cette tragédie, ouvrant le **Chapitre 11 (L'Arc Fugitif)** alors que les héros doivent fuir sous la pluie, traqués par leurs anciens amis.

---

## 3. Fichiers et Clés de Dialogue Associés
*   **Fichier Script** : `Data/Script/halcyon/ground/autel_celeste/init.lua`
*   **Fichier Textes FR** : `Data/Script/halcyon/ground/autel_celeste/strings.fr.resx`
*   **Clés de dialogues implémentées** :
    *   `CPB_004` à `CPB_009` : Le duel terminé et le clin d'œil à l'Équipe de Secours.
    *   `CPB_010` à `CPB_012` : L'apparition de la météorite et la résolution de Rayquaza.
    *   `CPB_013` à `CPB_014` : L'envol de Rayquaza et le tir d'Ultralaser détruisant l'étoile.
    *   `CPB_015` à `CPB_017` : La beauté des météores, le grondement sismique sur Metano Town et l'avertissement de fuite.
