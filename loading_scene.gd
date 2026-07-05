extends Node2D

@onready var LoadingLabel: Label = $CanvasLayer/Background/loadingtext


#SCENES

const MAP_SCENE = preload("uid://cr4jrnum24onu")
const SCENE_TRANSITION = preload("uid://dtv64xe1i5jfr")
const ARCHIVE = preload("uid://e4np211g5nk1")
const ARCHIVES_CARD = preload("uid://c0h5hn88auyo6")
const ASK_TUTORIAL = preload("uid://chp1m7pi4dfml")
const CARD_MANAGER = preload("uid://2r2t7sy2wycb")
const COIN_ADD_PARTICLE = preload("uid://s6va71jul34t")
const COIN_BARRAGE_PARTICLE = preload("uid://btjsmqynj8nhe")
const COIN_DECK = preload("uid://cjumn24wf84ma")
const COIN_PLAY_PARTICLE = preload("uid://w5jgphq268vx")
const COIN_STATUS_EFFECT = preload("uid://b7frpsmw0r6p")
const COIN = preload("uid://ddet242jm5v23")
const CREDITS = preload("uid://c0qbb7sy8pdut")
const DAMAGE_PARTICLE = preload("uid://q4hytnmn2fbt")
const DEBT_DAMAGE_PARTICLE = preload("uid://1g21u656k60k")
const DEBT_EFFECT_PARTICLE = preload("uid://c52tpyupg2ynl")
const DIALOGUE_BOX = preload("uid://dv278qg6j2epd")
const ENEMY_HEALTH_BAR = preload("uid://dbj4jt3y4yqdx")
const ENEMY_INFORMATION_DISPLAY = preload("uid://1lqiy1lfcalo")
const FLOATING_LABEL = preload("uid://dwf6g2wuj1oe3")
const GAIN_EFFECT_PARTICLE = preload("uid://c5py6ekby1mnm")
const INFLATION_PARTICLE = preload("uid://bq67mkmrnr14p")
const KEEPER_HEALTH_BAR = preload("uid://ca5q424cckfd0")
const KEEPER_INFORMATION_DISPLAY = preload("uid://c8vfntelui3b7")
const LOAN_SHARK = preload("uid://c3dwvff0d1irb")
const LOAN_SHARK_BITE = preload("uid://xbuhunh3hna4")
const MAIN = preload("uid://memld2b4qk28")
const MAIN_MENU = preload("uid://dnnwqv3jo1tat")
const MAP_SYSTEM = preload("uid://dqkovpohrgml")
const PASSIVE_ARCHIVE = preload("uid://l3507hyn44f5")
const PASSIVE_BAR_ICON = preload("uid://dldde8yrawlpn")
const PASSSIVE_NOTIFICATION = preload("uid://b1h1nfobkbmxd")
const PICKPOCKET_PARTICLE = preload("uid://gtmo80f6bhex")
const PIGGY = preload("uid://cysrv10cvv8al")
const PLAYER_HEALTH_BAR = preload("uid://vnsb1sd0yalg")
const PLAYER_INFORMATION_DISPLAY = preload("uid://c61s4yrsvak0l")
const POST_GAME_SCREEN = preload("uid://c7uk7pxxcix85")
const PROFILE = preload("uid://dx0fgogfduiq3")
const REWARD_CARD = preload("uid://cwallu4gxlxlx")
const SETTINGS_MENU = preload("uid://ddp7w8jblc6to")
const SHOP_CARD = preload("uid://d327fu0pjg8bq")
const SHOP_KEEPERS_ROOM = preload("uid://cph07oexpeoak")
const SINGLE_DAMAGE_PARTICLE = preload("uid://dgeahqxig4fqa")
const SPARE_CHANGE_PARTICLE = preload("uid://bn1a4qhm1md")
const SPARE_CHANGE_RE_FLIP_PARTICLE = preload("uid://1go5ifrar23k")
const SPEND_DAMAGE_PARTICLE = preload("uid://dmgnoylltbfre")
const SPEND_EFFECT_PARTICLE = preload("uid://m3n67qiuvr7i")
const SPEND_EXPLOSION_PARTICLE = preload("uid://bgfgq2kw3njao")
const SPLASH_SCREEN = preload("uid://cmkt12jtux30")
const STATUS_EFFECT = preload("uid://bmy7mewa8qp5l")
const STATUS_SPELL_ARCHIVE = preload("uid://cxpfdg3bbd11p")
const TAX_EVASION_PARTICLE = preload("uid://da2fh3ch8p4y5")
const THRIFT_DAMAGE_PARTICLE = preload("uid://bvrulyxw02bom")
const THRIFT_PARTICLE = preload("uid://b5x6b2q8jvqa5")
const TUTORIAL = preload("uid://cq10yywodq6bn")
const TUTORIAL_MAIN = preload("uid://vk32ilhncea3")
const VOID_ADDED_PARTICLE = preload("uid://dwpakh5cjl3k5")
const VOID_REMOVED_PARTICLE = preload("uid://b360j7dt7jml1")

