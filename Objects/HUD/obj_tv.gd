extends Node2D

var chose = false
var message = ""
var showtext = false
var tvsprite = "default"
var imageindexstore = 0
var once = false
var shownranka = false
var shownrankb = false
var shownrankc = false
var character = "PEPPINO"

func _process(delta):
	$MessageLabel.text = message
	if (global.combo != 0 && global.combotime != 0 && (tvsprite == "default" || tvsprite == "combo")):
		$ComboLabel.visible = false
		$ComboLabel.text = global.combo
	else:
		$ComboLabel.visible = false

func _on_ResetTimer_timeout():
	showtext = false
	tvsprite = "default"
	$TVSprite.speed_scale = 0.1
	imageindexstore = 0
