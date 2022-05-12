
world
	maxx = 50
	maxy = 50
	view = 35
	fps = 30
	turf = /turf/back

	New()
		..()
		spawn(10)
			Loop()

		for(var/x in 1 to maxx)
			for(var/y in 1 to maxy)
				if(x == 1 || x == maxx || y == 1 || y == maxy)
					new/turf/wall(locate(x, y, 1))

		for(var/x in 1 + 1 to maxx - 1 step 5)
			for(var/y in 1 + 1 to maxy - 1 step 5)
				new/obj/ball(locate(x, y, 1))

	proc/Loop()
		var/initial_name = name
		var/new_fps = fps
		while(TRUE)
			fps = new_fps
			Tick()
			if(tick_usage > 100 - map_cpu * 2)
				new_fps += (10 - new_fps) * 0.01
			else
				new_fps += (100 - new_fps) * 0.01
			name = "[initial_name] (cpu = [round(cpu)], mcpu = [map_cpu], fps = [round(fps)], nfps = [round(new_fps)], tu = [tick_usage])"
			sleep(tick_lag)

	proc/Tick()
		for(var/obj/ball/ball as anything in Balls)
			ball.Tick()
