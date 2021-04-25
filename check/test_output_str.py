import sys
import re
import pytest

print("read the output")
output = sys.stdin.read(1000000)

def test_expected(expected):
    assert output.find(expected) != -1