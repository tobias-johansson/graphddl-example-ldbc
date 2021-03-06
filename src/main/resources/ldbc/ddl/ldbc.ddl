SET SCHEMA warehouse.LDBC

CREATE GRAPH LDBC (

    -- Element types
    Person       ( firstName STRING, lastName STRING, gender STRING, creationDate STRING, locationIP STRING, browserUsed STRING, birthday STRING ),

    Place        ( name STRING, url STRING ),
    Continent    EXTENDS Place (),
    Country      EXTENDS Place (),
    City         EXTENDS Place (),

    Organisation ( name STRING, url STRING ),
    Company      EXTENDS Organisation (),
    University   EXTENDS Organisation (),

    Tag          ( name STRING, url STRING ),
    Tagclass     ( name STRING, url STRING ),

    Forum        ( creationDate STRING, title STRING ),
    Message      ( creationDate STRING, locationIP STRING, browserUsed STRING, content STRING, length INTEGER ),
    Comment      EXTENDS Message (),
    Post         EXTENDS Message ( imageFile STRING, language STRING ),

    CONTAINEROF,
    HASCREATOR,
    HASINTEREST,
    HASMODERATOR,
    HASTAG,
    HASTYPE,
    ISLOCATEDIN,
    ISPARTOF,
    ISSUBCLASSOF,
    REPLYOF,
    HASMEMBER ( joinDate STRING ),
    KNOWS     ( creationDate STRING ),
    LIKES     ( creationDate STRING ),
    STUDYAT   ( classYear INTEGER ),
    WORKAT    ( workFrom INTEGER ),

    -- Node types with mappings
    (Post)       FROM post,
    (Tag)        FROM tag,
    (Company)    FROM company,
    (Tagclass)   FROM tagclass,
    (Continent)  FROM continent,
    (Person)     FROM person,
    (Forum)      FROM forum,
    (Comment)    FROM comment,
    (University) FROM university,
    (Country)    FROM country,
    (City)       FROM city,

    -- Edge types with mappings
    (Country)-[ISPARTOF]->(Continent)
        FROM country_ispartof_continent edge
            START NODES (Country)   FROM country   node JOIN ON edge.country.id = node.id
            END   NODES (Continent) FROM continent node JOIN ON edge.continent.id = node.id,

    (Tagclass)-[ISSUBCLASSOF]->(Tagclass)
        FROM tagclass_issubclassof_tagclass edge
            START NODES (Tagclass) FROM tagclass node JOIN ON edge.tagclass.id0 = node.id
            END   NODES (Tagclass) FROM tagclass node JOIN ON edge.tagclass.id1 = node.id,

    (Comment)-[REPLYOF]->(Comment)
        FROM comment_replyof_comment edge
            START NODES (Comment) FROM comment node JOIN ON edge.comment.id0 = node.id
            END   NODES (Comment) FROM comment node JOIN ON edge.comment.id1 = node.id,

    (Person)-[KNOWS]->(Person)
        FROM person_knows_person edge
            START NODES (Person) FROM person node JOIN ON edge.person.id0 = node.id
            END   NODES (Person) FROM person node JOIN ON edge.person.id1 = node.id,

    (Forum)-[HASTAG]->(Tag)
        FROM forum_hastag_tag edge
            START NODES (Forum) FROM forum node JOIN ON edge.forum.id = node.id
            END   NODES (Tag)   FROM tag   node JOIN ON edge.tag.id   = node.id,

    (Person)-[WORKAT]->(Company)
        FROM person_workat_company edge
            START NODES (Person)  FROM person  node JOIN ON edge.person.id  = node.id
            END   NODES (Company) FROM company node JOIN ON edge.company.id = node.id,

    (Person)-[LIKES]->(Post)
        FROM person_likes_post edge
            START NODES (Person) FROM person node JOIN ON edge.person.id = node.id
            END   NODES (Post)   FROM post   node  JOIN ON edge.post.id  = node.id,

    (Person)-[HASINTEREST]->(Tag)
        FROM person_hasinterest_tag edge
            START NODES (Person) FROM person node JOIN ON edge.person.id = node.id
            END   NODES (Tag)    FROM tag    node JOIN ON edge.tag.id    = node.id,

    (Company)-[ISLOCATEDIN]->(Country)
        FROM company_islocatedin_country edge
            START NODES (Company) FROM company node JOIN ON edge.company.id = node.id
            END   NODES (Country) FROM country node JOIN ON edge.country.id = node.id,

    (Comment)-[HASCREATOR]->(Person)
        FROM comment_hascreator_person edge
            START NODES (Comment) FROM comment node JOIN ON edge.comment.id = node.id
            END   NODES (Person)  FROM person  node JOIN ON edge.person.id  = node.id,

    (Post)-[HASTAG]->(Tag)
        FROM post_hastag_tag edge
            START NODES (Post) FROM post node JOIN ON edge.post.id = node.id
            END   NODES (Tag)  FROM tag  node JOIN ON edge.tag.id  = node.id,

    (Post)-[HASCREATOR]->(Person)
        FROM post_hascreator_person edge
            START NODES (Post)   FROM post   node JOIN ON edge.post.id   = node.id
            END   NODES (Person) FROM person node JOIN ON edge.person.id = node.id,

    (Comment)-[REPLYOF]->(Post)
        FROM comment_replyof_post edge
            START NODES (Comment) FROM comment node JOIN ON edge.comment.id = node.id
            END   NODES (Post)    FROM post    node JOIN ON edge.post.id    = node.id,

    (Post)-[ISLOCATEDIN]->(Country)
        FROM post_islocatedin_country edge
            START NODES (Post)    FROM post    node JOIN ON edge.post.id    = node.id
            END   NODES (Country) FROM country node JOIN ON edge.country.id = node.id,

    (Comment)-[ISLOCATEDIN]->(Country)
        FROM comment_islocatedin_country edge
            START NODES (Comment) FROM comment node JOIN ON edge.comment.id = node.id
            END   NODES (Country) FROM country node JOIN ON edge.country.id = node.id,

    (University)-[ISLOCATEDIN]->(City)
        FROM university_islocatedin_city edge
            START NODES (University) FROM university node JOIN ON edge.university.id = node.id
            END   NODES (City)       FROM city       node JOIN ON edge.city.id       = node.id,

    (Forum)-[CONTAINEROF]->(Post)
        FROM forum_containerof_post edge
            START NODES (Forum) FROM forum node JOIN ON edge.forum.id = node.id
            END   NODES (Post)  FROM post  node JOIN ON edge.post.id  = node.id,

    (Forum)-[HASMEMBER]->(Person)
        FROM forum_hasmember_person edge
            START NODES (Forum)  FROM forum  node JOIN ON edge.forum.id  = node.id
            END   NODES (Person) FROM person node JOIN ON edge.person.id = node.id,

    (Person)-[ISLOCATEDIN]->(City)
        FROM person_islocatedin_city edge
            START NODES (Person) FROM person node JOIN ON edge.person.id = node.id
            END   NODES (City)   FROM city   node JOIN ON edge.city.id   = node.id,

    (Person)-[STUDYAT]->(University)
        FROM person_studyat_university edge
            START NODES (Person)     FROM person     node JOIN ON edge.person.id     = node.id
            END   NODES (University) FROM university node JOIN ON edge.university.id = node.id,

    (Tag)-[HASTYPE]->(Tagclass)
        FROM tag_hastype_tagclass edge
            START NODES (Tag)      FROM tag      node JOIN ON edge.tag.id      = node.id
            END   NODES (Tagclass) FROM tagclass node JOIN ON edge.tagclass.id = node.id,

    (Forum)-[HASMODERATOR]->(Person)
        FROM forum_hasmoderator_person edge
            START NODES (Forum)  FROM forum  node JOIN ON edge.forum.id  = node.id
            END   NODES (Person) FROM person node JOIN ON edge.person.id = node.id,

    (Comment)-[HASTAG]->(Tag)
        FROM comment_hastag_tag edge
            START NODES (Comment) FROM comment node JOIN ON edge.comment.id = node.id
            END   NODES (Tag)     FROM tag     node JOIN ON edge.tag.id     = node.id,

    (Person)-[LIKES]->(Comment)
        FROM person_likes_comment edge
            START NODES (Person)  FROM person  node JOIN ON edge.person.id  = node.id
            END   NODES (Comment) FROM comment node JOIN ON edge.comment.id = node.id,

    (City)-[ISPARTOF]->(Country)
        FROM city_ispartof_country edge
            START NODES (City)    FROM city    node JOIN ON edge.city.id    = node.id
            END   NODES (Country) FROM country node JOIN ON edge.country.id = node.id
)
       