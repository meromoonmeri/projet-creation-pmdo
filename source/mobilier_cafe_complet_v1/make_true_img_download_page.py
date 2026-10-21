"""Génère `telecharger_objets_cafe_pmdo.html` avec UNIQUEMENT de vraies balises `<img>` RGBA transparentes
(`alpha = 0` réel, ZÉRO `<canvas>`, ZÉRO damier peint !) pour que :
1. « Clic droit -> Enregistrer l'image sous... » ou « Glisser-déposer vers le Bureau / dossier PMDO »
   enregistre DIRECTEMENT le vrai fichier PNG RGBA transparent (`alpha = 0`) au pixel exact (`1x` ou `HD`) !
2. Les liens `⬇` sur le serveur Live `:8000` (`?dl=1`) téléchargent aussi directement les `.png` et le `.zip`.

Usage : .venv/bin/python source/mobilier_cafe_complet_v1/make_true_img_download_page.py
"""
from __future__ import annotations

import base64, html
from pathlib import Path
import numpy as np
from PIL import Image

R = Path(__file__).resolve().parents[2]
DEST = R / 'livrables_pmdo_sans_fond'


def data_uri(p: Path) -> tuple[str, int, int]:
    im = Image.open(p).convert('RGBA')
    arr = np.array(im)
    # Vérification stricte : 100 % binaire alpha {0, 255} et 4 coins 100 % transparents (alpha == 0)
    assert set(np.unique(arr[..., 3])) <= {0, 255}, p
    for cy, cx in [(0, 0), (0, -1), (-1, 0), (-1, -1)]:
        assert int(arr[cy, cx, 3]) == 0, f'Coin non transparent dans {p}'
    return 'data:image/png;base64,' + base64.b64encode(p.read_bytes()).decode(), im.width, im.height


ITEMS = [
    ('01_spinda_comptoir', 'Comptoir Spinda (Bar à Jus)'),
    ('02_qulbutoke_comptoir', 'Comptoir Qulbutoké (Stand Recyclage)'),
    ('03_sucreine_comptoir', 'Comptoir Sucreine (Bar Baies & Nectars)'),
    ('04_kirlia_comptoir', 'Comptoir Kirlia (Bar Thés & Infusions)'),
    ('05_charmilly_comptoir', 'Comptoir Charmilly (Pâtisserie & Crème)'),
    ('06_estrade_rideaux_rouges', 'Grande Estrade aux Rideaux Rouges'),
    ('07_piano_cafe_bois', 'Piano Droit en Bois Miel & Velours Rouge'),
    ('08_jukebox_cafe', 'Jukebox / Phonographe Bois & Cuivre Doré'),
    ('09_table_cabaret_rouge', 'Table Ronde Cabaret Rouge'),
    ('10_banquette_velours_rouge', 'Banquette Capitonnée Velours Rouge'),
    ('11_kirlia_kiosque_guichet', 'Kiosque Kirlia à Guichet Ouvert'),
]


