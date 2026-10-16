// Genera las ilustraciones de muestra de la tienda (public/img/productos/*.svg
// y public/img/inicio/*.svg). Son dibujos vectoriales de cada prenda, para que
// el catálogo se vea completo antes de cargar las fotos reales.
//
//   node database/fotos-demo/generar.js
//
// Las fotos reales se cambian desde el panel (Admin → Productos → Editar →
// Imágenes) y las del inicio desde Admin → Inicio. Este script no hace falta
// en producción.

const fs = require("fs");
const path = require("path");

const SALIDA_PRODUCTOS = path.join(__dirname, "../../public/img/productos");
const SALIDA_INICIO = path.join(__dirname, "../../public/img/inicio");

// ── Colores ────────────────────────────────────────────────
const mezclar = (hex, con, t) => {
  const a = hex.match(/\w\w/g).map((h) => parseInt(h, 16));
  const b = con.match(/\w\w/g).map((h) => parseInt(h, 16));
  return "#" + a.map((v, i) => Math.round(v + (b[i] - v) * t).toString(16).padStart(2, "0")).join("");
};
const tonos = (base) => ({
  base,
  claro: mezclar(base, "ffffff", 0.22),
  oscuro: mezclar(base, "000000", 0.18),
  linea: mezclar(base, "000000", 0.32),
});

const TELAS = {
  rosa: "#d4708f",
  rosaClaro: "#e9a3b9",
  negro: "#2a2326",
  beige: "#dcc6ae",
  blanco: "#f6f1ec",
  celeste: "#9dbad3",
  marron: "#7b4d34",
  borravino: "#7d2b46",
  dorado: "#c9a24a",
  perla: "#f3ece4",
};

const FONDOS = {
  arena: ["#efe0d6", "#dcc3b4"],
  rosa: ["#f4d9de", "#e6b9c4"],
  crema: ["#f7ece4", "#e7d3c5"],
  malva: ["#ecd5da", "#d3aab6"],
  oscuro: ["#4a3a40", "#2f2428"],
};

// ── Prendas (viewBox 800 × 800, centradas en x = 400) ──────
// Cada una recibe los tonos de la tela y devuelve el SVG de la prenda.
const sombra = (d, c, extra = "") =>
  `<path d="${d}" fill="url(#tela-${c.base.slice(1)})" ${extra}/>`;

function perchero(color = "#b9a597") {
  return `<g fill="none" stroke="${color}" stroke-width="4" stroke-linecap="round" stroke-linejoin="round">
    <path d="M400 128 V108 a15 15 0 1 1 15 15"/>
    <path d="M400 128 L252 192 Q240 198 254 198 L546 198 Q560 198 548 192 Z"/>
  </g>`;
}