const PRELOAD_SCENES = [
	MAP_SCENE,
	SCENE_TRANSITION,
	ARCHIVE,
	ARCHIVES_CARD,
	ASK_TUTORIAL,
	CARD_MANAGER,
	COIN_ADD_PARTICLE,
	COIN_BARRAGE_PARTICLE,
	COIN_DECK,
	COIN_PLAY_PARTICLE,
	COIN_STATUS_EFFECT,
	COIN,
	CREDITS,
	DAMAGE_PARTICLE,
	DEBT_DAMAGE_PARTICLE,
	DEBT_EFFECT_PARTICLE,
	DIALOGUE_BOX,
	ENEMY_HEALTH_BAR,
	ENEMY_INFORMATION_DISPLAY,
	FLOATING_LABEL,
	GAIN_EFFECT_PARTICLE,
	INFLATION_PARTICLE,
	KEEPER_HEALTH_BAR,
	KEEPER_INFORMATION_DISPLAY,
	LOAN_SHARK,
	LOAN_SHARK_BITE,
	MAIN,
	MAIN_MENU,
	MAP_SYSTEM,
	PASSIVE_ARCHIVE,
	PASSIVE_BAR_ICON,
	PASSSIVE_NOTIFICATION,
	PICKPOCKET_PARTICLE,
	PIGGY,
	PLAYER_HEALTH_BAR,
	PLAYER_INFORMATION_DISPLAY,
	POST_GAME_SCREEN,
	PROFILE,
	REWARD_CARD,
	SETTINGS_MENU,
	SHOP_CARD,
	SHOP_KEEPERS_ROOM,
	SINGLE_DAMAGE_PARTICLE,
	SPARE_CHANGE_PARTICLE,
	SPARE_CHANGE_RE_FLIP_PARTICLE,
	SPEND_DAMAGE_PARTICLE,
	SPEND_EFFECT_PARTICLE,
	SPEND_EXPLOSION_PARTICLE,
	SPLASH_SCREEN,
	STATUS_EFFECT,
	STATUS_SPELL_ARCHIVE,
	TAX_EVASION_PARTICLE,
	THRIFT_DAMAGE_PARTICLE,
	THRIFT_PARTICLE,
	TUTORIAL,
	TUTORIAL_MAIN,
	VOID_ADDED_PARTICLE,
	VOID_REMOVED_PARTICLE
]

@onready var sound_manager: Node2D = $SoundManager

#AUDIOS

const GREED = preload("uid://cb0c5agc8yiv2")
const IN_THIS_WORLD_OF_COINS = preload("uid://bkxiylr3twixl")
const KEEPER_S_REST = preload("uid://bnkwnb7pyuorc")
const KEEPER_S_WALTZ = preload("uid://cng12nr5ss88f")
const MAIN_MENU_AUDIO = preload("uid://brcpr6378drlx")
const MISTY_MEADOWS = preload("uid://50o4ytr71q14")
const PASSIVE_SELECTION = preload("uid://cfm3uhjitv627")
const STARSHADE_GROVES = preload("uid://cwvykm00o58p3")

