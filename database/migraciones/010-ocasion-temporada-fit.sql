-- Clasificaciones transversales del menú: ocasión, temporada y fit de cada producto.
-- La app también agrega estas columnas sola al arrancar.
ALTER TABLE productos ADD COLUMN ocasiones VARCHAR(80) NULL AFTER talles;
ALTER TABLE productos ADD COLUMN temporada VARCHAR(30) NULL AFTER ocasiones;
ALTER TABLE productos ADD COLUMN fit       VARCHAR(20) NULL AFTER temporada;
