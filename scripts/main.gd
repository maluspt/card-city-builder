extends Node2D

var card = preload("res://scenes/card.tscn")
@onready var hand = $Hand
@onready var tilemap = $TestTileMap

func _on_button_pressed():
	var new_card = card.instantiate()
	new_card.play_area = %PlayArea
	new_card.tilemap = tilemap
	hand.add_card(new_card)

