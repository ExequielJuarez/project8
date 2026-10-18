// Protecciones de seguridad de toda la app:
//   • cabeceras (CSP, anti-clickjacking, HSTS en producción…) con helmet
//   • verificación de origen en los pedidos que modifican datos (anti-CSRF)
//   • límites de intentos (fuerza bruta, spam de códigos y de formularios)
const helmet = require("helmet");
const { rateLimit, ipKeyGenerator } = require("express-rate-limit");

const produccion = process.env.NODE_ENV === "production";

// ── Cabeceras ───────────────────────────────────────────────
// Scripts solo del propio sitio (ningún script de afuera ni en línea).
// Los estilos en línea se permiten porque las vistas pintan colores con style="--muestra: …".
const cabeceras = helmet({
  contentSecurityPolicy: {
    useDefaults: false,
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'"],
      scriptSrcAttr: ["'none'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", "data:", "blob:"],
      fontSrc: ["'self'"],
      connectSrc: ["'self'"],
      frameSrc: ["'self'"], // la vista previa del inicio en el panel
      frameAncestors: ["'self'"],
      objectSrc: ["'none'"],
      baseUri: ["'self'"],
      // form-action se deja libre: el pago redirige a Mercado Pago después de un POST
    },
  },
  crossOriginEmbedderPolicy: false, // las fotos pueden venir de otros orígenes si el admin lo configura
  referrerPolicy: { policy: "strict-origin-when-cross-origin" },
  hsts: produccion ? { maxAge: 15552000, includeSubDomains: true } : false,
});

// ── Anti-CSRF: los pedidos que cambian datos tienen que venir de este mismo sitio ──
// Los navegadores mandan Origin (o Referer) en los POST/PUT/PATCH/DELETE; si no
// coincide con el host del sitio se rechaza. Se suma a la cookie SameSite=Lax.
const MUTA = new Set(["POST", "PUT", "PATCH", "DELETE"]);
const RUTAS_EXTERNAS = new Set(["/pagos/webhook"]); // Mercado Pago avisa desde afuera (se verifica por firma)

function mismoOrigen(req, res, next) {
  if (!MUTA.has(req.method) || RUTAS_EXTERNAS.has(req.path)) return next();
  const origen = req.get("origin") || req.get("referer");
  if (origen) {
    try {
      if (new URL(origen).host === req.get("host")) return next();
    } catch {
      /* origen inválido → se rechaza */
    }
  } else if (!produccion) {
    return next(); // herramientas de línea de comandos en desarrollo
  }
  if (req.accepts(["html", "json"]) === "json") {
    return res.status(403).json({ ok: false, mensaje: "Pedido rechazado por seguridad. Recargá la página y probá de nuevo." });
  }
  res.status(403).send("Pedido rechazado por seguridad. Volvé atrás, recargá la página y probá de nuevo.");
}

// ── Límites de intentos (por IP) ────────────────────────────
function limite({ ventanaMin, max, mensaje, clave }) {
  return rateLimit({
    windowMs: ventanaMin * 60 * 1000,
    limit: max,
    standardHeaders: true,
    legacyHeaders: false,
    keyGenerator: clave || ((req) => ipKeyGenerator(req.ip)),
    handler: (req, res) => {
      if (req.accepts(["html", "json"]) === "json") return res.status(429).json({ ok: false, mensaje });
      res.status(429).send(`<!doctype html><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Demasiados intentos</title><body style="font-family:system-ui,sans-serif;max-width:480px;margin:15vh auto;padding:0 20px;text-align:center"><h1>Demasiados intentos</h1><p>${mensaje}</p><p><a href="/">Volver al inicio</a></p></body>`);
    },
  });
}

const mensajeEspera = "Hiciste muchos intentos seguidos. Esperá unos minutos y probá de nuevo.";

// Todo el sitio: frena robots que piden páginas sin parar
const general = limite({ ventanaMin: 5, max: 600, mensaje: mensajeEspera });
// Login, registro, códigos por email: frena la fuerza bruta de contraseñas y códigos
const acceso = limite({ ventanaMin: 15, max: 20, mensaje: mensajeEspera });
// Intentos de contraseña contra una misma cuenta, desde cualquier IP del mismo atacante
const porCuenta = limite({
  ventanaMin: 15,
  max: 8,
  mensaje: mensajeEspera,
  clave: (req) => `${ipKeyGenerator(req.ip)}|${String(req.body?.email || "").trim().toLowerCase().slice(0, 120)}`,
});
// Formularios públicos que mandan emails o crean registros
const formularios = limite({ ventanaMin: 60, max: 8, mensaje: "Enviaste muchas solicitudes. Probá de nuevo en una hora." });
// Cupones: evita adivinar códigos
const cupones = limite({ ventanaMin: 15, max: 15, mensaje: mensajeEspera });

module.exports = { cabeceras, mismoOrigen, general, acceso, porCuenta, formularios, cupones };
