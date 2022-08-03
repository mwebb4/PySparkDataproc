from argparse import ArgumentParser
import numpy as np
from kafka import KafkaConsumer
import os
from flight_utils.demo import test_function

if __name__=="__main__":
    parser = ArgumentParser()
    parser.add_argument("--word", help="Word to print")
    args, _ = parser.parse_known_args()
    print(os.listdir())
    print(args.word)
    test_function(args.word)
