extends Node2D

var item_loaded

var item_loaded_string

var m_candy = preload("res://items/repo/m_candy.tres")

var test_item = preload("res://items/repo/test_heal.tres")
			
func load_item(item):
	match item:
		"m_candy":
			item_loaded = m_candy
		"test_item":
			item_loaded = test_item
