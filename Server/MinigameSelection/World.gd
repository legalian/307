extends "res://GameBase.gd"
func systemname():
	return "MinigameSelection"
	
var minigameList = [["Racing", "Race Around the Track, Use Power Ups, and Pass All Other Racers To Win!", "res://minigames/MinigameSelection/MinigameSprites/RacingThumbnail.png"],
["Battle Royale", "Drop on A Huge Map, Pick Up Weapons, and Eliminate Other Players to be the Last Remaining!", "res://minigames/MinigameSelection/MinigameSprites/BattleRoyale_Icon.png"], 
["Demolition Derby", "Use Power Ups and Ram into Other Players to be the Last Remaining!", "res://minigames/MinigameSelection/MinigameSprites/CarSelectionPage.png"]
]


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var RandomMinigame = rng.randi_range(0, minigameList.size()-1)
	for p in players:
		rpc_unreliable_id(p.playerID, "_Select_Minigame", RandomMinigame);
	#somehow set the minigame order

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
