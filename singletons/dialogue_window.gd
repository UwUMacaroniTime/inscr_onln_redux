extends Window

@onready var dialogue_text = $Dialogue
@onready var portrait = $Portrait

var dialogue:Array[Dialogue] = []
func say(phrases:Array[Dialogue]):
	dialogue = phrases
	next()
	CanvasTint.color = Color.DIM_GRAY
	popup_centered(size)

func _on_backgrnd_pressed():
	if len(dialogue) > 0:
		next()
	else:
		CanvasTint.color = Color.WHITE
		hide()

func next():
	var front :Dialogue = dialogue.pop_front()
	dialogue_text.text = front.text
	portrait.texture = front.portrait
	if front.next != null:
		dialogue.push_front(front.next)
