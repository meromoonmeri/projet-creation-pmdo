# Matrice scène par scène PMD Red EU → New Era

Chaque ligne possède **exactement une classe principale**. Les indicateurs secondaires décrivent les domaines à conserver, porter ou adapter sans concurrencer cette décision principale. Priorité de décision : route New Era active → `CONFLIT`; module EU absent → `PORTÉ`; autorité EU non fermée → `DÉPENDANCE`; sinon module présent mais fidélité non démontrée → `ADAPTÉ`. Aucune scène n’est globalement `CONSERVÉ`.

Les comptages source couvrent toutes les branches déclarées; ils ne sont pas une durée linéaire. `EU exact` signifie que le graphe et les blocs français ont été décodés depuis la ROM EU. `Dépendance décodeur` interdit l’implémentation avant fermeture régionale.

| ID | Type | Classe principale | Autorité | New Era | Route | FR EU / FR exécuté | Déplacements | Anim./rot. | Cam./VFX | Audio | Timing/logique | Indicateurs secondaires |
|---|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| `t00p01` | base/ville | **ADAPTÉ** | EU exact | module squelette/adapté | non | 207 / 0 | 0 / 0 | 21 / 0 | 2 / 0 | 1 / 1 | 94 / 3 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `t01p01` | base/ville | **CONFLIT** | Dépendance décodeur | wrapper central | oui | ? / 0 | 202 / 2 | 1801 / 0 | 57 / 3 | 209 / 1 | 5095 / 5 | ADAPTÉ + DÉPENDANCE + PORTÉ |
| `t01p02a` | base/ville | **ADAPTÉ** | EU exact | module squelette/adapté | non | 269 / 0 | 28 / 0 | 183 / 0 | 12 / 4 | 27 / 10 | 569 / 267 | DÉPENDANCE + PORTÉ |
| `t01p03` | base/ville | **ADAPTÉ** | EU exact | module squelette/adapté | non | 242 / 0 | 17 / 0 | 309 / 0 | 12 / 1 | 54 / 9 | 763 / 222 | DÉPENDANCE + PORTÉ |
| `t01p04` | base/ville | **ADAPTÉ** | EU exact | module squelette/adapté | non | 10 / 0 | 2 / 0 | 18 / 0 | 1 / 1 | 6 / 6 | 47 / 10 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `t01p05` | base/ville | **ADAPTÉ** | EU exact | module squelette/adapté | non | 3 / 0 | 0 / 0 | 15 / 0 | 0 / 1 | 6 / 6 | 51 / 3 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `t01p07` | base/ville | **ADAPTÉ** | EU exact | module squelette/adapté | non | 0 / 0 | 0 / 0 | 4 / 0 | 2 / 0 | 2 / 2 | 13 / 0 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `b01p01a` | base/ville | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 191 / 0 | 1102 / 0 | 80 / 45 | 315 / 129 | 5210 / 927 | ADAPTÉ + PORTÉ |
| `b01p02a` | base/ville | **ADAPTÉ** | EU exact | module squelette/adapté | non | 240 / 0 | 19 / 0 | 81 / 0 | 50 / 5 | 98 / 46 | 721 / 172 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `h01p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 12 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h01p02` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h01p03` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h02p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h02p02` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h02p03` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h03p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h04p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h04p02` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h05p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h05p02` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h06p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h06p02` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h06p03` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h06p04` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h06p05` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h06p06` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h07p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h07p02` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h07p03` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h07p04` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h07p05` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 18 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h07p06` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h07p07` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h07p08` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h08p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h09p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h09p02` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h10p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h10p02` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h11p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h12p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h13p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h13p02` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h13p03` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h13p04` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h14p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h15p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h16p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h17p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h18p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h19p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h20p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h21p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h21p02` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h22p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h23p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h24p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h25p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h26p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h27p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h28p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h28p02` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h29p01` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 19 / 0 | 27 / 0 | 7 / 7 | 16 / 3 | 148 / 14 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h29p02` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h29p03` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `h29p04` | Friend Area | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 4 / 0 | 0 / 0 | 1 / 1 | 20 / 0 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `a01p01` | arc | **ADAPTÉ** | EU exact | module squelette/adapté | non | 197 / 0 | 0 / 0 | 156 / 0 | 19 / 16 | 24 / 15 | 285 / 197 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `a01p02` | arc | **ADAPTÉ** | EU exact | module squelette/adapté | non | 95 / 0 | 0 / 0 | 4 / 0 | 5 / 4 | 6 / 3 | 25 / 66 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `a02p01` | arc | **CONFLIT** | EU exact | wrapper central | oui | 5 / 0 | 0 / 4 | 2 / 2 | 3 / 3 | 1 / 1 | 9 / 6 | ADAPTÉ + DÉPENDANCE + PORTÉ |
| `a02p02` | arc | **CONFLIT** | EU exact | wrapper central | oui | 7 / 0 | 2 / 4 | 4 / 0 | 1 / 3 | 2 / 1 | 19 / 3 | ADAPTÉ + DÉPENDANCE + PORTÉ |
| `a02p03` | arc | **CONFLIT** | EU exact | wrapper central | oui | 16 / 0 | 2 / 4 | 14 / 0 | 2 / 3 | 5 / 1 | 38 / 3 | ADAPTÉ + CONSERVÉ + DÉPENDANCE + PORTÉ |
| `a02p04` | arc | **CONFLIT** | EU exact | wrapper central | oui | 92 / 0 | 7 / 4 | 12 / 0 | 2 / 3 | 4 / 1 | 151 / 3 | ADAPTÉ + DÉPENDANCE + PORTÉ |
| `a03p01` | arc | **CONFLIT** | EU exact | wrapper central | oui | 30 / 0 | 0 / 4 | 34 / 0 | 2 / 3 | 5 / 1 | 103 / 6 | ADAPTÉ + DÉPENDANCE + PORTÉ |
| `a03p02` | arc | **CONFLIT** | EU exact | wrapper central | oui | 2 / 0 | 0 / 4 | 2 / 0 | 1 / 3 | 1 / 1 | 5 / 3 | ADAPTÉ + CONSERVÉ + DÉPENDANCE + PORTÉ |
| `a03p03` | arc | **CONFLIT** | EU exact | wrapper central | oui | 113 / 0 | 0 / 4 | 30 / 2 | 18 / 3 | 10 / 1 | 142 / 14 | ADAPTÉ + DÉPENDANCE + PORTÉ |
| `a04p01` | arc | **CONFLIT** | EU exact | wrapper central | oui | 163 / 0 | 42 / 1 | 214 / 0 | 10 / 3 | 24 / 1 | 985 / 3 | ADAPTÉ + DÉPENDANCE + PORTÉ |
| `a04p02` | arc | **ADAPTÉ** | EU exact | module squelette/adapté | non | 1 / 0 | 0 / 0 | 0 / 0 | 1 / 0 | 1 / 1 | 6 / 1 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `a04p03` | arc | **ADAPTÉ** | EU exact | module squelette/adapté | non | 0 / 0 | 1 / 0 | 0 / 0 | 9 / 6 | 7 / 3 | 19 / 0 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `a04p04` | arc | **ADAPTÉ** | EU exact | module squelette/adapté | non | 32 / 0 | 1 / 0 | 14 / 0 | 5 / 5 | 4 / 1 | 54 / 30 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `a05p01` | arc | **ADAPTÉ** | EU exact | module squelette/adapté | non | 14 / 0 | 0 / 0 | 0 / 0 | 6 / 4 | 2 / 2 | 20 / 11 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `a05p02` | arc | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 0 / 0 | 0 / 0 | 4 / 4 | 1 / 1 | 39 / 5 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `a05p03` | arc | **CONFLIT** | EU exact | wrapper central | oui | 9 / 0 | 0 / 2 | 0 / 0 | 1 / 3 | 0 / 1 | 8 / 3 | ADAPTÉ + CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d01p01` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 109 / 0 | 25 / 0 | 53 / 0 | 3 / 3 | 42 / 8 | 265 / 66 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d01p02` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 8 / 0 | 2 / 0 | 4 / 0 | 1 / 0 | 3 / 1 | 25 / 6 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d02p01` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 10 / 0 | 12 / 0 | 48 / 0 | 4 / 1 | 3 / 3 | 136 / 10 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d02p02` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 2 / 0 | 4 / 0 | 6 / 0 | 2 / 2 | 2 / 2 | 10 / 1 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d03p01` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 15 / 0 | 8 / 0 | 24 / 0 | 2 / 0 | 8 / 4 | 77 / 10 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d03p02` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 22 / 0 | 10 / 0 | 19 / 0 | 1 / 0 | 5 / 1 | 69 / 12 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d04p01` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 18 / 0 | 4 / 0 | 6 / 0 | 2 / 0 | 2 / 2 | 31 / 2 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d04p02` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 11 / 0 | 4 / 0 | 24 / 0 | 1 / 0 | 6 / 1 | 59 / 9 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d05p01` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 69 / 0 | 3 / 0 | 28 / 0 | 1 / 0 | 10 / 1 | 171 / 38 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d05p02` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 28 / 0 | 0 / 0 | 30 / 0 | 19 / 19 | 10 / 3 | 95 / 25 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d06p01` | donjon/Ground | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 8 / 0 | 11 / 0 | 2 / 0 | 2 / 2 | 51 / 5 | ADAPTÉ + CONSERVÉ + PORTÉ |
| `d06p02` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 9 / 0 | 0 / 0 | 4 / 0 | 1 / 2 | 4 / 4 | 36 / 2 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d06p03` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 65 / 0 | 7 / 0 | 46 / 0 | 1 / 1 | 14 / 9 | 261 / 56 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d07p01` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 14 / 0 | 9 / 0 | 8 / 0 | 2 / 0 | 2 / 2 | 34 / 4 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d07p02` | donjon/Ground | **DÉPENDANCE** | Dépendance décodeur | module squelette/adapté | non | ? / 0 | 23 / 0 | 79 / 0 | 6 / 3 | 36 / 9 | 366 / 105 | ADAPTÉ + PORTÉ |
| `d08p01` | donjon/Ground | **CONFLIT** | EU exact | wrapper central | oui | 61 / 0 | 8 / 4 | 23 / 0 | 6 / 3 | 13 / 1 | 158 / 6 | ADAPTÉ + DÉPENDANCE + PORTÉ |
| `d08p02` | donjon/Ground | **CONFLIT** | EU exact | wrapper central | oui | 11 / 0 | 2 / 4 | 8 / 0 | 1 / 3 | 2 / 1 | 30 / 3 | ADAPTÉ + DÉPENDANCE + PORTÉ |
| `d09p01` | donjon/Ground | **CONFLIT** | EU exact | wrapper central | oui | 69 / 0 | 18 / 4 | 28 / 0 | 6 / 3 | 12 / 1 | 182 / 6 | ADAPTÉ + DÉPENDANCE + PORTÉ |
| `d09p02` | donjon/Ground | **CONFLIT** | EU exact | wrapper central | oui | 10 / 0 | 0 / 2 | 5 / 0 | 1 / 3 | 4 / 1 | 40 / 3 | ADAPTÉ + DÉPENDANCE + PORTÉ |
| `d09p03` | donjon/Ground | **CONFLIT** | EU exact | wrapper central | oui | 85 / 0 | 2 / 4 | 13 / 0 | 9 / 4 | 14 / 1 | 168 / 7 | ADAPTÉ + DÉPENDANCE + PORTÉ |
| `d10p01` | donjon/Ground | **CONFLIT** | EU exact | wrapper central | oui | 56 / 0 | 0 / 4 | 24 / 0 | 11 / 3 | 13 / 1 | 163 / 6 | ADAPTÉ + DÉPENDANCE + PORTÉ |
| `d10p02` | donjon/Ground | **CONFLIT** | EU exact | wrapper central | oui | 19 / 0 | 0 / 2 | 8 / 0 | 2 / 3 | 5 / 1 | 67 / 3 | ADAPTÉ + DÉPENDANCE + PORTÉ |
| `d10p03` | donjon/Ground | **CONFLIT** | EU exact | wrapper central | oui | 79 / 0 | 0 / 2 | 23 / 0 | 15 / 3 | 21 / 1 | 158 / 4 | ADAPTÉ + DÉPENDANCE + PORTÉ |
| `d11p01` | donjon/Ground | **CONFLIT** | EU exact | wrapper central | oui | 90 / 0 | 2 / 4 | 26 / 0 | 12 / 3 | 13 / 1 | 223 / 6 | ADAPTÉ + DÉPENDANCE + PORTÉ |
| `d11p02` | donjon/Ground | **CONFLIT** | EU exact | wrapper central | oui | 11 / 0 | 0 / 2 | 5 / 0 | 1 / 3 | 4 / 1 | 51 / 3 | ADAPTÉ + CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d11p03` | donjon/Ground | **CONFLIT** | EU exact | wrapper central | oui | 171 / 0 | 15 / 2 | 136 / 0 | 15 / 3 | 33 / 1 | 440 / 8 | ADAPTÉ + DÉPENDANCE + PORTÉ |
| `d12p01` | donjon/Ground | **CONFLIT** | Dépendance décodeur | wrapper central | oui | ? / 0 | 8 / 4 | 12 / 0 | 2 / 3 | 3 / 1 | 51 / 6 | ADAPTÉ + CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d12p02` | donjon/Ground | **CONFLIT** | EU exact | wrapper central | oui | 8 / 0 | 0 / 2 | 4 / 0 | 1 / 3 | 4 / 1 | 35 / 3 | ADAPTÉ + CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d12p04` | donjon/Ground | **CONFLIT** | EU exact | wrapper central | oui | 16 / 0 | 1 / 2 | 29 / 0 | 5 / 3 | 10 / 1 | 116 / 4 | ADAPTÉ + DÉPENDANCE + PORTÉ |
| `d13p01` | donjon/Ground | **CONFLIT** | Dépendance décodeur | wrapper central | oui | ? / 0 | 6 / 4 | 29 / 0 | 3 / 3 | 11 / 1 | 100 / 6 | ADAPTÉ + DÉPENDANCE + PORTÉ |
| `d13p02` | donjon/Ground | **CONFLIT** | EU exact | wrapper central | oui | 9 / 0 | 0 / 2 | 4 / 0 | 1 / 3 | 4 / 1 | 36 / 3 | ADAPTÉ + CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d13p03` | donjon/Ground | **CONFLIT** | EU exact | wrapper central | oui | 31 / 0 | 0 / 2 | 25 / 0 | 16 / 3 | 20 / 1 | 144 / 4 | ADAPTÉ + DÉPENDANCE + PORTÉ |
| `d14p01` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 0 / 0 | 0 / 0 | 2 / 0 | 1 / 0 | 1 / 1 | 3 / 0 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d15p01` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 16 / 0 | 0 / 0 | 2 / 0 | 1 / 0 | 5 / 1 | 5 / 16 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d16p01` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 15 / 0 | 1 / 0 | 9 / 0 | 10 / 10 | 22 / 4 | 58 / 15 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d17p01` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 16 / 0 | 1 / 0 | 8 / 0 | 10 / 10 | 26 / 4 | 58 / 16 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d18p01` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 19 / 0 | 1 / 0 | 10 / 0 | 10 / 10 | 22 / 4 | 58 / 19 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d19p01` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 19 / 0 | 0 / 0 | 2 / 0 | 1 / 0 | 1 / 1 | 3 / 19 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d20p01` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 34 / 0 | 9 / 0 | 26 / 0 | 10 / 11 | 34 / 5 | 99 / 34 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d21p01` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 4 / 0 | 1 / 0 | 6 / 0 | 3 / 3 | 9 / 3 | 26 / 5 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d22p01` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 5 / 0 | 3 / 0 | 5 / 0 | 2 / 2 | 3 / 1 | 36 / 5 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d23p01` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 2 / 0 | 4 / 0 | 5 / 0 | 2 / 2 | 2 / 2 | 10 / 1 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d24p01` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 80 / 0 | 5 / 0 | 33 / 0 | 15 / 14 | 34 / 5 | 176 / 82 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d24p02` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 2 / 0 | 0 / 0 | 3 / 0 | 1 / 0 | 1 / 1 | 11 / 2 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `d25p01` | donjon/Ground | **ADAPTÉ** | EU exact | module squelette/adapté | non | 2 / 0 | 4 / 0 | 5 / 0 | 2 / 2 | 2 / 2 | 10 / 1 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `s01` | base/ville | **ADAPTÉ** | EU exact | module squelette/adapté | non | 6 / 0 | 0 / 0 | 0 / 0 | 1 / 1 | 2 / 2 | 0 / 6 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `s02` | base/ville | **ADAPTÉ** | EU exact | module squelette/adapté | non | 0 / 0 | 6 / 0 | 5 / 0 | 4 / 2 | 4 / 4 | 28 / 0 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `s03` | base/ville | **ADAPTÉ** | EU exact | module squelette/adapté | non | 0 / 0 | 1 / 0 | 8 / 0 | 2 / 1 | 1 / 1 | 12 / 0 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `s04` | base/ville | **ADAPTÉ** | EU exact | module squelette/adapté | non | 0 / 0 | 3 / 0 | 0 / 0 | 1 / 0 | 0 / 0 | 23 / 0 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `s05` | base/ville | **ADAPTÉ** | EU exact | module squelette/adapté | non | 0 / 0 | 2 / 0 | 0 / 0 | 1 / 0 | 0 / 0 | 7 / 0 | CONSERVÉ + DÉPENDANCE + PORTÉ |
| `s06` | base/ville | **PORTÉ** | EU exact | absent | non | 0 / 0 | 0 / 0 | 0 / 0 | 1 / 0 | 0 / 0 | 0 / 0 | CONSERVÉ + DÉPENDANCE |
