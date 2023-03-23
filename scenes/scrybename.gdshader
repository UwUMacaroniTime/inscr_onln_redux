shader_type canvas_item;

uniform sampler2D displace_tex;
uniform float magnitude:hint_range(0.0, 1.0, 0.1) = 0.4;
uniform float bob_magnitude:hint_range(0.0, 1.0, 0.01) = 0.05;
uniform float bob_speed:hint_range(0.0, 2.0, 0.01) = 0.5;
uniform float pulse_magnitude:hint_range(0.0, 1.0, 0.01) = 0.07;
uniform float pulse_speed:hint_range(0.0, 2.0, 0.01) = 1.0;

void fragment()
{
	vec4 displace_col = texture(displace_tex, UV + vec2(0.0, sin(TIME * bob_speed) * bob_magnitude));
	vec2 coords = vec2(displace_col.b) * magnitude;
	coords.y += sin(TIME * pulse_speed) * pulse_magnitude;
	COLOR = texture(TEXTURE, UV + coords);
}