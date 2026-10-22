"""Tests -> ZIP projet PMDO + ZIP calques PNG/ORA -> aperçu autonome racine SST1."""
from pathlib import Path
import json
import subprocess
import sys

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
COMMON_DIR = R / 'source/entree_tour_celeste_sud_nord_v1'
if str(COMMON_DIR) not in sys.path:
    sys.path.insert(0, str(COMMON_DIR))

from sky_tower_common import package_lot  # noqa: E402


def main() -> None:
    subprocess.run([sys.executable, '-m', 'unittest', 'source.sommet_tour_celeste_rayquaza_v1.test_build'], cwd=R, check=True)
    m = json.loads((R / 'renders/sommet_tour_celeste_rayquaza_v1/manifest.json').read_text())
    max_b = max(v['distance'] for v in m['fidelite_rip']['brut'].values())
    package_lot(
        here=HERE,
        lot_name='sommet_tour_celeste_rayquaza_v1',
        namespace='sommet_tour_celeste',
        pfx='SST1',
        ora_name='SST1_sommet_tour_celeste_calques.ora',
        anims=['souffle_stratosphere_bpl', 'alizes_et_eclats'],
        ref_rel='references/b71_sky_tower_summit.png',
        surface_css='rgb(12,26,118)',
        html_name='apercu_sommet_tour_celeste_rayquaza_v1.html',
        goal_key='boss_px',
        fidelity_summary=f"Fidélité mesurée / rip b71 : max = {max_b:.2f} (seuil < 35) · sol_complet = {m['fidelite_rip']['sol_complet']:.2f}",
    )


if __name__ == '__main__':
    main()
