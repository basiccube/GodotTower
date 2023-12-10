class_name obj_player
extends KinematicBody2D

const FLOOR_NORMAL = Vector2.UP
var grav = 0.5
var velocity = Vector2.ZERO

var xscale = 1
var yscale = 1
var dir = xscale
var movespeed = 19
var wallspeed = 0

var targetLevel = ""
var targetRoom = ""

var sprite_index

# TODO: Replace these with bools
var facehurt = 1
var steppy = 0
var jumpstop = 0
var mach2 = 0
var landAnim = 0
var jumpAnim = 1
var machslideAnim = 0
var machhitAnim = 0
var machpunchAnim = 0
var moveAnim = 1
var shotgunAnim = 0
var backupweapon = false
var windingAnim = 0
var stompAnim = 0
var stopAnim = 1
var crouchslideAnim = 1
var crouchAnim = 1
var facestompAnim = 0
var idle = 0
var idleanim = 0
var suplexmove = 0
var heavy = false
var lastmove = 0
var tauntstoredstate = global.states.normal
var tauntstoredmovespeed = 6
var tauntstoredsprite = "idle"
var taunttimer = 20
var fallinganimation = 0
var momemtum = 0
var superslam = 0
var swingdingbuffer = 0
var crouchslipbuffer = 0
var punch = 0
var anger = 0
var angry = 0
var input_buffer_jump = 8
var input_buffer_secondjump = 8
var input_buffer_highjump = 8
var ladderbuffer = 0
var freefallsmash = 0
var freefallstart = 0
var bounce = 0
var character = "P"
var crouchmask = false
var instakillmove = 0
var grabbing = 0
var toomuchalarm1 = 0
var toomuchalarm2 = 0
var flamecloud_buffer = 0
var bombpeptimer = 100
var baddiegrabbed = ""
var attacking = 0
var inv_frames = 0
var supercharged = false
var flash = false
var hurted = 0
var box = false
var cutscene = false
var indoor = false
var backtohubstartx = position.x
var backtohubstarty = position.y
var backtohubroom = "Realtitlescreen"
var lastroom = ""
var lastlevel = ""
var lastdoor = ""
var roomstartx = 0
var roomstarty = 0

onready var charactersprite = $PeppinoSprite

onready var hurttimer = $HurtTimer
onready var hurttimer2 = $HurtTimer2
onready var floorcheck = $FloorCheck

var state = global.states.titlescreen

