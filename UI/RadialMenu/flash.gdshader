shader_type canvas_item;

uniform float flash_percent:hint_range(0.,1.) = 0.8;
uniform vec3 flash_colour:source_color = vec3(1.);
uniform float flash_duration = 0.5;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR.rgb = mix(texture(TEXTURE,UV).rgb,flash_colour*flash_percent,abs(sin(TIME*(1./flash_duration))));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