const prendas = {
  blusa(c) {
    const cuerpo = "M335 190 L372 190 L400 260 L428 190 L465 190 Q495 196 505 215 L512 300 Q520 420 528 520 Q534 590 540 642 Q400 672 260 642 Q266 590 272 520 Q280 420 288 300 L295 215 Q305 196 335 190 Z";
    const mangaI = "M295 215 C225 203 170 255 186 337 Q190 354 215 358 Q252 364 288 346 L289 300 Z";
    const mangaD = "M505 215 C575 203 630 255 614 337 Q610 354 585 358 Q548 364 512 346 L511 300 Z";
    return `
      ${sombra(mangaI, c)}${sombra(mangaD, c)}${sombra(cuerpo, c)}
      <path d="M295 215 C255 235 215 290 214 352" fill="none" stroke="${c.linea}" stroke-opacity=".25" stroke-width="2"/>
      <path d="M505 215 C545 235 585 290 586 352" fill="none" stroke="${c.linea}" stroke-opacity=".25" stroke-width="2"/>
      <path d="M198 340 Q245 368 289 346 M602 340 Q555 368 511 346" fill="none" stroke="${c.linea}" stroke-opacity=".45" stroke-width="5" stroke-linecap="round"/>
      <path d="M335 190 L400 262 L465 190" fill="none" stroke="${c.oscuro}" stroke-width="7" stroke-linejoin="round"/>
      <path d="M400 262 V650" stroke="${c.linea}" stroke-opacity=".3" stroke-width="2"/>
      ${[310, 372, 434, 496, 558, 620].map((y) => `<circle cx="400" cy="${y}" r="5" fill="${c.claro}" stroke="${c.linea}" stroke-opacity=".5"/>`).join("")}
      <path d="M300 330 Q330 470 318 640" fill="none" stroke="#fff" stroke-opacity=".12" stroke-width="22" stroke-linecap="round"/>
      <path d="M262 642 Q400 672 538 642" fill="none" stroke="${c.linea}" stroke-opacity=".3" stroke-width="3"/>`;
  },

  camisa(c) {
    const cuerpo = "M330 190 L372 190 L400 232 L428 190 L470 190 Q500 198 508 218 L514 300 Q522 420 528 520 Q534 590 538 650 Q400 676 262 650 Q266 590 272 520 Q278 420 286 300 L292 218 Q300 198 330 190 Z";
    const mangaI = "M292 218 L196 300 Q176 330 200 366 L240 392 L288 330 Z";
    const mangaD = "M508 218 L604 300 Q624 330 600 366 L560 392 L512 330 Z";
    return `
      ${sombra(mangaI, c)}${sombra(mangaD, c)}${sombra(cuerpo, c)}
      <path d="M330 190 L372 190 L400 232 L428 190 L470 190 L440 250 L400 236 L360 250 Z" fill="${c.claro}" stroke="${c.linea}" stroke-opacity=".4" stroke-width="2" stroke-linejoin="round"/>
      <path d="M400 236 V660" stroke="${c.linea}" stroke-opacity=".35" stroke-width="2"/>
      ${[290, 360, 430, 500, 570, 630].map((y) => `<circle cx="400" cy="${y}" r="5" fill="${c.claro}" stroke="${c.linea}" stroke-opacity=".5"/>`).join("")}
      <path d="M206 350 L245 385 M594 350 L555 385" stroke="${c.linea}" stroke-opacity=".4" stroke-width="4" stroke-linecap="round"/>
      <rect x="318" y="330" width="44" height="50" rx="3" fill="none" stroke="${c.linea}" stroke-opacity=".3" stroke-width="2"/>
      <path d="M300 330 Q326 470 316 650" fill="none" stroke="#fff" stroke-opacity=".12" stroke-width="22" stroke-linecap="round"/>`;
  },

  top(c) {
    const cuerpo = "M308 188 L346 188 L348 268 L452 268 L454 188 L492 188 L499 275 Q502 330 493 380 Q480 450 486 525 L490 566 Q400 580 310 566 L314 525 Q320 450 307 380 Q298 330 301 275 Z";
    return `
      <defs><clipPath id="clip-top"><path d="${cuerpo}"/></clipPath></defs>
      ${sombra(cuerpo, c)}
      <g clip-path="url(#clip-top)" stroke="${c.linea}" stroke-opacity=".22" stroke-width="2">
        ${Array.from({ length: 22 }, (_, i) => `<path d="M${296 + i * 10} 180 V600"/>`).join("")}
      </g>
      <path d="M348 268 L452 268" stroke="${c.oscuro}" stroke-width="6" stroke-linecap="round"/>
      <path d="M312 566 Q400 580 488 566" stroke="${c.oscuro}" stroke-opacity=".6" stroke-width="7" fill="none"/>`;
  },

  halter(c) {
    const cuerpo = "M345 196 Q400 330 455 196 L478 262 Q492 330 484 400 Q476 470 486 540 Q400 566 314 540 Q324 470 316 400 Q308 330 322 262 Z";
    return `
      <defs><clipPath id="clip-halter"><path d="${cuerpo}"/></clipPath></defs>
      ${sombra(cuerpo, c)}
      <g clip-path="url(#clip-halter)" stroke="${c.linea}" stroke-opacity=".2" stroke-width="2">
        ${Array.from({ length: 20 }, (_, i) => `<path d="M${306 + i * 10} 190 V560"/>`).join("")}
      </g>
      <path d="M345 196 Q400 330 455 196" fill="none" stroke="${c.oscuro}" stroke-width="7" stroke-linecap="round"/>
      <path d="M345 196 Q362 140 400 130 M455 196 Q438 140 400 130" fill="none" stroke="${c.oscuro}" stroke-width="6" stroke-linecap="round"/>`;
  },

  vestido(c) {
    const cuerpo = "M362 250 L400 330 L438 250 Q452 300 448 340 Q444 400 440 432 Q470 560 504 722 Q400 748 296 722 Q330 560 360 432 Q356 400 352 340 Q348 300 362 250 Z";
    return `
      <path d="M352 168 L362 250 M448 168 L438 250" fill="none" stroke="${c.oscuro}" stroke-width="7" stroke-linecap="round"/>
      ${sombra(cuerpo, c)}
      <path d="M362 250 L400 330 L438 250" fill="none" stroke="${c.oscuro}" stroke-width="6" stroke-linejoin="round"/>
      <path d="M358 432 Q400 448 442 432" fill="none" stroke="${c.linea}" stroke-opacity=".3" stroke-width="3"/>
      <path d="M392 450 Q380 600 340 722 M412 450 Q418 600 452 722 M370 450 Q350 590 318 720" fill="none" stroke="${c.linea}" stroke-opacity=".22" stroke-width="3"/>
      <path d="M440 520 L474 722" stroke="${c.linea}" stroke-opacity=".55" stroke-width="3"/>
      <path d="M440 520 L474 722 L504 722 Q480 600 440 520 Z" fill="${c.oscuro}" fill-opacity=".35"/>
      <path d="M368 470 Q346 600 318 720" fill="none" stroke="#fff" stroke-opacity=".14" stroke-width="24" stroke-linecap="round"/>`;
  },

  vestidoCorto(c) {
    const cuerpo = "M350 200 L400 260 L450 200 L478 250 Q484 330 470 400 Q500 470 520 560 Q400 596 280 560 Q300 470 330 400 Q316 330 322 250 Z";
    return `
      ${sombra(cuerpo, c)}
      <path d="M350 200 L400 260 L450 200" fill="none" stroke="${c.oscuro}" stroke-width="7" stroke-linejoin="round"/>
      <path d="M326 400 Q400 424 474 400" fill="none" stroke="${c.linea}" stroke-opacity=".35" stroke-width="3"/>
      <path d="M360 430 Q344 500 312 560 M400 430 V584 M440 430 Q456 500 488 560" fill="none" stroke="${c.linea}" stroke-opacity=".2" stroke-width="3"/>
      <path d="M340 210 Q326 300 342 400" fill="none" stroke="#fff" stroke-opacity=".14" stroke-width="20" stroke-linecap="round"/>`;
  },

  pantalon(c) {
    const cuerpo = "M305 214 L495 214 Q508 300 520 340 Q540 520 562 736 Q490 750 414 742 L400 430 L386 742 Q310 750 238 736 Q260 520 280 340 Q292 300 305 214 Z";
    return `
      ${sombra(cuerpo, c)}
      <rect x="305" y="170" width="190" height="48" rx="6" fill="${c.oscuro}"/>
      <path d="M305 194 H495" stroke="#fff" stroke-opacity=".12" stroke-width="3"/>
      <path d="M400 218 V330" stroke="${c.linea}" stroke-opacity=".4" stroke-width="2"/>
      <circle cx="400" cy="194" r="7" fill="${c.claro}" stroke="${c.linea}" stroke-opacity=".5"/>
      <path d="M350 230 Q344 300 330 370 M450 230 Q456 300 470 370" fill="none" stroke="${c.linea}" stroke-opacity=".3" stroke-width="2.5"/>
      <path d="M352 250 Q338 500 306 740 M448 250 Q462 500 494 740" fill="none" stroke="${c.linea}" stroke-opacity=".25" stroke-width="2.5"/>
      <path d="M330 300 Q316 520 270 730" fill="none" stroke="#fff" stroke-opacity=".12" stroke-width="26" stroke-linecap="round"/>`;
  },

  jean(c) {
    const cuerpo = "M312 214 L488 214 Q502 300 506 350 Q516 530 530 736 Q474 746 424 740 L400 420 L376 740 Q326 746 270 736 Q284 530 294 350 Q298 300 312 214 Z";
    return `
      ${sombra(cuerpo, c)}
      <rect x="312" y="170" width="176" height="48" rx="5" fill="${c.oscuro}"/>
      <circle cx="400" cy="194" r="8" fill="${c.dorado || "#c9a24a"}" stroke="#8a6d1f" stroke-opacity=".6"/>
      <path d="M400 218 V326 M400 326 Q370 330 352 300" fill="none" stroke="#f1d9a0" stroke-opacity=".8" stroke-width="2.5" stroke-dasharray="6 5"/>
      <path d="M340 222 Q380 290 352 300 M460 222 Q420 290 448 300" fill="none" stroke="#f1d9a0" stroke-opacity=".8" stroke-width="2.5" stroke-dasharray="6 5"/>
      <path d="M394 740 L400 420 L406 740" fill="none" stroke="${c.linea}" stroke-opacity=".3" stroke-width="2"/>
      <path d="M318 300 Q306 540 286 730" fill="none" stroke="#fff" stroke-opacity=".14" stroke-width="22" stroke-linecap="round"/>`;
  },

  blazer(c, interior = TELAS.blanco) {
    const t = tonos(interior);
    const mangaI = "M300 205 Q258 218 246 292 L216 604 Q214 626 238 628 L284 632 Q304 632 304 612 L320 332 Z";
    const mangaD = "M500 205 Q542 218 554 292 L584 604 Q586 626 562 628 L516 632 Q496 632 496 612 L480 332 Z";
    const torso = "M300 205 L332 195 L372 192 L400 340 L428 192 L468 195 L500 205 L514 330 L522 632 L278 632 L286 330 Z";
    return `
      ${sombra(mangaI, c)}${sombra(mangaD, c)}${sombra(torso, c)}
      <path d="M372 192 L428 192 L400 340 Z" fill="${t.base}"/>
      <path d="M372 192 Q400 214 428 192" fill="none" stroke="${t.linea}" stroke-opacity=".35" stroke-width="3"/>
      <path d="M346 196 L372 192 L402 336 L368 352 L334 292 L352 258 Z" fill="${c.claro}" stroke="${c.linea}" stroke-opacity=".45" stroke-width="2" stroke-linejoin="round"/>
      <path d="M454 196 L428 192 L398 336 L432 352 L466 292 L448 258 Z" fill="${c.claro}" stroke="${c.linea}" stroke-opacity=".45" stroke-width="2" stroke-linejoin="round"/>
      <path d="M402 336 V632" stroke="${c.linea}" stroke-opacity=".4" stroke-width="2"/>
      <circle cx="410" cy="440" r="8" fill="${c.oscuro}" stroke="${c.linea}" stroke-opacity=".5"/>
      <circle cx="410" cy="520" r="8" fill="${c.oscuro}" stroke="${c.linea}" stroke-opacity=".5"/>
      <path d="M314 524 H368 M432 524 H486" stroke="${c.linea}" stroke-opacity=".5" stroke-width="5" stroke-linecap="round"/>
      <path d="M234 600 L290 606 M566 600 L510 606" stroke="${c.linea}" stroke-opacity=".4" stroke-width="3"/>
      <path d="M300 340 Q290 500 296 620" fill="none" stroke="#fff" stroke-opacity=".12" stroke-width="22" stroke-linecap="round"/>`;
  },

  // ── Accesorios (sin percha) ──
  cartera(c) {
    const cuerpo = "M282 400 Q282 360 322 360 L478 360 Q518 360 518 400 L544 646 Q548 684 514 684 L286 684 Q252 684 256 646 Z";
    return `
      <path d="M332 366 Q332 236 400 236 Q468 236 468 366" fill="none" stroke="${c.oscuro}" stroke-width="16" stroke-linecap="round"/>
      ${sombra(cuerpo, c)}
      <path d="M284 410 Q400 500 516 410" fill="${c.claro}" fill-opacity=".5" stroke="${c.linea}" stroke-opacity=".45" stroke-width="3"/>
      <circle cx="400" cy="470" r="17" fill="${TELAS.dorado}" stroke="#8a6d1f" stroke-opacity=".6" stroke-width="2"/>
      <path d="M270 640 Q400 664 530 640" fill="none" stroke="${c.linea}" stroke-opacity=".3" stroke-width="3"/>
      <path d="M296 440 Q282 560 284 640" fill="none" stroke="#fff" stroke-opacity=".15" stroke-width="18" stroke-linecap="round"/>`;
  },

  tote(c) {
    const cuerpo = "M244 330 L556 330 L590 690 Q592 710 570 710 L230 710 Q208 710 210 690 Z";
    return `
      <path d="M312 336 Q312 190 360 190 M488 336 Q488 190 440 190 M360 190 H440" fill="none" stroke="${c.oscuro}" stroke-width="16" stroke-linecap="round" stroke-linejoin="round"/>
      ${sombra(cuerpo, c)}
      <path d="M244 372 H556" stroke="${c.linea}" stroke-opacity=".35" stroke-width="3" stroke-dasharray="8 6"/>
      <rect x="352" y="470" width="96" height="70" rx="4" fill="none" stroke="${c.linea}" stroke-opacity=".35" stroke-width="3"/>
      <circle cx="400" cy="505" r="9" fill="${TELAS.dorado}" stroke="#8a6d1f" stroke-opacity=".6"/>
      <path d="M232 420 Q226 560 232 690" fill="none" stroke="#fff" stroke-opacity=".14" stroke-width="20" stroke-linecap="round"/>`;
  },

  cinto(c) {
    return `
      <g transform="rotate(-8 400 400)">
        <rect x="110" y="368" width="580" height="64" rx="10" fill="url(#tela-${c.base.slice(1)})"/>
        <path d="M130 380 H670 M130 420 H670" stroke="#f1e0c4" stroke-opacity=".6" stroke-width="2" stroke-dasharray="7 6"/>
        ${[440, 490, 540, 590, 640].map((x) => `<circle cx="${x}" cy="400" r="6" fill="${c.oscuro}" stroke="${c.linea}" stroke-opacity=".4"/>`).join("")}
        <rect x="120" y="350" width="96" height="100" rx="14" fill="none" stroke="${TELAS.dorado}" stroke-width="12"/>
        <rect x="120" y="350" width="96" height="100" rx="14" fill="none" stroke="#fff" stroke-opacity=".25" stroke-width="3"/>
        <path d="M156 400 H258" stroke="${TELAS.dorado}" stroke-width="8" stroke-linecap="round"/>
        <rect x="318" y="358" width="30" height="84" rx="6" fill="${c.oscuro}"/>
      </g>`;
  },

  aros(c) {
    const aro = (x) => `
      <path d="M${x} 232 q-18 -22 6 -30 q22 -4 18 22" fill="none" stroke="${TELAS.dorado}" stroke-width="6" stroke-linecap="round"/>
      <circle cx="${x}" cy="252" r="11" fill="${TELAS.dorado}" stroke="#8a6d1f" stroke-opacity=".5"/>
      <path d="M${x} 262 V300" stroke="${TELAS.dorado}" stroke-width="5"/>
      <circle cx="${x}" cy="348" r="48" fill="url(#perla)"/>
      <circle cx="${x - 16}" cy="332" r="12" fill="#fff" fill-opacity=".75"/>`;
    return `
      <defs><radialGradient id="perla" cx=".38" cy=".34" r=".8"><stop offset="0" stop-color="#ffffff"/><stop offset=".6" stop-color="${TELAS.perla}"/><stop offset="1" stop-color="#cdbfb3"/></radialGradient></defs>
      ${aro(318)}${aro(482)}`;
  },

  collar(c) {
    return `
      <path d="M232 250 Q400 580 568 250" fill="none" stroke="${TELAS.dorado}" stroke-width="12" stroke-linecap="round" stroke-dasharray="0 17"/>
      <path d="M232 250 Q400 580 568 250" fill="none" stroke="#fff" stroke-opacity=".25" stroke-width="3" stroke-linecap="round" stroke-dasharray="0 17"/>
      <circle cx="400" cy="415" r="34" fill="none" stroke="${TELAS.dorado}" stroke-width="9"/>
      <circle cx="400" cy="415" r="12" fill="${TELAS.dorado}"/>`;
  },
};

