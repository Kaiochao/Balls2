
obj/plane
	screen_loc = "1,1"

	New()
		..()
		appearance_flags |= PLANE_MASTER | KEEP_TOGETHER
		filters += filter(
			type = "drop_shadow",
			x = 0,
			y = 0,
			size = 8,
			color = rgb(0, 0, 0, 200))
