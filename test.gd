extends Node2D

var sheet: Texture2D = preload("res://icon.svg")


func _ready():


	# Option 1: Slice by grid count (4 columns x 13 rows)
	# var frames_by_grid := SpriteFramesGenerator.from_grid(sheet, 4, 13, anims)

	# Option 2: Slice by pixel dimensions (300px x 300px)
	var frames_by_px := SpriteFramesGenerator.from_pixel_size(sheet, 300, 300, "idle", 20, 20)

	ResourceSaver.save(frames_by_px, "res://")
