import math


def calculate_hypotenus(a: int, b: int) -> float:
    c = math.sqrt(a**2 + b**2)
    return round(c, 2)
