PLAY STORE PAGE
https://play.google.com/store/apps/details?id=org.godotengine.Goktasi2&pcampaignid=web_share

SAVE & LOAD
add_to_group("save_data")
The _on_GUI_quit funciton in Main scene calls "save_data" function for every "save_data" group member
The save_data function accepts dictionary "data" and string "owner_name" as arguments.
Send this arguments to DataBase.save_data(data, owner_name) function to save data to DataBase.

DataBase.load_data function accpets string "owner_name" as argument. Return a dictionary with saved data from database. If no data found, return empty dictionary.

SUPPLIERS
Supplier/Supplier.gd
ItemDB/Items/Supplier.tscn
Supplier nodes in Main/Game/Supplier to adjust settings on inspector.