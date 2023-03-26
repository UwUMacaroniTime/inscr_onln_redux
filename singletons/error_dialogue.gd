extends AcceptDialog

func notify(text_body:String, title:String = "Notification"):
	popup_centered(min_size)
	self.title = title
	# we are not setting dialogue_text directly because this allows us to embed bbcode
	$BodyText.text = "[center]" + text_body +"[/center]"

