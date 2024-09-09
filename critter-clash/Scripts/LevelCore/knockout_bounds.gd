extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body.is_class("CharacterBody3D"):
		body.OutOfBounds()
	pass # Replace with function body.
