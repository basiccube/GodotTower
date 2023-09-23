extends obj_baddie

func _ready():
	grav = 0.5
	velocity.x = 0
	velocity.y = 0
	movespeed = 0
	state = global.states.walk
	stunned = 0
	spr_land = "pizzaboy"
	spr_idle = "pizzaboy"
	spr_fall = "pizzaboy"
	spr_stunfall = "pizzaboy"
	spr_walk = "pizzaboy"
	spr_turn = "pizzaboy"
	spr_recovery = "pizzaboy"
	spr_grabbed = "pizzaboy"
	spr_scared = "pizzaboy"
	spr_dead = "pizzaboy"
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
		global.states.pizzagoblinthrow:
			scr_pizzagoblin_throw()
		global.states.grabbed:
			scr_enemy_grabbed()
	if (state == global.states.walk):
		state = global.states.idle
	if (state != global.states.grabbed):
		z_index = 0
	if (state != global.states.stun):
		thrown = false
