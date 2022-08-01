from argparse import ArgumentParser
from flight_utils.spark import get_spark
from flight_utils.demo import test_function



if __name__=="__main__":
    parser = ArgumentParser()
    parser.add_argument("--word", help="Word to print")
    args, _ = parser.parse_known_args()
    test_function(args.word)
    spark, sc = get_spark(appName="flight-model")