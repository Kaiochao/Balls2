
var/Collision = TRUE

world
	maxx = 25
	maxy = 25
	view = 35
	fps = 40
	turf = /turf/back

	New()
		..()
		spawn(1)
			Loop()

		for(var/x in 1 to maxx)
			new/turf/wall(locate(x, 1, 1), Vector.north)
			new/turf/wall(locate(x, maxy, 1), Vector.south)
		for(var/y in 1 to maxy)
			new/turf/wall(locate(1, y, 1), Vector.east)
			new/turf/wall(locate(maxx, y, 1), Vector.west)

	proc/Loop()
		while(TRUE)
			Tick()
			sleep(tick_lag)

	proc/Tick()
		var/list/position_of = new
		var/list/mtvs_of = new
		var/list/bounces_of = new
		var/list/bounds_of = new
		LoadBalls(position_of, bounces_of, mtvs_of, bounds_of)
		EdgeBalls(bounds_of, bounces_of, mtvs_of)
		if(Collision)
			CollideBalls(position_of, bounds_of, bounces_of, mtvs_of)
		ResolveBalls(mtvs_of, bounces_of)
		StepBalls()
		GlideBalls(position_of)

	proc/GlideBalls(list/position_of)
		for(var/obj/ball/ball as anything in Balls)
			var/vector/motion = ball.Position() - position_of[ball]
			ball.step_size = max(abs(motion.X()), abs(motion.Y()))

	proc/StepBalls()
		for(var/obj/ball/ball as anything in Balls)
			ball.Step(ball.velocity * tick_lag)

	proc/LoadBalls(list/position_of, list/bounces_of, list/mtvs_of, list/bounds_of)
		for(var/obj/ball/ball as anything in Balls)
			position_of[ball] = ball.Position()
			bounces_of[ball] = list()
			mtvs_of[ball] = list()
			bounds_of[ball] = obounds(ball)

	proc/EdgeBalls(list/bounds_of, list/bounces_of, list/mtvs_of)
		for(var/obj/ball/ball as anything in Balls)
			var/list/bounds = bounds_of[ball]
			for(var/turf/wall/wall in bounds)
				if(ball.velocity.Dot(wall.normal) < 0)
					bounces_of[ball] += ball.velocity.Bounce(wall.normal)
					mtvs_of[ball] += wall.normal * -bounds_dist(ball, wall)

	proc/CollideBalls(list/position_of, list/bounds_of, list/bounces_of, list/mtvs_of)
		for(var/i in 1 to Balls.len - 1)
			var/obj/ball/a = Balls[i]
			for(var/j in i + 1 to Balls.len)
				var/obj/ball/b = Balls[j]
				if(b in bounds_of[a])
					var/vector/a_to_b = position_of[b] - position_of[a]
					var/distance_squared = a_to_b.LengthSquared()
					if(distance_squared < 32 * 32)
						var/vector/p = a_to_b * ((a.velocity.Dot(a_to_b) - b.velocity.Dot(a_to_b)) / distance_squared)
						bounces_of[a] += a.velocity - p
						bounces_of[b] += b.velocity + p
						var/distance = sqrt(distance_squared)
						var/vector/mtv = a_to_b * ((32 - distance) / distance / 2)
						mtvs_of[a] += -mtv
						mtvs_of[b] += mtv

	proc/ResolveBalls(list/mtvs_of, list/bounces_of)
		for(var/obj/ball/ball as anything in Balls)
			if(length(mtvs_of[ball]))
				ball.Step(list_average(mtvs_of[ball]))
			if(length(bounces_of[ball]))
				ball.velocity = list_average(bounces_of[ball])

proc/list_average(list/xs)
	var/total
	for(var/x in xs)
		total += x
	return total / length(xs)
