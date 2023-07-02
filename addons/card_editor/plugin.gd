@tool
extends EditorPlugin

var exporter :EditorExportPlugin = null

func _enter_tree():
	exporter = preload("res://addons/card_editor/json_export.gd").new()
	add_export_plugin(exporter)


func _exit_tree():
	remove_export_plugin(exporter)
