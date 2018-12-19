package org.opencypher.grapddl.example.ldbc

import org.apache.spark.sql.SparkSession
import org.apache.spark.sql.internal.StaticSQLConf.CATALOG_IMPLEMENTATION
import org.opencypher.grapddl.example.ldbc.DataImport._
import org.opencypher.okapi.api.graph.Namespace
import org.opencypher.spark.api.io.sql.IdGenerationStrategy
import org.opencypher.spark.api.{CAPSSession, GraphSources}

object LdbcExample extends App {

  // Launch Spark locally (with Hive support)
  implicit val session: CAPSSession = CAPSSession.local(CATALOG_IMPLEMENTATION.key -> "hive")
  implicit val spark: SparkSession = session.sparkSession

  // Import data from CSV
  // populateHiveDatabase("LDBC")

  // Create SQL PGDS
  val sqlGraphSource = GraphSources
    .sql(resource("/ldbc/ddl/ldbc.ddl"))
    .withIdGenerationStrategy(IdGenerationStrategy.HashBasedId)
    .withSqlDataSourceConfigs(resource("/ldbc/ddl/data-sources.json"))

  // Register SQL PGDS
  session.catalog.register(Namespace("sql"), sqlGraphSource)

  // Run a Cypher query
  session.cypher(
    s"""
       |FROM GRAPH sql.LDBC
       |MATCH (p:Person)-[:STUDYAT]->(u:University)
       |WHERE u.name = 'National_Institute_of_Business_Management'
       |RETURN p.firstName, u.name, u.url
       |ORDER BY p.firstName
     """.stripMargin).show

}



