const fs = require('fs');
const path = require('path');

const MANIFEST = 'package.json';

const [, , testDir] = process.argv;

const nodeModules = [];

(function traverse(dir) {
  const manifestPath = path.resolve(dir, MANIFEST);
  if (fs.existsSync(manifestPath)) {
    const { name, version } = require(manifestPath);
    nodeModules.push({
      name,
      version,
      dir,
    });
  }

  for (const dirent of fs.readdirSync(dir, { withFileTypes: true })) {
    if (!dirent.isDirectory()) {
      continue;
    }

    traverse(path.join(dir, dirent.name));
  }
})(testDir);

console.log('Generated node_modules structure:');

console.log(JSON.stringify(nodeModules, null, 2));
