-- Talles de ropa: productos.talles ("XS,S,M,L,XL") y el talle elegido en cada renglón del pedido.
-- La app también agrega estas columnas sola al arrancar.
ALTER TABLE productos     ADD COLUMN talles VARCHAR(60) NULL AFTER stock;
ALTER TABLE pedido_items  ADD COLUMN talle  VARCHAR(20) NULL AFTER color;
