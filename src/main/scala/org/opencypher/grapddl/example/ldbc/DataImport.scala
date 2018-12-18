package org.opencypher.grapddl.example.ldbc

import java.io.File

import org.apache.spark.sql.{DataFrame, SparkSession}
import org.apache.spark.sql.types.{StringType, StructField, TimestampType}

import scala.io.Source
import scala.util.Properties


object DataImport {
  def populateHiveDatabase(database: String)(implicit spark: SparkSession): Unit = {

    spark.sql(s"DROP DATABASE IF EXISTS $database CASCADE")
    spark.sql(s"CREATE DATABASE $database")

    // Load LDBC data from CSV files into Hive tables
    val csvFiles = new File(resource("/ldbc/csv/")).list()
    csvFiles.foreach { csvFile =>
      spark.read
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
    val views = readFile(resource("/ldbc/sql/ldbc_views.sql")).split(";")
    views.foreach(spark.sql)
  }

  def resource(path: String): String =
    getClass.getResource(path).getFile

  def readFile(fileName: String): String =
    Source
      .fromFile(fileName)
      .getLines()
      .mkString(Properties.lineSeparator)


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
