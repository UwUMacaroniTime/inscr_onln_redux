@tool
extends EditorExportPlugin

var do:bool = false
var progress:int = 0
var compiled:Dictionary


func _get_name():
	return "json_export"

func _export_begin(features, is_debug, path, flags):
	do = ("json_export" in features)
	progress = 0
	for file in DirAccess.get_files_at(ProjectSettings.globalize_path("res://JSON/")):
		DirAccess.remove_absolute(ProjectSettings.globalize_path("res://JSON/"+file))
		print("removed ", file)
	compiled = {"cards":[],"scrybes":[]}

func _export_end():
	if do:
		var fl = FileAccess.open(ProjectSettings.globalize_path("res://JSON/data.json"), FileAccess.WRITE_READ)
		fl.store_string(JSON.stringify(compiled))
		fl.close()
		do = false
		compiled = {} # for memory

func _export_file(path, type, features):
	
	if (do and type == "Resource"):
		
		var data = load(path)
		if (data is CData):
			var cdata: CData = data
			var json:Dictionary = {
				"attack":cdata.attack,
				"health":cdata.health,
				"name":cdata.resource_name,
				"conduit":cdata.conductive,
				"nosac":!cdata.sacrificable,
				"blood_cost":cdata.blood_cost,
				"sap_cost":cdata.sap_cost,
				"bone_cost":cdata.bone_cost,
				"energy_cost":cdata.energy_cost,
				"cells_cost":cdata.energy_max_cost,
				"heat_csot":cdata.heat_cost,
				"portrait":cdata.portrait.resource_path,
				"mox_cost":[],
				"sigils":[],
				"tribes":[],
				"description":cdata.description
			}
			
			for c in ["Green","Blue","Orange", "Prisim"]:
				for i in cdata.get("mox_" + c.to_lower() + "_cost"):
					json["mox_cost"].append(c)
			
			for s in cdata.sigils:
				var sg:Sigil = s.script.new() # tricking godot into realising that yes, this is an object with functions
				
				for property in s.get_property_list():
					sg.set(property.name, s.get(property.name))
				
				json["sigils"].append({
					"name":sg.resource_name,
					"icon":sg.get_icon().resource_path,
					"desc":sg.get_desc()
				})
			
			for t in cdata.tribes:
				json["tribes"].append(CData.TRIBES.keys()[t])
			
			print("exported ", cdata.resource_name, " (", progress, " done)")
			progress += 1
			
			compiled["cards"].append(json)
			return
		
		if (data is ScrybeData):
			var json := {
				"portrait":data.portrait.resource_path,
				"title":data.title,
				"name":data.resource_name,
				"desc":data.description.replace("[b]", "**").replace("\n[/b]", "**\n"),
			}
			compiled["scrybes"].append(json)
