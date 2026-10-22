# Carapagos — portraits générés individuellement V3

**Nouvelles propositions : Happy, Angry, Sad, Shouting, Surprised.** Normal est conservé octet pour octet depuis SpriteCollab. Les cinq nouvelles images ne sont pas les petites retouches V2 ; chaque expression a sa génération propre, guidée par le portrait Normal agrandi sans interpolation.

## Format et fonds

- Portraits individuels40×40 RGBA entièrement opaques.
- Palette choisie explicitement par rôle : ombres du masque, blues, blanc d'œil, couleurs chaudes de la bouche lorsque nécessaire. Un premier essai median-cut a été rejeté parce qu'il transformait la langue rose en gris-bleu.
- Les fonds viennent des cellules **Happy1, Angry3, Sad5, Shouting7, Surprised12** de `template.png` fourni par l'utilisateur. Aucun de leurs pixels n'est recoloré, aucun fond n'est régénéré. Tous les pixels visibles du fond sont vérifiés égaux à ceux du template. Les quatre couleurs du fond Angry/Surprised sont prises en compte dans la limite totale15.
- Retouches pixel de sourcils Angry/Sad après inspection, définies dans le script. Les autres dessins gardent les expressions issues du générateur, la sélection de palette et le nettoyage ; ne pas prétendre qu'ils ont tous été redessinés entièrement à la main.
- Sujets transparents et fonds opaques séparés dans `exports/pokemon_custom/tirtouga_portraits_v3/editable/`, pour poursuivre la retouche sans écraser les fonds.
- Planche SpriteCollab **200×160** à emplacements standards ; toutes les cases manquantes sont entièrement transparentes. Pas de faux remplissage des émotions restantes.

Minimum technique PASS. Niveau complet FAIL attendu : **Pain, Worried, Crying, Teary-Eyed, Determined, Joyous, Inspired, Dizzy, Sigh, Stunned** manquent. Ce lot est une proposition visuelle partielle, pas une planche complète approuvée ou un personnage importé.

## Validation utilisateur reçue

Le16septembre2026, l'utilisateur a explicitement validé ces portraits. Ils sont **déjà sur les fonds canoniques** ; aucun fond supplémentaire n'est nécessaire. Les fichiers approuvés et leur Normal conservé sont identifiés dans `approval.json`. Ne pas les régénérer/modifier sans nouvelle demande. Cette validation utilisateur est distincte d'une approbation du dépôt public SpriteCollab et ne remplit pas les dix cases d'émotion encore absentes.
