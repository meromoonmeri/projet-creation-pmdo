# Eau générée des anciens essais — rejetée

Les deux essais d’eau générée enregistrés précédemment pour FVF1 et EVF1 ont été rejetés. Ils ne sont **pas** utilisés dans le build, dans les calques, dans les scènes, dans les aperçus ni comme source de pixels. Les images correspondantes `FVF1_water_fill_generated.png` et `EVF1_water_fill_generated.png` ont été retirées.

Le rendu final de l’eau utilise exclusivement les quatre frames natives Metano Town River de `source/eau_metano/`, recadrées dans une fenêtre native contiguë 1:1 propre à chaque biome, puis découpées par le masque magenta d’origine. Voir `source/vallons_fleuris_v1/README.md` et les manifestes générés pour la provenance complète, les coordonnées de crop et le traitement des pixels transparents.
