#!/usr/bin/env python3
"""Validate a Nova candidate in exact PMDO 0.8.12."""
import argparse,json,shutil,subprocess,zipfile
from pathlib import Path
import build_pmdo_runtime_fixture as builder
from inventory_relict import sha256_file,write_json
from png_rgba import RGBAImage,load_png,save_png
from validate_pmdo_runtime import DOTNET_HEADLESS,PMDO,command,runtime_env,stop_group,wait_for_terminal
WORK=Path(__file__).resolve().parents[1];REPO=WORK.parents[1];CAND=WORK/"games/nova/conversion/pmdo_candidates";MAP_ID=3
def config(mid):
 global MAP_ID,ASSET,EVENTS,FIXTURE,STAGED,OUTPUT
 MAP_ID=mid;ASSET=f"nova_map_{mid:03d}";EVENTS=Path(f"/tmp/bibliotheque_nova_map{mid:03d}_validator.jsonl");FIXTURE=REPO/f".runtime-cache/bibliotheque-nova-map{mid:03d}-fixture";STAGED=REPO/f".runtime-cache/bibliotheque-nova-map{mid:03d}-candidate";OUTPUT=CAND/f"runtime/map_{mid:03d}"
config(74)
def stage(cand,dest):
 shutil.rmtree(dest,ignore_errors=True);gp=dest/f"Data/Ground/{ASSET}.rsground";gp.parent.mkdir(parents=True)
 with zipfile.ZipFile(cand/"nova_grounds.zip") as z:gp.write_bytes(z.read(f"{ASSET}.rsground"))
 g=json.loads(gp.read_text(encoding="utf-8-sig"));sheets={f["Sheet"] for l in g["Object"]["Layers"] for c in l["Tiles"] for cell in c for tl in cell["Layers"] for f in tl["Frames"]}
 if len(sheets)!=1:raise ValueError(sheets)
 sheet=sheets.pop();tp=dest/f"Content/Tile/{sheet}.tile";tp.parent.mkdir(parents=True);shutil.copy2(cand/f"tiles/{sheet}.tile",tp);return sheet,gp,tp
def compare(actual_path,expected_path,out,ex):
 actual=load_png(actual_path);expected=load_png(expected_path)
 if (actual.width,actual.height)!=(expected.width,expected.height):raise ValueError("runtime dimensions")
 left,top,right,bottom=ex;raw=actor=outside=maxdelta=0;bounds=None
 for pix in range(actual.width*actual.height):
  i=pix*4;ds=[abs(actual.pixels[i+c]-expected.pixels[i+c]) for c in range(4)]
  if not any(ds):continue
  raw+=1;x=pix%actual.width;y=pix//actual.width;bounds=[x,y,x,y] if bounds is None else [min(bounds[0],x),min(bounds[1],y),max(bounds[2],x),max(bounds[3],y)]
  if left<=x<right and top<=y<bottom:actor+=1
  else:outside+=1;maxdelta=max(maxdelta,*ds)
 if maxdelta>1:raise ValueError(f"visual mismatch {outside} delta {maxdelta}")
 scrub=RGBAImage(actual.width,actual.height,bytearray(actual.pixels))
 for y in range(max(0,top),min(actual.height,bottom)):
  a=(y*actual.width+max(0,left))*4;b=(y*actual.width+min(actual.width,right))*4;scrub.pixels[a:b]=expected.pixels[a:b]
 save_png(scrub,out);return {"raw_runtime_sha256":sha256_file(actual_path),"raw_runtime_pixels_exported":False,"raw_different_pixel_count":raw,"actor_excluded_pixel_count":actor,"raw_difference_bounds_inclusive":bounds,"environment_different_pixel_count":outside,"environment_max_channel_delta":maxdelta,"environment_evidence_sha256":sha256_file(out),"expected_sha256":sha256_file(expected_path),"dimensions_px":[actual.width,actual.height]}
def validate(cand,out,timeout=180):
 sheet,gp,tp=stage(cand,STAGED);builder.ASSET=ASSET;builder.SHEET=sheet;builder.QUEST_NAME="bibliotheque_nova_fixture";builder.EVENTS=str(EVENTS);manifest=builder.build(REPO,STAGED,FIXTURE)
 idx=subprocess.run(command(manifest,"-index","zone"),cwd=REPO,env=runtime_env(False),stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=300,check=True)
 if any(x in idx.stdout.lower() for x in (b"error",b"exception",b"failed to load")):raise ValueError("index error")
 EVENTS.unlink(missing_ok=True);screens=Path(manifest["appdata"])/"SCREENSHOT";shutil.rmtree(screens,ignore_errors=True);screens.mkdir(parents=True)
 with (FIXTURE/"runtime.log").open("wb") as log:
  p=subprocess.Popen(command(manifest),cwd=REPO,env=runtime_env(True),stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
  try:wait_for_terminal(p,EVENTS,timeout)
  finally:stop_group(p)
 events=[json.loads(x) for x in EVENTS.read_text().splitlines()];results=[x for x in events if x.get("event")=="result"]
 if len(results)!=1 or results[0].get("verdict")!="RUNTIME_PASS":raise ValueError(results)
 images=sorted(screens.glob("*.png"),key=lambda p:p.stat().st_mtime_ns)
 if len(images)!=2:raise ValueError("screenshots")
 out.mkdir(parents=True,exist_ok=True);(out/"events.jsonl").write_text("\n".join(json.dumps(x,separators=(",",":")) for x in events)+"\n");(out/"index.log").write_bytes(idx.stdout);spawn=manifest["spawn"]["movement_probes"]["successful"];ex=(spawn["x"]-16,spawn["y"]-32,spawn["x"]+32,spawn["y"]+32);visual=compare(images[0],cand/f"previews/map_{MAP_ID:03d}.png",out/"environment_tick_000.png",ex)
 report={"schema_version":"1.0.0","result":"NOVA_PMDO_RUNTIME_PASS","validation_status":"PMDO_VALIDATED","map_id":MAP_ID,"asset":ASSET,"viewport_px":[320,240],"tex_size":2,"ground_sha256":sha256_file(gp),"tile_sheet":sheet,"tile_sha256":sha256_file(tp),"pmdo_sha256":sha256_file(PMDO),"headless_sdl_sha256":sha256_file(next(DOTNET_HEADLESS.rglob("libSDL2-2.0.so.0"))),"runtime_destination_written":False,"runtime_probes":{"ground_load":"PASS","successful_movement":"PASS","blocked_movement":"PASS","terminal_event":"PASS"},"actor_exclusion_rect":{"x":ex[0],"y":ex[1],"width":ex[2]-ex[0],"height":ex[3]-ex[1]},"visual_validation":visual,"forbidden_content_check":{"fixture_actor_pixels_exported":False,"source_actor_pixels_exported":False,"dialogue_exported":False,"script_body_exported":False,"audio_binary_exported":False}};write_json(out/"runtime_report.json",report);return report
def main():
 p=argparse.ArgumentParser();p.add_argument("--candidates",type=Path,default=CAND);p.add_argument("--map-id",type=int,default=3);p.add_argument("--output",type=Path);p.add_argument("--timeout",type=int,default=180);a=p.parse_args();config(a.map_id);r=validate(a.candidates.resolve(),a.output.resolve() if a.output else OUTPUT.resolve(),a.timeout);print(json.dumps({"result":r["result"],"map_id":r["map_id"],"viewport_px":r["viewport_px"],"environment_different_pixel_count":r["visual_validation"]["environment_different_pixel_count"]},sort_keys=True));return 0
if __name__=="__main__":raise SystemExit(main())
