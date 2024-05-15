--CREATING TABLES FOR ALL DATA
DROP TABLE Animal;
CREATE TABLE Animal (
    animal_id integer primary key,
    lrid integer NOT NULL default 0,
    tag varchar(16) NOT NULL default '',
    rfid varchar(15) NOT NULL default '',
    nlis varchar(16) NOT NULL default '',
    is_new integer NOT NULL default 1,
    draft varchar(20) NOT NULL default '',
    sex varchar(20) NOT NULL default '',
    dob timestamp,
    sire varchar(16) NOT NULL default '',
    dam varchar(16) NOT NULL default '',
    breed varchar(20) NOT NULL default '',
    colour varchar(20) NOT NULL default '',
    weaned integer NOT NULL default 0 ,
    prev_tag varchar(10) NOT NULL default '',
    prev_pic varchar(20) NOT NULL default '',
    note varchar(30) NOT NULL default '',
    note_date timestamp,
    is_exported integer NOT NULL default 0,
    is_history integer NOT NULL default 0,
    is_deleted integer NOT NULL default 0,
    tag_sorter varchar(48) NOT NULL default '',
    donordam varchar(16) NOT NULL default '',
    whp timestamp,
    esi timestamp,
    status varchar(20) NOT NULL default '',
    status_date timestamp,
    overall_adg varchar(20) NOT NULL default '',
    current_adg varchar(20) NOT NULL default '',
    last_weight varchar(20) NOT NULL default '',
    last_weight_date timestamp,
    selected integer default 0,
    animal_group varchar(20) NOT NULL default '',
    current_farm varchar(20) NOT NULL default '',
    current_property varchar(20) NOT NULL default '',
    current_area varchar(20) NOT NULL default '',
    current_farm_date timestamp,
    current_property_date timestamp,
    current_area_date timestamp,
    animal_group_date timestamp,
    sex_date timestamp,
    breed_date timestamp,
    dob_date timestamp,
    colour_date timestamp,
    prev_pic_date timestamp,
    sire_date timestamp,
    dam_date timestamp,
    donordam_date timestamp,
    prev_tag_date timestamp,
    tag_date timestamp,
    rfid_date timestamp,
    nlis_date timestamp,
    modified timestamp,
    full_rfid varchar(16) default '',
    full_rfid_date timestamp);
DROP TABLE Note;
CREATE TABLE Note (
    animal_id integer NOT NULL,
    created timestamp,
    note varchar(30) NOT NULL,
    session_id integer NOT NULL,
    is_deleted integer default 0,
    is_alert integer default 0,
    primary key( animal_id, created ));

DROP TABLE SessionAnimalActivity;
CREATE TABLE SessionAnimalActivity (
    session_id integer NOT NULL,
    animal_id integer NOT NULL,
    activity_code integer NOT NULL,
    when_measured timestamp NOT NULL,
    latestForSessionAnimal integer default 1,
    latestForAnimal integer default 1,
    is_history integer NOT NULL default 0,
    is_exported integer NOT NULL default 0,
    is_deleted integer default 0,

    
    primary key( session_id, animal_id, activity_code, when_measured ));

DROP TABLE SessionAnimalTrait;
CREATE TABLE SessionAnimalTrait (
    session_id integer NOT NULL,
    animal_id integer NOT NULL,
    trait_code integer NOT NULL,
    alpha_value varchar(20) NOT NULL default '',
    alpha_units varchar(10) NOT NULL default '',
    when_measured timestamp NOT NULL,
    latestForSessionAnimal integer default 1,
    latestForAnimal integer default 1,
    is_history integer NOT NULL default 0,
    is_exported integer NOT NULL default 0,
    is_deleted integer default 0,
    primary key(session_id, animal_id, trait_code, when_measured));

DROP TABLE PicklistValue;
CREATE TABLE PicklistValue (
    picklistvalue_id integer primary key,
    picklist_id integer,
    value varchar(30));

-- read the CSV file into the table
\copy Animal from 'DATAFILES/Animal.csv' WITH DELIMITER ',' CSV HEADER;

-- read the CSV file into the table
\copy Note from 'DATAFILES/Note.csv' WITH DELIMITER ',' CSV HEADER;

