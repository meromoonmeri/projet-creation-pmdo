#!/usr/bin/env python3
"""Génère les planches filmstrip 24 poses par calque (dans `.cache/studio_layers/<MAP_ID>/`, hors Git)
et le Studio interactif HTML5 `<canvas>` 60 FPS (`index.html`, `apercu_sommet_tour_celeste_stc1_pmdo.html`,
`apercu_mine_magma_multicalque_pmdo.html`) réunissant les 3 cartes multicalques PMDO 0.8.12.0 :
- `STC1` — Sommet de la Tour Céleste — Arène de Rayquaza (alizés, couronne de référence & cumulus statiques),
- `MME1` — Mine Magma — Entrée (`D12P01` + `D12P01.bpl` 10 couches multicalques),
- `MMA1` — Mine Magma — Arène de Groudon (`b70` Hardware `1:1` + `b70canm` + Caldeira & Geysers 10 couches).
"""

from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path
from typing import Dict, List

from PIL import Image

REPO_ROOT = Path(__file__).resolve().parents[1]
if str(REPO_ROOT / "source") not in sys.path:
    sys.path.insert(0, str(REPO_ROOT / "source"))

STUDIO_CACHE = REPO_ROOT / ".cache" / "studio_layers"


def _load_builder(folder_name: str):
    path = REPO_ROOT / "source" / folder_name / "build.py"
    spec = importlib.util.spec_from_file_location(f"studio_{folder_name}", path)
    mod = importlib.util.module_from_spec(spec)
    assert spec and spec.loader
    spec.loader.exec_module(mod)
    return mod


