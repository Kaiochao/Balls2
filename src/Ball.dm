
var/list/Balls = new

obj/ball_renderer
	screen_loc = "1,1"
	icon = 'rsc/circle.dmi'
	render_target = "*Ball"

obj/ball
	render_source = "*Ball"

	var/vector/velocity

	New()
		..()
		Balls += src
		color = rgb(rand(360), 100, 100, space = COLORSPACE_HSV)
		velocity = Vector.north.Turn(rand() * 360) * 32

	Del()
		Balls -= src
		..()

	proc/Position()
		return new/vector(
			x * 32 + step_x,
			y * 32 + step_y)

	proc/Step(vector/motion)
		step_x += motion.X()
		step_y += motion.Y()

vector
	proc/Bounce(vector/normal)
		return src - Project(normal) * 2

	proc/Project(vector/onto)
		return onto * (Dot(onto) / onto.LengthSquared())
