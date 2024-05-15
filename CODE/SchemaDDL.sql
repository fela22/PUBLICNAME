
-- Nunzio Fela Dean
DROP TABLE Animal;
CREATE TABLE Animal (
	animal_id integer primary key,
	tag varchar(16) NOT NULL default '',
	sex varchar(20) NOT NULL default '',
	dob timestamp,
	sire varchar(16) NOT NULL default '',
	dam varchar(16) NOT NULL default '',
	breed varchar(20) NOT NULL default '',
	colour varchar(20) NOT NULL default '',
	weaned integer NOT NULL default 0 ,
	note varchar(30) NOT NULL default '',
	donordam varchar(16) NOT NULL default '',
	overall_adg varchar(20) NOT NULL default '',
	last_weight varchar(20) NOT NULL default '',
	sex_date timestamp,
	breed_date timestamp,
	dob_date timestamp);
CREATE TABLE Goat (
	animal_id integer primary key,
	tag varchar(16) NOT NULL default '',
	sex varchar(20) NOT NULL default '',
	dob timestamp,
	sire varchar(16) NOT NULL default '',
	dam varchar(16) NOT NULL default '',
	breed varchar(20) NOT NULL default '',
	colour varchar(20) NOT NULL default '',
	weaned integer NOT NULL default 0 ,
	note varchar(30) NOT NULL default '',
	donordam varchar(16) NOT NULL default '',
	overall_adg varchar(20) NOT NULL default '',
	last_weight varchar(20) NOT NULL default '',
	sex_date timestamp,
	breed_date timestamp,
	dob_date timestamp
);


DROP TABLE Points;
CREATE TABLE Points(
	animal_id integer primary key,
	points_total integer NOT NULL default 0,
	goats_rating_number integer NOT NULL default 0);

DROP TABLE Note;
CREATE TABLE Note (
	animal_id integer NOT NULL,
	created timestamp,
	note varchar(30) NOT NULL,
	primary key( animal_id, created ));

DROP TABLE SessionAnimalActivity;
CREATE TABLE SessionAnimalActivity (
	session_id integer NOT NULL,
	animal_id integer NOT NULL,
	activity_code integer NOT NULL,
	when_measured timestamp NOT NULL,
	primary key( session_id, animal_id, activity_code, when_measured ));

DROP TABLE SessionAnimalTrait;
CREATE TABLE SessionAnimalTrait (
	session_id integer NOT NULL,
	animal_id integer NOT NULL,
	trait_code integer NOT NULL,
	alpha_value varchar(20) NOT NULL default '',
	alpha_units varchar(10) NOT NULL default '',
	primary key(session_id, animal_id, trait_code));

DROP TABLE PicklistValue;
CREATE TABLE PicklistValue (
	picklistvalue_id integer primary key,
	picklist_id integer,
	value varchar(30));

-- read the CSV file into the table
\copy Animal from 'Animal.csv' WITH DELIMITER ',' CSV HEADER;

-- read the CSV file into the table
\copy Note from 'Note.csv' WITH DELIMITER ',' CSV HEADER;

-- read the CSV file into the table
\copy SessionAnimalActivity from 'SessionAnimalActivity.csv' WITH DELIMITER ',' CSV HEADER;

-- read the CSV file into the table
\copy SessionAnimalTrait from 'SessionAnimalTrait.csv' WITH DELIMITER ',' CSV HEADER;

-- read the CSV file into the table
\copy PicklistValue from 'PicklistValue.csv' WITH DELIMITER ',' CSV HEADER;
INSERT INTO Goat(animal_id,tag,sex,dob,sire,dam,breed,colour,weaned,note,donordam,overall_adg,last_weight,sex_date,breed_date, dob_date)
SELECT animal_id,tag,sex, dob, sire, dam, breed, colour, weaned, note, donordam, overall_adg, last_weight, sex_date, breed_date, dob_date FROM Animal;