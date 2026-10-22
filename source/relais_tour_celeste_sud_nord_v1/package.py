"""Tests -> ZIP projet PMDO + ZIP calques PNG/ORA -> aperçu autonome racine MST1."""
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
    subprocess.run([sys.executable, '-m', 'unittest', 'source.relais_tour_celeste_sud_nord_v1.test_build'], cwd=R, check=True)
    m = json.loads((R / 'renders/relais_tour_celeste_sud_nord_v1/manifest.json').read_text())
    max_b = max(v['distance'] for v in m['fidelite_rip']['brut'].values())
    package_lot(
        here=HERE,
        lot_name='relais_tour_celeste_sud_nord_v1',
        namespace='relais_tour_celeste',
        pfx='MST1',
        ora_name='MST1_relais_tour_celeste_calques.ora',
        anims=['scintillement_bpl', 'eclats_et_brises'],
        ref_rel='references/D13P02.png',
        surface_css='rgb(22,52,128)',
        html_name='apercu_relais_tour_celeste_sud_nord_v1.html',
        goal_key='threshold_px',
        fidelity_summary=f"Fidélité mesurée / rip D13P02 : max = {max_b:.1f} (seuil < 35) · sol_complet natif = {m['fidelite_rip']['sol_complet']:.2f}",
    )


if __name__ == '__main__':
    main()
