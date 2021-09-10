-- ======================================================================================
-- CONTEO POR TABLAS
-- ======================================================================================
select 'Lenguaje' as encabezado,count(*) as cantidad from lenguaje
union all
select 'Lenguaje_Pelicula',count(*) from lenguaje_pelicula
union all
select 'Clasificacion',count(*) from clasificacion
union all
select 'Actor',count(*) from actor
union all
select 'Pelicula_Actor',count(*) from pelicula_actor
union all
select 'Actor',count(*) from actor
union all
select 'Pelicula',count(*) from pelicula
union all
select 'Pelicula_Alquiler',count(*) from pelicula_alquiler
union all
select 'Categoria',count(*) from categoria
union all
select 'Categoria_Pelicula',count(*) from categoria_pelicula
union all
select 'Alquiler',count(*) from alquiler
union all
select 'Inventario',count(*) from inventario
union all
select 'Tienda',count(*) from tienda
union all
select 'Empleado',count(*) from empleado
union all
select 'Puesto',count(*) from puesto
union all
select 'Cliente',count(*) from cliente
union all
select 'Estado',count(*) from estado
union all
select 'Direccion',count(*) from direccion
union all
select 'Ciudad',count(*) from ciudad
union all
select 'Pais',count(*) from pais
;