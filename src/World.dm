
world
	maxx = 50
	maxy = 50
	view = 35
	fps = 25
	turf = /turf/back

	New()
		..()
		spawn
			Loop()

		for(var/x in 1 to maxx)
			new/turf/wall(locate(x, 1, 1), Vector.north)
			new/turf/wall(locate(x, maxy, 1), Vector.south)

		for(var/y in 2 to maxy - 1)
			new/turf/wall(locate(1, y, 1), Vector.east)
			new/turf/wall(locate(maxx, y, 1), Vector.west)

	proc/Loop()
		while(TRUE)
			Tick()
			sleep(tick_lag)

	proc/Tick()
		for(var/obj/ball/ball as anything in Balls)
			ball.Tick()

proc/spawn_a_ball()
	new/obj/ball(locate(
		rand(1 + 2, world.maxx - 2),
		rand(1 + 2, world.maxy - 2),
		1))

proc/delete_a_ball()
	del(locate(/obj/ball))

proc/enable_ball_collision()
	BallCollision = TRUE

proc/disable_ball_collision()
	BallCollision = FALSE
