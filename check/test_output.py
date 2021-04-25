import sys
import re
import pytest

print("read the output")
output = sys.stdin.read(1000000)

def test_expected(expected):
    assert re.search(expected, output)

def test_expected_add(temp):
    assert re.search(temp, output)

def test_not_expected(not_expected):
    assert not re.search(not_expected, output)