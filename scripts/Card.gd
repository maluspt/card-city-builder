extends TextureButton

var dragging = false
var card_highlighted = false

func _process(delta):
	if dragging:
		GameInfo.is_dragging_card = true
		global_position = Vector2(get_global_mouse_position().x - 23, get_global_mouse_position().y - 33)
		if Input.is_action_just_released("left_click"):
			GameInfo.is_dragging_card = false
			dragging = false

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
		dragging = true

func card_is_focused(focused: bool):
	if GameInfo.is_dragging_card == true:
		return
	if focused:
		z_index = 2
	else:
		z_index = 0
