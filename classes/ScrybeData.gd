class_name ScrybeData
extends Resource

## the portrait of the scrybe. Used to display as the profile icon, etc.
@export var portrait:Texture2D

@export_category("Editor Stuffs")
@export var name_tex:Texture2D
@export var name_mat:Material
@export var title:String
## the description displayed in the deck editor's scrybe select. Uses BBcode.
@export_multiline var description:String
