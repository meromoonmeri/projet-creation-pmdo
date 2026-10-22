#!/usr/bin/env python3
"""Static narrative audit for Rescue Team locations integrated into New Era."""
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---
from pathlib import Path
import json,re
ROOT=Path(__file__).resolve().parents[1]
CANON={
'gloomy_forest':('Sinister Woods',6,'Team Dazzling replaces Team Meanies role-for-role; Caterpie rescue and clearing confrontation retained.'),
'magma_cavern':('Magma Cavern',7,'Aged original Team ACT, Groudon and thirty-year continuity; no duplicate Aegis Cave climax.'),
'waterfall_pond':('Waterfall Pond / Crystal Sanctuary',8,'New Era crystal arc overlay; canonical Waterfall Pond remains a distinct location contract.'),
'sky_tower':('Sky Tower',10,'New Era Lugia/Necrozma climax occupies the location; Rayquaza meteor history must be memory, not replayed present-day.'),
'wish_cave':('Wish Cave',12,'Jirachi and wish contract retained as postgame; never converted into a Friend Area.'),
'mt_blaze':('Mt. Blaze',12,'Legacy expedition/revisit; Moltres remains the location guardian.'),
'frosty_forest':('Frosty Forest',12,'Legacy expedition/revisit; Articuno confrontation retained.'),
'mt_freeze':('Mt. Freeze',12,'Legacy expedition/revisit; Ninetales revelation preserved as historical testimony.'),
'lapis_cave':('Lapis Cave',12,'Fugitive-route legacy expedition; no unrelated boss insertion.'),
}
rows=[];errors=[]
for zid,(canon,chapter,contract) in CANON.items():
 p=ROOT/'Data/Zone'/f'{zid}.json'
 if not p.exists():errors.append(f'{zid}: ZoneData absent');continue
 o=json.load(open(p,encoding='utf-8-sig'))['Object'];grounds=o.get('GroundMaps',[]);mapped=set(re.findall(r'"MapID"\s*:\s*"([^"]+)"',p.read_text(encoding='utf-8-sig')));beats=[]
 for g in grounds:
  d=ROOT/'Data/Script/halcyon/ground'/g;files=list(d.glob('*.lua')) if d.exists() else []
  text='\n'.join(x.read_text(errors='ignore') for x in files);funcs=sorted(set(re.findall(r'function\s+[\w.]+\.([A-Za-z0-9_]+)',text)));beats += funcs
  if not files:errors.append(f'{zid}/{g}: aucun script Ground')
 rows.append({'zone':zid,'canonical_name':canon,'new_era_chapter':chapter,'segments':len(o.get('Segments',[])),'grounds':grounds,'mapped_rooms':sorted(mapped),'cinematic_functions':sorted(set(beats)),'contract':contract,'released':o.get('Released',False)})
reg=(ROOT/'Data/Script/halcyon/RedCanonicalCampaign.lua').read_text(errors='ignore');registered=sorted(set(re.findall(r"'([a-z][a-z0-9_]+)'",reg))) if reg else []
report={'schema':1,'scope':'PMD Red dungeons already integrated into New Era chapters plus registered postgame destinations','rules':['same canonical geography and Ground','original cinematic positions/choreography retained where source exists','New Era cast substitutes narrative roles without erasing original historical cast','legendary stays in canonical dungeon','Friend Areas are residential unlocks only','battle rsmap visually matches cinematic Ground','historical events are memories/testimony, not contradictory present-day replays'],'zones':rows,'registered_campaign_tokens':registered,'errors':errors}
out=ROOT/'docs/canonical/red';out.mkdir(parents=True,exist_ok=True);(out/'narrative_audit.json').write_text(json.dumps(report,indent=2,ensure_ascii=False)+'\n')
lines=['# Audit narratif — intégration PMD Red dans New Era','','**Statut : audit préalable, aucune cinématique modifiée par ce commit.**','',f'Zones canoniques actives auditées : **{len(rows)}**. Erreurs structurelles : **{len(errors)}**.','', '## Règles de continuité']+[f'- {x}' for x in report['rules']]+['','## Matrice des chapitres','', '| Zone | Canon | Chapitre | Segments | Grounds | Fonctions cinématiques détectées |','|---|---|---:|---:|---:|---:|']
for r in rows:lines.append(f"| `{r['zone']}` | {r['canonical_name']} | {r['new_era_chapter']} | {r['segments']} | {len(r['grounds'])} | {len(r['cinematic_functions'])} |")
lines += ['','## Contrats scène par scène','','### Chapitre 6 — Sinister Woods','- Conserver D04P01 comme approche et D04P02 comme clairière de confrontation.','- Team Dazzling occupe les rôles dramatiques de Team Meanies; elle ne change ni le lieu ni la géographie.','- Le sauvetage, le mini-boss, la confrontation et les conséquences à Metano doivent former une chaîne sans saut.','','### Chapitre 7 — Magma Cavern','- Team ACT est l’équipe originale, vieillie de trente ans.','- Entrée, cœur, fosse et Groudon restent une seule progression.','- La victoire ne doit pas réécrire le climax Aegis Cave du chapitre 5.','','### Chapitre 8','- Crystal Sanctuary reste l’arc New Era. Waterfall Pond canonique doit demeurer disponible séparément dans le postgame.','','### Chapitres 9–11','- Les arcs Suaire, Lugia/Necrozma et Accusation restent inchangés.','- Sky Tower distingue explicitement le présent New Era de la mémoire du météore/Rayquaza.','','### Après le chapitre 11','- Les donjons Red sont ouverts en vagues parallèles; aucun ordre fictif n’est imposé entre les arcs indépendants.','- Moltres, Articuno, Ninetales, Groudon, Rayquaza et Jirachi restent liés à leurs lieux canoniques.','','## Lacunes avant implémentation','- Les destinations postgame enregistrées sans ZoneData ne peuvent pas recevoir de cinématique exécutable avant création de leur zone.','- Chaque nouvelle scène doit avoir quatre états : première arrivée, nouvelle tentative, victoire, défaite/repli.','- Chaque boss doit retourner sur le même Ground après le combat et utiliser un `.rsmap` visuellement identique.','- Les 27 Grounds dungeon-backed doivent utiliser les reconstructions ROM corrigées, jamais les anciens placeholders.']
if errors:lines += ['','## Erreurs structurelles']+[f'- {e}' for e in errors]
(out/'NARRATIVE_AUDIT.md').write_text('\n'.join(lines)+'\n')
print(json.dumps({'zones':len(rows),'errors':len(errors)}));raise SystemExit(bool(errors))
