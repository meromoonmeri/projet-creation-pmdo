#!/usr/bin/env python3
"""Verification independante EFM1."""
from __future__ import annotations
import importlib.util, json, subprocess, sys, zipfile
from pathlib import Path
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
OUT=ROOT/"renders/entree_foret_mousse_sud_nord_v1"
STAGE=ROOT/".cache/entree_foret_mousse_sud_nord_v1/entree_foret_mousse"
def load_module(name,path):
    spec=importlib.util.spec_from_file_location(name,path)
    m=importlib.util.module_from_spec(spec); spec.loader.exec_module(m); return m
def main():
    mp=OUT/"manifest.json"
    if not mp.exists():
        subprocess.run([sys.executable,str(HERE/"build.py")],cwd=ROOT,check=True)
    subprocess.run([sys.executable,"-m","unittest","source.entree_foret_mousse_sud_nord_v1.test_build","-v"],cwd=ROOT,check=True)
    manifest=json.loads(mp.read_text(encoding="utf-8"))
    assert manifest["size_px"]==[768,576]
    assert manifest["grid_cells"]==[96,72]
    assert manifest["pmdo"]["version"]=="0.8.12.0"
    assert manifest["pmdo"]["runtime_tested"] is False
    assert manifest["art_approved"] is False
    assert manifest["pmdo"]["warp"] is None
    ora=ROOT/".cache/entree_foret_mousse_sud_nord_v1/EFM1_calques.ora"
    with zipfile.ZipFile(ora) as z:
        assert z.read("mimetype")==b"image/openraster"
        assert {"stack.xml","mergedimage.png","Thumbnails/thumbnail.png"} <= set(z.namelist())
    print("verify OK")
if __name__=="__main__":
    main()
