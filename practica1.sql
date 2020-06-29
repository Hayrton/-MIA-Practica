/*--------------------------------------------------------------------*/
/*Eliminacion de tablas*/
/*--------------------------------------------------------------------*/
DROP TABLE Costo_evento;
DROP TABLE Televisora;
DROP TABLE Evento_atleta;
DROP TABLE Evento;
DROP TABLE Tipo_participacion;
DROP TABLE Categoria;
/*DROP TABLE Disciplina_atleta;*/
DROP TABLE Atleta;
DROP TABLE Disciplina;
DROP TABLE Medallero;
DROP TABLE Tipo_medalla;
DROP TABLE Puesto_miembro;
DROP TABLE Miembro;
DROP TABLE Departamento;
DROP TABLE Puesto;
DROP TABLE Pais;
DROP TABLE Profesion;

DROP TABLE Sede;


/*--------------------------------------------------------------------*/
/*1) Escript para la creacion de las tablas*/
/*--------------------------------------------------------------------*/

CREATE TABLE Profesion(
	cod_prof 	integer,
	nombre 		varchar(50) CONSTRAINT PROFESION_nombre_unique UNIQUE NOT NULL,
	PRIMARY KEY (cod_prof)
);

CREATE TABLE Pais(
	cod_pais	integer,
	nombre		varchar(50) CONSTRAINT PAIS_nombre_unique UNIQUE NOT NULL,
    PRIMARY KEY (cod_pais)
);

CREATE TABLE Puesto(
	cod_puesto 	integer,
	nombre 		varchar(50) CONSTRAINT PUESTO_nombre_unique UNIQUE NOT NULL,
	PRIMARY KEY (cod_puesto)
);

CREATE TABLE Departamento(
	cod_depto 	integer,
	nombre 		varchar(50) CONSTRAINT DEPARTAMENTO_nombre_unique UNIQUE NOT NULL,
	PRIMARY KEY (cod_depto)
);

CREATE TABLE Miembro(
	cod_miembro 		integer,
	nombre				varchar(100) NOT NULL,
	apellido 			varchar(100) NOT NULL,
	edad				integer NOT NULL,
	telefono			integer,
	residencia			varchar(100),
	PAIS_cod_pais		integer,
	PROFESION_cod_prof 	integer,
	PRIMARY KEY (cod_miembro),
	FOREIGN KEY	(PAIS_cod_pais) REFERENCES Pais(cod_pais),
	FOREIGN KEY (PROFESION_cod_prof) REFERENCES Profesion(cod_prof)
);

CREATE TABLE Puesto_Miembro(
	MIEMBRO_cod_miembro		integer,
	PUESTO_cod_puesto		integer,
	DEPARTAMENTO_cod_depto 	integer,
	PRIMARY KEY (MIEMBRO_cod_miembro,PUESTO_cod_puesto,DEPARTAMENTO_cod_depto),
	FOREIGN KEY (MIEMBRO_cod_miembro) REFERENCES Miembro(cod_miembro),
	FOREIGN KEY (PUESTO_cod_puesto) REFERENCES Puesto(cod_puesto),
	FOREIGN KEY (DEPARTAMENTO_cod_depto) REFERENCES Departamento(cod_depto),
	fecha_inicio 	DATE NOT NULL,
	fecha_fin		DATE
);

CREATE TABLE Tipo_medalla(
	cod_tipo	integer,
	medalla		varchar(20) CONSTRAINT TIPO_medalla_unique UNIQUE NOT NULL,
	PRIMARY KEY (cod_tipo)
);

CREATE TABLE Medallero(
	PAIS_cod_pais			integer,
	TIPO_MEDALLA_cod_tipo	integer,
	PRIMARY KEY (PAIS_cod_pais,TIPO_MEDALLA_cod_tipo),
	FOREIGN KEY (PAIS_cod_pais) REFERENCES Pais(cod_pais),
	cantidad_medallas	integer NOT NULL,
	FOREIGN KEY (TIPO_MEDALLA_cod_tipo) REFERENCES Tipo_medalla(cod_tipo)
);

