extends AnimationPlayer


var played = false
func _on_Area_body_entered(body):
	if	!played:
		played = true
		play("LeaverAnimation")
		
