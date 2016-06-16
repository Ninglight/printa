CREATE TABLE Users
(
  id serial NOT NULL,
  num integer,
  login character varying(50),
  name character varying(50),
  first_name character varying(50),
  CONSTRAINT users_pkey PRIMARY KEY (id),
  CONSTRAINT users_num_key UNIQUE (num)
)

CREATE TABLE Structures
(
  id serial NOT NULL,
  acronym character varying(15),
  name character varying(50),
  type character(1),
  id_structure integer,
  CONSTRAINT structures_pkey PRIMARY KEY (id),
  CONSTRAINT structures_fkey FOREIGN KEY (id_structure)
      REFERENCES structures (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT structures_acronym_key UNIQUE (acronym)
)

CREATE TABLE Users_Structures(
	user_id int REFERENCES Users(id),
	structure_id int REFERENCES Structures(id),
	date_start date,
	date_end date NULL
);
CREATE INDEX ON Users_Structures (user_id, structure_id);

CREATE TABLE Statut(
	id SERIAL PRIMARY KEY,
	name varchar(50)
);
INSERT INTO Statut (name)
VALUES ('Fonctionnelle');
INSERT INTO Statut (name)
VALUES ('Time Out');
INSERT INTO Statut (name)
VALUES ('Imprimante inconnue');
INSERT INTO Statut (name)
VALUES ('Imprimante Supprimée');
INSERT INTO Statut (name)
VALUES ('Absence adresse IP');

CREATE TABLE Printers(
	id SERIAL PRIMARY KEY,
	name varchar(50),
	serial_number varchar(50) NULL,
	inventory_number varchar(50) NULL,
	id_statut int REFERENCES Statut(id)
);

CREATE TABLE Printing2015(
	id SERIAL PRIMARY KEY,
	id_user int REFERENCES Users(id),
	id_printer int REFERENCES Printers(id),
	date_printing timestamp,
	quantity int,
	id_page int REFERENCES Pages(id)
);

CREATE TABLE Counter2015(
	id SERIAL PRIMARY KEY,
	id_printer int REFERENCES Printers(id),
	date_counter timestamp,
	quantity int,
	id_page int REFERENCES Pages(id)
);

CREATE TABLE Trademarks(
	id SERIAL PRIMARY KEY,
	name varchar(50)
);
INSERT INTO Trademarks (name)
VALUES ('Indéfini');
INSERT INTO Trademarks (name)
VALUES ('Lexmark');
INSERT INTO Trademarks (name)
VALUES ('Toshiba');
INSERT INTO Trademarks (name)
VALUES ('HP');
INSERT INTO Trademarks (name)
VALUES ('Canon');
INSERT INTO Trademarks (name)
VALUES ('Ricoh');
INSERT INTO Trademarks (name)
VALUES ('Epson');
INSERT INTO Trademarks (name)
VALUES ('Oki');
INSERT INTO Trademarks (name)
VALUES ('Xerox');
INSERT INTO Trademarks (name)
VALUES ('Samsung');
INSERT INTO Trademarks (name)
VALUES ('Kyocera');
INSERT INTO Trademarks (name)
VALUES ('Konica Minolta');

CREATE TABLE Models(
	id SERIAL PRIMARY KEY,
	name varchar(50),
	id_trademark int REFERENCES Trademarks(id)
);

CREATE TABLE Models_Printers(
	printer_id int REFERENCES Printers(id),
	model_id int REFERENCES Models(id),
	date_start date,
	date_end date NULL
);
CREATE INDEX ON Models_Printers (printer_id, model_id);

CREATE TABLE Formats(
	id SERIAL PRIMARY KEY,
	name varchar(50)
);
INSERT INTO Formats (name)
VALUES ('A4');
INSERT INTO Formats (name)
VALUES ('A3');

CREATE TABLE Sides(
	id SERIAL PRIMARY KEY,
	name varchar(50)
);
INSERT INTO Sides (name)
VALUES ('Recto-Verso');
INSERT INTO Sides (name)
VALUES ('Recto');

CREATE TABLE Colors(
	id SERIAL PRIMARY KEY,
	name varchar(50)
);
INSERT INTO Colors (name)
VALUES ('Couleur');
INSERT INTO Colors (name)
VALUES ('Noir & Blanc');

CREATE TABLE Types(
	id SERIAL PRIMARY KEY,
	name varchar(50)
);
INSERT INTO Types (name)
VALUES ('Copie');
INSERT INTO Types (name)
VALUES ('Impression');
INSERT INTO Types (name)
VALUES ('Scan');

CREATE TABLE OID(
	id SERIAL PRIMARY KEY,
	name varchar(50)
);

CREATE TABLE Pages(
	id SERIAL PRIMARY KEY,
	id_type int REFERENCES Types(id),
	id_format int REFERENCES Formats(id) NULL,
	id_side int REFERENCES Sides(id) NULL,
	id_color int REFERENCES Colors(id) NULL
);

CREATE TABLE Actions(
	id SERIAL PRIMARY KEY,
	name varchar(50),
	id_page int REFERENCES Pages(id) NULL
);

CREATE TABLE Costs(
	id SERIAL PRIMARY KEY,
	id_model int REFERENCES Models(id),
	id_page int REFERENCES Pages(id),
	date_start date,
	date_end date NULL,
	amount double precision
);

CREATE TABLE Commands(
	id SERIAL PRIMARY KEY,
	id_action int REFERENCES Actions(id),
	id_model int REFERENCES Models(id) NULL,
	id_oid int REFERENCES OID(id)
);
INSERT INTO Commands VALUES (1, 319, NULL, 1);

CREATE TABLE Commands_Default(
	id SERIAL PRIMARY KEY,
	id_action int REFERENCES Actions(id),
	id_trademark int REFERENCES Trademarks(id) NULL,
	id_oid int REFERENCES OID(id),
    id_model int REFERENCES Models(id) NULL,
    complement varchar(100)
);

CREATE TABLE Errors(
	id SERIAL PRIMARY KEY,
	id_typeerror int,
	table_target varchar(30),
    column_target varchar(30) NULL,
	var_info varchar(100),
	date_error date
);

CREATE TABLE Types_Errors(
    id SERIAL PRIMARY KEY,
	name varchar(50),
	direction varchar(50)
);
INSERT INTO Types_Errors (name, direction)
VALUES ('SNMP', 'Récupération');
INSERT INTO Types_Errors (name, direction)
VALUES ('Database', 'Récupération');
INSERT INTO Types_Errors (name, direction)
VALUES ('Database', 'Insertion');
