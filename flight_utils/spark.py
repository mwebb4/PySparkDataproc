from typing import Tuple
from pyspark.sql import SparkSession
from pyspark.sql import SQLContext


def get_spark(isLocal: bool=False, appName: str=None) -> Tuple(SparkSession,SQLContext) :
    '''Creates and returns a SparkSession and SQLContext.'''

    mode = "local" if isLocal else None
    spark = SparkSession.builder\
            .master(mode)\
            .appName(appName)\
            .getOrCreate()
    sqlContext = SQLContext(spark)
    return spark, sqlContext
