
local globals = {
	BACK_COL = {141/255, 75/255, 14/255},
	TILE_COL = {124/255, 149/255, 61/255},
	BACK_COL_EDITOR = {1.2*10/255, 1.2*84/255, 1.2*156/255},
	
	HOVER_HIGHLIGHT = {240/255, 179/255, 86/255},
	
	PUSH_BUTTON_BORDER = {61/255, 149/255, 124/255},
	BUTTON_HIGHLIGHT = {198/255, 206/255, 105/255},
	BUTTON_BACK = {92/255, 185/255, 175/255},
	
	HINT_BACK = {198/255, 206/255, 105/255},
	HINT_OUTLINE = {74/255, 91/255, 32/255},
	
	PANEL_COL = {86/255, 165/255, 183/255},
	PANEL_BORDER_COL = {0/255, 91/255, 170/255},
	
	OUTLINE_COL = {0/255, 94/255, 182/255},
	OUTLINE_DISABLE_COL = {82/255, 105/255, 124/255},
	OUTLINE_FLASH_COL = {45/255,48/255,61/255},
	OUTLINE_HIGHLIGHT_COL = {94/255, 120/255, 142/255},
	AFFINITY_COLOR = {0, 0, 0},
	
	BUTTON_COL = {76/255, 156/255, 185/255},
	BUTTON_DISABLE_COL = {180/255, 225/255, 230/255},
	BUTTON_FLASH_COL = {143/255, 151/255, 191/25},
	BUTTON_HIGHLIGHT_COL = {201/255, 240/255, 252/255},
	
	TEXT_DISABLE_COL    = {143/255, 151/255, 191/255},
	TEXT_FLASH_COL      = {0.73, 0.73, 0.75},
	TEXT_HIGHLIGHT_COL  = {9/255, 11/255, 17/255},
	TEXT_COL            = {9/255, 11/255, 17/255},
	FLOATING_TEXT_COL   = {0.95,0.95,0.9},
	
	BUTTON_FLASH_PERIOD = 0.8,
	
	DEPTHS = {
		120,
		350,
		650,
		1000,
		1600,
		2200,
		3600,
		5100,
		6000,
	},
	DEPTH_TEXT = {
		[8] = "New chassis unlocked\n(Almost there!)",
		[9] = "You found the treasure. Thanks for playing!",
	},
	
	NO_DRIVE_TIME = 0.85,
	TURN_MULT = 1500,
	GRAVITY = 520,
	CAMERA_SCALE = 1600,
	CAMERA_SCROLL_SPEED = 0.12,
	CAMERA_SPEED = 1.8,
	SPEED_ZOOM_SCALE = false,
	MIN_CAMERA_RATIO = 14/9,
	
	SAVE_ORDER = {
		"waterline", "playerSpawn", "text",
		"pickups", "polygons", "circles", "doodads",
	},
	SAVE_INLINE = {"pos", "playerSpawn", "points"},
	INIT_LEVEL = "mainLevel",
	
	DEPTH_SCALE = 8,
	
	
	
	DRAW_TERRAIN_IN_DEBUG = true,
	
	
	
	
	
	
	UI_WIDTH = 1920,
	UI_HEIGHT = 1080,
	
	
	
	MASTER_VOLUME = 0.75,
	MUSIC_VOLUME = 0.0001,
	DEFAULT_MUSIC_DURATION = 174.69,
	CROSSFADE_TIME = 0,
	
	PHYSICS_SCALE = 300,
	LINE_SPACING = 36,
	INC_OFFSET = -15,
	
	WORLD_WIDTH = 2000,
	WORLD_HEIGHT = 2000,
	
	GRAVITY_MULT = 900,
	SPEED_LIMIT = 4500,
	
	MOUSE_SCROLL_MULT = 0,
	KEYBOARD_SCROLL_MULT = 1.4,
	
	MOUSE_EDGE = 8,
	MOUSE_SCROLL = 1200,
	CAMERA_BOUND = 1600,
}

return globals