CREATE TABLE Disciplina(
	cod_disciplina	integer,
	nombre			varchar(50) NOT NULL,
	descripcion		varchar(150),
	PRIMARY KEY (cod_disciplina)
);

CREATE TABLE Atleta(
	cod_atleta		integer,
	nombre			varchar(50) NOT NULL,
	apellido		varchar(50) NOT NULL,
	edad			integer NOT NULL,
	participaciones	varchar(100),
	DISCIPLINA_cod_disciplina 	integer,
	PAIS_cod_pais				integer,
	PRIMARY KEY (cod_atleta),
	FOREIGN KEY(DISCIPLINA_cod_disciplina) REFERENCES Disciplina(cod_disciplina),
	FOREIGN KEY(PAIS_cod_pais) REFERENCES Pais(cod_pais)
);

CREATE TABLE Categoria(
	cod_categoria 	integer,
	categoria		varchar(50) NOT NULL,
	PRIMARY KEY (cod_categoria)
);

CREATE TABLE Tipo_participacion(
	cod_participacion	integer,
	tipo_participacion	varchar(100) NOT NULL,
	PRIMARY KEY (cod_participacion)
);

CREATE TABLE Evento(
	cod_evento		integer,
	fecha			date NOT NULL,
	ubicacion		varchar(50) NOT NULL,
	hora			time NOT NULL,
	DISCIPLINA_cod_disciplina 				integer,
	TIPO_PARTICIPACION_cod_participacion	integer,
	CATEGORIA_cod_categoria					integer,
	PRIMARY KEY (cod_evento),
	FOREIGN KEY (DISCIPLINA_cod_disciplina) REFERENCES Disciplina(cod_disciplina),
	FOREIGN KEY (TIPO_PARTICIPACION_cod_participacion) 
	REFERENCES Tipo_participacion(cod_participacion),
	FOREIGN KEY (CATEGORIA_cod_categoria) REFERENCES Categoria(Cod_categoria)
);

CREATE TABLE Evento_Atleta(
	ATLETA_cod_atleta	integer,
	EVENTO_cod_evento	integer,
	PRIMARY KEY (ATLETA_cod_atleta, EVENTO_cod_evento),
	FOREIGN KEY (ATLETA_cod_atleta) REFERENCES Atleta(cod_atleta),
	FOREIGN KEY (EVENTO_cod_evento) REFERENCES Evento(cod_evento)
);

CREATE TABLE Televisora(
	cod_televisora	integer,
	nombre			varchar(50) NOT NULL,
	PRIMARY KEY (cod_televisora)
);

CREATE TABLE Costo_Evento(
	EVENTO_cod_evento			integer,
	TELEVISORA_cod_televisora 	integer,
	PRIMARY KEY (EVENTO_cod_evento,TELEVISORA_cod_televisora),
	FOREIGN KEY (EVENTO_cod_evento) REFERENCES Evento(cod_evento),
	FOREIGN KEY (TELEVISORA_cod_televisora) REFERENCES Televisora(cod_televisora),
	tarifa		numeric NOT NULL
);

/*--------------------------------------------------------------------*/
/*2) En la tabla “Evento” se decidió que la fecha y hora se trabajaría en una sola
columna*/
/*--------------------------------------------------------------------*/
ALTER TABLE Evento DROP COLUMN fecha;
ALTER TABLE Evento DROP COLUMN hora;
ALTER TABLE Evento ADD COLUMN fecha_hora TIMESTAMP;
SELECT * FROM Evento;

/*--------------------------------------------------------------------*/
/*3)Todos los eventos de las olimpiadas deben ser programados del 24 de julio
de 2020 a partir de las 9:00:00 hasta el 09 de agosto de 2020 hasta las
20:00:00.*/
/*--------------------------------------------------------------------*/
ALTER TABLE Evento ADD CONSTRAINT fecha_hora CHECK(fecha_hora > '2020-07-24 09:00:00' AND fecha_hora < '2020-08-09 20:00:00');


