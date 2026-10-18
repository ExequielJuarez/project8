# Akualoe Chic — tienda online de ropa

Ecommerce hecho con Node.js, Express, EJS y MySQL (Sequelize). Incluye catálogo con
filtros (categoría, talle, color y precio), ficha de producto con talles, carrito,
cupones, checkout, pagos (Mercado Pago o transferencia), cuenta del cliente, favoritos,
botón de arrepentimiento y panel de administración (productos, pedidos, categorías,
página de inicio y métricas).

## Puesta en marcha

```bash
npm install
cp .env.example .env        # completá DB_USER, DB_PASSWORD y DB_NAME
npm run db:instalar         # crea las tablas y carga los datos de prueba
npm run dev                 # http://localhost:3000
```

Usuarios de prueba: `demo@tienda.com / Demo1234` (cliente), `admin@tienda.com / Admin1234`
(admin) y `super@tienda.com / Super1234` (superadmin, edita el inicio).

Más detalles: [SEGURIDAD.md](SEGURIDAD.md), [database/README.md](database/README.md), [PAGOS.md](PAGOS.md),
[ACCESO.md](ACCESO.md), [LEGALES.md](LEGALES.md), [DEPLOY.md](DEPLOY.md) y [DONWEB.md](DONWEB.md).

## Fotos

Las fotos del catálogo están en `public/img/productos` y las del inicio en `public/img/inicio`. Se cambian desde
Admin → Productos → Editar → Imágenes y Admin → Inicio.

## Talles

Cada prenda tiene sus talles (XS, S, M, L, XL, XXL, Único), que se marcan al crear o editar el
producto. Los accesorios pueden quedar sin talle. El cliente elige el talle en la ficha y queda
guardado en el carrito y en el pedido.
