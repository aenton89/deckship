extends Level



@export var lvl_camera: Camera2D



func on_level_entered() -> void:
	Global.UI.hud.visible = false
	Global.UI.menu.visible = true
	
	lvl_camera.make_current()
	
	#Global.player.position = Vector2(0, 0)
	
	print("Player global:", Global.player.global_position)
	print("Camera global:", lvl_camera.global_position)


func on_level_exited() -> void:
	Global.UI.menu.visible = false
	Global.UI.hud.visible = true
	Global.camera.make_current()
