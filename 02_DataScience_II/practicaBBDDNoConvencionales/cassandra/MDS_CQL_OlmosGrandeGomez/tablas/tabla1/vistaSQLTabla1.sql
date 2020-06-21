SELECT a.name, a.species, a.varietal, a.provenance, a.toast, a.process, b.formatt
FROM PRODUCT a, FORMATS b WHERE a.name = b.product
