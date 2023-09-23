tool
extends Area2D

export(String) var trigger = "0"
export(bool) var portal = false
var storedstate = global.states.normal
var storedmovespeed = 6
var storedgrav = 0.5
var storedsprite = "idle"
var storedfreefallsmash = 0
onready var sprite = $Sprite

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35
	if (!portal):
		$Sprite.animation = "teleportmachine"

func _process(delta):
	if Engine.editor_hint:
		if (portal):
			$Sprite.animation = "teleportportal"
		elif (!portal):
			$Sprite.animation = "teleportmachine"
	if !Engine.editor_hint:
		var obj_player = utils.get_player()
		if (overlaps_body(obj_player)):
			if (portal):
				if (obj_player.state != global.states.backbreaker):
					obj_player.visible = false
					storedstate = obj_player.state
					storedmovespeed = obj_player.movespeed
					storedgrav = obj_player.grav
					storedsprite = obj_player.sprite_index
					storedfreefallsmash = obj_player.freefallsmash
					var effect1 = utils.instance_create((position.x - 64) + utils.randi_range(-50, 50), (position.y - 64) + utils.randi_range(-50, 50), "res://Objects/Visuals/obj_cloudeffect.tscn")
					effect1.sprite.animation = "teleporteffect"
					var effect2 = utils.instance_create((position.x - 64) + utils.randi_range(-50, 50), (position.y - 64) + utils.randi_range(-50, 50), "res://Objects/Visuals/obj_cloudeffect.tscn")
					effect2.sprite.animation = "teleporteffect"
					var effect3 = utils.instance_create((position.x - 64) + utils.randi_range(-50, 50), (position.y - 64) + utils.randi_range(-50, 50), "res://Objects/Visuals/obj_cloudeffect.tscn")
					effect3.sprite.animation = "teleporteffect"
					var effect4 = utils.instance_create((position.x - 64) + utils.randi_range(-50, 50), (position.y - 64) + utils.randi_range(-50, 50), "res://Objects/Visuals/obj_cloudeffect.tscn")
					effect4.sprite.animation = "teleporteffect"
					var effect5 = utils.instance_create((position.x - 64) + utils.randi_range(-50, 50), (position.y - 64) + utils.randi_range(-50, 50), "res://Objects/Visuals/obj_cloudeffect.tscn")
					effect5.sprite.animation = "teleporteffect"
					var effect6 = utils.instance_create((position.x - 64) + utils.randi_range(-50, 50), (position.y - 64) + utils.randi_range(-50, 50), "res://Objects/Visuals/obj_cloudeffect.tscn")
					effect6.sprite.animation = "teleporteffect"
					var effect7 = utils.instance_create((position.x - 64) + utils.randi_range(-50, 50), (position.y - 64) + utils.randi_range(-50, 50), "res://Objects/Visuals/obj_cloudeffect.tscn")
					effect7.sprite.animation = "teleporteffect"
					var effect8 = utils.instance_create((position.x - 64) + utils.randi_range(-50, 50), (position.y - 64) + utils.randi_range(-50, 50), "res://Objects/Visuals/obj_cloudeffect.tscn")
					effect8.sprite.animation = "teleporteffect"
					$TeleportTimer.start()
					obj_player.velocity.x = 0
					obj_player.velocity.y = 0
					obj_player.grav = 0
					obj_player.hurttimer.start()
					obj_player.hurttimer2.start()
					obj_player.hurted = 1
					obj_player.state = global.states.backbreaker

func _on_TeleportEndTimer_timeout():
	var obj_player = utils.get_player()
	obj_player.visible = true
	obj_player.state = storedstate
	obj_player.movespeed = storedmovespeed
	obj_player.grav = storedgrav
	obj_player.set_animation(storedsprite)
	obj_player.freefallsmash = storedfreefallsmash

func _on_TeleportTimer_timeout():
	for teleport in get_tree().get_nodes_in_group("obj_teleporter"):
		if (teleport.trigger == trigger && !teleport.portal):
			var obj_player = utils.get_player()
			obj_player.position.x = (teleport.position.x - 32)
			obj_player.position.y = teleport.position.y
			var effect1 = utils.instance_create((teleport.position.x - 64) + utils.randi_range(-50, 50), (teleport.position.y - 64) + utils.randi_range(-50, 50), "res://Objects/Visuals/obj_cloudeffect.tscn")
			effect1.sprite.animation = "teleporteffect"
			var effect2 = utils.instance_create((teleport.position.x - 64) + utils.randi_range(-50, 50), (teleport.position.y - 64) + utils.randi_range(-50, 50), "res://Objects/Visuals/obj_cloudeffect.tscn")
			effect2.sprite.animation = "teleporteffect"
			var effect3 = utils.instance_create((teleport.position.x - 64) + utils.randi_range(-50, 50), (teleport.position.y - 64) + utils.randi_range(-50, 50), "res://Objects/Visuals/obj_cloudeffect.tscn")
			effect3.sprite.animation = "teleporteffect"
			var effect4 = utils.instance_create((teleport.position.x - 64) + utils.randi_range(-50, 50), (teleport.position.y - 64) + utils.randi_range(-50, 50), "res://Objects/Visuals/obj_cloudeffect.tscn")
			effect4.sprite.animation = "teleporteffect"
			var effect5 = utils.instance_create((teleport.position.x - 64) + utils.randi_range(-50, 50), (teleport.position.y - 64) + utils.randi_range(-50, 50), "res://Objects/Visuals/obj_cloudeffect.tscn")
			effect5.sprite.animation = "teleporteffect"
			var effect6 = utils.instance_create((teleport.position.x - 64) + utils.randi_range(-50, 50), (teleport.position.y - 64) + utils.randi_range(-50, 50), "res://Objects/Visuals/obj_cloudeffect.tscn")
			effect6.sprite.animation = "teleporteffect"
			var effect7 = utils.instance_create((teleport.position.x - 64) + utils.randi_range(-50, 50), (teleport.position.y - 64) + utils.randi_range(-50, 50), "res://Objects/Visuals/obj_cloudeffect.tscn")
			effect7.sprite.animation = "teleporteffect"
			var effect8 = utils.instance_create((teleport.position.x - 64) + utils.randi_range(-50, 50), (teleport.position.y - 64) + utils.randi_range(-50, 50), "res://Objects/Visuals/obj_cloudeffect.tscn")
			effect8.sprite.animation = "teleporteffect"
	$TeleportEndTimer.start()
