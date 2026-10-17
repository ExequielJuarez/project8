// Categorías (las pestañas del menú) y sus subcategorías (los filtros de cada
// sección). Las usa la tienda (menú, páginas de categoría) y el panel admin.
//
// Las funciones que modifican devuelven { ok: true, ... } o { ok: false, mensaje }
// para que el panel muestre el motivo sin romperse.

const { Op } = require("sequelize");
const db = require("../model/database/models");
const slug = require("../helpers/slug");
const { GRUPOS, OCASIONES, TEMPORADAS, FITS } = require("../data/clasificacion");

const LARGO = { categoria: 60, subcategoria: 40 };

// ── Menú (se pide en cada página: se guarda en memoria hasta que cambie) ──
let menuCache = null;

async function menu() {
  if (!menuCache) {
    const filas = await db.Categoria.findAll({
      include: [{ association: "subcategorias", attributes: ["nombre", "slug", "orden", "id"] }],
      order: [["orden", "ASC"], ["id", "ASC"], ["subcategorias", "orden", "ASC"], ["subcategorias", "id", "ASC"]],
    });
    menuCache = filas.map((c) => ({
      id: c.id,
      nombre: c.nombre,
      slug: c.slug,
      url: `/categoria/${c.slug}`,
      subcategorias: c.subcategorias.map((s) => ({ nombre: s.nombre, slug: s.slug, url: `/categoria/${c.slug}?sub=${s.slug}` })),
    }));
  }
  return menuCache;
}

const limpiarMenu = () => (menuCache = null);

// Pestañas del menú, según la estructura de src/data/clasificacion.js:
// Novedades · Prendas Superiores ▾ · Prendas Inferiores ▾ · Vestidos y Monos ▾ ·
// Ropa Interior y de Dormir ▾ · Ocasión ▾ · Temporada ▾ · Talles y fit ▾ · Sale
async function navegacion() {
  const categorias = await menu();
  const usadas = new Set();
  const grupos = GRUPOS.map((g) => {
    const cats = g.slugs.map((s) => categorias.find((c) => c.slug === s)).filter(Boolean);
    cats.forEach((c) => usadas.add(c.slug));
    return {
      clave: g.clave,
      nombre: g.nombre,
      url: cats[0]?.url || "/tienda",
      claves: cats.map((c) => c.slug),
      hijos: [{ nombre: `Todo en ${g.nombre}`, url: `/prendas/${g.clave}` }, ...cats.map((c) => ({ nombre: c.nombre, url: c.url }))],
    };
  }).filter((g) => g.claves.length);
  // Categorías nuevas que no están en ningún grupo: pestañas sueltas
  const sueltas = categorias
    .filter((c) => !usadas.has(c.slug))
    .map((c) => ({
      clave: c.slug,
      nombre: c.nombre,
      url: c.url,
      hijos: c.subcategorias.length ? [{ nombre: `Todo en ${c.nombre}`, url: c.url }, ...c.subcategorias.map((s) => ({ nombre: s.nombre, url: s.url }))] : [],
    }));

  return [
    { clave: "inicio", nombre: "Inicio", url: "/", hijos: [], soloMovil: true },
    { clave: "novedades", nombre: "Novedades", url: "/novedades", hijos: [] },
    ...grupos,
    ...sueltas,
    { clave: "ocasion", nombre: "Ocasión", url: "/ocasion/casual", hijos: OCASIONES.map((o) => ({ nombre: o.nombre, url: `/ocasion/${o.valor}` })) },
    { clave: "temporada", nombre: "Temporada", url: "/temporada/primavera-verano", hijos: TEMPORADAS.map((t) => ({ nombre: t.nombre, url: `/temporada/${t.valor}` })) },
    {
      clave: "fit",
      nombre: "Talles y fit",
      url: "/guia-de-talles",
      hijos: [{ nombre: "Guía de talles", url: "/guia-de-talles" }, ...FITS.map((f) => ({ nombre: f.nombre, url: `/fit/${f.valor}` }))],
    },
    { clave: "ofertas", nombre: "Sale", url: "/ofertas", hijos: [] },
  ];
}

