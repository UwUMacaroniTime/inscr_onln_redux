extends Node

const port: = 1960

func _ready():
	if not SettingsManager.settings.network_enable:
		print("UPNP network functionality disabled.")
		
		if not SettingsManager.settings.disable_network_warning:
			ErrorDialogue.notify("UPNP [color=lightgray](Universal Plug aNd Play)[/color] has been disabled, possibly because Mac forgot to enable it by default. [color=red]You will not be able to play online until it is enabled.[/color] Please re-enable it in settings.\n[color=lightgray](this window will not reappear on subsiquent launches of the game)[/color]", "Online play disabled")
			SettingsManager.settings.disable_network_warning = true
			return
	

func upnp():
	var upnp: = UPNP.new()
	print("discovering network devices (this may take up to 2 seconds)...")
	var discover_result := upnp.discover(2000, 2, "")
	
	if discover_result == UPNP.UPNP_RESULT_SUCCESS:
		print("found network device\ngetting gateway...")
		var gateway = upnp.get_gateway()
		if gateway and gateway.is_valid_gateway():
			print("found valid gateway\nmaking request to forward port ", port, "...")
			var result := upnp.add_port_mapping(port, port, "inscryption_online_udp", "TCP")
			
			match result:
				upnp.UPNP_RESULT_SUCCESS:
					print("success")
				upnp.UPNP_RESULT_NOT_AUTHORIZED:
					assert(false, "not authorized to forward port!")
				upnp.UPNP_RESULT_INVALID_PORT:
					assert(false, "port " + str(port) + " is not a valid port!")
				upnp.UPNP_RESULT_INVALID_DURATION:
					assert(false, "invalid duration for port mapping!")
			
			print("external IP address: ", upnp.query_external_address())
			upnp.delete_port_mapping(port, "TCP")
			pass
		else:
			assert(false, "nonexistent or invalid gateway!")
	
	else:
		assert(false, "discovery exited with error code " + str(discover_result) + "!")
