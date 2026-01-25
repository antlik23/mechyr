type HashingAlgorithms = 'SHA-1' | 'SHA-256' | 'SHA-384' | 'SHA-512';

export async function hash(text: string, algorithm: HashingAlgorithms) {
  const textBinary = new TextEncoder().encode(text);
  const hashBuffer = await window.crypto.subtle.digest(algorithm, textBinary);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  const hashHex = hashArray.map((bytes) => bytes.toString(16).padStart(2, '0')).join('');

  return hashHex;
}

export async function hashFile(file: File) {
  return await hash(`${file.lastModified}${file.size}${file.name}${file.type}`, 'SHA-1');
}
