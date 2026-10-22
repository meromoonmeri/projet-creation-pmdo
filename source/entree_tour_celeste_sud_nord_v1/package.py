"""Tests -> ZIP projet PMDO + ZIP calques PNG/ORA -> aperçu autonome racine EST1."""
from pathlib import Path
import json
import subprocess
import sys

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
if str(HERE) not in sys.path:
    sys.path.insert(0, str(HERE))

from sky_tower_common import package_lot  # noqa: E402


def main() -> None:
    subprocess.run([sys.executable, '-m', 'unittest', 'source.entree_tour_celeste_sud_nord_v1.test_build'], cwd=R, check=True)
    m = json.loads((R / 'renders/entree_tour_celeste_sud_nord_v1/manifest.json').read_text())
    max_b = max(v['distance'] for v in m['fidelite_rip']['brut'].values())
    package_lot(
        here=HERE,
        lot_name='entree_tour_celeste_sud_nord_v1',
        namespace='entree_tour_celeste',
        pfx='EST1',
        ora_name='EST1_entree_tour_celeste_calques.ora',
        anims=['courants_bpl', 'brises_et_eclats'],
        ref_rel='references/D13P01.png',
        surface_css='rgb(18,46,112)',
        html_name='apercu_entree_tour_celeste_sud_nord_v1.html',
        goal_key='threshold_px',
        fidelity_summary=f"Fidélité mesurée / rip D13P01 : max = {max_b:.1f} (seuil < 35) · sol_complet = {m['fidelite_rip']['sol_complet']:.1f}",
    )


if __name__ == '__main__':
    main()
