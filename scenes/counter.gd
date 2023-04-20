extends Control

@onready var fg = $FG
@onready var bg = $BG

func set_value(text:int, first:String):
	fg.text = first + str(text)
	bg.text = first + str(text)