const ALL_IN = preload("uid://lwuew0lbc6d7")
const ALL_IN_STAMP = preload("uid://bo7ip21oxj6eq")
const BATTLE_START = preload("uid://whq12p7mykru")
const BOSS_DEFEATED = preload("uid://pbrojuc0bit1")
const BUTTON = preload("uid://bwn6ufooc31uy")
const CASH_OUT = preload("uid://dm2mpsfe2sli8")
const COIN_ATTACK_PARTICLE = preload("uid://djmpd27qq4nn1")
const COIN_ENDTURN = preload("uid://bfruqunt0uyuj")
const COIN_FLIP = preload("uid://bmscttmxwr782")
const COIN_GAIN = preload("uid://c3v64vs2uqtik")
const COIN_REFLIP = preload("uid://qtxsmuntihe3")
const COIN_RETRIEVE = preload("uid://ddmr4crafefos")
const COIN_UPGRADE = preload("uid://c2sojoo67g7sq")
const CRITICAL = preload("uid://nnwjjtfxt47l")
const DAMAGE_HEAVY = preload("uid://b8us2t16pmggo")
const DAMAGE_LIGHT = preload("uid://ds0jngoq17iij")
const DAMAGE_MODERATE = preload("uid://b2rf2iy046cx2")
const DAZZLE = preload("uid://b3o76gt2qs7pj")
const DEATH = preload("uid://bx1ttmouolx2q")
const DEBT_EFFECT = preload("uid://d18qgeounkatf")
const DEBT = preload("uid://cuwgygacdm7dj")
const DEBTED_ATTACK = preload("uid://ddf31ka4126fv")
const EXTRA_TURN = preload("uid://yp1dxyml8rna")
const GAIN_EFFECT = preload("uid://cr366klr6aivy")
const GAME_OVER_STAMP = preload("uid://b1ajhwrgwjsvo")
const GAME_OVER_WALL_CLOSE = preload("uid://dcogb5vig426m")
const GAME_OVER_WALL = preload("uid://cen1jkl1h44jj")
const GAME_OVER_WRITE = preload("uid://df3805cdw3r4t")
const JAR_O_SAVINGS = preload("uid://cbg3ofct0pu0j")
const PASSIVE_COIN_SNIPE = preload("uid://b0rkegpstg6g4")
const PASSIVE_JAR_O_SAVINGS = preload("uid://ctageqytkfmgg")
const PASSIVE_LOAN_SHARK = preload("uid://6xxw4avoncr8")
const PASSIVE_PASSIVE_INCOME = preload("uid://cl4xnombcshkv")
const PASSIVE_PAYBACK = preload("uid://bbsxs62yhirxa")
const PASSIVE_PAYDOWN = preload("uid://djv3lp0l3aftb")
const PASSIVE_REFUND = preload("uid://bubbbm2g4luge")
const PASSIVE_SPARE_CHANGE = preload("uid://dc4ftba55c4w8")
const PIGGY_AUDIO = preload("uid://hpygqai2v7qw")
const RESERVE_LOCK = preload("uid://4lh30crpkf58")
const SCROLL_HOVERED = preload("uid://dpcddmlbji61k")
const SCROLL_OPEN = preload("uid://ciyhsb2lowwtt")
const SHOPKEEPER_BATTLE_VOICE = preload("uid://cec837paqvvj")
const SHOPKEEPER_VOICE = preload("uid://c86gce7j7tjey")
const SHOP_BELL = preload("uid://1kl4yi6uvnhn")
const SLOW = preload("uid://f5jmno7qyhek")
const SPEND = preload("uid://bvbtrait4prdi")
const SPENDED_ATTACK = preload("uid://lfprp4w7saas")
const SPENDED_FLIP = preload("uid://dgu0hy8kwo343")
const STARSTRUCK = preload("uid://ca4b2ulhiuuoo")
const THRIFT = preload("uid://b34wg18n8eb0t")
const THRIFTED_ATTACK = preload("uid://dtx4a0j6atomh")
const THRIFT_FLAME = preload("uid://kld7c6qpdho7")
const TURN_ENEMY = preload("uid://rncriov1quyx")
const TURN_PLAYER = preload("uid://dk7433d32rg52")
const TURN_REVEAL = preload("uid://boyjppal62qns")
const VICTORY = preload("uid://bu3c18dhngcvw")
const VOIDED = preload("uid://ctvrb7nmqgd06")
const VOID_CLEANSE = preload("uid://bjqr2dvvwifnq")

