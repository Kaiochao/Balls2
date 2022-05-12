
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

	var/vector2/velocity
	var/bumped = FALSE

	New()
		..()
		Balls += src
		color = rgb(rand(360), 100, 100, space = COLORSPACE_HSV)
		velocity = Vector2.North.Turn(rand() * 360) * 32

	Del()
		Balls -= src
		..()

	Move()
		bumped = FALSE
		. = ..()

	Bump()
		..()
		bumped = TRUE

	proc/Tick()
		var/bounce_horizontal = FALSE
		var/bounce_vertical = FALSE
		var/vector2/motion = velocity * world.tick_lag
		var/moved_pixels = 0
		var/vector2/position = LowerPosition()
		step_size = 1#INF
		if(!(moved_pixels = Move(loc, dir, step_x + motion.x, step_y + motion.y)) || bumped)
			if(motion.x && motion.y)
				if(!(moved_pixels = max(moved_pixels, Move(loc, dir, step_x + motion.x, step_y))) || bumped)
					bounce_horizontal = TRUE
				if(!(moved_pixels = max(moved_pixels, Move(loc, dir, step_x, step_y + motion.y))) || bumped)
					bounce_vertical = TRUE
		step_size = CheckerboardDistance(LowerPosition() - position)
		velocity = new(
			bounce_horizontal ? -velocity.x : velocity.x,
			bounce_vertical ? -velocity.y : velocity.y)

	proc/CheckerboardDistance(vector2/offset)
		return max(abs(offset.x), abs(offset.y))
