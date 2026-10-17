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
  (1, 'Blusas', 'blusas', 1),
  (2, 'Tops', 'tops', 2),
  (3, 'Buzos', 'buzos', 3),
  (4, 'Pantalones', 'pantalones', 4),
  (5, 'Vestidos', 'vestidos', 5);

-- Subcategorías: los filtros propios de cada sección
INSERT INTO subcategorias (id, categoria_id, nombre, slug, orden) VALUES
  (1, 1, 'Camisas', 'camisas', 1),
  (2, 4, 'Rectos', 'rectos', 1),
  (3, 4, 'Cargo', 'cargo', 2),
  (4, 4, 'Sastreros', 'sastreros', 3),
  (5, 5, 'Cortos', 'cortos', 1);

INSERT INTO colores (id, valor, nombre, hex, orden) VALUES
  (1, 'rosa', 'Rosa', '#e9a3b9', 1),
  (2, 'negro', 'Negro', '#1f1a1c', 2),
  (3, 'beige', 'Beige', '#d8c3aa', 3),
  (4, 'blanco', 'Blanco', '#f6f1ec', 4),
  (5, 'marron', 'Marrón', '#6b4234', 5),
  (6, 'violeta', 'Violeta', '#7a2a9a', 6),
  (7, 'coral', 'Coral', '#f0714f', 7),
  (8, 'verde-oliva', 'Verde oliva', '#8a8052', 8),
  (9, 'amarillo', 'Amarillo', '#f2b21c', 9),
  (10, 'gris', 'Gris', '#b9bdb8', 10);

