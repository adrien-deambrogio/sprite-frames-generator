extends Node2D

var sheet: Texture2D = preload("res://7500.png")


func _ready():
	print("plop")

	# Option 1: Slice by grid count (4 columns x 13 rows)
	var frames_by_grid := SpriteFramesGenerator.from_grid(sheet, 14, 14, "idle", 0, 5 * 14 - 1)

	# Option 2: Slice by pixel dimensions (300px x 300px)
	# var frames_by_px := SpriteFramesGenerator.from_pixel_size(sheet, 250, 378)

	var err := ResourceSaver.save(frames_by_grid, "res://test_4.tres")
	if err != OK:
		push_error("Failed to save SpriteFrames: " + error_string(err))
