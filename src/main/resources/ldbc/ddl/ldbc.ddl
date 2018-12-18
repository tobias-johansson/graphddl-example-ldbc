-- generated by LdbcUtil on Mon Dec 17 16:49:33 CET 2018

SET SCHEMA warehouse.LDBC


CREATE GRAPH LDBC (
    -- Element types
    City       ( name STRING, url STRING ),
    Comment    ( creationDate STRING, locationIP STRING, browserUsed STRING, content STRING, length INTEGER ),
    Company    ( name STRING, url STRING ),
    Continent  ( name STRING, url STRING ),
    Country    ( name STRING, url STRING ),
    Forum      ( title STRING, creationDate STRING ),
    Person     ( firstName STRING, lastName STRING, gender STRING, creationDate STRING, locationIP STRING, browserUsed STRING, birthday STRING ),
    Post       ( imageFile STRING, creationDate STRING, locationIP STRING, browserUsed STRING, language STRING, content STRING, length INTEGER ),
    Tag        ( name STRING, url STRING ),
    Tagclass   ( name STRING, url STRING ),
    University ( name STRING, url STRING ),
    containerof,
    hascreator,
    hasinterest,
    hasmember ( joinDate STRING ),
    hasmoderator,
    hastag,
    hastype,
    islocatedin,
    ispartof,
    issubclassof,
    knows ( creationDate STRING ),
    likes ( creationDate STRING ),
    replyof,
    studyat ( classYear INTEGER ),
    workat ( workFrom INTEGER ),

    -- Node types including mappings
    (Post) FROM post,
    (Tag) FROM tag,
    (Company) FROM company,
    (Tagclass) FROM tagclass,
    (Continent) FROM continent,
    (Person) FROM person,
    (Forum) FROM forum,
    (Comment) FROM comment,
    (University) FROM university,
    (Country) FROM country,
    (City) FROM city,

    -- Edge types including mappings
    (Country)-[ispartof]->(Continent)
        FROM country_ispartof_continent edge
            START NODES (Country)   FROM country   node JOIN ON edge.country.id = node.id
            END   NODES (Continent) FROM continent node JOIN ON edge.continent.id = node.id,

    (Tagclass)-[issubclassof]->(Tagclass)
        FROM tagclass_issubclassof_tagclass edge
            START NODES (Tagclass) FROM tagclass node JOIN ON edge.tagclass.id0 = node.id
            END   NODES (Tagclass) FROM tagclass node JOIN ON edge.tagclass.id1 = node.id,

    (Comment)-[replyof]->(Comment)
        FROM comment_replyof_comment edge
            START NODES (Comment) FROM comment node JOIN ON edge.comment.id0 = node.id
            END   NODES (Comment) FROM comment node JOIN ON edge.comment.id1 = node.id,

    (Person)-[knows]->(Person)
        FROM person_knows_person edge
            START NODES (Person) FROM person node JOIN ON edge.person.id0 = node.id
            END   NODES (Person) FROM person node JOIN ON edge.person.id1 = node.id,

    (Forum)-[hastag]->(Tag)
        FROM forum_hastag_tag edge
            START NODES (Forum) FROM forum node JOIN ON edge.forum.id = node.id
            END   NODES (Tag)   FROM tag   node JOIN ON edge.tag.id   = node.id,

    (Person)-[workat]->(Company)
        FROM person_workat_company edge
            START NODES (Person)  FROM person  node JOIN ON edge.person.id  = node.id
            END   NODES (Company) FROM company node JOIN ON edge.company.id = node.id,

    (Person)-[likes]->(Post)
        FROM person_likes_post edge
            START NODES (Person) FROM person node JOIN ON edge.person.id = node.id
            END   NODES (Post)   FROM post   node  JOIN ON edge.post.id  = node.id,

    (Person)-[hasinterest]->(Tag)
        FROM person_hasinterest_tag edge
            START NODES (Person) FROM person node JOIN ON edge.person.id = node.id
            END   NODES (Tag)    FROM tag    node JOIN ON edge.tag.id    = node.id,

    (Company)-[islocatedin]->(Country)
        FROM company_islocatedin_country edge
            START NODES (Company) FROM company node JOIN ON edge.company.id = node.id
            END   NODES (Country) FROM country node JOIN ON edge.country.id = node.id,

    (Comment)-[hascreator]->(Person)
        FROM comment_hascreator_person edge
            START NODES (Comment) FROM comment node JOIN ON edge.comment.id = node.id
            END   NODES (Person)  FROM person  node JOIN ON edge.person.id  = node.id,

    (Post)-[hastag]->(Tag)
        FROM post_hastag_tag edge
            START NODES (Post) FROM post node JOIN ON edge.post.id = node.id
            END   NODES (Tag)  FROM tag  node JOIN ON edge.tag.id  = node.id,

    (Post)-[hascreator]->(Person)
        FROM post_hascreator_person edge
            START NODES (Post)   FROM post   node JOIN ON edge.post.id   = node.id
            END   NODES (Person) FROM person node JOIN ON edge.person.id = node.id,

    (Comment)-[replyof]->(Post)
        FROM comment_replyof_post edge
            START NODES (Comment) FROM comment node JOIN ON edge.comment.id = node.id
            END   NODES (Post)    FROM post    node JOIN ON edge.post.id    = node.id,

    (Post)-[islocatedin]->(Country)
        FROM post_islocatedin_country edge
            START NODES (Post)    FROM post    node JOIN ON edge.post.id    = node.id
            END   NODES (Country) FROM country node JOIN ON edge.country.id = node.id,

    (Comment)-[islocatedin]->(Country)
        FROM comment_islocatedin_country edge
            START NODES (Comment) FROM comment node JOIN ON edge.comment.id = node.id
            END   NODES (Country) FROM country node JOIN ON edge.country.id = node.id,

    (University)-[islocatedin]->(City)
        FROM university_islocatedin_city edge
            START NODES (University) FROM university node JOIN ON edge.university.id = node.id
            END   NODES (City)       FROM city       node JOIN ON edge.city.id       = node.id,

    (Forum)-[containerof]->(Post)
        FROM forum_containerof_post edge
            START NODES (Forum) FROM forum node JOIN ON edge.forum.id = node.id
            END   NODES (Post)  FROM post  node JOIN ON edge.post.id  = node.id,

    (Forum)-[hasmember]->(Person)
        FROM forum_hasmember_person edge
            START NODES (Forum)  FROM forum  node JOIN ON edge.forum.id  = node.id
            END   NODES (Person) FROM person node JOIN ON edge.person.id = node.id,

    (Person)-[islocatedin]->(City)
        FROM person_islocatedin_city edge
            START NODES (Person) FROM person node JOIN ON edge.person.id = node.id
            END   NODES (City)   FROM city   node JOIN ON edge.city.id   = node.id,

    (Person)-[studyat]->(University)
        FROM person_studyat_university edge
            START NODES (Person)     FROM person     node JOIN ON edge.person.id     = node.id
            END   NODES (University) FROM university node JOIN ON edge.university.id = node.id,

    (Tag)-[hastype]->(Tagclass)
        FROM tag_hastype_tagclass edge
            START NODES (Tag)      FROM tag      node JOIN ON edge.tag.id      = node.id
            END   NODES (Tagclass) FROM tagclass node JOIN ON edge.tagclass.id = node.id,

    (Forum)-[hasmoderator]->(Person)
        FROM forum_hasmoderator_person edge
            START NODES (Forum)  FROM forum  node JOIN ON edge.forum.id  = node.id
            END   NODES (Person) FROM person node JOIN ON edge.person.id = node.id,

    (Comment)-[hastag]->(Tag)
        FROM comment_hastag_tag edge
            START NODES (Comment) FROM comment node JOIN ON edge.comment.id = node.id
            END   NODES (Tag)     FROM tag     node JOIN ON edge.tag.id     = node.id,

    (Person)-[likes]->(Comment)
        FROM person_likes_comment edge
            START NODES (Person)  FROM person  node JOIN ON edge.person.id  = node.id
            END   NODES (Comment) FROM comment node JOIN ON edge.comment.id = node.id,

    (City)-[ispartof]->(Country)
        FROM city_ispartof_country edge
            START NODES (City)    FROM city    node JOIN ON edge.city.id    = node.id
            END   NODES (Country) FROM country node JOIN ON edge.country.id = node.id
)
       