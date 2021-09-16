-- ======================================================================================
-- Consulta 1 ->2
-- ======================================================================================
-- Mostrar la cantidad de copias que existen en el inventario para la pelÃ­cula
--SUGAR WONKA.
select count(pelicula.idpelicula) as total from inventario
inner join pelicula on pelicula.idpelicula = inventario.idpelicula
where pelicula.titulo = 'SUGAR WONKA'
;

-- ======================================================================================
-- Consulta 2 ->7
-- ======================================================================================
--Mostrar el nombre, apellido y pago total de todos los clientes que han rentado
--pelï¿½culas por lo menos 40 veces.
select name,lastname,quantity from(
select cliente.nombre as name,cliente.apellido as lastname,count(alquiler.idcliente)as quantity from cliente
inner join alquiler on cliente.idcliente = alquiler.idcliente
group by cliente.nombre,cliente.apellido) sub
where sub.quantity >= 40
;

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
;

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
where cantidad >= 2
;

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
order by actor.apellido asc
;


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
order by cantidad desc
;


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
;
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
)
;

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
;

-- ======================================================================================
-- Consulta 11
-- ======================================================================================
--Mostrar el paï¿½s y el nombre del cliente que mï¿½s pelï¿½culas rentï¿½ asï¿½ como
--tambiï¿½n el porcentaje que representa la cantidad de pelï¿½culas que rentï¿½ con
--respecto al resto de clientes del paï¿½s.
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
inner join pais on pais.idpais =  sub2.pa
;


-- ======================================================================================
-- Consulta 13 -> 113
-- ======================================================================================
--Mostrar el nombre del país, nombre del cliente y número de películas
--rentadas de todos los clientes que rentaron más películas por país. Si el
--número de películas máximo se repite, mostrar todos los valores que
--representa el máximo.
select sub1.pa as pais,sub1.nomb as nombre,sub1.tot as alquiler from(
    select pais.pais as pa,cliente.nombre||' '||cliente.apellido as nomb ,count(alquiler.idcliente)as tot from alquiler
    inner join cliente on cliente.idcliente = alquiler.idcliente
    inner join direccion on cliente.iddireccion = direccion.iddireccion
    inner join ciudad on direccion.idciudad = ciudad.idciudad
    inner join pais on ciudad.idpais = pais.idpais
    group by pais.pais,cliente.nombre||' '||cliente.apellido
    order by pa asc
)sub1
inner join (
    select sub3.pa as pais2,max(sub3.tot) as maximo from(
        select pais.pais as pa,count(alquiler.idcliente)as tot from alquiler
        inner join cliente on cliente.idcliente = alquiler.idcliente
        inner join direccion on cliente.iddireccion = direccion.iddireccion
        inner join ciudad on direccion.idciudad = ciudad.idciudad
        inner join pais on ciudad.idpais = pais.idpais
        group by pais.pais,cliente.nombre||' '||cliente.apellido
        order by pa asc
    )sub3
    group by sub3.pa
)sub2 on sub1.pa = sub2.pais2 and sub1.tot = sub2.maximo
;