const conPercha = new Set(["blusa", "camisa", "top", "halter", "vestido", "vestidoCorto", "pantalon", "jean", "blazer"]);

// ── Escena ─────────────────────────────────────────────────
function escena({ prenda, tela, fondo = "arena", detalle = false, interior }) {
  const c = tonos(tela);
  const [f1, f2] = FONDOS[fondo];
  const dibujo = prendas[prenda](c, interior);
  const idTela = `tela-${c.base.slice(1)}`;
  const grupo = detalle
    ? `<g transform="translate(-170 -150) scale(1.42)">${dibujo}</g>`
    : `<g transform="translate(400 430) scale(1.12) translate(-400 -430)">${conPercha.has(prenda) ? perchero() : ""}${dibujo}</g>`;
  const oscuro = fondo === "oscuro";
  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 800" role="img">
  <defs>
    <linearGradient id="fondo" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="${f1}"/><stop offset="1" stop-color="${f2}"/></linearGradient>
    <linearGradient id="${idTela}" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="${c.claro}"/><stop offset=".55" stop-color="${c.base}"/><stop offset="1" stop-color="${c.oscuro}"/></linearGradient>
    <linearGradient id="luz" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#fff" stop-opacity="${oscuro ? 0.12 : 0.55}"/><stop offset="1" stop-color="#fff" stop-opacity="0"/></linearGradient>
    <filter id="sombra" x="-20%" y="-20%" width="140%" height="150%"><feDropShadow dx="0" dy="18" stdDeviation="14" flood-color="#2b1a20" flood-opacity="${oscuro ? 0.55 : 0.28}"/></filter>
  </defs>
  <rect width="800" height="800" fill="url(#fondo)"/>
  <polygon points="470,0 700,0 330,800 100,800" fill="url(#luz)"/>
  <polygon points="650,0 760,0 540,800 430,800" fill="url(#luz)" opacity=".6"/>
  <g filter="url(#sombra)">${grupo}</g>
</svg>
`;
}

// ── Catálogo de imágenes ───────────────────────────────────
// [archivo, prenda, tela, fondo, detalle, interior]
const PRODUCTOS = {
  "blusa-romana": ["blusa", TELAS.blanco, "arena"],
  "blusa-satin": ["camisa", TELAS.rosaClaro, "crema"],
  "camisa-lino": ["camisa", TELAS.beige, "rosa"],
  "top-siena": ["top", TELAS.negro, "arena"],
  "top-basico": ["top", TELAS.blanco, "malva"],
  "top-halter": ["halter", TELAS.rosa, "crema"],
  "top-rib": ["top", TELAS.beige, "rosa"],
  "blazer-clasico": ["blazer", TELAS.beige, "arena"],
  "blazer-rosa": ["blazer", TELAS.rosaClaro, "crema"],
  "blazer-negro": ["blazer", TELAS.negro, "malva"],
  "pantalon-sastrero": ["pantalon", TELAS.beige, "rosa"],
  "pantalon-palazzo": ["pantalon", TELAS.rosa, "arena"],
  "pantalon-recto": ["pantalon", TELAS.negro, "crema"],
  "palazzo-blanco": ["pantalon", TELAS.blanco, "malva"],
  "jean-mom": ["jean", TELAS.celeste, "arena"],
  "vestido-aura": ["vestido", TELAS.rosa, "crema"],
  "vestido-elegance": ["vestido", TELAS.negro, "rosa"],
  "vestido-midi-lino": ["vestido", TELAS.beige, "malva"],
  "vestido-corto": ["vestidoCorto", TELAS.blanco, "rosa"],
  "vestido-seda": ["vestido", TELAS.borravino, "crema"],
  "cartera-mini": ["cartera", TELAS.negro, "arena"],
  "cinto-cuero": ["cinto", TELAS.marron, "crema"],
  "aros-perla": ["aros", TELAS.perla, "malva"],
  "collar-dorado": ["collar", TELAS.dorado, "oscuro"],
};

fs.mkdirSync(SALIDA_PRODUCTOS, { recursive: true });
fs.mkdirSync(SALIDA_INICIO, { recursive: true });

for (const [nombre, [prenda, tela, fondo]] of Object.entries(PRODUCTOS)) {
  fs.writeFileSync(path.join(SALIDA_PRODUCTOS, `${nombre}-1.svg`), escena({ prenda, tela, fondo }));
  const fondoDetalle = fondo === "oscuro" ? "rosa" : { arena: "rosa", rosa: "arena", crema: "malva", malva: "crema" }[fondo];
  fs.writeFileSync(path.join(SALIDA_PRODUCTOS, `${nombre}-2.svg`), escena({ prenda, tela, fondo: fondoDetalle, detalle: true }));
}

// ── Inicio: portada y colecciones ──────────────────────────
function portada() {
  const rosa = tonos(TELAS.rosaClaro);
  const beige = tonos(TELAS.beige);
  const blusa = tonos(TELAS.blanco);
  const tela = (c) => `<linearGradient id="tela-${c.base.slice(1)}" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="${c.claro}"/><stop offset=".55" stop-color="${c.base}"/><stop offset="1" stop-color="${c.oscuro}"/></linearGradient>`;
  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1600 560" role="img" preserveAspectRatio="xMaxYMid slice">
  <defs>
    <linearGradient id="fondo" x1="0" y1="0" x2="1" y2="0"><stop offset="0" stop-color="#f7e1e0"/><stop offset=".5" stop-color="#f0cfcd"/><stop offset="1" stop-color="#e3b5b3"/></linearGradient>
    <linearGradient id="luz" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#fff" stop-opacity=".6"/><stop offset="1" stop-color="#fff" stop-opacity="0"/></linearGradient>
    ${tela(rosa)}${tela(beige)}${tela(blusa)}
    <filter id="sombra" x="-20%" y="-20%" width="140%" height="150%"><feDropShadow dx="0" dy="14" stdDeviation="12" flood-color="#2b1a20" flood-opacity=".28"/></filter>
  </defs>
  <rect width="1600" height="560" fill="url(#fondo)"/>
  <polygon points="900,0 1140,0 960,560 720,560" fill="url(#luz)"/>
  <polygon points="1250,0 1380,0 1200,560 1070,560" fill="url(#luz)" opacity=".55"/>
  <path d="M600 34 H1600" stroke="#a98f86" stroke-width="6"/>
  <g filter="url(#sombra)">
    <g transform="translate(700 -34) scale(.66)">${perchero()}${prendas.blazer(rosa)}</g>
    <g transform="translate(1010 -28) scale(.64)">${perchero()}${prendas.pantalon(beige)}</g>
    <g transform="translate(1290 0) scale(.55)">${perchero()}${prendas.blusa(blusa)}</g>
  </g>
</svg>
`;
}

