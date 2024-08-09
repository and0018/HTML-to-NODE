extends Object


func _ready():
	var nova_cena = PackedScene.new()
	var root_node = Node.new()
	nova_cena.pack(root_node)
	var caminho = "res://Html.tscn"
	ResourceSaver.save(caminho, nova_cena)
	print("Cena criada em: " + caminho)
