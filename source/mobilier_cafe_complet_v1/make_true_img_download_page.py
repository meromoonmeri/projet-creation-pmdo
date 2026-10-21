"""Génère `telecharger_objets_cafe_pmdo.html` avec UNIQUEMENT de vraies balises `<img>` RGBA transparentes
(`alpha = 0` réel, ZÉRO `<canvas>`, ZÉRO damier peint !) :
1. Section 1 en tête : la nouvelle Scène & Rideaux au motif **Spinda Troubadour** cohérente à la POV 3/4 de dessus
   des salles existantes (`SpindaV7_cafe`, `salon_haut`, `salon_bas`, `casino`) + démonstration directe en salle !
2. Section 2 : tous les comptoirs & meubles Café / Cabaret sans fond (`alpha = 0` réel).
3. Section 3 : toutes les planches groupées `8 × 8 px` prêtes pour PMDO Dev.

Usage : .venv/bin/python source/mobilier_cafe_complet_v1/make_true_img_download_page.py
"""
from __future__ import annotations

import base64, html
from pathlib import Path
import numpy as np
from PIL import Image

R = Path(__file__).resolve().parents[2]
DEST = R / 'livrables_pmdo_sans_fond'
KMC_APERCUS = R / 'renders/mobilier_cafe_complet_v1/apercus'


def data_uri(p: Path, require_alpha_zero: bool = True) -> tuple[str, int, int]:
    im = Image.open(p)
    if require_alpha_zero:
        im = im.convert('RGBA')
        arr = np.array(im)
        assert set(np.unique(arr[..., 3])) <= {0, 255}, p
        for cy, cx in [(0, 0), (0, -1), (-1, 0), (-1, -1)]:
            assert int(arr[cy, cx, 3]) == 0, f'Coin non transparent dans {p}'
    return 'data:image/png;base64,' + base64.b64encode(p.read_bytes()).decode(), im.width, im.height


SCENE_ITEMS = [
    ('06a_estrade_spinda_troubadour', 'Scène Ouverte Complète — Estrade POV 3/4 + Arche Rideaux Spinda Troubadour'),
    ('06b_estrade_plateau_spinda', 'Plateau d’Estrade Seul — Bois Miel & Spirale Spinda (POV 3/4 Salles)'),
    ('06c_rideau_gauche_spinda_troubadour', 'Rideau de Scène GAUCHE Seul — Motif Spinda Troubadour'),
    ('06d_rideau_droit_spinda_troubadour', 'Rideau de Scène DROIT Seul — Motif Spinda Troubadour (Asymétrique)'),
    ('06e_lambrequin_arche_spinda_troubadour', 'Grande Arche Supérieure Ouverte Seule — Spinda Troubadour (Over)'),
    ('06f_estrade_fond_ferme_spinda_troubadour', 'Variante Scène avec Fond Rideau Rouge Drapé — Spinda Troubadour'),
]

CAFE_ITEMS = [
    ('01_spinda_comptoir', 'Comptoir Spinda (Bar à Jus)'),
    ('02_qulbutoke_comptoir', 'Comptoir Qulbutoké (Stand Recyclage)'),
    ('03_sucreine_comptoir', 'Comptoir Sucreine (Bar Baies & Nectars)'),
    ('04_kirlia_comptoir', 'Comptoir Kirlia (Bar Thés & Infusions)'),
    ('05_charmilly_comptoir', 'Comptoir Charmilly (Pâtisserie & Crème)'),
    ('07_piano_cafe_bois', 'Piano Droit en Bois Miel & Velours Rouge'),
    ('08_jukebox_cafe', 'Jukebox / Phonographe Bois & Cuivre Doré'),
    ('09_table_cabaret_rouge', 'Table Ronde Cabaret Rouge'),
    ('10_banquette_velours_rouge', 'Banquette Capitonnée Velours Rouge'),
    ('11_kirlia_kiosque_guichet', 'Kiosque Kirlia à Guichet Ouvert'),
]


