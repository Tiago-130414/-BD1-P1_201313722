-- ======================================================================================
--PARA INSERTAR PAIS -> 109
-- ======================================================================================
insert into Pais(pais)
select distinct pais_cliente as country from temporal where temporal.pais_cliente is not null
union
select distinct pais_empleado as country from temporal where temporal.pais_empleado is not null
union
select distinct pais_tienda as country from temporal where temporal.pais_tienda is not null;

-- ======================================================================================
--PARA INSERTAR CIUDAD -> 600
-- ======================================================================================
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

-- ======================================================================================
--PARA INSERTAR DIRECCIONES -> 605
-- ======================================================================================
insert into direccion(direccion,codigopostal,idciudad)
select distinct temporal.direccion_cliente as address,temporal.codigo_postal_cliente as postalcode, idCiudad as city from temporal
inner join Ciudad on ciudad.ciudad = temporal.ciudad_cliente
where temporal.direccion_cliente is not null
union
select distinct temporal.direccion_empleado as address,temporal.codigo_postal_empleado as postalcode, idCiudad as city from temporal
inner join Ciudad on ciudad.ciudad = temporal.ciudad_empleado
where temporal.direccion_empleado is not null and temporal.codigo_postal_empleado is not null
union
select distinct temporal.direccion_tienda as address,temporal.codigo_postal_tienda as postalcode, idCiudad as city from temporal
inner join Ciudad on ciudad.ciudad = temporal.ciudad_tienda
where temporal.direccion_tienda is not null and temporal.codigo_postal_tienda is not null
;

-- ======================================================================================
--PARA INSERTAR TIENDA -> 2
-- ======================================================================================
insert into tienda(nombre,iddireccion)
select distinct temporal.nombre_tienda as nombre,direccion.iddireccion as dir from temporal
inner join direccion on direccion.direccion = temporal.direccion_tienda
where temporal.nombre_tienda is not null
;

-- ======================================================================================
--PARA INSERTAR ACTORES -> 199
-- ======================================================================================
insert into actor(nombre,apellido)
SELECT  distinct SUBSTR(temporal.actor_pelicula, 1, INSTR(temporal.actor_pelicula,' ')-1) AS nombre, SUBSTR(temporal.actor_pelicula, INSTR(temporal.actor_pelicula, ' ')+1) AS apellido
FROM temporal where actor_pelicula is not null;

-- ======================================================================================
--PARA INSERTAR EN CLASIFICACION -> 5
-- ======================================================================================
insert into Clasificacion(descripcion)
select distinct clasificacion from temporal where clasificacion is not null;

-- ======================================================================================
--PARA INSERTAR EN CATEGORIA -> 16
-- ======================================================================================
insert into Categoria (descripcion)
select distinct categoria_pelicula from temporal where categoria_pelicula is not null;

-- ======================================================================================
--PARA INSERTAR EN LENGUAJE -> 6
-- ======================================================================================
insert into Lenguaje(descripcion)
select distinct lenguaje_pelicula from temporal where lenguaje_pelicula is not null;

-- ======================================================================================
--PARA INSERTAR ESTADO CLIENTE_ACTIVO,EMPLEADO_ACTIVO -> 2
-- ======================================================================================
insert into Estado(estado)
select distinct cliente_activo as estado from temporal where cliente_activo is not null
union
select distinct empleado_activo as estado from temporal where empleado_activo is not null;

-- ======================================================================================
--PARA INSERTAR PELICULA -> 1,000
-- ======================================================================================
insert into Pelicula (titulo,descripcion,anolanzamiento,duracion,costoalquiler,costodano,tiempoalquiler,idclasificacion)
select distinct temporal.nombre_pelicula, temporal.descripcion_pelicula, temporal.ano_lanzamiento,temporal.dias_renta, temporal.costo_renta,temporal.duracion,temporal.costo_por_dano, clasificacion.idClasificacion
from temporal
inner join Clasificacion on clasificacion.descripcion = temporal.clasificacion
where temporal.nombre_pelicula is not null and temporal.clasificacion is not null;

-- ======================================================================================
--PARA INSERTAR CATEGORIA_PELICULA -> 1,000
-- ======================================================================================
insert into categoria_pelicula (idcategoria,idPelicula)
select distinct Categoria.idCategoria, Pelicula.idPelicula from temporal
inner join Categoria on categoria.descripcion = temporal.categoria_pelicula
inner join Pelicula on pelicula.titulo = temporal.nombre_pelicula;

