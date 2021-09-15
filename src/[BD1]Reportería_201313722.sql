-- ======================================================================================
-- Consulta 1 ->2
-- ======================================================================================
-- Mostrar la cantidad de copias que existen en el inventario para la pelÃ­cula
--SUGAR WONKA.
select count(pelicula.idpelicula) as total from inventario
inner join pelicula on pelicula.idpelicula = inventario.idpelicula
where pelicula.titulo = 'SUGAR WONKA';

-- ======================================================================================
-- Consulta 2 ->7
-- ======================================================================================
--Mostrar el nombre, apellido y pago total de todos los clientes que han rentado
--pelï¿½culas por lo menos 40 veces.
select name,lastname,quantity from(
select cliente.nombre as name,cliente.apellido as lastname,count(alquiler.idcliente)as quantity from cliente
inner join alquiler on cliente.idcliente = alquiler.idcliente
group by cliente.nombre,cliente.apellido) sub
where sub.quantity >= 40;

-- ======================================================================================
-- Consulta 3 -> 6,550
-- ======================================================================================
--Mostrar el nombre y apellido del cliente y el nombre de la pelï¿½cula de todos
--aquellos clientes que hayan rentado una pelï¿½cula y no la hayan devuelto y
--donde la fecha de alquiler estï¿½ mï¿½s allï¿½ de la especificada por la pelï¿½cula.
select name,lastname,title from(
select cliente.nombre as name,cliente.apellido as lastname,pelicula.titulo as title,EXTRACT(DAY FROM alquiler.fechadevolucion - alquiler.fecharenta)as tiempo,pelicula.tiempoalquiler as tiempopermitido from pelicula
inner join alquiler on alquiler.idpelicula = pelicula.idpelicula
inner join cliente on cliente.idcliente = alquiler.idcliente
where alquiler.fechadevolucion is not null
) where tiempo > tiempopermitido
union
select cliente.nombre as name,cliente.apellido as lastname,pelicula.titulo as title from pelicula
inner join alquiler on alquiler.idpelicula = pelicula.idpelicula
inner join cliente on cliente.idcliente = alquiler.idcliente
where alquiler.fechadevolucion is null


-- ======================================================================================
-- Consulta 4 -> 9
-- ======================================================================================
--Mostrar el nombre y apellido (en una sola columna) de los actores que
--contienen la palabra ï¿½SONï¿½ en su apellido, ordenados por su primer nombre.

select actor.nombre||' '||actor.apellido as Informacion from actor
where instr(actor.apellido,'son')>0
order by actor.nombre
;

-- ======================================================================================
-- Consulta 5 -> 55
-- ======================================================================================
--Mostrar el apellido de todos los actores y la cantidad de actores que tienen
--ese apellido pero solo para los que comparten el mismo nombre por lo menos
--con dos actores.
select apellido,cantidad from(
select actor.apellido as apellido, count(actor.apellido) as cantidad from actor
group by actor.apellido)
where cantidad >= 2;

-- ======================================================================================
-- Consulta 6 -> 58
-- ======================================================================================
--Mostrar el nombre y apellido de los actores que participaron en una pelï¿½cula
--que involucra un ï¿½Cocodriloï¿½ y un ï¿½Tiburï¿½nï¿½ junto con el aï¿½o de lanzamiento
--de la pelï¿½cula, ordenados por el apellido del actor en forma ascendente.

select actor.nombre,actor.apellido,pelicula.anolanzamiento from pelicula
inner join pelicula_actor on pelicula_actor.idpelicula = pelicula.idpelicula
inner join actor on pelicula_actor.idactor = actor.idactor
where instr(pelicula.descripcion,'Crocodile')>0 and instr(pelicula.descripcion,'Shark')>0
order by actor.apellido asc;


-- ======================================================================================
-- Consulta 7 -> 10
-- ======================================================================================
--Mostrar el nombre de la categorï¿½a y el nï¿½mero de pelï¿½culas por categorï¿½a de
--todas las categorï¿½as de pelï¿½culas en las que hay entre 55 y 65 pelï¿½culas.
--Ordenar el resultado por nï¿½mero de pelï¿½culas de forma descendente.
select nombre,cantidad from(
select categoria.descripcion as nombre,count(*) as cantidad from pelicula
inner join categoria_pelicula on categoria_pelicula.idpelicula = pelicula.idpelicula
inner join categoria on categoria_pelicula.idcategoria = categoria.idcategoria
group by categoria.descripcion)
where cantidad >55 and cantidad <65
order by cantidad desc;


