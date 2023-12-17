extends Area2D

export(String, "shroom", "sausage", "cheese", "tomato", "pineapple") var content = "shroom"

func _ready():
	$Sprite.speed_scale = 0.35
	$Sprite.playing = true
	if (global.saveroom.has(global.targetRoom + name)):
		queue_free()
	
func destroy():
	queue_free()

func _process(delta):
	var obj_player = utils.get_player()
	if (overlaps_body(obj_player) && $Sprite.animation == "unopen"):
		if (!utils.soundplaying("CollectToppin")):
			utils.playsound("CollectToppin")
		var smallnumbid = utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_smallnumber.tscn")
		smallnumbid.number = "1000"
		global.combotime = 60
		global.collect += 1000
		global.style += 10
		global.heattime = 60
		global.heatstyle += 10
		#utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_taunteffect.tscn")
		if (content == "shroom"):
			var pizzakinid = utils.instance_create_level(global_position.x, global_position.y, "res://Objects/Collectibles/obj_pizzakinshroom.tscn")
			global.shroomfollow = true
		if (content == "sausage"):
			var pizzakinid = utils.instance_create_level(global_position.x, global_position.y, "res://Objects/Collectibles/obj_pizzakinsausage.tscn")
			global.sausagefollow = true
		if (content == "cheese"):
			var pizzakinid = utils.instance_create_level(global_position.x, global_position.y, "res://Objects/Collectibles/obj_pizzakincheese.tscn")
			global.cheesefollow = true
		if (content == "tomato"):
			var pizzakinid = utils.instance_create_level(global_position.x, global_position.y, "res://Objects/Collectibles/obj_pizzakintomato.tscn")
			global.tomatofollow = true
		if (content == "pineapple"):
			var pizzakinid = utils.instance_create_level(global_position.x, global_position.y, "res://Objects/Collectibles/obj_pizzakinpineapple.tscn")
			global.pineapplefollow = true
		var obj_tv = utils.get_instance("obj_tv")
		if (global.toppintotal < 5):
			obj_tv.message = "YOU NEED " + str(5 - global.toppintotal) + " MORE TOPPINS!"
		if (global.toppintotal == 5):
			obj_tv.message = "YOU HAVE ALL TOPPINS!"
		obj_tv.showtext = true
		obj_tv.resettimer.wait_time = 2.5
		obj_tv.resettimer.start()
		global.saveroom.append(global.targetRoom + name)
		global.toppintotal += 1
		$Sprite.animation = "open"
	if ($Sprite.animation == "open" && $Sprite.frame == 16):
		destroy()
