extends obj_baddie

func _ready():
	grav = 0.5
	velocity.x = 0
	velocity.y = 0
	movespeed = 1
	state = global.states.walk
	stunned = 0
	straightthrow = false
	spr_land = "bounce"
	spr_idle = "idle"
	spr_fall = "fall"
	spr_stunfall = "stun"
	spr_walk = "move"
	spr_turn = "turn"
	spr_recovery = "recovery"
	spr_grabbed = "grabbed"
	spr_scared = "scared"
	spr_dead = "slimedead"
	xscale = -1
	hp = 1
	important = false
	
func _process(delta):
	match state:
		global.states.idle:
			scr_enemy_idle()
		global.states.turn:
			scr_enemy_turn()
		global.states.walk:
			scr_enemy_walk()
		global.states.land:
			scr_enemy_land()
		global.states.hit:
			scr_enemy_hit()
		global.states.stun:
			scr_enemy_stun()
		global.states.grabbed:
			scr_enemy_grabbed()
	var obj_player = utils.get_player()
	if (obj_player.position.x > (position.x - 400) && obj_player.position.x < (position.x + 400) && position.y <= (obj_player.position.y + 60) && position.y >= (obj_player.position.y - 60)):
		if (state != global.states.idle && obj_player.state == global.states.mach3):
			state = global.states.idle
			$Sprite.animation = spr_scared
			if (position.x != obj_player.position.x):
				xscale = (-(sign(position.x - obj_player.position.x)))
	if (state != global.states.grabbed):
		z_index = 0
	if (state != global.states.stun):
		thrown = false