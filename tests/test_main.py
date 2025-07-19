from src.main import calculate_hypotenus


def test_calculate_hypotenus():
    result = calculate_hypotenus(8, 9)
    assert result == 12.04
