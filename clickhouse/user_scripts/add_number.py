#!/usr/bin/python3
import sys
import json

testing_log = '/tmp/testing_function.log'
def log(msg):
    with open(testing_log, "a") as f:
        f.write(msg + "\n")

if __name__ == '__main__':
    for line in sys.stdin:
        value = json.loads(line)
        num1 = int(value['num1'])
        num2 = int(value['num2'])
        result = json.dumps({'result': num1+num2})
        log(result)
        print(result, end='\n', flush=True)
        sys.stdout.flush()
