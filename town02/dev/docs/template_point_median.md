# Point médian — template inter-donjons

> **Rien de ce document n'a été testé en jeu.** Tout ce qui suit est vérifié
> par lecture de code, compilation Lua et outils d'audit — pas par une partie.

## Principe

Le point médian est **une seule structure**, déclinée visuellement. Le joueur
doit le reconnaître immédiatement d'un donjon à l'autre, tout en le sentant
appartenir au biome qui l'accueille.

| | Où c'est défini | Varie ? |
|---|---|---|
| **Structure** | `Data/Script/halcyon/MidpointTemplate.lua` | Jamais |
| **Habillage** | table `SKIN` / `RELAY_SKIN` de chaque relais | Toujours |

## Les 4 états (squelette, non négociable)

Repris du patron d'origine du Tunnel Incandescent
(`searing_tunnel_midpoint/init.lua:159-166`).

| État | Quand | Traitement |
|---|---|---|
| `FirstArrival` | Première venue | Carton-titre, entrée en marchant, découverte, installation du camp |
| `RepeatArrival` | **Retour à l'amiable** | Court, sans carton-titre : repli volontaire ou sauvegarde reprise sur place |
| `DeathArrival` | KO au-delà du checkpoint | Réveil au sol, `EventSleep` → `Wake` décalés, l'escorte veille |
| `Rest` | Relais déjà connu | Mise en place + fondu, le joueur garde la main |

Ordre des branches identique partout — c'est ce qui garantit le même
comportement d'un donjon à l'autre.

## Fonction dans la progression (identique partout)

1. **Palier** — marque le milieu du trajet (moitié 1 / moitié 2)
2. **Pause** — rocher de Kangourex : soin, stockage, sauvegarde
3. **Repère** — carton-titre à la première venue
4. **Transition** — sortie nord = avancer, sortie sud = redescendre

## Habillage par donjon (règle de non-duplication)

Aucun couple (musique, ambiance) n'est réutilisé. Vérifié automatiquement par
`tools/verify_midpoint_template.py`.

| Donjon | Ambiance | Musique | Justification du biome |
|---|---|---|---|
| Tunnel Incandescent | `steam` | Lower Spring Cave | Poche de vapeur, chaleur volcanique |
| Mont Venteux | `blowing_wind` | Canyon Camp | Canyon coupe-vent : le calme vient des parois |
| Forêt Lugubre | `autumn_leaves` | Mystifying Forest | Le calme vient du couvert végétal |
| Aegis Cave | `mysterious_distortion` | In the Depths of the Pit | Le calme vient de la pierre taillée |
| Sanctuaire de Cristal | `winter_snow` | Snow Camp | Poussière de cristal, silence des prismes |
| Marais de l'Oubli | `mysterious_distortion` | Cave Camp | Brume au-dessus de l'eau — **musique différente** des Ruines |
| Pic Céleste | `blowing_wind_fast` | Summit | Vent d'altitude : même famille que le Mont, degré supérieur |

> Le Marais et les Ruines partagent le *nom* du MapStatus mais pas la musique
> ni le décor : la signature complète reste unique. Le Pic et le Mont utilisent
> deux variantes de vent distinctes (`_fast`), pour marquer la montée en altitude.

## Le cas « retour à l'amiable »

Deux chemins mènent au même état, tous deux armés explicitement :

- **Repli volontaire** — `South_Exit_Touch` pose le drapeau avant de partir
- **Sauvegarde reprise sur place** — `GameLoad` pose le drapeau

Drapeaux : `WindsweptMidReturn`, `GloomyMidReturn`, `RuinsMidReturn`,
`SanctuaryMidReturn`, `MarshMidReturn`, `PeakMidReturn` (déclarés dans
`scriptvars.lua`).

**Garde-fou.** Le drapeau est consommé dès la lecture (une scène par retour, pas
une par rechargement de carte), et le Mont vérifie en plus
`HasPendingScene()` : un simple retour ne doit jamais escamoter une
cinématique de progression (Fragment tombé du ciel, dernière veillée).

## Contraintes moteur respectées

- `GAME:FadeOut` est **bloquant** (`ScriptGame.cs:1590`) et rend la main à chaque
  frame (`FadeEffect.cs:30-42`) : tout appel avant le premier fondu laisse passer
  des frames rendues sur une carte non montée. D'où le `FadeOut(false,1)` en tête
  de chaque scène — no-op sur écran déjà noir (`FadeEffect.cs:63-64`).
- `GROUND:AddMapStatus` et `BossFX.Particle` échouent **en silence** sur un nom
  absent. Les MapStatus réellement présents sont les 10 de `Data/MapStatus/` ;
  l'outil de vérification refuse tout nom fantôme.
- Reprise de main systématiquement via `GeneralFunctions.RendreLaMain()`
  (fondu court), jamais en plan fixe.

## Vérification

```bash
python3 tools/verify_midpoint_template.py .
```

Contrôle les 3 règles du brief : reconnaissabilité (même structure), intégration
(habillage déclaré), non-duplication (aucune signature partagée), plus la
détection des MapStatus fantômes.
