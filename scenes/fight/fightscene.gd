extends Control

enum player {
	client,
	enemy
}

@onready var hands :Array[Node] = [$ClientHand, $EnemyHand]
@onready var player_uis :Array[Node] = [ $ClientUI, $EnemyUI,]
@onready var lines :Array[Node] = [$Lines/Backline0, $Lines/Frontline0, $Lines/Backline1, $Lines/Frontline1]

func get_slot(side:player, frontline:bool, idx:int):
	return lines[side * 2 + int(frontline)].get_child(idx)


