shader_type canvas_item;

uniform vec4 inner_color : source_color = vec4(0.78, 0.80, 0.84, 0.0);
uniform vec4 outer_color : source_color = vec4(0.92, 0.94, 0.98, 0.7);
uniform float border_size : hint_range(0.02, 0.4) = 0.12;
uniform float feather : hint_range(0.001, 0.2) = 0.04;
uniform float intensity : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec2 centered_uv = abs(UV - vec2(0.5)) * 2.0;
	float edge_distance = max(centered_uv.x, centered_uv.y);
	float border_mask = smoothstep(1.0 - border_size - feather, 1.0 - border_size, edge_distance);
	float outer_falloff = smoothstep(1.0 - feather, 1.0, edge_distance);
	vec4 gradient = mix(inner_color, outer_color, outer_falloff);
	gradient.a *= border_mask * intensity;
	COLOR = gradient;
}
