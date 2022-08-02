from pyspark.sql import SparkSession
from pyspark.sql import SQLContext


def get_spark(isLocal: bool=False, appName: str=None):
    '''Creates and returns a SparkSession and SQLContext.'''
    if isLocal:
        spark = SparkSession.builder\
        .master("local[*]")\
        .appName(appName)\
        .getOrCreate()
    else:
        spark = SparkSession.builder.appName(appName).getOrCreate()
    sqlContext = SQLContext(spark)
    return spark, sqlContext
