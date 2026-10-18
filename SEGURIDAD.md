# Seguridad

## Qué protege la tienda

| Riesgo | Cómo se evita |
|---|---|
| **Inyección SQL** | Todas las consultas pasan por Sequelize con parámetros. Los pocos `literal()`/`query()` que hay usan valores fijos o números ya convertidos. Los códigos de producto en la URL solo aceptan dígitos. |
| **Robo de contraseñas** | Se guardan con bcrypt (nunca en texto). El login compara siempre contra un hash, así no se puede averiguar qué emails existen. |
| **Fuerza bruta** | Límite por IP y por cuenta en login, registro y códigos por email (`src/middlewares/seguridad.js`), además del freno por sesión. Códigos de 6 dígitos con 5 intentos y vencimiento a los 10 minutos. |
| **CSRF** | Cookie `SameSite=Lax` + verificación de que los pedidos que modifican datos vienen de este mismo sitio. |
| **XSS** | Las vistas escapan todo (`<%= %>`). Política de seguridad (CSP) que solo permite scripts del propio sitio y bloquea los scripts en línea. |
| **Clickjacking / sniffing** | Cabeceras `X-Frame-Options`, `X-Content-Type-Options`, `Referrer-Policy`, y HSTS en producción. |
| **Archivos subidos** | Solo JPG/PNG/WEBP de hasta 2–3 MB, con nombre aleatorio, y se comprueba el contenido real del archivo (no solo la extensión). |
| **Acceso al panel** | Todo `/admin` exige rol admin; el editor del inicio exige superadmin. Los pedidos solo los ve su dueño, quien los hizo en esa sesión o un admin. |
| **Sesiones** | Cookie `httpOnly`, `secure` bajo https, sesión nueva al iniciar sesión (anti fijación). En producción el servidor **no arranca** sin `SESSION_SECRET` de 32+ caracteres. |
| **Pagos** | El precio y el stock salen siempre de la base, nunca del navegador. El estado del pago se consulta a Mercado Pago, no se confía en la URL ni en el aviso. |

## Antes de publicar (importante)

1. `NODE_ENV=production` y una `SESSION_SECRET` larga y aleatoria (`node -e "console.log(require('crypto').randomBytes(48).toString('hex'))"`).
2. **Cambiá las contraseñas de los usuarios de prueba** o borralos (ver `DONWEB.md`): `admin@tienda.com`, `super@tienda.com`, `demo@tienda.com`.
3. **La base de datos no debe estar abierta a internet.** Dejá que solo la app se conecte (red privada o lista de IPs permitidas en el hosting) y usá un usuario con permisos solo sobre esta base, con una clave larga.
4. **Nunca subas el `.env` ni credenciales a GitHub.** Si alguna vez se subieron, hay que cambiarlas: borrarlas del repo no alcanza, quedan en el historial.
5. Configurá `MP_WEBHOOK_SECRET` si cobrás con Mercado Pago, y `SMTP_*` para los emails.
6. Mantené las dependencias al día: `npm audit` y `npm update` de vez en cuando.
7. Hacé copias de seguridad de la base.