-- ======================================================================================
--PARA INSERTAR PELICULA_ACTOR -> 5462
-- ======================================================================================
insert into pelicula_actor(idpelicula,idactor)
select distinct pelicula.idpelicula,actor.idactor from temporal
inner join Pelicula on pelicula.titulo = temporal.nombre_pelicula
inner join Actor on actor.nombre||' '||actor.apellido = temporal.actor_pelicula 
;

-- ======================================================================================
--PARA INSERTAR LENGUAJE_PELICULA -> 1,000
-- ======================================================================================
insert into lenguaje_pelicula(idlenguaje,idpelicula)
select distinct lenguaje.idlenguaje,pelicula.idpelicula from temporal
inner join lenguaje on lenguaje.descripcion = temporal.lenguaje_pelicula
inner join pelicula on pelicula.titulo = temporal.nombre_pelicula;

-- ======================================================================================
--PARA INSERTAR INVENTARIO -> 1521
-- ======================================================================================
insert into inventario (idpelicula,idtienda)
select distinct pelicula.idpelicula, tienda.idtienda from temporal
inner join tienda on tienda.nombre = temporal.tienda_pelicula
inner join pelicula on pelicula.titulo = temporal.nombre_pelicula;

-- ======================================================================================
--PARA INSERTAR EN PUESTO
-- ======================================================================================
insert into puesto(descripcion) values ('No Encargado');
insert into puesto(descripcion) values ('Encargado');

-- ======================================================================================
--PARA INSERTAR EMPLEADO ->2
-- ======================================================================================
insert into empleado (nombre,apellido,correoElectronico,usuario,contrasena,idtienda,iddireccion,idestado,idPuesto)
select  distinct SUBSTR(temporal.nombre_empleado, 1, INSTR(temporal.nombre_empleado,' ')-1) AS nombre, 
SUBSTR(temporal.nombre_empleado, INSTR(temporal.nombre_empleado, ' ')+1) AS apellido,
temporal.correo_empleado as mail,
temporal.usuario_empleado as username,
temporal.contrasena_empleado as pass,
tienda.idtienda as store,
direccion.iddireccion as direction,
estado.idestado as estado,
CASE WHEN temporal.nombre_empleado = temporal.encargado_tienda then 2 ELSE 1 END as encargado
FROM temporal 
inner join tienda on tienda.nombre = temporal.tienda_empleado
inner join direccion on direccion.direccion = temporal.direccion_empleado
inner join estado on estado.estado = temporal.empleado_activo
where temporal.nombre_empleado is not null;

-- ======================================================================================
--PARA INSERTAR CLIENTE -> 599
-- ======================================================================================
insert into cliente (nombre,apellido,correoElectronico,fecharegistro,idestado,iddireccion,idtienda)
select  distinct SUBSTR(temporal.nombre_cliente, 1, INSTR(temporal.nombre_cliente,' ')-1) AS nombre, 
SUBSTR(temporal.nombre_cliente, INSTR(temporal.nombre_cliente, ' ')+1) AS apellido,
temporal.correo_cliente as mail,
temporal.fecha_creacion as registro,
estado.idestado as estado,
direccion.iddireccion as iddir,
tienda.idtienda as store
from temporal
inner join tienda on tienda.nombre = temporal.tienda_preferida
inner join estado on estado.estado = temporal.cliente_activo
inner join direccion on temporal.direccion_cliente = direccion.direccion
inner join ciudad on direccion.idciudad = ciudad.idciudad
inner join pais on pais.idpais = ciudad.idpais
where temporal.nombre_cliente is not null and pais.pais = temporal.pais_cliente and ciudad.ciudad = temporal.ciudad_cliente;

-- ======================================================================================
--PARA INSERTAR ALQUILER -> 16,044
-- ======================================================================================
select * from temporal;
insert into alquiler(monto,fechapago,fecharenta,fechadevolucion,idtienda,idcliente)
select distinct temporal.monto_a_pagar,temporal.fecha_pago,temporal.fecha_renta, temporal.fecha_retorno,tienda.idtienda as tienda,cliente.idcliente as client from temporal
inner join cliente on cliente.nombre ||' '||cliente.apellido = temporal.nombre_cliente
inner join tienda on tienda.nombre = temporal.tienda_preferida
where temporal.fecha_renta is not null and temporal.monto_a_pagar is not null;

-- ======================================================================================
--PARA INSERTAR PELICULA_ALQUILER -> 52,103
-- ======================================================================================
select distinct pelicula.idpelicula,alquiler.idalquiler from temporal
inner join pelicula on pelicula.titulo = temporal.nombre_pelicula
inner join alquiler on alquiler.fecharenta = temporal.fecha_renta;

