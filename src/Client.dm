
client
	tick_lag = 0.01

	New()
		. = ..()
		screen += new/obj/plane

	East()
		spawn_a_ball()

	West()
		delete_a_ball()

	North()
		enable_ball_collision()
		BallCollision = TRUE

	South()
		disable_ball_collision()
		BallCollision = FALSE
