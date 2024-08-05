extends Control

var html_code = "

<span>As melhores ofertas na sua mão!</span>
<span >Aqui no KANGURU você encontra as melhores ofertas mais próximas de você, sem sair de casa.</span>
</div><div>
<span>Mega ofertão</span>
<span>50% off</span>
"
var css_code = "
  width: 294px;
  color: rgba(75,87,104,1);
  position: absolute;
  top: 583px;
  left: 48px;
  font-size: 14px;
  opacity: 1;
  text-align: center;
"

func _ready():
	
	'load_html_css_files(caminho_html, caminho_css)'
	parse_html_css()
	
'func load_html_css_files(html_path, css_path):
	var file = caminho.new()
	if file.file_exists(html_path):
		file.open(html_path, caminho.READ)
		html_code = file.get_as_text()
		file.close()
	if file.file_exists(css_path):
		file.open(css_path, caminho.READ)
		css_code = file.get_as_text()
		file.close()'

func parse_html_css():
	var html_tree = parse_html(html_code)
	var css_styles = parse_css(css_code)
	create_ui_nodes(html_tree, css_styles)

func parse_html(html):
	# Função simples para analisar HTML
	var tree = []
	var lines = html.split("\n")
	for line in lines:
		if line.begins_with("<p>"):
			tree.append({"tag": "p", "content": line.strip_tags()})
		elif line.begins_with("<div>"):
			tree.append({"tag": "div", "content": line.strip_tags()})
		elif line.begins_with("<h1>"):
			tree.append({"tag": "h1", "content": line.strip_tags()})
		elif line.begins_with("<h2>"):
			tree.append({"tag": "h2", "content": line.strip_tags()})
		elif line.begins_with("<span>"):
			tree.append({"tag": "span", "content": line.strip_tags()})
		
		return tree

func parse_css(css):
	# Função simples para analisar CSS
	var styles = {}
	var lines = css.split("\n")
	for line in lines:
		var parts = line.split(":")
		if parts.size() == 2:
			styles[parts[0].strip_edges()] = parts[1].strip_edges().strip(";")
			return styles

func create_ui_nodes(html_tree, css_styles):
	for element in html_tree:
		var node = null
		if element["tag"] == "p":
			node = Label.new()
			node.text = element["content"]
		elif element["tag"] == "div":
			node = Panel.new()
		elif element["tag"] == "h1":
			node = Label.new()
			node.text = element["content"]
			node.add_font_override("font", load("res://path_to_your_h1_font.tres"))
		elif element["tag"] == "h2":
			node = Label.new()
			node.text = element["content"]
			node.add_font_override("font", load("res://path_to_your_h2_font.tres"))
		elif element["tag"] == "span":
			node = Label.new()
			node.text = element["content"]
		if node != null:
			apply_styles(node, css_styles)
			add_child(node)

func apply_styles(node, styles):

	# Função para aplicar estilos CSS
	for key in styles.keys():
		if key == "color":
			node.add_color_override("font_color", Color(styles[key]))
		elif key == "background-color":
			node.add_color_override("panel", Color(styles[key]))
		elif key == "font-size":
			var font = FontFile.new()
			font.size = int(styles[key])
			node.add_font_override("font", font)
		elif key == "width":
			node.rect_min_size.x = int(styles[key])
		elif key == "height":
			node.rect_min_size.y = int(styles[key])
		elif key == "margin":
			
			var margins = styles[key].split(" ")
			
			if margins.size() == 4:
				node.margin_top = int(margins[0])
				node.margin_right = int(margins[1])
				node.margin_bottom = int(margins[2])
				node.margin_left = int(margins[3])
		elif key == "padding":
			var paddings = styles[key].split(" ")
			if paddings.size() == 4:
					node.add_constant_override("margin_top", int(paddings[0]))
					node.add_constant_override("margin_right", int(paddings[1]))
					node.add_constant_override("margin_bottom", int(paddings[2]))
					node.add_constant_override("margin_left", int(paddings[3]))
		elif key == "position":
			if styles[key] == "absolute":
				node.rect_position = Vector2(int(styles.get("left", "0")), int(styles.get("top", "0")))
		elif key == "top":
			node.rect_min_size.y = int(styles[key])
		elif key == "left":
			node.rect_min_size.x = int(styles[key])
		elif key == "right":
			node.rect_min_size.x = int(styles[key])
		elif key == "bottom":
			node.rect_min_size.y = int(styles[key])
		
