
particles/collision
	width = 100
	height = 100
	count = 10
	spawning = 100000
	lifespan = 100
	position = list(0, 0, 0)
	velocity = generator("circle", 32)
	friction = 0.5

obj/collision_particles
	New(vector/position)
		..()
		appearance_flags |= KEEP_TOGETHER
		loc = locate(1, 1, position.Z())
		step_x = position.X() - 16
		step_y = position.Y() - 16
		particles = new/particles/collision
		animate(src, time = 2, alpha = 0)
		spawn(3)
			loc = null
