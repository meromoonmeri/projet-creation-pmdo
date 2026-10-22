"""Tests -> ZIP projet PMDO + ZIP calques PNG/ORA -> aperçu autonome racine FGM1."""
from pathlib import Path
import subprocess
import sys

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
COMMON_DIR = R / 'source/entree_tour_celeste_sud_nord_v1'
if str(COMMON_DIR) not in sys.path:
    sys.path.insert(0, str(COMMON_DIR))

from sky_tower_common import package_lot  # noqa: E402


def main() -> None:
    subprocess.run([sys.executable, '-m', 'unittest', 'source.arene_grotte_meteore_deoxys_native_v1.test_build'], cwd=R, check=True)
    package_lot(
        here=HERE,
        lot_name='arene_grotte_meteore_deoxys_native_v1',
        namespace='arene_grotte_meteore_deoxys',
        pfx='FGM1',
        ora_name='FGM1_arene_grotte_meteore_calques.ora',
        anims=['onde_psionique_b74', 'levitation_meteorites'],
        ref_rel='references/b74_meteor_cave_deoxys.png',
        surface_css='rgb(0,0,72)',
        html_name='apercu_arene_grotte_meteore_deoxys_native_v1.html',
        goal_key='boss_px',
        fidelity_summary='Fidélité mesurée / rip b74 : 100 % Natif · distance RVB = 0,00 sur les 10 calques (recomposition t=0 bit-à-bit égale)',
    )


if __name__ == '__main__':
    main()
