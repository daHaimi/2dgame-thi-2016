# Shaders Cheatcheet

## Pixel/Fragment Shader
### laden des Shaders `hueAdjust.glsl`:
```lua
local shader = love.graphics.newShader("shader/hueAdjust.glsl");
```


### setzen der Shader Variable `hue`:
```lua
shader:send("hue", math.random() * 2 * math.pi);
```


### ausführen des Shaders:

```lua
love.graphics.setShader(shader);
```


### `shader/hueAdjust.glsl` Inhalt

#### importieren der `hue` Variable
```glsl
exern float hue;
```


#### Kommentar
```glsl
// http://lolengine.net/blog/2013/07/27/rgb-to-hsv-in-glsl
```


#### Shader interne Funktionsaufrufe

```glsl
vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = c.g < c.b ? vec4(c.bg, K.wz) : vec4(c.gb, K.xy);
    vec4 q = c.r < p.x ? vec4(p.xyw, c.r) : vec4(c.r, p.yzx);

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
```


#### die durch `setShader` aufgerufene Funktion

| variable      | Beschreibung                                  |
| :------------ | :-------------------------------------------- |
| `color`       | Farbe in Form von RGBA                        |
| `texture`     | zu Zeichnendes Bild                           |
| `texturePos`  | relative normalisierte Position zu dem Bild   |
| `screenPos`   | Koordinate des Pixels relativ zum Screen      |

```glsl
vec4 effect(vec4 color, Image texture, vec2 texturePos, vec2 screenPos)
{
    color = Texel(texture, texturePos).rgba;
    float alpha = color.a;
    vec3 hsvcolor = rgb2hsv(color.rgb);
    hsvcolor.x = hue;
    vec3 rgbcolor = hsv2rgb(hsvcolor);
    return vec4(rgbcolor, alpha);
}
```


## vertex Shader

### laden
### Variablen setzen
### ausführen

### call interface

```glsl
vec4 position(mat4 mvp_matrix, vec4 vertex)
{
    return mvp_matrix * vertex;
}
```