def main() -> None:
    cards_html = []
    for stem, title in ITEMS:
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
                <span>Arrière (Under · {wb}×{hb})</span>
                <img src="{ub}" alt="{stem}_1x_arriere.png" title="Clic droit → Enregistrer l'image sous... ({stem}_1x_arriere.png)">
                <a class="dl" href="{ub}" download="{stem}_1x_arriere.png">⬇ Arrière 1×</a>
              </div>
              <div class="mini">
                <span>Avant (Over · {wf}×{hf})</span>
                <img src="{uf}" alt="{stem}_1x_avant.png" title="Clic droit → Enregistrer l'image sous... ({stem}_1x_avant.png)">
                <a class="dl" href="{uf}" download="{stem}_1x_avant.png">⬇ Avant 1×</a>
              </div>
            </div>''')

        cards_html.append(f'''
        <article class="card">
          <div class="head">
            <strong>{html.escape(title)}</strong>
            <small>PMDO 1× : {w1}×{h1} px ({w1//8}×{h1//8} tuiles)</small>
          </div>
          <div class="stage">
            <img class="main1x" src="{u1}" width="{min(320, w1*2)}" alt="{stem}_1x_complet.png"
                 title="VRAI PNG TRANSPARENT (alpha=0) — Clic droit → Enregistrer l'image sous... ou Glisser vers le Bureau !">
          </div>
          <div class="btns">
            <a class="dl pri" href="{u1}" download="{stem}_1x_complet.png">⬇ PNG 1× PMDO ({w1}×{h1})</a>
            <a class="dl" href="{un}" download="{stem}_1x_nuit.png">⬇ 1× Nuit</a>
            <a class="dl" href="{uhd}" download="{stem}_HD_sans_fond.png">⬇ PNG HD ({whd}×{hhd})</a>
          </div>
          {''.join(sub_parts)}
          <details>
            <summary>Afficher l'image Master HD ({whd}×{hhd} px) pour Clic droit → Enregistrer sous…</summary>
            <div class="stage" style="margin-top:8px">
              <img class="hdimg" src="{uhd}" alt="{stem}_HD_sans_fond.png"
                   title="VRAI PNG HD TRANSPARENT ({whd}×{hhd}) — Clic droit → Enregistrer l'image sous...">
            </div>
          </details>
        </article>''')

    sheets_html = []
    for sp in sorted((DEST / 'tilesheets_import_pmdo_8px').glob('*.png')):
        us, ws, hs = data_uri(sp)
        sheets_html.append(f'''
        <div class="sheetbox">
          <div><strong>{html.escape(sp.name)}</strong> <small>({ws}×{hs} px · grille 8×8 · vrai alpha=0)</small>
            <a class="dl pri" href="{us}" download="{sp.name}">⬇ Télécharger la planche</a>
          </div>
          <img src="{us}" alt="{sp.name}" title="Clic droit → Enregistrer l'image sous... ({sp.name})">
        </div>''')

    page = f'''<!doctype html>
<html lang="fr">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Vrais PNG Transparents (alpha = 0, ZÉRO damier) — Prêts pour PMDO</title>
<style>
body{{background:#2b231d;color:#f5ebd9;font:15px/1.55 system-ui,sans-serif;margin:0;padding:24px}}
main{{max-width:1340px;margin:auto}}
h1{{font-size:27px;margin:0 0 8px;color:#ffd57e}}
h2{{font-size:20px;margin:24px 0 10px;color:#ffd57e}}
.tip{{background:#3b2f26;border:2px solid #9bd180;border-radius:11px;padding:15px 18px;margin-bottom:20px}}
.grid{{display:grid;grid-template-columns:repeat(auto-fill,minmax(350px,1fr));gap:16px}}
.card{{background:#362b23;border:1px solid #6b5747;border-radius:11px;padding:14px}}
.head{{display:flex;justify-content:space-between;align-items:baseline;gap:8px;margin-bottom:8px}}
.head strong{{color:#ffd57e;font-size:15.5px}}
.head small{{color:#cbbba6;white-space:nowrap}}
/* AUCUN DAMIER NULLE PART : uniquement un conteneur neutre sous de VRAIES balises <img> RGBA alpha=0 ! */
.stage{{background:transparent;border:1px dashed #6b5747;border-radius:8px;padding:12px;text-align:center;min-height:190px;display:flex;align-items:center;justify-content:center}}
img{{image-rendering:pixelated;display:inline-block;max-width:100%}}
img.hdimg{{max-height:260px;width:auto}}
.btns{{margin-top:9px}}
a.dl,button{{background:#e6dcc8;color:#231a13;border:0;border-radius:6px;padding:6px 11px;margin:3px 4px 3px 0;text-decoration:none;display:inline-block;font-weight:700;font-size:12.8px;cursor:pointer}}
a.dl.pri{{background:#9bd180;color:#13240e}}
.subrow{{display:grid;grid-template-columns:1fr 1fr;gap:8px;margin-top:10px}}
.mini{{border:1px dashed #5d4b3d;border-radius:7px;padding:8px;text-align:center}}
.mini span{{display:block;font-size:11.8px;color:#d2c3af;margin-bottom:5px}}
.mini img{{max-height:110px;width:auto;display:block;margin:0 auto 6px}}
details{{margin-top:9px;font-size:13px;color:#d7c8b4}}
summary{{cursor:pointer;color:#ffd57e}}
.sheetbox{{background:#362b23;border:1px solid #6b5747;border-radius:10px;padding:14px;margin-bottom:14px}}
.sheetbox img{{margin-top:10px;border:1px dashed #6b5747;padding:8px;border-radius:6px}}
code{{color:#c7edb4;background:#221b16;padding:1px 5px;border-radius:4px}}
</style>
<main>
<h1>Vrais PNG 100 % Transparents (<code>alpha = 0</code> réel · ZÉRO damier peint !)</h1>
<div class="tip">
  <strong style="color:#b8f09c;font-size:16px">✓ Corrigé ! Pourquoi vous aviez eu le damier avant :</strong>
  la page précédente dessinait un damier gris dans un <code>&lt;canvas&gt;</code>, donc un <em>Clic droit → Enregistrer l'image sous…</em> enregistrait les carrés gris du canvas !<br>
  <strong>Ici, chaque vignette ci-dessous est directement le VRAI fichier <code>&lt;img&gt;</code> PNG 32 bits RGBA avec <code>alpha = 0</code> réel (aucun canvas, aucun damier nulle part) :</strong>
  <ul style="margin:7px 0 0;padding-left:20px">
    <li><strong>Faites simplement Clic droit sur n'importe quelle image ci-dessous → « Enregistrer l'image sous… »</strong> (ou glissez-déposez l'image directement sur votre Bureau / dans votre dossier PMDO) : vous obtenez <strong>le vrai PNG 100 % transparent aux dimensions exactes <code>8 × 8 px</code> de PMDO</strong> !</li>
    <li>Sur l'onglet <strong>Live Preview</strong>, vous pouvez aussi télécharger l'archive complète en un clic :
      <a class="dl pri" href="livrables_pmdo_sans_fond/PACK_PMDO_1X_ET_MOD_0812_SANS_FOND.zip?dl=1" target="_blank">⬇ Télécharger le ZIP complet (36 PNG sans fond + 30 banques .tile)</a>
    </li>
  </ul>
</div>

<h2>1. Objets individuels PMDO <code>1×</code> (grille exacte <code>8 px</code>, vrai canal alpha transparent)</h2>
<div class="grid">
  {''.join(cards_html)}
</div>

<h2>2. Planches groupées <code>8 × 8 px</code> (pour importer plusieurs objets d'un coup dans PMDO Dev)</h2>
{''.join(sheets_html)}
</main>
</html>
'''
    out = R / 'telecharger_objets_cafe_pmdo.html'
    out.write_text(page)
    print(f'OK {out.name}: 100% vraies balises <img> RGBA alpha=0, 0 canvas, 0 damier ({out.stat().st_size/1e6:.2f} Mo)')


if __name__ == '__main__':
    main()
