@tool
extends EditorExportPlugin

var do:bool = false
var progress:int = 0


func _get_name():
	return "json_export"

func _export_begin(features, is_debug, path, flags):
	do = ("json_export" in features)
	progress = 0
	for file in DirAccess.get_files_at(ProjectSettings.globalize_path("res://JSON/")):
		DirAccess.remove_absolute(ProjectSettings.globalize_path("res://JSON/"+file))
		print("removed ", file)
		pass


func _export_file(path, type, features):
	
	if (do and type == "Resource"):
		
		var data = load(path)
		if (not data is CData):
			return
		
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
			var sg:Sigil = s.script.new()
			
			for property in s.get_property_list():
				sg.set(property.name, s.get(property.name))
			
			json["sigils"].append({
				"name":sg.resource_name,
				"icon":sg.get_icon().resource_path,
				"desc":sg.get_desc()
			})
		
		for t in cdata.tribes:
			json["tribes"].append(CData.TRIBES.keys()[t])
		
		var fl = FileAccess.open(ProjectSettings.globalize_path("res://JSON/" \
		+ cdata.resource_name + ".json"), FileAccess.WRITE_READ)
		
		fl.store_string(JSON.stringify(json))
		fl.close()
		print("exported ", cdata.resource_name, " (", progress, " done)")
		skip()
		progress += 1
		pass