def export_filmstrips() -> Dict:
    specs = [
        {
            "id": "MMA1",
            "folder": "mine_magma_arene_v1",
            "ref_rel": "source/mine_magma_arene_v1/references/native_H26P01.png",
            "ref_label": "Référence matérielle GBA native 1× (H26P01)",
            "zip_rel": ".cache/virtual_zips/MMA1_PMDO_0.8.12.zip",
            "bg_fill": "#370000",
            "subtitle": "H26P01 1× Natif + Palette Cycling H26P01.bpl — Veines #FF00FF, cascade Nord, 6 colonnes 1× & arène de Groudon (0 mini-volcan)",
            "wind_summary": "H26P01.bpl : Mer & veines #FF00FF (31f @ 4t) | Cascade Nord & colonnes 1× (8f @ 3t) | Rives (15f @ 8t) | Braises W04 Top (16f @ 7t)",
        },
        {
            "id": "MME1",
            "folder": "mine_magma_entree_v1",
            "ref_rel": "source/mine_magma_arene_v1/references/native_H26P01.png",
            "ref_label": "Référence matérielle roche noire & magma 1× (H26P01)",
            "zip_rel": ".cache/virtual_zips/MME1_PMDO_0.8.12.zip",
            "bg_fill": "#140404",
            "subtitle": "Entrée 100 % Roche Noire Magma (Basalte & Obsidienne) — Chaussée Sud-Nord, arche caverneuse, veines #FF00FF & H26P01.bpl 1×",
            "wind_summary": "Roche noire magma unifiée | Gouffres & veines #FF00FF (31f @ 4t) | 4 cascades 1× (8f @ 3t) | Rives (15f @ 8t) | Braises W04 Top",
        },
        {
            "id": "STC1",
            "folder": "tour_celeste_sommet_v1",
            "ref_rel": "source/tour_celeste_sommet_v1/references/ref_sommet_planete_rayquaza.png",
            "ref_label": "Référence Sommet Planète & Couronne Nuageuse",
            "zip_rel": ".cache/virtual_zips/STC1_PMDO_0.8.12.zip",
            "bg_fill": "#040a34",
            "subtitle": "b71 1:1 sans halo atmosphérique ni frange blanche d'extrémité — Alizés, couronne de référence & cumulus Top statiques",
            "wind_summary": "Statiques (1 pose) : Horizon Terre pur, alizés, couronne & croissants, cumulus Top | Animés : Étoiles cosmos & souffle D13P01.bpl",
        },
    ]

    manifest_maps: List[Dict] = []
    for item in specs:
        mid = item["id"]
        folder = item["folder"]
        out_dir = STUDIO_CACHE / mid
        out_dir.mkdir(parents=True, exist_ok=True)

        mod = _load_builder(folder)
        layers, walk_grid, _ = mod.build_layers_for_size()
        meta = json.loads((REPO_ROOT / "renders" / folder / "metadata.json").read_text(encoding="utf-8"))

        layer_entries = []
        for idx, layer in enumerate(layers):
            n_poses = len(layer.frames)
            w, h = layer.frames[0].size
            strip = Image.new("RGBA", (w * n_poses, h), (0, 0, 0, 0))
            for t, fr in enumerate(layer.frames):
                strip.paste(fr, (t * w, 0))
            strip_path = out_dir / f"{layer.slug}.png"
            strip.save(strip_path, format="PNG", optimize=False, compress_level=6)
            sheet_key = f"{mid}_{idx:02d}_{layer.slug.upper()}"
            layer_entries.append(
                {
                    "index": idx,
                    "slug": layer.slug,
                    "name": layer.name,
                    "kind": meta["layers"][idx]["kind"],
                    "poses": n_poses,
                    "frame_length": meta["layers"][idx].get("frame_length", 5),
                    "unique_tiles": meta["unique_tiles_per_sheet"].get(sheet_key, 0),
                    "strip_url": f"/.cache/studio_layers/{mid}/{layer.slug}.png",
                    "static_url": f"/renders/{folder}/layers/{layer.slug}.png",
                }
            )

        manifest_maps.append(
            {
                "id": mid,
                "title": meta["title"],
                "subtitle": item["subtitle"],
                "wind_summary": item["wind_summary"],
                "bg_fill": item["bg_fill"],
                "ref_label": item["ref_label"],
                "folder": folder,
                "width": meta["size_px"][0],
                "height": meta["size_px"][1],
                "n_frames": meta["n_frames"],
                "frame_ticks": meta["frame_ticks"],
                "fidelity": meta["fidelity_distance"],
                "walkable_tiles": meta["walkable_tiles"],
                "total_tiles": meta["total_tiles"],
                "total_unique_tiles": meta["total_unique_tiles"],
                "zip_bytes": meta["zip_bytes"],
                "zip_url": "/" + item["zip_rel"],
                "ref_url": "/" + item["ref_rel"],
                "webp_url": f"/renders/{folder}/animation_24frames.webp",
                "pose0_url": f"/renders/{folder}/composite_pose0.png",
                "walk_grid": walk_grid.astype(int).tolist(),
                "layers": layer_entries,
            }
        )
        print(f"[Studio] {mid}: {len(layer_entries)} filmstrips écrits dans {out_dir}")

    return {"maps": manifest_maps}


