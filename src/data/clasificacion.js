// Estructura del menú y clasificaciones transversales de la tienda.
//
// GRUPOS: cómo se agrupan las categorías en el menú (por slug). Las categorías
// que no estén acá (por ejemplo, una nueva creada desde el panel) aparecen
// sueltas en el menú.
// OCASIONES / TEMPORADAS / FITS: filtros rápidos que se marcan en cada producto.

const GRUPOS = [
  {
    clave: "superiores",
    nombre: "Prendas Superiores",
    slugs: ["remeras-y-camisetas", "blusas-y-camisas", "tops-y-musculosas", "buzos-sweaters-y-cardigans", "camperas-blazers-y-abrigos"],
  },
  {
    clave: "inferiores",
    nombre: "Prendas Inferiores",
    slugs: ["pantalones", "jeans-y-denim", "faldas-y-minis", "shorts-y-bermudas", "leggings-y-calzas"],
  },
  { clave: "vestidos", nombre: "Vestidos y Monos", slugs: ["vestidos-de-dia", "vestidos-de-noche", "monos-y-jumpsuits"] },
  { clave: "interior", nombre: "Ropa Interior y de Dormir", slugs: ["conjuntos-y-corpinos", "pijamas-y-camisones", "ropa-termica"] },
];

const OCASIONES = [
  { valor: "casual", nombre: "Casual" },
  { valor: "oficina", nombre: "Oficina / Workwear" },
  { valor: "fiesta-noche", nombre: "Fiesta y Noche" },
  { valor: "playero", nombre: "Playero" },
];

const TEMPORADAS = [
  { valor: "primavera-verano", nombre: "Primavera / Verano" },
  { valor: "otono-invierno", nombre: "Otoño / Invierno" },
];

const FITS = [
  { valor: "oversize", nombre: "Oversize" },
  { valor: "slim", nombre: "Slim" },
  { valor: "recto", nombre: "Recto" },
  { valor: "wide", nombre: "Wide leg" },
];

const nombreDe = (lista, valor) => lista.find((x) => x.valor === valor)?.nombre || "";
const validos = (lista, valores) => lista.map((x) => x.valor).filter((v) => [].concat(valores || []).join(",").split(",").map((s) => s.trim()).includes(v));

module.exports = { GRUPOS, OCASIONES, TEMPORADAS, FITS, nombreDe, validos };