-- ======================================================================================
-- Consulta 14 -> 256
-- ======================================================================================
--Mostrar todas las ciudades por país en las que predomina la renta de
--películas de la categoría “Horror”. Es decir, hay más rentas que las otras
--categorías.
select sub3.pais as pai,sub3.ci as ciud from(
    select categoria.descripcion as cat,pais.pais as pais,ciudad.ciudad as ci,count(alquiler.idalquiler) as tot from alquiler
    inner join pelicula on pelicula.idpelicula = alquiler.idpelicula
    inner join categoria_pelicula on categoria_pelicula.idpelicula = pelicula.idpelicula
    inner join categoria on categoria.idcategoria = categoria_pelicula.idcategoria
    inner join cliente on alquiler.idcliente = cliente.idcliente
    inner join direccion on cliente.iddireccion = direccion.iddireccion
    inner join ciudad on direccion.idciudad = ciudad.idciudad
    inner join pais on ciudad.idpais = pais.idpais
    where categoria.descripcion != 'Horror'
    group by categoria.descripcion,pais.pais,ciudad.ciudad
    order by pais.pais
)sub2
inner join (
    select categoria.descripcion as cat,pais.pais as pais,ciudad.ciudad as ci,count(alquiler.idalquiler) as tot from alquiler
    inner join pelicula on pelicula.idpelicula = alquiler.idpelicula
    inner join categoria_pelicula on categoria_pelicula.idpelicula = pelicula.idpelicula
    inner join categoria on categoria.idcategoria = categoria_pelicula.idcategoria
    inner join cliente on alquiler.idcliente = cliente.idcliente
    inner join direccion on cliente.iddireccion = direccion.iddireccion
    inner join ciudad on direccion.idciudad = ciudad.idciudad
    inner join pais on ciudad.idpais = pais.idpais
    where categoria.descripcion = 'Horror'
    group by categoria.descripcion,pais.pais,ciudad.ciudad
    order by pais.pais
)sub3 on sub2.pais = sub3.pais and sub3.tot>sub2.tot
group by sub3.pais,sub3.ci
;
-- ======================================================================================
-- Consulta 15 -> 108
-- ======================================================================================
--Mostrar el nombre del país, la ciudad y el promedio de rentas por ciudad. Por
--ejemplo: si el país tiene 3 ciudades, se deben sumar todas las rentas de la
--ciudad y dividirlo dentro de tres (número de ciudades del país).
select sub2.country,round((sub3.suma/sub2.tot),2)as promedio from(
    select pais.pais as country,count(ciudad.idciudad) as tot from pais
    inner join ciudad on pais.idpais = ciudad.idpais
    group by pais.pais
    order by country asc
)sub2
inner join(
    select sub1.idpa as paisid,sum(tot) as suma from(
        select pais.pais as idpa ,count(alquiler.idcliente)as tot from alquiler
        inner join cliente on cliente.idcliente = alquiler.idcliente
        inner join direccion on cliente.iddireccion = direccion.iddireccion
        inner join ciudad on direccion.idciudad = ciudad.idciudad
        inner join pais on ciudad.idpais = pais.idpais
        group by pais.pais
    )sub1 group by sub1.idpa
) sub3 on sub2.country = sub3.paisid

-- ======================================================================================
-- Consulta 16 -> 101
-- ======================================================================================
--Mostrar el nombre del país y el porcentaje de rentas de películas de la
--categoría “Sports”.
select sub2.country as pais,round((sub2.tot/sub3.suma),2) * 100 as porcentaje from(
    select pais.pais as country,count(alquiler.idcliente)as tot from alquiler
    inner join cliente on cliente.idcliente = alquiler.idcliente
    inner join direccion on cliente.iddireccion = direccion.iddireccion
    inner join ciudad on direccion.idciudad = ciudad.idciudad
    inner join pais on ciudad.idpais = pais.idpais
    inner join pelicula on pelicula.idpelicula = alquiler.idpelicula
    inner join categoria_pelicula on categoria_pelicula.idpelicula = pelicula.idpelicula
    inner join categoria on categoria_pelicula.idcategoria = categoria.idcategoria
    where categoria.descripcion = 'Sports'
    group by pais.pais
    order by country asc
)sub2
inner join(
    select sub1.idpa as paisid,sum(tot) as suma from(
        select pais.pais as idpa ,count(alquiler.idcliente)as tot from alquiler
        inner join cliente on cliente.idcliente = alquiler.idcliente
        inner join direccion on cliente.iddireccion = direccion.iddireccion
        inner join ciudad on direccion.idciudad = ciudad.idciudad
        inner join pais on ciudad.idpais = pais.idpais
        group by pais.pais
    )sub1 group by sub1.idpa
) sub3 on sub2.country = sub3.paisid
order by pais;

-- ======================================================================================
-- Consulta 17 -> 20
-- ======================================================================================
--Mostrar la lista de ciudades de Estados Unidos y el número de rentas de
--películas para las ciudades que obtuvieron más rentas que la ciudad
--“Dayton”.

select sub1.city,sub1.total from(
    select pais.pais as country,ciudad.ciudad as city,count(alquiler.idalquiler) as total from alquiler
    inner join cliente on alquiler.idcliente = cliente.idcliente
    inner join direccion on cliente.iddireccion = direccion.iddireccion
    inner join ciudad on direccion.idciudad = ciudad.idciudad
    inner join pais on ciudad.idpais = pais.idpais
    where pais.pais = 'United States'
    group by pais.pais,ciudad.ciudad
)sub1
inner join(
    select pais.pais as country,ciudad.ciudad as city,count(alquiler.idalquiler) as total from alquiler
    inner join cliente on alquiler.idcliente = cliente.idcliente
    inner join direccion on cliente.iddireccion = direccion.iddireccion
    inner join ciudad on direccion.idciudad = ciudad.idciudad
    inner join pais on ciudad.idpais = pais.idpais
    where pais.pais = 'United States' and ciudad.ciudad = 'Dayton'
    group by pais.pais,ciudad.ciudad
)sub2 on sub1.country = sub2.country
where sub1.total > sub2.total
order by sub1.city
;

