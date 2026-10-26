#!/usr/bin/env python3
"""Met à jour `apercu_cliff_nord_nuit_pmdo.html` pour afficher les cartes `cliffdaytest` et
`cliffnordouesttest1` en version **JOUR & NUIT côte à côte (animés en temps réel)** ainsi qu'en
vue plein format `☀️ Jour Animé`, `🌙 Nuit Animée` et `☀️ Jour d'origine statique`, avec les
78 calques/frames PNG embarqués en data-URI pour un affichage instantané et 100 % autonome.
"""
from __future__ import annotations

import base64
import json
from pathlib import Path

ROOT = Path("/home/user/projet-creation-pmdo")
OUT_DIR = ROOT / "livrables_cliff_nord_nuit_pmdo"
HTML_PATH = ROOT / "apercu_cliff_nord_nuit_pmdo.html"


def collect_embedded_pngs() -> dict[str, str]:
    rels: set[str] = set()
    for sub in ("viewer_layers_1x", "png_1x", "calques_nuit_1x"):
        d = OUT_DIR / sub
        for p in sorted(d.glob("*.png")):
            rels.add(f"livrables_cliff_nord_nuit_pmdo/{sub}/{p.name}")
    out: dict[str, str] = {}
    for rel in sorted(rels):
        raw = (ROOT / rel).read_bytes()
        out[rel] = "data:image/png;base64," + base64.b64encode(raw).decode("ascii")
    return out


