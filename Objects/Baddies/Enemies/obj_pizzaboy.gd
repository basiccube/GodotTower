extends obj_baddie

func _ready():
	grav = 0.5
	velocity.x = 0
	velocity.y = 0
	movespeed = 0
	state = global.states.walk
	stunned = 0
	spr_land = "idle"
	spr_idle = "idle"
	spr_fall = "idle"
	spr_stunfall = "idle"
	spr_walk = "idle"
	spr_turn = "idle"
	spr_recovery = "idle"
	spr_grabbed = "idle"
	spr_scared = "idle"
	spr_dead = "idle"
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
	if (state == global.states.walk):
		state = global.states.idle
	if (state != global.states.grabbed):
		z_index = 0
	if (state != global.states.stun):
		thrown = false
