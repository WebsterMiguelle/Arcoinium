shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 0.8, 0.2, 1.0);
uniform float line_thickness : hint_range(0.0, 10.0) = 4.0;
uniform float pulse_speed : hint_range(0.0, 10.0) = 4.0;
uniform bool is_hovered = false;

// NEW: This artificially shrinks the card slightly to make room for the outline!
uniform float margin : hint_range(0.0, 0.3) = 0.05;

// NEW: A helper function that stops Godot from smearing edge pixels
float get_alpha(sampler2D tex, vec2 uv) {
	// If the shader tries to look outside the image, force it to return invisible
	if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
		return 0.0;
	}
	return texture(tex, uv).a;
}

void fragment() {
	// 1. Scale the UVs to create a fake transparent border
	vec2 uv = (UV - 0.5) * (1.0 + margin) + 0.5;
	
	// 2. Get the color of the card using the new shrunken coordinates
	vec4 color;
	if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
		color = vec4(0.0);
	} else {
		color = texture(TEXTURE, uv);
	}

	// 3. Do the Outline Math
	if (is_hovered) {
		vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
		
		// Use our custom get_alpha() function instead of the default texture()
		float outline = get_alpha(TEXTURE, uv + vec2(-size.x, 0));
		outline += get_alpha(TEXTURE, uv + vec2(0, size.y));
		outline += get_alpha(TEXTURE, uv + vec2(size.x, 0));
		outline += get_alpha(TEXTURE, uv + vec2(0, -size.y));
		outline += get_alpha(TEXTURE, uv + vec2(-size.x, size.y));
		outline += get_alpha(TEXTURE, uv + vec2(size.x, size.y));
		outline += get_alpha(TEXTURE, uv + vec2(-size.x, -size.y));
		outline += get_alpha(TEXTURE, uv + vec2(size.x, -size.y));
		outline = min(outline, 1.0);
		
		// Pulse animation
		float pulse = (sin(TIME * pulse_speed) + 1.0) * 0.5; 
		float final_alpha = outline * (0.4 + (pulse * 0.6));
		
		vec4 outline_col = glow_color;
		outline_col.a *= final_alpha;
		
		// Draw the card OVER the glowing outline
		COLOR = mix(outline_col, color, color.a);
	} else {
		COLOR = color;
	}
}