HTML_TEMPLATE = """<!doctype html>
<html lang="fr">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Maps Cliff Nord (Jour &amp; Nuit Animés Côte à Côte) — Nuages 3 Plans &amp; Mer 8 Phases (PMDO 0.8.12)</title>
  <style>
    :root {
      --bg: #0d111a;
      --slate: #161b26;
      --card: #192131;
      --border: #2a3752;
      --gold: #f6c453;
      --indigo: #818cf8;
      --mint: #34d399;
      --text: #eaf0fa;
      --muted: #98a7c2;
    }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      font: 15px/1.6 system-ui, -apple-system, Segoe UI, Roboto, sans-serif;
      background: var(--bg);
      color: var(--text);
    }
    header {
      background: linear-gradient(180deg, #182238 0%, #101522 100%);
      border-bottom: 1px solid var(--border);
      padding: 24px 20px 20px;
    }
    .wrap { max-width: 1540px; margin: 0 auto; padding: 0 18px; }
    h1 { margin: 0 0 8px; font-size: 26px; color: #fff; }
    h2 { margin: 30px 0 12px; font-size: 20px; color: var(--gold); border-bottom: 1px solid var(--border); padding-bottom: 8px; }
    h3 { margin: 0 0 6px; font-size: 15px; color: #fff; }
    p { margin: 6px 0; color: var(--muted); }
    .badges { display: flex; flex-wrap: wrap; gap: 8px; margin: 12px 0 14px; }
    .badge {
      padding: 4px 11px; border-radius: 999px; font-size: 12.5px; font-weight: 600;
      background: #212c42; color: #dce7ff; border: 1px solid #354668;
    }
    .badge.ok { background: #133329; color: #6ee7b7; border-color: #215747; }
    .badge.night { background: #1e2246; color: #c7d2fe; border-color: #3d4685; }
    .actions { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 12px; }
    .btn {
      display: inline-block; padding: 8px 15px; border-radius: 8px; text-decoration: none;
      font-weight: 700; font-size: 13px; cursor: pointer; border: 1px solid transparent;
    }
    .btn-primary { background: var(--gold); color: #141720; }
    .btn-secondary { background: #222d44; color: var(--text); border-color: #394b70; }
    .map-block {
      background: var(--card); border: 1px solid var(--border); border-radius: 14px;
      padding: 18px; margin-top: 16px;
    }
    .toolbar {
      display: flex; flex-wrap: wrap; gap: 8px; align-items: center; margin-bottom: 12px;
    }
    .toolbar button {
      background: #222d44; color: var(--text); border: 1px solid #384a6e;
      padding: 7px 13px; border-radius: 7px; cursor: pointer; font-weight: 600; font-size: 13px;
    }
    .toolbar button.active {
      background: var(--gold); color: #141720; border-color: var(--gold);
    }
    .toggles {
      display: flex; flex-wrap: wrap; gap: 14px; align-items: center;
      margin-bottom: 12px; padding: 8px 12px; background: #131926;
      border: 1px solid #26334d; border-radius: 8px; font-size: 13px; color: var(--text);
    }
    .toggles label { display: inline-flex; align-items: center; gap: 6px; cursor: pointer; user-select: none; }
    .toggles input { accent-color: var(--gold); cursor: pointer; }
    .stage {
      background: #161b26;
      border: 1px solid #29354f;
      border-radius: 10px;
      padding: 14px;
      display: flex;
      justify-content: center;
      align-items: flex-start;
      overflow-x: auto;
    }
    .stage img {
      image-rendering: pixelated;
      image-rendering: crisp-edges;
      display: block;
      max-width: 100%;
      height: auto;
    }
    .dual-grid {
      display: flex;
      flex-wrap: wrap;
      gap: 16px;
      justify-content: center;
      align-items: flex-start;
      width: 100%;
    }
    .viewport-card {
      background: #111622;
      border: 1px solid #2b3956;
      border-radius: 10px;
      padding: 10px;
      display: flex;
      flex-direction: column;
      align-items: center;
    }
    .viewport-title {
      width: 100%;
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 8px;
      padding: 4px 10px;
      border-radius: 6px;
      font-weight: 700;
      font-size: 13px;
    }
    .viewport-title.day {
      background: linear-gradient(90deg, rgba(246,196,83,0.22), rgba(56,189,248,0.12));
      color: #fde68a;
      border: 1px solid rgba(246,196,83,0.45);
    }
    .viewport-title.night {
      background: linear-gradient(90deg, rgba(129,140,248,0.25), rgba(30,41,59,0.4));
      color: #c7d2fe;
      border: 1px solid rgba(129,140,248,0.45);
    }
    /* Scène PMDO 0.8.12 multi-calques temps réel en balises DOM pures (100 % net au pixel près) */
    .pmdo-viewport-wrap {
      position: relative;
      flex: 0 0 auto;
      overflow: hidden;
      background: #161b26;
      border-radius: 6px;
    }
    .pmdo-scene {
      position: relative;
      transform-origin: top left;
      overflow: hidden;
      background: #161b26;
      image-rendering: pixelated;
      image-rendering: crisp-edges;
    }
    .pmdo-scene .lyr {
      position: absolute;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      pointer-events: none;
      image-rendering: pixelated;
      image-rendering: crisp-edges;
    }
    .pmdo-scene .lyr-cloud-64 {
      position: absolute;
      left: 0;
      width: 100%;
      height: 64px;
      background-repeat: repeat-x;
      background-size: 1440px 64px;
      pointer-events: none;
      image-rendering: pixelated;
      image-rendering: crisp-edges;
      will-change: background-position;
    }
    .pmdo-scene .lyr-cloud-96 {
      position: absolute;
      left: 0;
      width: 100%;
      height: 96px;
      background-repeat: repeat-x;
      background-size: 1440px 96px;
      pointer-events: none;
      image-rendering: pixelated;
      image-rendering: crisp-edges;
      will-change: background-position;
    }
    .telemetry {
      font-family: ui-monospace, SFMono-Regular, Menlo, monospace;
      font-size: 12.5px;
      color: #9ee6c9;
      background: #10241e;
      border: 1px solid #215747;
      padding: 5px 11px;
      border-radius: 7px;
      margin-top: 10px;
      display: inline-block;
    }
    .meta {
      display: flex; flex-wrap: wrap; gap: 8px; margin-top: 10px; font-size: 12.5px; color: var(--muted);
    }
    .meta span {
      background: #131824; padding: 3px 9px; border-radius: 6px; border: 1px solid #26324a;
    }
    .layers-grid {
      display: grid; grid-template-columns: repeat(auto-fill, minmax(290px, 1fr));
      gap: 14px; margin-top: 16px;
    }
    .layer-card {
      background: #141a27; border: 1px solid #27334c; border-radius: 10px; padding: 12px;
    }
    .layer-card .stage { padding: 10px; min-height: 150px; }
    .dl { color: var(--gold); text-decoration: none; font-weight: 600; font-size: 12.5px; }
    .dl:hover { text-decoration: underline; }
    footer {
      border-top: 1px solid var(--border); margin-top: 40px; padding: 20px 0 36px;
      font-size: 13px; color: var(--muted);
    }
  </style>
</head>
<body>
<header>
  <div class="wrap">
    <h1><code>cliffdaytest</code> &amp; <code>cliffnordouesttest1</code> — Version JOUR &amp; Version NUIT Animées (PMDO 0.8.12)</h1>
    <p>
      Comparaison directe <strong>☀️ JOUR &amp; 🌙 NUIT côte à côte</strong> et plein format <code>1×</code> des deux cartes
      (<code>cliffdaytest.rsground</code> <code>984 × 792 px</code> et <code>cliffnordouesttest1.rsground</code> <code>1104 × 784 px</code>) :
      <strong>LUT Halcyon officielle à 3 133 couleurs canoniques exactes</strong> (5 paires <code>Metano_Town_*</code> / <code>*_Night.tile</code>),
      <strong>3 plans de nuages en défilement continu horizontal sans couture</strong> (<code>LayeredBG</code> · <code>RepeatX = true</code>),
      <strong>mer animée sur ses 8 phases complètes</strong> (<code>FrameLength = 10</code> à 60 Hz)
      et <strong>étang, bannières, moulin, fleurs &amp; cascade animés en 4 phases</strong>.
    </p>
    <div class="badges">
      <span class="badge ok">☀️ Jour &amp; 🌙 Nuit Côte à Côte Synchronisés (60 Hz)</span>
      <span class="badge night">LUT Halcyon Officielle (3 133 couleurs canoniques · 5 paires Night.tile)</span>
      <span class="badge ok">Nuages Animés 3 Plans de Parallaxe (Horizon -5 · Milieu -9 · Haut -14 px/s)</span>
      <span class="badge night">Mer Animée 8 Phases + Cascades, Étang, Moulin &amp; Bannières 4 Phases</span>
      <span class="badge">Fond Ardoise #161b26 · 100 % Autonome &amp; Net Pixel-Art</span>
    </div>
    <div class="actions">
      <a class="btn btn-primary" href="livrables_cliff_nord_nuit_pmdo/PACK_CLIFF_NORD_NUIT_PMDO_0812.zip" download>
        ⬇ Pack Complet PMDO 0.8.12 (.ZIP — .rsground + .dir + .tile + INSTALLER.py + GIF/PNG)
      </a>
      <a class="btn btn-secondary" href="cliffdaytest.rsground" download>
        ⬇ cliffdaytest.rsground (Jour)
      </a>
      <a class="btn btn-secondary" href="livrables_cliff_nord_nuit_pmdo/MOD_CLIFF_NORD_NUIT_PMDO/Data/Ground/cliffdaytest_nuit.rsground" download>
        ⬇ cliffdaytest_nuit.rsground (Nuit)
      </a>
      <a class="btn btn-secondary" href="cliffnordouesttest1.rsground" download>
        ⬇ cliffnordouesttest1.rsground (Jour)
      </a>
      <a class="btn btn-secondary" href="livrables_cliff_nord_nuit_pmdo/MOD_CLIFF_NORD_NUIT_PMDO/Data/Ground/cliffnordouesttest1_nuit.rsground" download>
        ⬇ cliffnordouesttest1_nuit.rsground (Nuit)
      </a>
    </div>
  </div>
</header>

<main class="wrap">
  <!-- ==================== CARTE 1 : CLIFF NORD-EST ==================== -->
  <h2>1. <code>cliffdaytest</code> (Jour) &amp; <code>cliffdaytest_nuit</code> (Nuit) — Cliff Reverie Town Nord-Est (984 × 792 px · 123 × 99 tuiles)</h2>
  <div class="map-block"
       data-stem="cliffdaytest_nuit"
       data-w="984"
       data-h="792">
    <div class="toolbar">
      <button type="button" class="mode-btn active" data-mode="dual_anim">☀️/🌙 Côte à Côte Jour &amp; Nuit (Animés)</button>
      <button type="button" class="mode-btn" data-mode="jour_anim">☀️ Jour Animé (Plein format 1×)</button>
      <button type="button" class="mode-btn" data-mode="nuit_anim">🌙 Nuit Animée (Plein format 1×)</button>
      <button type="button" class="mode-btn" data-mode="jour_orig">☀️ Jour d'origine statique (Réf. 1:1)</button>
      <button type="button" class="play-btn">⏸ Pause</button>
      <span style="margin-left:8px;color:var(--muted);font-size:13px">Vent nuages :</span>
      <button type="button" class="wind-btn" data-wind="1">PMDO 1× (-5/-9/-14 px/s)</button>
      <button type="button" class="wind-btn active" data-wind="2.2">Brise 2.2× (aperçu vif)</button>
      <span style="margin-left:8px;color:var(--muted);font-size:13px">Zoom :</span>
      <button type="button" class="zoom-btn active" data-z="auto">Auto Côte-à-Côte / 1×</button>
      <button type="button" class="zoom-btn" data-z="1">1× (984×792)</button>
      <button type="button" class="zoom-btn" data-z="1.4">1.4×</button>
    </div>

    <div class="toggles">
      <strong style="color:var(--gold)">Calques actifs :</strong>
      <label><input type="checkbox" data-layer="sky" checked> Ciel &amp; Lune/Étoiles</label>
      <label><input type="checkbox" data-layer="clouds" checked> Nuages animés (3 plans parallaxe)</label>
      <label><input type="checkbox" data-layer="sea" checked> Mer animée (8 phases)</label>
      <label><input type="checkbox" data-layer="terrain" checked> Falaises, Village, Bannières &amp; Étang animé (4 phases)</label>
      <label><input type="checkbox" data-layer="canopy" checked> Canopée avant-plan (Layer=4)</label>
    </div>

    <div class="stage">
      <div class="dual-grid">
        <!-- Vue JOUR -->
        <div class="viewport-card card-day">
          <div class="viewport-title day">
            <span>☀️ VERSION JOUR ANIMÉE — <code>cliffdaytest</code></span>
            <span>984 × 792 px · Mer 8 phases · Nuages 3 plans</span>
          </div>
          <div class="pmdo-viewport-wrap wrap-day" style="width:984px;height:792px">
            <div class="pmdo-scene scene-day" style="width:984px;height:792px">
              <img class="lyr lyr-sky-day" data-asset="livrables_cliff_nord_nuit_pmdo/viewer_layers_1x/cliffdaytest_nuit_sky_jour.png" alt="Ciel Jour">
              <div class="lyr-cloud-64 lyr-cloud-horizon-day" style="top:240px"></div>
              <div class="lyr-cloud-96 lyr-cloud-milieu-day" style="top:134px"></div>
              <div class="lyr-cloud-96 lyr-cloud-haut-day" style="top:26px"></div>
              <img class="lyr lyr-sea-day" data-asset="livrables_cliff_nord_nuit_pmdo/viewer_layers_1x/cliffdaytest_nuit_sea_jour_0.png" alt="Mer Jour 8 phases">
              <img class="lyr lyr-terrain-day" data-asset="livrables_cliff_nord_nuit_pmdo/viewer_layers_1x/cliffdaytest_nuit_terrain_jour_0.png" alt="Terrain Jour">
              <img class="lyr lyr-canopy-day" data-asset="livrables_cliff_nord_nuit_pmdo/viewer_layers_1x/cliffdaytest_nuit_canopy_jour.png" alt="Canopée Jour">
              <img class="lyr lyr-dayorig" data-asset="livrables_cliff_nord_nuit_pmdo/png_1x/cliffdaytest_jour_ref.png" alt="Jour origine" style="display:none">
            </div>
          </div>
        </div>

        <!-- Vue NUIT -->
        <div class="viewport-card card-night">
          <div class="viewport-title night">
            <span>🌙 VERSION NUIT ANIMÉE — <code>cliffdaytest_nuit</code></span>
            <span>984 × 792 px · Lune &amp; Étoiles · LUT Halcyon</span>
          </div>
          <div class="pmdo-viewport-wrap wrap-night" style="width:984px;height:792px">
            <div class="pmdo-scene scene-night" style="width:984px;height:792px">
              <img class="lyr lyr-sky-night" data-asset="livrables_cliff_nord_nuit_pmdo/viewer_layers_1x/cliffdaytest_nuit_sky.png" alt="Ciel Nuit">
              <div class="lyr-cloud-64 lyr-cloud-horizon-night" style="top:240px"></div>
              <div class="lyr-cloud-96 lyr-cloud-milieu-night" style="top:134px"></div>
              <div class="lyr-cloud-96 lyr-cloud-haut-night" style="top:26px"></div>
              <img class="lyr lyr-sea-night" data-asset="livrables_cliff_nord_nuit_pmdo/viewer_layers_1x/cliffdaytest_nuit_sea_nuit_0.png" alt="Mer Nuit 8 phases">
              <img class="lyr lyr-terrain-night" data-asset="livrables_cliff_nord_nuit_pmdo/viewer_layers_1x/cliffdaytest_nuit_terrain_nuit_0.png" alt="Terrain Nuit">
              <img class="lyr lyr-canopy-night" data-asset="livrables_cliff_nord_nuit_pmdo/viewer_layers_1x/cliffdaytest_nuit_canopy_nuit.png" alt="Canopée Nuit">
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="telemetry">▶ En cours · Mer phase 1/8 · Nuages hauts 0 px · milieu 0 px · horizon 0 px</div>
    <div class="meta">
      <span>Ground Jour : <code>cliffdaytest.rsground</code></span>
      <span>Ground Nuit : <code>Data/Ground/cliffdaytest_nuit.rsground</code></span>
      <span>BG animés : <code>CLIFF_NE_NUIT_CIEL/ASTRES.dir</code> + <code>CLIFF_NUIT_NUAGES_{HORIZON,MILIEU,HAUT}.dir</code></span>
      <span>Tilesheet : <code>Content/Tile/CliffNE_Nuit.tile</code></span>
    </div>

    <h3 style="margin-top:18px">Calques séparés Nuit 1× (PNG RGBA transparents)</h3>
    <div class="layers-grid">
      <div class="layer-card">
        <h3>BG 00 · Ciel nocturne velouté, Lune &amp; Étoiles</h3>
        <div class="stage"><img data-asset="livrables_cliff_nord_nuit_pmdo/calques_nuit_1x/cliffdaytest_nuit_BG00_ciel_et_astres.png" alt="BG00"></div>
      </div>
      <div class="layer-card">
        <h3>BG 01 · Nuages animés (3 Plans 1440 px)</h3>
        <div class="stage"><img data-asset="livrables_cliff_nord_nuit_pmdo/calques_nuit_1x/cliffdaytest_nuit_BG01_nuages_animes_wrap.png" alt="BG01"></div>
      </div>
      <div class="layer-card">
        <h3>Calque 01 · Mer lunaire animée (8 phases)</h3>
        <div class="stage"><img data-asset="livrables_cliff_nord_nuit_pmdo/calques_nuit_1x/cliffdaytest_nuit_L01_layer_2.png" alt="L01"></div>
      </div>
      <div class="layer-card">
        <h3>Calque 02 · Falaise, herbe &amp; chemin</h3>
        <div class="stage"><img data-asset="livrables_cliff_nord_nuit_pmdo/calques_nuit_1x/cliffdaytest_nuit_L02_layer_2.png" alt="L02"></div>
      </div>
      <div class="layer-card">
        <h3>Calques 03–04 · Village, Étang &amp; Fleurs animés</h3>
        <div class="stage"><img data-asset="livrables_cliff_nord_nuit_pmdo/viewer_layers_1x/cliffdaytest_nuit_terrain_nuit_0.png" alt="L03-04"></div>
      </div>
      <div class="layer-card">
        <h3>Calque 05 · Canopée avant-plan (Layer=4)</h3>
        <div class="stage"><img data-asset="livrables_cliff_nord_nuit_pmdo/calques_nuit_1x/cliffdaytest_nuit_L05_canopee_avant_plan.png" alt="L05"></div>
      </div>
    </div>
  </div>

  <!-- ==================== CARTE 2 : CLIFF NORD-OUEST ==================== -->
  <h2>2. <code>cliffnordouesttest1</code> (Jour) &amp; <code>cliffnordouesttest1_nuit</code> (Nuit) — Cliff Nord-Ouest (1104 × 784 px · 138 × 98 tuiles)</h2>
  <div class="map-block"
       data-stem="cliffnordouesttest1_nuit"
       data-w="1104"
       data-h="784">
    <div class="toolbar">
      <button type="button" class="mode-btn active" data-mode="dual_anim">☀️/🌙 Côte à Côte Jour &amp; Nuit (Animés)</button>
      <button type="button" class="mode-btn" data-mode="jour_anim">☀️ Jour Animé (Plein format 1×)</button>
      <button type="button" class="mode-btn" data-mode="nuit_anim">🌙 Nuit Animée (Plein format 1×)</button>
      <button type="button" class="mode-btn" data-mode="jour_orig">☀️ Jour d'origine statique (Réf. 1:1)</button>
      <button type="button" class="play-btn">⏸ Pause</button>
      <span style="margin-left:8px;color:var(--muted);font-size:13px">Vent nuages :</span>
      <button type="button" class="wind-btn" data-wind="1">PMDO 1× (-5/-9/-14 px/s)</button>
      <button type="button" class="wind-btn active" data-wind="2.2">Brise 2.2× (aperçu vif)</button>
      <span style="margin-left:8px;color:var(--muted);font-size:13px">Zoom :</span>
      <button type="button" class="zoom-btn active" data-z="auto">Auto Côte-à-Côte / 1×</button>
      <button type="button" class="zoom-btn" data-z="1">1× (1104×784)</button>
      <button type="button" class="zoom-btn" data-z="1.4">1.4×</button>
    </div>

    <div class="toggles">
      <strong style="color:var(--gold)">Calques actifs :</strong>
      <label><input type="checkbox" data-layer="sky" checked> Ciel &amp; Lune/Étoiles</label>
      <label><input type="checkbox" data-layer="clouds" checked> Nuages animés (3 plans parallaxe)</label>
      <label><input type="checkbox" data-layer="sea" checked> Mer animée (8 phases)</label>
      <label><input type="checkbox" data-layer="terrain" checked> Falaises, Chemin &amp; Cascade animée (4 phases)</label>
    </div>

    <div class="stage">
      <div class="dual-grid">
        <!-- Vue JOUR -->
        <div class="viewport-card card-day">
          <div class="viewport-title day">
            <span>☀️ VERSION JOUR ANIMÉE — <code>cliffnordouesttest1</code></span>
            <span>1104 × 784 px · Mer 8 phases · Cascade 4 phases</span>
          </div>
          <div class="pmdo-viewport-wrap wrap-day" style="width:1104px;height:784px">
            <div class="pmdo-scene scene-day" style="width:1104px;height:784px">
              <img class="lyr lyr-sky-day" data-asset="livrables_cliff_nord_nuit_pmdo/viewer_layers_1x/cliffnordouesttest1_nuit_sky_jour.png" alt="Ciel Jour">
              <div class="lyr-cloud-64 lyr-cloud-horizon-day" style="top:360px"></div>
              <div class="lyr-cloud-96 lyr-cloud-milieu-day" style="top:198px"></div>
              <div class="lyr-cloud-96 lyr-cloud-haut-day" style="top:38px"></div>
              <img class="lyr lyr-sea-day" data-asset="livrables_cliff_nord_nuit_pmdo/viewer_layers_1x/cliffnordouesttest1_nuit_sea_jour_0.png" alt="Mer Jour 8 phases">
              <img class="lyr lyr-terrain-day" data-asset="livrables_cliff_nord_nuit_pmdo/viewer_layers_1x/cliffnordouesttest1_nuit_terrain_jour_0.png" alt="Terrain Jour">
              <img class="lyr lyr-canopy-day" data-asset="livrables_cliff_nord_nuit_pmdo/viewer_layers_1x/cliffnordouesttest1_nuit_canopy_jour.png" alt="Canopée Jour" style="display:none">
              <img class="lyr lyr-dayorig" data-asset="livrables_cliff_nord_nuit_pmdo/png_1x/cliffnordouesttest1_jour_ref.png" alt="Jour origine" style="display:none">
            </div>
          </div>
        </div>

        <!-- Vue NUIT -->
        <div class="viewport-card card-night">
          <div class="viewport-title night">
            <span>🌙 VERSION NUIT ANIMÉE — <code>cliffnordouesttest1_nuit</code></span>
            <span>1104 × 784 px · Lune &amp; Étoiles · Cascade Nuit</span>
          </div>
          <div class="pmdo-viewport-wrap wrap-night" style="width:1104px;height:784px">
            <div class="pmdo-scene scene-night" style="width:1104px;height:784px">
              <img class="lyr lyr-sky-night" data-asset="livrables_cliff_nord_nuit_pmdo/viewer_layers_1x/cliffnordouesttest1_nuit_sky.png" alt="Ciel Nuit">
              <div class="lyr-cloud-64 lyr-cloud-horizon-night" style="top:360px"></div>
              <div class="lyr-cloud-96 lyr-cloud-milieu-night" style="top:198px"></div>
              <div class="lyr-cloud-96 lyr-cloud-haut-night" style="top:38px"></div>
              <img class="lyr lyr-sea-night" data-asset="livrables_cliff_nord_nuit_pmdo/viewer_layers_1x/cliffnordouesttest1_nuit_sea_nuit_0.png" alt="Mer Nuit 8 phases">
              <img class="lyr lyr-terrain-night" data-asset="livrables_cliff_nord_nuit_pmdo/viewer_layers_1x/cliffnordouesttest1_nuit_terrain_nuit_0.png" alt="Terrain Nuit">
              <img class="lyr lyr-canopy-night" data-asset="livrables_cliff_nord_nuit_pmdo/viewer_layers_1x/cliffnordouesttest1_nuit_canopy_nuit.png" alt="Canopée Nuit" style="display:none">
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="telemetry">▶ En cours · Mer phase 1/8 · Nuages hauts 0 px · milieu 0 px · horizon 0 px</div>
    <div class="meta">
      <span>Ground Jour : <code>cliffnordouesttest1.rsground</code></span>
      <span>Ground Nuit : <code>Data/Ground/cliffnordouesttest1_nuit.rsground</code></span>
      <span>BG animés : <code>CLIFF_NW_NUIT_CIEL/ASTRES.dir</code> + <code>CLIFF_NUIT_NUAGES_{HORIZON,MILIEU,HAUT}.dir</code></span>
      <span>Tilesheet : <code>Content/Tile/CliffNW_Nuit.tile</code></span>
    </div>

    <h3 style="margin-top:18px">Calques séparés Nuit 1× (PNG RGBA transparents)</h3>
    <div class="layers-grid">
      <div class="layer-card">
        <h3>BG 00 · Ciel nocturne velouté, Lune &amp; Étoiles</h3>
        <div class="stage"><img data-asset="livrables_cliff_nord_nuit_pmdo/calques_nuit_1x/cliffnordouesttest1_nuit_BG00_ciel_et_astres.png" alt="BG00"></div>
      </div>
      <div class="layer-card">
        <h3>BG 01 · Nuages animés (3 Plans 1440 px)</h3>
        <div class="stage"><img data-asset="livrables_cliff_nord_nuit_pmdo/calques_nuit_1x/cliffnordouesttest1_nuit_BG01_nuages_animes_wrap.png" alt="BG01"></div>
      </div>
      <div class="layer-card">
        <h3>Calque 01 · Mer lunaire animée (8 phases)</h3>
        <div class="stage"><img data-asset="livrables_cliff_nord_nuit_pmdo/calques_nuit_1x/cliffnordouesttest1_nuit_L01_layer_1.png" alt="L01"></div>
      </div>
      <div class="layer-card">
        <h3>Calques 02–03 · Falaises, Chemin &amp; Cascade animée</h3>
        <div class="stage"><img data-asset="livrables_cliff_nord_nuit_pmdo/viewer_layers_1x/cliffnordouesttest1_nuit_terrain_nuit_0.png" alt="L02-03"></div>
      </div>
    </div>
  </div>
</main>

<script>
const EMBEDDED_PNGS = __EMBEDDED_PNGS_JSON__;
(() => {
  const BASE = 'livrables_cliff_nord_nuit_pmdo/viewer_layers_1x';
  const assetUrl = (rel) => EMBEDDED_PNGS[rel] || rel;

  document.querySelectorAll('img[data-asset]').forEach((img) => {
    img.src = assetUrl(img.dataset.asset);
  });

  const controllers = [];

  document.querySelectorAll('.map-block').forEach((block) => {
    const stem = block.dataset.stem;
    const baseW = Number(block.dataset.w);
    const baseH = Number(block.dataset.h);
    const hasCanopy = stem === 'cliffdaytest_nuit';

    const cardDay = block.querySelector('.card-day');
    const cardNight = block.querySelector('.card-night');
    const wrapDay = block.querySelector('.wrap-day');
    const sceneDay = block.querySelector('.scene-day');
    const wrapNight = block.querySelector('.wrap-night');
    const sceneNight = block.querySelector('.scene-night');

    const skyDayEl = block.querySelector('.lyr-sky-day');
    const cloudHorizonDayEl = block.querySelector('.lyr-cloud-horizon-day');
    const cloudMilieuDayEl = block.querySelector('.lyr-cloud-milieu-day');
    const cloudHautDayEl = block.querySelector('.lyr-cloud-haut-day');
    const seaDayEl = block.querySelector('.lyr-sea-day');
    const terrainDayEl = block.querySelector('.lyr-terrain-day');
    const canopyDayEl = block.querySelector('.lyr-canopy-day');
    const dayOrigEl = block.querySelector('.lyr-dayorig');

    const skyNightEl = block.querySelector('.lyr-sky-night');
    const cloudHorizonNightEl = block.querySelector('.lyr-cloud-horizon-night');
    const cloudMilieuNightEl = block.querySelector('.lyr-cloud-milieu-night');
    const cloudHautNightEl = block.querySelector('.lyr-cloud-haut-night');
    const seaNightEl = block.querySelector('.lyr-sea-night');
    const terrainNightEl = block.querySelector('.lyr-terrain-night');
    const canopyNightEl = block.querySelector('.lyr-canopy-night');

    cloudHorizonDayEl.style.backgroundImage = `url('${assetUrl(BASE + '/nuages_jour_horizon_1440.png')}')`;
    cloudMilieuDayEl.style.backgroundImage = `url('${assetUrl(BASE + '/nuages_jour_milieu_1440.png')}')`;
    cloudHautDayEl.style.backgroundImage = `url('${assetUrl(BASE + '/nuages_jour_haut_1440.png')}')`;

    cloudHorizonNightEl.style.backgroundImage = `url('${assetUrl(BASE + '/nuages_nuit_horizon_1440.png')}')`;
    cloudMilieuNightEl.style.backgroundImage = `url('${assetUrl(BASE + '/nuages_nuit_milieu_1440.png')}')`;
    cloudHautNightEl.style.backgroundImage = `url('${assetUrl(BASE + '/nuages_nuit_haut_1440.png')}')`;

    const playBtn = block.querySelector('.play-btn');
    const telemEl = block.querySelector('.telemetry');

    const state = {
      mode: 'dual_anim',
      zoomMode: 'auto',
      playing: true,
      windMult: 2.2,
      elapsedSec: 0,
      lastSeaPhase: -1,
      lastHautPx: -1,
      lastMilieuPx: -1,
      lastHorizonPx: -1,
      vis: { sky: true, clouds: true, sea: true, terrain: true, canopy: true },
    };

    function applyZoom() {
      let z = 1.0;
      if (state.zoomMode === 'auto') {
        z = state.mode === 'dual_anim' ? (baseW > 1000 ? 0.62 : 0.68) : 1.0;
      } else {
        z = Number(state.zoomMode) || 1.0;
      }
      [ [wrapDay, sceneDay], [wrapNight, sceneNight] ].forEach(([wEl, sEl]) => {
        sEl.style.transform = `scale(${z})`;
        wEl.style.width = `${Math.round(baseW * z)}px`;
        wEl.style.height = `${Math.round(baseH * z)}px`;
      });
    }

    function applyPaletteAndVisibility() {
      const isOrig = state.mode === 'jour_orig';
      const showDayCard = state.mode === 'dual_anim' || state.mode === 'jour_anim' || isOrig;
      const showNightCard = state.mode === 'dual_anim' || state.mode === 'nuit_anim';

      cardDay.style.display = showDayCard ? 'flex' : 'none';
      cardNight.style.display = showNightCard ? 'flex' : 'none';

      dayOrigEl.style.display = isOrig ? 'block' : 'none';
      const showClouds = !isOrig && state.vis.clouds;

      skyDayEl.style.display = (!isOrig && state.vis.sky) ? 'block' : 'none';
      cloudHorizonDayEl.style.display = showClouds ? 'block' : 'none';
      cloudMilieuDayEl.style.display = showClouds ? 'block' : 'none';
      cloudHautDayEl.style.display = showClouds ? 'block' : 'none';
      seaDayEl.style.display = (!isOrig && state.vis.sea) ? 'block' : 'none';
      terrainDayEl.style.display = (!isOrig && state.vis.terrain) ? 'block' : 'none';
      canopyDayEl.style.display = (!isOrig && hasCanopy && state.vis.canopy) ? 'block' : 'none';

      skyNightEl.style.display = state.vis.sky ? 'block' : 'none';
      cloudHorizonNightEl.style.display = state.vis.clouds ? 'block' : 'none';
      cloudMilieuNightEl.style.display = state.vis.clouds ? 'block' : 'none';
      cloudHautNightEl.style.display = state.vis.clouds ? 'block' : 'none';
      seaNightEl.style.display = state.vis.sea ? 'block' : 'none';
      terrainNightEl.style.display = state.vis.terrain ? 'block' : 'none';
      canopyNightEl.style.display = (hasCanopy && state.vis.canopy) ? 'block' : 'none';

      state.lastSeaPhase = -1;
      applyZoom();
    }

    function updateFrame() {
      if (state.mode === 'jour_orig') {
        telemEl.textContent = 'Référence Jour d’origine statique (avant animation des nuages et des 8 phases de mer)';
        return;
      }
      const seaPhase = Math.floor(state.elapsedSec * 6) % 8;
      if (seaPhase !== state.lastSeaPhase) {
        seaDayEl.src = assetUrl(`${BASE}/${stem}_sea_jour_${seaPhase}.png`);
        terrainDayEl.src = assetUrl(`${BASE}/${stem}_terrain_jour_${seaPhase % 4}.png`);
        seaNightEl.src = assetUrl(`${BASE}/${stem}_sea_nuit_${seaPhase}.png`);
        terrainNightEl.src = assetUrl(`${BASE}/${stem}_terrain_nuit_${seaPhase % 4}.png`);
        state.lastSeaPhase = seaPhase;
      }
      const hautPx = Math.floor(state.elapsedSec * 14 * state.windMult) % 1440;
      const milieuPx = Math.floor(state.elapsedSec * 9 * state.windMult) % 1440;
      const horizonPx = Math.floor(state.elapsedSec * 5 * state.windMult) % 1440;
      if (hautPx !== state.lastHautPx) {
        cloudHautDayEl.style.backgroundPosition = `${-hautPx}px 0px`;
        cloudHautNightEl.style.backgroundPosition = `${-hautPx}px 0px`;
        state.lastHautPx = hautPx;
      }
      if (milieuPx !== state.lastMilieuPx) {
        cloudMilieuDayEl.style.backgroundPosition = `${-milieuPx}px 0px`;
        cloudMilieuNightEl.style.backgroundPosition = `${-milieuPx}px 0px`;
        state.lastMilieuPx = milieuPx;
      }
      if (horizonPx !== state.lastHorizonPx) {
        cloudHorizonDayEl.style.backgroundPosition = `${-horizonPx}px 0px`;
        cloudHorizonNightEl.style.backgroundPosition = `${-horizonPx}px 0px`;
        state.lastHorizonPx = horizonPx;
      }
      telemEl.textContent =
        `${state.playing ? '▶ En cours' : '⏸ Pause'} · Mode : ${state.mode === 'dual_anim' ? '☀️ Jour & 🌙 Nuit Côte à Côte' : state.mode} · Mer phase ${seaPhase + 1}/8 (FrameLength=10 · 60 Hz) ` +
        `· Nuages hauts -${hautPx} px · milieu -${milieuPx} px · horizon -${horizonPx}/1440 px`;
    }

    block.querySelectorAll('.mode-btn').forEach((btn) => {
      btn.addEventListener('click', () => {
        block.querySelectorAll('.mode-btn').forEach((b) => b.classList.remove('active'));
        btn.classList.add('active');
        state.mode = btn.dataset.mode;
        applyPaletteAndVisibility();
        updateFrame();
      });
    });

    playBtn.addEventListener('click', () => {
      state.playing = !state.playing;
      playBtn.textContent = state.playing ? '⏸ Pause' : '▶ Lecture';
      updateFrame();
    });

    block.querySelectorAll('.wind-btn').forEach((btn) => {
      btn.addEventListener('click', () => {
        block.querySelectorAll('.wind-btn').forEach((b) => b.classList.remove('active'));
        btn.classList.add('active');
        state.windMult = Number(btn.dataset.wind);
        updateFrame();
      });
    });

    block.querySelectorAll('.zoom-btn').forEach((btn) => {
      btn.addEventListener('click', () => {
        block.querySelectorAll('.zoom-btn').forEach((b) => b.classList.remove('active'));
        btn.classList.add('active');
        state.zoomMode = btn.dataset.z;
        applyZoom();
      });
    });

    block.querySelectorAll('input[data-layer]').forEach((chk) => {
      chk.addEventListener('change', () => {
        state.vis[chk.dataset.layer] = chk.checked;
        applyPaletteAndVisibility();
      });
    });

    applyPaletteAndVisibility();
    updateFrame();
    controllers.push({ state, updateFrame });
  });

  let lastTs = null;
  function tick(ts) {
    const dt = lastTs === null ? 0 : Math.min((ts - lastTs) / 1000, 0.1);
    lastTs = ts;
    controllers.forEach((c) => {
      if (c.state.playing) c.state.elapsedSec += dt;
      c.updateFrame();
    });
    requestAnimationFrame(tick);
  }
  requestAnimationFrame(tick);
})();
</script>
</body>
</html>
"""


def main() -> None:
    pngs = collect_embedded_pngs()
    html = HTML_TEMPLATE.replace(
        "__EMBEDDED_PNGS_JSON__",
        json.dumps(pngs, ensure_ascii=False, separators=(",", ":")),
    )
    assert "<canvas" not in html.lower()
    assert "#161b26" in html.lower()
    HTML_PATH.write_text(html, encoding="utf-8")
    print(f"[OK] {HTML_PATH.name} mis à jour ({len(pngs)} PNG embarqués, {HTML_PATH.stat().st_size / (1024*1024):.2f} MiB)")


if __name__ == "__main__":
    main()