-- read the CSV file into the table
\copy SessionAnimalActivity from 'DATAFILES/SessionAnimalActivity.csv' WITH DELIMITER ',' CSV HEADER;

-- read the CSV file into the table
\copy SessionAnimalTrait from 'DATAFILES/SessionAnimalTrait.csv' WITH DELIMITER ',' CSV HEADER;

-- read the CSV file into the table
\copy PicklistValue from 'DATAFILES/PicklistValue.csv' WITH DELIMITER ',' CSV HEADER;
--ALL DATA IS AVAILABLE TO BE SELECTED FROM NOW

--CREATING TABLES FOR OUR VIEWS NOW

--CREATE GOAT TABLE TO ACT AS BASE RELATION FOR INDIVIDUALS
DROP TABLE Goat CASCADE;
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
INSERT INTO Goat(animal_id,tag,sex,dob,sire,dam,breed,colour,weaned,note,donordam,overall_adg,last_weight,sex_date,breed_date, dob_date)
SELECT animal_id,tag,sex, dob, sire, dam, breed, colour, weaned, note, donordam, overall_adg, last_weight, sex_date, breed_date, dob_date FROM Animal;
DROP TABLE Animal;

--CREATE TRAIT TABLE TO ACT AS BASE RELATION FOR INDIVIDUAL'S TRAITS
DROP TABLE Trait CASCADE;
CREATE TABLE Trait 
(
session_id integer NOT null, 
animal_id integer NOT NULL,
activity_code integer NOT NULL,
when_measured timestamp NOT NULL,
PRIMARY key(session_id, animal_id, activity_code, when_measured),

milk_rating integer DEFAULT 0,
mothering_rating integer DEFAULT 0,
vigor_score integer DEFAULT 0,
sore_mouth integer DEFAULT 0,
chlamydia_vaccination integer DEFAULT 0,
birth_weight integer DEFAULT 0,
weaned integer DEFAULT 0
);



INSERT INTO Trait(session_id, animal_id, activity_code, when_measured )
SELECT session_id, animal_id, activity_code, when_measured 
   

FROM SessionAnimalActivity;
DROP TABLE SessionAnimalActivity;

/*Update Trait
set birth_weight = Case
    When activity_code = 357 and value >= '6' then 3
    when activity_code = 357 and value < '6' then 5
    Else birth_weight
End; */

Update Trait as t_wean
Set weaned = Case
    When t_wean.value = t_birth.value then 0
    When t_wean.value < t_birth.value Then 5
    Else 0
End
    From ( 
        Select animal_id, value from Trait 
        Where activity_code in (487, 488, 489, 490)
    ) As t_birth where t_wean.animal_id = t_birth.animal_id and t_wean.activity_code = 867;

--milk rating
Update Trait
Set milk_rating = Case 
    When activity_code = 476 Then 1 --Milk rating Good
    When activity_code In (2184, 477, 478) then 5 --Milk rating Not good
    Else milk_rating
End;

--mothering rating
Update Trait 
Set mothering_rating = Case
    when activity_code = 740 then 1
    when activity_code in (937, 940) then 5
    else mothering_rating
End;


/*
--vigor score
Update Trait
Set vigor_score = Case
    --need to fix the values
    when activity_code = 230 and value = '1' Then 0
    when activity_code = 230 and value = '2' then 2
    when activity_code = 230 and value = '3' then 5
    Else vigor_score
End;
*/

--sore mouth
Update Trait
Set sore_mouth = Case
    when activity_code in (242,1218) Then 1
    Else 0
End;


--chlamydia vaccination
Update Trait
Set chlamydia_vaccination = Case
    When activity_code = 737 then 0
    Else 1
End;




Select animal_id, 
    Sum (milk_rating + mothering_rating + vigor_score + sore_mouth + chlamydia_vaccination + birth_weight) as total_points 
from Trait
Group BY animal_id;



--QUERIES UTILIZING VIEWS
CREATE VIEW VaxedGoats AS
SELECT distinct g.animal_id, t.activity_code, g.dob
FROM Goat AS g,Trait AS t
WHERE t.activity_code='737' AND g.animal_id=t.animal_id
ORDER BY g.animal_id;
DROP VIEW Family_TREE;
CREATE VIEW Family_Tree AS
SELECT animal_id, sire, dam, tag
FROM Goat;
