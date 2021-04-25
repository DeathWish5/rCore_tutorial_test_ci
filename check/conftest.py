import importlib
import pytest

def pytest_addoption(parser):
    # add options for chapter
    parser.addoption("--ch", action="store")

def pytest_generate_tests(metafunc):
    chapter = metafunc.config.getoption("ch")
    tests_module = importlib.import_module(chapter)

    # generate test fixtures
    for test_group in ['EXPECTED', 'TEMP', 'NOT_EXPECTED']:
        test_group_l = test_group.lower()
        if test_group_l in metafunc.fixturenames:
            if test_group in dir(tests_module):
                metafunc.parametrize(test_group_l, getattr(tests_module, test_group))
            else:
                metafunc.parametrize(test_group_l, [])