-- ======================================================================================
-- Consulta 18 -> 2,904
-- ======================================================================================
--Mostrar el nombre, apellido y fecha de retorno de película a la tienda de todos
--los clientes que hayan rentado más de 2 películas que se encuentren en
--lenguaje Inglés en donde el empleado que se las vendió ganará más de 15
--dólares en sus rentas del día en la que el cliente rentó la película.
select cliente.nombre,cliente.apellido,trunc(alquiler.fechadevolucion) from alquiler
inner join cliente on cliente.idcliente = alquiler.idcliente
inner join(
    select empleado.idempleado as idemp,trunc(alquiler.fecharenta)as frenta from alquiler
    inner join empleado on alquiler.idempleado = empleado.idempleado
    group by empleado.idempleado,trunc(alquiler.fecharenta)
    having sum(alquiler.monto) > 15
)sub1 on sub1.idemp = alquiler.idempleado and sub1.frenta = trunc(alquiler.fecharenta)
inner join(
    select  cliente.idcliente as client,trunc(alquiler.fecharenta) as frenta from alquiler
    inner join cliente on alquiler.idcliente = cliente.idcliente
    inner join pelicula on alquiler.idpelicula = pelicula.idpelicula
    inner join lenguaje_pelicula on pelicula.idpelicula = lenguaje_pelicula.idpelicula
    inner join lenguaje on lenguaje_pelicula.idlenguaje = lenguaje.idlenguaje
    where lenguaje.descripcion like '%English%'
    group by cliente.idcliente,trunc(alquiler.fecharenta)
    having count(alquiler.idcliente) > 2
)sub2 on sub2.client = alquiler.idcliente and sub2.frenta = trunc(alquiler.fecharenta)
group by cliente.nombre,cliente.apellido,trunc(alquiler.fechadevolucion)
;
-- ======================================================================================
-- Consulta 19 -> 372
-- ======================================================================================
--Mostrar el número de mes, de la fecha de renta de la película, nombre y
--apellido de los clientes que más películas han rentado y las que menos en
--una sola consulta.
select sub2.mes,cliente.nombre,cliente.apellido,sub2.tot as total from(
    select  EXTRACT(MONTH FROM alquiler.fecharenta) as mes,cliente.idcliente as id, count(alquiler.idcliente) as tot from alquiler
    inner join cliente on alquiler.idcliente = cliente.idcliente
    group by cliente.idcliente, EXTRACT(MONTH FROM alquiler.fecharenta)
)sub2
inner join(
    select sub1.mes as months,max(sub1.tot) as total from alquiler 
    inner join(
        select  EXTRACT(MONTH FROM alquiler.fecharenta) as mes,cliente.idcliente as id, count(alquiler.idcliente) as tot from alquiler
        inner join cliente on alquiler.idcliente = cliente.idcliente
        group by cliente.idcliente, EXTRACT(MONTH FROM alquiler.fecharenta)
    )sub1 on alquiler.idcliente = sub1.id
    group by sub1.mes
)sub3 on sub2.mes = sub3.months and sub2.tot = sub3.total 
inner join cliente on sub2.id = cliente.idcliente
union all
select sub2.mes,cliente.nombre,cliente.apellido,sub2.tot from(
    select  EXTRACT(MONTH FROM alquiler.fecharenta) as mes,cliente.idcliente as id, count(alquiler.idcliente) as tot from alquiler
    inner join cliente on alquiler.idcliente = cliente.idcliente
    group by cliente.idcliente, EXTRACT(MONTH FROM alquiler.fecharenta)
)sub2
inner join(
    select sub1.mes as months,min(sub1.tot) as total from alquiler 
    inner join(
        select  EXTRACT(MONTH FROM alquiler.fecharenta) as mes,cliente.idcliente as id, count(alquiler.idcliente) as tot from alquiler
        inner join cliente on alquiler.idcliente = cliente.idcliente
        group by cliente.idcliente, EXTRACT(MONTH FROM alquiler.fecharenta)
    )sub1 on alquiler.idcliente = sub1.id
    group by sub1.mes
)sub3 on sub2.mes = sub3.months and sub2.tot = sub3.total 
inner join cliente on sub2.id = cliente.idcliente
;


-- ======================================================================================
-- Consulta 20
-- ======================================================================================
--Mostrar el porcentaje de lenguajes de películas más rentadas de cada ciudad
--durante el mes de julio del año 2005 de la siguiente manera: ciudad,
--lenguaje, porcentaje de renta.

















