extends RayCast

var slopeAngle

func getSlopeAngle():
	slopeAngle = rad2deg(acos(get_collision_normal().dot(Vector3(0, 1, 0))))
	return slopeAngle