extends obj_baddie

func _ready():
	grav = 0.5
	velocity.x = 0
	velocity.y = 0
	movespeed = 1
	state = global.states.walk
	stunned = 0
	straightthrow = false
	spr_idle = "idle"
	spr_stunfall = "stun"
	spr_walk = "walk"
	spr_grabbed = "stun"
	spr_scared = "scared"
	spr_dead = "pizzagoblin_dead"
	xscale = -1
	hp = 1
	bombreset = 0
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
		global.states.charge:
			scr_enemy_charge()
		global.states.pizzagoblinthrow:
			scr_pizzagoblin_throw()
		global.states.grabbed:
			scr_enemy_grabbed()
	var obj_player = utils.get_player()
	if (obj_player.position.x > (position.x - 450) && obj_player.position.x < (position.x + 450) && position.y <= (obj_player.position.y + 110) && position.y >= (obj_player.position.y - 110)):
		if (state != global.states.idle && obj_player.state == global.states.mach3):
			state = global.states.idle
			$Sprite.animation = spr_scared
			if (position.x != obj_player.position.x):
				xscale = (-(sign(position.x - obj_player.position.x)))
	if (state != global.states.grabbed):
		z_index = 0
	if (state != global.states.stun):
		thrown = false
	if (bombreset > 0):
		bombreset -= 1
	if (position.x != (obj_player.position.x + 50) && state != global.states.pizzagoblinthrow && obj_player.state != global.states.bombpep && bombreset == 0 && is_on_floor()):
		if (obj_player.position.x > (position.x - 450) && obj_player.position.x < (position.x + 450) && position.y <= (obj_player.position.y + 70) && position.y >= (obj_player.position.y - 70)):
			if (state == global.states.walk || state == global.states.idle):
				xscale = (-(sign(position.x - obj_player.position.x)))
				state = global.states.pizzagoblinthrow