/*--------------------------------------------------------------------*/
/*4)Se decidió que las ubicación de los eventos se registrarán previamente en
una tabla y que en la tabla “Evento” sólo se almacenara la llave foránea
según el código del registro de la ubicación, para esto debe realizar lo
siguiente:*/
/*--------------------------------------------------------------------*/

CREATE TABLE Sede(
	codigo integer,
	sede 	varchar(50) NOT NULL,
	PRIMARY KEY (codigo)
);

ALTER TABLE Evento ALTER COLUMN ubicacion TYPE int USING ubicacion::integer;
SELECT * FROM Evento;

ALTER TABLE Evento ADD CONSTRAINT ubicacion_FK FOREIGN KEY (ubicacion) 
REFERENCES Sede(codigo);

/*--------------------------------------------------------------------*/
/*5. Se revisó la información de los miembros que se tienen actualmente y antes
de que se ingresen a la base de datos el Comité desea que a los miembros
que no tengan número telefónico se le ingrese el número por Default 0 al
momento de ser cargados a la base de datos.*/
/*--------------------------------------------------------------------*/
ALTER TABLE Miembro ALTER COLUMN telefono SET DEFAULT 0;

/*--------------------------------------------------------------------*/
/*6. Generar el script necesario para hacer la inserción de datos a las tablas
requeridas.*/
/*--------------------------------------------------------------------*/
INSERT INTO Pais VALUES (1,'Guatemala');
INSERT INTO Pais VALUES (2,'Francia');
INSERT INTO Pais VALUES (3,'Argentina');
INSERT INTO Pais VALUES (4,'Alemania');
INSERT INTO Pais VALUES (5,'Italia');
INSERT INTO Pais VALUES (6,'Brasil');
INSERT INTO Pais VALUES (7,'Estado Unido');
SELECT * FROM Pais;

INSERT INTO Profesion VALUES (1,'Medico');
INSERT INTO Profesion VALUES (2,'Arquitecto');
INSERT INTO Profesion VALUES (3,'Ingeniero');
INSERT INTO Profesion VALUES (4,'Secretaria');
INSERT INTO Profesion VALUES (5,'Auditor');
SELECT * FROM Profesion;

INSERT INTO Miembro(cod_miembro, nombre, apellido, edad, residencia, pais_cod_pais, profesion_cod_prof)
VALUES (1,'Scott','Mitchell',32,'109 highland drive manitowoc,WI 54220',7,3);
INSERT INTO Miembro VALUES (2,'fanette','Poulin',25,25075853,'49, boulevard Aristide Briand 76120 LE GRAND-QUEVILLY',2,4);
INSERT INTO Miembro(cod_miembro, nombre, apellido, edad, residencia, pais_cod_pais, profesion_cod_prof) 
VALUES (3,'Laura','Cunha Silva',55,'Rua Onze, 86 Uberaba-MG',6,5);
INSERT INTO Miembro VALUES (4,'Juan Jose','Lopez',38,36985274,'26 calle 4-10 zona 11',1,2);
INSERT INTO Miembro VALUES (5,'Arcangela','Panicucci',39,391664921,'Via Santa Teresa, 114 90010-Geraci Siculo PA',5,1);
INSERT INTO Miembro(cod_miembro, nombre, apellido, edad, residencia, pais_cod_pais, profesion_cod_prof) 
VALUES (6,'Jeuel','Villalpando',31,'Acuña de Figeroa 6106 80101 Playa Pascual',3,5);
SELECT * FROM Miembro;

