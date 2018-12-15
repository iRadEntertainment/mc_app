shader_type canvas_item;

uniform vec2 shader_screen_size = vec2(780.0 , 1200.0); 
uniform float shift = 200.0;

void vertex () {
	float ratio_x = VERTEX.x / shader_screen_size.x;
	float ratio_y = VERTEX.y / shader_screen_size.y;
	float sdd = UV.x;
	VERTEX.y += ratio_x * (0.5-ratio_y)*2.0*shift;
	VERTEX.x -= shift + shift*ratio_x;
}