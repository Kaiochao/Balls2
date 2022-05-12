
client
	tick_lag = 0.01

	New()
		. = ..()
		screen += new/obj/plane
		screen += new/obj/ball_renderer

	East()
		new/obj/ball(locate(
			rand(1 + 2, world.maxx - 2),
			rand(1 + 2, world.maxy - 2),
			1))

	West()
		del(locate(/obj/ball))

	North()
		Collision = TRUE

	South()
		Collision = FALSE