INSERT INTO Disciplina VALUES (1,'Atletismo','Saltos de longitud y triples, de altura y con pertiga o garrocha; las pruebas de lanzamiento de martillo, jabalina y disco.');
INSERT INTO Disciplina VALUES (2,'Badminton');
INSERT INTO Disciplina VALUES (3,'Ciclismo');
INSERT INTO Disciplina VALUES (4,'Judo','Es un arte marcial que se origino en Japon alrededor de 1880');
INSERT INTO Disciplina VALUES (5,'Lucha');
INSERT INTO Disciplina VALUES (6,'Tenis de Mesa');
INSERT INTO Disciplina VALUES (7,'Boxeo');
INSERT INTO Disciplina VALUES (8,'Natacion','Esta presente como deporte en los Juegos desde la primera edicion de la era moderna, en Atenas, Grecia, en 1896, donde se disputo en aguas abiertas.');
INSERT INTO Disciplina VALUES (9,'Esgrima');
INSERT INTO Disciplina VALUES (10,'Vela');
SELECT * FROM Disciplina;

INSERT INTO Tipo_medalla VALUES (1,'Oro');
INSERT INTO Tipo_medalla VALUES (2,'Plata');
INSERT INTO Tipo_medalla VALUES (3,'Bronce');
INSERT INTO Tipo_medalla VALUES (4,'Platino');
SELECT * FROM Tipo_medalla;

INSERT INTO Categoria VALUES (1,'Clasificatorio');
INSERT INTO Categoria VALUES (2,'Eliminatorio');
INSERT INTO Categoria VALUES (3,'Final');
SELECT * FROM Categoria;

INSERT INTO Tipo_participacion VALUES (1,'Individual');
INSERT INTO Tipo_participacion VALUES (2,'Parejas');
INSERT INTO Tipo_participacion VALUES (3,'Equipos');
SELECT * FROM Tipo_participacion;

INSERT INTO Medallero VALUES (5,1,3);
INSERT INTO Medallero VALUES (2,1,5);
INSERT INTO Medallero VALUES (6,3,4);
INSERT INTO Medallero VALUES (4,4,3);
INSERT INTO Medallero VALUES (7,3,10);
INSERT INTO Medallero VALUES (3,2,8);
INSERT INTO Medallero VALUES (1,1,2);
INSERT INTO Medallero VALUES (1,4,5);
INSERT INTO Medallero VALUES (5,2,7);
SELECT * FROM Medallero;

INSERT INTO Sede VALUES (1,'Gimnasio Metropolitano de Tokio');
INSERT INTO Sede VALUES (2,'Jardin del Palacion Imperial de Tokio');
INSERT INTO Sede VALUES (3,'Gimnasio Nacional Yoyogi');
INSERT INTO Sede VALUES (4,'Nippon Budokan');
INSERT INTO Sede VALUES (5,'Estadio Olimpico');
SELECT * FROM Sede;

INSERT INTO Evento VALUES (1,3,2,2,1,to_timestamp('24 Jul 2020 11:00:00','DD Mon YYYY HH24:MI:SS'));
INSERT INTO Evento VALUES (2,1,6,1,3,to_timestamp('26 Jul 2020 10:30:00','DD Mon YYYY HH24:MI:SS'));
INSERT INTO Evento VALUES (3,5,7,1,2,to_timestamp('30 Jul 2020 18:45:00','DD Mon YYYY HH24:MI:SS'));
INSERT INTO Evento VALUES (4,2,1,1,1,to_timestamp('01 Aug 2020 12:15:00','DD Mon YYYY HH24:MI:SS'));
INSERT INTO Evento VALUES (5,4,10,3,1,to_timestamp('08 Aug 2020 19:35:00','DD Mon YYYY HH24:MI:SS'));
SELECT * FROM Evento;



/*--------------------------------------------------------------------*/
/*7. Después de que se implementó el script el cuál creó todas las tablas de las
bases de datos, el Comité Olímpico Internacional tomó la decisión de
eliminar la restricción “UNIQUE” de las siguientes tablas:*/
/*--------------------------------------------------------------------*/
ALTER TABLE Pais DROP CONSTRAINT PAIS_nombre_unique;
ALTER TABLE Tipo_medalla DROP CONSTRAINT TIPO_medalla_unique;
ALTER TABLE Departamento DROP CONSTRAINT DEPARTAMENTO_nombre_unique;



