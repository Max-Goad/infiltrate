shader_type canvas_item;

uniform sampler2D mask_texture;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec4 mask = texture(mask_texture, UV);
	color.a = mask.r;
	COLOR = color;
}