// ── Consultas ───────────────────────────────────────────────
// Todas las categorías con sus subcategorías y cuántos productos tiene cada una
async function listarCompletas() {
  const [categorias, conteoCat, conteoSub] = await Promise.all([
    db.Categoria.findAll({
      include: [{ association: "subcategorias" }],
      order: [["orden", "ASC"], ["id", "ASC"], ["subcategorias", "orden", "ASC"], ["subcategorias", "id", "ASC"]],
    }),
    db.Producto.findAll({ attributes: ["categoriaId", [db.sequelize.fn("COUNT", "*"), "n"]], group: ["categoriaId"], raw: true }),
    db.Producto.findAll({
      attributes: ["subcategoriaId", [db.sequelize.fn("COUNT", "*"), "n"]],
      where: { subcategoriaId: { [Op.ne]: null } },
      group: ["subcategoriaId"],
      raw: true,
    }),
  ]);
  const nCat = new Map(conteoCat.map((f) => [f.categoriaId, Number(f.n)]));
  const nSub = new Map(conteoSub.map((f) => [f.subcategoriaId, Number(f.n)]));
  return categorias.map((c) => ({
    id: c.id,
    nombre: c.nombre,
    slug: c.slug,
    orden: c.orden,
    productos: nCat.get(c.id) || 0,
    subcategorias: c.subcategorias.map((s) => ({ id: s.id, nombre: s.nombre, slug: s.slug, productos: nSub.get(s.id) || 0 })),
  }));
}

async function porSlug(valor) {
  const c = await db.Categoria.findOne({
    where: { slug: String(valor || "") },
    include: [{ association: "subcategorias" }],
    order: [["subcategorias", "orden", "ASC"], ["subcategorias", "id", "ASC"]],
  });
  if (!c) return null;
  return {
    id: c.id,
    nombre: c.nombre,
    slug: c.slug,
    subcategorias: c.subcategorias.map((s) => ({ id: s.id, nombre: s.nombre, slug: s.slug })),
  };
}

async function porNombre(nombre) {
  const c = await db.Categoria.findOne({ where: { nombre: String(nombre || "") }, raw: true });
  return c ? { id: c.id, nombre: c.nombre, slug: c.slug } : null;
}

// ── Validación de nombres ───────────────────────────────────
function nombreValido(texto, tipo) {
  const nombre = String(texto || "").trim().replace(/\s+/g, " ");
  const max = LARGO[tipo];
  if (nombre.length < 2 || nombre.length > max) {
    return { mensaje: `El nombre tiene que tener entre 2 y ${max} letras` };
  }
  const s = slug(nombre, max);
  if (!s) return { mensaje: "Usá letras o números en el nombre" };
  // Primera letra en mayúscula, el resto como lo escribió
  return { nombre: nombre.charAt(0).toUpperCase() + nombre.slice(1), slug: s };
}

// ── Categorías ──────────────────────────────────────────────
async function crearCategoria(texto) {
  const v = nombreValido(texto, "categoria");
  if (v.mensaje) return { ok: false, mensaje: v.mensaje };
  if (await db.Categoria.findOne({ where: { [Op.or]: [{ slug: v.slug }, { nombre: v.nombre }] } })) {
    return { ok: false, mensaje: `Ya existe una categoría llamada "${v.nombre}"` };
  }
  const ultimo = (await db.Categoria.max("orden")) || 0;
  const c = await db.Categoria.create({ nombre: v.nombre, slug: v.slug, orden: ultimo + 1 });
  limpiarMenu();
  return { ok: true, categoria: c.get({ plain: true }) };
}

async function renombrarCategoria(id, texto) {
  const c = await db.Categoria.findByPk(id);
  if (!c) return { ok: false, mensaje: "No encontramos esa categoría" };
  const v = nombreValido(texto, "categoria");
  if (v.mensaje) return { ok: false, mensaje: v.mensaje };
  const repetida = await db.Categoria.findOne({
    where: { id: { [Op.ne]: c.id }, [Op.or]: [{ slug: v.slug }, { nombre: v.nombre }] },
  });
  if (repetida) return { ok: false, mensaje: `Ya existe una categoría llamada "${v.nombre}"` };
  await c.update({ nombre: v.nombre, slug: v.slug });
  limpiarMenu();
  return { ok: true, categoria: c.get({ plain: true }) };
}

