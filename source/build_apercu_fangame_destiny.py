#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Génère `apercu_fangame_pmd_destiny.html` : Cinématique d'Opening **100 % POV Map PMD 3/4**
(`320 × 240` natif PMDO `×3 = 960 × 720` pixel-perfect) + **Sprites PMD Multi-Poses 8 Directions**
suivant plan par plan le schéma & la musique de `Simple and Clean -Ray of Hope MIX-` (`2aafI3XvKxo`) :

  1. **Cohérence totale POV & échelle PMD (`Explorers of Sky` / PMDO `0.8.12.0`)** :
     5 Maps d'Opening en vue 3/4 top-down pixel-art (`576 × 320` = `72 × 40` tuiles `8×8`, `<= 96` couleurs)
     parcourues par une vraie caméra PMDO `320 × 240` (`GAME:MoveCamera`, zoom, shake, hit-stop, fondus).
  2. **Vraie animation multi-poses 8 directions (`PMDCollab` `AnimData.xml`)** :
     Chaque geste (`Walk`, `Hop`, `LeapForth`, `Pull`, `Pose`, `DeepBreath`, `TumbleBack`, `Float`,
     `Rotate`, `Strike`, `QuickStrike`, `Double`, `Swing`, `RearUp`, `Shoot`, `Hurt`, `HitGround`,
     `Pain`, `Twirl`, `Sink`, `Wake`, `LookUp`) est enchaîné logiquement sur les dalles et l'eau miroir,
     avec reflets inversés dans l'eau, ondes de pas, arcs de mêlée pixel-art et boîtes de portraits PMDO.
  3. **Image & Logo plein centre `(W/2, H/2)` (`(160, 120)` sur `320×240`) + Battement subtil des 2 ailes**
     à l'arrivée unique du blason Œuf Ailé, sur fonds **Jour** et **Nuit** séparés (`.dir` 24 poses).
  4. **Double synchro musicale** : lecteur officiel **YouTube IFrame API (`2aafI3XvKxo`, `02:33`)** +
     **synthétiseur polyphonique WebAudio `128 BPM` *Ray of Hope*** intégré (`00:56`) + fichier audio local.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent


def _vurl(rel_path: str) -> str:
    clean = "/" + rel_path.lstrip("/")
    p = REPO_ROOT / clean.lstrip("/")
    if not p.is_file():
        return clean
    h = hashlib.sha256(p.read_bytes()).hexdigest()[:10]
    return f"{clean}?v={h}"


