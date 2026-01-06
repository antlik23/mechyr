export function downloadBlob(blob: Blob, fileName: string) {
  const blobUrl = window.URL.createObjectURL(blob);

  const link = document.createElement('a');
  link.href = blobUrl;
  link.download = fileName;
  link.click();

  URL.revokeObjectURL(blobUrl);
}