// Solo se puede borrar si no tiene productos (para no dejar productos sin categoría)
async function borrarCategoria(id) {
  const c = await db.Categoria.findByPk(id);
  if (!c) return { ok: false, mensaje: "No encontramos esa categoría" };
  const productos = await db.Producto.count({ where: { categoriaId: c.id } });
  if (productos) {
    return {
      ok: false,
      mensaje: `"${c.nombre}" tiene ${productos} ${productos === 1 ? "producto" : "productos"}. Pasalos a otra categoría antes de borrarla.`,
    };
  }
  if ((await db.Categoria.count()) <= 1) return { ok: false, mensaje: "La tienda necesita al menos una categoría" };
  await c.destroy(); // sus subcategorías se borran solas (ON DELETE CASCADE)
  limpiarMenu();
  return { ok: true, categoria: { nombre: c.nombre } };
}

// Sube o baja una categoría en el menú (direccion: -1 o 1)
async function moverCategoria(id, direccion) {
  const todas = await db.Categoria.findAll({ order: [["orden", "ASC"], ["id", "ASC"]] });
  const i = todas.findIndex((c) => c.id === Number(id));
  const j = i + (Number(direccion) < 0 ? -1 : 1);
  if (i < 0 || j < 0 || j >= todas.length) return { ok: false, mensaje: "No se puede mover más" };
  [todas[i], todas[j]] = [todas[j], todas[i]];
  await db.sequelize.transaction(async (t) => {
    for (const [orden, c] of todas.entries()) {
      if (c.orden !== orden + 1) await c.update({ orden: orden + 1 }, { transaction: t });
    }
  });
  limpiarMenu();
  return { ok: true };
}

// ── Subcategorías ───────────────────────────────────────────
async function crearSubcategoria(categoriaId, texto) {
  const c = await db.Categoria.findByPk(categoriaId);
  if (!c) return { ok: false, mensaje: "No encontramos esa categoría" };
  const v = nombreValido(texto, "subcategoria");
  if (v.mensaje) return { ok: false, mensaje: v.mensaje };
  const existente = await db.Subcategoria.findOne({ where: { categoriaId: c.id, slug: v.slug } });
  if (existente) {
    return { ok: false, mensaje: `"${c.nombre}" ya tiene una subcategoría "${existente.nombre}"`, subcategoria: existente.get({ plain: true }) };
  }
  const ultimo = (await db.Subcategoria.max("orden", { where: { categoriaId: c.id } })) || 0;
  const s = await db.Subcategoria.create({ categoriaId: c.id, nombre: v.nombre, slug: v.slug, orden: ultimo + 1 });
  limpiarMenu();
  return { ok: true, subcategoria: s.get({ plain: true }), categoria: c.nombre };
}

async function renombrarSubcategoria(id, texto) {
  const s = await db.Subcategoria.findByPk(id);
  if (!s) return { ok: false, mensaje: "No encontramos esa subcategoría" };
  const v = nombreValido(texto, "subcategoria");
  if (v.mensaje) return { ok: false, mensaje: v.mensaje };
  const repetida = await db.Subcategoria.findOne({ where: { categoriaId: s.categoriaId, slug: v.slug, id: { [Op.ne]: s.id } } });
  if (repetida) return { ok: false, mensaje: `Ya existe "${repetida.nombre}" en esta categoría` };
  await s.update({ nombre: v.nombre, slug: v.slug });
  limpiarMenu();
  return { ok: true, subcategoria: s.get({ plain: true }) };
}

// Los productos que la tenían quedan sin subcategoría (siguen en su categoría)
async function borrarSubcategoria(id) {
  const s = await db.Subcategoria.findByPk(id);
  if (!s) return { ok: false, mensaje: "No encontramos esa subcategoría" };
  const productos = await db.Producto.count({ where: { subcategoriaId: s.id } });
  await db.sequelize.transaction(async (t) => {
    await db.Producto.update({ subcategoriaId: null }, { where: { subcategoriaId: s.id }, transaction: t });
    await s.destroy({ transaction: t });
  });
  limpiarMenu();
  return { ok: true, subcategoria: { nombre: s.nombre }, productos };
}

module.exports = {
  menu,
  navegacion,
  limpiarMenu,
  listarCompletas,
  porSlug,
  porNombre,
  crearCategoria,
  renombrarCategoria,
  borrarCategoria,
  moverCategoria,
  crearSubcategoria,
  renombrarSubcategoria,
  borrarSubcategoria,
};
