-- ==========================================================
-- AKUALOE CHIC — Datos de prueba
--
-- Cargar DESPUÉS de schema.sql (borra y vuelve a cargar todo).
-- Las fechas de los pedidos son relativas al momento de la carga
-- (CURDATE() - INTERVAL n DAY / NOW() - INTERVAL n MINUTE), así el
-- panel siempre muestra ventas recientes sin importar cuándo se cargue.
--
-- Usuarios de prueba:
--   Cliente  demo@tienda.com   /  Demo1234
--   Admin    admin@tienda.com  /  Admin1234
--   Super    super@tienda.com  /  (la del seed original)
--
-- Las fotos de los productos están en public/img/productos y se cambian
-- desde Admin → Productos → Editar → Imágenes.
--
-- Uso:  npm run db:instalar   (carga schema.sql + este archivo)
--   o:  mysql -u root -p akualoe_chic < database/datos-prueba.sql
-- ==========================================================

USE akualoe_chic;

-- Acentos bien guardados aunque el cliente de MySQL no esté en UTF-8
SET NAMES utf8mb4;
-- Misma zona horaria que usa la app (DB_TIMEZONE en el .env), para que
-- CURDATE() y las fechas de los pedidos coincidan con el panel
SET time_zone = '-03:00';

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE notificaciones;
TRUNCATE TABLE arrepentimientos;
TRUNCATE TABLE pedido_items;
TRUNCATE TABLE pedidos;
TRUNCATE TABLE favoritos;
TRUNCATE TABLE especificaciones;
TRUNCATE TABLE producto_imagenes;
TRUNCATE TABLE producto_colores;
TRUNCATE TABLE productos;
TRUNCATE TABLE colores;
TRUNCATE TABLE subcategorias;
TRUNCATE TABLE categorias;
TRUNCATE TABLE cupones;
TRUNCATE TABLE usuarios;
SET FOREIGN_KEY_CHECKS = 1;
ALTER TABLE pedidos AUTO_INCREMENT = 1001;

-- ── Usuarios ─────────────────────────────────────────────
INSERT INTO usuarios (id, nombre, apellido, email, telefono, password, google_id, rol, newsletter) VALUES
  (1, 'Cliente', 'Demo', 'demo@tienda.com', '11 5555 4444', '$2b$10$jX3V6AhKp.Par41X/kOWfelfguSzaU4z/IZkvYOv0UHGBQ/6Rl2Oy', NULL, 'cliente', 1),
  (2, 'Admin', 'Tienda', 'admin@tienda.com', NULL, '$2b$10$OUwf1N16MEgHBa5jhFt6K.cGjo4yUyiF/cOwUOBsyttSBQqgwMRYq', NULL, 'admin', 0),
  (3, 'Ana', 'Pérez', 'ana.perez@gmail.com', NULL, NULL, 'demo-ana.perez@gmail.com', 'cliente', 0),
  (4, 'Super', 'Admin', 'super@tienda.com', NULL, '$2b$10$AhElj/1kwG2mSrQCEpRKI.eaaUIicEpYgvqxK2sckmrfVXodWJpke', NULL, 'superadmin', 0);

-- ── Categorías y colores ────────────────────────────────
INSERT INTO categorias (id, nombre, slug, orden) VALUES
  (1, 'Remeras y camisetas', 'remeras-y-camisetas', 1),
  (2, 'Blusas y camisas', 'blusas-y-camisas', 2),
  (3, 'Tops y musculosas', 'tops-y-musculosas', 3),
  (4, 'Buzos, sweaters y cárdigans', 'buzos-sweaters-y-cardigans', 4),
  (5, 'Camperas, blazers y abrigos', 'camperas-blazers-y-abrigos', 5),
  (6, 'Pantalones', 'pantalones', 6),
  (7, 'Jeans / Denim', 'jeans-y-denim', 7),
  (8, 'Faldas y minis', 'faldas-y-minis', 8),
  (9, 'Shorts y bermudas', 'shorts-y-bermudas', 9),
  (10, 'Leggings / Calzas', 'leggings-y-calzas', 10),
  (11, 'Vestidos de día / Casuales', 'vestidos-de-dia', 11),
  (12, 'Vestidos de noche / Fiesta', 'vestidos-de-noche', 12),
  (13, 'Monos / Jumpsuits', 'monos-y-jumpsuits', 13),
  (14, 'Conjuntos y corpiños', 'conjuntos-y-corpinos', 14),
  (15, 'Pijamas y camisones', 'pijamas-y-camisones', 15),
  (16, 'Ropa térmica', 'ropa-termica', 16);

-- Subcategorías: los filtros propios de cada sección
INSERT INTO colores (id, valor, nombre, hex, orden) VALUES
  (1, 'negro', 'Negro', '#1f1a1c', 1),
  (2, 'chocolate', 'Chocolate', '#4a2f27', 2),
  (3, 'bordo', 'Bordó', '#6b1f2f', 3),
  (4, 'crema', 'Crema', '#efe6d6', 4),
  (5, 'beige', 'Beige', '#cdb9a0', 5),
  (6, 'azul-jean', 'Azul jean', '#5b7a99', 6),
  (7, 'gris', 'Gris', '#8b8d90', 7),
  (8, 'verde', 'Verde', '#3f6258', 8),
  (9, 'blanco', 'Blanco', '#fbf8f4', 9);

