shader_type canvas_item;

uniform float alpha_step = .5;
uniform sampler2D gradient;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float average_luminocity = (COLOR.r + COLOR.g + COLOR.b + COLOR.a) * .333;
	vec4 color = texture(gradient, vec2(average_luminocity, 0));
	
	COLOR = vec4(color.rgb, step(alpha_step, COLOR.a));
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
