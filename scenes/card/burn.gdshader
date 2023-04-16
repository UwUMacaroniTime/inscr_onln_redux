shader_type canvas_item;

uniform float clip: hint_range(0.0, 4.0, 0.1) = 0;
uniform sampler2D gradient;
uniform sampler2D noise;
uniform sampler2D screen:hint_screen_texture;

void fragment() {
	COLOR = texture(gradient, vec2(min((texture(noise, UV).x) * clip, 0.99))) * texture(screen, SCREEN_UV);
}
