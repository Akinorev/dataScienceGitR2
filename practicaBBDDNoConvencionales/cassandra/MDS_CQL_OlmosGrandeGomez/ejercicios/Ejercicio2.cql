INSERT INTO practica.PRODUCTS_CHAR_FORMAT (name, format, process, provenance, species, toast, varietal) VALUES ('Antes', 'capsules', 'normal', 'Brasil', 'Arabica', 'natural', 'Maragogype');
INSERT INTO practica.PRODUCTS_CHAR_FORMAT (name, format, process, provenance, species, toast, varietal) VALUES ('Antes', 'ground', 'normal', 'Brasil', 'Arabica', 'natural', 'Maragogype');
INSERT INTO practica.PRODUCTS_CHAR_FORMAT (name, format, process, provenance, species, toast, varietal) VALUES ('Antes', 'prepared', 'normal', 'Brasil', 'Arabica', 'natural', 'Maragogype');
INSERT INTO practica.PRODUCTS_CHAR_FORMAT (name, format, process, provenance, species, toast, varietal) VALUES ('Antes', 'roasted bean', 'normal', 'Brasil', 'Arabica', 'natural', 'Maragogype');

INSERT INTO practica.PRODUCTS_FORMAT_REFS (product, format, barcode, maxstock, minstock, pack, price, stock) VALUES ('Antes', 'ground', 'IOI36746I421868', '4340', '270', 'pkg 200 g.', '24,15','2533');
INSERT INTO practica.PRODUCTS_FORMAT_REFS (product, format, barcode, maxstock, minstock, pack, price, stock) VALUES ('Antes', 'ground', 'QQI47782I728991', '1500', '30', 'pkg 1 Kg.', '96,18','300');
INSERT INTO practica.PRODUCTS_FORMAT_REFS (product, format, barcode, maxstock, minstock, pack, price, stock) VALUES ('Antes', 'capsules', 'OQI73010I681542', '4210', '80', 'pkg 25 un.', '2,9','2387');
INSERT INTO practica.PRODUCTS_FORMAT_REFS (product, format, barcode, maxstock, minstock, pack, price, stock) VALUES ('Antes', 'capsules', 'QII79718I227817', '4080', '220', 'pkg 10 un.', '1,86','2393');
INSERT INTO practica.PRODUCTS_FORMAT_REFS (product, format, barcode, maxstock, minstock, pack, price, stock) VALUES ('Antes', 'roasted bean', 'OQI67128I901745', '2420', '410', 'pkg 200 g.', '9,5','900');
INSERT INTO practica.PRODUCTS_FORMAT_REFS (product, format, barcode, maxstock, minstock, pack, price, stock) VALUES ('Antes', 'roasted bean', 'OQQ50976Q123543', '4050', '320', 'pkg 1 Kg.', '36,03','2124');
INSERT INTO practica.PRODUCTS_FORMAT_REFS (product, format, barcode, maxstock, minstock, pack, price, stock) VALUES ('Antes', 'prepared', 'OQO17188Q460551', '4630', '260', 'can 330 ml.', '3,99','4088');
INSERT INTO practica.PRODUCTS_FORMAT_REFS (product, format, barcode, maxstock, minstock, pack, price, stock) VALUES ('Antes', 'prepared', 'QIO44629Q878316', '4300', '210', 'cup 200 ml.', '2,7','2701');

DELETE FROM practica.PRODUCTS_CHAR_FORMAT WHERE NAME='Son antes';
DELETE FROM practica.PRODUCTS_FORMAT_REFS WHERE PRODUCT='Son antes' and FORMAT='ground';
DELETE FROM practica.PRODUCTS_FORMAT_REFS WHERE PRODUCT='Son antes' and FORMAT='capsules';
DELETE FROM practica.PRODUCTS_FORMAT_REFS WHERE PRODUCT='Son antes' and FORMAT='prepared';
DELETE FROM practica.PRODUCTS_FORMAT_REFS WHERE PRODUCT='Son antes' and FORMAT='roasted bean';
