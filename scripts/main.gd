extends Node2D

var card = preload("res://scenes/card.tscn")

func _on_button_pressed():
	var new_card = card.instantiate()
	$Hand.add_child(new_card)
