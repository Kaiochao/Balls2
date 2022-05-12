
var/list/Balls = new

obj/ball_renderer
	screen_loc = "1,1"
	icon = 'rsc/circle.dmi'
	render_target = "*Ball"

obj/ball
	render_source = "*Ball"

	density = TRUE
	bound_width = 24
	bound_height = 24
	bound_x = 4
	bound_y = 4

	var/vector/velocity
	var/bumped = FALSE

	New()
		..()
		Balls += src
		color = rgb(rand(360), 100, 100, space = COLORSPACE_HSV)
		velocity = Vector.north.Turn(rand() * 360) * 32

	Del()
		Balls -= src
		..()

	Move()
		bumped = FALSE
		. = ..()

	Bump()
		..()
		bumped = TRUE

	proc/Position()
		return new/vector(
			1 + (x - 1) * 32 + step_x + bound_x + (bound_width - 1) / 2,
			1 + (y - 1) * 32 + step_y + bound_y + (bound_height - 1) / 2,
			z)

	proc/Tick()
		var/bounce_horizontal = FALSE
		var/bounce_vertical = FALSE
		var/vector/motion = velocity * world.tick_lag
		var/moved_pixels = 0
		var/vector/position = Position()
		step_size = 1#INF
		if(!(moved_pixels = Move(loc, dir, step_x + motion.X(), step_y + motion.Y())) || bumped)
			if(motion.X() && motion.Y())
				if(!(moved_pixels = max(moved_pixels, Move(loc, dir, step_x + motion.X(), step_y))) || bumped)
					bounce_horizontal = TRUE
				if(!(moved_pixels = max(moved_pixels, Move(loc, dir, step_x, step_y + motion.Y()))) || bumped)
					bounce_vertical = TRUE
		step_size = CheckerboardDistance(Position() - position)
		velocity *= new/vector(
			bounce_horizontal ? -1 : 1,
			bounce_vertical ? -1 : 1)

	proc/CheckerboardDistance(vector/offset)
		return max(abs(offset.X()), abs(offset.Y()))
