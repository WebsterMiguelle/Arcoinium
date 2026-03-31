shader_type canvas_item;

// 1.05 is fully open (clear screen). 0.0 is fully closed (black screen).
uniform float circle_size : hint_range(0.0, 1.05) = 1.05;
// Controls how blurry or sharp the edge of the circle is
uniform float blur : hint_range(0.0, 1.0) = 0.2; 

void fragment() {
	// Get the distance from the center of the screen
	float d = distance(UV, vec2(0.5, 0.5));
	
	// Calculate the edge of the circle
	float alpha = smoothstep(circle_size - blur, circle_size, d);
	
	// Draw it black, using the calculated alpha for the hole
	COLOR = vec4(0.0, 0.0, 0.0, alpha);
}