-- normalize place
CREATE TABLE LDBC.city AS
SELECT id, name, url
FROM LDBC.place
WHERE type == 'city';

CREATE TABLE LDBC.country AS
SELECT id, name, url
FROM LDBC.place
WHERE type == 'country';

CREATE TABLE LDBC.continent AS
SELECT id, name, url
FROM LDBC.place
WHERE type == 'continent';

-- normalize organisation
CREATE TABLE LDBC.company AS
SELECT id, name, url
FROM LDBC.organisation
WHERE type == 'company';

CREATE TABLE LDBC.university AS
SELECT id, name, url
FROM LDBC.organisation
WHERE type == 'university';

-- normalize person_islocatedin_place
CREATE TABLE LDBC.person_islocatedin_city AS
SELECT `t`.`Person.id` AS `Person.id`, `t`.`Place.id` AS `City.id`
FROM LDBC.person_islocatedin_place AS t;

-- normalize comment_islocatedin_place
CREATE TABLE LDBC.comment_islocatedin_country AS
SELECT `t`.`Comment.id` AS `Comment.id`, `t`.`Place.id` AS `Country.id`
FROM LDBC.comment_islocatedin_place AS t;

-- normalize post_islocatedin_place
CREATE TABLE LDBC.post_islocatedin_country AS
SELECT `t`.`Post.id` AS `Post.id`, `t`.`Place.id` AS `Country.id`
FROM LDBC.post_islocatedin_place AS t;

-- normalize organisation_islocatedin_place to university_islocatedin_city
CREATE TABLE LDBC.university_islocatedin_city AS
SELECT `l`.`Organisation.id` AS `University.id`, `l`.`Place.id` AS `City.id`
FROM LDBC.organisation_islocatedin_place AS l, LDBC.city AS r
WHERE `l`.`Place.id` == `r`.`id`;

-- normalize organisation_islocatedin_place to company_islocatedin_country
CREATE TABLE LDBC.company_islocatedin_country AS
SELECT `l`.`Organisation.id` AS `Company.id`, `l`.`Place.id` AS `Country.id`
FROM LDBC.organisation_islocatedin_place AS l, LDBC.country AS r
WHERE `l`.`Place.id` == `r`.`id`;

-- normalize person_studyat_organisation
CREATE TABLE LDBC.person_studyat_university AS
SELECT `t`.`Person.id` AS `Person.id`, `t`.`Organisation.id` AS `University.id`, `t`.`classYear` AS `classYear`
FROM LDBC.person_studyat_organisation AS t;

-- normalize person_workat_organisation
CREATE TABLE LDBC.person_workat_company AS
SELECT `t`.`Person.id` AS `Person.id`, `t`.`Organisation.id` AS `Company.id`, `t`.`workFrom` AS `workFrom`
FROM LDBC.person_workat_organisation AS t;

--normalize place_ispartof_place
CREATE TABLE LDBC.city_ispartof_country AS
SELECT `l`.`Place.id0` AS `City.id`, `l`.`Place.id1` AS `Country.id`
FROM LDBC.place_ispartof_place AS l, LDBC.city AS r
WHERE `l`.`Place.id0` == `r`.`id`;

CREATE TABLE LDBC.country_ispartof_continent AS
SELECT `l`.`Place.id0` AS `Country.id`, `l`.`Place.id1` AS `Continent.id`
FROM LDBC.place_ispartof_place AS l, LDBC.country AS r
WHERE `l`.`Place.id0` == `r`.`id`;