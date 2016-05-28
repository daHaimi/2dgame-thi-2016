extern float nighttime;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords) {
    // ggf noch shift in bestimmte farbe?
    return color * nighttime;
}
