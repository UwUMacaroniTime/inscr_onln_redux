shader_type canvas_item;

uniform sampler2D palette;

void fragment() {
	vec4 tex_col = texture(TEXTURE, UV);
	vec4 palette_col = texture(palette, vec2(1.0 - tex_col.x, 1.0 - tex_col.y));
	palette_col.a *= tex_col.a;
	COLOR = palette_col;
}
