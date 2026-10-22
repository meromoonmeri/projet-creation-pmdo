#!/usr/bin/env node
import { pathToFileURL } from 'node:url';
import { dirname, join, resolve } from 'node:path';
import fs from 'node:fs';

if (process.argv.length !== 5) {
  throw new Error('usage: extract-all.mjs BUNDLE DATA_WIN OUTPUT_DIRECTORY');
}
const bundle = resolve(process.argv[2]);
const input = resolve(process.argv[3]);
const output = resolve(process.argv[4]);
const { dotnet } = await import(pathToFileURL(join(bundle, '_framework', 'dotnet.js')).href);
const runtime = await dotnet
  .withConsoleForwarding()
  .withApplicationArguments('/work/data.win', '/out')
  .create();
const virtual = runtime.Module.FS;
virtual.mkdir('/work');
virtual.mkdir('/out');
console.error(`[extract-host] importing ${input}`);
const inputBytes = fs.readFileSync(input);
virtual.writeFile('/work/data.win', inputBytes);
console.error(`[extract-host] imported ${inputBytes.length} bytes`);
const code = await runtime.runMain();

function copyTree(virtualPath, hostPath) {
  fs.mkdirSync(hostPath, { recursive: true });
  for (const name of virtual.readdir(virtualPath)) {
    if (name === '.' || name === '..') continue;
    const source = `${virtualPath}/${name}`;
    const target = join(hostPath, name);
    const stat = virtual.stat(source);
    if (virtual.isDir(stat.mode)) copyTree(source, target);
    else if (virtual.isFile(stat.mode)) {
      fs.mkdirSync(dirname(target), { recursive: true });
      fs.writeFileSync(target, virtual.readFile(source));
    }
  }
}

console.error(`[extract-host] exporting to ${output}`);
copyTree('/out', output);
console.error(`[extract-host] exit ${code}`);
process.exitCode = code;