/*--------------------------------------------------------------------*/
/*8. Después de un análisis más profundo se decidió que los Atletas pueden
participar en varias disciplinas y no sólo en una como está reflejado
actualmente en las tablas, por lo que se pide que realice lo siguiente.*/
/*--------------------------------------------------------------------*/
ALTER TABLE Atleta DROP COLUMN DISCIPLINA_cod_disciplina;

CREATE TABLE Disciplina_atleta(
	ATLETA_cod_atleta 			integer,
	DISCIPLINA_cod_disciplina 	integer,
	PRIMARY KEY (ATLETA_cod_atleta,DISCIPLINA_cod_disciplina),
	FOREIGN KEY (ATLETA_cod_atleta) REFERENCES Atleta(cod_atleta),
	FOREIGN KEY (DISCIPLINA_cod_disciplina) REFERENCES Disciplina(cod_disciplina)
);



/*--------------------------------------------------------------------*/
/*9. En la tabla “Costo_Evento” se determinó que la columna “tarifa” no debe
ser entero sino un decimal con 2 cifras de precisión.
Generar el script correspondiente para modificar el tipo de dato que se le
pide.*/
/*--------------------------------------------------------------------*/
ALTER TABLE Costo_evento ALTER COLUMN tarifa SET DATA TYPE numeric(5,2);


/*--------------------------------------------------------------------*/
/*10. Generar el Script que borre de la tabla “Tipo_Medalla” '4,Platino'*/
/*--------------------------------------------------------------------*/
DELETE FROM Medallero WHERE Tipo_medalla_cod_tipo = '4';
SELECT * FROM Medallero;
DELETE FROM Tipo_medalla  WHERE medalla = 'Platino';
SELECT * FROM Tipo_medalla;


/*--------------------------------------------------------------------*/
/*11. La fecha de las olimpiadas está cerca y los preparativos siguen, pero de
último momento se dieron problemas con las televisoras encargadas de
transmitir los eventos, ya que no hay tiempo de solucionar los problemas
que se dieron, se decidió no transmitir el evento a través de las televisoras
por lo que el Comité Olímpico pide generar el script que elimine la tabla
“TELEVISORAS” y “COSTO_EVENTO”.*/
/*--------------------------------------------------------------------*/
DROP TABLE Costo_evento;
DROP TABLE Televisora;

/*--------------------------------------------------------------------*/
/*12. El comité olímpico quiere replantear las disciplinas que van a llevarse a cabo,
por lo cual pide generar el script que elimine todos los registros contenidos
en la tabla “DISCIPLINA”.*/
/*--------------------------------------------------------------------*/
ALTER TABLE Evento DROP COLUMN disciplina_cod_disciplina;
DELETE FROM Disciplina;

/*--------------------------------------------------------------------*/
/*13. Los miembros que no tenían registrado su número de teléfono en sus
perfiles fueron notificados, por lo que se acercaron a las instalaciones de
Comité para actualizar sus datos.*/
/*--------------------------------------------------------------------*/
SELECT * FROM Miembro;
UPDATE Miembro SET telefono=55464601 WHERE nombre='Laura' AND apellido='Cunha Silva';
UPDATE Miembro SET telefono=91514243 WHERE nombre='Jeuel' AND apellido='Villalpando';
UPDATE Miembro SET telefono=920686670 WHERE nombre='Scott' AND apellido='Mitchell';


/*--------------------------------------------------------------------*/
/*14. El Comité decidió que necesita la fotografía en la información de los atletas
para su perfil, por lo que se debe agregar la columna “Fotografía” a la tabla
Atleta, debido a que es un cambio de última hora este campo deberá ser
opcional.*/
/*--------------------------------------------------------------------*/
ALTER TABLE Atleta ADD COLUMN fotografia bytea;
SELECT * FROM Atleta;


/*--------------------------------------------------------------------*/
/*15. Todos los atletas que se registren deben cumplir con ser menores a 25 años.
De lo contrario no se debe poder registrar a un atleta en la base de datos.*/
/*--------------------------------------------------------------------*/
ALTER TABLE Atleta ADD CONSTRAINT ATLETA_edad_limit CHECK(edad<25);

