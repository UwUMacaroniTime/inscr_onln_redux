extends Node

var players:Array[Player] = [Player.new(0), Player.new(1)]
var host:int

signal player_gained_card(card:CData, player:Player)
