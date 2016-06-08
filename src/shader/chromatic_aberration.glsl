extern vec2 screen;
extern vec2 redStrength;
extern vec2 greenStrength;
extern vec2 blueStrength;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords) {
	vec2 pSize = vec2(1.0 / screen.x, 1.0 / screen.y);
	float colRed = Texel(texture, vec2(texture_coords.x + pSize.x * redStrength.x, texture_coords.y - pSize.y * redStrength.y)).r;
	float colGreen = Texel(texture, vec2(texture_coords.x + pSize.x * greenStrength.x, texture_coords.y - pSize.y * greenStrength.y)).g;
	float colBlue = Texel(texture, vec2(texture_coords.x + pSize.x * blueStrength.x, texture_coords.y - pSize.y * blueStrength.y)).b;

	return vec4(colRed, colGreen, colBlue, 1.0);
}