-- ======================================================================================
-- Consulta 8 -> 8
-- ======================================================================================
--Mostrar todas las categorï¿½as de pelï¿½culas en las que la diferencia promedio
--entre el costo de reemplazo de la pelï¿½cula y el precio de alquiler sea superior
--a 17.
select nombre,diferencia from(
select categoria.descripcion as nombre,round(avg(pelicula.costodano - pelicula.costoalquiler),2) as diferencia from pelicula
inner join categoria_pelicula on categoria_pelicula.idpelicula = pelicula.idpelicula
inner join categoria on categoria_pelicula.idcategoria = categoria.idcategoria
group by categoria.descripcion
)dif
where dif.diferencia > 17

-- ======================================================================================
-- Consulta 9 -> 5462
-- ======================================================================================
--Mostrar el tï¿½tulo de la pelï¿½cula, el nombre y apellido del actor de todas
--aquellas pelï¿½culas en las que uno o mï¿½s actores actuaron en dos o mï¿½s
--pelï¿½culas.
select sb1.title,sb1.name,sb1.lastname from(
select pelicula.titulo as title,actor.idactor as id,actor.nombre as name,actor.apellido as lastname from pelicula_actor
inner join actor on actor.idactor = pelicula_actor.idactor
inner join pelicula on pelicula.idpelicula = pelicula_actor.idpelicula
)sb1
where sb1.id in (
select actor.idactor as id2 from pelicula_actor
inner join actor on actor.idactor = pelicula_actor.idactor
inner join pelicula on pelicula.idpelicula = pelicula_actor.idpelicula
group by actor.idactor having count(*) >= 2
);

-- ======================================================================================
-- Consulta 10 -> 3
-- ======================================================================================
--Mostrar el nombre y apellido (en una sola columna) de todos los actores y
--clientes cuyo primer nombre sea el mismo que el primer nombre del actor con
--ID igual a 8. No debe retornar el nombre del actor con ID igual a 8
--dentro de la consulta. No puede utilizar el nombre del actor como una
--constante, ï¿½nicamente el ID proporcionado.

select cliente.nombre||' '||cliente.apellido as nombre from cliente
inner join (
select actor.nombre as nom, actor.apellido as ape from actor
where actor.idactor = 8
)sb on cliente.nombre = sb.nom 
union all
select actor.nombre||' '||actor.apellido from actor
inner join (
select actor.nombre as nom, actor.apellido as ape from actor
where actor.idactor = 8
)sb on actor.nombre = sb.nom

-- ======================================================================================
-- Consulta 11
-- ======================================================================================
--Mostrar el país y el nombre del cliente que más películas rentó así como
--también el porcentaje que representa la cantidad de películas que rentó con
--respecto al resto de clientes del país.

select cliente.nombre||' '||cliente.apellido as nombre,pais.pais,(sub2.tot/sub3.suma) * 100 as porcentaje from(
        select alquiler.idcliente as id,pais.idpais as pa,count(alquiler.idcliente)as tot from alquiler
        inner join cliente on cliente.idcliente = alquiler.idcliente
        inner join direccion on cliente.iddireccion = direccion.iddireccion
        inner join ciudad on direccion.idciudad = ciudad.idciudad
        inner join pais on ciudad.idpais = pais.idpais
        group by alquiler.idcliente,pais.idpais
        order by tot desc fetch first 1 row only
    )sub2
    inner join(
        select sub1.idpa as paisid,sum(tot) as suma from(
        select pais.idpais as idpa ,count(alquiler.idcliente)as tot from alquiler
        inner join cliente on cliente.idcliente = alquiler.idcliente
        inner join direccion on cliente.iddireccion = direccion.iddireccion
        inner join ciudad on direccion.idciudad = ciudad.idciudad
        inner join pais on ciudad.idpais = pais.idpais
        group by pais.idpais
    )sub1 group by sub1.idpa
)sub3 on sub2.pa = sub3.paisid
inner join cliente on cliente.idcliente = sub2.id
inner join pais on pais.idpais =  sub2.pa;