func _ready():
	var SaveManager = ConfigFile.new()
	var SaveData = SaveManager.load("user://saveData.ini")
	global.option_fullscreen = SaveManager.get_value("Option", "fullscreen", false)
	global.option_resolution = SaveManager.get_value("Option", "resolution", 1)
	global.option_mastervolume = SaveManager.get_value("Option", "mastervolume", 1)
	global.option_musicvolume = SaveManager.get_value("Option", "musicvolume", 1)
	global.option_sfxvolume = SaveManager.get_value("Option", "sfxvolume", 1)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(global.option_mastervolume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(global.option_musicvolume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(global.option_sfxvolume))
	if (global.option_fullscreen):
		OS.window_fullscreen = true
	else:
		OS.window_fullscreen = false
	if (global.option_resolution == 0):
		OS.window_size = Vector2(480, 270)
	if (global.option_resolution == 1):
		OS.window_size = Vector2(960, 540)
	if (global.option_resolution == 2):
		OS.window_size = Vector2(1920, 1080)

func _process(delta):
	charactersprite.playing = true
	sprite_index = charactersprite.animation
	if (character == "P"):
		charactersprite = $PeppinoSprite
		$PeppinoSprite.visible = true
		$NoiseSprite.visible = false
	elif (character == "N"):
		charactersprite = $NoiseSprite
		$PeppinoSprite.visible = false
		$NoiseSprite.visible = true
	charactersprite.material.set_shader_param("current_palette", global.peppalette)
	charactersprite.material.set_shader_param("flash", flash)
	position.x += velocity.x
	position.y += velocity.y
	velocity.x = clamp(velocity.x, -500, 500)
	velocity.y = clamp(velocity.y, -50, 50)
	charactersprite.flip_h = true if xscale == -1 else false
	$SolidCheck.scale.x = xscale
	$SolidCheck2.scale.x = xscale
	$WallClimbCheck.scale.x = xscale
	$DestructibleArea.scale.x = xscale
	if "finishingblow" in charactersprite.animation:
		charactersprite.offset.x = 20 * xscale
	else:
		charactersprite.offset.x = 0
	if crouchmask:
		$CrouchCollision.set_deferred("disabled", false)
		$PlayerCollision.set_deferred("disabled", true)
		$CrouchCheck.enabled = true
	else:
		$CrouchCollision.set_deferred("disabled", true)
		$PlayerCollision.set_deferred("disabled", false)
		$CrouchCheck.enabled = false
	for destructible in $DestructibleArea.get_overlapping_bodies():
		if (destructible.is_in_group("obj_destructibles")):
			if (!destructible.is_in_group("obj_specialdestructibles")):
				if (state == global.states.mach2 || state == global.states.mach3 || state == global.states.machroll || state == global.states.knightpepslopes || state == global.states.tumble || state == global.states.crouchslide || state == global.states.faceplant):
					destructible.destroy()
					if (state == global.states.mach2):
						machpunchAnim = 1
				if ((state == global.states.knightpep || state == global.states.superslam) && velocity.y > 0):
					destructible.destroy()
				if (state == global.states.handstandjump || state == global.states.shoulderbash):
					if (destructible.is_in_group("obj_bigdestructibles")):
						if (shotgunAnim == 0):
							var rng = utils.randi_range(1, 5)
							if (rng == 1):
								charactersprite.animation = "suplexmash1"
							elif (rng == 2):
								charactersprite.animation = "suplexmash2"
							elif (rng == 3):
								charactersprite.animation = "suplexmash3"
							elif (rng == 4):
								charactersprite.animation = "suplexmash4"
							elif (rng == 5):
								charactersprite.animation = "punch"
							state = global.states.tackle
							movespeed = 3
							velocity.y = -3
							destructible.destroy()
						else:
							state = global.states.shotgun
							charactersprite.animation = "shotgun"
							utils.instance_create(global_position.x + (xscale * 20), global_position.y + 20, "res://Objects/Misc/obj_shotgunbullet.tscn")
							var bulletid = utils.instance_create(global_position.x + (xscale * 20), global_position.y + 20, "res://Objects/Misc/obj_shotgunbullet.tscn")
							bulletid.spdh = 4
							var bulletid2 = utils.instance_create(global_position.x + (xscale * 20), global_position.y + 20, "res://Objects/Misc/obj_shotgunbullet.tscn")
							bulletid2.spdh = -4
							destructible.destroy()
					if (!destructible.is_in_group("obj_bigdestructibles")):
						destructible.destroy()
			if (destructible.is_in_group("obj_specialdestructibles")):
				if (destructible.is_in_group("obj_rollblock") && state == global.states.tumble):
					destructible.destroy()
				if (destructible.is_in_group("obj_bombblock") && state == global.states.bombpep && charactersprite.animation != "bombpep_end"):
					destructible.destroy()
					hurted = 1
					velocity.y = -4
					utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_bombexplosion.tscn")
					charactersprite.animation = "bombpep_end"
					bombpeptimer = 0
		if (destructible.is_in_group("obj_metalblock")):
			if (state == global.states.mach3 || state == global.states.knightpepslopes):
				destructible.destroy()
		if (destructible.is_in_group("obj_baddie")):
			if (destructible.state != global.states.grabbed && !cutscene):
				if (state == global.states.shoulderbash):
					utils.playsound("Punch")
					global.hit += 1
					global.combotime = 60
					if (!is_on_floor()):
						charactersprite.animation = "ungroundedattack"
						velocity.y = -2
					else:
						var rng = utils.randi_range(1, 2)
						charactersprite.animation = "attack" + str(rng)
					destructible.destroy()
				if (state == global.states.faceplant):
					utils.playsound("Punch")
					global.hit += 1
					global.combotime = 60
					destructible.destroy()
		if (destructible.is_in_group("obj_hungrypillar")):
			if (state == global.states.shoulderbash):
				destructible.destroy()
	for destructible in $JumpArea.get_overlapping_bodies():
		if (destructible.is_in_group("obj_destructibles") && !destructible.is_in_group("obj_specialdestructibles")):
			if (velocity.y <= 0.5 && (state == global.states.jump || state == global.states.fireass || state == global.states.mach2 || state == global.states.mach3)):
				destructible.destroy()
				velocity.y = 0
	for destructible in $SJumpArea.get_overlapping_bodies():
		if (destructible.is_in_group("obj_destructibles") && !destructible.is_in_group("obj_specialdestructibles")):
			if (velocity.y <= 0.5 && (state == global.states.Sjump || state == global.states.climbwall)):
				destructible.destroy()
	for destructible in $FallArea.get_overlapping_bodies():
		if (destructible.is_in_group("obj_destructibles") && !destructible.is_in_group("obj_specialdestructibles")):
			if (velocity.y >= 0 && (state == global.states.freefall || state == global.states.freefallland)):
				if (destructible.is_in_group("obj_bigdestructibles")):
					if (shotgunAnim == 0):
						charactersprite.animation = "bodyslamland"
					else:
						charactersprite.animation = "shotgunjump2"
					state = global.states.freefallland
				destructible.destroy()
		if (destructible.is_in_group("obj_specialdestructibles")):
			if (destructible.is_in_group("obj_bombblock") && state == global.states.bombpep && charactersprite.animation != "bombpep_end"):
				destructible.destroy()
				hurted = 1
				velocity.y = -4
				utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_bombexplosion.tscn")
				charactersprite.animation = "bombpep_end"
				bombpeptimer = 0
		if (destructible.is_in_group("obj_metalblock")):
			if (state == global.states.freefall || state == global.states.freefallland):
				if (freefallsmash >= 10):
					if (shotgunAnim == 0):
						charactersprite.animation = "bodyslamland"
					else:
						charactersprite.animation = "shotgunjump2"
					state = global.states.freefallland
					destructible.destroy()
			if (state == global.states.knightpep):
				destructible.destroy()
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider != null:
			if collision.collider.is_in_group("obj_boilingsauce"):
				if (state != global.states.gameover):
					state = global.states.fireass
					velocity.y = -25
					charactersprite.animation = "fireass"
					utils.playsound("Scream5")
			if collision.collider.is_in_group("obj_hungrypillar"):
				if (state == global.states.handstandjump):
					state = global.states.finishingblow
					var rng = utils.randi_range(1, 5)
					if (rng == 1):
						charactersprite.animation = "finishingblow1"
					elif (rng == 2):
						charactersprite.animation = "finishingblow2"
					elif (rng == 3):
						charactersprite.animation = "finishingblow3"
					elif (rng == 4):
						charactersprite.animation = "finishingblow4"
					elif (rng == 5):
						charactersprite.animation = "finishingblow5"
					velocity.x = 0
					movespeed = 0
				if (instakillmove == 1):
					collision.collider.destroy()
			if collision.collider.is_in_group("obj_hurtbox"):
				destroy(collision.collider)
			if collision.collider.is_in_group("obj_baddie"):
				var baddie = collision.collider
				if (baddie.state != global.states.grabbed && !cutscene):
					if (instakillmove == 1):
						if (state == global.states.mach3 && charactersprite.animation != "mach3hit"):
							charactersprite.animation = "mach3hit"
						if (state == global.states.mach2 && is_on_floor()):
							machpunchAnim = 1
						utils.playsound("Punch")
						global.hit += 1
						global.combotime = 60
						if (!is_on_floor() && state != global.states.freefall && Input.is_action_just_pressed("key_jump")):
							if (state == global.states.mach3 || state == global.states.mach2):
								charactersprite.animation = "mach2jump"
							suplexmove = 0
							velocity.y = -11
						baddie.destroy()
					if (state == global.states.slipnslide):
						utils.playsound("Punch")
						global.hit += 1
						global.combotime = 60
						baddie.destroy()
					if (global_position.y < baddie.global_position.y && attacking == 0 && charactersprite.animation != "mach2jump" && (state == global.states.jump || state == global.states.mach1 || state == global.states.grab) && velocity.y >= 0 && baddie.velocity.y >= 0 && charactersprite.animation != "stompprep"):
						utils.playsound("Stomp")
						baddie.state = global.states.stun
						if (baddie.stunned < 100):
							baddie.stunned = 100
						if Input.is_action_just_pressed("key_jump"):
							utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_stompeffect.tscn")
							stompAnim = 1
							velocity.y = -14
							if (state != global.states.grab):
								charactersprite.animation = "stompprep"
						else:
							utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_stompeffect.tscn")
							stompAnim = 1
							velocity.y = -9
							if (state != global.states.grab):
								charactersprite.animation = "stompprep"
					if (baddie.state != global.states.pizzagoblinthrow && baddie.velocity.y >= 0 && state != global.states.tackle && state != global.states.superslam && state != global.states.machslide && state != global.states.freefall && state != global.states.mach2 && state != global.states.handstandjump && state != global.states.shoulderbash && state != global.states.mach3 && state != global.states.machroll && state != global.states.slipnslide && state != global.states.knightpepslopes):
						utils.playsound("Bump")
						if (state != global.states.bombpep && state != global.states.mach1):
							movespeed = 0
						if (baddie.is_in_group("obj_pizzaball")):
							global.golfhit += 1
						if (baddie.stunned < 100):
							baddie.stunned = 100
						baddie.velocity.y = -5
						baddie.velocity.x = ((xscale) * 5)
						baddie.state = global.states.stun
					if (state == global.states.superslam || state == global.states.freefall):
						utils.playsound("HitEnemy")
						global.combotime = 60
						utils.instance_create(baddie.global_position.x, baddie.global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
						baddie.state = global.states.stun
						baddie.hp -= 1
						if (baddie.stunned < 100):
							baddie.stunned = 100
						utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_bumpeffect.tscn")
						utils.instance_create(baddie.global_position.x, baddie.global_position.y, "res://Objects/Visuals/obj_bangeffect.tscn")
						if (baddie.hp <= 0):
							baddie.stunned = 200
							baddie.state = global.states.stun
						velocity.y = -7
						state = global.states.normal
						baddie.velocity.y = -4
						baddie.velocity.x = (xscale * 5)
					if (state == global.states.handstandjump):
						if (shotgunAnim == 0):
							movespeed = 0
							charactersprite.animation = "haulingstart"
							state = global.states.grab
							baddie.state = global.states.grabbed
						else:
							state = global.states.shotgun
							var effectid = utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_pistoleffect.tscn")
							effectid.xscale = xscale
							charactersprite.animation = "shotgun"
							utils.instance_create(global_position.x + (xscale * 20), global_position.y + 20, "res://Objects/Misc/obj_shotgunbullet.tscn")
							var bulletid = utils.instance_create(global_position.x + (xscale * 20), global_position.y + 20, "res://Objects/Misc/obj_shotgunbullet.tscn")
							bulletid.spdh = 4
							var bulletid2 = utils.instance_create(global_position.x + (xscale * 20), global_position.y + 20, "res://Objects/Misc/obj_shotgunbullet.tscn")
							bulletid2.spdh = -4
							baddie.destroy()
							global.hit += 1
							global.combotime = 60
	match state:
		global.states.normal:
			scr_player_normal()
		global.states.jump:
			scr_player_jump()
		global.states.backbreaker:
			scr_player_backbreaker()
		global.states.crouch:
			scr_player_crouch()
		global.states.crouchjump:
			scr_player_crouchjump()
		global.states.crouchslide:
			scr_player_crouchslide()
		global.states.freefallprep:
			scr_player_freefallprep()
		global.states.freefall:
			scr_player_freefall()
		global.states.freefallland:
			scr_player_freefallland()
		global.states.bump:
			scr_player_bump()
		global.states.comingoutdoor:
			scr_player_comingoutdoor()
		global.states.door:
			scr_player_door()
		global.states.handstandjump:
			scr_player_handstandjump()
		global.states.shoulderbash:
			scr_player_shoulderbash()
		global.states.hurt:
			scr_player_hurt()
		global.states.mach1:
			scr_player_mach1()
		global.states.mach2:
			scr_player_mach2()
		global.states.mach3:
			scr_player_mach3()
		global.states.machfreefall:
			scr_player_machfreefall()
		global.states.machslide:
			scr_player_machslide()
		global.states.machroll:
			scr_player_machroll()
		global.states.tumble:
			scr_player_tumble()
		global.states.climbwall:
			scr_player_climbwall()
		global.states.titlescreen:
			scr_player_titlescreen()
		global.states.Sjump:
			scr_player_Sjump()
		global.states.Sjumpland:
			scr_player_Sjumpland()
		global.states.Sjumpprep:
			scr_player_Sjumpprep()
		global.states.fireass:
			scr_player_fireass()
		global.states.timesup:
			scr_player_timesup()
		global.states.gameover:
			scr_player_gameover()
		global.states.victory:
			scr_player_victory()
		global.states.grab:
			scr_player_grab()
		global.states.superslam:
			scr_player_superslam()
		global.states.finishingblow:
			scr_player_finishingblow()
		global.states.ladder:
			scr_player_ladder()
		global.states.tackle:
			scr_player_tackle()
		global.states.gottreasure:
			scr_player_gottreasure()
		global.states.slipnslide:
			scr_player_slipnslide()
		global.states.knightpep:
			scr_player_knightpep()
		global.states.knightpepattack:
			scr_player_knightpepattack()
		global.states.knightpepslopes:
			scr_player_knightpepslopes()
		global.states.bombpep:
			scr_player_bombpep()
		global.states.keyget:
			scr_player_keyget()
		global.states.shotgun:
			scr_player_shotgun()
		global.states.portal:
			scr_player_portal()
		global.states.faceplant:
			scr_player_faceplant()
		global.states.ejected:
			scr_player_ejected()
	scr_playersounds()
	if (global.combo >= global.combomilestone && state != global.states.backbreaker):
		supercharged = true
		global.combomilestone += 10
	if (!utils.instance_exists("obj_superchargeeffect") && supercharged):
		var effectid = utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_superchargeeffect.tscn")
		effectid.playerid = name
	if (is_on_floor() && state != global.states.handstandjump):
		suplexmove = 0
	if (state != global.states.freefall):
		freefallsmash = 0
	if (!(state == global.states.grab || state == global.states.superslam || state == global.states.mach2)):
		baddiegrabbed = ""
	if (anger == 0):
		angry = 0
	if (anger > 0):
		angry = 1
		anger -= 1
	if (charactersprite.animation == "winding" && state != global.states.normal):
		windingAnim = 0
	if (global.combotime > 0 && !cutscene):
		global.combotime -= 0.15
	global.combotime = clamp(global.combotime, 0, 60)
	if (global.combotime <= 0 && global.combo != 0):
		global.combotime = 0
		global.combodropped = true
		global.combo = 0
		global.combomilestone = 3
	if (input_buffer_jump < 8):
		input_buffer_jump += 1
	if (input_buffer_secondjump < 8):
		input_buffer_secondjump += 1
	if (input_buffer_highjump < 8):
		input_buffer_highjump += 1
	if (inv_frames == 0 && hurted == 0):
		modulate.a = 1
	if (state == global.states.mach2 || state == global.states.knightpep || state == global.states.knightpepslopes || state == global.states.knightpepattack || state == global.states.facestomp || state == global.states.cheesepep || state == global.states.bombpep || state == global.states.machfreefall || state == global.states.machroll || state == global.states.mach3 || state == global.states.freefall || state == global.states.Sjump):
		attacking = 1
	else:
		attacking = 0
	if (state == global.states.throw || state == global.states.punch || state == global.states.backkick || state == global.states.shoulder || state == global.states.uppunch):
		grabbing = 1
	else:
		grabbing = 0
	if (state == global.states.mach3 || state == global.states.mach2 || state == global.states.climbwall || state == global.states.freefall || state == global.states.tumble || state == global.states.fireass || state == global.states.Sjump || state == global.states.machroll || state == global.states.machfreefall || (state == global.states.superslam && charactersprite.animation == "piledriver") || state == global.states.knightpep || state == global.states.knightpepattack || state == global.states.knightpepslopes || state == global.states.faceplant || state == global.states.shoulderbash || (state == global.states.crouchslide && (charactersprite.animation == "jumpdive1" || charactersprite.animation == "jumpdive2"))):
		instakillmove = 1
	else:
		instakillmove = 0
	if (flash && $WhiteFlashTimer.is_stopped()):
		$WhiteFlashTimer.wait_time = 0.1
		$WhiteFlashTimer.start()
	if ((state != global.states.jump && state != global.states.crouchjump) || velocity.y < 0):
		fallinganimation = 0
	if state != global.states.normal:
		facehurt = 0
	if state != global.states.normal && state != global.states.machslide:
		machslideAnim = 0
	if (state != global.states.normal && state != global.states.jump && state != global.states.mach1 && state != global.states.mach2 && state != global.states.mach3 && state != global.states.handstandjump && state != global.states.freefallprep && state != global.states.knightpep && state != global.states.shotgun && state != global.states.knightpepslopes):
		momemtum = 0
	if state != global.states.normal:
		idle = 0
	if (state != global.states.facestomp):
		facestompAnim = 0
	if (state != global.states.freefall && state != global.states.facestomp && state != global.states.superslam && state != global.states.freefallland):
		superslam = 0
	if state != global.states.mach2:
		machpunchAnim = 0
	if state != global.states.jump:
		ladderbuffer = 0
	if state != global.states.jump:
		stompAnim = 0
	if ((state == global.states.mach3 || state == global.states.mach2 || state == global.states.climbwall || state == global.states.machroll || state == global.states.handstandjump || state == global.states.shoulderbash || state == global.states.machslide) && (!utils.instance_exists("obj_mach3effect"))):
		toomuchalarm1 = 6
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_mach3effect.tscn")
	if (toomuchalarm1 > 0):
		toomuchalarm1 -= 1
		if (toomuchalarm1 <= 0 && (state == global.states.mach3 || state == global.states.mach2 || state == global.states.climbwall || state == global.states.machroll || state == global.states.handstandjump || state == global.states.shoulderbash || state == global.states.machslide)):
			utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_mach3effect.tscn")
			toomuchalarm1 = 6
	if (!$CrouchCheck.is_colliding()):
		if (state != global.states.bump && charactersprite.animation != "bombpep_intro" && charactersprite.animation != "knightpep_thunder" && state != global.states.tumble && state != global.states.fireass && state != global.states.crouch && state != global.states.machroll && state != global.states.hurt && state != global.states.crouchslide && state != global.states.crouchjump):
			crouchmask = false
		else:
			crouchmask = true
	else:
		crouchmask = true
	if (state == global.states.gottreasure || charactersprite.animation == "knightpep_start" || charactersprite.animation == "knightpep_thunder" || state == global.states.keyget || state == global.states.door || state == global.states.ejected || state == global.states.victory || state == global.states.comingoutdoor || state == global.states.gameover || state == global.states.portal):
		cutscene = true
	else:
		cutscene = false
	if (indoor && !utils.instance_exists("obj_uparrow")):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_uparrow.tscn")
	if (state == global.states.mach2 && (!utils.instance_exists("obj_speedlines"))):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_speedlines.tscn")

func _physics_process(delta):
	var snap_vector = Vector2.ZERO
	if (!Input.is_action_pressed("key_jump") && (state != global.states.jump && state != global.states.ladder && state != global.states.climbwall && state != global.states.Sjump && state != global.states.Sjumpprep && state != global.states.bump && state != global.states.crouchjump && state != global.states.tumble)):
		for slope in $SlopeArea.get_overlapping_bodies():
			if (slope.is_in_group("obj_slope")):
				if (state == global.states.mach2 || state == global.states.mach3 || state == global.states.tumble || state == global.states.machslide):
					if (velocity.y < -6):
						velocity.y = 0
				snap_vector = Vector2.DOWN * 20
	if state != global.states.titlescreen && state != global.states.gameover && state != global.states.ejected && charactersprite.animation != "ungroundedattack" && charactersprite.animation != "attack1" && charactersprite.animation != "attack2":
		if state != global.states.backbreaker && state != global.states.finishingblow && state != global.states.portal && state != global.states.gottreasure && state != global.states.Sjumpland && state != global.states.ladder && state != global.states.keyget && (state != global.states.door && (charactersprite.animation != "downpizzabox" && charactersprite.animation != "uppizzabox")):
			if (velocity.y < 30):
				velocity.y += grav
		velocity = move_and_slide_with_snap(velocity, snap_vector, FLOOR_NORMAL, true, 4, 1)
		
func get_sprite_frame():
	return charactersprite.frames.get_frame(charactersprite.animation, charactersprite.frame)
	
func get_frame():
	return charactersprite.frame
	
func is_last_frame():
	if (charactersprite.frame == charactersprite.frames.get_frame_count(charactersprite.animation) - 1):
		return true
	else:
		return false
	
func set_animation(anim: String):
	charactersprite.animation = anim
	
func place_meeting(collisionpos: Vector2, object: String):
	var collisiondata = move_and_collide(collisionpos, true, true, true)
	if collisiondata != null:
		if collisiondata.collider != null:
			if collisiondata.collider.is_in_group(object):
				return true
			else:
				return false
		else:
			return false
			
func is_colliding_with_wall():
	if (state == global.states.mach1 || state == global.states.normal || state == global.states.machslide || state == global.states.slipnslide):
		if ((($SolidCheck.is_colliding() && $SolidCheck.get_collider() != null && ($SolidCheck.get_collider().is_in_group("obj_solid") || $SolidCheck.get_collider().is_in_group("obj_destructibles") || $SolidCheck.get_collider().is_in_group("obj_specialdestructibles") || $SolidCheck.get_collider().is_in_group("obj_metalblock"))) || ($SolidCheck2.is_colliding() && $SolidCheck2.get_collider() != null && ($SolidCheck2.get_collider().is_in_group("obj_solid") || $SolidCheck2.get_collider().is_in_group("obj_destructibles") || $SolidCheck2.get_collider().is_in_group("obj_specialdestructibles") || $SolidCheck2.get_collider().is_in_group("obj_metalblock")))) && !utils.instance_exists("obj_fadeout")):
			return true
		else:
			return false
	elif (state == global.states.mach2 || state == global.states.machroll || state == global.states.tumble || state == global.states.faceplant):
		if ((($SolidCheck.is_colliding() && $SolidCheck.get_collider() != null && ($SolidCheck.get_collider().is_in_group("obj_solid") || $SolidCheck.get_collider().is_in_group("obj_specialdestructibles") || $SolidCheck.get_collider().is_in_group("obj_metalblock"))) || ($SolidCheck2.is_colliding() && $SolidCheck2.get_collider() != null && $SolidCheck2.get_collider().is_in_group("obj_solid"))) && !utils.instance_exists("obj_fadeout")):
			return true
		else:
			return false
	else:
		if ((($SolidCheck.is_colliding() && $SolidCheck.get_collider() != null && ($SolidCheck.get_collider().is_in_group("obj_solid") || $SolidCheck.get_collider().is_in_group("obj_specialdestructibles"))) || ($SolidCheck2.is_colliding() && $SolidCheck2.get_collider() != null && $SolidCheck2.get_collider().is_in_group("obj_solid"))) && !utils.instance_exists("obj_fadeout")):
			return true
		else:
			return false
		
func is_wallclimbable():
	if ((($SolidCheck.is_colliding() && $SolidCheck.get_collider() != null && ($SolidCheck.get_collider().is_in_group("obj_solid") || $SolidCheck.get_collider().is_in_group("obj_specialdestructibles"))) || ($WallClimbCheck.is_colliding() && $WallClimbCheck.get_collider() != null && $WallClimbCheck.get_collider().is_in_group("obj_solid")))):
		return true
	else:
		return false
		
func is_colliding_wallclimb():
	if ($SolidCheck.is_colliding() || $WallClimbCheck.is_colliding()):
		return true
	else:
		return false
		
func is_colliding():
	if ($SolidCheck.is_colliding() || $SolidCheck2.is_colliding()):
		return true
	else:
		return false
		
func destroy(collider):
	if ((state == global.states.knightpep || state == global.states.knightpepattack || state == global.states.knightpepslopes) && !cutscene):
		if (collider.is_in_group("obj_grandpa")):
			collider.destroy()
	elif (state == global.states.bombpep && hurted == 0):
		if (collider.is_in_group("obj_spike")):
			$Bombpep2.play()
			velocity.y = -4
			utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_bombexplosion.tscn")
			charactersprite.animation = "bombpep_end"
			state = global.states.bombpep
			bombpeptimer = 0
			hurted = 1
	elif (state == global.states.tumble):
		pass
	elif (state == global.states.cheesepep || state == global.states.cheesepepstick):
		pass
	elif (state != global.states.hurt && hurted == 0 && state != global.states.bump && !cutscene):
		if collider.is_in_group("obj_forkhitbox"):
			position.x += (8 * (-xscale))
		if (collider.is_in_group("obj_minijohn_hitbox") && (instakillmove == 1 || state == global.states.punch || state == global.states.handstandjump)):
			return
		utils.playsound("PepHurt")
		$HurtTimer.wait_time = 1
		$HurtTimer.start()
		$HurtTimer2.wait_time = 2
		$HurtTimer2.start()
		hurted = 1
		if (xscale == collider.scale.x):
			charactersprite.animation = "hurtjump"
		else:
			charactersprite.animation = "hurt"
		
		movespeed = 8
		velocity.y = -5
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_spikehurteffect.tscn")
		state = global.states.hurt
		if (shotgunAnim == 0):
			global.hurtcounter += 1
			global.style -= 10
			if (global.collect > 100):
				global.collect -= 100
			else:
				global.collect = 0
			if (global.collect != 0):
				utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_pizzaloss.tscn")
				utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_pizzaloss.tscn")
				utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_pizzaloss.tscn")
				utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_pizzaloss.tscn")
				utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_pizzaloss.tscn")
				utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_pizzaloss.tscn")
				utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_pizzaloss.tscn")
				utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_pizzaloss.tscn")
				utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_pizzaloss.tscn")
				utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_pizzaloss.tscn")
				utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_pizzaloss.tscn")
				utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_pizzaloss.tscn")
		else:
			var shotgunid = utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_sausageman_dead.tscn")
			shotgunid.sprite_index = load("res://Objects/Collectibles/sprites/shotgun/shotgunback_0.png")
			if (backupweapon):
				backupweapon = false
			else:
				shotgunAnim = 0
	
func scr_dotaunt():
	if Input.is_action_just_pressed("key_taunt"):
		$Taunt.play()
		taunttimer = 20
		tauntstoredmovespeed = movespeed
		tauntstoredsprite = charactersprite.animation
		tauntstoredstate = state
		state = global.states.backbreaker
		if (supercharged):
			var rng = utils.randi_range(1, 4)
			charactersprite.animation = "supertaunt" + str(rng)
		else:
			charactersprite.animation = "taunt"
			charactersprite.frame = utils.randi_range(0, charactersprite.frames.get_frame_count(charactersprite.animation) - 1)
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_taunteffect.tscn")
	
func scr_player_normal():
	if (dir != xscale):
		dir = xscale
		movespeed = 2
		facehurt = 0
	mach2 = 0
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	velocity.x = (move * movespeed)
	if (machslideAnim == 0 && landAnim == 0 && shotgunAnim == 0):
		if (move == 0):
			if (idle < 400):
				idle += 1
			if (idle >= 150 && is_last_frame()):
				facehurt = 0
				idle = 0
			if (idle >= 150 && charactersprite.animation != "idleanim1" && charactersprite.animation != "idleanim2" && charactersprite.animation != "idleanim3" && charactersprite.animation != "idleanim4" && charactersprite.animation != "idleanim5" && charactersprite.animation != "idleanim6"):
				randomize()
				idleanim = utils.randi_range(0, 100)
				if (idleanim <= 16):
					charactersprite.animation = "idleanim1"
				if (idleanim > 16 && idleanim < 32):
					charactersprite.animation = "idleanim2"
				if (idleanim > 32 && idleanim < 48):
					charactersprite.animation = "idleanim3"
				if (idleanim > 48 && idleanim < 64):
					charactersprite.animation = "idleanim4"
				if (idleanim > 64 && idleanim < 80):
					charactersprite.animation = "idleanim5"
				if (idleanim > 80):
					charactersprite.animation = "idleanim6"
			if (idle < 150):
				if (facehurt == 0):
					if (windingAnim < 1800 || angry == 1):
						movespeed = 0
						if (global.minutes == 0 && global.seconds == 0):
							charactersprite.animation = "hurtidle"
						elif (global.panic || global.timeattack):
							charactersprite.animation = "panic"
						elif (angry):
							charactersprite.animation = "3hpidle"
						else:
							charactersprite.animation = "idle"
					else:
						idle = 0
						windingAnim -= 1
						charactersprite.animation = "winding"
				elif (facehurt == 1):
					windingAnim = 0
					if (charactersprite.animation != "facehurtup" && charactersprite.animation != "facehurt"):
						charactersprite.animation = "facehurtup"
					if (is_last_frame() && charactersprite.animation == "facehurtup"):
						charactersprite.animation = "facehurt"
		if (move != 0):
			machslideAnim = 0
			idle = 0
			facehurt = 0
			if (global.minutes == 0 && global.seconds == 0):
				charactersprite.animation = "hurtwalk"
			elif (angry):
				charactersprite.animation = "3hpwalk"
			else:
				charactersprite.animation = "move"
		if (move != 0):
			xscale = move
	if (landAnim == 1):
		if (shotgunAnim == 0):
			if (move == 0):
				movespeed = 0
				charactersprite.animation = "land"
				if (is_last_frame()):
					landAnim = 0
			if (move != 0):
				charactersprite.animation = "land2"
				if (is_last_frame()):
					landAnim = 0
					charactersprite.animation = "move"
		if (shotgunAnim == 1):
			charactersprite.animation = "shotgun_land"
			if (is_last_frame()):
				landAnim = 0
				charactersprite.animation = "move"
	if (machslideAnim == 1):
		charactersprite.animation = "machslideend"
		if (is_last_frame() && charactersprite.animation == "machslideend"):
			machslideAnim = 0
	if (charactersprite.animation == "shotgun" && is_last_frame()):
		charactersprite.animation = "shotgun_idle"
	if (landAnim == 0):
		if (shotgunAnim == 1 && move == 0 && charactersprite.animation != "shotgun"):
			charactersprite.animation = "shotgun_idle"
		elif (shotgunAnim == 1 && charactersprite.animation != "shotgun"):
			charactersprite.animation = "shotgun_walk"
	if (is_on_wall() && xscale == 1 && move == 1):
		movespeed = 0
	if (is_on_wall() && xscale == -1 && move == -1):
		movespeed = 0
	jumpstop = 0
	if (!is_on_floor() && !Input.is_action_just_pressed("key_jump")):
		if (shotgunAnim == 0):
			charactersprite.animation = "fall"
		else:
			charactersprite.animation = "shotgun_fall"
		jumpAnim = 0
		state = global.states.jump
	if (Input.is_action_just_pressed("key_jump") && is_on_floor() && !Input.is_action_pressed("key_down")):
		$Jump.play()
		charactersprite.animation = "jump"
		if (shotgunAnim == 1):
			charactersprite.animation = "shotgun_jump"
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_highjumpcloud2.tscn")
		for i in get_tree().get_nodes_in_group("obj_highjumpcloud2"):
			if xscale == 1:
				i.sprite.flip_h = false
			elif xscale == -1:
				i.sprite.flip_h = true
		velocity.y = -11
		state = global.states.jump
		jumpAnim = 1
	if (is_on_floor() && input_buffer_jump < 8 && !Input.is_action_pressed("key_down") && !Input.is_action_pressed("key_dash") && velocity.y >= 0):
		$Jump.play()
		charactersprite.animation = "jump"
		if (shotgunAnim == 1):
			charactersprite.animation = "shotgun_jump"
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_highjumpcloud2.tscn")
		for i in get_tree().get_nodes_in_group("obj_highjumpcloud2"):
			if xscale == 1:
				i.sprite.flip_h = false
			elif xscale == -1:
				i.sprite.flip_h = true
		stompAnim = 0
		velocity.y = -11
		state = global.states.jump
		jumpAnim = 1
		jumpstop = 0
	if ((Input.is_action_pressed("key_down") && is_on_floor()) || ($CrouchCheck.is_colliding() && is_on_floor())):
		state = global.states.crouch
		landAnim = 0
		crouchAnim = 1
		idle = 0
	if (move != 0):
		if movespeed < 6:
			movespeed += 0.5
		elif (floor(movespeed) == 6):
			movespeed = 6
	else:
		movespeed = 0
	if (movespeed > 6):
		movespeed -= 0.1
	momemtum = 0
	if (move != 0):
		xscale = move
		if (movespeed < 3 && move != 0):
			charactersprite.speed_scale = 0.35
		elif (movespeed > 3 && movespeed < 6):
			charactersprite.speed_scale = 0.45
		else:
			charactersprite.speed_scale = 0.6
	else:
		charactersprite.speed_scale = 0.35
	if (Input.is_action_just_pressed("key_grab") && ((global.shoulderbash && Input.is_action_pressed("key_up") && character == "P") || !global.shoulderbash || (global.shoulderbash && character != "P"))):
		suplexmove = 1
		$SuplexDash.play()
		state = global.states.handstandjump
		if (shotgunAnim == 0):
			charactersprite.animation = "suplexdash"
		else:
			charactersprite.animation = "shotgun_suplexdash"
		movespeed = 6
	if (Input.is_action_just_pressed("key_grab") && character == "P" && global.shoulderbash && !Input.is_action_pressed("key_up")):
		suplexmove = 1
		$SuplexDash.play()
		state = global.states.shoulderbash
		charactersprite.animation = "attackdash"
		movespeed = 6
	if (Input.is_action_just_pressed("key_shoot") && shotgunAnim == 1):
		utils.playsound("KillingBlow")
		state = global.states.shotgun
		var effectid = utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_pistoleffect.tscn")
		effectid.xscale = xscale
		charactersprite.animation = "shotgun"
		utils.instance_create(global_position.x + (xscale * 20), global_position.y + 20, "res://Objects/Misc/obj_shotgunbullet.tscn")
		var bulletid = utils.instance_create(global_position.x + (xscale * 20), global_position.y + 20, "res://Objects/Misc/obj_shotgunbullet.tscn")
		bulletid.spdh = 4
		var bulletid2 = utils.instance_create(global_position.x + (xscale * 20), global_position.y + 20, "res://Objects/Misc/obj_shotgunbullet.tscn")
		bulletid2.spdh = -4
	if (Input.is_action_pressed("key_dash") && !is_on_wall() && !is_colliding_with_wall()):
		movespeed = 6
		charactersprite.animation = "mach1"
		jumpAnim = 1
		state = global.states.mach1
	if (move != 0 && (charactersprite.frame == 3 || charactersprite.frame == 8) && steppy == 0):
		utils.instance_create(position.x, (position.y + 43), "res://Objects/Visuals/obj_cloudeffect.tscn")
		steppy = 1
	if (move != 0 && charactersprite.frame != 3 && charactersprite.frame != 8):
		steppy = 0
	scr_dotaunt()
		
func scr_player_jump():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	if (momemtum == 0):
		velocity.x = (move * movespeed)
	else:
		velocity.x = (xscale * movespeed)
	if (dir != xscale):
		dir = xscale
		movespeed = 2
		facehurt = 0
	if (move != xscale):
		movespeed = 2
	if (movespeed == 0):
		momemtum = 0
	if (move != 0 && movespeed < 6):
		movespeed += 0.5
	if (movespeed > 6):
		movespeed -= 0.1
	if (is_on_wall() && move != 0 && movespeed < 2):
		movespeed = 0
	if (dir != xscale):
		dir = xscale
	landAnim = 1
	if (!Input.is_action_pressed("key_jump") && jumpstop == 0 && velocity.y < 0.5 && stompAnim == 0):
		velocity.y /= 10
		jumpstop = 1
	if (ladderbuffer > 0):
		ladderbuffer -= 1
	if (is_on_ceiling() && jumpstop == 0 && jumpAnim == 1):
		velocity.y = grav
		jumpstop = 1
	if (is_on_floor() && input_buffer_jump < 8 && !Input.is_action_pressed("key_down") && !Input.is_action_pressed("key_dash") && velocity.y >= 0 && (!((charactersprite.animation == "facestomp" || charactersprite.animation == "freefall")))):
		$Jump.play()
		charactersprite.animation = "jump"
		if (shotgunAnim == 1):
			charactersprite.animation = "shotgun_jump"
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_highjumpcloud2.tscn")
		stompAnim = 0
		velocity.y = -11
		state = global.states.jump
		jumpAnim = 1
		jumpstop = 0
		movespeed = 2
	if ((is_on_floor() && velocity.y >= 0 && !Input.is_action_pressed("key_dash"))):
		$Step.play()
		if Input.is_action_pressed("key_dash"):
			landAnim = 0
		input_buffer_secondjump = 0
		state = global.states.normal
		jumpAnim = 1
		jumpstop = 0
		movespeed = 2
	if Input.is_action_just_pressed("key_jump"):
		input_buffer_jump = 0
	if (velocity.y > 5):
		fallinganimation += 1
	if (fallinganimation >= 40 && fallinganimation < 80):
		charactersprite.animation = "facestomp"
	if (fallinganimation >= 80):
		charactersprite.animation = "freefall"
	if (stompAnim == 0):
		if (jumpAnim == 1):
			if (is_last_frame()):
				jumpAnim = 0
		if (jumpAnim == 0):
			if (charactersprite.animation == "airdash1"):
				charactersprite.animation = "airdash2"
			if (charactersprite.animation == "shotgun_jump"):
				charactersprite.animation = "shotgun_fall"
			if (charactersprite.animation == "jump"):
				charactersprite.animation = "fall"
			if (charactersprite.animation == "shotgunjump1"):
				charactersprite.animation = "shotgunjump2"
	if (stompAnim == 1):
		if (charactersprite.animation == "stompprep" && is_last_frame()):
			charactersprite.animation = "stomp"
	if (Input.is_action_just_pressed("key_down")):
		if (shotgunAnim == 0):
			state = global.states.freefallprep
			charactersprite.animation = "bodyslamstart"
			velocity.y = -5
		else:
			utils.playsound("KillingBlow")
			state = global.states.freefallprep
			charactersprite.animation = "shotgunjump1"
			velocity.y = -5
			var bulletid = utils.instance_create(global_position.x, global_position.y + 60, "res://Objects/Misc/obj_shotgunbullet.tscn")
			bulletid.sprite = "shotgunbullet2"
			bulletid.spdh = -10
			bulletid.spd = 0
			var bulletid2 = utils.instance_create(global_position.x, global_position.y + 60, "res://Objects/Misc/obj_shotgunbullet.tscn")
			bulletid2.sprite = "shotgunbullet2"
			bulletid2.spdh = -10
			bulletid2.spd = 5
			var bulletid3 = utils.instance_create(global_position.x, global_position.y + 60, "res://Objects/Misc/obj_shotgunbullet.tscn")
			bulletid3.sprite = "shotgunbullet2"
			bulletid3.spdh = -10
			bulletid3.spd = -5
	if (move != 0):
		xscale = move
	charactersprite.speed_scale = 0.35
	if (is_on_floor() && (charactersprite.animation == "facestomp" || charactersprite.animation == "freefall")):
		for i in get_tree().get_nodes_in_group("obj_baddie"):
			if (i.is_on_floor() && i.screenvisible):
				i.velocity.y = -7
				i.velocity.x = 0
		for i in get_tree().get_nodes_in_group("obj_camera"):
			i.shake_mag = 10
			i.shake_mag_acc = (30 / 30)
		$Groundpound.play()
		charactersprite.animation = "bodyslamland"
		state = global.states.freefallland
	if (Input.is_action_just_pressed("key_grab") && ((global.shoulderbash && Input.is_action_pressed("key_up") && character == "P") || !global.shoulderbash || (global.shoulderbash && character != "P")) && suplexmove == 0):
		suplexmove = 1
		$SuplexDash.play()
		state = global.states.handstandjump
		charactersprite.animation = "suplexdashjumpstart"
		velocity.y = -4
		movespeed = 6
	if (Input.is_action_just_pressed("key_grab") && character == "P" && global.shoulderbash && !Input.is_action_pressed("key_up") && suplexmove == 0):
		suplexmove = 1
		$SuplexDash.play()
		state = global.states.shoulderbash
		charactersprite.animation = "airattackstart"
		velocity.y = -4
		movespeed = 6
	if (Input.is_action_just_pressed("key_shoot") && shotgunAnim == 1):
		utils.playsound("KillingBlow")
		state = global.states.shotgun
		var effectid = utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_pistoleffect.tscn")
		effectid.xscale = xscale
		charactersprite.animation = "shotgun"
		utils.instance_create(global_position.x + (xscale * 20), global_position.y + 20, "res://Objects/Misc/obj_shotgunbullet.tscn")
		var bulletid = utils.instance_create(global_position.x + (xscale * 20), global_position.y + 20, "res://Objects/Misc/obj_shotgunbullet.tscn")
		bulletid.spdh = 4
		var bulletid2 = utils.instance_create(global_position.x + (xscale * 20), global_position.y + 20, "res://Objects/Misc/obj_shotgunbullet.tscn")
		bulletid2.spdh = -4
	if (!Input.is_action_pressed("key_dash") && move != xscale):
		mach2 = 0
	if (Input.is_action_pressed("key_dash") && is_on_floor() && fallinganimation < 40):
		movespeed = 6
		charactersprite.animation = "mach1"
		jumpAnim = 1
		state = global.states.mach1
	scr_dotaunt()
	
func scr_player_backbreaker():
	mach2 = 0
	if (charactersprite.animation != "machfreefall"):
		velocity.x = 0
		movespeed = 0
	else:
		velocity.x = (xscale * movespeed)
	landAnim = 0
	if (charactersprite.animation == "machfreefall" && is_on_floor()):
		state = global.states.machslide
		charactersprite.animation = "crouchslide"
	if (charactersprite.animation == "taunt" || charactersprite.animation == "supertaunt1" || charactersprite.animation == "supertaunt2" || charactersprite.animation == "supertaunt3" || charactersprite.animation == "supertaunt4"):
		if (supercharged && !utils.instance_exists("obj_tauntaftereffectspawner")):
			utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_tauntaftereffectspawner.tscn")
			for i in get_tree().get_nodes_in_group("obj_baddie"):
				if (i.screenvisible):
					i.destroy()
			for i in get_tree().get_nodes_in_group("obj_camera"):
				i.shake_mag = 10
				i.shake_mag_acc = (30 / 30)
			supercharged = false
		taunttimer -= 1
		charactersprite.speed_scale = 0
		velocity.y = 0
	if (is_last_frame() && (charactersprite.animation == "supertaunt1" || charactersprite.animation == "supertaunt2" || charactersprite.animation == "supertaunt3" || charactersprite.animation == "supertaunt4")):
		movespeed = tauntstoredmovespeed
		charactersprite.animation = tauntstoredsprite
		state = tauntstoredstate
	if (taunttimer == 0 && charactersprite.animation == "taunt"):
		movespeed = tauntstoredmovespeed
		charactersprite.animation = tauntstoredsprite
		state = tauntstoredstate
	if (is_last_frame() && charactersprite.animation == "eatspaghetti"):
		state = global.states.normal
	if (is_last_frame() && charactersprite.animation == "timesup"):
		state = global.states.normal
	if (is_last_frame() && charactersprite.animation == "levelcomplete"):
		state = global.states.normal
	if (is_last_frame() && charactersprite.animation == "bossintro"):
		state = global.states.normal
	if (charactersprite.animation != "taunt"):
		charactersprite.speed_scale = 0.35
		
func scr_player_crouch():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	velocity.x = (move * movespeed)
	movespeed = 4
	crouchmask = true
	if (!is_on_floor() && !Input.is_action_just_pressed("key_jump")):
		jumpAnim = 0
		state = global.states.crouchjump
		movespeed = 4
		crouchAnim = 1
	if (is_on_floor() && !Input.is_action_pressed("key_down") && !$CrouchCheck.is_colliding() && !Input.is_action_just_pressed("key_jump")):
		state = global.states.normal
		movespeed = 0
		crouchAnim = 1
		jumpAnim = 1
		crouchmask = false
	if (crouchAnim == 0):
		if (move == 0):
			if (shotgunAnim == 0):
				charactersprite.animation = "crouch"
			else:
				charactersprite.animation = "shotgun_duck"
		if (move != 0):
			if (shotgunAnim == 0):
				charactersprite.animation = "crawl"
			else:
				charactersprite.animation = "shotgun_crawl"
	if (crouchAnim == 1):
		if (move == 0):
			if (shotgunAnim == 0):
				charactersprite.animation = "crouchstart"
			else:
				charactersprite.animation = "shotgun_goduck"
			if (is_last_frame()):
				crouchAnim = 0
	if (move != 0):
		xscale = move
		crouchAnim = 0
	if (Input.is_action_just_pressed("key_jump") && is_on_floor() && !$CrouchCheck.is_colliding()):
		$Jump.play()
		velocity.y = -8
		state = global.states.crouchjump
		movespeed = 4
		crouchAnim = 1
		jumpAnim = 1
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("obj_slope") && Input.is_action_pressed("key_down"):
			movespeed = 14
			xscale = (-sign(collision.collider.scale.x))
			$SolidCheck.scale.x *= -1
			$SolidCheck2.scale.x *= -1
			$DestructibleArea.scale.x *= -1
			$WallClimbCheck.scale.x *= -1
			state = global.states.tumble
			charactersprite.animation = "tumblestart"
	charactersprite.speed_scale = 0.45
	
func scr_player_crouchjump():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	fallinganimation += 1
	if (fallinganimation >= 40 && fallinganimation < 80):
		charactersprite.animation = "facestomp"
		state = global.states.jump
	crouchmask = true
	velocity.x = (move * movespeed)
	movespeed = 4
	if (!Input.is_action_pressed("key_jump") && jumpstop == 0 && jumpAnim == 1):
		velocity.y /= 2
		jumpstop = 1
	if (is_on_ceiling() && jumpstop == 0 && jumpAnim == 1):
		velocity.y = grav
		jumpstop = 1
	if (is_on_floor() && Input.is_action_pressed("key_down")):
		state = global.states.crouch
		jumpAnim = 1
		crouchAnim = 1
		jumpstop = 0
		$Step.play()
	if (jumpAnim == 1):
		if (shotgunAnim == 0):
			charactersprite.animation = "crouchjump"
		else:
			charactersprite.animation = "shotgun_crouchjump1"
		if (is_last_frame()):
			jumpAnim = 0
	if (jumpAnim == 0):
		if (shotgunAnim == 0):
			charactersprite.animation = "crouchfall"
		else:
			charactersprite.animation = "shotgun_crouchjump2"
	if (is_on_floor() && !Input.is_action_pressed("key_down") && !$CrouchCheck.is_colliding()):
		movespeed = 0
		state = global.states.normal
		jumpAnim = 1
		landAnim = 1
		crouchAnim = 1
		jumpstop = 0
		crouchmask = false
		$Step.play()
	if (move != 0):
		xscale = move
	charactersprite.speed_scale = 0.35
	
func scr_player_freefallprep():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	if (!is_on_floor()):
		velocity.x = (move * movespeed)
		if (move != xscale && momemtum == 1 && movespeed != 0):
			movespeed -= 0.05
		if (movespeed == 0):
			momemtum = 0
		if (move == 0 && momemtum == 0):
			movespeed = 0
			mach2 = 0
		if (move != 0 && movespeed < 7):
			movespeed += 0.25
		if (movespeed > 7):
			movespeed -= 0.05
		if (is_on_wall() && move != 0):
			movespeed = 0
		if (dir != xscale):
			mach2 = 0
			dir = xscale
			movespeed = 0
		if (move == (-xscale)):
			mach2 = 0
			movespeed = 0
			momemtum = 0
		if (move != 0):
			xscale = move
	charactersprite.speed_scale = 0.5
	if (is_last_frame()):
		velocity.y += 14
		state = global.states.freefall
		if (shotgunAnim == 0):
			charactersprite.animation = "bodyslamfall"
		else:
			charactersprite.animation = "shotgunjump3"
	
func scr_player_freefall():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	landAnim = 1
	velocity.y = 15
	if (!is_on_floor()):
		velocity.x = (move * movespeed)
		if (move != xscale && momemtum == 1 && movespeed != 0):
			movespeed -= 0.05
		if (movespeed == 0):
			momemtum = 0
		if (move == 0 && momemtum == 0):
			movespeed = 0
			mach2 = 0
		if (move != 0 && movespeed < 7):
			movespeed += 0.25
		if (movespeed > 7):
			movespeed -= 0.05
		if (is_colliding_with_wall() && move != 0):
			movespeed = 0
		if (dir != xscale):
			mach2 = 0
			dir = xscale
			movespeed = 0
		if (move == (-xscale)):
			mach2 = 0
			movespeed = 0
			momemtum = 0
		if (move != 0):
			xscale = move
	freefallsmash += 1
	if (freefallsmash > 10 && !utils.instance_exists("obj_superslameffect")):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_superslameffect.tscn")
	if (is_on_floor() && (!(input_buffer_jump < 8))):
		$Groundpound.play()
		freefallsmash = 0
		if (shotgunAnim == 0):
			charactersprite.animation = "bodyslamland"
		else:
			charactersprite.animation = "shotgunjump2"
		state = global.states.freefallland
		jumpAnim = 1
		jumpstop = 0
		for i in get_tree().get_nodes_in_group("obj_baddie"):
			if (i.is_on_floor() && i.screenvisible):
				i.velocity.y = -11
				i.velocity.x = 0
		for i in get_tree().get_nodes_in_group("obj_camera"):
			i.shake_mag = 20
			i.shake_mag_acc = (30 / 30)
		bounce = 0
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_landcloud.tscn")
	charactersprite.speed_scale = 0.35

func scr_player_freefallland():
	mach2 = 0
	jumpAnim = 1
	landAnim = 0
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 0
	machhitAnim = 0
	movespeed = 0
	facehurt = 1
	velocity.y = 0
	velocity.x = 0
	if (is_last_frame() && (!(superslam > 30))):
		state = global.states.normal
	if (is_last_frame() && superslam > 30):
		state = global.states.machfreefall
		velocity.y = -7
	charactersprite.speed_scale = 0.35
	
func scr_player_bump():
	movespeed = 0
	mach2 = 0
	if (is_on_floor() && velocity.y >= 0):
		velocity.x = 0
	if (is_last_frame()):
		state = global.states.normal
	if (charactersprite.animation != "tumbleend" && charactersprite.animation != "hitwall"):
		charactersprite.animation = "bump"
	charactersprite.speed_scale = 0.35
	
func scr_player_comingoutdoor():
	mach2 = 0
	jumpAnim = 1
	landAnim = 0
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 1
	machhitAnim = 0
	velocity.x = 0
	charactersprite.animation = "walkfront"
	charactersprite.speed_scale = 0.35
	if (is_last_frame()):
		movespeed = 0
		state = global.states.normal
	
func scr_player_crouchslide():
	velocity.x = (xscale * movespeed)
	if (movespeed >= 0 && !(charactersprite.animation == "jumpdive1" || charactersprite.animation == "jumpdive2")):
		movespeed -= 0.2
	crouchmask = true
	if (crouchslipbuffer > 0):
		crouchslipbuffer -= 1
	if (movespeed > 0 && charactersprite.animation == "crouchslip" && !Input.is_action_pressed("key_down") && Input.is_action_pressed("key_dash") && !$CrouchCheck.is_colliding() && crouchslipbuffer <= 0):
		charactersprite.animation = "machhit"
		state = global.states.mach2
		if (movespeed < 8):
			movespeed = 8
	if (velocity.x == 0 || movespeed <= 0):
		state = global.states.crouch
		movespeed = 0
		mach2 = 0
		crouchslideAnim = 1
		crouchAnim = 1
	if (is_on_wall()):
		movespeed = 0
		state = global.states.bump
		velocity.x = (-2.5 * xscale)
		velocity.y = -3
		mach2 = 0
		machslideAnim = 1
		machhitAnim = 0
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_bumpeffect.tscn")
	if (!Input.is_action_pressed("key_jump") && jumpstop == 0 && velocity.y < 0.5 && stompAnim == 0 && character == "P"):
		velocity.y /= 20
		jumpstop = 1
	if (Input.is_action_just_pressed("key_jump") && character == "P"):
		input_buffer_jump = 0
	if (is_on_floor() && input_buffer_jump < 8 && !$CrouchCheck.is_colliding() && character == "P"):
		charactersprite.animation = "jumpdive1"
		velocity.y = -11
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_superdashcloud.tscn")
	if (is_on_floor() && (charactersprite.animation == "jumpdive1" || charactersprite.animation == "jumpdive2") && velocity.y >= 0):
		charactersprite.animation = "crouchslip"
		jumpstop = 0
	if (charactersprite.animation == "jumpdive1" && is_last_frame()):
		charactersprite.animation = "jumpdive2"
	if (!utils.instance_exists("obj_slidecloud") && is_on_floor() && movespeed > 5):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_slidecloud.tscn")
		for i in get_tree().get_nodes_in_group("obj_slidecloud"):
			if xscale == 1:
				i.sprite.flip_h = false
			elif xscale == -1:
				i.sprite.flip_h = true
	charactersprite.speed_scale = 0.35
	
func scr_player_door():
	velocity.x = 0
	mach2 = 0
	jumpAnim = 1
	landAnim = 0
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 1
	machhitAnim = 0
	charactersprite.speed_scale = 0.35
	if (is_last_frame()):
		charactersprite.speed_scale = 0
	if (is_last_frame() && (!utils.instance_exists("obj_fadeout")) && (charactersprite.animation == "uppizzabox" || charactersprite.animation == "downpizzabox")):
		utils.instance_create(utils.get_gamenode().global_position.x, utils.get_gamenode().global_position.y, "res://Objects/Visuals/obj_fadeout.tscn")
	
func scr_player_handstandjump():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	landAnim = 0
	velocity.x = (xscale * movespeed)
	momemtum = 1
	dir = xscale
	if (movespeed < 10 && is_on_floor()):
		movespeed += 0.5
	elif (!is_on_floor()):
		movespeed = 10
	if (!Input.is_action_pressed("key_jump") && jumpstop == 0 && velocity.y < 0.5 && stompAnim == 0):
		velocity.y /= 10
		jumpstop = 1
	if (move != xscale && move != 0):
		state = global.states.normal
	if ((is_last_frame() || charactersprite.animation == "suplexdashjump" || charactersprite.animation == "suplexdashjumpstart") && is_on_floor() && !Input.is_action_pressed("key_dash") && velocity.y >= 0):
		charactersprite.speed_scale = 0.35
		state = global.states.normal
	if ((is_last_frame() || charactersprite.animation == "suplexdashjump" || charactersprite.animation == "suplexdashjumpstart") && is_on_floor() && Input.is_action_pressed("key_dash")):
		charactersprite.speed_scale = 0.35
		state = global.states.mach2
	if (is_last_frame() && charactersprite.animation == "suplexdashjumpstart"):
		charactersprite.animation = "suplexdashjump"
	if (Input.is_action_pressed("key_down") && is_on_floor() && velocity.y >= 0):
		charactersprite.animation = "crouchslip"
		if (character == "P"):
			machhitAnim = 0
		crouchslipbuffer = 20
		state = global.states.crouchslide
		movespeed = 12
	if (!is_on_floor() && (charactersprite.animation == "suplexdash" || charactersprite.animation == "shotgun_suplexdash")):
		charactersprite.animation = "suplexdashjumpstart"
	if (Input.is_action_just_pressed("key_jump")):
		input_buffer_jump = 0
	if (is_on_floor() && input_buffer_jump < 8):
		charactersprite.animation = "suplexdashjumpstart"
		$Jump.play()
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_highjumpcloud2.tscn")
		velocity.y = -11
	if (is_on_wall()):
		$Bump.play()
		movespeed = 0
		state = global.states.bump
		velocity.x = (-2.5 * xscale)
		velocity.y = -3
		mach2 = 0
		machslideAnim = 1
		machhitAnim = 0
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_bumpeffect.tscn")
	if (!utils.instance_exists("obj_slidecloud") && is_on_floor() && movespeed > 5):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_slidecloud.tscn")
		for i in get_tree().get_nodes_in_group("obj_slidecloud"):
			if xscale == 1:
				i.sprite.flip_h = false
			elif xscale == -1:
				i.sprite.flip_h = true
	charactersprite.speed_scale = 0.35
	if (Input.is_action_just_pressed("key_grab") && character == "P"):
		movespeed = 8
		charactersprite.animation = "faceplant"
		charactersprite.speed_scale = 0.5
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_jumpdust.tscn")
		for i in get_tree().get_nodes_in_group("obj_jumpdust"):
			if xscale == 1:
				i.sprite.flip_h = false
			elif xscale == -1:
				i.sprite.flip_h = true
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_crazyrunothereffect.tscn")
		state = global.states.faceplant

func scr_player_shoulderbash():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	landAnim = 0
	if (charactersprite.animation != "ungroundedattack" && charactersprite.animation != "attack1" && charactersprite.animation != "attack2"):
		velocity.x = (xscale * movespeed)
	else:
		velocity.x = 0
		velocity.y = 0
	momemtum = 1
	dir = xscale
	if (movespeed < 10 && is_on_floor()):
		movespeed += 0.5
	elif (!is_on_floor()):
		movespeed = 10
	if (!Input.is_action_pressed("key_jump") && jumpstop == 0 && velocity.y < 0.5 && stompAnim == 0):
		velocity.y /= 10
		jumpstop = 1
	if (move != xscale && move != 0):
		state = global.states.normal
	if (((is_last_frame() && charactersprite.animation == "attackdash") || charactersprite.animation == "mach2jump") && is_on_floor() && !Input.is_action_pressed("key_dash") && velocity.y >= 0):
		charactersprite.speed_scale = 0.35
		state = global.states.machslide
		$MachSlide.play()
		charactersprite.animation = "machslidestart"
	if (((is_last_frame() && charactersprite.animation == "attackdash") || charactersprite.animation == "mach2jump") && is_on_floor() && Input.is_action_pressed("key_dash")):
		charactersprite.speed_scale = 0.35
		state = global.states.mach2
	if (is_last_frame() && charactersprite.animation == "airattackstart"):
		charactersprite.animation = "airattack"
	if (is_last_frame() && charactersprite.animation == "ungroundedattack"):
		charactersprite.animation = "backflip"
	if (is_last_frame() && (charactersprite.animation == "attack1" || charactersprite.animation == "attack2")):
		charactersprite.animation = "attackdash"
	if (is_on_floor() && charactersprite.animation == "backflip"):
		charactersprite.animation = "attackdash"
	if (is_on_floor() && (charactersprite.animation == "airattack" || charactersprite.animation == "airattackstart")):
		if (Input.is_action_pressed("key_dash")):
			charactersprite.speed_scale = 0.35
			state = global.states.mach2
		elif (!Input.is_action_pressed("key_grab")):
			charactersprite.speed_scale = 0.35
			state = global.states.machslide
			$MachSlide.play()
			charactersprite.animation = "machslidestart"
		else:
			charactersprite.animation = "attackdash"
	if (Input.is_action_just_pressed("key_jump")):
		input_buffer_jump = 0
	if (is_on_floor() && input_buffer_jump < 8 && charactersprite.animation == "attackdash"):
		charactersprite.animation = "mach2jump"
		$Jump.play()
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_highjumpcloud2.tscn")
		velocity.y = -11
	if (Input.is_action_pressed("key_down") && is_on_floor() && velocity.y >= 0):
		charactersprite.animation = "crouchslip"
		if (character == "P"):
			machhitAnim = 0
		crouchslipbuffer = 20
		state = global.states.crouchslide
		movespeed = 12
	if (is_on_wall()):
		$Bump.play()
		movespeed = 0
		state = global.states.bump
		velocity.x = (-2.5 * xscale)
		velocity.y = -3
		mach2 = 0
		machslideAnim = 1
		machhitAnim = 0
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_bumpeffect.tscn")
	if (!utils.instance_exists("obj_slidecloud") && is_on_floor() && movespeed > 5):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_slidecloud.tscn")
		for i in get_tree().get_nodes_in_group("obj_slidecloud"):
			if xscale == 1:
				i.sprite.flip_h = false
			elif xscale == -1:
				i.sprite.flip_h = true
	charactersprite.speed_scale = 0.35
	
func scr_player_hurt():
	if (charactersprite.animation == "hurtjump"):
		velocity.x = (xscale * movespeed)
	if (charactersprite.animation == "hurt"):
		velocity.x = ((-xscale) * movespeed)
	if (movespeed > 0):
		movespeed -= 0.1
	freefallsmash = 0
	mach2 = 0
	bounce = 0
	jumpAnim = 1
	if (is_on_floor()):
		landAnim = 0
	else:
		landAnim = 1
	jumpstop = 0
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 0
	machhitAnim = 0
	hurted = 1
	$FlashEffectOffTimer.wait_time = 0.05
	$FlashEffectOffTimer.start()
	$HurtTimer2.wait_time = 1
	$HurtTimer2.start()
	if (is_on_floor()):
		velocity.y = -4
	if (is_colliding_with_wall()):
		xscale *= -1
		$SolidCheck.scale.x *= -1
		$SolidCheck2.scale.x *= -1
		$DestructibleArea.scale.x *= -1
		$WallClimbCheck.scale.x *= -1
	charactersprite.speed_scale = 0.35
	
func scr_player_mach1():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	dir = xscale
	landAnim = 0
	if (is_colliding_with_wall()):
		mach2 = 0
		state = global.states.normal
		movespeed = 0
	machhitAnim = 0
	crouchslideAnim = 1
	velocity.x = (xscale * movespeed)
	if (xscale == 1 && move == -1):
		charactersprite.animation = "mach1"
		momemtum = 0
		mach2 = 0
		movespeed = 6
		xscale = -1
	if (xscale == -1 && move == 1):
		charactersprite.animation = "mach1"
		momemtum = 0
		mach2 = 0
		movespeed = 6
		xscale = 1
	if (is_on_floor()):
		if (movespeed <= 8):
			movespeed += 0.075
		if (movespeed >= 8):
			state = global.states.mach2
			utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_jumpdust.tscn")
			for i in get_tree().get_nodes_in_group("obj_jumpdust"):
				if xscale == 1:
					i.sprite.flip_h = false
				elif xscale == -1:
					i.sprite.flip_h = true
	if (!is_on_floor() && charactersprite.animation != "airdash1"):
		charactersprite.animation = "airdash2"
	if (charactersprite.animation == "airdash1" && is_last_frame()):
		charactersprite.animation = "airdash2"
	if (!Input.is_action_pressed("key_dash")):
		state = global.states.normal
	if (!Input.is_action_pressed("key_jump") && jumpstop == 0 && velocity.y < 0.5):
		velocity.y /= 10
		jumpstop = 1
	if (is_on_floor() && velocity.y >= 0):
		jumpstop = 0
	if (is_colliding_with_wall()):
		state = global.states.normal
		movespeed = 0
	if (!global.may2019run):
		charactersprite.speed_scale = 0.5
	else:
		charactersprite.speed_scale = 0.45
	if (!utils.instance_exists("obj_dashcloud") && is_on_floor()):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_dashcloud.tscn")
		for i in get_tree().get_nodes_in_group("obj_dashcloud"):
			if xscale == 1:
				i.sprite.flip_h = false
			elif xscale == -1:
				i.sprite.flip_h = true
	if (is_on_floor() && charactersprite.animation != "mach1" && velocity.y >= 0 && !global.may2019run):
		charactersprite.animation = "mach1"
	if (is_on_floor() && charactersprite.animation != "running" && velocity.y >= 0 && global.may2019run && character == "P"):
		charactersprite.animation = "running"
	if (Input.is_action_just_pressed("key_jump") && is_on_floor()):
		$Jump.play()
		charactersprite.animation = "airdash1"
		dir = xscale
		momemtum = 1
		velocity.y = -11
		jumpAnim = 1
	if (Input.is_action_pressed("key_down") && !is_on_floor()):
		if (shotgunAnim == 0):
			state = global.states.freefallprep
			charactersprite.animation = "bodyslamstart"
			velocity.y = -5
		else:
			state = global.states.freefallprep
			charactersprite.animation = "shotgunjump1"
			velocity.y = -5
			var bulletid = utils.instance_create(global_position.x, global_position.y + 60, "res://Objects/Misc/obj_shotgunbullet.tscn")
			bulletid.sprite = "shotgunbullet2"
			bulletid.spdh = -10
			bulletid.spd = 0
			var bulletid2 = utils.instance_create(global_position.x, global_position.y + 60, "res://Objects/Misc/obj_shotgunbullet.tscn")
			bulletid2.sprite = "shotgunbullet2"
			bulletid2.spdh = -10
			bulletid2.spd = 5
			var bulletid3 = utils.instance_create(global_position.x, global_position.y + 60, "res://Objects/Misc/obj_shotgunbullet.tscn")
			bulletid3.sprite = "shotgunbullet2"
			bulletid3.spdh = -10
			bulletid3.spd = -5
	scr_dotaunt()
	
func scr_player_mach2():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	if (windingAnim < 2000):
		windingAnim += 1
	velocity.x = (xscale * movespeed)
	crouchslideAnim = 1
	if (!Input.is_action_pressed("key_jump") && jumpstop == 0 && velocity.y < 0.5):
		velocity.y /= 10
		jumpstop = 1
	if (is_on_floor() && velocity.y >= 0):
		jumpstop = 0
	if (input_buffer_jump < 8 && is_on_floor() && (!(move == 1 && xscale == -1)) && (!(move == -1 && xscale == 1))):
		charactersprite.animation = "secondjump1"
		$Jump.play()
		velocity.y = -11
	if (is_on_floor() && velocity.y >= 0):
		if (machpunchAnim == 0 && charactersprite.animation != "mach" && charactersprite.animation != "mach3" && charactersprite.animation != "machhit"):
			if (charactersprite.animation != "machhit" && charactersprite.animation != "rollgetup"):
				charactersprite.animation = "mach"
		if (machpunchAnim == 1):
			if (punch == 0):
				charactersprite.animation = "machpunch1"
			if (punch == 1):
				charactersprite.animation = "machpunch2"
			if (charactersprite.frame == 4 && charactersprite.animation == "machpunch1"):
				punch = 1
				machpunchAnim = 0
			if (charactersprite.frame == 4 && charactersprite.animation == "machpunch2"):
				punch = 0
				machpunchAnim = 0
	if (!is_on_floor()):
		machpunchAnim = 0
	if (is_on_floor()):
		if (movespeed < 12):
			movespeed += 0.1
		if (movespeed >= 12):
			movespeed = 12
			machhitAnim = 0
			state = global.states.mach3
			flash = true
			if (charactersprite.animation != "rollgetup"):
				charactersprite.animation = "mach4"
			utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_jumpdust.tscn")
	if (Input.is_action_just_pressed("key_jump")):
		input_buffer_jump = 0
	if (Input.is_action_pressed("key_down")):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_jumpdust.tscn")
		flash = false
		state = global.states.machroll
		velocity.y = 10
	if (!is_on_floor() && is_wallclimbable() && (charactersprite.animation != "walljumpstart" || (charactersprite.animation == "walljumpstart" && charactersprite.frame > 2))):
		wallspeed = movespeed
		state = global.states.climbwall
	if (is_on_floor() && is_wallclimbable() && $SlopeCheck.is_colliding()):
		wallspeed = movespeed
		state = global.states.climbwall
	if (is_on_floor() && is_colliding_with_wall() && !$SlopeCheck.is_colliding()):
		movespeed = 0
		state = global.states.normal
	if (!utils.instance_exists("obj_dashcloud") && is_on_floor()):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_dashcloud.tscn")
		for i in get_tree().get_nodes_in_group("obj_dashcloud"):
			if xscale == 1:
				i.sprite.flip_h = false
			elif xscale == -1:
				i.sprite.flip_h = true
	if (is_on_floor() && is_last_frame() && charactersprite.animation == "rollgetup"):
		charactersprite.animation = "mach"
	if (!is_on_floor() && charactersprite.animation != "secondjump2" && charactersprite.animation != "mach2jump" && charactersprite.animation != "walljumpstart" && charactersprite.animation != "walljumpend"):
		charactersprite.animation = "secondjump1"
	if (is_last_frame() && charactersprite.animation == "secondjump1"):
		charactersprite.animation = "secondjump2"
	if (is_last_frame() && charactersprite.animation == "walljumpstart"):
		charactersprite.animation = "walljumpend"
	if (!Input.is_action_pressed("key_dash") && move != xscale && is_on_floor()):
		state = global.states.machslide
		$MachSlide.play()
		charactersprite.animation = "machslidestart"
	if (move == (-xscale) && is_on_floor()):
		$MachSlideBoost.play()
		state = global.states.machslide
		charactersprite.animation = "machslideboost"
	if (move == xscale && !Input.is_action_pressed("key_dash") && is_on_floor()):
		state = global.states.normal
	if (charactersprite.animation == "rollgetup"):
		charactersprite.speed_scale = 0.4
	else:
		charactersprite.speed_scale = 0.65
	scr_dotaunt()
	
func scr_player_mach3():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	if (windingAnim < 2000):
		windingAnim += 1
	velocity.x = (xscale * movespeed)
	mach2 = 100
	momemtum = 1
	if (movespeed < 24 && move == xscale):
		movespeed += 0.1
		if (!utils.instance_exists("obj_crazyruneffect")):
			utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_crazyruneffect.tscn")
	elif (movespeed > 12 && move != xscale):
		movespeed -= 0.1
	if (charactersprite.animation == "crazyrun"):
		if (flamecloud_buffer > 0):
			flamecloud_buffer -= 1
		else:
			flamecloud_buffer = 10
			utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_flamecloud.tscn")
	crouchslideAnim = 1
	if (!Input.is_action_pressed("key_jump") && jumpstop == 0 && velocity.y < 0.5):
		velocity.y /= 10
		jumpstop = 1
	if (is_on_floor() && velocity.y >= 0):
		jumpstop = 0
	if (input_buffer_jump < 8 && is_on_floor() && (!(move == 1 && xscale == -1)) && (!(move == -1 && xscale == 1))):
		$Jump.play()
		charactersprite.animation = "mach3jump"
		velocity.y = -11
	if (charactersprite.animation == "mach3jump" && is_last_frame()):
		charactersprite.animation = "mach4"
	if (is_last_frame() && (charactersprite.animation == "rollgetup" || charactersprite.animation == "mach3hit")):
		charactersprite.animation = "mach4"
	if (charactersprite.animation == "mach2jump" && is_on_floor() && velocity.y >= 0):
		charactersprite.animation = "mach4"
	if (movespeed > 20 && charactersprite.animation != "crazyrun"):
		flash = true
		charactersprite.animation = "crazyrun"
	elif (movespeed <= 20 && charactersprite.animation == "crazyrun"):
		charactersprite.animation = "mach4"
	if (charactersprite.animation == "crazyrun" && !utils.instance_exists("obj_crazyrunothereffect")):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_crazyrunothereffect.tscn")
	if (charactersprite.animation == "mach4"):
		charactersprite.speed_scale = 0.4
	if (charactersprite.animation == "crazyrun"):
		charactersprite.speed_scale = 0.75
	if (charactersprite.animation == "rollgetup" || charactersprite.animation == "mach3hit"):
		charactersprite.speed_scale = 0.4
	if (Input.is_action_just_pressed("key_jump")):
		input_buffer_jump = 0
	if (Input.is_action_pressed("key_up")):
		charactersprite.animation = "superjumpprep"
		state = global.states.Sjumpprep
		velocity.x = 0
	if (!Input.is_action_pressed("key_dash") && is_on_floor()):
		charactersprite.animation = "machslidestart"
		$MachSlide.play()
		state = global.states.machslide
	if (move == (-xscale) && is_on_floor()):
		charactersprite.animation = "machslideboost3"
		$MachSlideBoost.play()
		state = global.states.machslide
	if (Input.is_action_pressed("key_down")):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_jumpdust.tscn")
		flash = false
		state = global.states.machroll
		velocity.y = 10
	if (!is_on_floor() && is_wallclimbable()):
		wallspeed = 10
		state = global.states.climbwall
	if (is_on_floor() && is_wallclimbable() && $SlopeCheck.is_colliding()):
		wallspeed = 10
		state = global.states.climbwall
	if (is_on_floor() && (is_colliding_with_wall() && charactersprite.animation != "machslideboost" && charactersprite.animation != "machslideboost3") && !$SlopeCheck.is_colliding()):
		charactersprite.animation = "hitwall"
		$Groundpound.play()
		$Bump.play()
		for i in get_tree().get_nodes_in_group("obj_camera"):
			i.shake_mag = 20
			i.shake_mag_acc = (40 / 20)
		velocity.x = 0
		charactersprite.speed_scale = 0.35
		for i in get_tree().get_nodes_in_group("obj_baddie"):
			if (i.screenvisible):
				i.stun = true
				i.ministun = false
				i.velocity.y = -5
				i.velocity.x = 0
		flash = false
		state = global.states.bump
		velocity.x = (-2.5 * xscale)
		velocity.y = -3
		mach2 = 0
		utils.instance_create(position.x + 10, position.y + 10, "res://Objects/Visuals/obj_bumpeffect.tscn")
	if (!utils.instance_exists("obj_chargeeffect")):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_chargeeffect.tscn")
	if (!utils.instance_exists("obj_superdashcloud") && is_on_floor()):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_superdashcloud.tscn")
	scr_dotaunt()
	
func scr_player_machfreefall():
	pass
	
func scr_player_machslide():
	velocity.x = (xscale * movespeed)
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	if (movespeed >= 0):
		movespeed -= 0.4
	if (charactersprite.animation == "machslidestart" && is_last_frame()):
		charactersprite.animation = "machslide"
	charactersprite.speed_scale = 0.35
	landAnim = 0
	if (movespeed <= 0 && (charactersprite.animation == "machslide" || charactersprite.animation == "crouchslide")):
		state = global.states.normal
		if (charactersprite.animation == "machslide" && shotgunAnim == 0):
			machslideAnim = 1
		movespeed = 0
	if (is_colliding_with_wall() && (charactersprite.animation == "machslide" || charactersprite.animation == "machslidestart")):
		velocity.x = ((-xscale) * 2.5)
		velocity.y = -4
		state = global.states.bump
		charactersprite.frame = 4
	if (charactersprite.frame == charactersprite.frames.get_frame_count(charactersprite.animation) - 2 && (charactersprite.animation == "machslideboost" || charactersprite.animation == "machslideboost3")):
		$DestructibleArea.scale.x *= -1
	if (is_last_frame() && charactersprite.animation == "machslideboost"):
		velocity.x = 0
		$SolidCheck.scale.x *= -1
		$SolidCheck2.scale.x *= -1
		$DestructibleArea.scale.x *= -1
		$WallClimbCheck.scale.x *= -1
		xscale *= -1
		movespeed = 8
		state = global.states.mach2
	if (is_last_frame() && charactersprite.animation == "machslideboost3"):
		velocity.x = 0
		charactersprite.animation = "mach4"
		$SolidCheck.scale.x *= -1
		$SolidCheck2.scale.x *= -1
		$DestructibleArea.scale.x *= -1
		$WallClimbCheck.scale.x *= -1
		xscale *= -1
		movespeed = 12
		state = global.states.mach3
	if (charactersprite.animation == "crouchslide" && movespeed == 0 && is_on_floor()):
		facehurt = 1
		state = global.states.normal
		charactersprite.animation = "facehurtup"
	if (mach2 == 0):
		if (!utils.instance_exists("obj_slidecloud") && is_on_floor()):
			utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_slidecloud.tscn")
			for i in get_tree().get_nodes_in_group("obj_slidecloud"):
				if xscale == 1:
					i.sprite.flip_h = false
				elif xscale == -1:
					i.sprite.flip_h = true
	elif (mach2 >= 35):
		if (!utils.instance_exists("obj_dashcloud") && is_on_floor()):
			utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_dashcloud.tscn")
			for i in get_tree().get_nodes_in_group("obj_dashcloud"):
				if xscale == 1:
					i.sprite.flip_h = false
				elif xscale == -1:
					i.sprite.flip_h = true
	elif (mach2 >= 100):
		if (!utils.instance_exists("obj_dashcloud2") && is_on_floor()):
			utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_dashcloud2.tscn")
			for i in get_tree().get_nodes_in_group("obj_dashcloud2"):
				if xscale == 1:
					i.sprite.flip_h = false
				elif xscale == -1:
					i.sprite.flip_h = true
	
func scr_player_climbwall():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	if (windingAnim < 200):
		windingAnim += 1
	suplexmove = 0
	velocity.y = (-wallspeed)
	if (wallspeed < 24 && move == xscale):
		wallspeed += 0.05
	crouchslideAnim = 1
	charactersprite.animation = "climbwall"
	if (!Input.is_action_pressed("key_dash") || (move != xscale && move != 0)):
		state = global.states.normal
		movespeed = 0
	if (is_on_ceiling()):
		charactersprite.animation = "superjumpland"
		$Groundpound.play()
		state = global.states.Sjumpland
		machhitAnim = 0
	if (!is_colliding_wallclimb()):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_jumpdust.tscn")
		velocity.y = 0
		if (movespeed >= 8 && movespeed < 12):
			state = global.states.mach2
		elif (movespeed >= 12):
			state = global.states.mach3
			charactersprite.animation = "mach4"
		else:
			state = global.states.normal
	if (Input.is_action_just_pressed("key_jump")):
		movespeed = 8
		charactersprite.animation = "walljumpstart"
		velocity.y = -11
		xscale *= -1
		jumpstop = 0
		state = global.states.mach2
	if ((is_on_floor() && wallspeed <= 0) || wallspeed <= 0):
		state = global.states.jump
		charactersprite.animation = "fall"
	charactersprite.speed_scale = 0.6
	if (!utils.instance_exists("obj_cloudeffect")):
		utils.instance_create(position.x, (position.y + 43), "res://Objects/Visuals/obj_cloudeffect.tscn")
	
func scr_player_machroll():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	velocity.x = (xscale * movespeed)
	mach2 = 100
	machslideAnim = 1
	if (is_colliding_with_wall() && is_on_wall()):
		$Bump.play()
		velocity.x = 0
		charactersprite.speed_scale = 0.35
		flash = false
		state = global.states.bump
		velocity.x = (-2.5 * xscale)
		velocity.y = -3
		mach2 = 0
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_bumpeffect.tscn")
	if (!utils.instance_exists("obj_cloudeffect") && is_on_floor()):
		utils.instance_create(position.x, (position.y + 43), "res://Objects/Visuals/obj_cloudeffect.tscn")
	if is_on_floor():
		charactersprite.animation = "machroll"
	elif charactersprite.animation != "dive":
		charactersprite.animation = "dive"
		velocity.y = 10
	charactersprite.speed_scale = 0.8
	if (!Input.is_action_pressed("key_down") && !$CrouchCheck.is_colliding()):
		$RollGetUp.play()
		state = global.states.mach2
		charactersprite.animation = "rollgetup"
	
func scr_player_tumble():
	velocity.x = (xscale * movespeed)
	if (charactersprite.animation == "tumblestart"):
		movespeed = 6
	else:
		movespeed = 14
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if !collision.collider.is_in_group("obj_slope") && charactersprite.animation == "tumblestart" && charactersprite.frame < 11:
			charactersprite.frame = 11
	if (charactersprite.animation == "tumblestart" && is_last_frame()):
		charactersprite.animation = "tumble"
	if (is_colliding_with_wall() && is_on_wall()):
		$Tumble4.play()
		velocity.x = 0
		movespeed = 0
		charactersprite.animation = "tumbleend"
		state = global.states.bump
	if Input.is_action_just_pressed("key_jump"):
		input_buffer_jump = 0
	if (!Input.is_action_pressed("key_jump") && jumpstop == 0 && velocity.y < 0.5 && stompAnim == 0):
		velocity.y /= 2
		jumpstop = 1
	if (is_on_floor() && velocity.y >= 0):
		jumpstop = 0
	if (input_buffer_jump < 8 && is_on_floor() && velocity.x != 0):
		velocity.y = -9
	charactersprite.speed_scale = 0.35
	
func scr_player_titlescreen():
	global.targetDoor = "A"
	if (charactersprite.animation == "pepcooter" && (!utils.instance_exists("obj_superdashcloud"))):
		utils.instance_create(position.x - 120, position.y, "res://Objects/Visuals/obj_superdashcloud.tscn")
	charactersprite.speed_scale = 0.35
	
func scr_player_Sjump():
	velocity.x = 0
	mach2 = 0
	jumpAnim = 1
	landAnim = 0
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 0
	machhitAnim = 0
	if (charactersprite.animation == "superjump"):
		velocity.y = -15
	if (is_on_ceiling()):
		if (charactersprite.animation == "superjump"):
			charactersprite.animation = "superjumpland"
		for i in get_tree().get_nodes_in_group("obj_camera"):
			i.shake_mag = 10
			i.shake_mag_acc = (30 / 30)
		for i in get_tree().get_nodes_in_group("obj_baddie"):
			if (i.screenvisible):
				if (i.is_on_floor()):
					i.velocity.y = -7
		$Groundpound.play()
		state = global.states.Sjumpland
		machhitAnim = 0
	if (Input.is_action_just_pressed("key_dash")):
		movespeed = 12
		machhitAnim = 0
		state = global.states.mach3
		flash = true
		charactersprite.animation = "mach4"
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_jumpdust.tscn")
	charactersprite.speed_scale = 0.5
	
func scr_player_Sjumpland():
	mach2 = 0
	jumpAnim = 1
	landAnim = 0
	machslideAnim = 1
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 0
	machhitAnim = 0
	movespeed = 0
	velocity.y = 0
	velocity.x = 0
	if (charactersprite.frame == 6):
		if (character == "P"):
			charactersprite.animation = "machfreefall"
		else:
			charactersprite.animation = "fall"
		state = global.states.jump
		jumpAnim = 0
	
func scr_player_Sjumpprep():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	mach2 = 0
	if (charactersprite.animation == "superjumpprep"):
		velocity.x = (xscale * movespeed)
		if (movespeed >= 0):
			movespeed -= 0.8
	if (charactersprite.animation == "superjumppreplight" || charactersprite.animation == "superjumpright" || charactersprite.animation == "superjumpleft"):
		velocity.x = (move * 2)
	if (charactersprite.animation != "superjumpprep"):
		if (sign(velocity.x) == 0):
			charactersprite.animation = "superjumppreplight"
		if (sign(velocity.x) == 1):
			if (xscale == 1):
				charactersprite.animation = "superjumpright"
			if (xscale == -1):
				charactersprite.animation = "superjumpleft"
		if (sign(velocity.x) == -1):
			if (xscale == 1):
				charactersprite.animation = "superjumpleft"
			if (xscale == -1):
				charactersprite.animation = "superjumpright"
	jumpAnim = 1
	landAnim = 0
	machslideAnim = 1
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 1
	if (is_last_frame() && charactersprite.animation == "superjumpprep"):
		charactersprite.animation = "superjumppreplight"
	if (!Input.is_action_pressed("key_up") && (charactersprite.animation == "superjumppreplight" || charactersprite.animation == "superjumpleft" || charactersprite.animation == "superjumpright")):
		$SuperJumpRelease.play()
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_explosioneffect.tscn")
		charactersprite.animation = "superjump"
		state = global.states.Sjump
		velocity.y = -15
	if (!$SuperJumpHold.playing):
		$SuperJumpHold.play()
	charactersprite.speed_scale = 0.35
	
func scr_player_fireass():
	charactersprite.speed_scale = 0.35
	if (charactersprite.animation == "fireass"):
		var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
		#if (is_last_frame()):
			#var impactid = utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_balloonpop.tscn")
			#impactid.sprite = "shotgunimpact"
		if (move != 0):
			xscale = move
		velocity.x = (move * movespeed)
		movespeed = 4
		if (is_on_floor() && velocity.y >= 0):
			movespeed = 6
			charactersprite.animation = "fireassground"
	if (charactersprite.animation == "fireassground"):
		velocity.x = (xscale * movespeed)
		if (movespeed > 0):
			movespeed -= 0.25
		if (is_last_frame() || is_colliding_with_wall()):
			#$FireassEnd.play()
			#charactersprite.animation = "fireassend"
			#velocity.x = 0
			movespeed = 0
			landAnim = 0
			$FlashEffectOffTimer.wait_time = 0.05
			$FlashEffectOffTimer.start()
			$HurtTimer2.wait_time = 1
			$HurtTimer2.start()
			hurted = 1
			state = global.states.normal
			charactersprite.animation = "idle"
	if (charactersprite.animation == "fireassend"):
		if (is_last_frame()):
			movespeed = 0
			landAnim = 0
			$FlashEffectOffTimer.wait_time = 0.05
			$FlashEffectOffTimer.start()
			$HurtTimer2.wait_time = 1
			$HurtTimer2.start()
			hurted = 1
			state = global.states.normal
			charactersprite.animation = "idle"
	
	
func scr_player_timesup():
	xscale = 1
	inv_frames = 0
	charactersprite.animation = "timesup"
	$HurtTimer.stop()
	$HurtTimer2.stop()
	if (global.targetRoom == "timesuproom"):
		position.x = 480
		position.y = 270
	if (charactersprite.frame == 9):
		charactersprite.speed_scale = 0
	
func scr_player_gameover():
	charactersprite.speed_scale = 0.35
	cutscene = true
	hurted = 0
	inv_frames = 0
	flash = false
	if (velocity.y < 30):
		velocity.y += grav
	if (position.y > 1080):
		global.roomtorestart = ""
		global.leveltorestart = ""
		scr_playerreset()
		global.targetDoor = "A"
		utils.room_goto("", "hub_room1")

func scr_player_victory():
	velocity.x = 0
	mach2 = 0
	jumpAnim = 1
	landAnim = 0
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 1
	machhitAnim = 0
	if (is_last_frame()):
		charactersprite.speed_scale = 0
	else:
		charactersprite.speed_scale = 0.35
	
func scr_player_grab():
	grav = 0.5
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	if (is_on_floor()):
		if (dir != xscale && charactersprite.animation != "swingding"):
			dir = xscale
			movespeed = 2
			facehurt = 0
		jumpstop = 0
		anger = 100
		velocity.x = (move * movespeed)
		if (!heavy):
			if (move != 0):
				if (movespeed < 6):
					movespeed += 0.5
				elif (floor(movespeed) == 6):
					movespeed = 6 
			else:
				movespeed = 0
			if (movespeed > 6):
				movespeed -= 0.1
		else:
			if (move != 0):
				if (movespeed < 4):
					movespeed += 0.25
				elif (floor(movespeed) == 4):
					movespeed = 4
			else:
				movespeed = 0
			if (movespeed > 4):
				movespeed -= 0.1
		if (move != 0 && charactersprite.animation != "swingding"):
			xscale = move
		if (move != 0):
			if (movespeed < 3 && move != 0):
				charactersprite.speed_scale = 0.35
			elif (movespeed > 3 && movespeed < 6):
				charactersprite.speed_scale = 0.45
			else:
				charactersprite.speed_scale = 0.6
		else:
			charactersprite.speed_scale = 0.35
	if (!is_on_floor()):
		if (dir != xscale && charactersprite.animation != "swingding"):
			dir = xscale
			movespeed = 2
			facehurt = 0
		if (move != xscale):
			movespeed = 2
		if (momemtum == 0):
			velocity.x = (move * movespeed)
		else:
			velocity.x = (xscale * movespeed)
		if (move != xscale && momemtum == 1 && movespeed != 0):
			movespeed -= 0.05
		if (movespeed == 0):
			momemtum = 0
		if (move != 0 && movespeed < 6):
			movespeed += 0.5
		if (movespeed > 6):
			movespeed -= 0.5
		if ($WallClimbCheck.is_colliding() && $WallClimbCheck.get_collider().is_in_group("obj_solid") && is_on_wall()):
			movespeed = 0
		if (dir != xscale && charactersprite.animation != "swingding"):
			dir = xscale
			movespeed = 2
			facehurt = 0
		if (move == (-xscale)):
			mach2 = 0
			momemtum = 0
		landAnim = 1
		if (!Input.is_action_pressed("key_jump") && jumpstop == 0 && velocity.y < 0.5 && stompAnim == 0):
			velocity.y /= 10
			jumpstop = 1
		if (ladderbuffer > 0):
			ladderbuffer -= 1
		if (is_on_ceiling() && jumpstop == 0 && jumpAnim == 1):
			velocity.y = grav
			jumpstop = 1
		if (move != 0 && charactersprite.animation != "swingding"):
			xscale = move
	if (Input.is_action_just_pressed("key_jump")):
		input_buffer_jump = 0
	if (is_on_floor() && input_buffer_jump < 8 && !Input.is_action_pressed("key_down") && !Input.is_action_pressed("key_dash") && velocity.y >= 0 && charactersprite.animation != "swingding"):
		$Jump.play()
		charactersprite.animation = "haulingjump"
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_highjumpcloud2.tscn")
		if (!heavy):
			velocity.y = -11
		else:
			velocity.y = -6
	if (is_on_floor() && move != 0 && charactersprite.animation == "haulingidle"):
		charactersprite.animation = "haulingwalk"
	elif (is_on_floor() && move == 0 && charactersprite.animation == "haulingwalk"):
		charactersprite.animation = "haulingidle"
	if (charactersprite.animation == "haulingstart" && is_last_frame()):
		charactersprite.animation = "haulingidle"
	if ((charactersprite.animation == "haulingjump" && is_last_frame()) || (!is_on_floor() && (charactersprite.animation == "haulingwalk" || charactersprite.animation == "haulingidle"))):
		charactersprite.animation = "haulingfall"
	if (is_on_floor() && velocity.y >= 0 && (charactersprite.animation == "haulingfall" || charactersprite.animation == "haulingjump")):
		charactersprite.animation = "haulingland"
		movespeed = 2
	if (charactersprite.animation == "haulingland" && is_last_frame()):
		charactersprite.animation = "haulingidle"
	if (move != 0 && move != lastmove && swingdingbuffer < 300):
		lastmove = move
		swingdingbuffer += 50
	if (swingdingbuffer > 0):
		swingdingbuffer -= 1
	if (charactersprite.animation == "swingding" && swingdingbuffer < 150):
		state = global.states.normal
	if (swingdingbuffer > 300 && charactersprite.animation != "swingding"):
		charactersprite.animation = "swingding"
		flash = true
	if (Input.is_action_just_pressed("key_dash") || Input.is_action_just_pressed("key_grab")):
		if (move != 0):
			move = xscale
		state = global.states.finishingblow
		if (charactersprite.animation == "swingding"):
			charactersprite.animation = "swingdingend"
		elif (!Input.is_action_pressed("key_up")):
			var rng = utils.randi_range(1, 5)
			if (rng == 1):
				charactersprite.animation = "finishingblow1"
			elif (rng == 2):
				charactersprite.animation = "finishingblow2"
			elif (rng == 3):
				charactersprite.animation = "finishingblow3"
			elif (rng == 4):
				charactersprite.animation = "finishingblow4"
			elif (rng == 5):
				charactersprite.animation = "finishingblow5"
		elif (Input.is_action_pressed("key_up")):
			charactersprite.animation = "uppercutfinishingblow"
		velocity.x = 0
		movespeed = 0
	if (Input.is_action_pressed("key_down") && !is_on_floor()):
		charactersprite.animation = "piledriver"
		velocity.y = -6
		state = global.states.superslam
		charactersprite.speed_scale = 0.35
	if (!utils.instance_exists("obj_cloudeffect") && is_on_floor() && move != 0 && (floor(charactersprite.frame) == 4 || floor(charactersprite.frame) == 10)):
		utils.instance_create(position.x, (position.y + 43), "res://Objects/Visuals/obj_cloudeffect.tscn")
	if (Input.is_action_pressed("key_down") && is_on_floor()):
		state = global.states.crouch
		landAnim = 0
		crouchAnim = 1
		idle = 0
	if (charactersprite.animation != "swingding"):
		charactersprite.speed_scale = 0.35
	else:
		# I don't know what's wrong here so I'll leave it like this for the time being
		#charactersprite.speed_scale = (swingdingbuffer / 600)
		charactersprite.speed_scale = 0.35
	
func scr_player_superslam():
	var move = 0
	if (charactersprite.animation == "piledriver"):
		move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
		velocity.x = (move * movespeed)
	else:
		move = 0
		velocity.x = 0
	if (is_on_floor() && charactersprite.animation == "piledriver" && velocity.y >= 0):
		$Groundpound.play()
		charactersprite.animation = "piledriverland"
		jumpAnim = 1
		for i in get_tree().get_nodes_in_group("obj_camera"):
			i.shake_mag = 20
			i.shake_mag_acc = (40 / 30)
		velocity.x = 0
		bounce = 0
		var effectid = utils.instance_create(position.x, position.y + 35, "res://Objects/Visuals/obj_bangeffect.tscn")
		effectid.scale.x = xscale
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_landcloud.tscn")
		freefallstart = 0
		for i in get_tree().get_nodes_in_group("obj_baddie"):
			if (i.is_on_floor() && i.screenvisible):
				i.velocity.y = -7
				i.velocity.x = 0
	jumpAnim = 1
	landAnim = 0
	machslideAnim = 1
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 1
	if (move != 0):
		if (movespeed < 6):
			movespeed += 0.5
		elif (floor(movespeed) == 6):
			movespeed = 6
	else:
		movespeed = 0
	if (movespeed > 6):
		movespeed -= 0.1
	if (character == "N" && move != 0):
		xscale = move
	charactersprite.speed_scale = 0.35
	
func scr_player_finishingblow():
	velocity.x = (xscale * movespeed)
	velocity.y = 0
	if (movespeed > 0):
		movespeed -= 0.5
	if (is_last_frame()):
		state = global.states.normal
	if (charactersprite.frame == 6 && (!utils.instance_exists("obj_swordhitbox"))):
		utils.playsound("Punch")
		utils.playsound("KillingBlow")
		utils.instance_create((global_position.x + 50), global_position.y, "res://Objects/Hitboxes/obj_swordhitbox.tscn")
	if (charactersprite.frame == 0 && (!utils.instance_exists("obj_swordhitbox")) && charactersprite.animation == "swingdingend"):
		utils.playsound("KillingBlow")
		utils.instance_create((global_position.x + 50), global_position.y, "res://Objects/Hitboxes/obj_swordhitbox.tscn")
	charactersprite.speed_scale = 0.35
	landAnim = 0
	
func scr_player_ladder():
	jumpAnim = 1
	landAnim = 0
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 0
	machhitAnim = 0
	jumpstop = 0
	movespeed = 0
	velocity.x = 0
	if Input.is_action_pressed("key_up"):
		charactersprite.animation = "laddermove"
		velocity.y = -2
		charactersprite.speed_scale = 0.35
	elif Input.is_action_pressed("key_down"):
		charactersprite.animation = "ladderdown"
		velocity.y = 6
		charactersprite.speed_scale = -0.35
	else:
		charactersprite.animation = "ladder"
		velocity.y = 0
	mach2 = 0
	if (!$LadderCheck.is_colliding()):
		landAnim = 0
		jumpAnim = 0
		state = global.states.normal
		velocity.y = 0
	if (Input.is_action_just_pressed("key_jump")):
		charactersprite.animation = "jump"
		ladderbuffer = 20
		jumpAnim = 1
		state = global.states.jump
		velocity.y = -9
	if (Input.is_action_pressed("key_down") && is_on_floor()):
		state = global.states.normal
		
func scr_player_tackle():
	mach2 = 0
	velocity.x = ((-xscale) * movespeed)
	if (movespeed > 0):
		movespeed -= 0.5
	jumpAnim = 1
	landAnim = 0
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 1
	if (is_last_frame()):
		state = global.states.normal
	charactersprite.speed_scale = 0.35
	
func scr_player_gottreasure():
	mach2 = 0
	charactersprite.animation = "gottreasure"
	charactersprite.speed_scale = 0.2
	
func scr_player_slipnslide():
	mach2 = 0
	jumpAnim = 1
	landAnim = 0
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 0
	machhitAnim = 0
	velocity.x = (xscale * movespeed)
	if ($SlopeCheck.is_colliding()):
		movespeed += 0.2
	else:
		if (movespeed > 0 && is_on_floor()):
			movespeed -= 0.25
	if (movespeed <= 0):
		for slope in $SlopeArea.get_overlapping_bodies():
			if (!slope.is_in_group("obj_slope")):
				state = global.states.normal
				movespeed = 0
				mach2 = 0
	if (is_colliding_with_wall()):
		state = global.states.bump
		velocity.x = (2 * (-xscale))
		velocity.y = -3
		mach2 = 0
		utils.instance_create(position.x + 10, position.y + 10, "res://Objects/Visuals/obj_bumpeffect.tscn")
	charactersprite.animation = "slipnslide"
	charactersprite.speed_scale = 0.35
	if (!utils.instance_exists("obj_slidecloud") && is_on_floor() && movespeed > 1.5):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_slidecloud.tscn")
		for i in get_tree().get_nodes_in_group("obj_slidecloud"):
			if xscale == 1:
				i.sprite.flip_h = false
			elif xscale == -1:
				i.sprite.flip_h = true
		
func scr_player_knightpep():
	$FlashEffectOffTimer.wait_time = 0.05
	$FlashEffectOffTimer.start()
	$HurtTimer2.start()
	var move = 0
	if (charactersprite.animation == "knightpep_walk" || charactersprite.animation == "knightpep_jump" || charactersprite.animation == "knightpep_fall" || charactersprite.animation == "knightpep_idle"):
		move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
		velocity.x = (move * movespeed)
	elif (is_on_floor()):
		move = 0
		velocity.x = 0
	if (Input.is_action_just_pressed("key_jump")):
		input_buffer_jump = 0
	if (!Input.is_action_pressed("key_jump") && jumpstop == 0 && velocity.y < 0.5 && stompAnim == 0):
		velocity.y /= 2
		jumpstop = 1
	if (is_on_floor() && velocity.y >= 0):
		jumpstop = 0
	if (dir != xscale):
		dir = xscale
		movespeed = 0
	if (is_on_floor() && move != 0 && charactersprite.animation == "knightpep_idle"):
		charactersprite.animation = "knightpep_walk"
	elif (is_on_floor() && move == 0 && charactersprite.animation == "knightpep_walk"):
		charactersprite.animation = "knightpep_idle"
	if (input_buffer_jump < 8 && velocity.y >= 0 && is_on_floor() && (charactersprite.animation == "knightpep_idle" || charactersprite.animation == "knightpep_walk")):
		charactersprite.animation = "knightpep_jumpstart"
	if (is_last_frame() && charactersprite.animation == "knightpep_jumpstart"):
		$Jump.play()
		velocity.y = -11
		if (Input.is_action_pressed("key_right")):
			velocity.x = 4
		if (Input.is_action_pressed("key_left")):
			velocity.x = -4
		charactersprite.animation = "knightpep_jump"
	if ((is_last_frame() && charactersprite.animation == "knightpep_jump") || (!is_on_floor() && charactersprite.animation != "knightpep_jump" && charactersprite.animation != "knightpep_thunder")):
		charactersprite.animation = "knightpep_fall"
	if (charactersprite.animation == "knightpep_fall" && is_on_floor() && velocity.y >= 0):
		for i in get_tree().get_nodes_in_group("obj_baddie"):
			if (i.is_on_floor() && i.screenvisible):
				i.velocity.y = -7
				i.velocity.x = 0
		for i in get_tree().get_nodes_in_group("obj_camera"):
			i.shake_mag = 10
			i.shake_mag_acc = (30 / 30)
		bounce = 0
		freefallstart = 0
		momemtum = 0
		$Groundpound.play()
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_landcloud.tscn")
		charactersprite.animation = "knightpep_land"
	if (is_last_frame() && charactersprite.animation == "knightpep_land"):
		charactersprite.animation = "knightpep_idle"
	if (move != 0):
		xscale = move
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if (collision.collider != null):
			if collision.collider.is_in_group("obj_slope") && charactersprite.animation != "knightpep_thunder":
				xscale = (-sign(collision.collider.scale.x))
				$SolidCheck.scale.x *= -1
				$SolidCheck2.scale.x *= -1
				$DestructibleArea.scale.x *= -1
				$WallClimbCheck.scale.x *= -1
				state = global.states.knightpepslopes
				charactersprite.animation = "knightpep_downslope"
	if (move != 0):
		if (movespeed < 6):
			movespeed += 0.5
		elif (movespeed == 6):
			movespeed = 6
	else:
		movespeed = 0
	if (move != 0 && velocity.x != 0):
		if (movespeed < 1):
			charactersprite.speed_scale = 0.15
		elif (movespeed > 1 && movespeed < 4):
			charactersprite.speed_scale = 0.35
		else:
			charactersprite.speed_scale = 0.6
	else:
		charactersprite.speed_scale = 0.35
	if (charactersprite.frame == 4 && charactersprite.animation == "knightpep_start"):
		utils.instance_create(position.x, position.y - 600, "res://Objects/Visuals/obj_thunder.tscn")
	if (is_last_frame() && charactersprite.animation == "knightpep_thunder"):
		charactersprite.animation = "knightpep_idle"
	if (!utils.instance_exists("obj_cloudeffect") && is_on_floor() && move != 0 && (charactersprite.frame == 4 || charactersprite.frame == 10)):
		utils.instance_create(position.x, (position.y + 43), "res://Objects/Visuals/obj_cloudeffect.tscn")
	
func scr_player_knightpepattack():
	pass
	
func scr_player_knightpepslopes():
	$FlashEffectOffTimer.wait_time = 0.05
	$FlashEffectOffTimer.start()
	$HurtTimer2.start()
	hurted = 1
	velocity.x = (xscale * movespeed)
	if (charactersprite.animation == "knightpep_downslope"):
		movespeed = 15
	if (!$SlopeCheck.is_colliding()):
		charactersprite.animation = "knightpep_charge"
	if ($SlopeCheck.is_colliding()):
		charactersprite.animation = "knightpep_downslope"
	if (is_colliding_with_wall()):
		var debris1 = utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_knightdebris.tscn")
		debris1.sprite.frame = 0
		var debris2 = utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_knightdebris.tscn")
		debris2.sprite.frame = 1
		var debris3 = utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_knightdebris.tscn")
		debris3.sprite.frame = 2
		var debris4 = utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_knightdebris.tscn")
		debris4.sprite.frame = 3
		var debris5 = utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_knightdebris.tscn")
		debris5.sprite.frame = 4
		var debris6 = utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_knightdebris.tscn")
		debris6.sprite.frame = 5
		velocity.x = (5 * xscale)
		velocity.y = -3
		$Bump.play()
		utils.playsound("LoseKnight")
		flash = true
		state = global.states.bump
	if (movespeed <= 0 && charactersprite.animation == "knightpep_charge"):
		charactersprite.animation = "knightpep_idle"
		state = global.states.knightpep
	charactersprite.speed_scale = 0.4
	
func scr_player_bombpep():
	if (Input.is_action_just_pressed("key_jump")):
		input_buffer_jump = 0
	if (!Input.is_action_pressed("key_jump") && jumpstop == 0 && velocity.y < 0.5 && stompAnim == 0):
		velocity.y /= 2
		jumpstop = 1
	if (is_on_floor() && velocity.y >= 0):
		jumpstop = 0
	mach2 = 0
	landAnim = 0
	$FlashEffectOffTimer.wait_time = 0.05
	$FlashEffectOffTimer.start()
	if (charactersprite.animation == "bombpep_intro" && is_last_frame()):
		charactersprite.animation = "bombpep_run"
	if (charactersprite.animation == "bombpep_run" || charactersprite.animation == "bombpep_runabouttoexplode"):
		if (movespeed <= 8):
			movespeed += 0.2
		var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
		if (is_on_floor()):
			if (move != 0 && !utils.instance_exists("obj_cloudeffect")):
				xscale = move
		velocity.x = (xscale * movespeed)
	else:
		velocity.x = 0
		movespeed = 0
	if (bombpeptimer < 20 && bombpeptimer != 0):
		charactersprite.animation = "bombpep_runabouttoexplode"
	if (is_last_frame() && charactersprite.animation == "bombpep_end"):
		$HurtTimer2.wait_time = 1
		$HurtTimer2.start()
		hurted = 1
		state = global.states.normal
		charactersprite.animation = "idle"
	if (bombpeptimer <= 0 && charactersprite.animation == "bombpep_runabouttoexplode"):
		$Bombpep2.play()
		hurted = 1
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_bombexplosion.tscn")
		charactersprite.animation = "bombpep_end"
	if (bombpeptimer > 0):
		bombpeptimer -= 0.5
	if (is_colliding_with_wall()):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_bumpeffect.tscn")
		xscale *= -1
		$SolidCheck.scale.x *= -1
		$SolidCheck2.scale.x *= -1
		$DestructibleArea.scale.x *= -1
		$WallClimbCheck.scale.x *= -1
	if (input_buffer_jump < 8 && is_on_floor() && velocity.x != 0):
		velocity.y = -9
	if (movespeed < 4):
		charactersprite.speed_scale = 0.35
	elif (movespeed > 4 && movespeed < 8):
		charactersprite.speed_scale = 0.45
	else:
		charactersprite.speed_scale = 0.6
	if (!utils.instance_exists("obj_dashcloud") && is_on_floor() && velocity.x != 0):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_dashcloud.tscn")
		for i in get_tree().get_nodes_in_group("obj_dashcloud"):
			if xscale == 1:
				i.sprite.flip_h = false
			elif xscale == -1:
				i.sprite.flip_h = true
	
	
func scr_player_keyget():
	velocity.x = 0
	velocity.y = 0
	charactersprite.speed_scale = 0.35
	movespeed = 0
	mach2 = 0
	jumpAnim = 1
	landAnim = 0
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 1
	machhitAnim = 0
	charactersprite.animation = "keyget"
	if (is_last_frame()):
		global.keyget = false
		state = global.states.normal
		
func scr_player_shotgun():
	velocity.x = (xscale * movespeed)
	dir = xscale
	movespeed = 0
	landAnim = 0
	momemtum = 1
	if (is_last_frame()):
		if (is_on_floor()):
			charactersprite.animation = "shotgun_idle"
			state = global.states.normal
		else:
			charactersprite.animation = "shotgun_fall"
			state = global.states.jump
	charactersprite.speed_scale = 0.4
	if (!utils.instance_exists("obj_slidecloud") && is_on_floor() && movespeed > 4):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_slidecloud.tscn")
		
func scr_player_portal():
	if (is_last_frame() && charactersprite.animation == "pizzaportalentrancestart"):
		visible = true
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_pizzaportalfade.tscn")
		state = global.states.freefall
		charactersprite.animation = "machfreefall"
		grav = 0.5
	mach2 = 0
	
func scr_player_faceplant():
	velocity.x = (xscale * movespeed)
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	if (movespeed < 12 && is_on_floor()):
		movespeed += 0.5
	if (is_colliding_with_wall()):
		charactersprite.animation = "hitwall"
		$Groundpound.play()
		$Bump.play()
		for i in get_tree().get_nodes_in_group("obj_camera"):
			i.shake_mag = 20
			i.shake_mag_acc = (40 / 20)
		velocity.x = 0
		charactersprite.speed_scale = 0.35
		for i in get_tree().get_nodes_in_group("obj_baddie"):
			if (i.screenvisible):
				i.stun = true
				i.ministun = false
				i.velocity.y = -5
				i.velocity.x = 0
		flash = false
		state = global.states.bump
		velocity.x = (-2.5 * xscale)
		velocity.y = -3
		mach2 = 0
		utils.instance_create(position.x + 10, position.y + 10, "res://Objects/Visuals/obj_bumpeffect.tscn")
	if (is_last_frame() && !Input.is_action_pressed("key_dash")):
		state = global.states.normal
	elif (is_last_frame() && Input.is_action_pressed("key_dash")):
		charactersprite.speed_scale = 0.35
		state = global.states.mach2
	if (!utils.instance_exists("obj_dashcloud2") && is_on_floor() && movespeed > 5):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_dashcloud2.tscn")
		for i in get_tree().get_nodes_in_group("obj_dashcloud2"):
			if xscale == 1:
				i.sprite.flip_h = false
			elif xscale == -1:
				i.sprite.flip_h = true
				
func scr_player_ejected():
	if (position.y > utils.get_instance_level("obj_camlimit_bottom").position.y + 100 && !utils.instance_exists("obj_fadeout")):
		landAnim = 0
		targetLevel = lastlevel
		targetRoom = lastroom
		global.targetDoor = lastdoor
		state = global.states.normal
		global.combo = 0
		global.combotime = 0
		global.combodropped = false
		global.combomilestone = 10
		supercharged = false
		for i in get_tree().get_nodes_in_group("obj_camera"):
			i.ded = 0
			i.heatmeter.animation = "empty"
		utils.instance_create(utils.get_gamenode().global_position.x, utils.get_gamenode().global_position.y, "res://Objects/Visuals/obj_fadeout.tscn")
	charactersprite.animation = "deathend"
	charactersprite.speed_scale = 0.35
	cutscene = true
	hurted = 0
	inv_frames = 0
	if (velocity.y < 12):
		velocity.y += grav
	
func scr_playerreset():
	if (utils.instance_exists("obj_endlevelfade")):
		for i in get_tree().get_nodes_in_group("obj_endlevelfade"):
			i.queue_free()
	global.secretfound = 0
	global.hurtcounter = 0
	for i in get_tree().get_nodes_in_group("obj_tv"):
		i.shownranka = false
		i.shownrankb = false
		i.shownrankc = false
	for i in get_tree().get_nodes_in_group("obj_music"):
		i.musicnode.stop()
	if (utils.instance_exists("obj_timesup")):
		for i in get_tree().get_nodes_in_group("obj_timesup"):
			i.queue_free()
	if (utils.instance_exists("obj_pizzaface")):
		for i in get_tree().get_nodes_in_group("obj_pizzaface"):
			i.destroy()
	global.seconds = 59
	global.minutes = 1
	global.laps = 0
	global.taminutes = 0
	global.taseconds = 0
	global.timeattack = false
	state = global.states.normal
	visible = true
	targetLevel = ""
	targetRoom = ""
	indoor = false
	box = false
	supercharged = false
	global.saveroom.clear()
	global.baddieroom.clear()
	global.escaperoom.clear()
	$WhiteFlashTimer.stop()
	$FlashEffectOffTimer.stop()
	$FlashEffectOnTimer.stop()
	$HurtTimer.stop()
	$HurtTimer2.stop()
	grav = 0.5
	velocity.x = 0
	velocity.y = 0
	xscale = 1
	yscale = 1
	position.x = backtohubstartx
	position.y = backtohubstarty
	shotgunAnim = 0
	steppy = 0
	jumpstop = 0
	for i in get_tree().get_nodes_in_group("obj_camera"):
		i.ded = 0
		i.heatmeter.animation = "empty"
	global.panic = false
	jumpAnim = 1
	landAnim = 0
	machslideAnim = 0
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 1
	machhitAnim = 0
	stompAnim = 0
	inv_frames = 0
	hurted = 0
	mach2 = 0
	input_buffer_jump = 8
	input_buffer_secondjump = 8
	input_buffer_highjump = 8
	flash = false
	global.key_inv = false
	global.keyget = false
	global.toppintotal = 1
	global.shroomfollow = false
	global.cheesefollow = false
	global.tomatofollow = false
	global.sausagefollow = false
	global.pineapplefollow = false
	global.collect = 0
	global.pizzacoin = 0
	global.treasure = false
	global.combo = 0
	global.combotime = 0
	global.combodropped = false
	global.combomilestone = 10
	global.multiplier = 1
	global.style = 0
	global.stylethreshold = 0
	backupweapon = false
	global.hit = 0
	bounce = 0
	idle = 0
	superslam = 0
	attacking = 0
	machpunchAnim = 0
	punch = 0
	instakillmove = 0
	windingAnim = 0
	facestompAnim = 0
	ladderbuffer = 0
	toomuchalarm1 = 0
	toomuchalarm2 = 0
	flamecloud_buffer = 0
	idleanim = 0
	momemtum = 0
	cutscene = false
	grabbing = 0
	dir = xscale
	fallinganimation = 0
	bombpeptimer = 100
	suplexmove = 0
	anger = 0
	angry = 0

func scr_playersounds():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	if (state == global.states.mach1 && !$Mach1.playing && is_on_floor()):
		$Mach1.play()
	elif (state != global.states.mach1 || !is_on_floor() || move == (-xscale)):
		$Mach1.stop()
	if (((charactersprite.animation == "mach" || charactersprite.animation == "machhit") || state == global.states.climbwall) && !$Mach2.playing):
		$Mach2.play()
	elif ((charactersprite.animation != "mach" && charactersprite.animation != "machhit") && state != global.states.climbwall):
		$Mach2.stop()
	if ((state == global.states.mach3 || charactersprite.animation == "machslideboost3") && charactersprite.animation != "crazyrun" && !$Mach3.playing):
		$Mach3.play()
	elif ((state != global.states.mach3 && charactersprite.animation != "machslideboost3") || charactersprite.animation == "crazyrun"):
		$Mach3.stop()
	if (charactersprite.animation == "crazyrun" && !$Mach4.playing):
		$Mach4.play()
	elif (charactersprite.animation != "crazyrun"):
		$Mach4.stop()
	if (state == global.states.knightpepslopes && !$KnightSlide.playing):
		$KnightSlide.play()
	elif (state != global.states.knightpepslopes && $KnightSlide.playing):
		$KnightSlide.stop()
	if ((charactersprite.animation == "bombpep_run" || charactersprite.animation == "bombpep_runabouttoexplode") && !$Bombpep1.playing):
		$Bombpep1.play()
	elif ((charactersprite.animation != "bombpep_run" && charactersprite.animation != "bombpep_runabouttoexplode") && $Bombpep1.playing):
		$Bombpep1.stop()
	if (state != global.states.Sjumpprep && $SuperJumpPrep.playing):
		$SuperJumpPrep.stop()
	if (state != global.states.Sjumpprep && $SuperJumpHold.playing):
		$SuperJumpHold.stop()
	if (charactersprite.animation == "tumblestart" && !$Tumble1.playing && charactersprite.frame < 11):
		$Tumble1.play()
	if (charactersprite.animation == "tumblestart" && charactersprite.frame == 11 && !$Tumble2.playing):
		$Tumble2.play()
		$Tumble1.stop()
	if ((charactersprite.animation == "tumble" || charactersprite.animation == "machroll") && !$Tumble3.playing):
		$Tumble3.play()
	if (state != global.states.tumble && charactersprite.animation != "machroll"):
		$Tumble1.stop()
		$Tumble2.stop()
		$Tumble3.stop()
	if ($SuplexDash.playing && state != global.states.handstandjump && state != global.states.shoulderbash):
		$SuplexDash.stop()

func _on_HurtTimer_timeout():
	if (state == global.states.hurt):
		state = global.states.normal
		movespeed = 0

func _on_HurtTimer2_timeout():
	hurted = 0
	inv_frames = 0

func _on_FlashEffectOffTimer_timeout():
	modulate.a = 0
	$FlashEffectOnTimer.wait_time = 0.05
	$FlashEffectOnTimer.start()

func _on_FlashEffectOnTimer_timeout():
	modulate.a = 1
	$FlashEffectOffTimer.wait_time = 0.05
	$FlashEffectOffTimer.start()

func _on_WhiteFlashTimer_timeout():
	flash = false

func _on_GrabCheckTimer_timeout():
	if (!utils.instance_exists_level(baddiegrabbed) && (state == global.states.grab || state == global.states.superslam)):
		state = global.states.normal
	if (baddiegrabbed != "" && utils.instance_exists_level(baddiegrabbed) && utils.get_instance_level(baddiegrabbed).state != global.states.grabbed && state == global.states.grab):
		utils.get_instance_level(baddiegrabbed).state = global.states.grabbed