function tile(prenda, tela, fondo, interior) {
  const c = tonos(tela);
  const [f1, f2] = FONDOS[fondo];
  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 700" role="img" preserveAspectRatio="xMidYMid slice">
  <defs>
    <linearGradient id="fondo" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="${f1}"/><stop offset="1" stop-color="${f2}"/></linearGradient>
    <linearGradient id="tela-${c.base.slice(1)}" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="${c.claro}"/><stop offset=".55" stop-color="${c.base}"/><stop offset="1" stop-color="${c.oscuro}"/></linearGradient>
    <linearGradient id="luz" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#fff" stop-opacity=".5"/><stop offset="1" stop-color="#fff" stop-opacity="0"/></linearGradient>
    <filter id="sombra" x="-20%" y="-20%" width="140%" height="150%"><feDropShadow dx="0" dy="16" stdDeviation="12" flood-color="#2b1a20" flood-opacity=".28"/></filter>
  </defs>
  <rect width="800" height="700" fill="url(#fondo)"/>
  <polygon points="480,0 700,0 360,700 140,700" fill="url(#luz)"/>
  <g filter="url(#sombra)" transform="translate(0 -40)">${perchero()}${prendas[prenda](c, interior)}</g>
</svg>
`;
}

fs.writeFileSync(path.join(SALIDA_INICIO, "portada.svg"), portada());
fs.writeFileSync(path.join(SALIDA_INICIO, "coleccion-blusas.svg"), tile("blusa", TELAS.blanco, "arena"));
fs.writeFileSync(path.join(SALIDA_INICIO, "coleccion-pantalones.svg"), tile("pantalon", TELAS.rosa, "rosa"));
fs.writeFileSync(path.join(SALIDA_INICIO, "coleccion-vestidos.svg"), tile("vestido", TELAS.negro, "crema"));

console.log(`✔ ${Object.keys(PRODUCTOS).length * 2} imágenes de productos y 4 del inicio generadas.`);
