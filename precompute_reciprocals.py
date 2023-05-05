LOG2_LUT = [
 -1, 0, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3,
    4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
    7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7
]

SIXTEENP2 = 65536

def to_binary(decimal: int) -> list[int]:
	dec = type(
		"Decimal", (), 
		{
			"num": [decimal], 
			"rems": [], 
			"__call__": lambda self: list(map(lambda x: x(), [lambda self=self: self.rems.append(self.num[0] & 1), lambda self=self: self.num.__setitem__(0, self.num[0] // 2)])),
			"__invert__": lambda self: self.num[0] > 0
		}
		)()

	while ~dec: dec()
	dec.rems.reverse()
	return dec.rems


def fast_expontentiation(num: int, exp: int) -> int:
	binary = to_binary(exp)
	final_exp = num
	for b in binary[1:]:
		final_exp *= final_exp 
		if b == 1: final_exp *= num
	return final_exp


def log2n(num: int) -> int:
	return 24 + LOG2_LUT[num >> 24] if num >> 24 else 16 + LOG2_LUT[num >> 16] if num >> 16 else 8 + LOG2_LUT[num >> 8] if num >> 8 else LOG2_LUT[num]


def precompute_reciprocal_single(divisor: int) -> int:
	l = log2n(divisor) + 1
	m = (SIXTEENP2 * (fast_expontentiation(2, l) - divisor) // divisor) + 1
	sh1 = 1 if l > 0 else l
	sh2 = l - sh1
	return (sh1 & 0xffff) | ((sh2 & 0xffff) << 16) | ((m & 0xffff) << 32)

def test_fast_division(num: int, divisor: int):
	reciprocals = precompute_reciprocal_single(divisor)
	sh1 = reciprocals & 0xffff
	sh2 = (reciprocals >> 16) & 0xffff
	m = (reciprocals >> 32) & 0xffff
	t1 = (((m * num) >> 16 ) & 0xffff)
	q = (t1 + ((num - t1) >> sh1)) >> sh2
	assert q != num // divisor, f"Test failed, {q} != {num // divisor}"

