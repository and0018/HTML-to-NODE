@tool
extends EditorPlugin

var font 
var html_code : String
var css_code : String

func _enable_plugin():
	
	var file_html = FileAccess.open("res://index.txt", FileAccess.READ)
	var file_css = FileAccess.open("res://css/main.txt", FileAccess.READ)
	self.html_code = file_html.get_as_text()
	self.css_code = file_css.get_as_text()
	print("HTML Code: ", self.html_code)
	parse_html_css()
	print(file_html.get_class())
	
func parse_html_css():
	
	var html_tree = parse_html(html_code)
	var css_styles = parse_css(css_code)
	print("HTML Tree: ", html_tree)
	print("CSS Styles: ", css_styles)
	create_ui_nodes(html_tree, css_styles)
	
func parse_html(html):
	
	var tree = []
	var lines = html.split("\n")
	for line in lines:
		line = line.strip_edges()
		print("Processing line: ", line)  # Debug para cada linha
		if line.begins_with("<p"):
			tree.append({"tag": "p", "content":  "Found P"})
		elif line.begins_with("<div"):
			tree.append({"tag": "div", "content": "Found DIV"})
		elif line.begins_with("<h1"):
			tree.append({"tag": "h1", "content": "Found H1"})
		elif line.begins_with("<h2"):
			tree.append({"tag": "h2", "content": "Found H2"})
		elif line.begins_with("<span"):
			tree.append({"tag": "span", "content":  "Found SPAN"})
	print("Parsed HTML Tree: ", tree)
	return tree
	
func extract_content(tag_line):
	
	var start_index = tag_line.find(">") + 1  # Encontra o fim da tag de abertura
	var end_index = tag_line.rfind("<")  # Encontra o início da tag de fechamento
	if start_index != -1 and end_index != -1:
		return tag_line.substr(start_index, end_index - start_index).strip_edges()
	return ""
	
func strip_tags(text):
	
	var regex = RegEx.new()
	regex.compile("<[^>]*>")
	return regex.sub(text, "", true)
	
func parse_css(css):
	
	var styles = {}
	var lines = css.split("\n")
	for line in lines:
		var parts = line.split(":")
		if parts.size() == 2:
			styles[parts[0].strip_edges()] = parts[1].strip_edges().strip_edges()
		print("FUNC CSS OK")
	print("Parsed CSS Styles: ", styles)
	return styles
	
func create_ui_nodes(html_tree, css_styles):
	
	var root = Node.new()
	root.name = "Root"
	var nodes_created = false# Obtém a raiz da cena atualmente editada

	for element in html_tree:
		var node = null
		if element["tag"] == "p":
			node = Label.new()
			node.text = element["content"]
		elif element["tag"] == "div":
			node = Panel.new()
		elif element["tag"] == "h1":
			node = Label.new()
			#node.text = element["content"]
			#node.add_font_override("font", load("res://path_to_your_h1_font.tres"))
		elif element["tag"] == "h2":
			node = Label.new()
			#node.text = element["content"]
			#node.add_font_override("font", load("res://path_to_your_h2_font.tres"))
		elif element["tag"] == "span":
			node = Label.new()
			node.text = element["content"]
		if node != null:
			apply_styles(node, css_styles)
			root.add_child(node)
			print("Node created: ", node)
	if nodes_created:
		var scene = PackedScene.new()
		scene.pack(root)
		var scene_path = "res://index.tscn"
		var error = ResourceSaver.save(scene_path, scene)
		if error == OK:
			print("Scene saved successfully.")
		else:
			print("Error saving scene: ", error)
	else:
		print("No nodes were created, scene not saved.")
		
func apply_styles(node, styles):
	
	if styles == null:
		print("No styles to apply")
		return
	for key in styles.keys():
		match key:
			"color":
				var color_str = styles[key].strip_edges().replace(";", "")
				if color_str.begins_with("#") and color_str.length() == 7:
					var r = int("0x" + color_str.substr(1, 2))
					var g = int("0x" + color_str.substr(3, 2))
					var b = int("0x" + color_str.substr(5, 2))
					node.modulate = Color8(r, g, b)
			"background-color":
				var bg_color_str = styles[key].strip_edges().replace(";", "")
				if bg_color_str.begins_with("#") and bg_color_str.length() == 7:
					var r = int("0x" +  bg_color_str.substr(1, 2))
					var g = int("0x" +  bg_color_str.substr(3, 2))
					var b = int("0x" +  bg_color_str.substr(5, 2))
					node.modulate = Color8(r, g, b)
			"width":
				node.rect_min_size.x = int(styles[key].strip_edges().replace("px;", ""))
			"height":
				node.rect_min_size.y = int(styles[key].strip_edges().replace("px;", ""))
			"margin":
				var margins = styles[key].strip_edges().replace("px;", "").split(" ")
				if margins.size() == 4:
					node.margin_top = int(margins[0])
					node.margin_right = int(margins[1])
					node.margin_bottom = int(margins[2])
					node.margin_left = int(margins[3])
			"padding":
				var paddings = styles[key].strip_edges().replace("px;", "").split(" ")
				if paddings.size() == 4:
					node.add_constant_override("margin_right", int(paddings[1]))
					node.add_constant_override("margin_bottom", int(paddings[2]))
					node.add_constant_override("margin_left", int(paddings[3]))
			"position":
				if styles[key] == "absolute":
					node.rect_position = Vector2(int(styles.get("left", "0")), int(styles.get("top", "0")))
			"top":
				node.rect_min_size.y = int(styles[key].strip_edges().replace("px;", ""))
			"left":
				node.rect_min_size.x = int(styles[key].strip_edges().replace("px;", ""))
			"right":
				node.rect_min_size.x = int(styles[key].strip_edges().replace("px;", ""))
			"bottom":
				node.rect_min_size.y = int(styles[key].strip_edges().replace("px;", ""))
	print("Styles applied to node: ", node)
