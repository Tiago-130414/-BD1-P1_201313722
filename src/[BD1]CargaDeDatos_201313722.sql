select * from temporal;

--PARA INSERTAR PAIS -> 109
insert into Pais(pais)
select distinct pais_cliente as country from temporal where temporal.pais_cliente is not null
union
select distinct pais_empleado as country from temporal where temporal.pais_empleado is not null
union
select distinct pais_tienda as country from temporal where temporal.pais_tienda is not null;
select * from pais;

--PARA INSERTAR CIUDAD -> 600
insert into Ciudad (ciudad,idPais)
select distinct temporal.ciudad_cliente as ciudad,idpais as pais from temporal
inner join Pais on Pais.pais = temporal.pais_cliente
where temporal.ciudad_cliente is not null
union
select distinct temporal.ciudad_empleado as ciudad,idpais as pais from temporal
inner join Pais on Pais.pais = temporal.pais_empleado
where temporal.ciudad_empleado is not null
union
select distinct temporal.ciudad_tienda as ciudad,idpais as pais from temporal
inner join Pais on Pais.pais = temporal.pais_tienda
where temporal.ciudad_tienda is not null
;

--PARA INSERTAR DIRECCIONES
select distinct temporal.direccion_cliente, idCiudad,temporal.codigo_postal_cliente from temporal
inner join Ciudad on ciudad.ciudad = temporal.ciudad_cliente
where temporal.direccion_cliente is not null and temporal.codigo_postal_cliente is not null
union
select distinct temporal.direccion_empleado, idCiudad,temporal.codigo_postal_empleado from temporal
inner join Ciudad on ciudad.ciudad = temporal.ciudad_empleado
where temporal.direccion_empleado is not null and temporal.codigo_postal_empleado is not null
union
select distinct temporal.direccion_tienda, idCiudad,temporal.codigo_postal_tienda from temporal
inner join Ciudad on ciudad.ciudad = temporal.ciudad_tienda
where temporal.direccion_tienda is not null and temporal.codigo_postal_tienda is not null
;

--PARA INSERTAR ACTORES -> 199
insert into actor(nombre,apellido)
SELECT  distinct SUBSTR(temporal.actor_pelicula, 1, INSTR(temporal.actor_pelicula,' ')-1) AS nombre, SUBSTR(temporal.actor_pelicula, INSTR(temporal.actor_pelicula, ' ')+1) AS apellido
FROM temporal where actor_pelicula is not null;

--PARA INSERTAR EN CLASIFICACION -> 5
insert into Clasificacion(descripcion)
select distinct clasificacion from temporal where clasificacion is not null;

--PARA INSERTAR EN CATEGORIA -> 16
insert into Categoria (descripcion)
select distinct categoria_pelicula from temporal where categoria_pelicula is not null;

--PARA INSERTAR EN LENGUAJE -> 6
insert into Lenguaje(descripcion)
select distinct lenguaje_pelicula from temporal where lenguaje_pelicula is not null;

--PARA INSERTAR ESTADO CLIENTE_ACTIVO,EMPLEADO_ACTIVO -> 2
insert into Estado(estado)
select distinct cliente_activo as estado from temporal where cliente_activo is not null
union
select distinct empleado_activo as estado from temporal where empleado_activo is not null;

--PARA INSERTAR PELICULA -> 1,000
insert into Pelicula (titulo,descripcion,anolanzamiento,duracion,costoalquiler,costodano,tiempoalquiler,idclasificacion)
select distinct temporal.nombre_pelicula, temporal.descripcion_pelicula, temporal.ano_lanzamiento,temporal.dias_renta, temporal.costo_renta,temporal.duracion,temporal.costo_por_dano, clasificacion.idClasificacion
from temporal
inner join Clasificacion on clasificacion.descripcion = temporal.clasificacion
where temporal.nombre_pelicula is not null and temporal.clasificacion is not null;

--PARA INSERTAR CATEGORIA_PELICULA -> 1,000
insert into categoria_pelicula (idcategoria,idPelicula)
select distinct Categoria.idCategoria, Pelicula.idPelicula from temporal
inner join Categoria on categoria.descripcion = temporal.categoria_pelicula
inner join Pelicula on pelicula.titulo = temporal.nombre_pelicula;

--PARA INSERTAR PELICULA_ACTOR -> 5462
insert into pelicula_actor(idpelicula,idactor)
select distinct pelicula.idpelicula,actor.idactor from temporal
inner join Pelicula on pelicula.titulo = temporal.nombre_pelicula
inner join Actor on actor.nombre||' '||actor.apellido = temporal.actor_pelicula 
;

--PARA INSERTAR LENGUAJE_PELICULA -> 1,000
insert into lenguaje_pelicula(idlenguaje,idpelicula)
select distinct lenguaje.idlenguaje,pelicula.idpelicula from temporal
inner join lenguaje on lenguaje.descripcion = temporal.lenguaje_pelicula
inner join pelicula on pelicula.titulo = temporal.nombre_pelicula;

--PARA INSERTAR EN PUESTO (Falta completar)
select distinct encargado_tienda from temporal where encargado_tienda is not null;


