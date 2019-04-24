extends MeshInstance

func _on_Area_body_entered(body):
	$".."/wtf.play("LeaverAnimation")
	#Animation.play("LeaverAnimation")