const PRELOAD_AUDIO = [
	GREED,
	IN_THIS_WORLD_OF_COINS,
	KEEPER_S_REST,
	KEEPER_S_WALTZ,
	MAIN_MENU_AUDIO,
	MISTY_MEADOWS,
	PASSIVE_SELECTION,
	STARSHADE_GROVES,

	ALL_IN,
	ALL_IN_STAMP,
	BATTLE_START,
	BOSS_DEFEATED,
	BUTTON,
	CASH_OUT,
	COIN_ATTACK_PARTICLE,
	COIN_ENDTURN,
	COIN_FLIP,
	COIN_GAIN,
	COIN_REFLIP,
	COIN_RETRIEVE,
	COIN_UPGRADE,
	CRITICAL,
	DAMAGE_HEAVY,
	DAMAGE_LIGHT,
	DAMAGE_MODERATE,
	DAZZLE,
	DEATH,
	DEBT_EFFECT,
	DEBT,
	DEBTED_ATTACK,
	EXTRA_TURN,
	GAIN_EFFECT,
	GAME_OVER_STAMP,
	GAME_OVER_WALL_CLOSE,
	GAME_OVER_WALL,
	GAME_OVER_WRITE,
	JAR_O_SAVINGS,
	PASSIVE_COIN_SNIPE,
	PASSIVE_JAR_O_SAVINGS,
	PASSIVE_LOAN_SHARK,
	PASSIVE_PASSIVE_INCOME,
	PASSIVE_PAYBACK,
	PASSIVE_PAYDOWN,
	PASSIVE_REFUND,
	PASSIVE_SPARE_CHANGE,
	PIGGY_AUDIO,
	RESERVE_LOCK,
	SCROLL_HOVERED,
	SCROLL_OPEN,
	SHOPKEEPER_BATTLE_VOICE,
	SHOPKEEPER_VOICE,
	SHOP_BELL,
	SLOW,
	SPEND,
	SPENDED_ATTACK,
	SPENDED_FLIP,
	STARSTRUCK,
	THRIFT,
	THRIFTED_ATTACK,
	THRIFT_FLAME,
	TURN_ENEMY,
	TURN_PLAYER,
	TURN_REVEAL,
	VICTORY,
	VOIDED,
	VOID_CLEANSE
]

func _ready() -> void:
	start_loading_animation()

	await load_scenes()
	await load_audio()

	loading_animation = false
	LoadingLabel.text = "Ready!"
	
	await get_tree().process_frame

	get_tree().change_scene_to_packed(ASK_TUTORIAL)
	
func load_scenes():
	print("LOADING SCENES")
	for scene in PRELOAD_SCENES:
		if scene is PackedScene:
			var instance = scene.instantiate()

			# Hide it if possible
			if instance is CanvasItem:
				instance.visible = false

			add_child(instance)

			# Give Godot one frame to initialize everything
			await get_tree().process_frame

			instance.queue_free()

	# Wait one more frame to ensure everything is freed
	await get_tree().process_frame
	pass

func load_audio():
	print("LOADING AUDIOS")
	var player := AudioStreamPlayer.new()
	player.volume_db = -80
	add_child(player)

	for stream in PRELOAD_AUDIO:
		player.stream = stream
		player.play()

		# Allow browser to decode the audio
		await get_tree().process_frame

		player.stop()

	player.queue_free()
	

const LOADING_MESSAGES = [
	"Preparing Coin Magic",
	"Teaching Piggy New Tricks",
	"Feeding Loan Shark",
	"Counting the Treasury",
	"Stamping Fresh Coins",
	"Polishing Gold Coins",
	"Opening the Arcane Vault",
	"Shuffling the Coin Deck",
	"Consulting the Shopkeeper",
	"Calculating Compound Interest",
	"Negotiating Trade Routes",
	"Auditing the Tax Collector",
	"Bribing the Aristocrat",
	"Organizing the Reserve",
	"Flipping the First Coin",
	"Gathering Coin Dwarves",
	"Training Apprentice Mages",
	"Awakening the Twilight Sage",
	"Preparing the Arcane Circle",
	"Loading Greed..."
]

var loading_animation := true

func start_loading_animation():
	loading_animation = true

	while loading_animation:
		var message = LOADING_MESSAGES.pick_random()

		for i in range(4):
			if !loading_animation:
				break

			var dots = ""
			for j in range(i):
				dots += "."

			LoadingLabel.text = message + dots

			await get_tree().create_timer(0.3).timeout
