extends Window

@onready var dialogue_text = $Dialogue
var dialogue:Array[String] = ["hmmm... this deck...", "it sure is a deck, I'll give you that"]

func say(phrases:Array[String]):
	dialogue = phrases
	dialogue_text.text = dialogue.pop_front()
	show()

func _on_backgrnd_pressed():
	if len(dialogue) > 0:
		dialogue_text.text = dialogue.pop_front()
	else:
		hide()

class Dialogue extends Resource:
	@export var text:String
	@export var portrait:Texture2D
