extern vec2 lightPosition;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords) {

    float distance = lightPosition.x * lightPosition.y;

    return color / distance;

}
