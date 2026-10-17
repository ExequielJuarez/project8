// ==========================================================
// Qué se puede editar del inicio desde el panel (Admin → Inicio)
// y el valor original de cada cosa.
//
// Este esquema arma solo el formulario del panel, limpia lo que
// se guarda y completa lo que falta. Para sumar un campo nuevo
// alcanza con agregarlo acá y usarlo en views/inicio.ejs.
//
// Tipos: texto (una línea) · lineas (varios renglones) · parrafo
//        numero · link · imagen · opciones · lista (fija o variable)
// En los textos, *palabra* se muestra en cursiva.
// ==========================================================

const IMG = (nombre) => `/img/inicio/${nombre}`;

const FONDOS = { claro: "Claro", medio: "Gris", oscuro: "Oscuro" };

const texto = (etiqueta, defecto, max = 80, extra = {}) => ({ tipo: "texto", etiqueta, defecto, max, ...extra });
const parrafo = (etiqueta, defecto, max = 300, extra = {}) => ({ tipo: "parrafo", etiqueta, defecto, max, ...extra });
const link = (etiqueta, defecto, extra = {}) => ({ tipo: "link", etiqueta, defecto, max: 255, ancho: "medio", ...extra });
const imagen = (etiqueta, defecto, extra = {}) => ({ tipo: "imagen", etiqueta, defecto, ...extra });
const etiquetaSeccion = (defecto) => texto("Texto chico de arriba", defecto, 40);

const SECCIONES = {
  portada: {
    titulo: "Portada",
    descripcion: "Lo primero que se ve al entrar: título, botón y la foto grande.",
    siempreVisible: true,
    campos: {
      etiqueta: texto("Texto chico de arriba", "Nueva temporada", 40),
      titulo: {
        tipo: "lineas",
        etiqueta: "Título grande",
        defecto: "Tu estilo,\nTu esencia",
        max: 60,
        maxLineas: 3,
        ayuda: "Un renglón por línea. Se muestra en mayúsculas.",
      },
      bajada: parrafo("Texto debajo del título", "Prendas para acompañarte todos los días.", 120),
      botonTexto: texto("Botón", "Ver colección", 30, { ancho: "medio" }),
      botonLink: link("Link del botón", "/tienda"),
      imagen: imagen("Foto principal", IMG("portada.jpg"), {
        ayuda: "Queda mejor una foto horizontal, con la modelo del lado derecho.",
        fondo: "claro",
      }),
    },
  },

  colecciones: {
    titulo: "Colecciones",
    descripcion: "Las tres tarjetas grandes que llevan a cada categoría.",
    campos: {
      items: {
        tipo: "lista",
        etiqueta: "Tarjetas",
        item: "Colección",
        cantidad: 3,
        campos: {
          nombre: texto("Nombre", "", 30, { ancho: "medio" }),
          link: link("Link", "", { ayuda: "Ej: /categoria/blusas abre esa sección; /categoria/pantalones?sub=palazzo, ya filtrada; /ofertas, las ofertas." }),
          imagen: imagen("Foto", ""),
        },
        defecto: [
          { nombre: "Blusas", link: "/categoria/blusas", imagen: IMG("coleccion-blusas.jpg") },
          { nombre: "Pantalones", link: "/categoria/pantalones", imagen: IMG("coleccion-pantalones.jpg") },
          { nombre: "Vestidos", link: "/categoria/vestidos", imagen: IMG("coleccion-vestidos.jpg") },
        ],
      },
    },
  },

  masElegidos: {
    titulo: "Más elegidos",
    descripcion: "La fila de productos. Salen los que tienen la etiqueta “Más elegido” (se pone al editar cada producto).",
    campos: {
      etiqueta: etiquetaSeccion("Lo más buscado"),
      titulo: texto("Título", "Más elegidos", 40),
      linkTexto: texto("Texto del link", "Ver todos", 24, { ancho: "medio" }),
      link: link("A dónde lleva", "/tienda"),
    },
  },
};

module.exports = { SECCIONES, FONDOS };
