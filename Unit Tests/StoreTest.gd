extends Node

# Testlerin çalışacağı asıl sınıfın adının "Store" olduğunu varsayıyorum.
# Eğer başka bir isimdeyse (örneğin Market), aşağıdaki "Store" yazılarını ona göre değiştir.

func _ready():
	print("--- Satış Sistemi (Sell) Testleri Başlıyor ---")
	
	test_basarili_tam_satis()
	test_elde_olandan_fazla_satma()
	test_degere_sahip_olmayan_esya_satisi()
	
	print("--- Tüm Testler Tamamlandı ---")


# --- TEST YARDIMCI FONKSİYONU ---
func assert_equal(expected, actual, test_name: String):
	if expected == actual:
		print("[BAŞARILI] ", test_name)
	else:
		print("[HATA] ", test_name, " | Beklenen: ", expected, " | Gelen: ", actual)


# --- TEST SENARYOLARI ---

func test_basarili_tam_satis():
	var test_inv = Inventory.new()
	var test_item_id = Item.ID.ORE_BLUE
	var test_item = ItemDB.get_item(test_item_id)
	
	test_inv.add_item(test_item_id, 10)
	test_inv.add_item(Store.id_coin, 500)
	
	# Dinamik beklenen kazanç hesabı
	var birim_kazanc = int(test_item.value * Store.sell_multiplier)
	var beklenen_kazanc = 4 * birim_kazanc
	
	var kalan_miktar = Store.sell(test_item_id, 4, test_inv)
	var son_para = test_inv.get_item_amount(Store.id_coin)
	
	assert_equal(6, kalan_miktar, "Kusursuz Satış: Kalan maden doğru eksildi mi?")
	assert_equal(500 + beklenen_kazanc, son_para, "Kusursuz Satış: Kazanılan para doğru eklendi mi?")


func test_elde_olandan_fazla_satma():
	var test_inv = Inventory.new()
	var test_item_id = Item.ID.ORE_COPPER
	var test_item = ItemDB.get_item(test_item_id)
	
	test_inv.add_item(test_item_id, 3) # Sadece 3 adet var
	test_inv.add_item(Store.id_coin, 0)
	
	# 3 adet için dinamik kazanç hesabı
	var birim_kazanc = int(test_item.value * Store.sell_multiplier)
	var beklenen_kazanc = 3 * birim_kazanc
	
	# 10 adet satmaya çalışıyoruz
	var kalan_miktar = Store.sell(test_item_id, 10, test_inv)
	var son_para = test_inv.get_item_amount(Store.id_coin)
	
	assert_equal(0, kalan_miktar, "Fazla Satış Denemesi: Kalan maden sıfırlandı mı?")
	assert_equal(beklenen_kazanc, son_para, "Fazla Satış Denemesi: Sadece eldeki miktar (3 adet) kadar mı para verildi?")


func test_degere_sahip_olmayan_esya_satisi():
	var test_inv = Inventory.new()
	
	# Test için değeri 0 olan geçici bir eşyayı simüle edelim veya değeri 0 olan bir ID verelim:
	# Eğer veri tabanında değeri 0 olan eşya yoksa, test için geçici bir eşya üretiyoruz:
	var dummy_zero_item = Item.new()
	dummy_zero_item.id = 9999
	dummy_zero_item.value = 0
	ItemDB.items[9999] = dummy_zero_item # Test süresince 0 değerli eşya
	
	test_inv.add_item(9999, 5)
	test_inv.add_item(Store.id_coin, 100)
	
	var kalan_miktar = Store.sell(9999, 2, test_inv)
	var son_para = test_inv.get_item_amount(Store.id_coin)
	
	assert_equal(5, test_inv.get_item_amount(9999), "Değersiz Eşya: Eşya eksilmedi mi?")
	assert_equal(100, son_para, "Değersiz Eşya: Para değişmeden kaldı mı?")
	
	# Test temizliği
	ItemDB.items.erase(9999)
