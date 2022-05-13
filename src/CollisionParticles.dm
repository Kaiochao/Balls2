
particles/collision
	velocity = generator("sphere", 32)
	spawning = 1e5
	lifespan = 1e5

obj/collision_particles
	New(vector/position, count, color)
		..()
		appearance_flags |= KEEP_TOGETHER
		loc = locate(1, 1, position.Z())
		step_x = position.X() - 16
		step_y = position.Y() - 16
		particles = new/particles/collision
		particles.count = count
		particles.color = color
		animate(src, time = 2, alpha = 0)
		spawn(3)
			loc = null
