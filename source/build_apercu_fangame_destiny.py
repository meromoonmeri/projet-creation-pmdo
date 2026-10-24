#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Génère `apercu_fangame_pmd_destiny.html` : simulateur interactif 60 FPS de l'écran-titre
`320 × 240` (`Content/BG/Title_Screen_Background.dir` + `Content/UI/Title.png` + `TopMenu`)
et tableau de bord d'architecture Halcyon / `town02` pour **Pokémon Mystery Dungeon : Destiny**."""
from __future__ import annotations

import hashlib
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
    atlas_url = _vurl(".cache/studio_layers/DST1_MENU/Title_Screen_Background_atlas_6x4.png")
    title_url = _vurl(".cache/studio_layers/DST1_MENU/Title_320x240.png")
    enter_url = _vurl(".cache/studio_layers/DST1_MENU/Enter_74x11.png")
    logo_hd_url = _vurl(".cache/studio_layers/DST1_MENU/Logo_PMD_Destiny_HD.png")
    pack_zip_url = "/.cache/virtual_zips/PACK_MENU_ET_BASE_PMD_DESTINY_0.8.12.zip"
    dst1_zip_url = "/.cache/virtual_zips/DST1_PMDO_0.8.12.zip"

    return f"""<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Pokémon Mystery Dungeon : Destiny — Écran-Titre .dir Animé &amp; Architecture Halcyon / town02</title>
  <style>
    :root {{
      --bg: #070d1f;
      --panel: #0f1b38;
      --panel-2: #15264d;
      --border: #2a4884;
      --gold: #fbbf24;
      --gold-soft: #fde68a;
      --cyan: #38bdf8;
      --text: #eef4ff;
      --muted: #9eb5de;
    }}
    * {{ box-sizing: border-box; }}
    body {{
      margin: 0;
      font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif;
      background: radial-gradient(circle at 50% 0%, #162b5b 0%, var(--bg) 65%);
      color: var(--text);
      min-height: 100vh;
    }}
    header {{
      padding: 16px 24px;
      border-bottom: 1px solid var(--border);
      background: rgba(9, 16, 38, 0.92);
      display: flex;
      flex-wrap: wrap;
      align-items: center;
      justify-content: space-between;
      gap: 12px;
    }}
    header h1 {{
      margin: 0;
      font-size: 1.22rem;
      color: var(--gold-soft);
      letter-spacing: 0.2px;
    }}
    header p {{
      margin: 4px 0 0;
      font-size: 0.84rem;
      color: var(--muted);
    }}
    .nav-links {{
      display: flex;
      gap: 8px;
      flex-wrap: wrap;
    }}
    .btn-nav {{
      padding: 7px 13px;
      border-radius: 8px;
      background: var(--panel-2);
      border: 1px solid var(--cyan);
      color: #fff;
      text-decoration: none;
      font-size: 0.81rem;
      font-weight: 700;
    }}
    main {{
      max-width: 1420px;
      margin: 0 auto;
      padding: 20px;
      display: grid;
      grid-template-columns: minmax(0, 1.35fr) minmax(340px, 0.95fr);
      gap: 20px;
    }}
    @media (max-width: 1060px) {{
      main {{ grid-template-columns: 1fr; }}
    }}
    .card {{
      background: rgba(15, 27, 56, 0.92);
      border: 1px solid var(--border);
      border-radius: 12px;
      padding: 16px 18px;
      box-shadow: 0 12px 32px rgba(0, 0, 0, 0.42);
    }}
    .mode-bar {{
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      margin-bottom: 14px;
    }}
    .mode-btn {{
      flex: 1;
      min-width: 170px;
      padding: 9px 12px;
      border-radius: 8px;
      border: 1px solid #35589c;
      background: #132347;
      color: #dbeafe;
      font-weight: 700;
      font-size: 0.82rem;
      cursor: pointer;
      transition: all 0.15s ease;
    }}
    .mode-btn.active {{
      background: linear-gradient(180deg, #d97706, #92400e);
      border-color: var(--gold-soft);
      color: #fff;
    }}
    .screen-shell {{
      display: flex;
      justify-content: center;
      align-items: center;
      background: #030712;
      border: 2px solid #2e4f8f;
      border-radius: 10px;
      padding: 14px;
      position: relative;
    }}
    canvas#pmdoCanvas {{
      width: 100%;
      max-width: 768px;
      aspect-ratio: 4 / 3;
      image-rendering: pixelated;
      image-rendering: crisp-edges;
      border-radius: 4px;
      box-shadow: 0 0 28px rgba(56, 189, 248, 0.18);
      cursor: pointer;
    }}
    .controls-grid {{
      margin-top: 14px;
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      align-items: center;
      justify-content: space-between;
    }}
    .ctrl-btn {{
      padding: 6px 11px;
      border-radius: 7px;
      border: 1px solid #35589c;
      background: #172b56;
      color: #eef4ff;
      font-size: 0.8rem;
      font-weight: 600;
      cursor: pointer;
    }}
    .ctrl-btn.active {{
      background: #1d4ed8;
      border-color: #93c5fd;
    }}
    .phase-pill {{
      font-size: 0.82rem;
      padding: 5px 11px;
      border-radius: 999px;
      background: #1b3163;
      border: 1px solid #4973c4;
      color: var(--gold-soft);
      font-weight: 700;
    }}
    .dl-primary {{
      display: block;
      width: 100%;
      text-align: center;
      padding: 12px 14px;
      margin-top: 10px;
      border-radius: 9px;
      background: linear-gradient(180deg, #d97706, #92400e);
      border: 1px solid var(--gold-soft);
      color: #fff;
      font-weight: 800;
      font-size: 0.9rem;
      text-decoration: none;
    }}
    .dl-secondary {{
      display: block;
      width: 100%;
      text-align: center;
      padding: 10px 14px;
      margin-top: 8px;
      border-radius: 9px;
      background: #183468;
      border: 1px solid var(--cyan);
      color: #e0f2fe;
      font-weight: 700;
      font-size: 0.84rem;
      text-decoration: none;
    }}
    pre.tree {{
      background: #071024;
      border: 1px solid #243f75;
      border-radius: 8px;
      padding: 11px 13px;
      font-size: 0.76rem;
      line-height: 1.45;
      color: #cfe2ff;
      overflow-x: auto;
      margin: 10px 0;
    }}
    .logo-preview-box {{
      background: repeating-conic-gradient(#111c38 0% 25%, #0b1329 0% 50%) 50% / 18px 18px;
      border: 1px solid #2b4985;
      border-radius: 9px;
      padding: 10px;
      text-align: center;
      margin-top: 10px;
    }}
    .logo-preview-box img {{
      max-width: 100%;
      max-height: 150px;
      height: auto;
    }}
    h2 {{
      margin: 0 0 8px;
      font-size: 1.02rem;
      color: var(--gold-soft);
    }}
    .spec-list {{
      margin: 8px 0;
      padding-left: 18px;
      font-size: 0.83rem;
      color: #d6e4ff;
      line-height: 1.5;
    }}
  </style>
</head>
<body>
  <header>
    <div>
      <h1>Pokémon Mystery Dungeon : Destiny — Simulateur Écran-Titre PMDO 0.8.12 (`320 × 240`)</h1>
      <p>Fond <code>Title_Screen_Background.dir</code> animé en boucle (Crépuscule ──▶ Soir &amp; Nuit Étoilée, sans logo) + <code>Content/UI/Title.png</code> séparé + Architecture Quest Halcyon / <code>town02</code></p>
    </div>
    <div class="nav-links">
      <a class="btn-nav" href="./index.html">Studio 10 Calques HD (DST1 + 38 Maps)</a>
      <a class="btn-nav" href="./apercu_consolidation_town02_unifiee.html">Architecture Unifiée town02 (122 Grounds)</a>
    </div>
  </header>

  <main>
    <section class="card">
      <div class="mode-bar">
        <button class="mode-btn" data-mode="dir_only">1. Fond <code>.dir</code> Pur (Sans Logo, comme Halcyon)</button>
        <button class="mode-btn active" data-mode="title_scene">2. Écran-Titre PMDO (<code>.dir</code> + <code>Title.png</code>)</button>
        <button class="mode-btn" data-mode="top_menu">3. Menu Principal <code>TopMenu</code> (Lua Live)</button>
      </div>

      <div class="screen-shell">
        <canvas id="pmdoCanvas" width="320" height="240" title="Cliquez ou appuyez sur Entrée pour basculer entre Écran-Titre et TopMenu"></canvas>
      </div>

      <div class="controls-grid">
        <div style="display:flex;gap:6px;flex-wrap:wrap;align-items:center;">
          <button class="ctrl-btn active" id="playBtn">⏸ Pause</button>
          <button class="ctrl-btn" data-jump="0">Pose 0 · Crépuscule Doré</button>
          <button class="ctrl-btn" data-jump="6">Pose 6 · Heure Bleue</button>
          <button class="ctrl-btn" data-jump="12">Pose 12 · Nuit Étoilée</button>
          <button class="ctrl-btn" data-jump="13">Pose 13 · Étoile Filante</button>
        </div>
        <span class="phase-pill" id="phaseLabel">Pose 00 / 24 · Crépuscule Doré</span>
      </div>

      <div style="margin-top:10px;display:flex;gap:12px;align-items:center;flex-wrap:wrap;">
        <label style="font-size:0.81rem;color:var(--muted);flex:1;min-width:220px;">
          Curseur de pose (<code>0..23</code>) :
          <input type="range" id="poseSlider" min="0" max="23" value="0" style="width:100%;vertical-align:middle;" />
        </label>
        <label style="font-size:0.81rem;color:var(--muted);">
          Cadence PMDO :
          <select id="ticksSelect" style="background:#132347;color:#fff;border:1px solid #35589c;border-radius:6px;padding:4px 8px;">
            <option value="8">8 ticks/pose (rapide · 3,2 s)</option>
            <option value="12" selected>12 ticks/pose (standard · 4,8 s)</option>
            <option value="18">18 ticks/pose (contemplatif · 7,2 s)</option>
          </select>
        </label>
      </div>
    </section>

    <aside class="card">
      <h2>Assets Officiels &amp; Organisation Halcyon / <code>town02</code></h2>
      <div class="logo-preview-box">
        <img src="{logo_hd_url}" alt="Logo Pokémon Mystery Dungeon : Destiny HD" />
        <div style="font-size:0.75rem;color:var(--muted);margin-top:4px;">
          <code>Content/UI/Title.png</code> (<code>320×240</code>) &amp; Cutout HD (<code>1369×752</code>, <code>0 px</code> <code>#FF00FF</code>)
        </div>
      </div>

      <a class="dl-primary" href="{pack_zip_url}" download="PACK_MENU_ET_BASE_PMD_DESTINY_0.8.12.zip">
        ⬇ Télécharger PACK_MENU_ET_BASE_PMD_DESTINY_0.8.12.zip
      </a>
      <a class="dl-secondary" href="{dst1_zip_url}" download="DST1_PMDO_0.8.12.zip">
        ⬇ Télécharger Scène 10 Calques Ground DST1_PMDO_0.8.12.zip
      </a>

      <ul class="spec-list">
        <li><strong><code>Content/BG/Title_Screen_Background.dir</code></strong> : <code>320×240</code>, <code>24</code> poses en boucle parfaite <strong>100 % sans logo</strong> (trailer <code>&lt;iiii (320, 240, 0, 24)</code>).</li>
        <li><strong>Cycle Ciel &amp; Mer</strong> : Crépuscule doré-corail ──▶ Heure bleue ──▶ Soir &amp; Nuit étoilée (~96 étoiles scintillantes + étoile filante poses <code>11..15</code> + reflets marins).</li>
        <li><strong><code>Data/Script/halcyon/services/destiny_title_anim/init.lua</code></strong> : Souscrit à <code>EngineServiceEvents.AddMenu</code> et anime le <code>.dir</code> sous <code>TopMenu</code> via <code>LowerSummaryMenus</code> + <code>MenuDirTex(TexType.BG)</code>.</li>
      </ul>

      <pre class="tree">Pokemon-Mystery-Dungeon-Destiny/
├── Mod.xml                         (&lt;Name&gt;Pokemon Mystery Dungeon: Destiny&lt;/Name&gt;, &lt;Namespace&gt;halcyon&lt;/Namespace&gt;)
├── Content/
│   ├── ContentParams.xml           (&lt;TitleBG&gt;Title_Screen_Background&lt;/TitleBG&gt;)
│   ├── BG/Title_Screen_Background.dir  (320×240 × 24 poses animées SANS logo)
│   ├── UI/Title.png &amp; Enter.png    (Logo Super PMD : Destiny séparé + PRESS ENTER)
│   └── Tile/*.tile + index.idx     (town02 + 38 maps Studio + 84 maps Guilde = 0 damier mauve)
├── Data/
│   ├── Ground/*.rsground           (town02 + pmd_destiny_menu_titre + 121 Grounds custom)
│   ├── Zone/master_zone.json &amp; index.idx
│   └── Script/halcyon/
│       ├── main.lua                (inclut require 'halcyon.services.destiny_title_anim')
│       ├── services/destiny_title_anim/init.lua
│       └── ground/&lt;id&gt;/init.lua
└── Strings/strings.reon &amp; strings.fr.reon</pre>

      <div style="font-size:0.78rem;color:var(--muted);">
        Commande unique pour assembler tout le fangame (<code>town02</code> + écran-titre <em>Destiny</em> + 122 cartes) :<br/>
        <code style="color:var(--gold-soft);">./CREER_FANGAME_PMD_DESTINY.sh</code>
      </div>
    </aside>
  </main>

  <script>
    const canvas = document.getElementById('pmdoCanvas');
    const ctx = canvas.getContext('2d');
    ctx.imageSmoothingEnabled = false;

    const N_POSES = 24;
    const COLS = 6;
    let mode = 'title_scene';
    let playing = true;
    let pose = 0;
    let frameTick = 0;
    let ticksPerPose = 12;
    let menuCursor = 0;
    const menuItems = ['New Game', 'Records', 'Options', 'Exit Quest', 'Mods', 'Quit'];

    const atlasImg = new Image();
    const titleImg = new Image();
    const enterImg = new Image();
    let loaded = 0;
    const onAsset = () => {{ loaded++; }};
    atlasImg.onload = onAsset;
    titleImg.onload = onAsset;
    enterImg.onload = onAsset;
    atlasImg.src = '{atlas_url}';
    titleImg.src = '{title_url}';
    enterImg.src = '{enter_url}';

    const phaseNames = (p) => {{
      if (p <= 3 || p >= 22) return 'Crépuscule Doré';
      if (p <= 7) return 'Heure Bleue & Premières Étoiles';
      if (p >= 11 && p <= 15) return 'Soir & Nuit Étoilée (Étoile Filante)';
      if (p <= 16) return 'Soir & Nuit Étoilée Scintillante';
      return 'Aube Crépusculaire (Boucle)';
    }};

    function drawPmdoWindow(x, y, w, h) {{
      ctx.fillStyle = 'rgba(12, 24, 58, 0.88)';
      ctx.fillRect(x, y, w, h);
      ctx.strokeStyle = '#cbd5e1';
      ctx.lineWidth = 2;
      ctx.strokeRect(x + 1, y + 1, w - 2, h - 2);
      ctx.strokeStyle = '#38bdf8';
      ctx.lineWidth = 1;
      ctx.strokeRect(x + 3.5, y + 3.5, w - 7, h - 7);
    }}

    function render() {{
      ctx.clearRect(0, 0, 320, 240);
      if (atlasImg.complete && atlasImg.naturalWidth > 0) {{
        const sx = (pose % COLS) * 320;
        const sy = Math.floor(pose / COLS) * 240;
        ctx.drawImage(atlasImg, sx, sy, 320, 240, 0, 0, 320, 240);
      }}

      if (mode === 'title_scene') {{
        if (titleImg.complete && titleImg.naturalWidth > 0) {{
          ctx.drawImage(titleImg, 0, 0);
        }}
        if (enterImg.complete && enterImg.naturalWidth > 0) {{
          if (Math.floor(frameTick / 30) % 2 === 0) {{
            const ex = Math.floor((320 - enterImg.naturalWidth) / 2);
            ctx.drawImage(enterImg, ex, 180);
          }}
        }}
      }} else if (mode === 'top_menu') {{
        // Reproduit fidèlement TopMenu.cs (Loc(16,16)) + TOP_TITLE_SUMMARY en haut à droite !
        drawPmdoWindow(16, 16, 92, 108);
        ctx.font = 'bold 10px monospace';
        ctx.textBaseline = 'top';
        menuItems.forEach((item, idx) => {{
          const iy = 24 + idx * 15;
          if (idx === menuCursor) {{
            ctx.fillStyle = '#fde68a';
            ctx.fillText('▶', 22, iy);
          }}
          ctx.fillStyle = idx === menuCursor ? '#fde68a' : '#f8fafc';
          ctx.fillText(item, 33, iy);
        }});

        drawPmdoWindow(124, 16, 180, 28);
        ctx.fillStyle = '#fde68a';
        ctx.font = 'bold 8px monospace';
        ctx.textAlign = 'center';
        ctx.fillText('Pokemon Mystery Dungeon: Destiny', 214, 26);
        ctx.textAlign = 'left';
      }}

      document.getElementById('phaseLabel').textContent =
        `Pose ${{String(pose).padStart(2, '0')}} / 24 · ${{phaseNames(pose)}}`;
      document.getElementById('poseSlider').value = String(pose);
    }}

    function loop() {{
      frameTick++;
      if (playing && frameTick % ticksPerPose === 0) {{
        pose = (pose + 1) % N_POSES;
      }}
      render();
      requestAnimationFrame(loop);
    }}

    document.querySelectorAll('.mode-btn').forEach(btn => {{
      btn.addEventListener('click', () => {{
        document.querySelectorAll('.mode-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        mode = btn.dataset.mode;
        render();
      }});
    }});

    document.getElementById('playBtn').addEventListener('click', (e) => {{
      playing = !playing;
      e.target.textContent = playing ? '⏸ Pause' : '▶ Lecture';
      e.target.classList.toggle('active', playing);
    }});

    document.querySelectorAll('[data-jump]').forEach(btn => {{
      btn.addEventListener('click', () => {{
        pose = Number(btn.dataset.jump) % N_POSES;
        render();
      }});
    }});

    document.getElementById('poseSlider').addEventListener('input', (e) => {{
      pose = Number(e.target.value) % N_POSES;
      render();
    }});

    document.getElementById('ticksSelect').addEventListener('change', (e) => {{
      ticksPerPose = Number(e.target.value) || 12;
    }});

    canvas.addEventListener('click', () => {{
      const next = mode === 'title_scene' ? 'top_menu' : (mode === 'top_menu' ? 'dir_only' : 'title_scene');
      mode = next;
      document.querySelectorAll('.mode-btn').forEach(b => b.classList.toggle('active', b.dataset.mode === mode));
    }});

    window.addEventListener('keydown', (e) => {{
      if (e.key === 'Enter') {{
        mode = mode === 'top_menu' ? 'title_scene' : 'top_menu';
        document.querySelectorAll('.mode-btn').forEach(b => b.classList.toggle('active', b.dataset.mode === mode));
      }} else if (mode === 'top_menu' && e.key === 'ArrowDown') {{
        e.preventDefault();
        menuCursor = (menuCursor + 1) % menuItems.length;
      }} else if (mode === 'top_menu' && e.key === 'ArrowUp') {{
        e.preventDefault();
        menuCursor = (menuCursor + menuItems.length - 1) % menuItems.length;
      }}
    }});

    requestAnimationFrame(loop);
  </script>
</body>
</html>
"""


def main() -> None:
    out_path = REPO_ROOT / "apercu_fangame_pmd_destiny.html"
    out_path.write_text(build_destiny_html(), encoding="utf-8")
    print(f"[Destiny UI] Généré : {out_path} ({out_path.stat().st_size} octets)")


if __name__ == "__main__":
    main()