def build_html(manifest: Dict, default_map_id: str = "MMA1") -> str:
    manifest_json = json.dumps(manifest, ensure_ascii=False)
    return f"""<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Studio Multicalque PMDO 0.8.12.0 — Mine Magma (MME1 · MMA1) &amp; Tour Céleste (STC1)</title>
  <style>
    :root {{
      --bg: #0b1020;
      --panel: #141e38;
      --panel-2: #1b294c;
      --border: #314b82;
      --accent: #ff944d;
      --accent-2: #ffd180;
      --ok: #5be39b;
      --text: #f3f6ff;
      --muted: #a6b7d8;
    }}
    * {{ box-sizing: border-box; }}
    body {{
      margin: 0;
      font-family: Inter, system-ui, -apple-system, Segoe UI, Roboto, sans-serif;
      background: radial-gradient(circle at 50% 0%, #24182c 0%, var(--bg) 68%);
      color: var(--text);
      min-height: 100vh;
    }}
    header {{
      padding: 16px 24px;
      border-bottom: 1px solid var(--border);
      background: rgba(12, 18, 36, 0.94);
      display: flex;
      flex-wrap: wrap;
      align-items: center;
      justify-content: space-between;
      gap: 14px;
    }}
    header h1 {{
      margin: 0;
      font-size: 1.18rem;
      letter-spacing: 0.01em;
    }}
    header p {{
      margin: 4px 0 0;
      color: var(--muted);
      font-size: 0.86rem;
    }}
    .map-tabs {{
      display: flex;
      gap: 8px;
      flex-wrap: wrap;
      align-items: center;
    }}
    .map-tab {{
      background: var(--panel);
      color: var(--text);
      border: 1px solid var(--border);
      border-radius: 8px;
      padding: 8px 14px;
      font-weight: 700;
      font-size: 0.84rem;
      cursor: pointer;
    }}
    .map-tab.active {{
      background: linear-gradient(180deg, #b83b14, #7a2108);
      border-color: var(--accent-2);
      color: #fff;
    }}
    main {{
      max-width: 1480px;
      margin: 0 auto;
      padding: 18px 24px 40px;
      display: grid;
      grid-template-columns: minmax(0, 1fr) 395px;
      gap: 20px;
      align-items: start;
    }}
    @media (max-width: 1120px) {{
      main {{ grid-template-columns: 1fr; }}
    }}
    .stage-card, .side-card {{
      background: rgba(20, 30, 56, 0.93);
      border: 1px solid var(--border);
      border-radius: 12px;
      padding: 16px;
    }}
    .stage-top {{
      display: flex;
      flex-wrap: wrap;
      justify-content: space-between;
      align-items: center;
      gap: 10px;
      margin-bottom: 12px;
    }}
    .wind-pill {{
      background: var(--panel-2);
      border: 1px solid var(--border);
      padding: 6px 11px;
      border-radius: 7px;
      font-size: 0.8rem;
      color: var(--accent-2);
    }}
    .canvas-wrap {{
      display: flex;
      gap: 14px;
      flex-wrap: wrap;
      justify-content: center;
      align-items: center;
      background: #060912;
      border: 1px solid #243864;
      border-radius: 10px;
      padding: 12px;
      overflow-x: auto;
    }}
    canvas, .ref-preview {{
      image-rendering: pixelated;
      image-rendering: crisp-edges;
      border-radius: 4px;
      max-width: 100%;
      height: auto;
      box-shadow: 0 8px 28px rgba(0, 0, 0, 0.6);
    }}
    .ref-box {{
      display: none;
      flex-direction: column;
      align-items: center;
      gap: 6px;
    }}
    .ref-box.visible {{ display: flex; }}
    .ref-caption {{
      font-size: 0.78rem;
      color: var(--muted);
    }}
    .controls {{
      margin-top: 14px;
      display: flex;
      flex-wrap: wrap;
      align-items: center;
      gap: 10px;
      padding-top: 12px;
      border-top: 1px solid #243c6a;
    }}
    button.ctrl {{
      background: var(--panel-2);
      color: var(--text);
      border: 1px solid var(--border);
      border-radius: 7px;
      padding: 7px 12px;
      font-size: 0.84rem;
      cursor: pointer;
    }}
    button.ctrl.active {{
      background: #9e3816;
      border-color: var(--accent-2);
    }}
    input[type="range"] {{
      flex: 1;
      min-width: 150px;
      accent-color: var(--accent);
    }}
    .metrics {{
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 8px;
      margin-bottom: 14px;
    }}
    .metric {{
      background: var(--panel-2);
      border: 1px solid #294375;
      border-radius: 8px;
      padding: 9px 11px;
    }}
    .metric .k {{ font-size: 0.74rem; color: var(--muted); }}
    .metric .v {{ font-size: 0.98rem; font-weight: 700; margin-top: 2px; color: var(--ok); }}
    .layer-list {{
      display: flex;
      flex-direction: column;
      gap: 6px;
      max-height: 430px;
      overflow-y: auto;
    }}
    .layer-row {{
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 8px;
      padding: 7px 9px;
      background: var(--panel-2);
      border: 1px solid #264070;
      border-radius: 7px;
      font-size: 0.82rem;
    }}
    .layer-row label {{
      display: flex;
      align-items: center;
      gap: 8px;
      cursor: pointer;
      flex: 1;
    }}
    .badge {{
      font-size: 0.71rem;
      padding: 2px 6px;
      border-radius: 5px;
      background: #233c6b;
      color: #cfe2ff;
      white-space: nowrap;
    }}
    .badge.anim {{
      background: #5b2512;
      color: #ffd180;
    }}
    .dl-btn {{
      display: block;
      width: 100%;
      text-align: center;
      margin-top: 14px;
      padding: 11px 14px;
      background: linear-gradient(180deg, #c24116, #842608);
      color: #fff;
      text-decoration: none;
      font-weight: 700;
      font-size: 0.88rem;
      border-radius: 8px;
      border: 1px solid var(--accent-2);
    }}
    .status-line {{
      font-size: 0.8rem;
      color: var(--muted);
    }}
  </style>
</head>
<body>
  <header>
    <div>
      <h1 id="headerTitle">Studio Multicalque 24 Poses · PMDO 0.8.12.0</h1>
      <p id="mapSubtitle">Chargement des planches pixel-art...</p>
    </div>
    <nav class="map-tabs" id="mapTabs"></nav>
  </header>

  <main>
    <section class="stage-card">
      <div class="stage-top">
        <div class="wind-pill" id="windSummary"></div>
        <div class="status-line" id="loadStatus">Chargement des calques...</div>
      </div>

      <div class="canvas-wrap">
        <canvas id="stageCanvas" width="768" height="576"></canvas>
        <div class="ref-box" id="refBox">
          <img id="refImg" class="ref-preview" width="384" height="288" alt="Référence canonique GBA" />
          <div class="ref-caption" id="refCaption">Référence canonique GBA</div>
        </div>
      </div>

      <div class="controls">
        <button class="ctrl active" id="playBtn">⏸ Pause</button>
        <span id="frameLabel" style="font-variant-numeric: tabular-nums; font-size:0.85rem; min-width:96px;">Pose 00 / 23</span>
        <input type="range" id="frameSlider" min="0" max="23" value="0" />
        <button class="ctrl" data-speed="0.5">0.5×</button>
        <button class="ctrl active" data-speed="1">1× (60 FPS / 5 ticks)</button>
        <button class="ctrl" data-speed="2">2×</button>
        <button class="ctrl" id="collBtn">Collisions Sud-Nord</button>
        <button class="ctrl" id="refBtn">Référence GBA</button>
      </div>
    </section>

    <aside class="side-card">
      <div class="metrics" id="metricsBox"></div>
      <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
        <strong style="font-size:0.9rem;">Calques natifs (10 couches)</strong>
        <div style="display:flex; gap:6px;">
          <button class="ctrl" id="allOnBtn" style="padding:4px 8px; font-size:0.76rem;">Tout afficher</button>
          <button class="ctrl" id="animOnlyBtn" style="padding:4px 8px; font-size:0.76rem;">Animés seuls</button>
        </div>
      </div>
      <div class="layer-list" id="layerList"></div>
      <a class="dl-btn" id="zipDownload" href="#" download>Télécharger le package .rsground</a>
    </aside>
  </main>

  <script>
    const MANIFEST = {manifest_json};
    const DEFAULT_ID = "{default_map_id}";
    let m = MANIFEST.maps.find((x) => x.id === (location.hash.replace('#', '') || DEFAULT_ID)) || MANIFEST.maps[0];
    let playing = true;
    let speedMul = 1.0;
    let showCollisions = false;
    let showRef = false;
    let poseIdx = 0;
    let lastStepMs = performance.now();
    const imageCache = new Map();
    const layerEnabled = new Map();

    const canvas = document.getElementById('stageCanvas');
    const ctx = canvas.getContext('2d');
    ctx.imageSmoothingEnabled = false;

    function loadImg(url) {{
      if (imageCache.has(url)) return imageCache.get(url);
      const p = new Promise((resolve) => {{
        const im = new Image();
        im.onload = () => resolve(im);
        im.onerror = () => resolve(null);
        im.src = url;
      }});
      imageCache.set(url, p);
      return p;
    }}

    function buildTabs() {{
      const tabsEl = document.getElementById('mapTabs');
      tabsEl.innerHTML = '';
      MANIFEST.maps.forEach((item) => {{
        const btn = document.createElement('button');
        btn.className = 'map-tab' + (item.id === m.id ? ' active' : '');
        btn.textContent = `${{item.id}} · ${{item.title}}`;
        btn.addEventListener('click', () => selectMap(item.id));
        tabsEl.appendChild(btn);
      }});
    }}

    async function selectMap(mapId) {{
      const found = MANIFEST.maps.find((x) => x.id === mapId);
      if (!found) return;
      m = found;
      history.replaceState(null, '', '#' + m.id);
      poseIdx = 0;
      buildTabs();
      await initMap();
    }}

    async function initMap() {{
      canvas.width = m.width;
      canvas.height = m.height;
      ctx.imageSmoothingEnabled = false;

      document.getElementById('headerTitle').innerHTML = `${{m.title}} (<code>${{m.id}}</code> · 10 Calques · PMDO 0.8.12.0)`;
      document.getElementById('mapSubtitle').textContent = m.subtitle;
      document.getElementById('windSummary').textContent = m.wind_summary;
      document.getElementById('refImg').src = m.ref_url;
      document.getElementById('refCaption').textContent = m.ref_label;
      const dl = document.getElementById('zipDownload');
      dl.href = m.zip_url;
      dl.textContent = `⬇ Télécharger ${{m.id}}_PMDO_0.8.12.zip (${{(m.zip_bytes / 1048576).toFixed(2)}} Mio)`;

      document.getElementById('metricsBox').innerHTML = `
        <div class="metric"><div class="k">Fidélité canonique</div><div class="v">${{m.fidelity.toFixed(2)}} &lt; 25</div></div>
        <div class="metric"><div class="k">Cycle sans couture</div><div class="v">${{m.n_frames}} poses (${{m.n_frames * m.frame_ticks}} ticks)</div></div>
        <div class="metric"><div class="k">Tuiles praticables</div><div class="v">${{m.walkable_tiles}} / ${{m.total_tiles}}</div></div>
        <div class="metric"><div class="k">Tuiles uniques GPU</div><div class="v">${{m.total_unique_tiles.toLocaleString('fr-FR')}}</div></div>
      `;

      const listEl = document.getElementById('layerList');
      listEl.innerHTML = '';
      m.layers.forEach((L) => {{
        const key = `${{m.id}}:${{L.slug}}`;
        if (!layerEnabled.has(key)) layerEnabled.set(key, true);
        const row = document.createElement('div');
        row.className = 'layer-row';
        const isAnim = L.poses > 1;
        row.innerHTML = `
          <label>
            <input type="checkbox" data-key="${{key}}" ${{layerEnabled.get(key) ? 'checked' : ''}} />
            <span><strong>${{String(L.index).padStart(2, '0')}}</strong> ${{L.name}}</span>
          </label>
          <span class="badge ${{isAnim ? 'anim' : ''}}">${{L.kind}} · ${{L.poses}}p@${{L.frame_length || 5}}t · ${{L.unique_tiles}}t</span>
        `;
        row.querySelector('input').addEventListener('change', (ev) => {{
          layerEnabled.set(key, ev.target.checked);
          renderCurrentFrame();
        }});
        listEl.appendChild(row);
      }});

      const statusEl = document.getElementById('loadStatus');
      let loaded = 0;
      await Promise.all(m.layers.map(async (L) => {{
        if (!L._img) {{
          const strip = await loadImg(L.strip_url);
          L._img = strip || await loadImg(L.static_url);
          L._isStrip = Boolean(strip);
        }}
        loaded += 1;
        statusEl.textContent = `Calques chargés : ${{loaded}} / ${{m.layers.length}}`;
      }}));
      statusEl.textContent = `✓ ${{m.layers.length}} / ${{m.layers.length}} calques temps réel prêts (échelle 1:1)`;
      renderCurrentFrame();
    }}

    let hwTick = 0;

    function renderCurrentFrame() {{
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      ctx.fillStyle = m.bg_fill || '#050b18';
      ctx.fillRect(0, 0, canvas.width, canvas.height);

      for (const L of m.layers) {{
        const key = `${{m.id}}:${{L.slug}}`;
        if (!layerEnabled.get(key) || !L._img) continue;
        if (L._isStrip) {{
          const fl = L.frame_length || m.frame_ticks || 5;
          const frame = L.poses > 1 ? (Math.floor(hwTick / fl) % L.poses) : 0;
          ctx.drawImage(L._img, frame * m.width, 0, m.width, m.height, 0, 0, m.width, m.height);
        }} else {{
          ctx.drawImage(L._img, 0, 0, m.width, m.height);
        }}
      }}

      if (showCollisions && m.walk_grid) {{
        ctx.fillStyle = 'rgba(72, 255, 168, 0.30)';
        const gh = m.walk_grid.length;
        const gw = m.walk_grid[0].length;
        for (let gy = 0; gy < gh; gy++) {{
          for (let gx = 0; gx < gw; gx++) {{
            if (m.walk_grid[gy][gx]) ctx.fillRect(gx * 8, gy * 8, 7, 7);
          }}
        }}
      }}

      poseIdx = Math.floor(hwTick / (m.frame_ticks || 5)) % m.n_frames;
      document.getElementById('frameLabel').textContent = `Pose ${{String(poseIdx).padStart(2, '0')}} / ${{m.n_frames - 1}} (tick ${{hwTick}})`;
      document.getElementById('frameSlider').value = String(poseIdx);
    }}

    function tick(now) {{
      const intervalMs = (1000 / 60) / speedMul;
      if (playing && (now - lastStepMs) >= intervalMs) {{
        const steps = Math.max(1, Math.min(4, Math.floor((now - lastStepMs) / intervalMs)));
        hwTick = (hwTick + steps) % 34720;
        lastStepMs = now;
        renderCurrentFrame();
      }}
      requestAnimationFrame(tick);
    }}

    document.getElementById('playBtn').addEventListener('click', (e) => {{
      playing = !playing;
      e.target.textContent = playing ? '⏸ Pause' : '▶ Lecture';
      e.target.classList.toggle('active', playing);
    }});
    document.getElementById('frameSlider').addEventListener('input', (e) => {{
      poseIdx = Number(e.target.value);
      hwTick = poseIdx * (m.frame_ticks || 5);
      renderCurrentFrame();
    }});
    document.querySelectorAll('[data-speed]').forEach((btn) => {{
      btn.addEventListener('click', () => {{
        speedMul = Number(btn.dataset.speed);
        document.querySelectorAll('[data-speed]').forEach((b) => b.classList.toggle('active', b === btn));
      }});
    }});
    document.getElementById('collBtn').addEventListener('click', (e) => {{
      showCollisions = !showCollisions;
      e.target.classList.toggle('active', showCollisions);
      renderCurrentFrame();
    }});
    document.getElementById('refBtn').addEventListener('click', (e) => {{
      showRef = !showRef;
      e.target.classList.toggle('active', showRef);
      document.getElementById('refBox').classList.toggle('visible', showRef);
    }});
    document.getElementById('allOnBtn').addEventListener('click', () => {{
      m.layers.forEach((L) => layerEnabled.set(`${{m.id}}:${{L.slug}}`, true));
      document.querySelectorAll('#layerList input[type="checkbox"]').forEach((c) => c.checked = true);
      renderCurrentFrame();
    }});
    document.getElementById('animOnlyBtn').addEventListener('click', () => {{
      m.layers.forEach((L) => layerEnabled.set(`${{m.id}}:${{L.slug}}`, L.poses > 1));
      document.querySelectorAll('#layerList input[type="checkbox"]').forEach((c, idx) => {{
        c.checked = m.layers[idx].poses > 1;
      }});
      renderCurrentFrame();
    }});

    buildTabs();
    initMap().then(() => requestAnimationFrame(tick));
  </script>
</body>
</html>
"""


def main() -> None:
    manifest = export_filmstrips()
    (REPO_ROOT / "index.html").write_text(build_html(manifest, default_map_id="MMA1"), encoding="utf-8")
    (REPO_ROOT / "apercu_mine_magma_multicalque_pmdo.html").write_text(
        build_html(manifest, default_map_id="MME1"), encoding="utf-8"
    )
    (REPO_ROOT / "apercu_sommet_tour_celeste_stc1_pmdo.html").write_text(
        build_html(manifest, default_map_id="STC1"), encoding="utf-8"
    )
    print("[Studio] index.html, apercu_mine_magma_multicalque_pmdo.html et apercu_sommet_tour_celeste_stc1_pmdo.html générés.")


if __name__ == "__main__":
    main()
