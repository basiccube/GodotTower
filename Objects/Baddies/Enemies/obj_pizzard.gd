extends obj_baddie

func _ready():
	grav = 0.5
	velocity.x = 0
	velocity.y = 0
	movespeed = 1
	state = global.states.walk
	stunned = 0
	straightthrow = false
	spr_idle = "walk"
	spr_stunfall = "stun"
	spr_walk = "walk"
	spr_grabbed = "stun"
	spr_scared = "stun"
	spr_dead = "pizzard_dead"
	hp = 2
	important = false
	bombreset = 0
	
func _process(delta):
	match state:
		global.states.idle:
			scr_enemy_idle()
		global.states.charge:
			scr_enemy_charge()
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
		global.states.pizzagoblinthrow:
			scr_pizzagoblin_throw()
		global.states.grabbed:
			scr_enemy_grabbed()
	var obj_player = utils.get_player()
	scr_scareenemy()
	if (bombreset > 0):
		bombreset -= 1
	if (position.x != obj_player.position.x && obj_player.state != global.states.knightpepslopes && obj_player.state != global.states.knightpep && state != global.states.pizzagoblinthrow && bombreset == 0 && is_on_floor()):
		if (obj_player.position.x > (position.x - 450) && obj_player.position.x < (position.x + 450) && position.y <= (obj_player.position.y + 70) && position.y >= (obj_player.position.y - 70)):
			if (state == global.states.walk):
				$Sprite.animation = "shoot"
				xscale = (-(sign(position.x - obj_player.position.x)))
				state = global.states.pizzagoblinthrow
	if (state != global.states.grabbed):
		z_index = 0
	if (state != global.states.stun):
		thrown = false
