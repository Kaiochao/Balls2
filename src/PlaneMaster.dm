
obj/plane
	screen_loc = "1,1"

	New()
		..()
		filters += filter(type = "drop_shadow", x = 0, y = -4, size = 8, color = rgb(0, 0, 0, 128))
		appearance_flags = PLANE_MASTER | KEEP_TOGETHER
