class_name SpriteFramesGenerator
extends RefCounted


## Generates or appends an animation to a SpriteFrames resource by slicing a Texture2D by column and row counts.
## [param start_frame] and [param end_frame] are 0-indexed and inclusive.
static func from_grid(
	texture: Texture2D,
	h_frames: int,
	v_frames: int,
	anim_name: StringName,
	start_frame: int,
	end_frame: int,
	sprite_frames: SpriteFrames = null,
	fps: float = 10.0,
	loop: bool = true
) -> SpriteFrames:
	assert(texture != null, "Texture cannot be null.")
	assert(h_frames > 0 and v_frames > 0, "Grid dimensions must be greater than 0.")

	var tex_size := texture.get_size()
	var frame_size := Vector2(tex_size.x / h_frames, tex_size.y / v_frames)

	return _build_animation(texture, h_frames, v_frames, frame_size, anim_name, start_frame, end_frame, sprite_frames, fps, loop)


## Generates or appends an animation to a SpriteFrames resource by slicing a Texture2D using fixed pixel dimensions.
## [param start_frame] and [param end_frame] are 0-indexed and inclusive.
static func from_pixel_size(
	texture: Texture2D,
	frame_width: int,
	frame_height: int,
	anim_name: StringName,
	start_frame: int,
	end_frame: int,
	sprite_frames: SpriteFrames = null,
	fps: float = 10.0,
	loop: bool = true
) -> SpriteFrames:
	assert(texture != null, "Texture cannot be null.")
	assert(frame_width > 0 and frame_height > 0, "Frame dimensions must be greater than 0.")

	var tex_size := texture.get_size()
	var h_frames := int(tex_size.x) / frame_width
	var v_frames := int(tex_size.y) / frame_height

	if h_frames <= 0 or v_frames <= 0:
		push_error("Frame size (%dx%d) is larger than texture size (%dx%d)." % [frame_width, frame_height, int(tex_size.x), int(tex_size.y)])
		return sprite_frames if sprite_frames != null else SpriteFrames.new()

	var frame_size := Vector2(frame_width, frame_height)

	return _build_animation(texture, h_frames, v_frames, frame_size, anim_name, start_frame, end_frame, sprite_frames, fps, loop)


static func _build_animation(
	texture: Texture2D,
	h_frames: int,
	v_frames: int,
	frame_size: Vector2,
	anim_name: StringName,
	start_frame: int,
	end_frame: int,
	sprite_frames: SpriteFrames,
	fps: float,
	loop: bool
) -> SpriteFrames:
	if sprite_frames == null:
		sprite_frames = SpriteFrames.new()
		if sprite_frames.has_animation(&"default"):
			sprite_frames.remove_animation(&"default")

	var total_frames := h_frames * v_frames
	if total_frames <= 0:
		push_error("Total frames is 0. Check texture and grid/frame dimensions.")
		return sprite_frames

	var start_idx := clampi(start_frame, 0, total_frames - 1)
	var end_idx := clampi(end_frame, 0, total_frames - 1)

	if not sprite_frames.has_animation(anim_name):
		sprite_frames.add_animation(anim_name)

	sprite_frames.set_animation_speed(anim_name, fps)
	sprite_frames.set_animation_loop(anim_name, loop)

	for i in range(start_idx, end_idx + 1):
		var col := i % h_frames
		var row := i / h_frames

		var atlas := AtlasTexture.new()
		atlas.atlas = texture
		atlas.filter_clip = false
		atlas.region = Rect2(
			Vector2(col * frame_size.x, row * frame_size.y),
			frame_size
		)

		sprite_frames.add_frame(anim_name, atlas)

	return sprite_frames
