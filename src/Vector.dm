
vector
	proc/Bounce(vector/normal)
		return src - Project(normal) * 2

	proc/Project(vector/onto)
		return onto * (Dot(onto) / onto.LengthSquared())