def render_cards(item_list: list[tuple[str, str]]) -> str:
    out = []
    for stem, title in item_list:
        p_1x = DEST / f'1x_PMDO_8px_sans_fond/{stem}_1x_complet.png'
        p_nuit = DEST / f'1x_PMDO_8px_sans_fond/{stem}_1x_nuit.png'
        p_back = DEST / f'1x_PMDO_8px_sans_fond/{stem}_1x_arriere.png'
        p_front = DEST / f'1x_PMDO_8px_sans_fond/{stem}_1x_avant.png'
        p_hd = DEST / f'HD_sans_fond/{stem}_HD_sans_fond.png'

        u1, w1, h1 = data_uri(p_1x)
        un, _, _ = data_uri(p_nuit)
        uhd, whd, hhd = data_uri(p_hd)

        sub_parts = []
        if p_back.exists() and p_front.exists():
            ub, wb, hb = data_uri(p_back)
            uf, wf, hf = data_uri(p_front)
            sub_parts.append(f'''
            <div class="subrow">
              <div class="mini">
                <span>Arrière · Under ({wb}×{hb})</span>
                <img src="{ub}" alt="{stem}_1x_arriere.png" title="VRAI PNG TRANSPARENT (alpha=0) — Clic droit → Enregistrer l'image sous...">
                <a class="dl" href="{ub}" download="{stem}_1x_arriere.png">⬇ Arrière 1×</a>
              </div>
              <div class="mini">
                <span>Avant · Over ({wf}×{hf})</span>
                <img src="{uf}" alt="{stem}_1x_avant.png" title="VRAI PNG TRANSPARENT (alpha=0) — Clic droit → Enregistrer l'image sous...">
                <a class="dl" href="{uf}" download="{stem}_1x_avant.png">⬇ Avant 1×</a>
              </div>
            </div>''')

        out.append(f'''
        <article class="card">
          <div class="head">
            <strong>{html.escape(title)}</strong>
            <small>1× : {w1}×{h1} px ({w1//8}×{h1//8} tuiles)</small>
          </div>
          <div class="stage">
            <img class="main1x" src="{u1}" width="{min(336, w1*2)}" alt="{stem}_1x_complet.png"
                 title="VRAI PNG TRANSPARENT 32 BITS RGBA (alpha=0) — Clic droit → Enregistrer l'image sous... ou Glisser vers le Bureau !">
          </div>
          <div class="btns">
            <a class="dl pri" href="{u1}" download="{stem}_1x_complet.png">⬇ PNG 1× PMDO ({w1}×{h1})</a>
            <a class="dl" href="{un}" download="{stem}_1x_nuit.png">⬇ 1× Nuit</a>
            <a class="dl" href="{uhd}" download="{stem}_HD_sans_fond.png">⬇ PNG HD ({whd}×{hhd})</a>
          </div>
          {''.join(sub_parts)}
          <details>
            <summary>Afficher le Master HD sans fond ({whd}×{hhd} px) pour Clic droit → Enregistrer sous…</summary>
            <div class="stage" style="margin-top:8px">
              <img class="hdimg" src="{uhd}" alt="{stem}_HD_sans_fond.png"
                   title="VRAI PNG HD TRANSPARENT ({whd}×{hhd}) — Clic droit → Enregistrer l'image sous...">
            </div>
          </details>
        </article>''')
    return ''.join(out)


