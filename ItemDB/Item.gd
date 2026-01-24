class_name Item
extends Resource


enum ID {
	BULLET,
	ORE,
	FUEL,
	COIN,
	SUPPLIER_FUEL,
	SUPPLIER_BULLET,
	DETECTOR_ORE,
	ORE_IRON,
	ORE_GOLD,
	ORE_COPPER,
	ORE_SILVER,
	FUEL_T2,
}

enum Type {
	FUEL,
	ORE,
	BULLET,
	TOOL,
	COIN,
	SUPPLIER
}


export (ID) var id
export (Type) var type
export (String) var name
export (String, MULTILINE) var info
export (Texture) var texture
export (PackedScene) var scene
export (int) var value
export (bool) var visible = true
#export (bool) var visible_market = true
#export (bool) var visible_player = true
