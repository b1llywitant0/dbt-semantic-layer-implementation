#!/usr/bin/python3
import sys
import json
import base64
from decimal import Decimal

testing_log = '/tmp/testing_function.log'
def log(msg):
    with open(testing_log, "a") as f:
        f.write(msg + "\n")

def decodeBigDecimal(value_base64: str, scale: int) -> Decimal:
    # Step 1: Base64 decode
    raw_bytes = base64.b64decode(value_base64)
    
    # Step 2: Convert to signed big-endian integer
    unscaled_value = int.from_bytes(raw_bytes, byteorder="big", signed=True)
    
    # Step 3: Apply scale
    return Decimal(unscaled_value).scaleb(-scale)

if __name__ == '__main__':
    for line in sys.stdin:
        value = json.loads(line)
        value_base64 = str(value['value_base64'])
        scale = int(value['scale'])
        log(f"[DEBUG] Decoding value_base64={value_base64}, scale={scale}")
        result = json.dumps({'result': str(decodeBigDecimal(value_base64, scale))})
        log(f"[DEBUG] Output: {result}")
        print(result, end='\n')
        sys.stdout.flush()
