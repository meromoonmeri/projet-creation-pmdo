# EAD2 — correction immersive du 16 octobre 2026

## Demande

La « map avec la grotte de fond » est rejetée : trop petite, pas assez immersive.
Priorité donnée à sa correction, avant de continuer les autres cartes.

## Réalisé

- Nouvelle génération avec la référence D14P12A fournie au générateur, prompt exact conservé.
- Environnement plein cadre : très grandes masses latérales, voûte coupée en haut, premier plan large,
  sol et silhouettes dessinés à l'intérieur ; suppression du petit décor ovale sur fond uni de la V1.
- Pas d'agrandissement arbitraire : nouveau layout normalisé à 768×576, même grille 8 px.
- Sol support réutilisé de la V1 du même biome, copié sans modification. Sol visible issu de la V2.
- Sept calques + Top vide, poussière 24×5 ticks, profondeur dessinée et non aplat de remplacement.
- Marqueurs : arrivée `[384,560]`, seuil `[400,224]`. Passage 16×16 vérifié, aucun warp.
- Fidélité sortie (seuil 35) : sol **5,63**, roche **7,37**. Mesure de couleur uniquement.
- **8 tests PASS**, dont 3 mutations rejetées (pixel, marqueur, animation).
- **30 images reconstruites exactement depuis le Ground et les banques .tile**.
- Contrôle spécifique : plus de 380 px de sol praticable sur la rangée de premier plan contrôlée ;
  profondeur contenant de nombreux tons et détails, pas un aplat.
- **16 tests historiques EDR1 repassés**, lot précédent non modifié.
- ZIP PMDO, ZIP calques/ORA et aperçu HTML autonome construits ; serveur de session sur 8001.

## Non validé

Approbation artistique : **en attente de l'utilisateur**. Chargement réel, éditeur, rendu et
échelle/déplacement dans PMDO : **non testés**. Les contrôles Python ne les remplacent pas.
La grande façade peut encore nécessiter un ajustement de caméra/échelle après un essai en jeu.

## Lots provisoires conservés

EAD1 reste l'essai rejeté. FDR1 a été construit avant le retour utilisateur, mais ses tests et
son paquet ne sont pas terminés : il n'est pas déclaré livré. La priorité est EAD2.
