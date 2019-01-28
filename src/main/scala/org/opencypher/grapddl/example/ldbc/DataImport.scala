package org.opencypher.grapddl.example.ldbc

import java.io.File

import org.apache.spark.sql.types.{StringType, StructField, TimestampType}
import org.apache.spark.sql.{DataFrame, SparkSession}

import scala.io.Source


object DataImport {
  def populateHiveDatabase(database: String)(implicit spark: SparkSession): Unit = {

    spark.sql(s"DROP DATABASE IF EXISTS $database CASCADE")
    spark.sql(s"CREATE DATABASE $database")

    // Load LDBC data from CSV files into Hive tables
    new File(resource("/ldbc/csv/"))
      .list()
      .foreach { csvFile =>
        spark
          .read
          .format("csv")
          .option("header", value = true)
          .option("inferSchema", value = true)
          .option("delimiter", "|")
          .load(resource(s"/ldbc/csv/$csvFile"))
          // cast e.g. Timestamp to String
          .withCompatibleTypes
          .write
          .saveAsTable(s"$database.${csvFile.dropRight("_0_0.csv.gz".length)}")
      }

    // Create views that normalize LDBC data where necessary
    Source
      .fromFile(resource("/ldbc/sql/ldbc_views.sql"))
      .mkString
      .split(";")
      .foreach(spark.sql)
  }

  def resource(path: String): String =
    getClass.getResource(path).getFile

  // Date/Time types are not supported yet, so we coerce them into strings
  implicit class DataFrameConversion(df: DataFrame) {
    def withCompatibleTypes: DataFrame = df.schema.fields.foldLeft(df) {
      case (currentDf, StructField(name, dataType, _, _)) if dataType == TimestampType =>
        currentDf
          .withColumn(s"${name}_tmp", currentDf.col(name).cast(StringType))
          .drop(name)
          .withColumnRenamed(s"${name}_tmp", name)
      case (currentDf, _) => currentDf
    }
  }

}