def build_destiny_html() -> str:
    manifest_p = REPO_ROOT / "renders" / "pmd_destiny_fangame_v1" / "opening_assets" / "manifest.json"
    manifest = json.loads(manifest_p.read_text(encoding="utf-8"))
    pmd_cat = manifest["pmd_catalog"]

    # Ajout de cache-busting sur chaque feuille de sprite et portrait
    base_sp = "renders/pmd_destiny_fangame_v1/opening_assets/pmd_sprites"
    for pid, pdata in pmd_cat["pokemon"].items():
        for aname, ainfo in pdata["anims"].items():
            ainfo["url"] = _vurl(f"{base_sp}/{ainfo['file']}")
        pt_urls = {}
        for emo, rel_f in pdata.get("portraits", {}).items():
            pt_urls[emo] = _vurl(f"{base_sp}/{rel_f}")
        pdata["portraitUrls"] = pt_urls

    credits_list = []
    for item in pmd_cat.get("credits_summary", []):
        if item.get("authors"):
            credits_list.append(f"{item['name']} ({', '.join(item['authors'][:4])})")
    credits_html = " · ".join(credits_list)

    pmd_cat_json = json.dumps(pmd_cat["pokemon"], ensure_ascii=False)

    day_atlas_url = _vurl(".cache/studio_layers/DST_MENU_DUAL/BG_Jour_320x240_atlas_6x4.png")
    night_atlas_url = _vurl(".cache/studio_layers/DST_MENU_DUAL/BG_Nuit_320x240_atlas_6x4.png")
    enter_url = _vurl(".cache/studio_layers/DST_MENU_DUAL/Enter_74x11.png")
    logo_hd_url = _vurl(".cache/studio_layers/DST_MENU_DUAL/Logo_PMD_Destiny_Oeuf_Ailes_HD.png")

    rig_lw_url = _vurl("renders/pmd_destiny_fangame_v1/apercus_menu/logo_rig_left_wing.png")
    rig_rw_url = _vurl("renders/pmd_destiny_fangame_v1/apercus_menu/logo_rig_right_wing.png")
    rig_core_url = _vurl("renders/pmd_destiny_fangame_v1/apercus_menu/logo_rig_core_body.png")

    opm1_url = _vurl("renders/pmd_destiny_fangame_v1/opening_assets/maps/opm1_plage_cristal.png")
    opm2_url = _vurl("renders/pmd_destiny_fangame_v1/opening_assets/maps/opm2_abysse_vitrail.png")
    opm3_url = _vurl("renders/pmd_destiny_fangame_v1/opening_assets/maps/opm3_arene_eau_miroir.png")
    opm4_url = _vurl("renders/pmd_destiny_fangame_v1/opening_assets/maps/opm4_ciel_astral.png")
    opm5_url = _vurl("renders/pmd_destiny_fangame_v1/opening_assets/maps/opm5_falaise_promontoire.png")

    vitrail_dais_url = _vurl("renders/pmd_destiny_fangame_v1/opening_assets/vitrail_dais_pmd_pixel.png")
    wf_cyan_url = _vurl("renders/pmd_destiny_fangame_v1/opening_assets/wayfinder_cyan.png")
    wf_emerald_url = _vurl("renders/pmd_destiny_fangame_v1/opening_assets/wayfinder_emerald.png")
    wf_amber_url = _vurl("renders/pmd_destiny_fangame_v1/opening_assets/wayfinder_amber.png")

    scr_jour_320 = _vurl("renders/pmd_destiny_fangame_v1/apercus_menu/ecran_titre_jour_320x240.png")
    scr_nuit_320 = _vurl("renders/pmd_destiny_fangame_v1/apercus_menu/ecran_titre_nuit_320x240.png")
    planche_maps = _vurl("renders/pmd_destiny_fangame_v1/apercus_menu/planche_4_maps_opening_pmd_320x240.png")

    pack_zip_url = "/.cache/virtual_zips/PACK_MENU_ET_BASE_PMD_DESTINY_0.8.12.zip"
    dstj_zip_url = "/.cache/virtual_zips/DSTJ_PMDO_0.8.12.zip"
    dstn_zip_url = "/.cache/virtual_zips/DSTN_PMDO_0.8.12.zip"

    return f"""<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Pokémon Mystery Dungeon : Destiny — Cinématique POV Map PMD 3/4 « Ray of Hope MIX », Logo Centré &amp; Ailes</title>
  <style>
    :root {{
      --bg: #050b1a;
      --panel: #0c1732;
      --panel-2: #132349;
      --border: #284785;
      --gold: #fbbf24;
      --gold-soft: #fde68a;
      --cyan: #38bdf8;
      --text: #eef5ff;
      --muted: #9db6e0;
    }}
    * {{ box-sizing: border-box; }}
    body {{
      margin: 0;
      font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif;
      background:
        radial-gradient(circle at 50% 10%, rgba(56, 189, 248, 0.15) 0%, transparent 48%),
        radial-gradient(circle at 50% 0%, #132859 0%, var(--bg) 68%);
      color: var(--text);
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
    }}
    header {{
      width: 100%;
      padding: 13px 22px;
      border-bottom: 1px solid var(--border);
      background: rgba(6, 12, 28, 0.94);
      display: flex;
      flex-wrap: wrap;
      align-items: center;
      justify-content: center;
      gap: 16px;
      text-align: center;
    }}
    header h1 {{
      margin: 0;
      font-size: 1.13rem;
      color: var(--gold-soft);
    }}
    header .sub {{
      font-size: 0.80rem;
      color: var(--muted);
      margin-top: 3px;
    }}
    .nav-links {{
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 8px;
    }}
    .btn-link {{
      text-decoration: none;
      padding: 7px 12px;
      border-radius: 8px;
      font-size: 0.80rem;
      font-weight: 600;
      border: 1px solid var(--border);
      background: var(--panel-2);
      color: var(--text);
    }}
    .btn-link:hover {{ border-color: var(--cyan); }}
    .btn-link.gold {{
      background: linear-gradient(180deg, #f59e0b, #d97706);
      border-color: #fde68a;
      color: #160d00;
    }}

    main {{
      width: 100%;
      max-width: 980px;
      margin: 0 auto;
      padding: 18px 14px 44px;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 18px;
    }}
    .cinema-card {{
      width: 100%;
      background: linear-gradient(180deg, rgba(14, 27, 58, 0.96), rgba(8, 16, 36, 0.98));
      border: 1px solid var(--border);
      border-radius: 18px;
      padding: 16px;
      box-shadow: 0 22px 58px rgba(0, 0, 0, 0.65);
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 12px;
    }}
    .top-bar {{
      width: 100%;
      display: flex;
      flex-wrap: wrap;
      align-items: center;
      justify-content: center;
      gap: 7px;
    }}
    button.ctrl {{
      cursor: pointer;
      padding: 7px 13px;
      border-radius: 9px;
      border: 1px solid var(--border);
      background: var(--panel-2);
      color: var(--text);
      font-weight: 600;
      font-size: 0.80rem;
      transition: all 0.12s ease;
    }}
    button.ctrl:hover {{ border-color: var(--cyan); background: #1a3163; }}
    button.ctrl.active {{
      border-color: var(--gold);
      background: linear-gradient(180deg, #27488a, #193161);
      color: var(--gold-soft);
    }}
    button.ctrl.primary {{
      background: linear-gradient(180deg, #38bdf8, #0284c7);
      border-color: #bae6fd;
      color: #041326;
      font-weight: 700;
    }}
    button.ctrl.yt-btn {{
      background: linear-gradient(180deg, #f43f5e, #be123c);
      border-color: #fecdd3;
      color: #fff;
      font-weight: 700;
    }}

    /* Écran PMDO 320x240 (x3 = 768x576 / max 800px) 100 % centré au milieu de la page */
    .stage-frame {{
      position: relative;
      width: 100%;
      max-width: 780px;
      margin: 0 auto;
      border-radius: 12px;
      overflow: hidden;
      border: 2px solid #3964b3;
      background: #020612;
      box-shadow: 0 14px 40px rgba(0, 0, 0, 0.72), 0 0 28px rgba(56, 189, 248, 0.14);
      display: flex;
      align-items: center;
      justify-content: center;
    }}
    canvas#destinyStage {{
      display: block;
      width: 100%;
      height: auto;
      margin: 0 auto;
      image-rendering: pixelated;
      image-rendering: crisp-edges;
    }}

    .timeline-wrap {{
      width: 100%;
      max-width: 820px;
      display: flex;
      flex-direction: column;
      gap: 6px;
    }}
    .scrubber-row {{
      display: flex;
      align-items: center;
      gap: 10px;
    }}
    input[type="range"]#timeScrub {{
      flex: 1;
      accent-color: var(--cyan);
      cursor: pointer;
    }}
    .time-readout {{
      font-family: ui-monospace, SFMono-Regular, Menlo, monospace;
      font-size: 0.79rem;
      color: var(--gold-soft);
      min-width: 106px;
      text-align: right;
    }}
    .chapters {{
      display: grid;
      grid-template-columns: repeat(6, minmax(0, 1fr));
      gap: 5px;
    }}
    @media (max-width: 760px) {{
      .chapters {{ grid-template-columns: repeat(3, minmax(0, 1fr)); }}
    }}
    .chap-btn {{
      cursor: pointer;
      padding: 6px 5px;
      border-radius: 7px;
      border: 1px solid #243f74;
      background: rgba(12, 24, 52, 0.88);
      color: var(--muted);
      font-size: 0.71rem;
      text-align: center;
    }}
    .chap-btn:hover {{ border-color: var(--cyan); color: var(--text); }}
    .chap-btn.current {{
      border-color: var(--gold);
      background: rgba(39, 72, 138, 0.68);
      color: var(--gold-soft);
      font-weight: 700;
    }}

    .audio-dock {{
      width: 100%;
      max-width: 820px;
      display: grid;
      grid-template-columns: 1fr auto;
      gap: 12px;
      align-items: center;
      background: rgba(7, 14, 32, 0.88);
      border: 1px solid #244075;
      border-radius: 12px;
      padding: 11px 13px;
    }}
    @media (max-width: 720px) {{
      .audio-dock {{ grid-template-columns: 1fr; justify-items: center; text-align: center; }}
    }}
    .audio-info {{ font-size: 0.79rem; line-height: 1.46; color: var(--muted); }}
    .audio-info strong {{ color: var(--text); }}
    .yt-mini-box {{
      width: 240px;
      height: 135px;
      border-radius: 8px;
      overflow: hidden;
      border: 1px solid #35599e;
      background: #02050d;
      display: flex;
      align-items: center;
      justify-content: center;
    }}
    .yt-mini-placeholder {{
      font-size: 0.71rem;
      color: var(--muted);
      padding: 8px;
      text-align: center;
    }}

    .status-strip {{
      width: 100%;
      max-width: 820px;
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 7px;
    }}
    .pill {{
      font-size: 0.74rem;
      padding: 4px 10px;
      border-radius: 999px;
      background: rgba(15, 29, 64, 0.9);
      border: 1px solid var(--border);
      color: var(--muted);
    }}
    .pill strong {{ color: var(--gold-soft); }}

    .details-grid {{
      width: 100%;
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 16px;
    }}
    @media (max-width: 800px) {{
      .details-grid {{ grid-template-columns: 1fr; }}
    }}
    .info-card {{
      background: rgba(12, 23, 50, 0.94);
      border: 1px solid var(--border);
      border-radius: 14px;
      padding: 15px;
    }}
    .info-card h2 {{
      margin: 0 0 9px 0;
      font-size: 0.94rem;
      color: var(--gold-soft);
      border-bottom: 1px solid rgba(56, 189, 248, 0.22);
      padding-bottom: 6px;
      text-align: center;
    }}
    .info-card img.full {{
      width: 100%;
      border-radius: 8px;
      border: 1px solid #315496;
      image-rendering: pixelated;
    }}
    .preview-pair {{
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px;
      margin-top: 10px;
    }}
    .preview-pair figure {{ margin: 0; text-align: center; }}
    .preview-pair img {{
      width: 100%;
      border-radius: 8px;
      border: 1px solid #315496;
      image-rendering: pixelated;
    }}
    .preview-pair figcaption {{ margin-top: 4px; font-size: 0.73rem; color: var(--muted); }}
    ul.spec {{
      margin: 0;
      padding-left: 17px;
      font-size: 0.79rem;
      line-height: 1.5;
      color: var(--muted);
    }}
    ul.spec li {{ margin-bottom: 5px; }}
    code {{
      background: rgba(4, 9, 24, 0.82);
      padding: 1px 5px;
      border-radius: 4px;
      color: #bae6fd;
      font-size: 0.75rem;
    }}
  </style>
</head>
<body>
  <header>
    <div>
      <h1>Pokémon Mystery Dungeon : Destiny — Cinématique POV Map PMD 3/4 « Ray of Hope MIX »</h1>
      <div class="sub">5 Maps d'Opening PMD en vue 3/4 Pixel-Art (<code>320×240</code> caméra PMDO) · Sprites Multi-Poses 8 Directions · Mêlée <code>128 BPM</code> · Logo plein centre &amp; Ailes animées</div>
    </div>
    <div class="nav-links">
      <a class="btn-link" href="/index.html">← Galerie Studio (39 cartes)</a>
      <a class="btn-link" href="{dstj_zip_url}">⬇ Carte Jour (DSTJ)</a>
      <a class="btn-link" href="{dstn_zip_url}">⬇ Carte Nuit (DSTN)</a>
      <a class="btn-link gold" href="{pack_zip_url}">⬇ Pack Fangame Destiny (.zip)</a>
    </div>
  </header>

  <main>
    <section class="cinema-card">
      <div class="top-bar">
        <button class="ctrl primary" id="btnPlayCinema">▶ Relancer la Cinématique PMD (Synthé 128 BPM)</button>
        <button class="ctrl yt-btn" id="btnPlayYT">▶ Synchro YouTube Officielle (2aafI3XvKxo · 02:33)</button>
        <button class="ctrl" id="btnModeTitle">🎮 Écran-Titre PMDO Direct</button>
        <button class="ctrl" id="btnFlapNow">🪽 Battre des ailes</button>
        <button class="ctrl active" id="btnThemeDay">☀️ Jour</button>
        <button class="ctrl" id="btnThemeNight">🌙 Nuit</button>
        <button class="ctrl" id="btnPause">⏸ Pause</button>
      </div>

      <!-- Écran natif PMDO 320x240 x3 = 960x720 (4:3 cohérent de bout en bout, centré plein milieu) -->
      <div class="stage-frame">
        <canvas id="destinyStage" width="960" height="720"></canvas>
      </div>

      <div class="timeline-wrap">
        <div class="scrubber-row">
          <input type="range" id="timeScrub" min="0" max="1000" value="0" />
          <div class="time-readout" id="timeReadout">00:00 / 00:56</div>
        </div>
        <div class="chapters">
          <button class="chap-btn current" data-jump="0.00">I · OPM1 Plage &amp; Patte</button>
          <button class="chap-btn" data-jump="0.15">II · OPM2 Abysse &amp; Vitrail</button>
          <button class="chap-btn" data-jump="0.31">III · OPM3 Eau-Miroir</button>
          <button class="chap-btn" data-jump="0.40">IV · Mêlée 128 BPM &amp; Trio</button>
          <button class="chap-btn" data-jump="0.67">V · OPM4 Ciel &amp; Darkrai</button>
          <button class="chap-btn" data-jump="0.83">VI · OPM5 Falaise → Titre</button>
        </div>
      </div>

      <div class="audio-dock">
        <div class="audio-info">
          <div><strong id="audioModeLabel">🎹 Audio actif : Synthé WebAudio « Ray of Hope » 128 BPM intégré (Coupe PMD 00:56)</strong></div>
          <div style="margin-top:4px;">
            • <strong>« Synchro YouTube Officielle (2aafI3XvKxo · 02:33) »</strong> cale toutes les maps PMD, les déplacements, la mêlée et l'arrivée du logo sur l'horloge exacte de la vidéo YouTube officielle.<br/>
            • Ou importez un audio local :
            <label style="cursor:pointer;color:var(--cyan);font-weight:600;text-decoration:underline;">
              📂 Charger MP3/WAV<input type="file" id="localAudioInput" accept="audio/*" style="display:none;" />
            </label>
            · <label style="cursor:pointer;"><input type="checkbox" id="chkMuteSynth" /> Couper synthé</label>
            · <label style="cursor:pointer;"><input type="checkbox" id="chkCenterCrosshair" /> Axe centre <code>(160, 120)</code></label>
          </div>
        </div>
        <div class="yt-mini-box">
          <div class="yt-mini-placeholder" id="ytPlaceholder">
            Lecteur YouTube <code>2aafI3XvKxo</code><br/>(cliquez sur le bouton rouge ci-dessus)
          </div>
          <div id="ytPlayerSlot"></div>
        </div>
      </div>

      <div class="status-strip">
        <span class="pill">Map PMD active : <strong id="lblMap">OPM1 · Plage Cristal (576×320)</strong></span>
        <span class="pill">Caméra PMDO : <strong id="lblCam">320×240</strong></span>
        <span class="pill">Centre Logo : <strong id="lblCenter">(160, 120) = 50% × 50%</strong></span>
        <span class="pill">2 Ailes : <strong id="lblWingDeg">0.0°</strong></span>
      </div>
    </section>

    <section class="details-grid">
      <div class="info-card">
        <h2>Cohérence POV 3/4 Map PMD &amp; Échelle Sprites (<code>320×240</code>)</h2>
        <img class="full" src="{planche_maps}" alt="Planche des Maps d'Opening PMD 3/4" />
        <div class="preview-pair">
          <figure>
            <img src="{scr_jour_320}" alt="Écran-Titre Jour 320x240" />
            <figcaption><code>320×240</code> JOUR — Logo centré <code>(160, 120)</code></figcaption>
          </figure>
          <figure>
            <img src="{scr_nuit_320}" alt="Écran-Titre Nuit 320x240" />
            <figcaption><code>320×240</code> NUIT — Logo centré <code>(160, 120)</code></figcaption>
          </figure>
        </div>
      </div>

      <div class="info-card">
        <h2>Architecture des 5 Maps Opening PMD &amp; Crédits Sprites</h2>
        <ul class="spec">
          <li><strong>POV 100 % Map PMD 3/4 Orthographique (<code>576×320</code> = <code>72×40</code> tuiles <code>8×8</code>, <code>&lt;= 96</code> couleurs)</strong> :
            <code>OPM1</code> Plage Cristal &amp; Lagon · <code>OPM2</code> Temple Marin Abyssal &amp; Rosace Vitrail 3/4 incrustée dans la pierre ·
            <code>OPM3</code> Arène Eau-Miroir à 16 piliers runiques · <code>OPM4</code> Plateforme Mosaïque Astrale · <code>OPM5</code> Promontoire Fleuri &amp; Océan.</li>
          <li><strong>Vraie Mêlée &amp; Gestes Liés sur les Tuiles (<code>AnimData.xml</code> 8 directions)</strong> :
            Chaque déplacement calcule automatiquement l'orientation <code>Dir8 (0..7)</code>, projette le reflet inversé ondulant dans l'eau miroir,
            génère des ondes de pas pixel-art et synchronise <code>Strike</code>, <code>QuickStrike</code>, <code>Double</code>, <code>Swing</code>,
            <code>Hop</code>, <code>TumbleBack</code>, <code>Pain</code>, <code>RearUp</code>, <code>Pull</code> et <code>Pose</code> avec <em>hit-stop</em> et <em>camera shake</em>.</li>
          <li><strong>Arrivée Centrée &amp; Battement Subtil des 2 Ailes</strong> :
            Panoramique caméra vertical depuis l'océan d'<code>OPM5</code> vers le fond <code>.dir</code> Jour/Nuit *PMD Sky*, impact unique plein centre
            <code>(160, 120)</code> et oscillation amortie des deux ailes (<code>logo_rig_left_wing.png</code> / <code>right_wing.png</code>).</li>
          <li><strong>Crédits Sprites &amp; Portraits (<code>PMDCollab / SpriteCollab</code>, CC-BY)</strong> :
            {credits_html}. Audio officiel lu via YouTube IFrame API (<code>2aafI3XvKxo</code>) sans copie de piste protégée dans le dépôt.</li>
        </ul>
      </div>
    </section>
  </main>

  <audio id="localAudioEl" preload="auto" style="display:none;"></audio>

  <script>
  (() => {{
    const PMD_CATALOG = {pmd_cat_json};

    const outCanvas = document.getElementById('destinyStage');
    const outCtx = outCanvas.getContext('2d');
    outCtx.imageSmoothingEnabled = false;

    // Framebuffer virtuel natif PMDO 320 x 240 !
    const VW = 320, VH = 240;
    const vCanvas = document.createElement('canvas');
    vCanvas.width = VW;
    vCanvas.height = VH;
    const vCtx = vCanvas.getContext('2d');
    vCtx.imageSmoothingEnabled = false;

    // Tampon monde 576 x 320 pour composer la map PMD active + reflets d'eau + sprites Y-triés + VFX pixel
    const MW = 576, MH = 320;
    const mCanvas = document.createElement('canvas');
    mCanvas.width = MW;
    mCanvas.height = MH;
    const mCtx = mCanvas.getContext('2d');
    mCtx.imageSmoothingEnabled = false;

    // Tampon d'inversion/ondulation pour les reflets dans l'eau miroir
    const refCanvas = document.createElement('canvas');
    refCanvas.width = 160;
    refCanvas.height = 160;
    const refCtx = refCanvas.getContext('2d');
    refCtx.imageSmoothingEnabled = false;

    // Tampons HD pour le blason articulé 3 pièces (battement subtil des deux ailes)
    const rigCanvas = document.createElement('canvas');
    rigCanvas.width = 872;
    rigCanvas.height = 629;
    const rigCtx = rigCanvas.getContext('2d');

    const tintCanvas = document.createElement('canvas');
    tintCanvas.width = 872;
    tintCanvas.height = 629;
    const tintCtx = tintCanvas.getContext('2d');

    const IMG_CACHE = new Map();
    function getImg(url) {{
      if (!url) return null;
      if (IMG_CACHE.has(url)) return IMG_CACHE.get(url);
      const im = new Image();
      im.decoding = 'async';
      im.src = url;
      IMG_CACHE.set(url, im);
      return im;
    }}

    // Préchargement immédiat des maps PMD 3/4, fonds .dir, rig d'ailes et feuilles de sprites
    const MAPS = {{
      opm1: getImg("{opm1_url}"),
      opm2: getImg("{opm2_url}"),
      opm3: getImg("{opm3_url}"),
      opm4: getImg("{opm4_url}"),
      opm5: getImg("{opm5_url}"),
      vitrailDais: getImg("{vitrail_dais_url}"),
      wfCyan: getImg("{wf_cyan_url}"),
      wfEmerald: getImg("{wf_emerald_url}"),
      wfAmber: getImg("{wf_amber_url}"),
      dayAtlas: getImg("{day_atlas_url}"),
      nightAtlas: getImg("{night_atlas_url}"),
      enterUI: getImg("{enter_url}"),
      logoHD: getImg("{logo_hd_url}"),
      rigLW: getImg("{rig_lw_url}"),
      rigRW: getImg("{rig_rw_url}"),
      rigCore: getImg("{rig_core_url}"),
    }};

    Object.values(PMD_CATALOG).forEach((p) => {{
      Object.values(p.anims).forEach((a) => getImg(a.url));
      Object.values(p.portraitUrls || {{}}).forEach((u) => getImg(u));
    }});

    // État global
    let viewMode = 'opening';       // 'opening' | 'title320'
    let theme = 'jour';             // 'jour' | 'nuit'
    let audioSource = 'synth';      // 'synth' (56s) | 'youtube' (153s) | 'local'
    let durationSec = 56.0;
    let curTime = 0.0;
    let paused = false;
    let scrubbing = false;
    let lastNow = performance.now();
    let manualFlapStart = -999.0;
    let titleModeRevealStart = 0.0;

    // Bulles pixel-art persistantes (coordonnées écran 320x240)
    const PIXEL_BUBBLES = Array.from({{ length: 72 }}, (_, i) => ({{
      x: (i * 47 + 13) % VW,
      yOff: ((i * 61 + 7) % 100) / 100.0,
      r: 1 + (i % 4) + (i % 13 === 0 ? 2 : 0),
      spd: 0.14 + (i % 6) * 0.045,
      wob: 2.5 + (i % 5) * 1.4,
      ph: i * 1.37,
    }}));

    // =========================================================================
    // SYNTHÉTISEUR WEBAUDIO POLYPHONIQUE 128 BPM « RAY OF HOPE »
    // =========================================================================
    let audioCtx = null;
    let synthStepPlayed = -1;
    const BPM = 128.0;
    const STEP_SEC = (60.0 / BPM) / 2.0;

    function m2f(m) {{ return 440.0 * Math.pow(2.0, (m - 69.0) / 12.0); }}

    const CHORDS = [
      [53, 60, 64, 69],
      [55, 62, 67, 71],
      [52, 59, 64, 67],
      [57, 64, 67, 72],
      [50, 57, 62, 65],
      [55, 59, 62, 67],
      [48, 55, 60, 64],
      [52, 59, 64, 71],
    ];
    const MELODY_DROP = [
      76, 79, 81, 79, 76, 74, 72, 74,
      76, 79, 84, 83, 81, 79, 76, 74,
      72, 74, 76, 79, 81, 84, 83, 79,
      76, 74, 72, 71, 72, 76, 79, 84,
    ];

    function ensureAudioCtx() {{
      if (!audioCtx) {{
        const AC = window.AudioContext || window.webkitAudioContext;
        if (AC) audioCtx = new AC();
      }}
      if (audioCtx && audioCtx.state === 'suspended') audioCtx.resume();
    }}

    function playNote(freq, dur, gainVal, type = 'triangle', cutoff = 3200) {{
      if (!audioCtx || document.getElementById('chkMuteSynth').checked) return;
      const now = audioCtx.currentTime;
      const o1 = audioCtx.createOscillator();
      const o2 = audioCtx.createOscillator();
      const flt = audioCtx.createBiquadFilter();
      const g = audioCtx.createGain();
      o1.type = type;
      o2.type = 'sine';
      o1.frequency.setValueAtTime(freq, now);
      o2.frequency.setValueAtTime(freq * 2.0, now);
      flt.type = 'lowpass';
      flt.frequency.setValueAtTime(cutoff, now);
      flt.frequency.exponentialRampToValueAtTime(Math.max(260, cutoff * 0.3), now + dur);
      g.gain.setValueAtTime(0.0001, now);
      g.gain.linearRampToValueAtTime(gainVal, now + 0.01);
      g.gain.exponentialRampToValueAtTime(0.0001, now + dur);
      o1.connect(flt); o2.connect(flt); flt.connect(g); g.connect(audioCtx.destination);
      o1.start(now); o2.start(now);
      o1.stop(now + dur + 0.02); o2.stop(now + dur + 0.02);
    }}

    function playSupersaw(notes, dur, gainVal) {{
      if (!audioCtx || document.getElementById('chkMuteSynth').checked) return;
      const now = audioCtx.currentTime;
      const flt = audioCtx.createBiquadFilter();
      flt.type = 'lowpass';
      flt.frequency.setValueAtTime(4200, now);
      const g = audioCtx.createGain();
      g.gain.setValueAtTime(0.0001, now);
      g.gain.linearRampToValueAtTime(gainVal, now + 0.02);
      g.gain.exponentialRampToValueAtTime(0.0001, now + dur);
      flt.connect(g); g.connect(audioCtx.destination);
      notes.forEach((m) => {{
        [-8, 0, +8].forEach((det) => {{
          const o = audioCtx.createOscillator();
          o.type = 'sawtooth';
          o.frequency.setValueAtTime(m2f(m), now);
          o.detune.setValueAtTime(det, now);
          o.connect(flt);
          o.start(now);
          o.stop(now + dur + 0.03);
        }});
      }});
    }}

    function playKick(gainVal = 0.15) {{
      if (!audioCtx || document.getElementById('chkMuteSynth').checked) return;
      const now = audioCtx.currentTime;
      const o = audioCtx.createOscillator();
      const g = audioCtx.createGain();
      o.type = 'sine';
      o.frequency.setValueAtTime(145, now);
      o.frequency.exponentialRampToValueAtTime(42, now + 0.13);
      g.gain.setValueAtTime(gainVal, now);
      g.gain.exponentialRampToValueAtTime(0.0001, now + 0.17);
      o.connect(g); g.connect(audioCtx.destination);
      o.start(now); o.stop(now + 0.18);
    }}

    function playNoiseHit(dur = 0.06, gainVal = 0.035, freq = 6500) {{
      if (!audioCtx || document.getElementById('chkMuteSynth').checked) return;
      const now = audioCtx.currentTime;
      const len = Math.max(256, Math.floor(audioCtx.sampleRate * dur));
      const buf = audioCtx.createBuffer(1, len, audioCtx.sampleRate);
      const d = buf.getChannelData(0);
      for (let i = 0; i < len; i++) d[i] = Math.random() * 2 - 1;
      const src = audioCtx.createBufferSource();
      src.buffer = buf;
      const flt = audioCtx.createBiquadFilter();
      flt.type = 'bandpass';
      flt.frequency.setValueAtTime(freq, now);
      const g = audioCtx.createGain();
      g.gain.setValueAtTime(gainVal, now);
      g.gain.exponentialRampToValueAtTime(0.0001, now + dur);
      src.connect(flt); flt.connect(g); g.connect(audioCtx.destination);
      src.start(now);
    }}

    function tickSynth(u, tSec) {{
      if (audioSource !== 'synth' || paused || viewMode !== 'opening' || !audioCtx) return;
      const step = Math.floor(tSec / STEP_SEC);
      if (step === synthStepPlayed || u >= 0.995) return;
      synthStepPlayed = step;

      const bar = Math.floor(step / 8);
      const inBar = step % 8;
      const chord = CHORDS[bar % CHORDS.length];

      if (u < 0.15) {{
        playNote(m2f(chord[inBar % 4] + (inBar >= 4 ? 12 : 0)), 0.50, 0.036, 'sine', 2000);
      }} else if (u < 0.31) {{
        if (inBar % 2 === 0) playKick(0.08);
        playNote(m2f(chord[step % 4] + 12), 0.36, 0.04, 'triangle', 2900);
      }} else if (u < 0.40) {{
        if (inBar % 2 === 0) playKick(0.12);
        playNoiseHit(0.06, 0.032, 3000 + (u - 0.31) * 35000);
        if (inBar === 0) playSupersaw(chord, 0.85, 0.018);
        playNote(m2f(chord[inBar % 4] + 12), 0.24, 0.04, 'sawtooth', 3000);
      }} else if (u < 0.67) {{
        // DROP MÊLÉE 128 BPM !
        if (inBar % 2 === 0) playKick(0.17);
        if (inBar === 2 || inBar === 6) playNoiseHit(0.12, 0.055, 2200);
        else playNoiseHit(0.045, 0.025, 7800);
        if (inBar === 0 || inBar === 4) playSupersaw(chord, 0.80, 0.026);
        playNote(m2f(MELODY_DROP[step % MELODY_DROP.length]), 0.28, 0.048, 'sawtooth', 4800);
      }} else if (u < 0.83) {{
        if (inBar % 4 === 0) playKick(0.10);
        if (inBar === 0) playSupersaw(chord, 1.5, 0.018);
        if (inBar % 2 === 0) playNote(m2f(chord[(inBar / 2) % 4] + 12), 0.65, 0.034, 'triangle', 2600);
      }} else {{
        if (inBar === 0 && u < 0.93) {{
          playSupersaw([53, 60, 65, 69, 72], 2.2, 0.022);
          playNote(m2f(84), 1.4, 0.05, 'triangle', 5200);
        }}
      }}
    }}

    // =========================================================================
    // YOUTUBE IFRAME API OFFICIELLE (`2aafI3XvKxo`)
    // =========================================================================
    let ytPlayer = null;
    let ytApiRequested = false;

    function activateYouTubeSync() {{
      viewMode = 'opening';
      audioSource = 'youtube';
      durationSec = 153.0;
      paused = false;
      document.getElementById('audioModeLabel').textContent =
        '🎬 Audio actif : YouTube Officiel 2aafI3XvKxo — Simple and Clean: Ray of Hope MIX (02:33)';
      const ph = document.getElementById('ytPlaceholder');
      if (ph) ph.style.display = 'none';

      if (ytPlayer && typeof ytPlayer.playVideo === 'function') {{
        ytPlayer.seekTo(0, true);
        ytPlayer.playVideo();
        return;
      }}
      if (!ytApiRequested) {{
        ytApiRequested = true;
        const tag = document.createElement('script');
        tag.src = 'https://www.youtube.com/iframe_api';
        tag.onerror = () => fallbackFromYT('YouTube indisponible sur ce réseau : synthé 128 BPM Ray of Hope maintenu.');
        document.head.appendChild(tag);
      }}
    }}

    function fallbackFromYT(msg) {{
      audioSource = 'synth';
      durationSec = 56.0;
      curTime = 0.0;
      synthStepPlayed = -1;
      ensureAudioCtx();
      document.getElementById('audioModeLabel').textContent = '🎹 ' + msg;
    }}

    window.onYouTubeIframeAPIReady = function() {{
      ytPlayer = new YT.Player('ytPlayerSlot', {{
        width: '240',
        height: '135',
        videoId: '2aafI3XvKxo',
        playerVars: {{ autoplay: 1, controls: 1, rel: 0, modestbranding: 1, playsinline: 1 }},
        events: {{
          onReady: (ev) => {{
            const d = ev.target.getDuration();
            if (d && d > 30) durationSec = d;
            ev.target.playVideo();
          }},
          onError: () => fallbackFromYT('Lecture intégrée restreinte : synthé 128 BPM Ray of Hope activé.'),
        }},
      }});
    }};

    // =========================================================================
    // MOTEUR DE SPRITES PMD MULTI-POSES 8 DIRECTIONS (`AnimData.xml`) & VFX PIXEL
    // =========================================================================
    function lerp(a, b, t) {{ return a + (b - a) * Math.max(0, Math.min(1, t)); }}
    function smoothstep(t) {{
      const u = Math.max(0, Math.min(1, t));
      return u * u * (3 - 2 * u);
    }}

    // Calcule l'indice Dir8 PMDO (0=Down, 1=DR, 2=Right, 3=UR, 4=Up, 5=UL, 6=Left, 7=DL)
    function vecToDir8(dx, dy, fallback = 0) {{
      if (Math.hypot(dx, dy) < 0.4) return fallback;
      // En écran RPG (x droite, y bas) : (0, +1) -> 0 Down ; (+1, 0) -> 2 Right ; (0, -1) -> 4 Up ; (-1, 0) -> 6 Left
      const ang = Math.atan2(dx, dy); // 0 = Down, +pi/2 = Right, +-pi = Up, -pi/2 = Left
      const idx = Math.round(ang / (Math.PI / 4));
      return ((idx % 8) + 8) % 8;
    }}

    function resolveAnimFrame(pid, animName, tick60, loop = true) {{
      const p = PMD_CATALOG[pid];
      if (!p) return null;
      const anim = p.anims[animName] || p.anims.Idle || Object.values(p.anims)[0];
      if (!anim) return null;
      const im = getImg(anim.url);
      if (!im || !im.complete || im.naturalWidth === 0) return null;

      const durs = anim.durations;
      const totalTicks = durs.reduce((s, d) => s + d, 0) || 1;
      let t = Math.max(0, Math.floor(tick60));
      if (loop) t = t % totalTicks;
      else t = Math.min(totalTicks - 1, t);

      let col = 0;
      let acc = 0;
      for (let i = 0; i < durs.length; i++) {{
        acc += durs[i];
        if (t < acc) {{ col = i; break; }}
        col = i;
      }}
      col = col % anim.cols;
      return {{ im, anim, col }};
    }}

    function drawWaterRipplePixel(ctx, wx, wy, radius, color = 'rgba(186, 230, 253, 0.75)') {{
      if (radius <= 1) return;
      ctx.save();
      ctx.strokeStyle = color;
      ctx.lineWidth = 1;
      ctx.beginPath();
      ctx.ellipse(Math.round(wx), Math.round(wy), Math.round(radius), Math.max(1, Math.round(radius * 0.48)), 0, 0, Math.PI * 2);
      ctx.stroke();
      ctx.restore();
    }}

    function drawSlashArcPixel(ctx, wx, wy, dirAngleRad, radius, progress, colorOuter, colorInner) {{
      if (progress <= 0 || progress >= 1) return;
      ctx.save();
      ctx.translate(Math.round(wx), Math.round(wy));
      ctx.rotate(dirAngleRad);
      const span = 1.9 * Math.sin(Math.PI * progress);
      ctx.strokeStyle = colorOuter;
      ctx.lineWidth = 4;
      ctx.beginPath();
      ctx.arc(0, 0, radius, -span * 0.5, span * 0.5);
      ctx.stroke();

      ctx.strokeStyle = colorInner;
      ctx.lineWidth = 2;
      ctx.beginPath();
      ctx.arc(0, 0, radius - 1, -span * 0.42, span * 0.42);
      ctx.stroke();
      ctx.restore();
    }}

    function drawProtectHexSphere(ctx, wx, wy, rad, tSec) {{
      ctx.save();
      const x = Math.round(wx), y = Math.round(wy);
      const g = ctx.createRadialGradient(x - rad * 0.25, y - rad * 0.25, 2, x, y, rad);
      g.addColorStop(0, 'rgba(224, 247, 255, 0.22)');
      g.addColorStop(0.75, 'rgba(56, 189, 248, 0.38)');
      g.addColorStop(1, 'rgba(186, 230, 253, 0.85)');
      ctx.fillStyle = g;
      ctx.beginPath();
      for (let i = 0; i < 6; i++) {{
        const a = tSec * 1.6 + (i * Math.PI) / 3;
        const px = x + Math.cos(a) * rad;
        const py = y + Math.sin(a) * rad;
        if (i === 0) ctx.moveTo(px, py);
        else ctx.lineTo(px, py);
      }}
      ctx.closePath();
      ctx.fill();
      ctx.strokeStyle = 'rgba(240, 253, 255, 0.92)';
      ctx.lineWidth = 1.5;
      ctx.stroke();
      ctx.restore();
    }}

    // Dessine un acteur PMD (reflet d'eau optionnel + ombre + sprite net)
    function drawActorOnMap(ctx, actor, tSec, pass) {{
      const res = resolveAnimFrame(actor.pid, actor.anim, actor.tick, actor.loop !== false);
      if (!res) return;
      const {{ im, anim, col }} = res;
      const fw = anim.fw, fh = anim.fh;
      const row = anim.rows >= 8 ? ((actor.dir8 % 8) + 8) % 8 : 0;
      const sx = col * fw, sy = row * fh;
      const wx = Math.round(actor.wx), wy = Math.round(actor.wy);
      const alpha = actor.alpha !== undefined ? actor.alpha : 1.0;

      if (pass === 'reflection') {{
        if (!actor.reflect) return;
        refCtx.clearRect(0, 0, fw, fh);
        refCtx.drawImage(im, sx, sy, fw, fh, 0, 0, fw, fh);
        ctx.save();
        ctx.globalAlpha = 0.30 * alpha;
        // Ondulation aquatique ligne par ligne sous les pieds du Pokémon
        const footY = wy + 10;
        for (let ly = 0; ly < fh; ly += 2) {{
          const waveX = Math.round(Math.sin(tSec * 6.0 + ly * 0.35) * 1.4);
          const dstY = footY + Math.round((fh - 1 - ly) * 0.58);
          ctx.drawImage(refCanvas, 0, ly, fw, 2, wx - Math.floor(fw / 2) + waveX, dstY, fw, 1);
        }}
        ctx.restore();
        return;
      }}

      if (actor.reflectOnly) return;

      // Ombre elliptique PMD au sol (sauf en pleine chute céleste)
      if (!actor.noShadow) {{
        ctx.save();
        ctx.fillStyle = `rgba(4, 10, 28, ${{(0.36 * alpha).toFixed(2)}})`;
        ctx.beginPath();
        ctx.ellipse(wx, wy + 9, 9, 4, 0, 0, Math.PI * 2);
        ctx.fill();
        ctx.restore();
      }}

      // Aura optionnelle autour du Pokémon (combat / ténèbres)
      if (actor.auraColor) {{
        ctx.save();
        ctx.fillStyle = actor.auraColor;
        ctx.beginPath();
        ctx.arc(wx, wy - 2, 16 + Math.sin(tSec * 12) * 2, 0, Math.PI * 2);
        ctx.fill();
        ctx.restore();
      }}

      ctx.save();
      ctx.globalAlpha = alpha;
      ctx.drawImage(im, sx, sy, fw, fh, wx - Math.floor(fw / 2), wy - Math.floor(fh / 2) - (actor.zLift || 0), fw, fh);
      ctx.restore();
    }}

    // Boîte de portrait d'émotion style PMD Explorers of Sky (40x40 dans cadre PMDO sur vCtx 320x240)
    function drawPMDPortrait(pid, emo, side = 'left', alpha = 1.0) {{
      const p = PMD_CATALOG[pid];
      if (!p || !p.portraitUrls || !p.portraitUrls[emo]) return;
      const im = getImg(p.portraitUrls[emo]);
      if (!im || !im.complete || im.naturalWidth === 0) return;

      const bx = side === 'left' ? 8 : VW - 52;
      const by = VH - 52;
      vCtx.save();
      vCtx.globalAlpha = alpha;
      vCtx.fillStyle = '#0d1b3a';
      vCtx.fillRect(bx - 2, by - 2, 44, 44);
      vCtx.strokeStyle = '#fbbf24';
      vCtx.lineWidth = 1;
      vCtx.strokeRect(bx - 1.5, by - 1.5, 43, 43);
      vCtx.drawImage(im, 0, 0, im.naturalWidth, im.naturalHeight, bx, by, 40, 40);
      vCtx.restore();
    }}

    function drawPixelBubblesOnScreen(tSec, count, speedMul = 1.0, alpha = 0.85) {{
      vCtx.save();
      for (let i = 0; i < count; i++) {{
        const b = PIXEL_BUBBLES[i];
        const y = Math.round((1.06 - ((b.yOff + tSec * b.spd * speedMul) % 1.16)) * VH);
        const x = Math.round(b.x + Math.sin(tSec * 2.6 + b.ph) * b.wob);
        vCtx.strokeStyle = `rgba(186, 242, 255, ${{alpha.toFixed(2)}})`;
        vCtx.lineWidth = 1;
        vCtx.beginPath();
        vCtx.arc(x, y, b.r, 0, Math.PI * 2);
        vCtx.stroke();
        vCtx.fillStyle = `rgba(255, 255, 255, ${{(alpha * 0.9).toFixed(2)}})`;
        vCtx.fillRect(x - Math.max(0, b.r - 1), y - Math.max(0, b.r - 1), 1, 1);
      }}
      vCtx.restore();
    }}

    // Projette la caméra PMDO (camX, camY, zoom) depuis mCanvas (576x320) vers vCanvas (320x240)
    function blitMapCameraToScreen(camX, camY, zoom = 1.0, shakeAmp = 0.0, tSec = 0.0) {{
      const srcW = VW / zoom;
      const srcH = VH / zoom;
      const shX = shakeAmp > 0 ? Math.sin(tSec * 58.0) * shakeAmp : 0;
      const shY = shakeAmp > 0 ? Math.cos(tSec * 67.0) * shakeAmp : 0;
      const sx = Math.max(0, Math.min(MW - srcW, camX - srcW / 2 + shX));
      const sy = Math.max(0, Math.min(MH - srcH, camY - srcH / 2 + shY));
      vCtx.clearRect(0, 0, VW, VH);
      vCtx.drawImage(mCanvas, sx, sy, srcW, srcH, 0, 0, VW, VH);
      document.getElementById('lblCam').textContent =
        `(${{Math.round(camX)}}, ${{Math.round(camY)}}) · ${{zoom.toFixed(2)}}×`;
    }}

    // =========================================================================
    // RIG D'AILES ARTICULÉ & ARRIVÉE EN UNE SEULE FOIS PLEIN CENTRE
    // =========================================================================
    function computeWingAngleDeg(dtSinceArrival, nowSec) {{
      let deg = 0.0;
      if (dtSinceArrival >= 0.0 && dtSinceArrival < 3.4) {{
        deg += 8.2 * Math.exp(-1.55 * dtSinceArrival) * Math.cos(2.0 * Math.PI * 2.25 * dtSinceArrival);
      }} else if (dtSinceArrival >= 3.4) {{
        deg += 0.60 * Math.sin((dtSinceArrival - 3.4) * 1.9);
      }}
      const dtManual = nowSec - manualFlapStart;
      if (dtManual >= 0.0 && dtManual < 2.4) {{
        deg += 8.8 * Math.exp(-1.75 * dtManual) * Math.sin(2.0 * Math.PI * 2.6 * dtManual);
      }}
      return deg;
    }}

    function drawArticulatedLogoOnOut(cx, cy, baseW, revealSec, nowSec) {{
      if (!MAPS.rigCore.complete || MAPS.rigCore.naturalWidth === 0) return 0.0;
      const hdW = 872, hdH = 629;
      const baseH = baseW * (hdH / hdW);

      if (revealSec >= 0.04 && revealSec <= 0.48) {{
        const fu = (revealSec - 0.04) / 0.44;
        const env = Math.sin(Math.PI * Math.min(1, Math.max(0, fu)));
        outCtx.save();
        const halfLen = outCanvas.width * (0.18 + 0.30 * fu);
        const fh = Math.max(4, 16 * env);
        const grad = outCtx.createRadialGradient(cx, cy, 2, cx, cy, halfLen);
        grad.addColorStop(0, `rgba(255,255,245,${{(0.95 * env).toFixed(3)}})`);
        grad.addColorStop(0.4, `rgba(254,240,138,${{(0.75 * env).toFixed(3)}})`);
        grad.addColorStop(1, 'rgba(254,240,138,0)');
        outCtx.fillStyle = grad;
        outCtx.beginPath();
        outCtx.ellipse(cx, cy, halfLen, fh, 0, 0, Math.PI * 2);
        outCtx.fill();
        outCtx.restore();
      }}

      if (revealSec < 0.18) return 0.0;
      const dtLogo = revealSec - 0.18;

      let scale = 1.0, alpha = 1.0, whiteFlash = 0.0;
      if (dtLogo < 0.60) {{
        const u = dtLogo / 0.60;
        const c1 = 1.70158, c3 = c1 + 1.0;
        const ease = 1.0 + c3 * Math.pow(u - 1.0, 3) + c1 * Math.pow(u - 1.0, 2);
        scale = 1.40 + (1.0 - 1.40) * ease;
        alpha = Math.min(1.0, dtLogo / 0.18);
        whiteFlash = Math.max(0.0, 1.0 - dtLogo / 0.35);
      }}

      const wingDeg = computeWingAngleDeg(dtLogo, nowSec);
      const rad = (wingDeg * Math.PI) / 180.0;

      rigCtx.clearRect(0, 0, hdW, hdH);
      if (MAPS.rigLW.complete && MAPS.rigRW.complete) {{
        rigCtx.save();
        rigCtx.translate(274, 335);
        rigCtx.rotate(rad);
        rigCtx.drawImage(MAPS.rigLW, -274, -335);
        rigCtx.restore();

        rigCtx.save();
        rigCtx.translate(598, 335);
        rigCtx.rotate(-rad);
        rigCtx.drawImage(MAPS.rigRW, -598, -335);
        rigCtx.restore();

        rigCtx.drawImage(MAPS.rigCore, 0, 0);
      }} else {{
        rigCtx.drawImage(MAPS.logoHD, 0, 0);
      }}

      tintCtx.clearRect(0, 0, hdW, hdH);
      tintCtx.globalCompositeOperation = 'source-over';
      tintCtx.drawImage(rigCanvas, 0, 0);

      if (whiteFlash > 0.01) {{
        tintCtx.globalCompositeOperation = 'source-atop';
        tintCtx.fillStyle = `rgba(255, 250, 218, ${{whiteFlash.toFixed(3)}})`;
        tintCtx.fillRect(0, 0, hdW, hdH);
      }}
      if (dtLogo >= 0.64 && dtLogo <= 1.32) {{
        const su = (dtLogo - 0.64) / 0.68;
        const sx = -180 + su * (hdW + 360);
        tintCtx.globalCompositeOperation = 'source-atop';
        const sg = tintCtx.createLinearGradient(sx - 95, 0, sx + 95, 95);
        sg.addColorStop(0, 'rgba(255,255,255,0)');
        sg.addColorStop(0.5, 'rgba(255,255,245,0.68)');
        sg.addColorStop(1, 'rgba(255,255,255,0)');
        tintCtx.fillStyle = sg;
        tintCtx.fillRect(0, 0, hdW, hdH);
      }}

      const drawW = baseW * scale;
      const drawH = baseH * scale;
      outCtx.save();
      outCtx.imageSmoothingEnabled = true;
      outCtx.globalAlpha = alpha;
      outCtx.drawImage(tintCanvas, cx - drawW / 2, cy - drawH / 2, drawW, drawH);
      outCtx.imageSmoothingEnabled = false;
      outCtx.restore();

      return wingDeg;
    }}

    // =========================================================================
    // CHORÉGRAPHIE PLAN PAR PLAN SUR LES 5 MAPS PMD 3/4 (`Simple and Clean: Ray of Hope MIX`)
    // =========================================================================
    function renderPMDOpening(u, tSec, nowSec) {{
      const ticks = tSec * 60.0;
      mCtx.clearRect(0, 0, MW, MH);
      let actors = [];
      let wingDeg = 0.0;
      let portraitOverlay = null;
      let screenFlash = 0.0;

      // -----------------------------------------------------------------------
      // ACTE I (0.00 .. 0.15) : OPM1 PLAGE CRISTAL ↔ LAGON & PATTE DANS L'EAU
      // -----------------------------------------------------------------------
      if (u < 0.15) {{
        document.getElementById('lblMap').textContent = 'OPM1 · Plage Cristal & Lagon (576×320)';
        if (MAPS.opm1.complete) mCtx.drawImage(MAPS.opm1, 0, 0, MW, MH);
        const loc = u / 0.15;

        // Charme Étoile Wayfinder englouti brillant au fond du lagon (288, 214)
        const wfPulse = 0.65 + 0.35 * Math.sin(tSec * 4.5);
        drawWaterRipplePixel(mCtx, 288, 214, 10 + (tSec * 14) % 24, `rgba(125, 249, 255, ${{(0.55 * wfPulse).toFixed(2)}})`);
        if (MAPS.wfCyan.complete) {{
          mCtx.save();
          mCtx.globalAlpha = 0.88;
          mCtx.drawImage(MAPS.wfCyan, 288 - 14, 214 - 14);
          mCtx.restore();
        }}

        if (loc < 0.25) {{
          // Plan 1a : Fond de l'eau avec bulles -> remontée caméra vers le rivage
          const s = smoothstep(loc / 0.25);
          blitMapCameraToScreen(288, lerp(222, 138, s), lerp(1.22, 1.05, s), 0, tSec);
          drawPixelBubblesOnScreen(tSec, 48, 1.0, 0.85 * (1.0 - s * 0.6));
          if (loc < 0.08) screenFlash = -(1.0 - loc / 0.08); // fondu noir d'ouverture
        }} else if (loc < 0.62) {{
          // Plan 1b : Riolu, Évoli & Tiplouf courent et jouent sur le sable doré
          const s = (loc - 0.25) / 0.37;
          const rx = lerp(215, 294, s), ry = lerp(96, 106, s);
          const ex = lerp(175, 244, s), ey = lerp(90, 98, s);
          const px = lerp(374, 330, s), py = lerp(94, 102, s);
          actors.push({{ pid: '0447', anim: s > 0.72 ? 'Hop' : 'Walk', dir8: vecToDir8(79, 10), tick: ticks * 1.2, wx: rx, wy: ry }});
          actors.push({{ pid: '0133', anim: s > 0.75 ? 'TailWhip' : 'Walk', dir8: 2, tick: ticks * 1.15, wx: ex, wy: ey }});
          actors.push({{ pid: '0393', anim: s > 0.68 ? 'Hover' : 'Walk', dir8: 6, tick: ticks * 1.15, wx: px, wy: py }});

          actors.sort((a, b) => a.wy - b.wy).forEach((a) => drawActorOnMap(mCtx, a, tSec, 'main'));
          blitMapCameraToScreen(lerp(268, 288, s), 112, 1.08, 0, tSec);
          if (s > 0.45) portraitOverlay = {{ pid: '0133', emo: 'Joyous', side: 'left' }};
        }} else if (loc < 0.76) {{
          // Plan 1c : Intercut rapide sous l'eau sur le Wayfinder qui pulse (comme dans 2aafI3XvKxo !)
          blitMapCameraToScreen(288, 214, 1.32, 0, tSec);
          drawPixelBubblesOnScreen(tSec, 44, 1.2, 0.8);
        }} else {{
          // Plan 1d : Riolu s'avance dans l'écume (288, 120) et tend la patte dans l'eau !
          const s = (loc - 0.76) / 0.24;
          const ry = lerp(108, 122, Math.min(1, s * 1.6));
          actors.push({{ pid: '0133', anim: 'Idle', dir8: 1, tick: ticks, wx: 244, wy: 100 }});
          actors.push({{ pid: '0393', anim: 'Idle', dir8: 7, tick: ticks, wx: 332, wy: 102 }});
          actors.push({{
            pid: '0447',
            anim: s < 0.42 ? 'Walk' : 'Pull',
            dir8: 0,
            tick: s < 0.42 ? ticks : (s - 0.42) * 55,
            loop: s < 0.42,
            wx: 288,
            wy: ry,
            reflect: true,
          }});
          if (s >= 0.42) {{
            const rp = (s - 0.42) / 0.58;
            drawWaterRipplePixel(mCtx, 288, 132, rp * 42, 'rgba(224, 247, 255, 0.92)');
            drawWaterRipplePixel(mCtx, 288, 132, Math.max(0, rp * 42 - 12), 'rgba(56, 189, 248, 0.82)');
          }}
          actors.forEach((a) => drawActorOnMap(mCtx, a, tSec, 'reflection'));
          actors.sort((a, b) => a.wy - b.wy).forEach((a) => drawActorOnMap(mCtx, a, tSec, 'main'));
          blitMapCameraToScreen(288, lerp(128, 142, s), lerp(1.16, 1.28, s), 0, tSec);
          portraitOverlay = {{ pid: '0447', emo: 'Surprised', side: 'left' }};
          if (s > 0.86) screenFlash = (s - 0.86) / 0.14 * 0.75;
        }}

      // -----------------------------------------------------------------------
      // ACTE II (0.15 .. 0.31) : OPM2 TEMPLE ABYSSAL, CHUTE & VITRAIL DU DESTIN
      // -----------------------------------------------------------------------
      }} else if (u < 0.31) {{
        document.getElementById('lblMap').textContent = 'OPM2 · Abysse & Vitrail Dive to the Heart (576×320)';
        if (MAPS.opm2.complete) mCtx.drawImage(MAPS.opm2, 0, 0, MW, MH);
        const loc = (u - 0.15) / 0.16;

        // Illumination progressive de la Rosace Vitrail PMD incrustée dans le cercle de pierre (288, 160)
        const vitAlpha = loc < 0.18 ? loc / 0.18 * 0.25 : Math.min(0.84, 0.25 + ((loc - 0.18) / 0.35) * 0.59);
        if (MAPS.vitrailDais.complete) {{
          mCtx.save();
          mCtx.globalAlpha = vitAlpha;
          mCtx.drawImage(MAPS.vitrailDais, 288 - 96, 160 - 87);
          mCtx.restore();
        }}

        // Projecteur sous-marin zénithal
        const spot = mCtx.createRadialGradient(288, 156, 8, 288, 156, 125);
        spot.addColorStop(0, 'rgba(165, 243, 252, 0.25)');
        spot.addColorStop(1, 'rgba(3, 10, 28, 0.52)');
        mCtx.fillStyle = spot;
        mCtx.fillRect(0, 0, MW, MH);

        if (loc < 0.36) {{
          // Lucario seul dans le rayon sous-marin serrant le Wayfinder puis basculant en arrière (TumbleBack -> Float)
          const s = loc / 0.36;
          actors.push({{
            pid: '0448',
            anim: s < 0.45 ? 'DeepBreath' : (s < 0.75 ? 'TumbleBack' : 'Float'),
            dir8: 0,
            tick: ticks,
            wx: 288,
            wy: lerp(152, 162, s),
            zLift: s >= 0.45 ? Math.sin((s - 0.45) * Math.PI) * 10 : 0,
          }});
          if (MAPS.wfCyan.complete) {{
            mCtx.drawImage(MAPS.wfCyan, 288 - 10, Math.round(lerp(156, 144, s)) - 10, 20, 20);
          }}
          actors.forEach((a) => drawActorOnMap(mCtx, a, tSec, 'main'));
          blitMapCameraToScreen(288, 158, lerp(1.26, 1.08, s), 0, tSec);
          drawPixelBubblesOnScreen(tSec, 62, 1.25, 0.88);
          portraitOverlay = {{ pid: '0448', emo: s < 0.55 ? 'Sad' : 'Inspired', side: 'left' }};
        }} else if (loc < 0.78) {{
          // Les 3 Wayfinders plongent sur le Vitrail -> Massko & Celebi apparaissent aux côtés de Lucario !
          const s = (loc - 0.36) / 0.42;
          const dropT = Math.min(1, s * 2.2);
          if (MAPS.wfCyan.complete && MAPS.wfEmerald.complete && MAPS.wfAmber.complete) {{
            mCtx.drawImage(MAPS.wfCyan, 288 - 10, Math.round(lerp(40, 132, dropT)) - 10, 20, 20);
            mCtx.drawImage(MAPS.wfEmerald, Math.round(lerp(260, 238, dropT)) - 10, Math.round(lerp(30, 162, dropT)) - 10, 20, 20);
            mCtx.drawImage(MAPS.wfAmber, Math.round(lerp(316, 338, dropT)) - 10, Math.round(lerp(30, 162, dropT)) - 10, 20, 20);
          }}
          const friendAlpha = s < 0.32 ? s / 0.32 : 1.0;
          actors.push({{ pid: '0448', anim: 'Pose', dir8: 0, tick: ticks * 0.7, wx: 288, wy: 144 }});
          actors.push({{ pid: '0253', anim: 'Pose', dir8: 1, tick: ticks * 0.7, wx: 238, wy: 172, alpha: friendAlpha }});
          actors.push({{ pid: '0251', anim: 'Twirl', dir8: 7, tick: ticks * 0.9, wx: 338, wy: 172, alpha: friendAlpha }});
          actors.sort((a, b) => a.wy - b.wy).forEach((a) => drawActorOnMap(mCtx, a, tSec, 'main'));
          blitMapCameraToScreen(288, 160, lerp(1.06, 1.18, s), 0, tSec);
          drawPixelBubblesOnScreen(tSec, 52, 1.1, 0.78);
          if (s > 0.35) portraitOverlay = {{ pid: '0448', emo: 'Joyous', side: 'left' }};
        }} else {{
          // Massko & Celebi se dissipent, leurs charmes filent vers le nord -> Lucario s'élance pour les rattraper !
          const s = (loc - 0.78) / 0.22;
          const fade = Math.max(0, 1.0 - s * 2.0);
          actors.push({{ pid: '0253', anim: 'Sink', dir8: 4, tick: ticks, wx: 238, wy: 172, alpha: fade }});
          actors.push({{ pid: '0251', anim: 'Sink', dir8: 4, tick: ticks, wx: 338, wy: 172, alpha: fade }});
          actors.push({{
            pid: '0448',
            anim: s < 0.5 ? 'LeapForth' : 'Pull',
            dir8: 4,
            tick: ticks * 1.2,
            wx: 288,
            wy: lerp(144, 104, s),
          }});
          // Étoiles filantes sombres filant au nord
          if (MAPS.wfEmerald.complete && MAPS.wfAmber.complete) {{
            mCtx.drawImage(MAPS.wfEmerald, Math.round(lerp(238, 268, s)) - 9, Math.round(lerp(162, 24, s)) - 9, 18, 18);
            mCtx.drawImage(MAPS.wfAmber, Math.round(lerp(338, 308, s)) - 9, Math.round(lerp(162, 24, s)) - 9, 18, 18);
          }}
          actors.sort((a, b) => a.wy - b.wy).forEach((a) => drawActorOnMap(mCtx, a, tSec, 'main'));
          blitMapCameraToScreen(288, lerp(156, 112, s), 1.16, 0, tSec);
          drawPixelBubblesOnScreen(tSec, 56, 1.6, 0.82);
        }}

      // -----------------------------------------------------------------------
      // ACTE III & IV (0.31 .. 0.67) : OPM3 ARÈNE EAU-MIROIR — REFLETS & MÊLÉE 128 BPM !
      // -----------------------------------------------------------------------
      }} else if (u < 0.67) {{
        document.getElementById('lblMap').textContent = 'OPM3 · Arène Eau-Miroir (Mêlée 128 BPM · 576×320)';
        if (MAPS.opm3.complete) mCtx.drawImage(MAPS.opm3, 0, 0, MW, MH);
        const loc = (u - 0.31) / 0.36; // 0..1 sur toute la séquence d'arène

        let camX = 288, camY = 166, camZ = 1.12, shake = 0.0;
        let fxDraw = null;

        if (loc < 0.24) {{
          // III (Pré-Refrain) : Lucario avance sur l'eau miroir ; les reflets inversés de Massko & Celebi tournent le dos et s'éloignent ;
          // Zoroark-Ombre & Massko-Ombre se retournent brusquement (Rotate) !
          const s = loc / 0.24;
          const ly = lerp(228, 182, Math.min(1, s * 1.4));
          drawWaterRipplePixel(mCtx, 288, ly + 9, (tSec * 22) % 18, 'rgba(125, 211, 252, 0.68)');

          if (s < 0.62) {{
            const rfFade = 1.0 - s / 0.62;
            actors.push({{ pid: '0253', anim: 'Walk', dir8: 4, tick: ticks, wx: 266, wy: lerp(164, 134, s), reflect: true, reflectOnly: true, alpha: rfFade }});
            actors.push({{ pid: '0251', anim: 'Walk', dir8: 4, tick: ticks, wx: 310, wy: lerp(164, 134, s), reflect: true, reflectOnly: true, alpha: rfFade }});
          }}

          const turnS = Math.max(0, (s - 0.55) / 0.45);
          actors.push({{
            pid: 'shadow_0571',
            anim: turnS > 0 && turnS < 0.7 ? 'Rotate' : 'Charge',
            dir8: turnS < 0.35 ? 4 : 0,
            tick: ticks * 1.3,
            wx: 256,
            wy: 118,
            reflect: true,
            auraColor: turnS > 0.3 ? 'rgba(147, 51, 234, 0.22)' : null,
          }});
          actors.push({{
            pid: 'shadow_0253',
            anim: turnS > 0 && turnS < 0.7 ? 'Rotate' : 'Charge',
            dir8: turnS < 0.35 ? 4 : 0,
            tick: ticks * 1.3,
            wx: 320,
            wy: 118,
            reflect: true,
            auraColor: turnS > 0.3 ? 'rgba(147, 51, 234, 0.22)' : null,
          }});
          actors.push({{ pid: '0448', anim: s < 0.7 ? 'Walk' : 'Charge', dir8: 4, tick: ticks, wx: 288, wy: ly, reflect: true }});

          camY = lerp(192, 152, s);
          camZ = lerp(1.06, 1.20, s);
          if (s > 0.86) screenFlash = ((s - 0.86) / 0.14) * 0.9; // Riser vers le Drop !

        }} else if (loc < 0.38) {{
          // IV-A (Échange 1 du Drop 128 BPM) : Ruée frontale Zoroark-Ombre (Attack) vs Parade Aura de Lucario (Strike) !
          const s = (loc - 0.24) / 0.14;
          const rush = Math.min(1, s * 2.2);
          const zx = lerp(256, 276, rush), zy = lerp(118, 150, rush);
          const lx = 288, ly = lerp(182, 166, rush);

          actors.push({{ pid: 'shadow_0571', anim: 'Attack', dir8: 0, tick: s * 48, loop: false, wx: zx, wy: zy, reflect: true, auraColor: 'rgba(168, 85, 247, 0.26)' }});
          actors.push({{ pid: 'shadow_0253', anim: 'Walk', dir8: 0, tick: ticks * 1.6, wx: lerp(320, 336, s), wy: lerp(118, 146, s), reflect: true }});
          actors.push({{ pid: '0448', anim: 'Strike', dir8: 4, tick: s * 38, loop: false, wx: lx, wy: ly, reflect: true, auraColor: 'rgba(56, 189, 248, 0.25)' }});

          fxDraw = () => {{
            drawSlashArcPixel(mCtx, zx + 4, zy + 8, Math.PI * 0.35, 22, s, '#a855f7', '#fde047');
            drawSlashArcPixel(mCtx, lx, ly - 8, -Math.PI * 0.65, 24, s, '#0284c7', '#e0f2fe');
            if (s > 0.38) {{
              const imp = (s - 0.38) / 0.62;
              drawWaterRipplePixel(mCtx, 282, 162, imp * 46, 'rgba(254, 240, 138, 0.92)');
              drawWaterRipplePixel(mCtx, 282, 162, imp * 28, 'rgba(56, 189, 248, 0.90)');
            }}
          }};
          camX = 284; camY = 158; camZ = 1.28;
          shake = s > 0.35 && s < 0.72 ? 3.2 : 0.6;
          if (s < 0.14) screenFlash = (1.0 - s / 0.14) * 0.85;

        }} else if (loc < 0.52) {{
          // IV-B (Échange 2 lié) : Massko-Ombre bondit sur le flanc droit (Hop -> Swing) ->
          // Lucario pivote instantanément (QuickStrike dir=2 Right) et l'éjecte sur l'eau !
          const s = (loc - 0.38) / 0.14;
          const hit = s > 0.46;
          const mx = !hit ? lerp(336, 310, s / 0.46) : lerp(310, 378, (s - 0.46) / 0.54);
          const my = 164;
          actors.push({{ pid: 'shadow_0571', anim: 'Hop', dir8: 7, tick: s * 42, wx: lerp(276, 244, s), wy: lerp(150, 164, s), reflect: true }});
          actors.push({{
            pid: 'shadow_0253',
            anim: !hit ? 'Swing' : 'Hurt',
            dir8: 6,
            tick: !hit ? s * 52 : ticks,
            wx: mx,
            wy: my,
            reflect: true,
            auraColor: 'rgba(168, 85, 247, 0.24)',
          }});
          actors.push({{
            pid: '0448',
            anim: s < 0.22 ? 'Rotate' : 'QuickStrike',
            dir8: 2,
            tick: (s - 0.22) * 58,
            loop: false,
            wx: lerp(288, 298, Math.min(1, s * 2)),
            wy: 164,
            reflect: true,
            auraColor: 'rgba(56, 189, 248, 0.28)',
          }});
          fxDraw = () => {{
            drawSlashArcPixel(mCtx, 304, 162, 0.0, 26, s, '#38bdf8', '#ffffff');
            if (hit) drawWaterRipplePixel(mCtx, mx, my + 8, ((s - 0.46) / 0.54) * 34, 'rgba(186, 230, 253, 0.9)');
          }};
          camX = lerp(292, 316, s); camY = 164; camZ = 1.26;
          shake = hit && s < 0.72 ? 2.8 : 0.4;

        }} else if (loc < 0.64) {{
          // IV-C (Échange 3 : Tenaille d'Ombres -> Lucario projeté à genoux sur l'eau miroir !)
          const s = (loc - 0.52) / 0.12;
          const knocked = s > 0.36;
          const ly = !knocked ? 164 : lerp(164, 204, smoothstep((s - 0.36) / 0.64));
          actors.push({{ pid: 'shadow_0571', anim: 'Double', dir8: 1, tick: s * 65, wx: lerp(244, 266, Math.min(1, s * 2.5)), wy: lerp(164, 156, s), reflect: true, auraColor: 'rgba(168, 85, 247, 0.3)' }});
          actors.push({{ pid: 'shadow_0253', anim: 'Strike', dir8: 7, tick: s * 55, wx: lerp(378, 310, Math.min(1, s * 2.5)), wy: lerp(164, 156, s), reflect: true, auraColor: 'rgba(168, 85, 247, 0.3)' }});
          actors.push({{
            pid: '0448',
            anim: !knocked ? 'Hurt' : (s < 0.74 ? 'TumbleBack' : 'Pain'),
            dir8: 4,
            tick: ticks * 1.2,
            wx: 288,
            wy: ly,
            reflect: true,
          }});
          if (knocked) drawWaterRipplePixel(mCtx, 288, ly + 8, ((s - 0.36) / 0.64) * 32, 'rgba(165, 243, 252, 0.85)');
          camX = 288; camY = lerp(164, 184, s); camZ = 1.24;
          shake = s > 0.32 && s < 0.55 ? 3.5 : 0.0;
          if (s > 0.55) portraitOverlay = {{ pid: '0448', emo: 'Pain', side: 'left' }};

        }} else if (loc < 0.80) {{
          // IV-D : ÉRUPTION DU VITRAIL SOUS L'EAU MIROIR -> RIOLU & ÉVOLI BONDISSENT DANS L'ARÈNE !
          const s = (loc - 0.64) / 0.16;
          if (MAPS.vitrailDais.complete) {{
            mCtx.save();
            mCtx.globalAlpha = Math.min(0.88, s * 1.8) * (1.0 - Math.max(0, (s - 0.8) * 2));
            mCtx.drawImage(MAPS.vitrailDais, 288 - 84, 174 - 76, 168, 152);
            mCtx.restore();
          }}
          const leap = Math.min(1, s * 1.8);
          actors.push({{ pid: 'shadow_0571', anim: s > 0.45 ? 'Hurt' : 'Attack', dir8: 0, tick: ticks, wx: 260, wy: lerp(148, 134, s), reflect: true }});
          actors.push({{ pid: 'shadow_0253', anim: s > 0.45 ? 'Hurt' : 'Attack', dir8: 0, tick: ticks, wx: 316, wy: lerp(148, 134, s), reflect: true }});
          actors.push({{ pid: '0448', anim: s < 0.5 ? 'Wake' : 'Pose', dir8: 4, tick: ticks, wx: 288, wy: 192, reflect: true }});
          actors.push({{
            pid: '0447',
            anim: s < 0.45 ? 'Hop' : 'QuickStrike',
            dir8: 4,
            tick: s * 65,
            wx: lerp(288, 260, leap),
            wy: lerp(176, 154, leap),
            zLift: s < 0.45 ? Math.sin((s / 0.45) * Math.PI) * 22 : 0,
            reflect: true,
            auraColor: 'rgba(56, 189, 248, 0.28)',
          }});
          actors.push({{
            pid: '0133',
            anim: s < 0.45 ? 'Hop' : 'Double',
            dir8: 4,
            tick: s * 65,
            wx: lerp(288, 316, leap),
            wy: lerp(176, 154, leap),
            zLift: s < 0.45 ? Math.sin((s / 0.45) * Math.PI) * 22 : 0,
            reflect: true,
            auraColor: 'rgba(251, 191, 36, 0.28)',
          }});
          fxDraw = () => {{
            if (s >= 0.42) {{
              drawSlashArcPixel(mCtx, 260, 142, -Math.PI * 0.5, 24, (s - 0.42) / 0.58, '#38bdf8', '#ffffff');
              drawSlashArcPixel(mCtx, 316, 142, -Math.PI * 0.5, 24, (s - 0.42) / 0.58, '#f59e0b', '#fef9c3');
            }}
          }};
          camX = 288; camY = 164; camZ = 1.22;
          if (s < 0.16) screenFlash = (1.0 - s / 0.16) * 0.92;
          portraitOverlay = {{ pid: '0447', emo: 'Determined', side: 'right' }};

        }} else {{
          // IV-E : COMBO TRIO SYNCHRONISÉ (Lucario + Riolu + Évoli) + Vol de Latias & Latios -> Bris des Ombres !
          const s = (loc - 0.80) / 0.20;
          const shAlpha = Math.max(0, 1.0 - Math.max(0, (s - 0.52) / 0.42));
          actors.push({{ pid: 'shadow_0571', anim: 'Hurt', dir8: 0, tick: ticks, wx: 256, wy: lerp(134, 114, s), reflect: true, alpha: shAlpha }});
          actors.push({{ pid: 'shadow_0253', anim: 'Hurt', dir8: 0, tick: ticks, wx: 320, wy: lerp(134, 114, s), reflect: true, alpha: shAlpha }});

          actors.push({{ pid: '0447', anim: 'RearUp', dir8: 4, tick: s * 52, wx: 258, wy: 164, reflect: true, auraColor: 'rgba(56, 189, 248, 0.28)' }});
          actors.push({{ pid: '0133', anim: 'Shoot', dir8: 4, tick: s * 52, wx: 318, wy: 164, reflect: true, auraColor: 'rgba(251, 191, 36, 0.28)' }});
          actors.push({{ pid: '0448', anim: 'RearUp', dir8: 4, tick: s * 52, wx: 288, wy: 158, reflect: true, auraColor: 'rgba(125, 249, 255, 0.34)' }});

          // Latias & Latios traversant majestueusement l'arène en diagonale
          actors.push({{ pid: '0380', anim: 'Walk', dir8: 3, tick: ticks * 1.4, wx: lerp(155, 415, s), wy: lerp(215, 78, s), zLift: 16, noShadow: true }});
          actors.push({{ pid: '0381', anim: 'Walk', dir8: 3, tick: ticks * 1.4, wx: lerp(135, 395, s), wy: lerp(232, 92, s), zLift: 18, noShadow: true }});

          fxDraw = () => {{
            if (s > 0.28) {{
              const b = (s - 0.28) / 0.72;
              const by = lerp(152, 112, Math.min(1, b * 1.5));
              const r = 8 + b * 28;
              const g = mCtx.createRadialGradient(288, by, 2, 288, by, r);
              g.addColorStop(0, 'rgba(255, 255, 255, 0.96)');
              g.addColorStop(0.5, 'rgba(56, 189, 248, 0.78)');
              g.addColorStop(1, 'rgba(251, 191, 36, 0)');
              mCtx.fillStyle = g;
              mCtx.beginPath();
              mCtx.arc(288, by, r, 0, Math.PI * 2);
              mCtx.fill();
            }}
          }};
          camX = 288; camY = 148; camZ = lerp(1.22, 1.08, s);
          shake = s > 0.45 && s < 0.78 ? 2.6 : 0.0;
          if (s > 0.85) screenFlash = ((s - 0.85) / 0.15) * 0.95;
        }}

        actors.forEach((a) => drawActorOnMap(mCtx, a, tSec, 'reflection'));
        actors.sort((a, b) => a.wy - b.wy).forEach((a) => drawActorOnMap(mCtx, a, tSec, 'main'));
        if (fxDraw) fxDraw();
        blitMapCameraToScreen(camX, camY, camZ, shake, tSec);

      // -----------------------------------------------------------------------
      // ACTE V (0.67 .. 0.83) : OPM4 PLATEFORME ASTRALE — RONDE À 3, DARKRAI & BARRIÈRE
      // -----------------------------------------------------------------------
      }} else if (u < 0.83) {{
        document.getElementById('lblMap').textContent = 'OPM4 · Ciel Astral & Autel Étoilé (576×320)';
        if (MAPS.opm4.complete) mCtx.drawImage(MAPS.opm4, 0, 0, MW, MH);
        const loc = (u - 0.67) / 0.16;

        if (loc < 0.38) {{
          // Ronde joyeuse à trois pattes jointes sur l'étoile centrale (288, 162) — rotation 8 directions !
          const s = loc / 0.38;
          const baseAng = tSec * 2.8;
          const trio = [
            {{ pid: '0448', off: 0 }},
            {{ pid: '0253', off: (Math.PI * 2) / 3 }},
            {{ pid: '0251', off: (Math.PI * 4) / 3 }},
          ];
          trio.forEach((t) => {{
            const a = baseAng + t.off;
            const wx = 288 + Math.cos(a) * 24;
            const wy = 162 + Math.sin(a) * 16;
            // Regard tourné vers le centre de la ronde !
            actors.push({{
              pid: t.pid,
              anim: t.pid === '0251' ? 'Twirl' : 'Float',
              dir8: vecToDir8(288 - wx, 162 - wy),
              tick: ticks,
              wx,
              wy,
            }});
          }});
          actors.sort((a, b) => a.wy - b.wy).forEach((a) => drawActorOnMap(mCtx, a, tSec, 'main'));
          blitMapCameraToScreen(288, 162, lerp(1.12, 1.24, s), 0, tSec);
          if (s < 0.15) screenFlash = (1.0 - s / 0.15) * 0.85;
          portraitOverlay = {{ pid: '0253', emo: 'Joyous', side: 'left' }};

        }} else if (loc < 0.68) {{
          // Darkrai surgit au nord (288, 92) et libère l'onde de choc du Néant Noir !
          const s = (loc - 0.38) / 0.30;
          actors.push({{
            pid: '0491',
            anim: s < 0.35 ? 'RearUp' : 'Shoot',
            dir8: 0,
            tick: s * 75,
            wx: 288,
            wy: 92,
            auraColor: 'rgba(153, 27, 27, 0.32)',
          }});
          const blast = Math.max(0, (s - 0.28) / 0.72);
          actors.push({{ pid: '0253', anim: blast > 0 ? 'Hurt' : 'Idle', dir8: 4, tick: ticks, wx: lerp(266, 232, blast), wy: lerp(156, 146, blast) }});
          actors.push({{ pid: '0251', anim: blast > 0 ? 'Hurt' : 'Idle', dir8: 4, tick: ticks, wx: lerp(310, 344, blast), wy: lerp(156, 146, blast) }});
          actors.push({{ pid: '0448', anim: blast > 0 ? 'Hurt' : 'Idle', dir8: 4, tick: ticks, wx: 288, wy: lerp(168, 198, blast) }});

          actors.sort((a, b) => a.wy - b.wy).forEach((a) => drawActorOnMap(mCtx, a, tSec, 'main'));
          if (blast > 0) {{
            mCtx.save();
            mCtx.strokeStyle = `rgba(220, 38, 38, ${{(1.0 - blast * 0.7).toFixed(2)}})`;
            mCtx.lineWidth = 3;
            mCtx.beginPath();
            mCtx.arc(288, 112, blast * 115, 0, Math.PI * 2);
            mCtx.stroke();
            mCtx.restore();
          }}
          blitMapCameraToScreen(288, 146, 1.14, blast > 0 && blast < 0.45 ? 3.4 : 0.0, tSec);
          portraitOverlay = {{ pid: '0251', emo: 'Stunned', side: 'right' }};

        }} else {{
          // Sacrifice protecteur façon Aqua : Lucario projette 2 sphères Protect hexagonales autour de Massko & Celebi
          // qui s'élèvent vers le pont d'étoiles NE tandis que Lucario coule doucement au sud !
          const s = (loc - 0.68) / 0.32;
          const mx = lerp(232, 368, s), my = lerp(146, 86, s);
          const cx2 = lerp(344, 404, s), cy2 = lerp(146, 72, s);
          actors.push({{ pid: '0491', anim: 'Idle', dir8: 0, tick: ticks, wx: 288, wy: 92, alpha: Math.max(0, 1.0 - s * 1.6) }});
          actors.push({{ pid: '0253', anim: 'Float', dir8: 3, tick: ticks, wx: mx, wy: my, noShadow: true }});
          actors.push({{ pid: '0251', anim: 'Float', dir8: 3, tick: ticks, wx: cx2, wy: cy2, noShadow: true }});
          actors.push({{
            pid: '0448',
            anim: s < 0.42 ? 'RearUp' : 'Sink',
            dir8: 4,
            tick: ticks,
            wx: 288,
            wy: lerp(198, 246, Math.max(0, (s - 0.35) / 0.65)),
            noShadow: s > 0.45,
          }});
          actors.sort((a, b) => a.wy - b.wy).forEach((a) => drawActorOnMap(mCtx, a, tSec, 'main'));
          drawProtectHexSphere(mCtx, mx, my - 2, 16, tSec);
          drawProtectHexSphere(mCtx, cx2, cy2 - 2, 16, tSec);
          blitMapCameraToScreen(lerp(288, 304, s), lerp(156, 178, s), 1.12, 0, tSec);
          portraitOverlay = {{ pid: '0448', emo: 'Sigh', side: 'left' }};
          if (s > 0.85) screenFlash = -((s - 0.85) / 0.15) * 0.7;
        }}

      // -----------------------------------------------------------------------
      // ACTE VI (0.83 .. 1.00) : OPM5 PROMONTOIRE -> PATTE PLONGÉE DANS L'OCÉAN ->
      // PANORAMIQUE ÉCRAN-TITRE PMD SKY + LOGO PLEIN CENTRE & BATTEMENT D'AILES !
      // -----------------------------------------------------------------------
      }} else {{
        const loc = (u - 0.83) / 0.17;

        if (loc < 0.42) {{
          // VI-A : Riolu & Évoli courent jusqu'à la pointe du promontoire fleuri (OPM5) ;
          // un Rayon d'Espoir brille sous les vagues -> Riolu plonge la patte tendue et saisit celle de Lucario !
          document.getElementById('lblMap').textContent = 'OPM5 · Promontoire & Rayon d’Espoir Marin (576×320)';
          if (MAPS.opm5.complete) mCtx.drawImage(MAPS.opm5, 0, 0, MW, MH);
          const s = loc / 0.42;

          // Faisceau lumineux sous-marin au pied nord-est de la falaise (368, 108)
          const rayG = mCtx.createRadialGradient(368, 108, 4, 368, 108, 46);
          rayG.addColorStop(0, 'rgba(255, 255, 240, 0.92)');
          rayG.addColorStop(0.5, 'rgba(56, 189, 248, 0.55)');
          rayG.addColorStop(1, 'rgba(56, 189, 248, 0)');
          mCtx.fillStyle = rayG;
          mCtx.beginPath();
          mCtx.arc(368, 108, 46, 0, Math.PI * 2);
          mCtx.fill();

          const dive = Math.max(0, (s - 0.52) / 0.48);
          const rx = dive === 0 ? lerp(256, 342, s / 0.52) : lerp(342, 364, dive);
          const ry = dive === 0 ? lerp(212, 148, s / 0.52) : lerp(148, 114, dive);
          actors.push({{ pid: '0133', anim: dive > 0 ? 'Pose' : 'Walk', dir8: 3, tick: ticks * 1.2, wx: lerp(236, 322, Math.min(1, s / 0.55)), wy: lerp(224, 158, Math.min(1, s / 0.55)) }});
          if (dive > 0.25) {{
            // Lucario remonte vers la surface à la rencontre de la patte de Riolu !
            actors.push({{ pid: '0448', anim: 'Pose', dir8: 4, tick: ticks, wx: 368, wy: lerp(134, 116, dive), reflect: true, alpha: Math.min(1, dive * 1.5) }});
          }}
          actors.push({{
            pid: '0447',
            anim: dive === 0 ? 'Walk' : (dive < 0.55 ? 'LeapForth' : 'Pull'),
            dir8: 3,
            tick: ticks * 1.3,
            wx: rx,
            wy: ry,
            zLift: dive > 0 && dive < 0.55 ? Math.sin((dive / 0.55) * Math.PI) * 16 : 0,
          }});
          if (dive > 0.35) {{
            drawWaterRipplePixel(mCtx, 366, 114, (dive - 0.35) * 52, 'rgba(255, 255, 255, 0.95)');
          }}
          actors.sort((a, b) => a.wy - b.wy).forEach((a) => drawActorOnMap(mCtx, a, tSec, 'main'));
          blitMapCameraToScreen(lerp(295, 352, s), lerp(182, 126, s), lerp(1.08, 1.26, s), 0, tSec);
          if (dive > 0.25) drawPixelBubblesOnScreen(tSec, 48, 1.8, 0.85);
          portraitOverlay = {{ pid: dive < 0.45 ? '0448' : '0447', emo: dive < 0.45 ? 'Surprised' : 'Inspired', side: 'left' }};
          if (s > 0.84) screenFlash = ((s - 0.84) / 0.16) * 0.96;

        }} else {{
          // VI-B : PANORAMIQUE VERTICAL DE L'OCÉAN VERS LE CIEL/MER PMD SKY (.DIR JOUR/NUIT) +
          // ARRIVÉE EN UNE SEULE FOIS PLEIN CENTRE (480, 360 <-> 160, 120) & BATTEMENT SUBTIL DES 2 AILES !
          document.getElementById('lblMap').textContent =
            theme === 'jour' ? 'Title_Screen_Background_Jour.dir (320×240)' : 'Title_Screen_Background_Nuit.dir (320×240)';
          const s = (loc - 0.42) / 0.58;
          const atlas = theme === 'jour' ? MAPS.dayAtlas : MAPS.nightAtlas;
          if (atlas.complete && atlas.naturalWidth > 0) {{
            const pose = Math.floor(tSec * 12.0) % 24;
            const ax = (pose % 6) * 320, ay = Math.floor(pose / 6) * 240;
            vCtx.clearRect(0, 0, VW, VH);
            vCtx.drawImage(atlas, ax, ay, 320, 240, 0, 0, VW, VH);
          }}
          if (s < 0.16) {{
            // Fondu lumineux de percée de la surface océanique + dernières bulles montant au ciel
            drawPixelBubblesOnScreen(tSec, 36, 2.0, (1.0 - s / 0.16) * 0.85);
            screenFlash = (1.0 - s / 0.16) * 0.85;
          }}
          document.getElementById('lblCam').textContent = '320×240 Natif PMDO (×3)';
        }}
      }}

      // Portrait PMDO éventuel sur vCtx (320x240)
      if (portraitOverlay) {{
        drawPMDPortrait(portraitOverlay.pid, portraitOverlay.emo, portraitOverlay.side, 0.96);
      }}

      // Flash blanc ou fondu noir sur vCtx
      if (screenFlash > 0.01) {{
        vCtx.fillStyle = `rgba(255, 253, 242, ${{Math.min(1, screenFlash).toFixed(3)}})`;
        vCtx.fillRect(0, 0, VW, VH);
      }} else if (screenFlash < -0.01) {{
        vCtx.fillStyle = `rgba(2, 6, 18, ${{Math.min(1, -screenFlash).toFixed(3)}})`;
        vCtx.fillRect(0, 0, VW, VH);
      }}

      // Blit 3x pixel-perfect (320x240 -> 960x720) plein centre !
      outCtx.imageSmoothingEnabled = false;
      outCtx.clearRect(0, 0, outCanvas.width, outCanvas.height);
      outCtx.drawImage(vCanvas, 0, 0, VW, VH, 0, 0, outCanvas.width, outCanvas.height);

      // Si on est dans VI-B (u >= 0.83 + 0.17*0.42 = 0.9014), dessin du Blason Articulé plein centre (480, 360) !
      const titleThreshold = 0.83 + 0.17 * 0.42;
      if (u >= titleThreshold) {{
        const revealSec = (u - titleThreshold) * durationSec;
        wingDeg = drawArticulatedLogoOnOut(outCanvas.width * 0.5, outCanvas.height * 0.5, 158 * 3, revealSec, nowSec);
        if (revealSec > 1.25 && MAPS.enterUI.complete && MAPS.enterUI.naturalWidth > 0) {{
          const blink = 0.45 + 0.55 * (0.5 + 0.5 * Math.sin(tSec * 5.0));
          outCtx.save();
          outCtx.imageSmoothingEnabled = false;
          outCtx.globalAlpha = blink;
          outCtx.drawImage(MAPS.enterUI, (outCanvas.width - 74 * 3) / 2, 196 * 3, 74 * 3, 11 * 3);
          outCtx.restore();
        }}
      }}

      drawCrosshairIfChecked();
      document.getElementById('lblWingDeg').textContent = (wingDeg >= 0 ? '+' : '') + wingDeg.toFixed(1) + '°';
    }}

    function renderDirectTitleMode(nowSec) {{
      document.getElementById('lblMap').textContent =
        theme === 'jour' ? 'Title_Screen_Background_Jour.dir (320×240)' : 'Title_Screen_Background_Nuit.dir (320×240)';
      document.getElementById('lblCam').textContent = '320×240 Natif PMDO (×3)';
      const tSec = nowSec - titleModeRevealStart;
      const atlas = theme === 'jour' ? MAPS.dayAtlas : MAPS.nightAtlas;
      if (atlas.complete && atlas.naturalWidth > 0) {{
        const pose = Math.floor(nowSec * 12.0) % 24;
        const ax = (pose % 6) * 320, ay = Math.floor(pose / 6) * 240;
        vCtx.clearRect(0, 0, VW, VH);
        vCtx.drawImage(atlas, ax, ay, 320, 240, 0, 0, VW, VH);
      }}
      outCtx.imageSmoothingEnabled = false;
      outCtx.drawImage(vCanvas, 0, 0, VW, VH, 0, 0, outCanvas.width, outCanvas.height);

      const wingDeg = drawArticulatedLogoOnOut(outCanvas.width * 0.5, outCanvas.height * 0.5, 158 * 3, tSec, nowSec);
      if (tSec > 1.20 && MAPS.enterUI.complete && MAPS.enterUI.naturalWidth > 0) {{
        const blink = 0.45 + 0.55 * (0.5 + 0.5 * Math.sin(nowSec * 5.0));
        outCtx.save();
        outCtx.imageSmoothingEnabled = false;
        outCtx.globalAlpha = blink;
        outCtx.drawImage(MAPS.enterUI, (outCanvas.width - 74 * 3) / 2, 196 * 3, 74 * 3, 11 * 3);
        outCtx.restore();
      }}
      drawCrosshairIfChecked();
      document.getElementById('lblWingDeg').textContent = (wingDeg >= 0 ? '+' : '') + wingDeg.toFixed(1) + '°';
    }}

    function drawCrosshairIfChecked() {{
      if (!document.getElementById('chkCenterCrosshair').checked) return;
      const cw = outCanvas.width, ch = outCanvas.height;
      outCtx.save();
      outCtx.strokeStyle = 'rgba(56, 189, 248, 0.80)';
      outCtx.setLineDash([6, 6]);
      outCtx.lineWidth = 1.5;
      outCtx.beginPath();
      outCtx.moveTo(cw / 2, 0); outCtx.lineTo(cw / 2, ch);
      outCtx.moveTo(0, ch / 2); outCtx.lineTo(cw, ch / 2);
      outCtx.stroke();
      outCtx.fillStyle = '#fbbf24';
      outCtx.beginPath();
      outCtx.arc(cw / 2, ch / 2, 5, 0, Math.PI * 2);
      outCtx.fill();
      outCtx.restore();
    }}

    // =========================================================================
    // BOUCLE 60 FPS & CONTRÔLES UI
    // =========================================================================
    function fmtTime(s) {{
      return String(Math.floor(s / 60)).padStart(2, '0') + ':' + String(Math.floor(s % 60)).padStart(2, '0');
    }}

    const scrubEl = document.getElementById('timeScrub');
    const readoutEl = document.getElementById('timeReadout');
    const chapBtns = Array.from(document.querySelectorAll('.chap-btn'));
    const localAudio = document.getElementById('localAudioEl');

    function frameLoop(nowMs) {{
      const dt = Math.min(0.08, Math.max(0.0, (nowMs - lastNow) / 1000.0));
      lastNow = nowMs;
      const nowSec = nowMs / 1000.0;

      if (viewMode === 'opening') {{
        if (!paused && !scrubbing) {{
          if (audioSource === 'youtube' && ytPlayer && typeof ytPlayer.getCurrentTime === 'function') {{
            const st = ytPlayer.getPlayerState ? ytPlayer.getPlayerState() : -1;
            if (st === 1) {{
              curTime = ytPlayer.getCurrentTime();
              const yd = ytPlayer.getDuration();
              if (yd && yd > 30) durationSec = yd;
            }} else if (st === 0) {{
              curTime = durationSec;
            }} else {{
              curTime = Math.min(durationSec, curTime + dt);
            }}
          }} else if (audioSource === 'local' && !localAudio.paused) {{
            curTime = localAudio.currentTime;
            if (localAudio.duration && isFinite(localAudio.duration)) durationSec = localAudio.duration;
          }} else {{
            curTime = Math.min(durationSec, curTime + dt);
          }}
        }}

        const u = Math.min(1.0, Math.max(0.0, curTime / durationSec));
        tickSynth(u, curTime);
        renderPMDOpening(u, curTime, nowSec);

        if (!scrubbing) scrubEl.value = String(Math.round(u * 1000));
        readoutEl.textContent = `${{fmtTime(curTime)}} / ${{fmtTime(durationSec)}}`;

        const cuts = [0.0, 0.15, 0.31, 0.40, 0.67, 0.83, 1.01];
        chapBtns.forEach((b, idx) => b.classList.toggle('current', u >= cuts[idx] && u < cuts[idx + 1]));
      }} else {{
        renderDirectTitleMode(nowSec);
      }}

      requestAnimationFrame(frameLoop);
    }}

    document.getElementById('btnPlayCinema').addEventListener('click', () => {{
      ensureAudioCtx();
      if (ytPlayer && ytPlayer.pauseVideo) ytPlayer.pauseVideo();
      localAudio.pause();
      viewMode = 'opening';
      audioSource = 'synth';
      durationSec = 56.0;
      curTime = 0.0;
      synthStepPlayed = -1;
      paused = false;
      document.getElementById('btnModeTitle').classList.remove('active');
      document.getElementById('audioModeLabel').textContent =
        '🎹 Audio actif : Synthé WebAudio « Ray of Hope » 128 BPM intégré (Coupe PMD 00:56)';
    }});

    document.getElementById('btnPlayYT').addEventListener('click', () => {{
      localAudio.pause();
      document.getElementById('btnModeTitle').classList.remove('active');
      activateYouTubeSync();
    }});

    document.getElementById('btnModeTitle').addEventListener('click', () => {{
      ensureAudioCtx();
      if (ytPlayer && ytPlayer.pauseVideo) ytPlayer.pauseVideo();
      localAudio.pause();
      viewMode = 'title320';
      titleModeRevealStart = performance.now() / 1000.0;
      paused = false;
      document.getElementById('btnModeTitle').classList.add('active');
      playSupersaw([53, 60, 65, 69, 72], 1.8, 0.02);
    }});

    document.getElementById('btnFlapNow').addEventListener('click', () => {{
      ensureAudioCtx();
      manualFlapStart = performance.now() / 1000.0;
      playNote(m2f(79), 0.35, 0.04, 'triangle', 3800);
    }});

    document.getElementById('btnThemeDay').addEventListener('click', () => {{
      theme = 'jour';
      document.getElementById('btnThemeDay').classList.add('active');
      document.getElementById('btnThemeNight').classList.remove('active');
    }});

    document.getElementById('btnThemeNight').addEventListener('click', () => {{
      theme = 'nuit';
      document.getElementById('btnThemeNight').classList.add('active');
      document.getElementById('btnThemeDay').classList.remove('active');
    }});

    document.getElementById('btnPause').addEventListener('click', (ev) => {{
      paused = !paused;
      ev.currentTarget.textContent = paused ? '▶ Reprendre' : '⏸ Pause';
      if (audioSource === 'youtube' && ytPlayer) {{
        if (paused && ytPlayer.pauseVideo) ytPlayer.pauseVideo();
        else if (!paused && ytPlayer.playVideo) ytPlayer.playVideo();
      }} else if (audioSource === 'local') {{
        if (paused) localAudio.pause();
        else localAudio.play();
      }}
    }});

    scrubEl.addEventListener('input', () => {{
      scrubbing = true;
      viewMode = 'opening';
      curTime = (Number(scrubEl.value) / 1000.0) * durationSec;
    }});
    scrubEl.addEventListener('change', () => {{
      curTime = (Number(scrubEl.value) / 1000.0) * durationSec;
      if (audioSource === 'youtube' && ytPlayer && ytPlayer.seekTo) ytPlayer.seekTo(curTime, true);
      if (audioSource === 'local') localAudio.currentTime = curTime;
      scrubbing = false;
    }});

    chapBtns.forEach((btn) => {{
      btn.addEventListener('click', () => {{
        ensureAudioCtx();
        viewMode = 'opening';
        document.getElementById('btnModeTitle').classList.remove('active');
        curTime = Number(btn.dataset.jump || '0') * durationSec;
        synthStepPlayed = -1;
        paused = false;
        if (audioSource === 'youtube' && ytPlayer && ytPlayer.seekTo) ytPlayer.seekTo(curTime, true);
        if (audioSource === 'local') localAudio.currentTime = curTime;
      }});
    }});

    document.getElementById('localAudioInput').addEventListener('change', (ev) => {{
      const f = ev.target.files && ev.target.files[0];
      if (!f) return;
      if (ytPlayer && ytPlayer.pauseVideo) ytPlayer.pauseVideo();
      localAudio.src = URL.createObjectURL(f);
      localAudio.onloadedmetadata = () => {{
        audioSource = 'local';
        viewMode = 'opening';
        durationSec = localAudio.duration || 153.0;
        curTime = 0.0;
        paused = false;
        localAudio.play();
        document.getElementById('audioModeLabel').textContent =
          `🎵 Audio local synchronisé : ${{f.name}} (${{fmtTime(durationSec)}})`;
      }};
    }});

    window.addEventListener('pointerdown', () => ensureAudioCtx(), {{ once: true }});
    requestAnimationFrame(frameLoop);
  }})();
  </script>
</body>
</html>
"""


