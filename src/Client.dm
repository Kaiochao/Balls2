
client
	tick_lag = 0.01

	New()
		. = ..()
		screen += new/obj/plane
		screen += new/obj/ball_renderer

	East()
		new/obj/ball(locate(rand(2, world.maxx - 1), rand(2, world.maxy - 1), 1))

	West()
		del(locate(/obj/ball))