-- ── Productos (imágenes en public/img/productos) ────────
INSERT INTO productos (id, nombre, categoria_id, subcategoria_id, color_id, precio, costo, stock, talles, etiqueta, resumen, descripcion, destacados) VALUES
  (1, 'Camisa Oversize Rosa', 1, 1, 1, 34900, 17500, 14, 'S,M,L,XL', 'Más elegido', 'Camisa oversize rosa pastel de tela suave, con estampa en la espalda. Se usa abierta o abotonada.', 'Una camisa de calce amplio que va con todo: abierta sobre una remera, abotonada con jean o como abrigo liviano.

Tela suave de buena caída, puños abotonados y una estampa delicada en la espalda.', 'Calce oversize cómodo
Estampa en la espalda
Puños abotonados'),
  (2, 'Top Deportivo Coral', 2, NULL, 7, 24900, 12100, 20, 'XS,S,M,L,XL', 'Nuevo', 'Top deportivo de espalda cruzada, con banda elástica contrastante. Sostén medio y mucha comodidad.', 'Un top pensado para entrenar y para todos los días: espalda con diseño abierto, tela elástica que no marca y banda inferior contrastante.

Combina con el short o la calza que quieras.', 'Espalda con diseño abierto
Banda elástica contrastante
Tela elástica de secado rápido'),
  (3, 'Remera Crop Blanca', 2, NULL, 4, 18900, 8900, 30, 'XS,S,M,L,XL', 'Más elegido', 'Remera crop de cuello alto y manga corta. Un básico para combinar con jean o pantalón de vestir.', 'Remera corta de cuello alto, tela canalé suave y elástica que se adapta al cuerpo sin apretar.

Con tiro alto queda perfecta; también sola o debajo de un buzo.', 'Cuello alto
Tela elástica
Largo crop'),
  (4, 'Chaleco Crochet', 2, NULL, 3, 39900, 19800, 9, 'S,M,L,XL', 'Nuevo', 'Chaleco tejido al crochet con puntilla calada. Una pieza artesanal para dar carácter a cualquier look.', 'Un chaleco tejido con diseño calado que se luce sobre camisas, remeras o vestidos.

Su tejido liviano lo hace ideal para entretiempo.', 'Tejido calado estilo crochet
Liviano y fresco
Combina con camisas y remeras'),
  (5, 'Buzo Violeta', 3, NULL, 6, 42900, 21400, 16, 'XS,S,M,L,XL', 'Más elegido', 'Buzo con capucha violeta, de friza suave y bolsillo canguro. Abrigado y súper cómodo.', 'El buzo que no querés sacarte: capucha con cordón, bolsillo canguro y puño elastizado.

Su color violeta intenso le da un toque distinto a cualquier outfit.', 'Capucha con cordón
Bolsillo canguro
Friza suave por dentro'),
  (6, 'Buzo Crop Negro', 3, NULL, 2, 44900, 22300, 11, 'XS,S,M,L,XL', 'Oferta', 'Buzo corto con capucha en negro, con estampa al frente. Ideal con jeans de tiro alto.', 'Buzo de largo crop con capucha y estampa llamativa. Combina muy bien con pantalones de tiro alto.

De friza gruesa, abrigado y con mucha onda.', 'Largo crop
Capucha con cordón
Estampa frontal'),
  (7, 'Pantalón Cargo Verde Oliva', 4, 3, 8, 46900, 23400, 13, 'XS,S,M,L,XL', 'Más elegido', 'Pantalón cargo de gabardina verde oliva, tiro medio y pierna amplia con bolsillos.', 'Un pantalón de gabardina resistente con calce amplio y bolsillos laterales. Cómodo y con mucho estilo.

Combina con zapatillas, botas, blusas y remeras.', 'Gabardina resistente
Pierna amplia
Bolsillos laterales'),
  (8, 'Pantalón Recto Marrón', 4, 2, 5, 43900, 21900, 12, 'XS,S,M,L,XL', 'Nuevo', 'Pantalón de pierna recta color chocolate, con detalle en la cintura. Un clásico renovado.', 'Pantalón de gabardina con tiro alto y pierna recta que estiliza. El color chocolate se combina con todo.

Se luce con camisas, tejidos y zapatillas.', 'Pierna recta
Tiro alto
Detalle en la cintura'),
  (9, 'Pantalón Gris Perla', 4, 4, 10, 41900, 20900, 8, 'XS,S,M,L,XL', 'Oferta', 'Pantalón de tela liviana color gris perla, de línea recta y cintura con cierre.', 'Un pantalón de vestir informal, de tela liviana y calce relajado. Perfecto para la oficina o para el día a día.

El gris perla suma luz y combina con todo.', 'Tela liviana
Línea recta
Cierre y botón'),
  (10, 'Vestido Amarillo', 5, 5, 9, 32900, 16400, 15, 'XS,S,M,L,XL', 'Más elegido', 'Vestido corto amarillo con breteles anchos y espalda descubierta. Fresco para todo el verano.', 'Un vestido simple, liviano y favorecedor: breteles anchos, escote cuadrado y falda ligeramente acampanada.

Con zapatillas o sandalias, siempre queda bien.', 'Breteles anchos
Falda acampanada
Color amarillo vibrante');

-- Colores en que se vende cada producto (el primero es el principal)
INSERT INTO producto_colores (producto_id, color_id, orden) VALUES
  (1, 1, 0),
  (1, 4, 1),
  (2, 7, 0),
  (3, 4, 0),
  (3, 2, 1),
  (4, 3, 0),
  (4, 5, 1),
  (5, 6, 0),
  (6, 2, 0),
  (7, 8, 0),
  (8, 5, 0),
  (9, 10, 0),
  (10, 9, 0);

INSERT INTO producto_imagenes (producto_id, ruta, orden) VALUES
  (1, '/img/productos/camisa-rosa-1.webp', 0),
  (1, '/img/productos/camisa-rosa-2.webp', 1),
  (2, '/img/productos/top-coral-1.webp', 0),
  (2, '/img/productos/top-coral-2.webp', 1),
  (2, '/img/productos/top-coral-3.webp', 2),
  (2, '/img/productos/top-coral-4.webp', 3),
  (3, '/img/productos/remera-crop-1.webp', 0),
  (3, '/img/productos/remera-crop-2.webp', 1),
  (4, '/img/productos/chaleco-crochet-1.webp', 0),
  (4, '/img/productos/chaleco-crochet-2.webp', 1),
  (4, '/img/productos/chaleco-crochet-3.webp', 2),
  (5, '/img/productos/buzo-violeta-1.webp', 0),
  (5, '/img/productos/buzo-violeta-2.webp', 1),
  (6, '/img/productos/buzo-crop-negro-1.webp', 0),
  (7, '/img/productos/pantalon-cargo-1.webp', 0),
  (7, '/img/productos/pantalon-cargo-2.webp', 1),
  (7, '/img/productos/pantalon-cargo-3.webp', 2),
  (7, '/img/productos/pantalon-cargo-4.webp', 3),
  (8, '/img/productos/pantalon-marron-1.webp', 0),
  (8, '/img/productos/pantalon-marron-2.webp', 1),
  (9, '/img/productos/pantalon-gris-1.webp', 0),
  (10, '/img/productos/vestido-amarillo-1.webp', 0),
  (10, '/img/productos/vestido-amarillo-2.webp', 1);

-- ── Ficha técnica de cada producto ──────────────────────
INSERT INTO especificaciones (producto_id, clave, valor, orden) VALUES
  (1, 'Composición', '100% algodón', 1),
  (1, 'Calce', 'Oversize', 2),
  (1, 'Largo', 'Cadera', 3),
  (1, 'Cuidado', 'Lavar en ciclo delicado', 4),
  (2, 'Composición', '88% poliéster · 12% elastano', 1),
  (2, 'Calce', 'Ajustado', 2),
  (2, 'Sostén', 'Medio', 3),
  (2, 'Cuidado', 'Lavar en agua fría', 4),
  (3, 'Composición', '95% algodón · 5% elastano', 1),
  (3, 'Calce', 'Ajustado', 2),
  (3, 'Largo', 'Crop', 3),
  (3, 'Cuidado', 'Lavar con colores similares', 4),
  (4, 'Composición', '100% algodón', 1),
  (4, 'Calce', 'Regular', 2),
  (4, 'Largo', 'Cintura', 3),
  (4, 'Cuidado', 'Lavar a mano', 4),
  (5, 'Composición', '80% algodón · 20% poliéster', 1),
  (5, 'Calce', 'Regular', 2),
  (5, 'Largo', 'Cadera', 3),
  (5, 'Cuidado', 'Lavar del revés en agua fría', 4),
  (6, 'Composición', '80% algodón · 20% poliéster', 1),
  (6, 'Calce', 'Regular', 2),
  (6, 'Largo', 'Crop', 3),
  (6, 'Cuidado', 'Lavar del revés en agua fría', 4),
  (7, 'Composición', '98% algodón · 2% elastano', 1),
  (7, 'Calce', 'Amplio', 2),
  (7, 'Tiro', 'Medio', 3),
  (7, 'Cuidado', 'Lavar del revés en agua fría', 4),
  (8, 'Composición', '98% algodón · 2% elastano', 1),
  (8, 'Calce', 'Recto', 2),
  (8, 'Tiro', 'Alto', 3),
  (8, 'Cuidado', 'Lavar del revés en agua fría', 4),
  (9, 'Composición', '70% algodón · 30% lino', 1),
  (9, 'Calce', 'Recto', 2),
  (9, 'Tiro', 'Medio', 3),
  (9, 'Cuidado', 'Lavar en ciclo delicado', 4),
  (10, 'Composición', '95% algodón · 5% elastano', 1),
  (10, 'Calce', 'Regular', 2),
  (10, 'Largo', 'Corto', 3),
  (10, 'Cuidado', 'Lavar en ciclo delicado', 4);

-- ── Cupones ─────────────────────────────────────────────
INSERT INTO cupones (codigo, descripcion, porcentaje, activo, vence_en) VALUES
  ('BIENVENIDA', '10% off en tu primera compra', 0.1000, 1, NULL),
  ('MAQUETA5', '5% off de prueba', 0.0500, 1, NULL),
  ('VERANO20', '20% off de temporada (vencido)', 0.2000, 1, CURDATE() - INTERVAL 10 DAY);

-- ── Favoritos del cliente demo ──────────────────────────
INSERT INTO favoritos (usuario_id, producto_id) VALUES
  (1, 1),
  (1, 7),
  (1, 10);

-- ── Pedidos de los últimos 30 días (80) ─────────────────
INSERT INTO pedidos (id, usuario_id, cliente, email, telefono, entrega, calle, altura, piso, codigo_postal, ciudad, provincia, medio_pago, estado, subtotal, descuento, envio, total, costo, ganancia, creado_en) VALUES
  (1001, NULL, 'Lucía Fernández', 'lucia.fernandez@mail.com', '11 47926919', 'domicilio', 'Av. Siempre Viva', '2176', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'cancelado', 79800, 0, 0, 79800, 39800, 40000, TIMESTAMP(CURDATE() - INTERVAL 29 DAY, '18:17:00')),
  (1002, NULL, 'Valentina López', 'valentina.lopez@mail.com', '11 47934838', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 120700, 12070, 0, 108630, 60300, 48330, TIMESTAMP(CURDATE() - INTERVAL 29 DAY, '20:45:00')),
  (1003, 1, 'Cliente Demo', 'demo@tienda.com', '11 47942757', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 108700, 0, 0, 108700, 53700, 55000, TIMESTAMP(CURDATE() - INTERVAL 29 DAY, '14:32:00')),
  (1004, NULL, 'Martín Gómez', 'martin.gomez@mail.com', '11 47950676', 'domicilio', 'Av. Siempre Viva', '1863', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 105600, 0, 0, 105600, 51700, 53900, TIMESTAMP(CURDATE() - INTERVAL 28 DAY, '18:13:00')),
  (1005, 1, 'Cliente Demo', 'demo@tienda.com', '11 47958595', 'domicilio', 'Av. Siempre Viva', '890', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'entregado', 24900, 0, 4500, 29400, 12100, 12800, TIMESTAMP(CURDATE() - INTERVAL 28 DAY, '19:45:00')),
  (1006, NULL, 'Sofía Rodríguez', 'sofia.rodriguez@mail.com', '11 47966514', 'domicilio', 'Av. Siempre Viva', '909', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 18900, 0, 4500, 23400, 8900, 10000, TIMESTAMP(CURDATE() - INTERVAL 28 DAY, '11:09:00')),
  (1007, NULL, 'Micaela Ortiz', 'micaela.ortiz@mail.com', '11 47974433', 'domicilio', 'Av. Siempre Viva', '671', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'entregado', 112700, 0, 0, 112700, 55700, 57000, TIMESTAMP(CURDATE() - INTERVAL 27 DAY, '20:12:00')),
  (1008, NULL, 'Facundo Ruiz', 'facundo.ruiz@mail.com', '11 47982352', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 133700, 0, 0, 133700, 66700, 67000, TIMESTAMP(CURDATE() - INTERVAL 27 DAY, '15:15:00')),
  (1009, 1, 'Cliente Demo', 'demo@tienda.com', '11 47990271', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 81800, 0, 0, 81800, 40900, 40900, TIMESTAMP(CURDATE() - INTERVAL 26 DAY, '19:03:00')),
  (1010, NULL, 'Mateo Sánchez', 'mateo.sanchez@mail.com', '11 47998190', 'domicilio', 'Av. Siempre Viva', '2130', NULL, '5500', 'Mendoza', 'Mendoza', 'tarjeta', 'entregado', 124700, 0, 0, 124700, 62300, 62400, TIMESTAMP(CURDATE() - INTERVAL 26 DAY, '11:12:00')),
  (1011, NULL, 'Santiago Morales', 'santiago.morales@mail.com', '11 48006109', 'domicilio', 'Av. Siempre Viva', '1454', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'entregado', 105700, 0, 0, 105700, 52600, 53100, TIMESTAMP(CURDATE() - INTERVAL 25 DAY, '16:31:00')),
  (1012, 1, 'Cliente Demo', 'demo@tienda.com', '11 48014028', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 18900, 1890, 0, 17010, 8900, 8110, TIMESTAMP(CURDATE() - INTERVAL 25 DAY, '10:15:00')),
  (1013, NULL, 'Juan Pérez', 'juan.perez@mail.com', '11 48021947', 'domicilio', 'Av. Siempre Viva', '744', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'cancelado', 132700, 0, 0, 132700, 66200, 66500, TIMESTAMP(CURDATE() - INTERVAL 25 DAY, '10:50:00')),
  (1014, NULL, 'Agustina Torres', 'agustina.torres@mail.com', '11 48029866', 'domicilio', 'Av. Siempre Viva', '1392', NULL, '5000', 'Córdoba', 'Córdoba', 'transferencia', 'entregado', 131600, 13160, 0, 118440, 64600, 53840, TIMESTAMP(CURDATE() - INTERVAL 24 DAY, '18:51:00')),
  (1015, NULL, 'Camila Martínez', 'camila.martinez@mail.com', '11 48037785', 'domicilio', 'Av. Siempre Viva', '1329', NULL, '5500', 'Mendoza', 'Mendoza', 'tarjeta', 'cancelado', 18900, 0, 4500, 23400, 8900, 10000, TIMESTAMP(CURDATE() - INTERVAL 24 DAY, '20:38:00')),
  (1016, NULL, 'Mateo Sánchez', 'mateo.sanchez@mail.com', '11 48045704', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 18900, 0, 0, 18900, 8900, 10000, TIMESTAMP(CURDATE() - INTERVAL 24 DAY, '18:10:00')),
  (1017, NULL, 'Lucía Fernández', 'lucia.fernandez@mail.com', '11 48053623', 'domicilio', 'Av. Siempre Viva', '3733', NULL, '5000', 'Córdoba', 'Córdoba', 'transferencia', 'entregado', 84700, 8470, 0, 76230, 41700, 34530, TIMESTAMP(CURDATE() - INTERVAL 24 DAY, '16:35:00')),
  (1018, NULL, 'Lucía Fernández', 'lucia.fernandez@mail.com', '11 48061542', 'domicilio', 'Av. Siempre Viva', '2892', NULL, '5500', 'Mendoza', 'Mendoza', 'tarjeta', 'entregado', 18900, 0, 4500, 23400, 8900, 10000, TIMESTAMP(CURDATE() - INTERVAL 23 DAY, '12:57:00')),
  (1019, NULL, 'Martín Gómez', 'martin.gomez@mail.com', '11 48069461', 'domicilio', 'Av. Siempre Viva', '1261', NULL, '2000', 'Rosario', 'Santa Fe', 'transferencia', 'entregado', 150600, 15060, 0, 135540, 75100, 60440, TIMESTAMP(CURDATE() - INTERVAL 23 DAY, '19:11:00')),
  (1020, NULL, 'Camila Martínez', 'camila.martinez@mail.com', '11 48077380', 'domicilio', 'Av. Siempre Viva', '3374', NULL, '1900', 'La Plata', 'Buenos Aires', 'transferencia', 'entregado', 164500, 16450, 0, 148050, 81000, 67050, TIMESTAMP(CURDATE() - INTERVAL 23 DAY, '16:43:00')),
  (1021, NULL, 'Facundo Ruiz', 'facundo.ruiz@mail.com', '11 48085299', 'domicilio', 'Av. Siempre Viva', '2640', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'entregado', 46900, 0, 4500, 51400, 23400, 23500, TIMESTAMP(CURDATE() - INTERVAL 23 DAY, '19:32:00')),
  (1022, NULL, 'Lucía Fernández', 'lucia.fernandez@mail.com', '11 48093218', 'domicilio', 'Av. Siempre Viva', '756', NULL, '2000', 'Rosario', 'Santa Fe', 'transferencia', 'entregado', 34900, 3490, 4500, 35910, 17500, 13910, TIMESTAMP(CURDATE() - INTERVAL 22 DAY, '18:29:00')),
  (1023, 1, 'Cliente Demo', 'demo@tienda.com', '11 48101137', 'domicilio', 'Av. Siempre Viva', '1274', NULL, '2000', 'Rosario', 'Santa Fe', 'transferencia', 'entregado', 77800, 7780, 0, 70020, 38900, 31120, TIMESTAMP(CURDATE() - INTERVAL 22 DAY, '14:33:00')),
  (1024, NULL, 'Juan Pérez', 'juan.perez@mail.com', '11 48109056', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 76800, 7680, 0, 69120, 38400, 30720, TIMESTAMP(CURDATE() - INTERVAL 21 DAY, '11:07:00')),
  (1025, NULL, 'Valentina López', 'valentina.lopez@mail.com', '11 48116975', 'domicilio', 'Av. Siempre Viva', '2689', NULL, '2000', 'Rosario', 'Santa Fe', 'tarjeta', 'entregado', 32900, 0, 4500, 37400, 16400, 16500, TIMESTAMP(CURDATE() - INTERVAL 21 DAY, '13:26:00')),
  (1026, NULL, 'Camila Martínez', 'camila.martinez@mail.com', '11 48124894', 'domicilio', 'Av. Siempre Viva', '1262', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'transferencia', 'entregado', 42900, 4290, 4500, 43110, 21400, 17210, TIMESTAMP(CURDATE() - INTERVAL 21 DAY, '09:10:00')),
  (1027, 1, 'Cliente Demo', 'demo@tienda.com', '11 48132813', 'domicilio', 'Av. Siempre Viva', '2485', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 42900, 0, 4500, 47400, 21400, 21500, TIMESTAMP(CURDATE() - INTERVAL 20 DAY, '15:23:00')),
  (1028, NULL, 'Martín Gómez', 'martin.gomez@mail.com', '11 48140732', 'domicilio', 'Av. Siempre Viva', '2894', NULL, '5500', 'Mendoza', 'Mendoza', 'tarjeta', 'entregado', 46900, 0, 4500, 51400, 23400, 23500, TIMESTAMP(CURDATE() - INTERVAL 20 DAY, '14:12:00')),
  (1029, NULL, 'Florencia Castro', 'florencia.castro@mail.com', '11 48148651', 'domicilio', 'Av. Siempre Viva', '3731', NULL, '2000', 'Rosario', 'Santa Fe', 'tarjeta', 'entregado', 42900, 0, 4500, 47400, 21400, 21500, TIMESTAMP(CURDATE() - INTERVAL 20 DAY, '19:54:00')),
  (1030, NULL, 'Martín Gómez', 'martin.gomez@mail.com', '11 48156570', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 155600, 15560, 0, 140040, 77800, 62240, TIMESTAMP(CURDATE() - INTERVAL 19 DAY, '14:25:00')),
  (1031, NULL, 'Sofía Rodríguez', 'sofia.rodriguez@mail.com', '11 48164489', 'domicilio', 'Av. Siempre Viva', '830', NULL, '5500', 'Mendoza', 'Mendoza', 'tarjeta', 'entregado', 62800, 0, 0, 62800, 30800, 32000, TIMESTAMP(CURDATE() - INTERVAL 19 DAY, '20:25:00')),
  (1032, NULL, 'Martín Gómez', 'martin.gomez@mail.com', '11 48172408', 'domicilio', 'Av. Siempre Viva', '3091', NULL, '2000', 'Rosario', 'Santa Fe', 'transferencia', 'entregado', 85800, 8580, 0, 77220, 42800, 34420, TIMESTAMP(CURDATE() - INTERVAL 19 DAY, '17:44:00')),
  (1033, NULL, 'Juan Pérez', 'juan.perez@mail.com', '11 48180327', 'domicilio', 'Av. Siempre Viva', '2203', NULL, '5000', 'Córdoba', 'Córdoba', 'transferencia', 'entregado', 18900, 1890, 4500, 21510, 8900, 8110, TIMESTAMP(CURDATE() - INTERVAL 19 DAY, '13:14:00')),
  (1034, NULL, 'Mateo Sánchez', 'mateo.sanchez@mail.com', '11 48188246', 'domicilio', 'Av. Siempre Viva', '1294', NULL, '2000', 'Rosario', 'Santa Fe', 'transferencia', 'entregado', 46900, 4690, 4500, 46710, 23400, 18810, TIMESTAMP(CURDATE() - INTERVAL 18 DAY, '16:28:00')),
  (1035, NULL, 'Micaela Ortiz', 'micaela.ortiz@mail.com', '11 48196165', 'domicilio', 'Av. Siempre Viva', '222', NULL, '1900', 'La Plata', 'Buenos Aires', 'tarjeta', 'entregado', 60800, 0, 0, 60800, 29800, 31000, TIMESTAMP(CURDATE() - INTERVAL 18 DAY, '13:44:00')),
  (1036, NULL, 'Micaela Ortiz', 'micaela.ortiz@mail.com', '11 48204084', 'domicilio', 'Av. Siempre Viva', '3865', NULL, '5500', 'Mendoza', 'Mendoza', 'transferencia', 'entregado', 46900, 4690, 4500, 46710, 23400, 18810, TIMESTAMP(CURDATE() - INTERVAL 18 DAY, '10:51:00')),
  (1037, 1, 'Cliente Demo', 'demo@tienda.com', '11 48212003', 'domicilio', 'Av. Siempre Viva', '2112', NULL, '1900', 'La Plata', 'Buenos Aires', 'tarjeta', 'entregado', 126700, 0, 0, 126700, 63200, 63500, TIMESTAMP(CURDATE() - INTERVAL 17 DAY, '12:25:00')),
  (1038, NULL, 'Nicolás Álvarez', 'nicolas.alvarez@mail.com', '11 48219922', 'domicilio', 'Av. Siempre Viva', '395', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 110700, 0, 0, 110700, 55300, 55400, TIMESTAMP(CURDATE() - INTERVAL 17 DAY, '15:18:00')),
  (1039, NULL, 'Tomás Díaz', 'tomas.diaz@mail.com', '11 48227841', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 18900, 1890, 0, 17010, 8900, 8110, TIMESTAMP(CURDATE() - INTERVAL 16 DAY, '10:21:00')),
  (1040, NULL, 'Mateo Sánchez', 'mateo.sanchez@mail.com', '11 48235760', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 104700, 0, 0, 104700, 51700, 53000, TIMESTAMP(CURDATE() - INTERVAL 16 DAY, '16:25:00')),
  (1041, NULL, 'Mateo Sánchez', 'mateo.sanchez@mail.com', '11 48243679', 'domicilio', 'Av. Siempre Viva', '3466', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 89800, 0, 0, 89800, 44800, 45000, TIMESTAMP(CURDATE() - INTERVAL 15 DAY, '10:22:00')),
  (1042, NULL, 'Santiago Morales', 'santiago.morales@mail.com', '11 48251598', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 24900, 0, 0, 24900, 12100, 12800, TIMESTAMP(CURDATE() - INTERVAL 15 DAY, '14:17:00')),
  (1043, NULL, 'Martín Gómez', 'martin.gomez@mail.com', '11 48259517', 'domicilio', 'Av. Siempre Viva', '2392', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'entregado', 117700, 0, 0, 117700, 58700, 59000, TIMESTAMP(CURDATE() - INTERVAL 14 DAY, '17:40:00')),
  (1044, NULL, 'Micaela Ortiz', 'micaela.ortiz@mail.com', '11 48267436', 'domicilio', 'Av. Siempre Viva', '3603', NULL, '5000', 'Córdoba', 'Córdoba', 'transferencia', 'entregado', 41900, 4190, 4500, 42210, 20900, 16810, TIMESTAMP(CURDATE() - INTERVAL 14 DAY, '17:59:00')),
  (1045, NULL, 'Tomás Díaz', 'tomas.diaz@mail.com', '11 48275355', 'domicilio', 'Av. Siempre Viva', '873', NULL, '2000', 'Rosario', 'Santa Fe', 'tarjeta', 'entregado', 105700, 0, 0, 105700, 52100, 53600, TIMESTAMP(CURDATE() - INTERVAL 14 DAY, '18:33:00')),
  (1046, NULL, 'Lucía Fernández', 'lucia.fernandez@mail.com', '11 48283274', 'domicilio', 'Av. Siempre Viva', '2214', NULL, '5000', 'Córdoba', 'Córdoba', 'transferencia', 'entregado', 164600, 16460, 0, 148140, 82200, 65940, TIMESTAMP(CURDATE() - INTERVAL 14 DAY, '10:21:00')),
  (1047, NULL, 'Sofía Rodríguez', 'sofia.rodriguez@mail.com', '11 48291193', 'domicilio', 'Av. Siempre Viva', '3811', NULL, '5000', 'Córdoba', 'Córdoba', 'transferencia', 'entregado', 102700, 10270, 0, 92430, 51400, 41030, TIMESTAMP(CURDATE() - INTERVAL 13 DAY, '14:48:00')),
  (1048, NULL, 'Agustina Torres', 'agustina.torres@mail.com', '11 48299112', 'domicilio', 'Av. Siempre Viva', '430', NULL, '1900', 'La Plata', 'Buenos Aires', 'transferencia', 'entregado', 32900, 3290, 4500, 34110, 16400, 13210, TIMESTAMP(CURDATE() - INTERVAL 13 DAY, '10:05:00')),
  (1049, NULL, 'Agustina Torres', 'agustina.torres@mail.com', '11 48307031', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 84800, 0, 0, 84800, 42300, 42500, TIMESTAMP(CURDATE() - INTERVAL 13 DAY, '12:19:00')),
  (1050, 1, 'Cliente Demo', 'demo@tienda.com', '11 48314950', 'domicilio', 'Av. Siempre Viva', '1184', NULL, '5500', 'Mendoza', 'Mendoza', 'tarjeta', 'cancelado', 42900, 0, 4500, 47400, 21400, 21500, TIMESTAMP(CURDATE() - INTERVAL 12 DAY, '11:06:00')),
  (1051, NULL, 'Nicolás Álvarez', 'nicolas.alvarez@mail.com', '11 48322869', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 37800, 0, 0, 37800, 17800, 20000, TIMESTAMP(CURDATE() - INTERVAL 12 DAY, '17:32:00')),
  (1052, NULL, 'Agustina Torres', 'agustina.torres@mail.com', '11 48330788', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 112700, 11270, 0, 101430, 55700, 45730, TIMESTAMP(CURDATE() - INTERVAL 11 DAY, '12:14:00')),
  (1053, NULL, 'Florencia Castro', 'florencia.castro@mail.com', '11 48338707', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 132700, 13270, 0, 119430, 66000, 53430, TIMESTAMP(CURDATE() - INTERVAL 11 DAY, '16:16:00')),
  (1054, NULL, 'Juan Pérez', 'juan.perez@mail.com', '11 48346626', 'domicilio', 'Av. Siempre Viva', '1347', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'entregado', 109700, 0, 0, 109700, 54700, 55000, TIMESTAMP(CURDATE() - INTERVAL 11 DAY, '18:07:00')),
  (1055, NULL, 'Lucía Fernández', 'lucia.fernandez@mail.com', '11 48354545', 'domicilio', 'Av. Siempre Viva', '965', NULL, '1900', 'La Plata', 'Buenos Aires', 'tarjeta', 'entregado', 34900, 0, 4500, 39400, 17500, 17400, TIMESTAMP(CURDATE() - INTERVAL 10 DAY, '18:05:00')),
  (1056, NULL, 'Mateo Sánchez', 'mateo.sanchez@mail.com', '11 48362464', 'domicilio', 'Av. Siempre Viva', '136', NULL, '2000', 'Rosario', 'Santa Fe', 'transferencia', 'entregado', 42900, 4290, 4500, 43110, 21400, 17210, TIMESTAMP(CURDATE() - INTERVAL 10 DAY, '15:23:00')),
  (1057, NULL, 'Sofía Rodríguez', 'sofia.rodriguez@mail.com', '11 48370383', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 59800, 0, 0, 59800, 29600, 30200, TIMESTAMP(CURDATE() - INTERVAL 10 DAY, '18:22:00')),
  (1058, NULL, 'Facundo Ruiz', 'facundo.ruiz@mail.com', '11 48378302', 'domicilio', 'Av. Siempre Viva', '3203', NULL, '2000', 'Rosario', 'Santa Fe', 'tarjeta', 'entregado', 81800, 0, 0, 81800, 40900, 40900, TIMESTAMP(CURDATE() - INTERVAL 9 DAY, '15:31:00')),
  (1059, NULL, 'Agustina Torres', 'agustina.torres@mail.com', '11 48386221', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 131600, 0, 0, 131600, 65100, 66500, TIMESTAMP(CURDATE() - INTERVAL 9 DAY, '20:51:00')),
  (1060, 1, 'Cliente Demo', 'demo@tienda.com', '11 48394140', 'domicilio', 'Av. Siempre Viva', '1414', NULL, '1900', 'La Plata', 'Buenos Aires', 'tarjeta', 'entregado', 46900, 0, 4500, 51400, 23400, 23500, TIMESTAMP(CURDATE() - INTERVAL 9 DAY, '15:36:00')),
  (1061, NULL, 'Martín Gómez', 'martin.gomez@mail.com', '11 48402059', 'domicilio', 'Av. Siempre Viva', '1449', NULL, '2000', 'Rosario', 'Santa Fe', 'tarjeta', 'entregado', 34900, 0, 4500, 39400, 17500, 17400, TIMESTAMP(CURDATE() - INTERVAL 9 DAY, '16:58:00')),
  (1062, 1, 'Cliente Demo', 'demo@tienda.com', '11 48409978', 'domicilio', 'Av. Siempre Viva', '644', NULL, '2000', 'Rosario', 'Santa Fe', 'transferencia', 'entregado', 69800, 6980, 0, 62820, 34400, 28420, TIMESTAMP(CURDATE() - INTERVAL 8 DAY, '15:07:00')),
  (1063, NULL, 'Florencia Castro', 'florencia.castro@mail.com', '11 48417897', 'domicilio', 'Av. Siempre Viva', '2733', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'cancelado', 112700, 0, 0, 112700, 55700, 57000, TIMESTAMP(CURDATE() - INTERVAL 8 DAY, '20:56:00')),
  (1064, NULL, 'Florencia Castro', 'florencia.castro@mail.com', '11 48425816', 'domicilio', 'Av. Siempre Viva', '866', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'transferencia', 'entregado', 120700, 12070, 0, 108630, 60300, 48330, TIMESTAMP(CURDATE() - INTERVAL 8 DAY, '14:47:00')),
  (1065, 1, 'Cliente Demo', 'demo@tienda.com', '11 48433735', 'domicilio', 'Av. Siempre Viva', '3642', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'entregado', 18900, 0, 4500, 23400, 8900, 10000, TIMESTAMP(CURDATE() - INTERVAL 8 DAY, '15:21:00')),
  (1066, 1, 'Cliente Demo', 'demo@tienda.com', '11 48441654', 'domicilio', 'Av. Siempre Viva', '172', NULL, '5000', 'Córdoba', 'Córdoba', 'transferencia', 'entregado', 81800, 8180, 0, 73620, 40900, 32720, TIMESTAMP(CURDATE() - INTERVAL 7 DAY, '09:45:00')),
  (1067, NULL, 'Micaela Ortiz', 'micaela.ortiz@mail.com', '11 48449573', 'domicilio', 'Av. Siempre Viva', '222', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 18900, 0, 4500, 23400, 8900, 10000, TIMESTAMP(CURDATE() - INTERVAL 7 DAY, '18:04:00')),
  (1068, NULL, 'Agustina Torres', 'agustina.torres@mail.com', '11 48457492', 'domicilio', 'Av. Siempre Viva', '1198', NULL, '2000', 'Rosario', 'Santa Fe', 'tarjeta', 'cancelado', 112700, 0, 0, 112700, 56400, 56300, TIMESTAMP(CURDATE() - INTERVAL 7 DAY, '12:24:00')),
  (1069, NULL, 'Micaela Ortiz', 'micaela.ortiz@mail.com', '11 48465411', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'cancelado', 34900, 0, 0, 34900, 17500, 17400, TIMESTAMP(CURDATE() - INTERVAL 7 DAY, '20:35:00')),
  (1070, NULL, 'Micaela Ortiz', 'micaela.ortiz@mail.com', '11 48473330', 'domicilio', 'Av. Siempre Viva', '3924', NULL, '1900', 'La Plata', 'Buenos Aires', 'tarjeta', 'entregado', 65800, 0, 0, 65800, 32300, 33500, TIMESTAMP(CURDATE() - INTERVAL 6 DAY, '12:51:00')),
  (1071, NULL, 'Facundo Ruiz', 'facundo.ruiz@mail.com', '11 48481249', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 18900, 0, 0, 18900, 8900, 10000, TIMESTAMP(CURDATE() - INTERVAL 6 DAY, '14:53:00')),
  (1072, NULL, 'Mateo Sánchez', 'mateo.sanchez@mail.com', '11 48489168', 'domicilio', 'Av. Siempre Viva', '980', NULL, '2000', 'Rosario', 'Santa Fe', 'tarjeta', 'entregado', 112700, 0, 0, 112700, 56200, 56500, TIMESTAMP(CURDATE() - INTERVAL 6 DAY, '15:36:00')),
  (1073, 1, 'Cliente Demo', 'demo@tienda.com', '11 48497087', 'domicilio', 'Av. Siempre Viva', '1168', NULL, '2000', 'Rosario', 'Santa Fe', 'tarjeta', 'entregado', 157600, 0, 0, 157600, 78800, 78800, TIMESTAMP(CURDATE() - INTERVAL 6 DAY, '10:05:00')),
  (1074, NULL, 'Florencia Castro', 'florencia.castro@mail.com', '11 48505006', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'cancelado', 178600, 0, 0, 178600, 88900, 89700, TIMESTAMP(CURDATE() - INTERVAL 5 DAY, '18:13:00')),
  (1075, NULL, 'Sofía Rodríguez', 'sofia.rodriguez@mail.com', '11 48512925', 'domicilio', 'Av. Siempre Viva', '1579', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 46900, 0, 4500, 51400, 23400, 23500, TIMESTAMP(CURDATE() - INTERVAL 5 DAY, '15:11:00')),
  (1076, NULL, 'Santiago Morales', 'santiago.morales@mail.com', '11 48520844', 'domicilio', 'Av. Siempre Viva', '1765', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 32900, 0, 4500, 37400, 16400, 16500, TIMESTAMP(CURDATE() - INTERVAL 5 DAY, '10:26:00')),
  (1077, NULL, 'Agustina Torres', 'agustina.torres@mail.com', '11 48528763', 'domicilio', 'Av. Siempre Viva', '1417', NULL, '5500', 'Mendoza', 'Mendoza', 'transferencia', 'enviado', 149600, 14960, 0, 134640, 74800, 59840, TIMESTAMP(CURDATE() - INTERVAL 4 DAY, '10:59:00')),
  (1078, NULL, 'Lucía Fernández', 'lucia.fernandez@mail.com', '11 48536682', 'domicilio', 'Av. Siempre Viva', '126', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'enviado', 18900, 0, 4500, 23400, 8900, 10000, TIMESTAMP(CURDATE() - INTERVAL 4 DAY, '19:34:00')),
  (1079, 1, 'Cliente Demo', 'demo@tienda.com', '11 48544601', 'domicilio', 'Av. Siempre Viva', '2306', NULL, '5500', 'Mendoza', 'Mendoza', 'transferencia', 'entregado', 59800, 5980, 4500, 58320, 29600, 24220, TIMESTAMP(CURDATE() - INTERVAL 3 DAY, '12:31:00')),
  (1080, NULL, 'Facundo Ruiz', 'facundo.ruiz@mail.com', '11 48552520', 'domicilio', 'Av. Siempre Viva', '2737', NULL, '5000', 'Córdoba', 'Córdoba', 'transferencia', 'enviado', 75800, 7580, 0, 68220, 37800, 30420, TIMESTAMP(CURDATE() - INTERVAL 3 DAY, '20:13:00'));

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

-- ── Renglones de los pedidos (140) ─────────────────────────
INSERT INTO pedido_items (pedido_id, producto_id, nombre, color, talle, precio, costo, cantidad) VALUES
  (1001, 10, 'Vestido Amarillo', 'Amarillo', 'M', 32900, 16400, 1),
  (1001, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'XS', 46900, 23400, 1),
  (1002, 5, 'Buzo Violeta', 'Violeta', 'S', 42900, 21400, 2),
  (1002, 1, 'Camisa Oversize Rosa', 'Blanco', 'L', 34900, 17500, 1),
  (1003, 3, 'Remera Crop Blanca', 'Negro', 'M', 18900, 8900, 1),
  (1003, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'L', 46900, 23400, 1),
  (1003, 5, 'Buzo Violeta', 'Violeta', 'L', 42900, 21400, 1),
  (1004, 3, 'Remera Crop Blanca', 'Blanco', 'XS', 18900, 8900, 2),
  (1004, 10, 'Vestido Amarillo', 'Amarillo', 'M', 32900, 16400, 1),
  (1004, 1, 'Camisa Oversize Rosa', 'Rosa', 'L', 34900, 17500, 1),
  (1005, 2, 'Top Deportivo Coral', 'Coral', 'S', 24900, 12100, 1),
  (1006, 3, 'Remera Crop Blanca', 'Negro', 'XL', 18900, 8900, 1),
  (1007, 3, 'Remera Crop Blanca', 'Blanco', 'XL', 18900, 8900, 1),
  (1007, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'L', 46900, 23400, 2),
  (1008, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'XS', 46900, 23400, 1),
  (1008, 5, 'Buzo Violeta', 'Violeta', 'XL', 42900, 21400, 1),
  (1008, 8, 'Pantalón Recto Marrón', 'Marrón', 'S', 43900, 21900, 1),
  (1009, 1, 'Camisa Oversize Rosa', 'Blanco', 'S', 34900, 17500, 1),
  (1009, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'XS', 46900, 23400, 1),
  (1010, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'XS', 46900, 23400, 1),
  (1010, 5, 'Buzo Violeta', 'Violeta', 'XL', 42900, 21400, 1),
  (1010, 1, 'Camisa Oversize Rosa', 'Rosa', 'S', 34900, 17500, 1),
  (1011, 4, 'Chaleco Crochet', 'Marrón', 'XL', 39900, 19800, 1),
  (1011, 10, 'Vestido Amarillo', 'Amarillo', 'XS', 32900, 16400, 2),
  (1012, 3, 'Remera Crop Blanca', 'Negro', 'XL', 18900, 8900, 1),
  (1013, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'L', 46900, 23400, 1),
  (1013, 5, 'Buzo Violeta', 'Violeta', 'XS', 42900, 21400, 2),
  (1014, 3, 'Remera Crop Blanca', 'Negro', 'L', 18900, 8900, 2),
  (1014, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'XS', 46900, 23400, 2),
  (1015, 3, 'Remera Crop Blanca', 'Negro', 'XS', 18900, 8900, 1),
  (1016, 3, 'Remera Crop Blanca', 'Negro', 'M', 18900, 8900, 1),
  (1017, 2, 'Top Deportivo Coral', 'Coral', 'XS', 24900, 12100, 2),
  (1017, 1, 'Camisa Oversize Rosa', 'Rosa', 'XL', 34900, 17500, 1),
  (1018, 3, 'Remera Crop Blanca', 'Negro', 'XS', 18900, 8900, 1),
  (1019, 10, 'Vestido Amarillo', 'Amarillo', 'S', 32900, 16400, 2),
  (1019, 5, 'Buzo Violeta', 'Violeta', 'M', 42900, 21400, 1),
  (1019, 9, 'Pantalón Gris Perla', 'Gris', 'XL', 41900, 20900, 1),
  (1020, 10, 'Vestido Amarillo', 'Amarillo', 'S', 32900, 16400, 1),
  (1020, 3, 'Remera Crop Blanca', 'Negro', 'M', 18900, 8900, 2),
  (1020, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'L', 46900, 23400, 2),
  (1021, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'XS', 46900, 23400, 1),
  (1022, 1, 'Camisa Oversize Rosa', 'Rosa', 'M', 34900, 17500, 1),
  (1023, 5, 'Buzo Violeta', 'Violeta', 'S', 42900, 21400, 1),
  (1023, 1, 'Camisa Oversize Rosa', 'Blanco', 'M', 34900, 17500, 1),
  (1024, 1, 'Camisa Oversize Rosa', 'Blanco', 'L', 34900, 17500, 1),
  (1024, 9, 'Pantalón Gris Perla', 'Gris', 'S', 41900, 20900, 1),
  (1025, 10, 'Vestido Amarillo', 'Amarillo', 'XS', 32900, 16400, 1),
  (1026, 5, 'Buzo Violeta', 'Violeta', 'M', 42900, 21400, 1),
  (1027, 5, 'Buzo Violeta', 'Violeta', 'XS', 42900, 21400, 1),
  (1028, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'L', 46900, 23400, 1),
  (1029, 5, 'Buzo Violeta', 'Violeta', 'L', 42900, 21400, 1),
  (1030, 1, 'Camisa Oversize Rosa', 'Rosa', 'M', 34900, 17500, 2),
  (1030, 5, 'Buzo Violeta', 'Violeta', 'L', 42900, 21400, 2),
  (1031, 3, 'Remera Crop Blanca', 'Blanco', 'XS', 18900, 8900, 1),
  (1031, 8, 'Pantalón Recto Marrón', 'Marrón', 'XS', 43900, 21900, 1),
  (1032, 5, 'Buzo Violeta', 'Violeta', 'L', 42900, 21400, 2),
  (1033, 3, 'Remera Crop Blanca', 'Negro', 'XL', 18900, 8900, 1),
  (1034, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'XS', 46900, 23400, 1),
  (1035, 9, 'Pantalón Gris Perla', 'Gris', 'S', 41900, 20900, 1),
  (1035, 3, 'Remera Crop Blanca', 'Blanco', 'L', 18900, 8900, 1),
  (1036, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'XS', 46900, 23400, 1),
  (1037, 10, 'Vestido Amarillo', 'Amarillo', 'XS', 32900, 16400, 1),
  (1037, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'M', 46900, 23400, 2),
  (1038, 1, 'Camisa Oversize Rosa', 'Rosa', 'M', 34900, 17500, 1),
  (1038, 5, 'Buzo Violeta', 'Violeta', 'L', 42900, 21400, 1),
  (1038, 10, 'Vestido Amarillo', 'Amarillo', 'S', 32900, 16400, 1),
  (1039, 3, 'Remera Crop Blanca', 'Blanco', 'M', 18900, 8900, 1),
  (1040, 5, 'Buzo Violeta', 'Violeta', 'M', 42900, 21400, 2),
  (1040, 3, 'Remera Crop Blanca', 'Negro', 'XL', 18900, 8900, 1),
  (1041, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'L', 46900, 23400, 1),
  (1041, 5, 'Buzo Violeta', 'Violeta', 'XS', 42900, 21400, 1),
  (1042, 2, 'Top Deportivo Coral', 'Coral', 'S', 24900, 12100, 1),
  (1043, 10, 'Vestido Amarillo', 'Amarillo', 'XL', 32900, 16400, 1),
  (1043, 9, 'Pantalón Gris Perla', 'Gris', 'L', 41900, 20900, 1),
  (1043, 5, 'Buzo Violeta', 'Violeta', 'XL', 42900, 21400, 1),
  (1044, 9, 'Pantalón Gris Perla', 'Gris', 'S', 41900, 20900, 1),
  (1045, 4, 'Chaleco Crochet', 'Beige', 'L', 39900, 19800, 1),
  (1045, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'XS', 46900, 23400, 1),
  (1045, 3, 'Remera Crop Blanca', 'Blanco', 'S', 18900, 8900, 1),
  (1046, 1, 'Camisa Oversize Rosa', 'Blanco', 'L', 34900, 17500, 1),
  (1046, 5, 'Buzo Violeta', 'Violeta', 'S', 42900, 21400, 2),
  (1046, 8, 'Pantalón Recto Marrón', 'Marrón', 'M', 43900, 21900, 1),
  (1047, 1, 'Camisa Oversize Rosa', 'Blanco', 'L', 34900, 17500, 2),
  (1047, 10, 'Vestido Amarillo', 'Amarillo', 'XS', 32900, 16400, 1),
  (1048, 10, 'Vestido Amarillo', 'Amarillo', 'XL', 32900, 16400, 1),
  (1049, 5, 'Buzo Violeta', 'Violeta', 'XL', 42900, 21400, 1),
  (1049, 9, 'Pantalón Gris Perla', 'Gris', 'XS', 41900, 20900, 1),
  (1050, 5, 'Buzo Violeta', 'Violeta', 'S', 42900, 21400, 1),
  (1051, 3, 'Remera Crop Blanca', 'Negro', 'S', 18900, 8900, 2),
  (1052, 3, 'Remera Crop Blanca', 'Negro', 'S', 18900, 8900, 1),
  (1052, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'XS', 46900, 23400, 2),
  (1053, 6, 'Buzo Crop Negro', 'Negro', 'S', 44900, 22300, 2),
  (1053, 5, 'Buzo Violeta', 'Violeta', 'L', 42900, 21400, 1),
  (1054, 10, 'Vestido Amarillo', 'Amarillo', 'XL', 32900, 16400, 2),
  (1054, 8, 'Pantalón Recto Marrón', 'Marrón', 'S', 43900, 21900, 1),
  (1055, 1, 'Camisa Oversize Rosa', 'Rosa', 'M', 34900, 17500, 1),
  (1056, 5, 'Buzo Violeta', 'Violeta', 'M', 42900, 21400, 1),
  (1057, 2, 'Top Deportivo Coral', 'Coral', 'M', 24900, 12100, 1),
  (1057, 1, 'Camisa Oversize Rosa', 'Blanco', 'L', 34900, 17500, 1),
  (1058, 1, 'Camisa Oversize Rosa', 'Blanco', 'L', 34900, 17500, 1),
  (1058, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'S', 46900, 23400, 1),
  (1059, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'S', 46900, 23400, 1),
  (1059, 2, 'Top Deportivo Coral', 'Coral', 'XS', 24900, 12100, 2),
  (1059, 1, 'Camisa Oversize Rosa', 'Rosa', 'L', 34900, 17500, 1),
  (1060, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'XL', 46900, 23400, 1),
  (1061, 1, 'Camisa Oversize Rosa', 'Rosa', 'S', 34900, 17500, 1),
  (1062, 2, 'Top Deportivo Coral', 'Coral', 'M', 24900, 12100, 1),
  (1062, 6, 'Buzo Crop Negro', 'Negro', 'XS', 44900, 22300, 1),
  (1063, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'M', 46900, 23400, 2),
  (1063, 3, 'Remera Crop Blanca', 'Blanco', 'L', 18900, 8900, 1),
  (1064, 9, 'Pantalón Gris Perla', 'Gris', 'XS', 41900, 20900, 1),
  (1064, 1, 'Camisa Oversize Rosa', 'Rosa', 'L', 34900, 17500, 1),
  (1064, 8, 'Pantalón Recto Marrón', 'Marrón', 'S', 43900, 21900, 1),
  (1065, 3, 'Remera Crop Blanca', 'Blanco', 'M', 18900, 8900, 1),
  (1066, 1, 'Camisa Oversize Rosa', 'Rosa', 'S', 34900, 17500, 1),
  (1066, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'L', 46900, 23400, 1),
  (1067, 3, 'Remera Crop Blanca', 'Negro', 'M', 18900, 8900, 1),
  (1068, 1, 'Camisa Oversize Rosa', 'Rosa', 'XL', 34900, 17500, 2),
  (1068, 5, 'Buzo Violeta', 'Violeta', 'S', 42900, 21400, 1),
  (1069, 1, 'Camisa Oversize Rosa', 'Rosa', 'M', 34900, 17500, 1),
  (1070, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'M', 46900, 23400, 1),
  (1070, 3, 'Remera Crop Blanca', 'Negro', 'M', 18900, 8900, 1),
  (1071, 3, 'Remera Crop Blanca', 'Blanco', 'M', 18900, 8900, 1),
  (1072, 10, 'Vestido Amarillo', 'Amarillo', 'XL', 32900, 16400, 2),
  (1072, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'XL', 46900, 23400, 1),
  (1073, 8, 'Pantalón Recto Marrón', 'Marrón', 'L', 43900, 21900, 2),
  (1073, 1, 'Camisa Oversize Rosa', 'Blanco', 'S', 34900, 17500, 2),
  (1074, 9, 'Pantalón Gris Perla', 'Gris', 'M', 41900, 20900, 1),
  (1074, 6, 'Buzo Crop Negro', 'Negro', 'M', 44900, 22300, 2),
  (1074, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'XS', 46900, 23400, 1),
  (1075, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'M', 46900, 23400, 1),
  (1076, 10, 'Vestido Amarillo', 'Amarillo', 'XS', 32900, 16400, 1),
  (1077, 7, 'Pantalón Cargo Verde Oliva', 'Verde oliva', 'M', 46900, 23400, 1),
  (1077, 10, 'Vestido Amarillo', 'Amarillo', 'S', 32900, 16400, 1),
  (1077, 1, 'Camisa Oversize Rosa', 'Rosa', 'S', 34900, 17500, 2),
  (1078, 3, 'Remera Crop Blanca', 'Negro', 'XL', 18900, 8900, 1),
  (1079, 1, 'Camisa Oversize Rosa', 'Rosa', 'M', 34900, 17500, 1),
  (1079, 2, 'Top Deportivo Coral', 'Coral', 'L', 24900, 12100, 1),
  (1080, 5, 'Buzo Violeta', 'Violeta', 'XS', 42900, 21400, 1),
  (1080, 10, 'Vestido Amarillo', 'Amarillo', 'XS', 32900, 16400, 1);

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
