shader_type canvas_item;

// Our gradient texture.
uniform sampler2D colormap : hint_black;

uniform vec2 noise_minmax = vec2(0.0, 1.0);

void fragment() {
	// Using `noise_minmax`, we normalize our `noise` variable's range.
	float noise = (texture(TEXTURE, UV).r - noise_minmax.x) / (noise_minmax.y - noise_minmax.x);
	vec2 uv_noise = vec2(noise, 0);
	COLOR = texture(colormap, uv_noise);
}