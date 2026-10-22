#!/usr/bin/env node
import { pathToFileURL } from 'node:url';
import { dirname, join, resolve } from 'node:path';
import fs from 'node:fs';

if (process.argv.length < 5) {
  throw new Error('usage: utmt-host.mjs BUNDLE COMMAND DATA_WIN [UTMT OPTIONS]');
}
const bundle = resolve(process.argv[2]);
let args = process.argv.slice(3);
const dataHost = resolve(args[1]);
args[1] = '/work/data.win';
let outputHost = process.env.UTMT_EXPORT_DIR ? resolve(process.env.UTMT_EXPORT_DIR) : null;
const scriptImports = [];
for (let index = 2; index < args.length; index++) {
  if ((args[index] === '-o' || args[index] === '--output') && index + 1 < args.length) {
    outputHost = resolve(args[index + 1]);
    args[index + 1] = '/out';
    index++;
  }
  if ((args[index] === '-s' || args[index] === '--scripts') && index + 1 < args.length) {
    let scriptIndex = 0;
    for (let cursor = index + 1; cursor < args.length && !args[cursor].startsWith('-'); cursor++) {
      const host = resolve(args[cursor]);
      const virtual = `/work/script${scriptIndex++}.csx`;
      scriptImports.push([host, virtual]);
      args[cursor] = virtual;
    }
  }
}
const { dotnet } = await import(pathToFileURL(join(bundle, '_framework', 'dotnet.js')).href);
const runtime = await dotnet.withConsoleForwarding().withApplicationArguments(...args).create();
const virtualFs = runtime.Module.FS;
for (const path of ['/work', '/out']) {
  try { virtualFs.mkdir(path); } catch {}
}
console.error(`[wasm-host] importing ${dataHost}`);
const bytes = fs.readFileSync(dataHost);
virtualFs.writeFile('/work/data.win', bytes);
console.error(`[wasm-host] imported ${bytes.length} bytes`);
for (const [host, virtual] of scriptImports) virtualFs.writeFile(virtual, fs.readFileSync(host));
const code = await runtime.runMain();

function exportTree(virtualPath, hostPath) {
  fs.mkdirSync(hostPath, { recursive: true });
  for (const name of virtualFs.readdir(virtualPath)) {
    if (name === '.' || name === '..') continue;
    const source = `${virtualPath}/${name}`;
    const target = join(hostPath, name);
    const stat = virtualFs.stat(source);
    if (virtualFs.isDir(stat.mode)) exportTree(source, target);
    else if (virtualFs.isFile(stat.mode)) {
      fs.mkdirSync(dirname(target), { recursive: true });
      fs.writeFileSync(target, virtualFs.readFile(source));
    }
  }
}
if (outputHost) exportTree('/out', outputHost);
console.error(`[wasm-host] exit ${code}`);
process.exitCode = code;