def inline_assets(html: str) -> str:
    """Intègre chaque image référencée par un chemin absolu `/renders/...` (avec `?v=hash`) en `data:` URI :
    la page devient autonome et se lance aussi dans l'aperçu (iframe) où les chemins absolus ne résolvent pas."""
    import base64
    import re

    cache: dict = {}

    def sub(m: "re.Match") -> str:
        rel = m.group(1)
        if rel not in cache:
            f = REPO_ROOT / rel.lstrip("/")
            if f.is_file():
                import io

                from PIL import Image

                buf = io.BytesIO()
                Image.open(f).convert("RGBA").save(buf, format="WEBP", lossless=True)  # WEBP sans perte : ~2× plus léger que le PNG
                cache[rel] = "data:image/webp;base64," + base64.b64encode(buf.getvalue()).decode("ascii")
            else:
                cache[rel] = rel
        return '"' + cache[rel] + '"'

    return re.sub(r'"(/renders/[^"?]+\.png)(?:\?v=[0-9a-f]+)?"', sub, html)


def main() -> None:
    out_path = REPO_ROOT / "apercu_fangame_pmd_destiny_pixel_opm.html"
    out_path.write_text(inline_assets(build_destiny_html()), encoding="utf-8")
    print(f"OK — {out_path} généré ({out_path.stat().st_size:,} octets)")


if __name__ == "__main__":
    main()
