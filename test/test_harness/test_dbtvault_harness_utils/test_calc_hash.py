from pandas import Series

from test import context_utils


def test_calc_hash_without_hashing_for_single_column():
    columns = Series(['1000'])

    expected_columns = Series(['1000'])
    actual_columns = context_utils.calc_hash(columns)

    assert expected_columns.equals(actual_columns)


def test_calc_hash_without_hashing_for_multiple_column():
    columns = Series(['1000', '2000', '3000'])

    expected_column = Series(['1000', '2000', '3000'])

    actual_columns = context_utils.calc_hash(columns)

    assert expected_column.equals(actual_columns)


def test_calc_hash_for_single_md5():
    columns = Series(["md5('1000')"])

    expected_hashes = Series(['A9B7BA70783B617E9998DC4DD82EB3C5'])
    actual_hashes = context_utils.calc_hash(columns)

    assert expected_hashes.equals(actual_hashes)


def test_calc_hash_for_multiple_md5():
    columns = Series(["md5('1000')", "md5('2000')", "md5('3000')"])

    expected_hashes = Series(['A9B7BA70783B617E9998DC4DD82EB3C5',
                              '08F90C1A417155361A5C4B8D297E0D78',
                              'E93028BDC1AACDFB3687181F2031765D'])

    actual_hashes = context_utils.calc_hash(columns)

    assert expected_hashes.equals(actual_hashes)


def test_calc_hash_for_single_sha256():
    columns = Series(["sha('1000')"])

    expected_hashes = Series(['40510175845988F13F6162ED8526F0B09F73384467FA855E1E79B44A56562A58'])
    actual_hashes = context_utils.calc_hash(columns)

    assert expected_hashes.equals(actual_hashes)


def test_calc_hash_for_multiple_sha256():
    columns = Series(["sha('1000')", "sha('2000')", "sha('3000')"])

    expected_hashes = Series(['40510175845988F13F6162ED8526F0B09F73384467FA855E1E79B44A56562A58',
                              '81A83544CF93C245178CBC1620030F1123F435AF867C79D87135983C52AB39D9',
                              'A176EEB31E601C3877C87C2843A2F584968975269E369D5C86788B4C2F92D2A2'])

    actual_hashes = context_utils.calc_hash(columns)

    assert expected_hashes.equals(actual_hashes)
