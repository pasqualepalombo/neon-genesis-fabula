extends Node
#TODO
# qui creo un dizionario di tutti gli item del gioco con nome che punta a
# quantita, e coordinate x-y del item.png (in modo da poter sapere quale region
# caricare per quell'oggetto. 
# creo un secondo dizionario che quando prendo un oggetto, se non c'è lo mette dentro
# se c'è già incrementa il totale. 
# SONO ARRIVATO FIN QUI
# Questo è da salvare in savegame. Questo è da caricare in loadgame.
# L'inventario che ha 21 panel(3x7) carica dalla posizione 0 a n tutte le coincidenze con il secondo
# dizionario ottenendo cosi anche le coordinate della region
# poi dovrò farlo navigabile, e perciò spostandomi (contando che la matrice è fissa 3x7) allora usero quel numero
# per ottenere le info in modo contrario tramite il nome in ricerca al dizionario e con questo
# dovrei anche risolvere il fatto di poterlo usare (se serve)

var all_items = {
	"health_potion" : [2,0,0], "mana_potion" : [3,16,0], 
	"mom_medicine" : [0, 48, 0], "packed_meal" : [0,64,0]
	}

var temporary_items = {}


func add_to_all_items_dictionary(key, value, x, y):
	if all_items.has(key):
		all_items[str(key)] = [all_items[str(key)][0]+1,x,y]
	else:
		all_items[str(key)] = [value,x,y]


func add_to_temporary_items_dictionary(key, value, x, y):
	if temporary_items.has(key):
		temporary_items[str(key)] = [temporary_items[str(key)][0]+1,x,y]
	else:
		temporary_items[str(key)] = [value,x,y]


func _ready():
	print(all_items)
	print (all_items.keys())
	print(all_items.values())
	print (all_items.health_potion)
	print (all_items.health_potion[0])
	pass
