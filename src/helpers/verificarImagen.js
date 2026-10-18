// multer confía en el tipo que declara el navegador (que un atacante puede falsear).
// Esto abre el archivo ya guardado y comprueba que de verdad sea JPG, PNG o WEBP
// mirando sus primeros bytes. Si alguno no lo es, se borran todos y devuelve false.
const fs = require("fs");

function esImagenReal(ruta) {
  let fd;
  try {
    fd = fs.openSync(ruta, "r");
    const b = Buffer.alloc(12);
    fs.readSync(fd, b, 0, 12, 0);
    const jpg = b[0] === 0xff && b[1] === 0xd8 && b[2] === 0xff;
    const png = b.subarray(0, 8).equals(Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]));
    const webp = b.subarray(0, 4).toString("latin1") === "RIFF" && b.subarray(8, 12).toString("latin1") === "WEBP";
    return jpg || png || webp;
  } catch {
    return false;
  } finally {
    if (fd !== undefined) fs.closeSync(fd);
  }
}

function verificarArchivos(archivos = []) {
  if (archivos.every((f) => esImagenReal(f.path))) return true;
  archivos.forEach((f) => fs.unlink(f.path, () => {}));
  return false;
}

module.exports = { esImagenReal, verificarArchivos };
