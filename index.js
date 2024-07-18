const path = require('path');

// Assume the first argument is the target directory
const targetDir = process.argv[2];

// Change the current working directory
process.chdir(targetDir);

// Remove the first argument and pass the remaining to tailwind
process.argv.splice(2, 1);

require('daisyui');
require('tailwindcss/lib/cli');
