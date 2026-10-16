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
-- Las imágenes de los productos son ilustraciones de muestra
-- (public/img/productos/*.svg, ver database/fotos-demo). Se reemplazan
-- por fotos reales desde Admin → Productos → Editar → Imágenes.
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
  (3, 'Blazers', 'blazers', 3),
  (4, 'Pantalones', 'pantalones', 4),
  (5, 'Vestidos', 'vestidos', 5),
  (6, 'Accesorios', 'accesorios', 6);

-- Subcategorías: los filtros propios de cada sección
INSERT INTO subcategorias (id, categoria_id, nombre, slug, orden) VALUES
  (1, 1, 'Blusas', 'blusas', 1),
  (2, 1, 'Camisas', 'camisas', 2),
  (3, 4, 'Palazzo', 'palazzo', 1),
  (4, 4, 'Sastreros', 'sastreros', 2),
  (5, 4, 'Rectos', 'rectos', 3),
  (6, 4, 'Jeans', 'jeans', 4),
  (7, 5, 'Largos', 'largos', 1),
  (8, 5, 'Midi', 'midi', 2),
  (9, 5, 'Cortos', 'cortos', 3),
  (10, 6, 'Carteras', 'carteras', 1),
  (11, 6, 'Cintos', 'cintos', 2),
  (12, 6, 'Bijouterie', 'bijouterie', 3);

INSERT INTO colores (id, valor, nombre, hex, orden) VALUES
  (1, 'rosa', 'Rosa', '#e08aa8', 1),
  (2, 'negro', 'Negro', '#1f1a1c', 2),
  (3, 'beige', 'Beige', '#d8c3aa', 3),
  (4, 'blanco', 'Blanco', '#f6f1ec', 4),
  (5, 'celeste', 'Celeste', '#9dbad3', 5),
  (6, 'marron', 'Marrón', '#7b4d34', 6),
  (7, 'borravino', 'Borravino', '#7d2b46', 7),
  (8, 'dorado', 'Dorado', '#c9a24a', 8);

-- ── Productos (imágenes en public/img/productos) ────────
INSERT INTO productos (id, nombre, categoria_id, subcategoria_id, color_id, precio, costo, stock, talles, etiqueta, resumen, descripcion, destacados) VALUES
  (1, 'Blusa Romana', 1, 1, 4, 28900, 14500, 18, 'XS,S,M,L,XL', 'Más elegido', 'Blusa de mangas globo con escote en V y botones al frente. Fresca, liviana y muy fácil de combinar.', 'La Blusa Romana es la prenda que resuelve cualquier outfit: con jean de día, con pantalón de vestir para la oficina o con pollera para salir.

Tiene mangas globo con puño elastizado, escote en V y una línea de botones forrados que le dan un detalle delicado.', 'Mangas globo con puño elastizado
Botones forrados al frente
Tela fresca de caída suave'),
  (2, 'Blusa Satén', 1, 2, 1, 29900, 15200, 12, 'XS,S,M,L,XL', 'Nuevo', 'Camisa de satén con caída fluida y brillo sutil. Para dar un toque elegante a lo cotidiano.', 'Una camisa de satén liviana, con cuello clásico y botones al frente. Se lleva dentro del pantalón o suelta sobre un jean.

Su caída fluida y el brillo suave la hacen ideal tanto para el día como para una salida.', 'Tela satinada de caída fluida
Cuello camisero clásico
Mangas con puño abotonado'),
  (3, 'Camisa Lino', 1, 2, 3, 31900, 16400, 10, 'S,M,L,XL', NULL, 'Camisa de lino lavado, fresca y con ese arrugado natural que se ve tan bien.', 'Camisa de lino con bolsillo en el pecho y mangas cortas. Un clásico de verano que no pasa de moda.

El lino lavado la hace suave desde el primer uso y le da ese aspecto relajado que tanto gusta.', 'Lino lavado, suave y fresco
Bolsillo en el pecho
Ideal para el calor'),
  (4, 'Top Siena', 2, NULL, 2, 22900, 11200, 24, 'XS,S,M,L,XL', 'Más elegido', 'Top de morley canalé con escote cuadrado. Ajustado, cómodo y muy versátil.', 'Un básico con carácter: escote cuadrado, tiras anchas y tela canalé que se adapta al cuerpo sin apretar.

Combinalo con jean, con pantalón sastrero o debajo de un blazer.', 'Escote cuadrado favorecedor
Canalé elastizado
Tiras anchas, cómodas'),
  (5, 'Top Básico', 2, NULL, 4, 18900, 8900, 30, 'XS,S,M,L,XL', NULL, 'El básico de todos los días, en morley canalé liviano.', 'Top sin mangas de línea simple, perfecto para usar solo o como capa interior. No puede faltar en tu placard.

Su tela canalé es suave, respirable y mantiene la forma lavado tras lavado.', 'Básico para todos los días
Tela suave y elástica
Varios colores'),
  (6, 'Top Halter', 2, NULL, 1, 19900, 9400, 15, 'XS,S,M,L,XL', 'Oferta', 'Top con cuello halter y espalda descubierta. Para días de sol y noches de verano.', 'Top halter de canalé con cuello que se ata en la nuca. Un diseño fresco y favorecedor.

Queda increíble con pantalón palazzo o con una pollera de tiro alto.', 'Cuello halter atado
Espalda descubierta
Canalé elastizado'),
  (7, 'Top Rib', 2, NULL, 3, 17900, 8200, 20, 'XS,S,M,L,XL', NULL, 'Top de morley rib color arena, con tiras anchas y mucho estilo.', 'Un top simple y cómodo, pensado para combinar con todo. Su color arena va con cualquier paleta.

La tela rib acompaña los movimientos sin marcar.', 'Color neutro fácil de combinar
Tela rib elástica
Cómodo todo el día'),
  (8, 'Blazer Clásico', 3, NULL, 3, 42900, 22800, 9, 'XS,S,M,L,XL', 'Nuevo', 'Blazer entallado de corte clásico con solapas y bolsillos con tapa. Elegancia en cada ocasión.', 'El blazer que suma categoría a cualquier look: con jean, con pantalón sastrero o sobre un vestido.

Tiene solapas clásicas, dos bolsillos con tapa y un forro suave que lo hace cómodo todo el día.', 'Corte entallado clásico
Bolsillos con tapa
Forro interior suave'),
  (9, 'Blazer Rosa', 3, NULL, 1, 44900, 24100, 7, 'XS,S,M,L,XL', 'Nuevo', 'Blazer rosa palo, el toque de color de la temporada.', 'Un blazer que no pasa desapercibido: el rosa palo es suave, elegante y combina con neutros, blanco y negro.

Perfecto para la oficina, un evento o una salida.', 'Color rosa palo de temporada
Solapas y bolsillos con tapa
Forro interior'),
  (10, 'Blazer Negro', 3, NULL, 2, 43900, 23200, 11, 'XS,S,M,L,XL', NULL, 'El blazer negro que siempre funciona. Para el trabajo y para salir.', 'Un esencial de todo placard: corte recto, solapas finas y caída impecable.

Con vestido, con jean o con pantalón de vestir, siempre suma.', 'Un esencial del placard
Caída impecable
Corte recto'),
  (11, 'Pantalón Sastrero', 4, 4, 3, 34900, 17500, 16, 'XS,S,M,L,XL', 'Más elegido', 'Pantalón de tiro alto con tajos y caída recta. Elegante y cómodo.', 'El pantalón sastrero que estiliza y se adapta a todo: lo usás con blusa y blazer para la oficina o con un top para salir.

Tiro alto, pinzas delanteras y cierre invisible.', 'Tiro alto que estiliza
Pinzas delanteras
Cierre y botón'),
  (12, 'Pantalón Palazzo', 4, 3, 1, 36900, 18800, 14, 'XS,S,M,L,XL', 'Nuevo', 'Palazzo de pierna ancha y tiro alto. Movimiento y elegancia.', 'Un pantalón con mucha caída y movimiento. La pierna ancha alarga la silueta y es súper cómodo.

Combinalo con un top ajustado y listo.', 'Pierna ancha con mucha caída
Tiro alto
Cintura con elástico atrás'),
  (13, 'Pantalón Recto Negro', 4, 5, 2, 33900, 17000, 13, 'XS,S,M,L,XL', NULL, 'Pantalón recto de vestir. Combina con todo.', 'Un clásico que no falla: línea recta, tiro alto y tela con buena caída.

Ideal para trabajar, para una reunión o para salir.', 'Línea recta y prolija
Tiro alto
Tela con caída'),
  (14, 'Palazzo Blanco', 4, 3, 4, 35900, 18100, 8, 'XS,S,M,L,XL', 'Oferta', 'Palazzo blanco fluido para días de calor.', 'Pantalón de pierna ancha en tela fresca. Un blanco que ilumina y combina con todo.

Perfecto con top negro o con blusa de colores.', 'Tela fresca y liviana
Pierna ancha
Tiro alto'),
  (15, 'Jean Mom', 4, 6, 5, 38900, 19400, 17, 'XS,S,M,L,XL', NULL, 'Jean de tiro alto y pierna recta, de denim celeste lavado.', 'El jean mom es el que mejor calza: tiro alto, cadera cómoda y pierna que se afina hacia el tobillo.

Denim de buen cuerpo con lavado celeste.', 'Tiro alto cómodo
Denim de buen cuerpo
Lavado celeste'),
  (16, 'Vestido Aura', 5, 7, 1, 32900, 16800, 14, 'XS,S,M,L,XL', 'Más elegido', 'Vestido largo de breteles finos con escote en V y tajo lateral.', 'Un vestido que alcanza para todo: breteles finos, escote en V y tajo lateral para moverte con comodidad.

Su tela fluida cae con elegancia y es ideal para eventos de día o de noche.', 'Breteles finos regulables
Escote en V
Tajo lateral'),
  (17, 'Vestido Elegance', 5, 7, 2, 38900, 19900, 10, 'XS,S,M,L,XL', NULL, 'Vestido negro de línea clásica para ocasiones especiales.', 'El vestido negro que todas necesitamos: simple, elegante y favorecedor.

Se luce solo o con accesorios dorados.', 'Un clásico atemporal
Escote en V
Tela con caída'),
  (18, 'Vestido Midi Lino', 5, 8, 3, 36900, 18700, 9, 'XS,S,M,L,XL', 'Nuevo', 'Vestido midi de lino con breteles finos. Fresco y elegante.', 'Un vestido midi pensado para el verano: lino liviano, breteles finos y línea acampanada.

Con sandalias o zapatillas, siempre queda bien.', 'Lino liviano y fresco
Línea acampanada
Largo midi'),
  (19, 'Vestido Corto Blanco', 5, 9, 4, 29900, 14900, 12, 'XS,S,M,L,XL', 'Oferta', 'Vestido corto blanco con escote en V. Para días de verano.', 'Un vestido corto y liviano, con escote en V y falda con vuelo.

El blanco más fresco del verano, para combinar con accesorios dorados.', 'Falda con vuelo
Escote en V
Tela liviana'),
  (20, 'Vestido Seda Borravino', 5, 7, 7, 41900, 21500, 6, 'XS,S,M,L,XL', NULL, 'Vestido de seda color borravino, ideal para una noche especial.', 'Un vestido con caída de seda en un color intenso y elegante.

Combinalo con tacos y aros dorados.', 'Color borravino intenso
Caída de seda
Breteles finos'),
  (21, 'Cartera Mini', 6, 10, 2, 27900, 13400, 15, NULL, 'Más elegido', 'Cartera de mano con asa y cierre de solapa. Pequeña pero ideal.', 'Una cartera de mano con espacio justo para lo esencial: celular, billetera y llaves.

Tiene asa superior rígida, solapa con broche dorado y forro interior.', 'Asa rígida superior
Broche dorado
Forro interior'),
  (22, 'Cinto Cuero', 6, 11, 6, 12900, 5800, 22, NULL, NULL, 'Cinto de cuero con hebilla dorada, para marcar la cintura.', 'Un cinto clásico en cuero color marrón con hebilla dorada. Suma definición a pantalones y vestidos.

Se combina con todo.', 'Hebilla dorada
Cuero resistente
Ancho 3 cm'),
  (23, 'Aros Perla', 6, 12, 4, 8900, 3600, 40, NULL, 'Oferta', 'Aros con perla y baño dorado. Un detalle que suma.', 'Aros colgantes con perla y herrajes con baño dorado. Livianos y elegantes.

El detalle justo para completar cualquier look.', 'Baño dorado
Livianos
Perla sintética'),
  (24, 'Collar Dorado', 6, 12, 8, 11900, 4800, 28, NULL, NULL, 'Collar de cadena con dije circular, baño dorado.', 'Un collar delicado con dije circular. Se luce solo o en capas con otros collares.

Cadena ajustable.', 'Baño dorado
Cadena ajustable
Dije circular');

-- Colores en que se vende cada producto (el primero es el principal)
INSERT INTO producto_colores (producto_id, color_id, orden) VALUES
  (1, 4, 0),
  (1, 1, 1),
  (2, 1, 0),
  (2, 4, 1),
  (3, 3, 0),
  (3, 4, 1),
  (4, 2, 0),
  (4, 4, 1),
  (4, 3, 2),
  (5, 4, 0),
  (5, 2, 1),
  (5, 3, 2),
  (6, 1, 0),
  (6, 2, 1),
  (7, 3, 0),
  (7, 1, 1),
  (8, 3, 0),
  (8, 2, 1),
  (9, 1, 0),
  (10, 2, 0),
  (11, 3, 0),
  (11, 2, 1),
  (12, 1, 0),
  (12, 3, 1),
  (12, 2, 2),
  (13, 2, 0),
  (14, 4, 0),
  (15, 5, 0),
  (16, 1, 0),
  (16, 2, 1),
  (17, 2, 0),
  (18, 3, 0),
  (19, 4, 0),
  (20, 7, 0),
  (21, 2, 0),
  (22, 6, 0),
  (23, 4, 0),
  (24, 8, 0);

INSERT INTO producto_imagenes (producto_id, ruta, orden) VALUES
  (1, '/img/productos/blusa-romana-1.svg', 0),
  (1, '/img/productos/blusa-romana-2.svg', 1),
  (2, '/img/productos/blusa-satin-1.svg', 0),
  (2, '/img/productos/blusa-satin-2.svg', 1),
  (3, '/img/productos/camisa-lino-1.svg', 0),
  (3, '/img/productos/camisa-lino-2.svg', 1),
  (4, '/img/productos/top-siena-1.svg', 0),
  (4, '/img/productos/top-siena-2.svg', 1),
  (5, '/img/productos/top-basico-1.svg', 0),
  (5, '/img/productos/top-basico-2.svg', 1),
  (6, '/img/productos/top-halter-1.svg', 0),
  (6, '/img/productos/top-halter-2.svg', 1),
  (7, '/img/productos/top-rib-1.svg', 0),
  (7, '/img/productos/top-rib-2.svg', 1),
  (8, '/img/productos/blazer-clasico-1.svg', 0),
  (8, '/img/productos/blazer-clasico-2.svg', 1),
  (9, '/img/productos/blazer-rosa-1.svg', 0),
  (9, '/img/productos/blazer-rosa-2.svg', 1),
  (10, '/img/productos/blazer-negro-1.svg', 0),
  (10, '/img/productos/blazer-negro-2.svg', 1),
  (11, '/img/productos/pantalon-sastrero-1.svg', 0),
  (11, '/img/productos/pantalon-sastrero-2.svg', 1),
  (12, '/img/productos/pantalon-palazzo-1.svg', 0),
  (12, '/img/productos/pantalon-palazzo-2.svg', 1),
  (13, '/img/productos/pantalon-recto-1.svg', 0),
  (13, '/img/productos/pantalon-recto-2.svg', 1),
  (14, '/img/productos/palazzo-blanco-1.svg', 0),
  (14, '/img/productos/palazzo-blanco-2.svg', 1),
  (15, '/img/productos/jean-mom-1.svg', 0),
  (15, '/img/productos/jean-mom-2.svg', 1),
  (16, '/img/productos/vestido-aura-1.svg', 0),
  (16, '/img/productos/vestido-aura-2.svg', 1),
  (17, '/img/productos/vestido-elegance-1.svg', 0),
  (17, '/img/productos/vestido-elegance-2.svg', 1),
  (18, '/img/productos/vestido-midi-lino-1.svg', 0),
  (18, '/img/productos/vestido-midi-lino-2.svg', 1),
  (19, '/img/productos/vestido-corto-1.svg', 0),
  (19, '/img/productos/vestido-corto-2.svg', 1),
  (20, '/img/productos/vestido-seda-1.svg', 0),
  (20, '/img/productos/vestido-seda-2.svg', 1),
  (21, '/img/productos/cartera-mini-1.svg', 0),
  (21, '/img/productos/cartera-mini-2.svg', 1),
  (22, '/img/productos/cinto-cuero-1.svg', 0),
  (22, '/img/productos/cinto-cuero-2.svg', 1),
  (23, '/img/productos/aros-perla-1.svg', 0),
  (23, '/img/productos/aros-perla-2.svg', 1),
  (24, '/img/productos/collar-dorado-1.svg', 0),
  (24, '/img/productos/collar-dorado-2.svg', 1);

-- ── Ficha técnica de cada producto ──────────────────────
INSERT INTO especificaciones (producto_id, clave, valor, orden) VALUES
  (1, 'Composición', '97% algodón · 3% elastano', 1),
  (1, 'Calce', 'Regular', 2),
  (1, 'Largo', 'Cintura', 3),
  (1, 'Cuidado', 'Lavar a mano o en ciclo delicado', 4),
  (2, 'Composición', '100% poliéster satinado', 1),
  (2, 'Calce', 'Holgado', 2),
  (2, 'Largo', 'Cadera', 3),
  (2, 'Cuidado', 'Lavar a mano en agua fría', 4),
  (3, 'Composición', '55% lino · 45% viscosa', 1),
  (3, 'Calce', 'Regular', 2),
  (3, 'Largo', 'Cadera', 3),
  (3, 'Cuidado', 'Lavar en ciclo delicado', 4),
  (4, 'Composición', '95% algodón · 5% elastano', 1),
  (4, 'Calce', 'Ajustado', 2),
  (4, 'Largo', 'Cropped', 3),
  (4, 'Cuidado', 'Lavar en ciclo delicado, no usar secadora', 4),
  (5, 'Composición', '95% algodón · 5% elastano', 1),
  (5, 'Calce', 'Ajustado', 2),
  (5, 'Largo', 'A la cintura', 3),
  (5, 'Cuidado', 'Lavar con colores similares', 4),
  (6, 'Composición', '95% algodón · 5% elastano', 1),
  (6, 'Calce', 'Ajustado', 2),
  (6, 'Largo', 'Cropped', 3),
  (6, 'Cuidado', 'Lavar a mano', 4),
  (7, 'Composición', '92% algodón · 8% elastano', 1),
  (7, 'Calce', 'Ajustado', 2),
  (7, 'Largo', 'Cropped', 3),
  (7, 'Cuidado', 'Lavar en ciclo delicado', 4),
  (8, 'Composición', '65% poliéster · 33% viscosa · 2% elastano', 1),
  (8, 'Calce', 'Entallado', 2),
  (8, 'Largo', 'Cadera', 3),
  (8, 'Cuidado', 'Limpieza en seco', 4),
  (9, 'Composición', '65% poliéster · 33% viscosa · 2% elastano', 1),
  (9, 'Calce', 'Entallado', 2),
  (9, 'Largo', 'Cadera', 3),
  (9, 'Cuidado', 'Limpieza en seco', 4),
  (10, 'Composición', '65% poliéster · 33% viscosa · 2% elastano', 1),
  (10, 'Calce', 'Recto', 2),
  (10, 'Largo', 'Cadera', 3),
  (10, 'Cuidado', 'Limpieza en seco', 4),
  (11, 'Composición', '70% poliéster · 28% viscosa · 2% elastano', 1),
  (11, 'Calce', 'Recto', 2),
  (11, 'Tiro', 'Alto', 3),
  (11, 'Cuidado', 'Lavar en ciclo delicado', 4),
  (12, 'Composición', '100% poliéster crepe', 1),
  (12, 'Calce', 'Amplio', 2),
  (12, 'Tiro', 'Alto', 3),
  (12, 'Cuidado', 'Lavar en ciclo delicado', 4),
  (13, 'Composición', '70% poliéster · 28% viscosa · 2% elastano', 1),
  (13, 'Calce', 'Recto', 2),
  (13, 'Tiro', 'Alto', 3),
  (13, 'Cuidado', 'Lavar en ciclo delicado', 4),
  (14, 'Composición', '100% poliéster crepe', 1),
  (14, 'Calce', 'Amplio', 2),
  (14, 'Tiro', 'Alto', 3),
  (14, 'Cuidado', 'Lavar en ciclo delicado', 4),
  (15, 'Composición', '98% algodón · 2% elastano', 1),
  (15, 'Calce', 'Mom', 2),
  (15, 'Tiro', 'Alto', 3),
  (15, 'Cuidado', 'Lavar del revés en agua fría', 4),
  (16, 'Composición', '100% poliéster satinado', 1),
  (16, 'Calce', 'Fluido', 2),
  (16, 'Largo', 'Maxi', 3),
  (16, 'Cuidado', 'Lavar a mano', 4),
  (17, 'Composición', '95% poliéster · 5% elastano', 1),
  (17, 'Calce', 'Entallado', 2),
  (17, 'Largo', 'Maxi', 3),
  (17, 'Cuidado', 'Lavar a mano', 4),
  (18, 'Composición', '55% lino · 45% viscosa', 1),
  (18, 'Calce', 'Suelto', 2),
  (18, 'Largo', 'Midi', 3),
  (18, 'Cuidado', 'Lavar en ciclo delicado', 4),
  (19, 'Composición', '100% algodón', 1),
  (19, 'Calce', 'Suelto', 2),
  (19, 'Largo', 'Corto', 3),
  (19, 'Cuidado', 'Lavar en ciclo delicado', 4),
  (20, 'Composición', '100% poliéster satinado', 1),
  (20, 'Calce', 'Fluido', 2),
  (20, 'Largo', 'Maxi', 3),
  (20, 'Cuidado', 'Lavar a mano', 4),
  (21, 'Material', 'Símil cuero', 1),
  (21, 'Medidas', '20 × 16 × 8 cm', 2),
  (21, 'Cierre', 'Solapa con broche', 3),
  (21, 'Cuidado', 'Limpiar con paño húmedo', 4),
  (22, 'Material', 'Cuero vacuno', 1),
  (22, 'Ancho', '3 cm', 2),
  (22, 'Largo', '100 cm', 3),
  (22, 'Cuidado', 'Evitar la humedad', 4),
  (23, 'Material', 'Acero con baño dorado', 1),
  (23, 'Largo', '4 cm', 2),
  (23, 'Cuidado', 'Evitar el agua y los perfumes', 3),
  (24, 'Material', 'Acero con baño dorado', 1),
  (24, 'Largo', '40 + 5 cm', 2),
  (24, 'Cuidado', 'Evitar el agua y los perfumes', 3);

-- ── Cupones ─────────────────────────────────────────────
INSERT INTO cupones (codigo, descripcion, porcentaje, activo, vence_en) VALUES
  ('BIENVENIDA', '10% off en tu primera compra', 0.1000, 1, NULL),
  ('MAQUETA5', '5% off de prueba', 0.0500, 1, NULL),
  ('VERANO20', '20% off de temporada (vencido)', 0.2000, 1, CURDATE() - INTERVAL 10 DAY);

-- ── Favoritos del cliente demo ──────────────────────────
INSERT INTO favoritos (usuario_id, producto_id) VALUES
  (1, 1),
  (1, 12),
  (1, 16);

-- ── Pedidos de los últimos 30 días (80) ─────────────────
INSERT INTO pedidos (id, usuario_id, cliente, email, telefono, entrega, calle, altura, piso, codigo_postal, ciudad, provincia, medio_pago, estado, subtotal, descuento, envio, total, costo, ganancia, creado_en) VALUES
  (1001, NULL, 'Lucía Fernández', 'lucia.fernandez@mail.com', '11 47926919', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 65700, 0, 0, 65700, 31800, 33900, TIMESTAMP(CURDATE() - INTERVAL 29 DAY, '15:26:00')),
  (1002, NULL, 'Santiago Morales', 'santiago.morales@mail.com', '11 47934838', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 51800, 5180, 0, 46620, 25700, 20920, TIMESTAMP(CURDATE() - INTERVAL 29 DAY, '20:45:00')),
  (1003, 1, 'Cliente Demo', 'demo@tienda.com', '11 47942757', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 89700, 0, 0, 89700, 45000, 44700, TIMESTAMP(CURDATE() - INTERVAL 29 DAY, '14:32:00')),
  (1004, NULL, 'Martín Gómez', 'martin.gomez@mail.com', '11 47950676', 'domicilio', 'Av. Siempre Viva', '984', NULL, '5000', 'Córdoba', 'Córdoba', 'transferencia', 'entregado', 122500, 12250, 0, 110250, 60000, 50250, TIMESTAMP(CURDATE() - INTERVAL 28 DAY, '10:49:00')),
  (1005, NULL, 'Facundo Ruiz', 'facundo.ruiz@mail.com', '11 47958595', 'domicilio', 'Av. Siempre Viva', '3066', NULL, '5500', 'Mendoza', 'Mendoza', 'tarjeta', 'entregado', 45800, 0, 4500, 50300, 22400, 23400, TIMESTAMP(CURDATE() - INTERVAL 28 DAY, '17:50:00')),
  (1006, NULL, 'Facundo Ruiz', 'facundo.ruiz@mail.com', '11 47966514', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 54800, 5480, 0, 49320, 27600, 21720, TIMESTAMP(CURDATE() - INTERVAL 28 DAY, '11:01:00')),
  (1007, NULL, 'Florencia Castro', 'florencia.castro@mail.com', '11 47974433', 'domicilio', 'Av. Siempre Viva', '2701', NULL, '5000', 'Córdoba', 'Córdoba', 'transferencia', 'entregado', 27900, 2790, 4500, 29610, 13400, 11710, TIMESTAMP(CURDATE() - INTERVAL 27 DAY, '17:46:00')),
  (1008, NULL, 'Tomás Díaz', 'tomas.diaz@mail.com', '11 47982352', 'domicilio', 'Av. Siempre Viva', '3580', NULL, '1900', 'La Plata', 'Buenos Aires', 'tarjeta', 'entregado', 77800, 0, 0, 77800, 39800, 38000, TIMESTAMP(CURDATE() - INTERVAL 27 DAY, '09:32:00')),
  (1009, 1, 'Cliente Demo', 'demo@tienda.com', '11 47990271', 'domicilio', 'Av. Siempre Viva', '2774', NULL, '2000', 'Rosario', 'Santa Fe', 'transferencia', 'entregado', 89600, 8960, 0, 80640, 43700, 36940, TIMESTAMP(CURDATE() - INTERVAL 27 DAY, '20:11:00')),
  (1010, NULL, 'Mateo Sánchez', 'mateo.sanchez@mail.com', '11 47998190', 'domicilio', 'Av. Siempre Viva', '2838', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'transferencia', 'entregado', 36900, 3690, 4500, 37710, 18700, 14510, TIMESTAMP(CURDATE() - INTERVAL 27 DAY, '17:44:00')),
  (1011, NULL, 'Camila Martínez', 'camila.martinez@mail.com', '11 48006109', 'domicilio', 'Av. Siempre Viva', '3278', NULL, '2000', 'Rosario', 'Santa Fe', 'transferencia', 'entregado', 46700, 4670, 4500, 46530, 20800, 21230, TIMESTAMP(CURDATE() - INTERVAL 26 DAY, '15:35:00')),
  (1012, NULL, 'Facundo Ruiz', 'facundo.ruiz@mail.com', '11 48014028', 'domicilio', 'Av. Siempre Viva', '1454', NULL, '5500', 'Mendoza', 'Mendoza', 'tarjeta', 'entregado', 49800, 0, 4500, 54300, 24600, 25200, TIMESTAMP(CURDATE() - INTERVAL 26 DAY, '16:31:00')),
  (1013, NULL, 'Micaela Ortiz', 'micaela.ortiz@mail.com', '11 48021947', 'domicilio', 'Av. Siempre Viva', '3366', NULL, '1900', 'La Plata', 'Buenos Aires', 'tarjeta', 'entregado', 35900, 0, 4500, 40400, 18100, 17800, TIMESTAMP(CURDATE() - INTERVAL 25 DAY, '12:10:00')),
  (1014, NULL, 'Juan Pérez', 'juan.perez@mail.com', '11 48029866', 'domicilio', 'Av. Siempre Viva', '219', NULL, '2000', 'Rosario', 'Santa Fe', 'transferencia', 'entregado', 38900, 3890, 4500, 39510, 19400, 15610, TIMESTAMP(CURDATE() - INTERVAL 25 DAY, '18:52:00')),
  (1015, NULL, 'Agustina Torres', 'agustina.torres@mail.com', '11 48037785', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 54800, 0, 0, 54800, 27600, 27200, TIMESTAMP(CURDATE() - INTERVAL 24 DAY, '17:29:00')),
  (1016, NULL, 'Juan Pérez', 'juan.perez@mail.com', '11 48045704', 'domicilio', 'Av. Siempre Viva', '1329', NULL, '2000', 'Rosario', 'Santa Fe', 'tarjeta', 'cancelado', 62800, 0, 0, 62800, 32200, 30600, TIMESTAMP(CURDATE() - INTERVAL 24 DAY, '20:38:00')),
  (1017, NULL, 'Agustina Torres', 'agustina.torres@mail.com', '11 48053623', 'domicilio', 'Av. Siempre Viva', '2897', NULL, '1900', 'La Plata', 'Buenos Aires', 'tarjeta', 'entregado', 38900, 0, 4500, 43400, 19900, 19000, TIMESTAMP(CURDATE() - INTERVAL 23 DAY, '11:40:00')),
  (1018, NULL, 'Sofía Rodríguez', 'sofia.rodriguez@mail.com', '11 48061542', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 59800, 0, 0, 59800, 29800, 30000, TIMESTAMP(CURDATE() - INTERVAL 23 DAY, '09:13:00')),
  (1019, NULL, 'Martín Gómez', 'martin.gomez@mail.com', '11 48069461', 'domicilio', 'Av. Siempre Viva', '2375', NULL, '5500', 'Mendoza', 'Mendoza', 'transferencia', 'entregado', 76700, 7670, 0, 69030, 38000, 31030, TIMESTAMP(CURDATE() - INTERVAL 23 DAY, '17:18:00')),
  (1020, NULL, 'Tomás Díaz', 'tomas.diaz@mail.com', '11 48077380', 'domicilio', 'Av. Siempre Viva', '972', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'entregado', 22900, 0, 4500, 27400, 11200, 11700, TIMESTAMP(CURDATE() - INTERVAL 22 DAY, '09:49:00')),
  (1021, NULL, 'Valentina López', 'valentina.lopez@mail.com', '11 48085299', 'domicilio', 'Av. Siempre Viva', '906', NULL, '5500', 'Mendoza', 'Mendoza', 'tarjeta', 'entregado', 17900, 0, 4500, 22400, 8200, 9700, TIMESTAMP(CURDATE() - INTERVAL 22 DAY, '09:17:00')),
  (1022, NULL, 'Santiago Morales', 'santiago.morales@mail.com', '11 48093218', 'domicilio', 'Av. Siempre Viva', '2562', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 51800, 0, 4500, 56300, 25700, 26100, TIMESTAMP(CURDATE() - INTERVAL 22 DAY, '10:31:00')),
  (1023, NULL, 'Tomás Díaz', 'tomas.diaz@mail.com', '11 48101137', 'domicilio', 'Av. Siempre Viva', '1486', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'transferencia', 'entregado', 105700, 10570, 0, 95130, 53200, 41930, TIMESTAMP(CURDATE() - INTERVAL 22 DAY, '09:12:00')),
  (1024, NULL, 'Valentina López', 'valentina.lopez@mail.com', '11 48109056', 'domicilio', 'Av. Siempre Viva', '2630', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'entregado', 32900, 0, 4500, 37400, 16800, 16100, TIMESTAMP(CURDATE() - INTERVAL 21 DAY, '10:45:00')),
  (1025, NULL, 'Valentina López', 'valentina.lopez@mail.com', '11 48116975', 'domicilio', 'Av. Siempre Viva', '3255', NULL, '2000', 'Rosario', 'Santa Fe', 'tarjeta', 'entregado', 43900, 0, 4500, 48400, 23200, 20700, TIMESTAMP(CURDATE() - INTERVAL 21 DAY, '15:00:00')),
  (1026, NULL, 'Micaela Ortiz', 'micaela.ortiz@mail.com', '11 48124894', 'domicilio', 'Av. Siempre Viva', '2490', NULL, '5500', 'Mendoza', 'Mendoza', 'tarjeta', 'entregado', 117600, 0, 0, 117600, 58500, 59100, TIMESTAMP(CURDATE() - INTERVAL 21 DAY, '15:26:00')),
  (1027, NULL, 'Valentina López', 'valentina.lopez@mail.com', '11 48132813', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 103600, 10360, 0, 93240, 50600, 42640, TIMESTAMP(CURDATE() - INTERVAL 21 DAY, '16:05:00')),
  (1028, NULL, 'Facundo Ruiz', 'facundo.ruiz@mail.com', '11 48140732', 'domicilio', 'Av. Siempre Viva', '3675', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 130600, 0, 0, 130600, 64900, 65700, TIMESTAMP(CURDATE() - INTERVAL 20 DAY, '17:42:00')),
  (1029, NULL, 'Valentina López', 'valentina.lopez@mail.com', '11 48148651', 'domicilio', 'Av. Siempre Viva', '3004', NULL, '1900', 'La Plata', 'Buenos Aires', 'tarjeta', 'entregado', 115600, 0, 0, 115600, 57000, 58600, TIMESTAMP(CURDATE() - INTERVAL 20 DAY, '14:37:00')),
  (1030, NULL, 'Florencia Castro', 'florencia.castro@mail.com', '11 48156570', 'domicilio', 'Av. Siempre Viva', '1785', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'cancelado', 69800, 0, 0, 69800, 35000, 34800, TIMESTAMP(CURDATE() - INTERVAL 20 DAY, '12:33:00')),
  (1031, NULL, 'Sofía Rodríguez', 'sofia.rodriguez@mail.com', '11 48164489', 'domicilio', 'Av. Siempre Viva', '830', NULL, '5500', 'Mendoza', 'Mendoza', 'tarjeta', 'entregado', 52800, 0, 4500, 57300, 26100, 26700, TIMESTAMP(CURDATE() - INTERVAL 19 DAY, '20:25:00')),
  (1032, NULL, 'Martín Gómez', 'martin.gomez@mail.com', '11 48172408', 'domicilio', 'Av. Siempre Viva', '3091', NULL, '2000', 'Rosario', 'Santa Fe', 'transferencia', 'entregado', 69800, 6980, 0, 62820, 35000, 27820, TIMESTAMP(CURDATE() - INTERVAL 19 DAY, '17:44:00')),
  (1033, NULL, 'Juan Pérez', 'juan.perez@mail.com', '11 48180327', 'domicilio', 'Av. Siempre Viva', '2203', NULL, '5000', 'Córdoba', 'Córdoba', 'transferencia', 'entregado', 17900, 1790, 4500, 20610, 8200, 7910, TIMESTAMP(CURDATE() - INTERVAL 19 DAY, '13:14:00')),
  (1034, NULL, 'Mateo Sánchez', 'mateo.sanchez@mail.com', '11 48188246', 'domicilio', 'Av. Siempre Viva', '1294', NULL, '2000', 'Rosario', 'Santa Fe', 'transferencia', 'entregado', 32900, 3290, 4500, 34110, 16800, 12810, TIMESTAMP(CURDATE() - INTERVAL 18 DAY, '16:28:00')),
  (1035, NULL, 'Micaela Ortiz', 'micaela.ortiz@mail.com', '11 48196165', 'domicilio', 'Av. Siempre Viva', '222', NULL, '1900', 'La Plata', 'Buenos Aires', 'tarjeta', 'entregado', 60800, 0, 0, 60800, 30400, 30400, TIMESTAMP(CURDATE() - INTERVAL 18 DAY, '13:44:00')),
  (1036, NULL, 'Micaela Ortiz', 'micaela.ortiz@mail.com', '11 48204084', 'domicilio', 'Av. Siempre Viva', '3865', NULL, '5500', 'Mendoza', 'Mendoza', 'transferencia', 'entregado', 38900, 3890, 4500, 39510, 19400, 15610, TIMESTAMP(CURDATE() - INTERVAL 18 DAY, '10:51:00')),
  (1037, 1, 'Cliente Demo', 'demo@tienda.com', '11 48212003', 'domicilio', 'Av. Siempre Viva', '1759', NULL, '1900', 'La Plata', 'Buenos Aires', 'transferencia', 'entregado', 50800, 5080, 4500, 50220, 24600, 21120, TIMESTAMP(CURDATE() - INTERVAL 17 DAY, '10:15:00')),
  (1038, NULL, 'Mateo Sánchez', 'mateo.sanchez@mail.com', '11 48219922', 'domicilio', 'Av. Siempre Viva', '3510', NULL, '1900', 'La Plata', 'Buenos Aires', 'tarjeta', 'entregado', 120700, 0, 0, 120700, 62600, 58100, TIMESTAMP(CURDATE() - INTERVAL 17 DAY, '15:22:00')),
  (1039, NULL, 'Camila Martínez', 'camila.martinez@mail.com', '11 48227841', 'domicilio', 'Av. Siempre Viva', '289', NULL, '1900', 'La Plata', 'Buenos Aires', 'transferencia', 'entregado', 22900, 2290, 4500, 25110, 11200, 9410, TIMESTAMP(CURDATE() - INTERVAL 16 DAY, '10:26:00')),
  (1040, NULL, 'Florencia Castro', 'florencia.castro@mail.com', '11 48235760', 'domicilio', 'Av. Siempre Viva', '293', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'transferencia', 'entregado', 106700, 10670, 0, 96030, 54400, 41630, TIMESTAMP(CURDATE() - INTERVAL 16 DAY, '17:58:00')),
  (1041, NULL, 'Juan Pérez', 'juan.perez@mail.com', '11 48243679', 'domicilio', 'Av. Siempre Viva', '3307', NULL, '2000', 'Rosario', 'Santa Fe', 'tarjeta', 'entregado', 52800, 0, 4500, 57300, 25700, 27100, TIMESTAMP(CURDATE() - INTERVAL 16 DAY, '14:01:00')),
  (1042, NULL, 'Facundo Ruiz', 'facundo.ruiz@mail.com', '11 48251598', 'domicilio', 'Av. Siempre Viva', '658', NULL, '1900', 'La Plata', 'Buenos Aires', 'tarjeta', 'entregado', 56800, 0, 4500, 61300, 28200, 28600, TIMESTAMP(CURDATE() - INTERVAL 15 DAY, '12:43:00')),
  (1043, NULL, 'Facundo Ruiz', 'facundo.ruiz@mail.com', '11 48259517', 'domicilio', 'Av. Siempre Viva', '1823', NULL, '5500', 'Mendoza', 'Mendoza', 'tarjeta', 'entregado', 109700, 0, 0, 109700, 55800, 53900, TIMESTAMP(CURDATE() - INTERVAL 15 DAY, '17:35:00')),
  (1044, NULL, 'Camila Martínez', 'camila.martinez@mail.com', '11 48267436', 'domicilio', 'Av. Siempre Viva', '2127', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'entregado', 125600, 0, 0, 125600, 61600, 64000, TIMESTAMP(CURDATE() - INTERVAL 15 DAY, '17:17:00')),
  (1045, NULL, 'Valentina López', 'valentina.lopez@mail.com', '11 48275355', 'domicilio', 'Av. Siempre Viva', '873', NULL, '2000', 'Rosario', 'Santa Fe', 'tarjeta', 'entregado', 18900, 0, 4500, 23400, 8900, 10000, TIMESTAMP(CURDATE() - INTERVAL 15 DAY, '18:33:00')),
  (1046, NULL, 'Valentina López', 'valentina.lopez@mail.com', '11 48283274', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 18900, 1890, 0, 17010, 8900, 8110, TIMESTAMP(CURDATE() - INTERVAL 14 DAY, '18:20:00')),
  (1047, NULL, 'Valentina López', 'valentina.lopez@mail.com', '11 48291193', 'domicilio', 'Av. Siempre Viva', '2436', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 55800, 0, 4500, 60300, 26800, 29000, TIMESTAMP(CURDATE() - INTERVAL 14 DAY, '13:28:00')),
  (1048, NULL, 'Lucía Fernández', 'lucia.fernandez@mail.com', '11 48299112', 'domicilio', 'Av. Siempre Viva', '3963', NULL, '2000', 'Rosario', 'Santa Fe', 'transferencia', 'entregado', 64700, 6470, 0, 58230, 31600, 26630, TIMESTAMP(CURDATE() - INTERVAL 13 DAY, '14:13:00')),
  (1049, NULL, 'Sofía Rodríguez', 'sofia.rodriguez@mail.com', '11 48307031', 'domicilio', 'Av. Siempre Viva', '3484', NULL, '2000', 'Rosario', 'Santa Fe', 'tarjeta', 'entregado', 59800, 0, 4500, 64300, 30400, 29400, TIMESTAMP(CURDATE() - INTERVAL 13 DAY, '15:11:00')),
  (1050, NULL, 'Camila Martínez', 'camila.martinez@mail.com', '11 48314950', 'domicilio', 'Av. Siempre Viva', '1938', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'transferencia', 'entregado', 77800, 7780, 0, 70020, 38800, 31220, TIMESTAMP(CURDATE() - INTERVAL 12 DAY, '19:10:00')),
  (1051, NULL, 'Facundo Ruiz', 'facundo.ruiz@mail.com', '11 48322869', 'domicilio', 'Av. Siempre Viva', '2205', NULL, '1900', 'La Plata', 'Buenos Aires', 'transferencia', 'entregado', 114600, 11460, 0, 103140, 57500, 45640, TIMESTAMP(CURDATE() - INTERVAL 12 DAY, '11:41:00')),
  (1052, NULL, 'Tomás Díaz', 'tomas.diaz@mail.com', '11 48330788', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 77800, 7780, 0, 70020, 40900, 29120, TIMESTAMP(CURDATE() - INTERVAL 12 DAY, '17:18:00')),
  (1053, NULL, 'Nicolás Álvarez', 'nicolas.alvarez@mail.com', '11 48338707', 'domicilio', 'Av. Siempre Viva', '1185', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'transferencia', 'entregado', 63800, 6380, 0, 57420, 33000, 24420, TIMESTAMP(CURDATE() - INTERVAL 12 DAY, '17:37:00')),
  (1054, NULL, 'Facundo Ruiz', 'facundo.ruiz@mail.com', '11 48346626', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 79700, 7970, 0, 71730, 39200, 32530, TIMESTAMP(CURDATE() - INTERVAL 11 DAY, '19:46:00')),
  (1055, NULL, 'Mateo Sánchez', 'mateo.sanchez@mail.com', '11 48354545', 'domicilio', 'Av. Siempre Viva', '1893', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'tarjeta', 'entregado', 71800, 0, 0, 71800, 36600, 35200, TIMESTAMP(CURDATE() - INTERVAL 11 DAY, '18:10:00')),
  (1056, NULL, 'Tomás Díaz', 'tomas.diaz@mail.com', '11 48362464', 'domicilio', 'Av. Siempre Viva', '424', NULL, '5000', 'Córdoba', 'Córdoba', 'transferencia', 'entregado', 48800, 4880, 4500, 48420, 23900, 20020, TIMESTAMP(CURDATE() - INTERVAL 11 DAY, '19:32:00')),
  (1057, NULL, 'Camila Martínez', 'camila.martinez@mail.com', '11 48370383', 'domicilio', 'Av. Siempre Viva', '2413', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'transferencia', 'entregado', 136600, 13660, 0, 122940, 68500, 54440, TIMESTAMP(CURDATE() - INTERVAL 10 DAY, '12:14:00')),
  (1058, NULL, 'Martín Gómez', 'martin.gomez@mail.com', '11 48378302', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 164500, 16450, 0, 148050, 84800, 63250, TIMESTAMP(CURDATE() - INTERVAL 10 DAY, '15:04:00')),
  (1059, NULL, 'Nicolás Álvarez', 'nicolas.alvarez@mail.com', '11 48386221', 'domicilio', 'Av. Siempre Viva', '2642', NULL, '5500', 'Mendoza', 'Mendoza', 'tarjeta', 'entregado', 89700, 0, 0, 89700, 44700, 45000, TIMESTAMP(CURDATE() - INTERVAL 10 DAY, '20:37:00')),
  (1060, NULL, 'Facundo Ruiz', 'facundo.ruiz@mail.com', '11 48394140', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 61800, 0, 0, 61800, 31300, 30500, TIMESTAMP(CURDATE() - INTERVAL 10 DAY, '13:10:00')),
  (1061, NULL, 'Camila Martínez', 'camila.martinez@mail.com', '11 48402059', 'domicilio', 'Av. Siempre Viva', '1392', NULL, '5000', 'Córdoba', 'Córdoba', 'transferencia', 'entregado', 207500, 20750, 0, 186750, 109500, 77250, TIMESTAMP(CURDATE() - INTERVAL 9 DAY, '13:18:00')),
  (1062, NULL, 'Martín Gómez', 'martin.gomez@mail.com', '11 48409978', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 144600, 0, 0, 144600, 73600, 71000, TIMESTAMP(CURDATE() - INTERVAL 9 DAY, '16:45:00')),
  (1063, NULL, 'Nicolás Álvarez', 'nicolas.alvarez@mail.com', '11 48417897', 'domicilio', 'Av. Siempre Viva', '2563', NULL, '1900', 'La Plata', 'Buenos Aires', 'tarjeta', 'entregado', 74700, 0, 0, 74700, 36900, 37800, TIMESTAMP(CURDATE() - INTERVAL 9 DAY, '15:48:00')),
  (1064, NULL, 'Nicolás Álvarez', 'nicolas.alvarez@mail.com', '11 48425816', 'domicilio', 'Av. Siempre Viva', '1093', NULL, '5500', 'Mendoza', 'Mendoza', 'transferencia', 'entregado', 46700, 4670, 4500, 46530, 21700, 20330, TIMESTAMP(CURDATE() - INTERVAL 8 DAY, '17:25:00')),
  (1065, NULL, 'Florencia Castro', 'florencia.castro@mail.com', '11 48433735', 'domicilio', 'Av. Siempre Viva', '3607', NULL, '2000', 'Rosario', 'Santa Fe', 'tarjeta', 'entregado', 36900, 0, 4500, 41400, 18800, 18100, TIMESTAMP(CURDATE() - INTERVAL 8 DAY, '15:59:00')),
  (1066, NULL, 'Juan Pérez', 'juan.perez@mail.com', '11 48441654', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'entregado', 65800, 6580, 0, 59220, 33600, 25620, TIMESTAMP(CURDATE() - INTERVAL 8 DAY, '20:00:00')),
  (1067, NULL, 'Tomás Díaz', 'tomas.diaz@mail.com', '11 48449573', 'domicilio', 'Av. Siempre Viva', '197', NULL, '5000', 'Córdoba', 'Córdoba', 'transferencia', 'entregado', 32900, 3290, 4500, 34110, 16800, 12810, TIMESTAMP(CURDATE() - INTERVAL 8 DAY, '17:19:00')),
  (1068, NULL, 'Agustina Torres', 'agustina.torres@mail.com', '11 48457492', 'domicilio', 'Av. Siempre Viva', '2054', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 55800, 0, 4500, 60300, 26800, 29000, TIMESTAMP(CURDATE() - INTERVAL 7 DAY, '17:12:00')),
  (1069, NULL, 'Nicolás Álvarez', 'nicolas.alvarez@mail.com', '11 48465411', 'domicilio', 'Av. Siempre Viva', '116', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 36800, 0, 4500, 41300, 17100, 19700, TIMESTAMP(CURDATE() - INTERVAL 7 DAY, '10:40:00')),
  (1070, NULL, 'Sofía Rodríguez', 'sofia.rodriguez@mail.com', '11 48473330', 'domicilio', 'Av. Siempre Viva', '569', NULL, '5000', 'Córdoba', 'Córdoba', 'transferencia', 'entregado', 36900, 3690, 4500, 37710, 18700, 14510, TIMESTAMP(CURDATE() - INTERVAL 6 DAY, '15:58:00')),
  (1071, NULL, 'Tomás Díaz', 'tomas.diaz@mail.com', '11 48481249', 'domicilio', 'Av. Siempre Viva', '595', NULL, '2000', 'Rosario', 'Santa Fe', 'transferencia', 'entregado', 92700, 9270, 0, 83430, 47100, 36330, TIMESTAMP(CURDATE() - INTERVAL 6 DAY, '16:02:00')),
  (1072, NULL, 'Martín Gómez', 'martin.gomez@mail.com', '11 48489168', 'domicilio', 'Av. Siempre Viva', '130', NULL, '5500', 'Mendoza', 'Mendoza', 'tarjeta', 'cancelado', 97600, 0, 0, 97600, 47800, 49800, TIMESTAMP(CURDATE() - INTERVAL 5 DAY, '14:34:00')),
  (1073, NULL, 'Sofía Rodríguez', 'sofia.rodriguez@mail.com', '11 48497087', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'tarjeta', 'entregado', 45800, 0, 0, 45800, 22400, 23400, TIMESTAMP(CURDATE() - INTERVAL 5 DAY, '13:25:00')),
  (1074, NULL, 'Nicolás Álvarez', 'nicolas.alvarez@mail.com', '11 48505006', 'domicilio', 'Av. Siempre Viva', '2290', NULL, '2000', 'Rosario', 'Santa Fe', 'tarjeta', 'entregado', 70800, 0, 0, 70800, 35600, 35200, TIMESTAMP(CURDATE() - INTERVAL 5 DAY, '10:56:00')),
  (1075, NULL, 'Agustina Torres', 'agustina.torres@mail.com', '11 48512925', 'domicilio', 'Av. Siempre Viva', '1271', NULL, '5000', 'Córdoba', 'Córdoba', 'tarjeta', 'entregado', 118600, 0, 0, 118600, 59800, 58800, TIMESTAMP(CURDATE() - INTERVAL 5 DAY, '20:36:00')),
  (1076, 1, 'Cliente Demo', 'demo@tienda.com', '11 48520844', 'domicilio', 'Av. Siempre Viva', '977', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'transferencia', 'enviado', 63800, 6380, 0, 57420, 32800, 24620, TIMESTAMP(CURDATE() - INTERVAL 4 DAY, '15:01:00')),
  (1077, NULL, 'Lucía Fernández', 'lucia.fernandez@mail.com', '11 48528763', 'domicilio', 'Av. Siempre Viva', '3297', NULL, '5500', 'Mendoza', 'Mendoza', 'tarjeta', 'enviado', 27900, 0, 4500, 32400, 13400, 14500, TIMESTAMP(CURDATE() - INTERVAL 4 DAY, '09:02:00')),
  (1078, 1, 'Cliente Demo', 'demo@tienda.com', '11 48536682', 'domicilio', 'Av. Siempre Viva', '1955', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'transferencia', 'entregado', 51800, 5180, 4500, 51120, 25700, 20920, TIMESTAMP(CURDATE() - INTERVAL 3 DAY, '17:06:00')),
  (1079, NULL, 'Camila Martínez', 'camila.martinez@mail.com', '11 48544601', 'retiro', NULL, NULL, NULL, NULL, NULL, NULL, 'transferencia', 'enviado', 28900, 2890, 0, 26010, 14500, 11510, TIMESTAMP(CURDATE() - INTERVAL 3 DAY, '14:58:00')),
  (1080, NULL, 'Micaela Ortiz', 'micaela.ortiz@mail.com', '11 48552520', 'domicilio', 'Av. Siempre Viva', '2339', NULL, '1405', 'CABA', 'Ciudad Autónoma de Buenos Aires', 'transferencia', 'entregado', 64800, 6480, 0, 58320, 32200, 26120, TIMESTAMP(CURDATE() - INTERVAL 3 DAY, '10:07:00'));

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

-- ── Renglones de los pedidos (150) ─────────────────────────
INSERT INTO pedido_items (pedido_id, producto_id, nombre, color, talle, precio, costo, cantidad) VALUES
  (1001, 23, 'Aros Perla', 'Blanco', NULL, 8900, 3600, 1),
  (1001, 13, 'Pantalón Recto Negro', 'Negro', 'L', 33900, 17000, 1),
  (1001, 4, 'Top Siena', 'Negro', 'XL', 22900, 11200, 1),
  (1002, 4, 'Top Siena', 'Negro', 'M', 22900, 11200, 1),
  (1002, 1, 'Blusa Romana', 'Rosa', 'L', 28900, 14500, 1),
  (1003, 4, 'Top Siena', 'Beige', 'M', 22900, 11200, 1),
  (1003, 16, 'Vestido Aura', 'Negro', 'L', 32900, 16800, 1),
  (1003, 13, 'Pantalón Recto Negro', 'Negro', 'L', 33900, 17000, 1),
  (1004, 6, 'Top Halter', 'Rosa', 'XS', 19900, 9400, 2),
  (1004, 23, 'Aros Perla', 'Blanco', NULL, 8900, 3600, 1),
  (1004, 12, 'Pantalón Palazzo', 'Negro', 'M', 36900, 18800, 2),
  (1005, 4, 'Top Siena', 'Beige', 'XL', 22900, 11200, 2),
  (1006, 8, 'Blazer Clásico', 'Beige', 'M', 42900, 22800, 1),
  (1006, 24, 'Collar Dorado', 'Dorado', NULL, 11900, 4800, 1),
  (1007, 21, 'Cartera Mini', 'Negro', NULL, 27900, 13400, 1),
  (1008, 17, 'Vestido Elegance', 'Negro', 'XL', 38900, 19900, 2),
  (1009, 5, 'Top Básico', 'Blanco', 'L', 18900, 8900, 1),
  (1009, 22, 'Cinto Cuero', 'Marrón', NULL, 12900, 5800, 1),
  (1009, 1, 'Blusa Romana', 'Blanco', 'XL', 28900, 14500, 2),
  (1010, 18, 'Vestido Midi Lino', 'Beige', 'XS', 36900, 18700, 1),
  (1011, 24, 'Collar Dorado', 'Dorado', NULL, 11900, 4800, 2),
  (1011, 4, 'Top Siena', 'Beige', 'XL', 22900, 11200, 1),
  (1012, 6, 'Top Halter', 'Negro', 'XL', 19900, 9400, 1),
  (1012, 2, 'Blusa Satén', 'Rosa', 'XL', 29900, 15200, 1),
  (1013, 14, 'Palazzo Blanco', 'Blanco', 'XS', 35900, 18100, 1),
  (1014, 15, 'Jean Mom', 'Celeste', 'XS', 38900, 19400, 1),
  (1015, 4, 'Top Siena', 'Beige', 'S', 22900, 11200, 1),
  (1015, 3, 'Camisa Lino', 'Blanco', 'L', 31900, 16400, 1),
  (1016, 8, 'Blazer Clásico', 'Negro', 'XL', 42900, 22800, 1),
  (1016, 6, 'Top Halter', 'Negro', 'XS', 19900, 9400, 1),
  (1017, 17, 'Vestido Elegance', 'Negro', 'XS', 38900, 19900, 1),
  (1018, 19, 'Vestido Corto Blanco', 'Blanco', 'L', 29900, 14900, 2),
  (1019, 24, 'Collar Dorado', 'Dorado', NULL, 11900, 4800, 1),
  (1019, 16, 'Vestido Aura', 'Negro', 'XL', 32900, 16800, 1),
  (1019, 3, 'Camisa Lino', 'Blanco', 'XL', 31900, 16400, 1),
  (1020, 4, 'Top Siena', 'Beige', 'L', 22900, 11200, 1),
  (1021, 7, 'Top Rib', 'Rosa', 'S', 17900, 8200, 1),
  (1022, 1, 'Blusa Romana', 'Rosa', 'S', 28900, 14500, 1),
  (1022, 4, 'Top Siena', 'Blanco', 'L', 22900, 11200, 1),
  (1023, 11, 'Pantalón Sastrero', 'Negro', 'XL', 34900, 17500, 1),
  (1023, 13, 'Pantalón Recto Negro', 'Negro', 'XL', 33900, 17000, 1),
  (1023, 18, 'Vestido Midi Lino', 'Beige', 'XS', 36900, 18700, 1),
  (1024, 16, 'Vestido Aura', 'Negro', 'M', 32900, 16800, 1),
  (1025, 10, 'Blazer Negro', 'Negro', 'S', 43900, 23200, 1),
  (1026, 4, 'Top Siena', 'Negro', 'XS', 22900, 11200, 1),
  (1026, 19, 'Vestido Corto Blanco', 'Blanco', 'L', 29900, 14900, 2),
  (1026, 11, 'Pantalón Sastrero', 'Beige', 'XL', 34900, 17500, 1),
  (1027, 12, 'Pantalón Palazzo', 'Beige', 'M', 36900, 18800, 2),
  (1027, 7, 'Top Rib', 'Beige', 'M', 17900, 8200, 1),
  (1027, 24, 'Collar Dorado', 'Dorado', NULL, 11900, 4800, 1),
  (1028, 15, 'Jean Mom', 'Celeste', 'M', 38900, 19400, 2),
  (1028, 19, 'Vestido Corto Blanco', 'Blanco', 'L', 29900, 14900, 1),
  (1028, 4, 'Top Siena', 'Beige', 'S', 22900, 11200, 1),
  (1029, 6, 'Top Halter', 'Negro', 'S', 19900, 9400, 2),
  (1029, 12, 'Pantalón Palazzo', 'Negro', 'L', 36900, 18800, 1),
  (1029, 15, 'Jean Mom', 'Celeste', 'XL', 38900, 19400, 1),
  (1030, 11, 'Pantalón Sastrero', 'Beige', 'XS', 34900, 17500, 2),
  (1031, 4, 'Top Siena', 'Negro', 'XS', 22900, 11200, 1),
  (1031, 19, 'Vestido Corto Blanco', 'Blanco', 'XS', 29900, 14900, 1),
  (1032, 11, 'Pantalón Sastrero', 'Beige', 'L', 34900, 17500, 2),
  (1033, 7, 'Top Rib', 'Rosa', 'XL', 17900, 8200, 1),
  (1034, 16, 'Vestido Aura', 'Negro', 'XS', 32900, 16800, 1),
  (1035, 20, 'Vestido Seda Borravino', 'Borravino', 'S', 41900, 21500, 1),
  (1035, 5, 'Top Básico', 'Blanco', 'L', 18900, 8900, 1),
  (1036, 15, 'Jean Mom', 'Celeste', 'XS', 38900, 19400, 1),
  (1037, 21, 'Cartera Mini', 'Negro', NULL, 27900, 13400, 1),
  (1037, 4, 'Top Siena', 'Negro', 'L', 22900, 11200, 1),
  (1038, 17, 'Vestido Elegance', 'Negro', 'XS', 38900, 19900, 2),
  (1038, 8, 'Blazer Clásico', 'Negro', 'M', 42900, 22800, 1),
  (1039, 4, 'Top Siena', 'Beige', 'XL', 22900, 11200, 1),
  (1040, 16, 'Vestido Aura', 'Rosa', 'XL', 32900, 16800, 1),
  (1040, 12, 'Pantalón Palazzo', 'Beige', 'M', 36900, 18800, 2),
  (1041, 7, 'Top Rib', 'Beige', 'M', 17900, 8200, 1),
  (1041, 11, 'Pantalón Sastrero', 'Negro', 'M', 34900, 17500, 1),
  (1042, 13, 'Pantalón Recto Negro', 'Negro', 'XS', 33900, 17000, 1),
  (1042, 4, 'Top Siena', 'Negro', 'S', 22900, 11200, 1),
  (1043, 16, 'Vestido Aura', 'Negro', 'XL', 32900, 16800, 1),
  (1043, 20, 'Vestido Seda Borravino', 'Borravino', 'M', 41900, 21500, 1),
  (1043, 11, 'Pantalón Sastrero', 'Negro', 'L', 34900, 17500, 1),
  (1044, 15, 'Jean Mom', 'Celeste', 'S', 38900, 19400, 2),
  (1044, 6, 'Top Halter', 'Negro', 'XL', 19900, 9400, 1),
  (1044, 21, 'Cartera Mini', 'Negro', NULL, 27900, 13400, 1),
  (1045, 5, 'Top Básico', 'Blanco', 'S', 18900, 8900, 1),
  (1046, 5, 'Top Básico', 'Negro', 'M', 18900, 8900, 1),
  (1047, 21, 'Cartera Mini', 'Negro', NULL, 27900, 13400, 2),
  (1048, 16, 'Vestido Aura', 'Rosa', 'M', 32900, 16800, 1),
  (1048, 4, 'Top Siena', 'Blanco', 'XL', 22900, 11200, 1),
  (1048, 23, 'Aros Perla', 'Blanco', NULL, 8900, 3600, 1),
  (1049, 2, 'Blusa Satén', 'Rosa', 'XS', 29900, 15200, 2),
  (1050, 15, 'Jean Mom', 'Celeste', 'S', 38900, 19400, 2),
  (1051, 16, 'Vestido Aura', 'Rosa', 'XS', 32900, 16800, 2),
  (1051, 6, 'Top Halter', 'Rosa', 'XS', 19900, 9400, 1),
  (1051, 1, 'Blusa Romana', 'Blanco', 'M', 28900, 14500, 1),
  (1052, 16, 'Vestido Aura', 'Negro', 'XL', 32900, 16800, 1),
  (1052, 9, 'Blazer Rosa', 'Rosa', 'S', 44900, 24100, 1),
  (1053, 9, 'Blazer Rosa', 'Rosa', 'L', 44900, 24100, 1),
  (1053, 5, 'Top Básico', 'Blanco', 'L', 18900, 8900, 1),
  (1054, 1, 'Blusa Romana', 'Rosa', 'L', 28900, 14500, 1),
  (1054, 17, 'Vestido Elegance', 'Negro', 'XL', 38900, 19900, 1),
  (1054, 24, 'Collar Dorado', 'Dorado', NULL, 11900, 4800, 1),
  (1055, 10, 'Blazer Negro', 'Negro', 'XL', 43900, 23200, 1),
  (1055, 21, 'Cartera Mini', 'Negro', NULL, 27900, 13400, 1),
  (1056, 6, 'Top Halter', 'Negro', 'S', 19900, 9400, 1),
  (1056, 1, 'Blusa Romana', 'Blanco', 'S', 28900, 14500, 1),
  (1057, 2, 'Blusa Satén', 'Rosa', 'L', 29900, 15200, 1),
  (1057, 15, 'Jean Mom', 'Celeste', 'M', 38900, 19400, 2),
  (1057, 1, 'Blusa Romana', 'Rosa', 'L', 28900, 14500, 1),
  (1058, 8, 'Blazer Clásico', 'Negro', 'XL', 42900, 22800, 2),
  (1058, 16, 'Vestido Aura', 'Rosa', 'S', 32900, 16800, 1),
  (1058, 4, 'Top Siena', 'Blanco', 'XS', 22900, 11200, 2),
  (1059, 1, 'Blusa Romana', 'Blanco', 'XS', 28900, 14500, 1),
  (1059, 16, 'Vestido Aura', 'Rosa', 'XL', 32900, 16800, 1),
  (1059, 21, 'Cartera Mini', 'Negro', NULL, 27900, 13400, 1),
  (1060, 1, 'Blusa Romana', 'Rosa', 'S', 28900, 14500, 1),
  (1060, 16, 'Vestido Aura', 'Rosa', 'L', 32900, 16800, 1),
  (1061, 9, 'Blazer Rosa', 'Rosa', 'XS', 44900, 24100, 2),
  (1061, 19, 'Vestido Corto Blanco', 'Blanco', 'XS', 29900, 14900, 1),
  (1061, 10, 'Blazer Negro', 'Negro', 'M', 43900, 23200, 2),
  (1062, 1, 'Blusa Romana', 'Rosa', 'L', 28900, 14500, 1),
  (1062, 12, 'Pantalón Palazzo', 'Rosa', 'XL', 36900, 18800, 2),
  (1062, 20, 'Vestido Seda Borravino', 'Borravino', 'XS', 41900, 21500, 1),
  (1063, 1, 'Blusa Romana', 'Blanco', 'L', 28900, 14500, 1),
  (1063, 4, 'Top Siena', 'Beige', 'XS', 22900, 11200, 2),
  (1064, 1, 'Blusa Romana', 'Rosa', 'L', 28900, 14500, 1),
  (1064, 23, 'Aros Perla', 'Blanco', NULL, 8900, 3600, 2),
  (1065, 12, 'Pantalón Palazzo', 'Beige', 'XS', 36900, 18800, 1),
  (1066, 16, 'Vestido Aura', 'Negro', 'L', 32900, 16800, 2),
  (1067, 16, 'Vestido Aura', 'Rosa', 'S', 32900, 16800, 1),
  (1068, 21, 'Cartera Mini', 'Negro', NULL, 27900, 13400, 2),
  (1069, 5, 'Top Básico', 'Beige', 'M', 18900, 8900, 1),
  (1069, 7, 'Top Rib', 'Beige', 'S', 17900, 8200, 1),
  (1070, 18, 'Vestido Midi Lino', 'Beige', 'XL', 36900, 18700, 1),
  (1071, 6, 'Top Halter', 'Negro', 'M', 19900, 9400, 1),
  (1071, 10, 'Blazer Negro', 'Negro', 'S', 43900, 23200, 1),
  (1071, 1, 'Blusa Romana', 'Rosa', 'M', 28900, 14500, 1),
  (1072, 1, 'Blusa Romana', 'Blanco', 'M', 28900, 14500, 2),
  (1072, 6, 'Top Halter', 'Negro', 'XL', 19900, 9400, 2),
  (1073, 4, 'Top Siena', 'Negro', 'L', 22900, 11200, 2),
  (1074, 11, 'Pantalón Sastrero', 'Negro', 'L', 34900, 17500, 1),
  (1074, 14, 'Palazzo Blanco', 'Blanco', 'S', 35900, 18100, 1),
  (1075, 12, 'Pantalón Palazzo', 'Beige', 'M', 36900, 18800, 2),
  (1075, 3, 'Camisa Lino', 'Beige', 'XL', 31900, 16400, 1),
  (1075, 22, 'Cinto Cuero', 'Marrón', NULL, 12900, 5800, 1),
  (1076, 3, 'Camisa Lino', 'Beige', 'S', 31900, 16400, 2),
  (1077, 21, 'Cartera Mini', 'Negro', NULL, 27900, 13400, 1),
  (1078, 4, 'Top Siena', 'Beige', 'L', 22900, 11200, 1),
  (1078, 1, 'Blusa Romana', 'Blanco', 'XL', 28900, 14500, 1),
  (1079, 1, 'Blusa Romana', 'Rosa', 'XL', 28900, 14500, 1),
  (1080, 12, 'Pantalón Palazzo', 'Beige', 'XL', 36900, 18800, 1),
  (1080, 21, 'Cartera Mini', 'Negro', NULL, 27900, 13400, 1);

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
