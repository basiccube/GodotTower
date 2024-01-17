extends Node2D

# Object used for boss fights when the player has failed and is supposed to fall off the screen.

func _on_obj_bossfallend_body_entered(body):
	if body is obj_player:
		global.leveltorestart = ""
		global.roomtorestart = ""
		utils.get_player().scr_playerreset()
		global.targetDoor = "A"
		utils.room_goto("", "hub_room1")
