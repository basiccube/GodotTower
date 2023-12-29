extends Node

var panic = false
var saveroom = []
var baddieroom = []
var escaperoom = []
var targetLevel = ""
var targetRoom = ""
var targetDoor = "A"
var leveltorestart = ""
var roomtorestart = ""

# Debug stuff
var debugview = false
var debugcollisions = true
var hudvisible = true

# Game options
var option_resolution = 1
var option_fullscreen = false
var option_mastervolume = 0
var option_sfxvolume = 0
var option_musicvolume = 0


# Enables the style bar from April 2019.
# This feature is extremely broken as the amount of score it gives is stupidly high.
var stylebar = false

# Enables the mach1 animation seen in May 2019 builds.
var may2019run = false

# Enables the shoulder bash from late 2020 builds.
var shoulderbash = false

# Enables the early 2019 grab.
var oldgrab = false

var minutes = 0
var seconds = 59
var laps = 0

# Time attack mode
var taminutes = 0
var taseconds = 0
var timeattack = false

var combo = 0
var combotime = 0
var combodropped = false
var combomilestone = 10

# Style bar
var style = 0
var stylethreshold = 0
var multiplier = 1

# Heat meter
var heatstyle = 0
var heatstylethreshold = 0
var heattime = 0
var baddierage = false
var baddiespeed = 1

var collect = 0
var pizzacoin = 0
var key_inv = false
var keyget = false
var hit = 0
var golfhit = 0

var hurtcounter = 0
var hurtmilestone = 3

var rank = ""
var secretfound = 0
var treasure = false
var toppintotal = 1
var shroomfollow = false
var cheesefollow = false
var tomatofollow = false
var sausagefollow = false
var pineapplefollow = false

var srank = 0
var arank = 0
var brank = 0
var crank = 0

var peppalette = 0

enum states {
	normal,
	jump,
	backbreaker,
	crouch,
	crouchjump,
	crouchslide,
	tumble,
	freefallprep,
	freefallland,
	freefall,
	mach1,
	mach2,
	mach3,
	machfreefall,
	machslide,
	machroll,
	bump,
	comingoutdoor,
	door,
	handstandjump,
	shoulderbash,
	hurt,
	climbwall,
	titlescreen,
	fireass,
	timesup,
	gameover,
	Sjumpprep,
	Sjumpland,
	Sjump,
	victory,
	knightpep,
	knightpepslopes,
	knightpepattack,
	finishingblow,
	keyget,
	smirk,
	gottreasure,
	bossintro,
	tackle,
	superslam,
	slam,
	grab,
	grabbed,
	grabbing,
	punch,
	shoulder,
	uppunch,
	backkick,
	bombpep,
	skateboard,
	slipnslide,
	stun,
	turn,
	idle,
	walk,
	land,
	hit,
	charge,
	chase,
	rage,
	pizzagoblinthrow,
	throw,
	cheesepep,
	cheeseball,
	cheesepepstick,
	faceplant,
	facestomp,
	ejected,
	ladder,
	shotgun,
	shotgunjump,
	portal,
	parry,
	spin,
}