def main() -> None:
    d1, dw1, dh1 = data_uri(KMC_APERCUS / 'Demo_POV_Salle_Cafe_SpindaV7_Arche_Ouverte.png', require_alpha_zero=False)
    d2, dw2, dh2 = data_uri(KMC_APERCUS / 'Demo_POV_Salle_Salon_Haut_SpindaV7_2_Rideaux.png', require_alpha_zero=False)

    sheets_html = []
    for sp in sorted((DEST / 'tilesheets_import_pmdo_8px').glob('*.png')):
        us, ws, hs = data_uri(sp)
        sheets_html.append(f'''
        <div class="sheetbox">
          <div><strong>{html.escape(sp.name)}</strong> <small>({ws}×{hs} px · grille 8×8 · vrai alpha=0)</small>
            <a class="dl pri" href="{us}" download="{sp.name}">⬇ Télécharger la planche</a>
          </div>
          <img src="{us}" alt="{sp.name}" title="VRAI PNG TRANSPARENT (alpha=0) — Clic droit → Enregistrer l'image sous... ({sp.name})">
        </div>''')

    page = f'''<!doctype html>
<html lang="fr">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Scène &amp; Rideaux Spinda Troubadour (POV Salles Existantes) + Tous les PNG 100 % Transparents PMDO</title>
<style>
body{{background:#2b231d;color:#f5ebd9;font:15px/1.55 system-ui,sans-serif;margin:0;padding:24px}}
main{{max-width:1360px;margin:auto}}
h1{{font-size:27px;margin:0 0 8px;color:#ffd57e}}
h2{{font-size:20px;margin:26px 0 10px;color:#ffd57e}}
.tip{{background:#3b2f26;border:2px solid #9bd180;border-radius:11px;padding:15px 18px;margin-bottom:20px}}
.demorow{{display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-bottom:18px}}
.demobox{{background:#362b23;border:1px solid #6b5747;border-radius:10px;padding:12px;text-align:center}}
.demobox img{{max-width:100%;height:auto;border-radius:6px;image-rendering:pixelated;margin-top:8px}}
.grid{{display:grid;grid-template-columns:repeat(auto-fill,minmax(350px,1fr));gap:16px}}
.card{{background:#362b23;border:1px solid #6b5747;border-radius:11px;padding:14px}}
.head{{display:flex;justify-content:space-between;align-items:baseline;gap:8px;margin-bottom:8px}}
.head strong{{color:#ffd57e;font-size:15px}}
.head small{{color:#cbbba6;white-space:nowrap}}
/* ZÉRO DAMIER NULLE PART : uniquement de VRAIES balises <img> 32 bits RGBA (alpha = 0) ! */
.stage{{background:transparent;border:1px dashed #6b5747;border-radius:8px;padding:12px;text-align:center;min-height:190px;display:flex;align-items:center;justify-content:center}}
img{{image-rendering:pixelated;display:inline-block;max-width:100%}}
img.hdimg{{max-height:260px;width:auto}}
.btns{{margin-top:9px}}
a.dl{{background:#e6dcc8;color:#231a13;border:0;border-radius:6px;padding:6px 11px;margin:3px 4px 3px 0;text-decoration:none;display:inline-block;font-weight:700;font-size:12.6px;cursor:pointer}}
a.dl.pri{{background:#9bd180;color:#13240e}}
.subrow{{display:grid;grid-template-columns:1fr 1fr;gap:8px;margin-top:10px}}
.mini{{border:1px dashed #5d4b3d;border-radius:7px;padding:8px;text-align:center}}
.mini span{{display:block;font-size:11.8px;color:#d2c3af;margin-bottom:5px}}
.mini img{{max-height:112px;width:auto;display:block;margin:0 auto 6px}}
details{{margin-top:9px;font-size:13px;color:#d7c8b4}}
summary{{cursor:pointer;color:#ffd57e}}
.sheetbox{{background:#362b23;border:1px solid #6b5747;border-radius:10px;padding:14px;margin-bottom:14px}}
.sheetbox img{{margin-top:10px;border:1px dashed #6b5747;padding:8px;border-radius:6px}}
code{{color:#c7edb4;background:#221b16;padding:1px 5px;border-radius:4px}}
</style>
<main>
<h1>Scène &amp; Rideaux au Motif Spinda Troubadour (POV 3/4 Salles Existantes) — Vrais PNG Transparents (<code>alpha = 0</code>)</h1>
<div class="tip">
  <strong style="color:#b8f09c;font-size:16px">✓ Nouveaux assets générés &amp; 100 % vrais <code>&lt;img&gt;</code> transparents (aucun canvas, aucun damier peint !) :</strong>
  <ul style="margin:7px 0 0;padding-left:20px">
    <li><strong>POV cohérente aux salles <code>SpindaV7</code> :</strong> plancher d'estrade profond en bois miel vu de dessus (~50° orthogonal PMDO) avec <strong>médaillon spirale Spinda incrusté</strong> et escalier central bas + <strong>rideaux ouverts à motifs spirales/pois Spinda, fanions cyan/or <code>ruban_spinda</code> et embrasses dorées de troubadour</strong> !</li>
    <li><strong>Faites Clic droit → « Enregistrer l'image sous… » (ou glissez sur votre Bureau) sur n'importe quel objet ci-dessous :</strong> chaque vignette de carte est directement le vrai PNG 32 bits <code>RGBA</code> <code>alpha = 0</code> aux dimensions exactes <code>8 × 8 px</code> de PMDO !</li>
    <li>Sur l'onglet <strong>Live Preview (<code>:8000</code>)</strong> :
      <a class="dl pri" href="livrables_pmdo_sans_fond/PACK_PMDO_1X_ET_MOD_0812_SANS_FOND.zip?dl=1" target="_blank">⬇ Télécharger TOUT le Pack PMDO (.ZIP — 16 objets sans fond + 8 planches + 36 banques .tile)</a>
      <a class="dl" href="apercu_mobilier_cafe_complet_v1.html" target="_blank">Ouvrir l'éditeur interactif en direct dans les salles SpindaV7</a>
    </li>
  </ul>
</div>

<h2>Contrôle direct de cohérence POV <code>1×</code> dans vos salles existantes (démonstration non cuite — maps intactes)</h2>
<div class="demorow">
  <div class="demobox">
    <strong>Salle <code>SpindaV7_cafe</code> (600×448) — Scène ouverte <code>06a_estrade_spinda_troubadour</code> posée au Nord</strong>
    <img src="{d1}" width="{dw1}" height="{dh1}" alt="Demo_POV_Salle_Cafe_SpindaV7">
  </div>
  <div class="demobox">
    <strong>Salle <code>SpindaV7_salon_haut</code> (600×448) — Plateau <code>06b</code> + Rideaux Gauche <code>06c</code> &amp; Droit <code>06d</code> séparés</strong>
    <img src="{d2}" width="{dw2}" height="{dh2}" alt="Demo_POV_Salle_Salon_Haut_SpindaV7">
  </div>
</div>

<h2>1. Estrade &amp; Rideaux Motif Spinda Troubadour — Vrais PNG <code>RGBA</code> <code>alpha = 0</code> (Clic droit → Enregistrer sous…)</h2>
<div class="grid">
  {render_cards(SCENE_ITEMS)}
</div>

<h2>2. Comptoirs &amp; Mobilier Café / Cabaret — Vrais PNG <code>RGBA</code> <code>alpha = 0</code> (Clic droit → Enregistrer sous…)</h2>
<div class="grid">
  {render_cards(CAFE_ITEMS)}
</div>

<h2>3. Planches groupées <code>8 × 8 px</code> sans fond (Import direct dans PMDO Dev)</h2>
{''.join(sheets_html)}
</main>
</html>
'''
    out = R / 'telecharger_objets_cafe_pmdo.html'
    out.write_text(page)
    print(f'OK {out.name}: 100% vraies balises <img>, 0 canvas, 0 damier ({out.stat().st_size/1e6:.2f} Mo)')


if __name__ == '__main__':
    main()
