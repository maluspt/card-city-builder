class_name Card extends Control

var dragging = false
var card_highlighted = false
var in_hand_pos: Vector2
var in_hand_rot: float
var original_parent: Node = null
var original_index: int = -1
var play_area: Control
var tilemap: TileMap

func _process(delta):
	if dragging:
		GameInfo.is_dragging_card = true
		global_position = Vector2(get_global_mouse_position().x - 23, get_global_mouse_position().y - 33)
		rotation = 0
		if Input.is_action_just_released("left_click"):
			GameInfo.is_dragging_card = false
			dragging = false

			if play_area.get_global_rect().has_point(get_global_mouse_position()):
				queue_free()
				on_dropped_in_play_area()
			else:
				snap_back_to_hand()

func card_is_focused(focused: bool):
	if GameInfo.is_dragging_card == true:
		return
	if focused:
		z_index = 2
		await tween_animation(0)
	else:
		z_index = 0
		await tween_animation(1)
		
func tween_animation(type: int):
	var tween = create_tween()
	match type:
		0: # pickup animation
			tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		1:
			tween.tween_property(self, "scale", Vector2.ONE, 0.55).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	await tween.finished
	
	in_hand_pos = Vector2(50, 0)


func _on_mouse_entered():
	card_is_focused(true)
	card_highlighted = true

func _on_mouse_exited():
	card_is_focused(false)
	card_highlighted = false

func _on_gui_input(event):
	if dragging:
		return
	if event.is_action_pressed("left_click"):
		original_parent = get_parent()
		original_index = get_index()
		in_hand_pos = global_position
		in_hand_rot = rotation

		dragging = true
		
func snap_back_to_hand():
	get_parent().remove_child(self)
	original_parent.add_child(self)
	original_parent.move_child(self, original_index)
	scale = Vector2(1.2, 1.2)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
func on_dropped_in_play_area():
	var placeholder_scene = preload("res://scenes/PlacebleTile.tscn")
	var placeholder = placeholder_scene.instantiate()
	
	# Set tilemap e tile_id baseado na carta
	placeholder.tilemap = tilemap
	placeholder.tile_id = 1 # ou algo que depende da carta
	
	# Adiciona na cena
	get_tree().current_scene.add_child(placeholder)
	placeholder.position = get_global_mouse_position()
	placeholder.following_mouse = true


