tool
extends BitmapFont

export(Texture) var texture = null setget changeTexture
export(String, MULTILINE) var characterMap setget changeMap
export(Vector2) var size setget changeSize
export(bool) var monospace = true setget changeMonospace

func changeTexture(value):
	texture = value
	if texture:
		update()

func changeMap(value):
	characterMap = value
	update()

func changeSize(value):
	size = value
	update()

func changeMonospace(value):
	monospace = value
	update()

func update():
	clear()
	if texture is Texture:
		add_texture(texture)
		var _characterArray = characterMap.to_utf8()
		for i in _characterArray.size():
			var _offsetLeft : int
			var _offsetRight : int
			
			if !monospace:
				var data = texture.get_data()
				data.lock()
				
				var _hit : bool
				
				# Left
				for _x in size.x:
					if _hit: break
					for _y in size.y:
						var _px = data.get_pixel(fmod(size.x * i, texture.get_width()) + _x, floor((size.x * i)/texture.get_width()) * size.y + _y)
						if _px.a != 0:
							_hit = true
							_offsetLeft = _x
							break
				_hit = false
				
				# Right
				for _x in size.x:
					if _hit: break
					for _y in size.y:
						var _px = data.get_pixel(fmod(size.x * i, texture.get_width()) + ((size.x - 1) - _x), floor((size.x * i)/texture.get_width()) * size.y + _y)
						if _px.a != 0:
							_hit = true
							_offsetRight = _x
							break
				
				data.unlock()
			
			var _rect = Rect2(fmod(size.x * i + _offsetLeft, texture.get_width()), floor((size.x * i)/texture.get_width()) * size.y, size.x - (_offsetLeft + _offsetRight), size.y)
			add_char(_characterArray[i], 0, _rect)
		update_changes()
