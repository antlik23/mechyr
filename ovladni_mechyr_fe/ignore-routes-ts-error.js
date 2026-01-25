import fs from 'fs';

const filePath = './src/lib/ROUTES.ts';

// Read the existing content of the file.
fs.readFile(filePath, 'utf8', (error, data) => {
  if (error) {
    console.error(error);
    return;
  }

  // Prepend the string to the beginning of the content.
  const newData =
    '// eslint-disable-next-line @typescript-eslint/ban-ts-comment\n// @ts-nocheck\n' + data;

  // Overwrite the original file with the new content.
  fs.writeFile(filePath, newData, 'utf8', (error) => {
    if (error) {
      console.error(error);
    }
  });
});
