
turf/back
	icon = 'rsc/square.dmi'
	color = rgb(100, 100, 100)
	plane = -1

turf/wall
	icon = 'rsc/square.dmi'
	color = rgb(50, 50, 50)

	var/vector/normal

	New(loc, vector/normal)
		..()
		src.normal = normal