-- ── Productos (imágenes en public/img/productos) ────────
INSERT INTO productos (id, nombre, categoria_id, subcategoria_id, color_id, precio, costo, stock, talles, ocasiones, temporada, fit, etiqueta, resumen, descripcion, destacados) VALUES
  (1, 'Campera de Cuero', 5, NULL, 1, 89900, 45000, 8, 'XS,S,M,L,XL', 'casual,fiesta-noche', 'otono-invierno', 'recto', 'Más elegido', 'Campera de cuero ecológico estilo motociclista, con cierre cruzado y bolsillos. Una pieza que sube cualquier outfit.', 'La campera perfecta para el entretiempo: corte biker, cierres metálicos y un calce que estiliza.

Combina con jeans, vestidos y faldas. Disponible en negro, chocolate y bordó.', 'Cierre cruzado metálico
Forro interior suave
Bolsillos con cierre'),
  (2, 'Jean Wide Leg', 7, NULL, 6, 52900, 26000, 14, 'XS,S,M,L,XL', 'casual', NULL, 'wide', 'Nuevo', 'Jean de pierna ancha con lavado azul intenso. Tiro alto y caída larga.', 'Un jean wide leg con mucho movimiento: tiro alto, cintura marcada y pierna que cae derecha.

Se luce con zapatillas, botas o plataformas.', 'Tiro alto
Pierna ancha con caída larga
Lavado azul intenso'),
  (3, 'Jean Franja Gris', 7, NULL, 7, 49900, 24500, 12, 'XS,S,M,L,XL', 'casual', NULL, 'wide', 'Más elegido', 'Jean gris de pierna recta con franjas laterales. Estilo deportivo y urbano.', 'Un jean con carácter: lavado gris, pierna ancha y franjas laterales que le dan un toque sporty.

Ideal con remeras cortas y zapatillas.', 'Franjas laterales
Pierna recta amplia
Lavado gris'),
  (4, 'Pantalón Palazzo Sastrero', 6, NULL, 4, 46900, 23200, 18, 'XS,S,M,L,XL', 'oficina,casual', NULL, 'wide', 'Más elegido', 'Palazzo de tela fluida con pinzas, tiro alto y pierna bien ancha. Elegante y cómodo.', 'El pantalón que resuelve la oficina y la salida: caída fluida, pinzas delanteras y tiro alto.

Disponible en varios colores neutros para combinar con todo.', 'Tela fluida con caída
Pinzas delanteras
Tiro alto'),
  (5, 'Pollera Mini Cuero', 8, NULL, 1, 34900, 17000, 10, 'XS,S,M,L,XL', 'fiesta-noche,casual', 'otono-invierno', 'slim', NULL, 'Minipollera de cuero ecológico con cierre trasero. Para animarse.', 'Una mini de línea recta y tiro alto, con tela símil cuero de buen cuerpo.

Con botas o zapatillas, y una remera básica.', 'Línea recta
Cierre trasero
Símil cuero'),
  (6, 'Pollera Short Crema', 8, NULL, 4, 29900, 14500, 15, 'XS,S,M,L,XL', 'casual,playero', 'primavera-verano', 'recto', 'Oferta', 'Pollera short plisada con cinto, en tonos tierra. Fresca y cómoda.', 'Una pollera con short por dentro, plisada y con cinturón. Ideal para días de calor.

Disponible en crema, beige y chocolate.', 'Short interior
Plisada con cinturón
Tela liviana'),
  (7, 'Remera Rib con Vivos', 1, NULL, 4, 21900, 10500, 25, 'XS,S,M,L,XL', 'casual', 'primavera-verano', 'slim', 'Nuevo', 'Remera de morley rib con cuello y puños contrastantes. Un básico con detalle.', 'Remera corta de tejido canalé suave, con vivos que resaltan el cuello y las mangas.

Disponible en varios colores.', 'Morley rib elástico
Vivos contrastantes
Calce ajustado'),
  (8, 'Remera Tejida Crema', 1, NULL, 4, 24900, 12000, 16, 'XS,S,M,L,XL', 'casual', 'primavera-verano', 'recto', NULL, 'Remera corta de punto tejido texturado, sin mangas anchas. Liviana y fresca.', 'Un tejido calado y texturado que la vuelve especial. Se usa sola o sobre una camisa.

Combina con jeans y polleras.', 'Punto texturado
Liviana
Largo corto'),
  (9, 'Remera Lavada Gris', 1, NULL, 7, 23900, 11500, 18, 'S,M,L,XL', 'casual', NULL, 'oversize', NULL, 'Remera oversize de algodón con lavado desgastado y bolsillo. Estilo vintage.', 'Una remera de calce amplio y lavado stone, con un bolsillo frontal. Cómoda y con onda.

Con jeans o con shorts, siempre suma.', 'Lavado desgastado
Calce oversize
Bolsillo frontal'),
  (10, 'Musculosa con Tachas', 3, NULL, 3, 26900, 13000, 12, 'XS,S,M,L,XL', 'casual,fiesta-noche', 'primavera-verano', 'slim', 'Nuevo', 'Musculosa de escote cuadrado con tachas en los breteles. Para destacar.', 'Una musculosa ajustada, con escote cuadrado y detalle de tachas que le da un aire rockero.

Disponible en bordó, verde y beige.', 'Tachas en los breteles
Escote cuadrado
Tela elástica'),
  (11, 'Top Halter con Broche', 3, NULL, 1, 27900, 13500, 10, 'XS,S,M,L,XL', 'fiesta-noche', 'primavera-verano', 'recto', NULL, 'Top halter de espalda descubierta con broche dorado. Para noches especiales.', 'Un top con cuello halter y escote profundo, cerrado con un broche dorado.

Se luce con pantalón de vestir o pollera.', 'Cuello halter
Broche dorado
Espalda descubierta'),
  (12, 'Top Halter Chocolate', 3, NULL, 2, 28900, 14000, 9, 'XS,S,M,L,XL', 'fiesta-noche', 'primavera-verano', 'slim', 'Más elegido', 'Top halter de raso color chocolate con escote cruzado. Elegante y sensual.', 'Un halter de caída fluida que se ata en la nuca, con detalle cruzado en el frente.

Queda perfecto con una pollera plisada o con jeans.', 'Escote cruzado
Se ata en la nuca
Raso suave'),
  (13, 'Short Chocolate', 9, NULL, 2, 27900, 13400, 14, 'XS,S,M,L,XL', 'casual,playero', 'primavera-verano', 'recto', NULL, 'Short de gabardina con tiro alto y botón. Cómodo y combinable.', 'Un short clásico de tiro alto, ideal para las tardes de calor.

Con botón y cierre, y bolsillos laterales.', 'Tiro alto
Gabardina suave
Bolsillos laterales'),
  (14, 'Short Crema', 9, NULL, 4, 27900, 13400, 13, 'XS,S,M,L,XL', 'casual,playero', 'primavera-verano', 'recto', 'Oferta', 'Short de gabardina en tonos claros, tiro alto, para un look fresco.', 'Un short liviano en color crema que combina con todo.

Perfecto para el verano.', 'Tiro alto
Tela liviana
Colores claros'),
  (15, 'Short Jean Desflecado', 9, NULL, 6, 29900, 14500, 20, 'XS,S,M,L,XL', 'casual,playero', 'primavera-verano', 'recto', 'Más elegido', 'Short de jean con lavado desgastado y bordes desflecados. Un clásico del verano.', 'El short de jean de siempre, con bastas desflecadas y lavado vintage.

Se combina con remeras, tops y camisas.', 'Bastas desflecadas
Lavado desgastado
Tiro alto'),
  (16, 'Vestido Halter Metalizado', 12, NULL, 2, 64900, 32000, 6, 'XS,S,M,L,XL', 'fiesta-noche', NULL, 'slim', 'Nuevo', 'Vestido largo halter con brillo metalizado y escote cruzado. Para eventos y noches especiales.', 'Un vestido largo con tela de brillo suave y escote cruzado. Se ajusta al cuerpo y cae recto.

El detalle del escote lo hace inolvidable.', 'Tela con brillo metalizado
Escote cruzado
Largo maxi'),
  (17, 'Vestido Largo Estampado', 11, NULL, 1, 58900, 29000, 9, 'XS,S,M,L,XL', 'casual,playero', 'primavera-verano', 'recto', 'Más elegido', 'Vestido largo con escote en V profundo y espalda abierta, estampado boho.', 'Un vestido fluido con estampa étnica, escote en V y espalda descubierta. Ideal para el verano y las fiestas.

Con botas o sandalias.', 'Estampado boho
Escote en V y espalda abierta
Tela fluida'),
  (18, 'Vestido Tul Estampado', 12, NULL, 2, 61900, 30500, 7, 'XS,S,M,L,XL', 'fiesta-noche', 'otono-invierno', 'recto', NULL, 'Vestido largo de tul con estampa degradé y mangas largas. Delicado y moderno.', 'Un vestido de tul con estampa en tonos tierra, mangas largas y largo hasta el tobillo.

Se usa con cinturón para marcar la cintura.', 'Tul con estampa degradé
Mangas largas
Largo maxi');

-- Colores en que se vende cada producto (el primero es el principal)
INSERT INTO producto_colores (producto_id, color_id, orden) VALUES
  (1, 1, 0),
  (1, 2, 1),
  (1, 3, 2),
  (2, 6, 0),
  (3, 7, 0),
  (4, 4, 0),
  (4, 5, 1),
  (4, 1, 2),
  (4, 8, 3),
  (5, 1, 0),
  (5, 2, 1),
  (6, 4, 0),
  (6, 5, 1),
  (6, 2, 2),
  (7, 4, 0),
  (7, 1, 1),
  (7, 6, 2),
  (8, 4, 0),
  (8, 1, 1),
  (9, 7, 0),
  (10, 3, 0),
  (10, 8, 1),
  (10, 5, 2),
  (11, 1, 0),
  (11, 2, 1),
  (11, 9, 2),
  (12, 2, 0),
  (13, 2, 0),
  (14, 4, 0),
  (14, 5, 1),
  (15, 6, 0),
  (16, 2, 0),
  (17, 1, 0),
  (18, 2, 0),
  (18, 3, 1);

INSERT INTO producto_imagenes (producto_id, ruta, orden) VALUES
  (1, '/img/productos/campera-cuero-1.webp', 0),
  (1, '/img/productos/campera-cuero-2.webp', 1),
  (1, '/img/productos/campera-cuero-3.webp', 2),
  (2, '/img/productos/jean-wide-leg-1.webp', 0),
  (2, '/img/productos/jean-wide-leg-2.webp', 1),
  (3, '/img/productos/jean-franja-1.webp', 0),
  (3, '/img/productos/jean-franja-2.webp', 1),
  (4, '/img/productos/pantalon-palazzo-1.webp', 0),
  (4, '/img/productos/pantalon-palazzo-2.webp', 1),
  (4, '/img/productos/pantalon-palazzo-3.webp', 2),
  (5, '/img/productos/pollera-cuero-1.webp', 0),
  (6, '/img/productos/pollera-short-crema-1.webp', 0),
  (7, '/img/productos/remera-rib-1.webp', 0),
  (7, '/img/productos/remera-rib-2.webp', 1),
  (8, '/img/productos/remera-tejida-1.webp', 0),
  (9, '/img/productos/remera-lavada-1.webp', 0),
  (10, '/img/productos/musculosa-tachas-1.webp', 0),
  (11, '/img/productos/top-halter-broche-1.webp', 0),
  (12, '/img/productos/top-halter-chocolate-1.webp', 0),
  (12, '/img/productos/top-halter-chocolate-2.webp', 1),
  (13, '/img/productos/short-chocolate-1.webp', 0),
  (14, '/img/productos/short-crema-1.webp', 0),
  (15, '/img/productos/short-jean-1.webp', 0),
  (15, '/img/productos/short-jean-2.webp', 1),
  (16, '/img/productos/vestido-halter-1.webp', 0),
  (17, '/img/productos/vestido-largo-1.webp', 0),
  (17, '/img/productos/vestido-largo-2.webp', 1),
  (18, '/img/productos/vestido-tul-1.webp', 0);

-- ── Ficha técnica de cada producto ──────────────────────
INSERT INTO especificaciones (producto_id, clave, valor, orden) VALUES
  (1, 'Material', 'Cuero ecológico', 1),
  (1, 'Calce', 'Regular', 2),
  (1, 'Largo', 'Cintura', 3),
  (1, 'Cuidado', 'Limpiar con paño húmedo', 4),
  (2, 'Composición', '100% algodón', 1),
  (2, 'Calce', 'Wide leg', 2),
  (2, 'Tiro', 'Alto', 3),
  (2, 'Cuidado', 'Lavar del revés en agua fría', 4),
  (3, 'Composición', '98% algodón · 2% elastano', 1),
  (3, 'Calce', 'Recto amplio', 2),
  (3, 'Tiro', 'Alto', 3),
  (3, 'Cuidado', 'Lavar del revés en agua fría', 4),
  (4, 'Composición', '70% poliéster · 28% viscosa · 2% elastano', 1),
  (4, 'Calce', 'Amplio', 2),
  (4, 'Tiro', 'Alto', 3),
  (4, 'Cuidado', 'Lavar en ciclo delicado', 4),
  (5, 'Material', 'Cuero ecológico', 1),
  (5, 'Calce', 'Ajustado', 2),
  (5, 'Largo', 'Mini', 3),
  (5, 'Cuidado', 'Limpiar con paño húmedo', 4),
  (6, 'Composición', '100% poliéster', 1),
  (6, 'Calce', 'Regular', 2),
  (6, 'Largo', 'Mini', 3),
  (6, 'Cuidado', 'Lavar en ciclo delicado', 4),
  (7, 'Composición', '95% algodón · 5% elastano', 1),
  (7, 'Calce', 'Ajustado', 2),
  (7, 'Largo', 'Crop', 3),
  (7, 'Cuidado', 'Lavar con colores similares', 4),
  (8, 'Composición', '100% algodón', 1),
  (8, 'Calce', 'Regular', 2),
  (8, 'Largo', 'Crop', 3),
  (8, 'Cuidado', 'Lavar a mano', 4),
  (9, 'Composición', '100% algodón', 1),
  (9, 'Calce', 'Oversize', 2),
  (9, 'Largo', 'Cadera', 3),
  (9, 'Cuidado', 'Lavar del revés', 4),
  (10, 'Composición', '95% algodón · 5% elastano', 1),
  (10, 'Calce', 'Ajustado', 2),
  (10, 'Largo', 'Crop', 3),
  (10, 'Cuidado', 'Lavar a mano', 4),
  (11, 'Composición', '100% poliéster', 1),
  (11, 'Calce', 'Fluido', 2),
  (11, 'Largo', 'Cintura', 3),
  (11, 'Cuidado', 'Lavar a mano', 4),
  (12, 'Composición', '100% poliéster satinado', 1),
  (12, 'Calce', 'Ajustado', 2),
  (12, 'Largo', 'Cintura', 3),
  (12, 'Cuidado', 'Lavar a mano', 4),
  (13, 'Composición', '98% algodón · 2% elastano', 1),
  (13, 'Calce', 'Regular', 2),
  (13, 'Largo', 'Corto', 3),
  (13, 'Cuidado', 'Lavar del revés en agua fría', 4),
  (14, 'Composición', '98% algodón · 2% elastano', 1),
  (14, 'Calce', 'Regular', 2),
  (14, 'Largo', 'Corto', 3),
  (14, 'Cuidado', 'Lavar del revés en agua fría', 4),
  (15, 'Composición', '100% algodón', 1),
  (15, 'Calce', 'Regular', 2),
  (15, 'Largo', 'Corto', 3),
  (15, 'Cuidado', 'Lavar del revés en agua fría', 4),
  (16, 'Composición', '90% poliéster · 10% elastano', 1),
  (16, 'Calce', 'Ajustado', 2),
  (16, 'Largo', 'Maxi', 3),
  (16, 'Cuidado', 'Lavar a mano', 4),
  (17, 'Composición', '100% viscosa', 1),
  (17, 'Calce', 'Fluido', 2),
  (17, 'Largo', 'Maxi', 3),
  (17, 'Cuidado', 'Lavar a mano', 4),
  (18, 'Composición', '100% poliéster', 1),
  (18, 'Calce', 'Regular', 2),
  (18, 'Largo', 'Maxi', 3),
  (18, 'Cuidado', 'Lavar a mano', 4);

-- ── Cupones ─────────────────────────────────────────────
INSERT INTO cupones (codigo, descripcion, porcentaje, activo, vence_en) VALUES
  ('BIENVENIDA', '10% off en tu primera compra', 0.1000, 1, NULL),
  ('MAQUETA5', '5% off de prueba', 0.0500, 1, NULL),
  ('VERANO20', '20% off de temporada (vencido)', 0.2000, 1, CURDATE() - INTERVAL 10 DAY);

-- ── Favoritos del cliente demo ──────────────────────────
INSERT INTO favoritos (usuario_id, producto_id) VALUES
  (1, 1),
  (1, 4),
  (1, 17);

-- ── Pedidos de los últimos 30 días (80) ─────────────────
INSERT INTO pedidos (id, usuario_id, cliente, email, telefono, entrega, calle, altura, piso, codigo_postal, ciudad, provincia, medio_pago, estado, subtotal, descuento, envio, total, costo, ganancia, creado_en) VALUES
  (1001, NULL, 'Lucía Fernández', 'lucia.fernandez@mail.com', '11 47926919', 'domicilio', 'Av. Siempre Viva', '2176', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'cancelado', 87800, 0, 0, 87800, 43000, 44800, TIMESTAMP(CURDATE() - INTERVAL 29 DAY, '18:17:00')),
  (1002, NULL, 'Valentina López', 'valentina.lopez@mail.com', '11 47934838', 'domicilio', 'Av. Siempre Viva', '2863', NULL, '5500', 'Mendoza', 'Mendoza', 'tarjeta', 'cancelado', 159400, 0, 0, 159400, 76800, 82600, TIMESTAMP(CURDATE() - INTERVAL 29 DAY, '09:45:00')),
  (1003, NULL, 'Santiago Morales', 'santiago.morales@mail.com', '11 47942757', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 55800, 0, 0, 55800, 27000, 28800, TIMESTAMP(CURDATE() - INTERVAL 29 DAY, '14:32:00')),
  (1004, NULL, 'Martín Gómez', 'martin.gomez@mail.com', '11 47950676', 'domicilio', 'Av. Siempre Viva', '1863', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 242600, 0, 0, 242600, 120400, 122200, TIMESTAMP(CURDATE() - INTERVAL 28 DAY, '18:13:00')),
  (1005, 1, 'Cliente Demo', 'demo@tienda.com', '11 47958595', 'domicilio', 'Av. Siempre Viva', '890', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'entregado', 49900, 0, 4500, 54400, 24500, 25400, TIMESTAMP(CURDATE() - INTERVAL 28 DAY, '19:45:00')),
  (1006, NULL, 'Sofía Rodríguez', 'sofia.rodriguez@mail.com', '11 47966514', 'domicilio', 'Av. Siempre Viva', '909', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 46900, 0, 4500, 51400, 23200, 23700, TIMESTAMP(CURDATE() - INTERVAL 28 DAY, '11:09:00')),
  (1007, NULL, 'Micaela Ortiz', 'micaela.ortiz@mail.com', '11 47974433', 'domicilio', 'Av. Siempre Viva', '671', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'entregado', 104700, 0, 0, 104700, 51200, 53500, TIMESTAMP(CURDATE() - INTERVAL 27 DAY, '20:12:00')),
  (1008, NULL, 'Facundo Ruiz', 'facundo.ruiz@mail.com', '11 47982352', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 85700, 0, 0, 85700, 41400, 44300, TIMESTAMP(CURDATE() - INTERVAL 27 DAY, '15:15:00')),
  (1009, 1, 'Cliente Demo', 'demo@tienda.com', '11 47990271', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 117800, 0, 0, 117800, 58400, 59400, TIMESTAMP(CURDATE() - INTERVAL 26 DAY, '19:03:00')),
  (1010, NULL, 'Mateo Sánchez', 'mateo.sanchez@mail.com', '11 47998190', 'domicilio', 'Av. Siempre Viva', '2130', NULL, '5500', 'Mendoza', 'Mendoza', 'tarjeta', 'entregado', 146700, 0, 0, 146700, 72500, 74200, TIMESTAMP(CURDATE() - INTERVAL 26 DAY, '11:12:00')),
  (1011, NULL, 'Santiago Morales', 'santiago.morales@mail.com', '11 48006109', 'domicilio', 'Av. Siempre Viva', '2836', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'entregado', 212600, 0, 0, 212600, 104500, 108100, TIMESTAMP(CURDATE() - INTERVAL 25 DAY, '10:20:00')),
  (1012, NULL, 'Nicolás Álvarez', 'nicolas.alvarez@mail.com', '11 48014028', 'domicilio', 'Av. Siempre Viva', '359', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 189600, 0, 0, 189600, 93000, 96600, TIMESTAMP(CURDATE() - INTERVAL 25 DAY, '09:57:00')),
  (1013, NULL, 'Juan Pérez', 'juan.perez@mail.com', '11 48021947', 'domicilio', 'Av. Siempre Viva', '584', NULL, '5500', 'Mendoza', 'Mendoza', 'transferencia', 'entregado', 52900, 5290, 4500, 52110, 26000, 21610, TIMESTAMP(CURDATE() - INTERVAL 25 DAY, '17:13:00')),
  (1014, NULL, 'Micaela Ortiz', 'micaela.ortiz@mail.com', '11 48029866', 'domicilio', 'Av. Siempre Viva', '2129', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'entregado', 79800, 0, 0, 79800, 39000, 40800, TIMESTAMP(CURDATE() - INTERVAL 24 DAY, '12:17:00')),
  (1015, NULL, 'Facundo Ruiz', 'facundo.ruiz@mail.com', '11 48037785', 'domicilio', 'Av. Siempre Viva', '1707', NULL, '1900', 'La Plata', 'Buenos Aires', 'tarjeta', 'entregado', 116800, 0, 0, 116800, 58000, 58800, TIMESTAMP(CURDATE() - INTERVAL 24 DAY, '14:08:00')),
  (1016, NULL, 'Juan Pérez', 'juan.perez@mail.com', '11 48045704', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 177600, 17760, 0, 159840, 87400, 72440, TIMESTAMP(CURDATE() - INTERVAL 24 DAY, '16:55:00')),
  (1017, NULL, 'Lucía Fernández', 'lucia.fernandez@mail.com', '11 48053623', 'domicilio', 'Av. Siempre Viva', '2728', NULL, '5500', 'Mendoza', 'Mendoza', 'tarjeta', 'entregado', 84800, 0, 0, 84800, 41500, 43300, TIMESTAMP(CURDATE() - INTERVAL 23 DAY, '12:35:00')),
  (1018, NULL, 'Tomás Díaz', 'tomas.diaz@mail.com', '11 48061542', 'domicilio', 'Av. Siempre Viva', '972', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'entregado', 49900, 0, 4500, 54400, 24500, 25400, TIMESTAMP(CURDATE() - INTERVAL 23 DAY, '09:49:00')),
  (1019, NULL, 'Valentina López', 'valentina.lopez@mail.com', '11 48069461', 'domicilio', 'Av. Siempre Viva', '906', NULL, '5500', 'Mendoza', 'Mendoza', 'tarjeta', 'entregado', 46900, 0, 4500, 51400, 23200, 23700, TIMESTAMP(CURDATE() - INTERVAL 23 DAY, '09:17:00')),
  (1020, NULL, 'Santiago Morales', 'santiago.morales@mail.com', '11 48077380', 'domicilio', 'Av. Siempre Viva', '2562', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 139800, 0, 0, 139800, 69500, 70300, TIMESTAMP(CURDATE() - INTERVAL 23 DAY, '10:31:00')),
  (1021, NULL, 'Florencia Castro', 'florencia.castro@mail.com', '11 48085299', 'domicilio', 'Av. Siempre Viva', '1127', NULL, '2000', 'Rosario', 'Santa Fe', 'tarjeta', 'cancelado', 81700, 0, 0, 81700, 39500, 42200, TIMESTAMP(CURDATE() - INTERVAL 22 DAY, '17:09:00')),
  (1022, 1, 'Cliente Demo', 'demo@tienda.com', '11 48093218', 'domicilio', 'Av. Siempre Viva', '1573', NULL, '1900', 'La Plata', 'Buenos Aires', 'tarjeta', 'entregado', 86700, 0, 0, 86700, 41900, 44800, TIMESTAMP(CURDATE() - INTERVAL 22 DAY, '14:36:00')),
  (1023, NULL, 'Valentina López', 'valentina.lopez@mail.com', '11 48101137', 'domicilio', 'Av. Siempre Viva', '3390', NULL, '5000', 'Córdoba', 'Córdoba', 'transferencia', 'entregado', 21900, 2190, 4500, 24210, 10500, 9210, TIMESTAMP(CURDATE() - INTERVAL 22 DAY, '16:42:00')),
  (1024, NULL, 'Nicolás Álvarez', 'nicolas.alvarez@mail.com', '11 48109056', 'domicilio', 'Av. Siempre Viva', '1747', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'entregado', 59800, 0, 4500, 64300, 29000, 30800, TIMESTAMP(CURDATE() - INTERVAL 21 DAY, '20:28:00')),
  (1025, 1, 'Cliente Demo', 'demo@tienda.com', '11 48116975', 'domicilio', 'Av. Siempre Viva', '1499', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 75700, 0, 0, 75700, 36500, 39200, TIMESTAMP(CURDATE() - INTERVAL 21 DAY, '14:59:00')),
  (1026, NULL, 'Facundo Ruiz', 'facundo.ruiz@mail.com', '11 48124894', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 57800, 0, 0, 57800, 28000, 29800, TIMESTAMP(CURDATE() - INTERVAL 21 DAY, '16:00:00')),
  (1027, NULL, 'Valentina López', 'valentina.lopez@mail.com', '11 48132813', 'domicilio', 'Av. Siempre Viva', '2006', NULL, '2000', 'Rosario', 'Santa Fe', 'tarjeta', 'entregado', 88800, 0, 0, 88800, 43500, 45300, TIMESTAMP(CURDATE() - INTERVAL 21 DAY, '20:14:00')),
  (1028, NULL, 'Mateo Sánchez', 'mateo.sanchez@mail.com', '11 48140732', 'domicilio', 'Av. Siempre Viva', '442', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'entregado', 135700, 0, 0, 135700, 66700, 69000, TIMESTAMP(CURDATE() - INTERVAL 20 DAY, '20:03:00')),
  (1029, 1, 'Cliente Demo', 'demo@tienda.com', '11 48148651', 'domicilio', 'Av. Siempre Viva', '3806', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'entregado', 96800, 0, 0, 96800, 47700, 49100, TIMESTAMP(CURDATE() - INTERVAL 20 DAY, '15:13:00')),
  (1030, 1, 'Cliente Demo', 'demo@tienda.com', '11 48156570', 'domicilio', 'Av. Siempre Viva', '252', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 148800, 0, 0, 148800, 74000, 74800, TIMESTAMP(CURDATE() - INTERVAL 19 DAY, '14:02:00')),
  (1031, NULL, 'Santiago Morales', 'santiago.morales@mail.com', '11 48164489', 'domicilio', 'Av. Siempre Viva', '3376', NULL, '1900', 'La Plata', 'Buenos Aires', 'tarjeta', 'entregado', 27900, 0, 4500, 32400, 13400, 14500, TIMESTAMP(CURDATE() - INTERVAL 19 DAY, '12:33:00')),
  (1032, NULL, 'Agustina Torres', 'agustina.torres@mail.com', '11 48172408', 'domicilio', 'Av. Siempre Viva', '2649', NULL, '1900', 'La Plata', 'Buenos Aires', 'tarjeta', 'entregado', 96800, 0, 0, 96800, 47700, 49100, TIMESTAMP(CURDATE() - INTERVAL 18 DAY, '11:16:00')),
  (1033, NULL, 'Valentina López', 'valentina.lopez@mail.com', '11 48180327', 'domicilio', 'Av. Siempre Viva', '1406', NULL, '1900', 'La Plata', 'Buenos Aires', 'transferencia', 'entregado', 111600, 11160, 0, 100440, 53900, 46540, TIMESTAMP(CURDATE() - INTERVAL 18 DAY, '17:01:00')),
  (1034, NULL, 'Santiago Morales', 'santiago.morales@mail.com', '11 48188246', 'domicilio', 'Av. Siempre Viva', '2207', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'transferencia', 'cancelado', 77800, 7780, 0, 70020, 37900, 32120, TIMESTAMP(CURDATE() - INTERVAL 18 DAY, '09:16:00')),
  (1035, NULL, 'Tomás Díaz', 'tomas.diaz@mail.com', '11 48196165', 'domicilio', 'Av. Siempre Viva', '2112', NULL, '5500', 'Mendoza', 'Mendoza', 'tarjeta', 'entregado', 57800, 0, 4500, 62300, 28000, 29800, TIMESTAMP(CURDATE() - INTERVAL 18 DAY, '12:25:00')),
  (1036, NULL, 'Martín Gómez', 'martin.gomez@mail.com', '11 48204084', 'domicilio', 'Av. Siempre Viva', '2079', NULL, '2000', 'Rosario', 'Santa Fe', 'tarjeta', 'entregado', 47800, 0, 4500, 52300, 23000, 24800, TIMESTAMP(CURDATE() - INTERVAL 17 DAY, '19:30:00')),
  (1037, NULL, 'Santiago Morales', 'santiago.morales@mail.com', '11 48212003', 'domicilio', 'Av. Siempre Viva', '1639', NULL, '2000', 'Rosario', 'Santa Fe', 'tarjeta', 'entregado', 26900, 0, 4500, 31400, 13000, 13900, TIMESTAMP(CURDATE() - INTERVAL 17 DAY, '11:20:00')),
  (1038, NULL, 'Florencia Castro', 'florencia.castro@mail.com', '11 48219922', 'domicilio', 'Av. Siempre Viva', '2307', NULL, '1900', 'La Plata', 'Buenos Aires', 'tarjeta', 'entregado', 49900, 0, 4500, 54400, 24500, 25400, TIMESTAMP(CURDATE() - INTERVAL 16 DAY, '09:23:00')),
  (1039, NULL, 'Mateo Sánchez', 'mateo.sanchez@mail.com', '11 48227841', 'domicilio', 'Av. Siempre Viva', '2027', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 202600, 0, 0, 202600, 99500, 103100, TIMESTAMP(CURDATE() - INTERVAL 16 DAY, '13:28:00')),
  (1040, NULL, 'Juan Pérez', 'juan.perez@mail.com', '11 48235760', 'domicilio', 'Av. Siempre Viva', '883', NULL, '2000', 'Rosario', 'Santa Fe', 'transferencia', 'entregado', 29900, 2990, 4500, 31410, 14500, 12410, TIMESTAMP(CURDATE() - INTERVAL 15 DAY, '15:08:00')),
  (1041, NULL, 'Camila Martínez', 'camila.martinez@mail.com', '11 48243679', 'domicilio', 'Av. Siempre Viva', '2653', NULL, '5500', 'Mendoza', 'Mendoza', 'tarjeta', 'entregado', 136800, 0, 0, 136800, 68200, 68600, TIMESTAMP(CURDATE() - INTERVAL 15 DAY, '18:30:00')),
  (1042, NULL, 'Sofía Rodríguez', 'sofia.rodriguez@mail.com', '11 48251598', 'domicilio', 'Av. Siempre Viva', '3992', NULL, '5500', 'Mendoza', 'Mendoza', 'transferencia', 'entregado', 109700, 10970, 0, 98730, 53400, 45330, TIMESTAMP(CURDATE() - INTERVAL 14 DAY, '14:40:00')),
  (1043, NULL, 'Lucía Fernández', 'lucia.fernandez@mail.com', '11 48259517', 'domicilio', 'Av. Siempre Viva', '2307', NULL, '5500', 'Mendoza', 'Mendoza', 'tarjeta', 'entregado', 141700, 0, 0, 141700, 69500, 72200, TIMESTAMP(CURDATE() - INTERVAL 14 DAY, '12:45:00')),
  (1044, NULL, 'Facundo Ruiz', 'facundo.ruiz@mail.com', '11 48267436', 'domicilio', 'Av. Siempre Viva', '1849', NULL, '2000', 'Rosario', 'Santa Fe', 'tarjeta', 'entregado', 146700, 0, 0, 146700, 72000, 74700, TIMESTAMP(CURDATE() - INTERVAL 14 DAY, '17:28:00')),
  (1045, NULL, 'Facundo Ruiz', 'facundo.ruiz@mail.com', '11 48275355', 'domicilio', 'Av. Siempre Viva', '1853', NULL, '1900', 'La Plata', 'Buenos Aires', 'tarjeta', 'entregado', 79700, 0, 0, 79700, 38500, 41200, TIMESTAMP(CURDATE() - INTERVAL 13 DAY, '17:03:00')),
  (1046, NULL, 'Agustina Torres', 'agustina.torres@mail.com', '11 48283274', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 167700, 16770, 0, 150930, 82700, 68230, TIMESTAMP(CURDATE() - INTERVAL 13 DAY, '14:11:00')),
  (1047, NULL, 'Valentina López', 'valentina.lopez@mail.com', '11 48291193', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 58900, 5890, 0, 53010, 29000, 24010, TIMESTAMP(CURDATE() - INTERVAL 12 DAY, '09:18:00')),
  (1048, NULL, 'Nicolás Álvarez', 'nicolas.alvarez@mail.com', '11 48299112', 'domicilio', 'Av. Siempre Viva', '547', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'transferencia', 'entregado', 350500, 35050, 0, 315450, 174000, 141450, TIMESTAMP(CURDATE() - INTERVAL 12 DAY, '09:19:00')),
  (1049, NULL, 'Mateo Sánchez', 'mateo.sanchez@mail.com', '11 48307031', 'domicilio', 'Av. Siempre Viva', '613', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'entregado', 173700, 0, 0, 173700, 85500, 88200, TIMESTAMP(CURDATE() - INTERVAL 12 DAY, '13:38:00')),
  (1050, NULL, 'Agustina Torres', 'agustina.torres@mail.com', '11 48314950', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 27900, 0, 0, 27900, 13400, 14500, TIMESTAMP(CURDATE() - INTERVAL 12 DAY, '16:03:00')),
  (1051, NULL, 'Valentina López', 'valentina.lopez@mail.com', '11 48322869', 'domicilio', 'Av. Siempre Viva', '919', NULL, '1900', 'La Plata', 'Buenos Aires', 'tarjeta', 'entregado', 141600, 0, 0, 141600, 69000, 72600, TIMESTAMP(CURDATE() - INTERVAL 11 DAY, '17:13:00')),
  (1052, NULL, 'Tomás Díaz', 'tomas.diaz@mail.com', '11 48330788', 'domicilio', 'Av. Siempre Viva', '2316', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 107700, 0, 0, 107700, 52500, 55200, TIMESTAMP(CURDATE() - INTERVAL 11 DAY, '10:13:00')),
  (1053, NULL, 'Lucía Fernández', 'lucia.fernandez@mail.com', '11 48338707', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 70800, 0, 0, 70800, 34700, 36100, TIMESTAMP(CURDATE() - INTERVAL 11 DAY, '11:35:00')),
  (1054, NULL, 'Nicolás Álvarez', 'nicolas.alvarez@mail.com', '11 48346626', 'domicilio', 'Av. Siempre Viva', '2505', NULL, '5500', 'Mendoza', 'Mendoza', 'transferencia', 'entregado', 89900, 8990, 0, 80910, 45000, 35910, TIMESTAMP(CURDATE() - INTERVAL 11 DAY, '13:44:00')),
  (1055, NULL, 'Camila Martínez', 'camila.martinez@mail.com', '11 48354545', 'domicilio', 'Av. Siempre Viva', '785', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'entregado', 78800, 0, 0, 78800, 38500, 40300, TIMESTAMP(CURDATE() - INTERVAL 10 DAY, '18:19:00')),
  (1056, NULL, 'Santiago Morales', 'santiago.morales@mail.com', '11 48362464', 'domicilio', 'Av. Siempre Viva', '882', NULL, '2000', 'Rosario', 'Santa Fe', 'tarjeta', 'entregado', 183600, 0, 0, 183600, 90500, 93100, TIMESTAMP(CURDATE() - INTERVAL 10 DAY, '09:14:00')),
  (1057, NULL, 'Tomás Díaz', 'tomas.diaz@mail.com', '11 48370383', 'domicilio', 'Av. Siempre Viva', '2187', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'transferencia', 'entregado', 87800, 8780, 0, 79020, 43000, 36020, TIMESTAMP(CURDATE() - INTERVAL 9 DAY, '13:01:00')),
  (1058, NULL, 'Sofía Rodríguez', 'sofia.rodriguez@mail.com', '11 48378302', 'domicilio', 'Av. Siempre Viva', '2180', NULL, '2000', 'Rosario', 'Santa Fe', 'transferencia', 'entregado', 92700, 9270, 0, 83430, 45000, 38430, TIMESTAMP(CURDATE() - INTERVAL 9 DAY, '10:47:00')),
  (1059, NULL, 'Sofía Rodríguez', 'sofia.rodriguez@mail.com', '11 48386221', 'domicilio', 'Av. Siempre Viva', '1261', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'transferencia', 'entregado', 23900, 2390, 4500, 26010, 11500, 10010, TIMESTAMP(CURDATE() - INTERVAL 8 DAY, '14:36:00')),
  (1060, NULL, 'Florencia Castro', 'florencia.castro@mail.com', '11 48394140', 'domicilio', 'Av. Siempre Viva', '3321', NULL, '5500', 'Mendoza', 'Mendoza', 'tarjeta', 'entregado', 266600, 0, 0, 266600, 132400, 134200, TIMESTAMP(CURDATE() - INTERVAL 8 DAY, '12:15:00')),
  (1061, NULL, 'Valentina López', 'valentina.lopez@mail.com', '11 48402059', 'domicilio', 'Av. Siempre Viva', '2563', NULL, '2000', 'Rosario', 'Santa Fe', 'tarjeta', 'entregado', 89900, 0, 0, 89900, 45000, 44900, TIMESTAMP(CURDATE() - INTERVAL 7 DAY, '15:48:00')),
  (1062, NULL, 'Camila Martínez', 'camila.martinez@mail.com', '11 48409978', 'domicilio', 'Av. Siempre Viva', '3078', NULL, '1900', 'La Plata', 'Buenos Aires', 'tarjeta', 'entregado', 271500, 0, 0, 271500, 134000, 137500, TIMESTAMP(CURDATE() - INTERVAL 7 DAY, '11:02:00')),
  (1063, NULL, 'Micaela Ortiz', 'micaela.ortiz@mail.com', '11 48417897', 'domicilio', 'Av. Siempre Viva', '222', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 46900, 0, 4500, 51400, 23200, 23700, TIMESTAMP(CURDATE() - INTERVAL 6 DAY, '18:04:00')),
  (1064, NULL, 'Agustina Torres', 'agustina.torres@mail.com', '11 48425816', 'domicilio', 'Av. Siempre Viva', '1198', NULL, '2000', 'Rosario', 'Santa Fe', 'tarjeta', 'cancelado', 206700, 0, 0, 206700, 103000, 103700, TIMESTAMP(CURDATE() - INTERVAL 6 DAY, '12:24:00')),
  (1065, NULL, 'Nicolás Álvarez', 'nicolas.alvarez@mail.com', '11 48433735', 'domicilio', 'Av. Siempre Viva', '1424', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'transferencia', 'entregado', 123800, 12380, 0, 111420, 61000, 50420, TIMESTAMP(CURDATE() - INTERVAL 5 DAY, '16:51:00')),
  (1066, NULL, 'Agustina Torres', 'agustina.torres@mail.com', '11 48441654', 'domicilio', 'Av. Siempre Viva', '1008', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 93700, 0, 0, 93700, 45500, 48200, TIMESTAMP(CURDATE() - INTERVAL 5 DAY, '17:00:00')),
  (1067, NULL, 'Martín Gómez', 'martin.gomez@mail.com', '11 48449573', 'domicilio', 'Av. Siempre Viva', '2367', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'transferencia', 'entregado', 128700, 12870, 0, 115830, 63200, 52630, TIMESTAMP(CURDATE() - INTERVAL 4 DAY, '14:23:00')),
  (1068, NULL, 'Mateo Sánchez', 'mateo.sanchez@mail.com', '11 48457492', 'domicilio', 'Av. Siempre Viva', '354', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'transferencia', 'enviado', 145600, 14560, 0, 131040, 70700, 60340, TIMESTAMP(CURDATE() - INTERVAL 4 DAY, '14:15:00')),
  (1069, NULL, 'Juan Pérez', 'juan.perez@mail.com', '11 48465411', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'enviado', 114800, 11480, 0, 103320, 57000, 46320, TIMESTAMP(CURDATE() - INTERVAL 4 DAY, '09:46:00')),
  (1070, NULL, 'Nicolás Álvarez', 'nicolas.alvarez@mail.com', '11 48473330', 'domicilio', 'Av. Siempre Viva', '1838', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'enviado', 56800, 0, 4500, 61300, 27500, 29300, TIMESTAMP(CURDATE() - INTERVAL 4 DAY, '16:51:00')),
  (1071, NULL, 'Camila Martínez', 'camila.martinez@mail.com', '11 48481249', 'domicilio', 'Av. Siempre Viva', '3713', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'enviado', 26900, 0, 4500, 31400, 13000, 13900, TIMESTAMP(CURDATE() - INTERVAL 3 DAY, '11:58:00')),
  (1072, NULL, 'Lucía Fernández', 'lucia.fernandez@mail.com', '11 48489168', 'domicilio', 'Av. Siempre Viva', '1417', NULL, '5500', 'Mendoza', 'Mendoza', 'transferencia', 'enviado', 161700, 16170, 0, 145530, 79500, 66030, TIMESTAMP(CURDATE() - INTERVAL 3 DAY, '10:59:00')),
  (1073, NULL, 'Camila Martínez', 'camila.martinez@mail.com', '11 48497087', 'domicilio', 'Av. Siempre Viva', '600', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'transferencia', 'enviado', 27900, 2790, 4500, 29610, 13400, 11710, TIMESTAMP(CURDATE() - INTERVAL 2 DAY, '15:00:00')),
  (1074, 1, 'Cliente Demo', 'demo@tienda.com', '11 48505006', 'domicilio', 'Av. Siempre Viva', '2306', NULL, '5500', 'Mendoza', 'Mendoza', 'transferencia', 'entregado', 139800, 13980, 0, 125820, 69500, 56320, TIMESTAMP(CURDATE() - INTERVAL 2 DAY, '12:31:00')),
  (1075, 1, 'Cliente Demo', 'demo@tienda.com', '11 48512925', 'domicilio', 'Av. Siempre Viva', '352', NULL, '1900', 'La Plata', 'Buenos Aires', 'transferencia', 'pagado', 106700, 10670, 0, 96030, 52000, 44030, TIMESTAMP(CURDATE() - INTERVAL 1 DAY, '11:40:00')),
  (1076, NULL, 'Camila Martínez', 'camila.martinez@mail.com', '11 48520844', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'pagado', 85800, 8580, 0, 77220, 42000, 35220, TIMESTAMP(CURDATE() - INTERVAL 1 DAY, '10:18:00')),
  (1077, NULL, 'Agustina Torres', 'agustina.torres@mail.com', '11 48528763', 'domicilio', 'Av. Siempre Viva', '1070', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'pagado', 217600, 0, 0, 217600, 107000, 110600, TIMESTAMP(CURDATE() - INTERVAL 1 DAY, '19:41:00')),
  (1078, NULL, 'Tomás Díaz', 'tomas.diaz@mail.com', '11 48536682', 'domicilio', 'Av. Siempre Viva', '2449', NULL, '2000', 'Rosario', 'Santa Fe', 'transferencia', 'enviado', 55800, 5580, 4500, 54720, 26900, 23320, TIMESTAMP(CURDATE() - INTERVAL 1 DAY, '19:59:00')),
  (1079, 1, 'Cliente Demo', 'demo@tienda.com', '11 48544601', 'domicilio', 'Av. Siempre Viva', '1487', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'pagado', 47800, 0, 4500, 52300, 23000, 24800, NOW() - INTERVAL 66 MINUTE),
  (1080, NULL, 'Juan Pérez', 'juan.perez@mail.com', '11 48552520', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'pagado', 46900, 4690, 0, 42210, 23200, 19010, NOW() - INTERVAL 123 MINUTE);

-- Cobro: los pedidos pagados/enviados/entregados tienen el pago aprobado
UPDATE pedidos SET pago_estado = 'aprobado', pagado_en = creado_en
WHERE estado IN ('pagado', 'enviado', 'entregado');
UPDATE pedidos
SET pago_detalle = ELT(1 + MOD(id, 4), 'Visa terminada en 4242 · 3 cuotas', 'Mastercard terminada en 5100 · 1 cuota',
                       'Naranja terminada en 6019 · 6 cuotas', 'Dinero en cuenta de Mercado Pago'),
    pago_id = CONCAT('demo-', id)
WHERE medio_pago = 'tarjeta' AND pago_estado = 'aprobado';
UPDATE pedidos SET pago_detalle = 'Transferencia acreditada'
WHERE medio_pago = 'transferencia' AND pago_estado = 'aprobado';

-- Dirección guardada del cliente demo (se usa para completar el checkout)
UPDATE usuarios SET dni = '30111222', calle = 'Av. Siempre Viva', altura = '2837', codigo_postal = '1405',
       ciudad = 'CABA', provincia = 'Ciudad Autónoma de Buenos Aires'
WHERE email = 'demo@tienda.com';

UPDATE pedidos SET actualizado_en = creado_en;

-- ── Renglones de los pedidos (159) ─────────────────────────
INSERT INTO pedido_items (pedido_id, producto_id, nombre, color, talle, precio, costo, cantidad) VALUES
  (1001, 17, 'Vestido Largo Estampado', 'Negro', 'M', 58900, 29000, 1),
  (1001, 12, 'Top Halter Chocolate', 'Chocolate', 'XS', 28900, 14000, 1),
  (1002, 8, 'Remera Tejida Crema', 'Negro', 'S', 24900, 12000, 2),
  (1002, 10, 'Musculosa con Tachas', 'Beige', 'XL', 26900, 13000, 2),
  (1002, 14, 'Short Crema', 'Crema', 'XL', 27900, 13400, 2),
  (1003, 12, 'Top Halter Chocolate', 'Chocolate', 'L', 28900, 14000, 1),
  (1003, 10, 'Musculosa con Tachas', 'Verde', 'L', 26900, 13000, 1),
  (1004, 4, 'Pantalón Palazzo Sastrero', 'Crema', 'XS', 46900, 23200, 2),
  (1004, 17, 'Vestido Largo Estampado', 'Negro', 'M', 58900, 29000, 1),
  (1004, 1, 'Campera de Cuero', 'Chocolate', 'L', 89900, 45000, 1),
  (1005, 3, 'Jean Franja Gris', 'Gris', 'S', 49900, 24500, 1),
  (1006, 4, 'Pantalón Palazzo Sastrero', 'Negro', 'XL', 46900, 23200, 1),
  (1007, 4, 'Pantalón Palazzo Sastrero', 'Beige', 'XL', 46900, 23200, 1),
  (1007, 12, 'Top Halter Chocolate', 'Chocolate', 'L', 28900, 14000, 2),
  (1008, 13, 'Short Chocolate', 'Chocolate', 'XS', 27900, 13400, 1),
  (1008, 11, 'Top Halter con Broche', 'Negro', 'XL', 27900, 13500, 1),
  (1008, 15, 'Short Jean Desflecado', 'Azul jean', 'S', 29900, 14500, 1),
  (1009, 1, 'Campera de Cuero', 'Bordó', 'XS', 89900, 45000, 1),
  (1009, 13, 'Short Chocolate', 'Chocolate', 'XS', 27900, 13400, 1),
  (1010, 15, 'Short Jean Desflecado', 'Azul jean', 'XS', 29900, 14500, 1),
  (1010, 10, 'Musculosa con Tachas', 'Verde', 'XL', 26900, 13000, 1),
  (1010, 1, 'Campera de Cuero', 'Negro', 'S', 89900, 45000, 1),
  (1011, 6, 'Pollera Short Crema', 'Chocolate', 'XL', 29900, 14500, 1),
  (1011, 18, 'Vestido Tul Estampado', 'Bordó', 'XS', 61900, 30500, 2),
  (1011, 17, 'Vestido Largo Estampado', 'Negro', 'XS', 58900, 29000, 1),
  (1012, 17, 'Vestido Largo Estampado', 'Negro', 'M', 58900, 29000, 2),
  (1012, 3, 'Jean Franja Gris', 'Gris', 'XL', 49900, 24500, 1),
  (1012, 7, 'Remera Rib con Vivos', 'Negro', 'S', 21900, 10500, 1),
  (1013, 2, 'Jean Wide Leg', 'Azul jean', 'XL', 52900, 26000, 1),
  (1014, 3, 'Jean Franja Gris', 'Gris', 'S', 49900, 24500, 1),
  (1014, 15, 'Short Jean Desflecado', 'Azul jean', 'S', 29900, 14500, 1),
  (1015, 1, 'Campera de Cuero', 'Chocolate', 'S', 89900, 45000, 1),
  (1015, 10, 'Musculosa con Tachas', 'Bordó', 'S', 26900, 13000, 1),
  (1016, 14, 'Short Crema', 'Crema', 'XS', 27900, 13400, 1),
  (1016, 1, 'Campera de Cuero', 'Negro', 'XS', 89900, 45000, 1),
  (1016, 15, 'Short Jean Desflecado', 'Azul jean', 'L', 29900, 14500, 2),
  (1017, 5, 'Pollera Mini Cuero', 'Chocolate', 'XS', 34900, 17000, 1),
  (1017, 3, 'Jean Franja Gris', 'Gris', 'S', 49900, 24500, 1),
  (1018, 3, 'Jean Franja Gris', 'Gris', 'L', 49900, 24500, 1),
  (1019, 4, 'Pantalón Palazzo Sastrero', 'Negro', 'S', 46900, 23200, 1),
  (1020, 1, 'Campera de Cuero', 'Bordó', 'S', 89900, 45000, 1),
  (1020, 3, 'Jean Franja Gris', 'Gris', 'L', 49900, 24500, 1),
  (1021, 9, 'Remera Lavada Gris', 'Gris', 'L', 23900, 11500, 1),
  (1021, 12, 'Top Halter Chocolate', 'Chocolate', 'L', 28900, 14000, 2),
  (1022, 15, 'Short Jean Desflecado', 'Azul jean', 'XS', 29900, 14500, 1),
  (1022, 12, 'Top Halter Chocolate', 'Chocolate', 'M', 28900, 14000, 1),
  (1022, 13, 'Short Chocolate', 'Chocolate', 'XS', 27900, 13400, 1),
  (1023, 7, 'Remera Rib con Vivos', 'Azul jean', 'L', 21900, 10500, 1),
  (1024, 15, 'Short Jean Desflecado', 'Azul jean', 'L', 29900, 14500, 2),
  (1025, 7, 'Remera Rib con Vivos', 'Negro', 'L', 21900, 10500, 1),
  (1025, 10, 'Musculosa con Tachas', 'Verde', 'M', 26900, 13000, 2),
  (1026, 12, 'Top Halter Chocolate', 'Chocolate', 'M', 28900, 14000, 2),
  (1027, 6, 'Pollera Short Crema', 'Crema', 'L', 29900, 14500, 1),
  (1027, 17, 'Vestido Largo Estampado', 'Negro', 'XL', 58900, 29000, 1),
  (1028, 4, 'Pantalón Palazzo Sastrero', 'Beige', 'XL', 46900, 23200, 1),
  (1028, 15, 'Short Jean Desflecado', 'Azul jean', 'XS', 29900, 14500, 1),
  (1028, 17, 'Vestido Largo Estampado', 'Negro', 'L', 58900, 29000, 1),
  (1029, 3, 'Jean Franja Gris', 'Gris', 'XS', 49900, 24500, 1),
  (1029, 4, 'Pantalón Palazzo Sastrero', 'Beige', 'M', 46900, 23200, 1),
  (1030, 1, 'Campera de Cuero', 'Bordó', 'L', 89900, 45000, 1),
  (1030, 17, 'Vestido Largo Estampado', 'Negro', 'XL', 58900, 29000, 1),
  (1031, 13, 'Short Chocolate', 'Chocolate', 'XL', 27900, 13400, 1),
  (1032, 4, 'Pantalón Palazzo Sastrero', 'Beige', 'L', 46900, 23200, 1),
  (1032, 3, 'Jean Franja Gris', 'Gris', 'L', 49900, 24500, 1),
  (1033, 13, 'Short Chocolate', 'Chocolate', 'XL', 27900, 13400, 1),
  (1033, 15, 'Short Jean Desflecado', 'Azul jean', 'S', 29900, 14500, 1),
  (1033, 10, 'Musculosa con Tachas', 'Verde', 'XL', 26900, 13000, 2),
  (1034, 14, 'Short Crema', 'Crema', 'XL', 27900, 13400, 1),
  (1034, 3, 'Jean Franja Gris', 'Gris', 'XL', 49900, 24500, 1),
  (1035, 12, 'Top Halter Chocolate', 'Chocolate', 'M', 28900, 14000, 2),
  (1036, 9, 'Remera Lavada Gris', 'Gris', 'M', 23900, 11500, 2),
  (1037, 10, 'Musculosa con Tachas', 'Bordó', 'XS', 26900, 13000, 1),
  (1038, 3, 'Jean Franja Gris', 'Gris', 'S', 49900, 24500, 1),
  (1039, 18, 'Vestido Tul Estampado', 'Bordó', 'XL', 61900, 30500, 2),
  (1039, 12, 'Top Halter Chocolate', 'Chocolate', 'L', 28900, 14000, 1),
  (1039, 3, 'Jean Franja Gris', 'Gris', 'L', 49900, 24500, 1),
  (1040, 6, 'Pollera Short Crema', 'Beige', 'XL', 29900, 14500, 1),
  (1041, 4, 'Pantalón Palazzo Sastrero', 'Crema', 'M', 46900, 23200, 1),
  (1041, 1, 'Campera de Cuero', 'Bordó', 'L', 89900, 45000, 1),
  (1042, 14, 'Short Crema', 'Beige', 'L', 27900, 13400, 1),
  (1042, 12, 'Top Halter Chocolate', 'Chocolate', 'M', 28900, 14000, 1),
  (1042, 2, 'Jean Wide Leg', 'Azul jean', 'XS', 52900, 26000, 1),
  (1043, 18, 'Vestido Tul Estampado', 'Bordó', 'S', 61900, 30500, 1),
  (1043, 10, 'Musculosa con Tachas', 'Verde', 'L', 26900, 13000, 1),
  (1043, 2, 'Jean Wide Leg', 'Azul jean', 'XS', 52900, 26000, 1),
  (1044, 17, 'Vestido Largo Estampado', 'Negro', 'L', 58900, 29000, 2),
  (1044, 12, 'Top Halter Chocolate', 'Chocolate', 'S', 28900, 14000, 1),
  (1045, 7, 'Remera Rib con Vivos', 'Negro', 'M', 21900, 10500, 1),
  (1045, 12, 'Top Halter Chocolate', 'Chocolate', 'L', 28900, 14000, 2),
  (1046, 17, 'Vestido Largo Estampado', 'Negro', 'S', 58900, 29000, 1),
  (1046, 4, 'Pantalón Palazzo Sastrero', 'Beige', 'S', 46900, 23200, 1),
  (1046, 18, 'Vestido Tul Estampado', 'Chocolate', 'L', 61900, 30500, 1),
  (1047, 17, 'Vestido Largo Estampado', 'Negro', 'M', 58900, 29000, 1),
  (1048, 17, 'Vestido Largo Estampado', 'Negro', 'XL', 58900, 29000, 2),
  (1048, 2, 'Jean Wide Leg', 'Azul jean', 'L', 52900, 26000, 1),
  (1048, 1, 'Campera de Cuero', 'Negro', 'S', 89900, 45000, 2),
  (1049, 3, 'Jean Franja Gris', 'Gris', 'M', 49900, 24500, 1),
  (1049, 18, 'Vestido Tul Estampado', 'Bordó', 'L', 61900, 30500, 2),
  (1050, 14, 'Short Crema', 'Crema', 'S', 27900, 13400, 1),
  (1051, 15, 'Short Jean Desflecado', 'Azul jean', 'L', 29900, 14500, 2),
  (1051, 12, 'Top Halter Chocolate', 'Chocolate', 'L', 28900, 14000, 1),
  (1051, 2, 'Jean Wide Leg', 'Azul jean', 'XS', 52900, 26000, 1),
  (1052, 2, 'Jean Wide Leg', 'Azul jean', 'XL', 52900, 26000, 1),
  (1052, 15, 'Short Jean Desflecado', 'Azul jean', 'XS', 29900, 14500, 1),
  (1052, 8, 'Remera Tejida Crema', 'Crema', 'M', 24900, 12000, 1),
  (1053, 9, 'Remera Lavada Gris', 'Gris', 'L', 23900, 11500, 1),
  (1053, 4, 'Pantalón Palazzo Sastrero', 'Negro', 'S', 46900, 23200, 1),
  (1054, 1, 'Campera de Cuero', 'Bordó', 'M', 89900, 45000, 1),
  (1055, 12, 'Top Halter Chocolate', 'Chocolate', 'S', 28900, 14000, 1),
  (1055, 3, 'Jean Franja Gris', 'Gris', 'M', 49900, 24500, 1),
  (1056, 1, 'Campera de Cuero', 'Negro', 'XS', 89900, 45000, 1),
  (1056, 5, 'Pollera Mini Cuero', 'Negro', 'S', 34900, 17000, 2),
  (1056, 9, 'Remera Lavada Gris', 'Gris', 'L', 23900, 11500, 1),
  (1057, 17, 'Vestido Largo Estampado', 'Negro', 'M', 58900, 29000, 1),
  (1057, 12, 'Top Halter Chocolate', 'Chocolate', 'L', 28900, 14000, 1),
  (1058, 5, 'Pollera Mini Cuero', 'Negro', 'M', 34900, 17000, 1),
  (1058, 15, 'Short Jean Desflecado', 'Azul jean', 'S', 29900, 14500, 1),
  (1058, 11, 'Top Halter con Broche', 'Chocolate', 'XL', 27900, 13500, 1),
  (1059, 9, 'Remera Lavada Gris', 'Gris', 'M', 23900, 11500, 1),
  (1060, 13, 'Short Chocolate', 'Chocolate', 'XS', 27900, 13400, 1),
  (1060, 17, 'Vestido Largo Estampado', 'Negro', 'S', 58900, 29000, 1),
  (1060, 1, 'Campera de Cuero', 'Bordó', 'S', 89900, 45000, 2),
  (1061, 1, 'Campera de Cuero', 'Negro', 'XS', 89900, 45000, 1),
  (1062, 18, 'Vestido Tul Estampado', 'Bordó', 'M', 61900, 30500, 2),
  (1062, 12, 'Top Halter Chocolate', 'Chocolate', 'XS', 28900, 14000, 2),
  (1062, 1, 'Campera de Cuero', 'Chocolate', 'S', 89900, 45000, 1),
  (1063, 4, 'Pantalón Palazzo Sastrero', 'Negro', 'M', 46900, 23200, 1),
  (1064, 1, 'Campera de Cuero', 'Negro', 'XL', 89900, 45000, 2),
  (1064, 10, 'Musculosa con Tachas', 'Verde', 'S', 26900, 13000, 1),
  (1065, 18, 'Vestido Tul Estampado', 'Chocolate', 'XS', 61900, 30500, 2),
  (1066, 5, 'Pollera Mini Cuero', 'Negro', 'S', 34900, 17000, 1),
  (1066, 6, 'Pollera Short Crema', 'Beige', 'S', 29900, 14500, 1),
  (1066, 12, 'Top Halter Chocolate', 'Chocolate', 'XL', 28900, 14000, 1),
  (1067, 12, 'Top Halter Chocolate', 'Chocolate', 'L', 28900, 14000, 1),
  (1067, 4, 'Pantalón Palazzo Sastrero', 'Negro', 'XL', 46900, 23200, 1),
  (1067, 2, 'Jean Wide Leg', 'Azul jean', 'L', 52900, 26000, 1),
  (1068, 14, 'Short Crema', 'Beige', 'XS', 27900, 13400, 1),
  (1068, 18, 'Vestido Tul Estampado', 'Chocolate', 'XS', 61900, 30500, 1),
  (1068, 13, 'Short Chocolate', 'Chocolate', 'XL', 27900, 13400, 2),
  (1069, 1, 'Campera de Cuero', 'Chocolate', 'XS', 89900, 45000, 1),
  (1069, 8, 'Remera Tejida Crema', 'Negro', 'S', 24900, 12000, 1),
  (1070, 5, 'Pollera Mini Cuero', 'Chocolate', 'M', 34900, 17000, 1),
  (1070, 7, 'Remera Rib con Vivos', 'Azul jean', 'M', 21900, 10500, 1),
  (1071, 10, 'Musculosa con Tachas', 'Verde', 'XS', 26900, 13000, 1),
  (1072, 18, 'Vestido Tul Estampado', 'Bordó', 'S', 61900, 30500, 1),
  (1072, 3, 'Jean Franja Gris', 'Gris', 'XS', 49900, 24500, 2),
  (1073, 14, 'Short Crema', 'Beige', 'S', 27900, 13400, 1),
  (1074, 1, 'Campera de Cuero', 'Negro', 'M', 89900, 45000, 1),
  (1074, 3, 'Jean Franja Gris', 'Gris', 'L', 49900, 24500, 1),
  (1075, 9, 'Remera Lavada Gris', 'Gris', 'XL', 23900, 11500, 2),
  (1075, 17, 'Vestido Largo Estampado', 'Negro', 'S', 58900, 29000, 1),
  (1076, 17, 'Vestido Largo Estampado', 'Negro', 'L', 58900, 29000, 1),
  (1076, 10, 'Musculosa con Tachas', 'Beige', 'S', 26900, 13000, 1),
  (1077, 17, 'Vestido Largo Estampado', 'Negro', 'M', 58900, 29000, 2),
  (1077, 3, 'Jean Franja Gris', 'Gris', 'S', 49900, 24500, 2),
  (1078, 13, 'Short Chocolate', 'Chocolate', 'XS', 27900, 13400, 1),
  (1078, 11, 'Top Halter con Broche', 'Chocolate', 'XS', 27900, 13500, 1),
  (1079, 9, 'Remera Lavada Gris', 'Gris', 'L', 23900, 11500, 2),
  (1080, 4, 'Pantalón Palazzo Sastrero', 'Beige', 'M', 46900, 23200, 1);

ALTER TABLE pedidos AUTO_INCREMENT = 1081;

-- ── Notificaciones para el admin (las 2 compras más recientes, sin leer) ──
INSERT INTO notificaciones (tipo, titulo, mensaje, url, pedido_id, leida, creado_en)
SELECT 'pedido',
       CONCAT('Nueva compra #', id),
       CONCAT(cliente, ' · $', FORMAT(total, 2, 'es_AR')),
       CONCAT('/admin/pedidos?q=', id),
       id, 0, creado_en
  FROM pedidos
 ORDER BY creado_en DESC
 LIMIT 2;
