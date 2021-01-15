extends Node

# class member variables go here, for example:
var player
var start


# for consistency's sake across the game
const LIGHT_SEC = 400	# must match LIGHT_SPEED for realism
const LS_TO_AU = 30 #500 realistic value
const AU = LS_TO_AU*LIGHT_SEC #12000
const ZEROC_IN_K = 273.15

const MOON_MASS = 0.0123 #Earth masses
const WORMHOLE_SPEED = 5.00 # in c

const start_date = [05, 05, 2155]
var date = start_date

# ship name lists here for consistency
# highly US themed names and some mythological animals
var friendly_names = ["Victorious", "Notorious", "Triumphant", "Courageous", "Reliant", "Privateer", "Providence", "Constellation", \
"Felicity", "Constitution", "Galactica", "Atlantis", "Cherokee", "Firebird", "Starbird", "Pegasus", "Hercules"]
# evil sounding
var enemy_names = ["Slasher", "Gnasher", "Raider", "Executioner", "Annihilator", "Plunder", "Destructor", \
"Merciless", "Fearless"]
# animal themed
var neutral_names = ["Meerkat", "Ursa", "Pouncer", "Fang", "Panther", "Cougar", "Claw", "Leopard", \
# fit the theme
"Mustang", "Vulture"]

# z index for consistent drawing
const PLAYER_Z = 10 # on top of everything else
const BASE_Z = 9
const SHIP_Z = 8
const ASTEROID_Z = 3
const PLANET_Z = 2

# ranks
enum ranks { CADET, ENSIGN, SCLT, FRLT }

# planets ships bases
var fleet1 = [1, 1, 1]
var fleet2 = [0, 1, 1] 

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func increment_date(days, months):
	# add them to date
	game.date = [game.date[0]+int(floor(days)), game.date[1]+months, game.date[2]]
	var month = game.date[1]
	if month > 12:
		game.date[1] = month-12
		game.date[2] += 1 # increment year

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
