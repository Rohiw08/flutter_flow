precision highp float;

// UNIFORMS

// Canvas and Pattern Details
uniform vec2 u_resolution;      // (0,1)
uniform vec4 u_bgColor;         // (2..5)
uniform vec4 u_patternColor;    // (6..9)
uniform vec4 u_params;          // (10..13) gap, lineWidth, dotRadius, crossSize
uniform float u_variant;        // (14)
uniform vec2 u_patternOffset;   // (15,16)
uniform float u_blendMode;      // (17)

// Gradient Properties
uniform float u_hasGradient;            // (18)
uniform vec2 u_gradientBegin;           // (19,20)
uniform vec2 u_gradientEnd;             // (21,22)
uniform vec4 u_gradientColors[4];       // (23..38)
uniform float u_gradientStops[4];       // (39..42)
uniform float u_gradientColorCount;     // (43)
uniform float u_tileMode;               // (44)
uniform mat4 u_transform;               // (45..60)

out vec4 fragColor;

// HELPER FUNCTIONS

// Manual 4x4 matrix inverse implementation
mat4 matrixInverse(mat4 m) {
    float a00 = m[0][0], a01 = m[0][1], a02 = m[0][2], a03 = m[0][3];
    float a10 = m[1][0], a11 = m[1][1], a12 = m[1][2], a13 = m[1][3];
    float a20 = m[2][0], a21 = m[2][1], a22 = m[2][2], a23 = m[2][3];
    float a30 = m[3][0], a31 = m[3][1], a32 = m[3][2], a33 = m[3][3];

    float b00 = a00 * a11 - a01 * a10;
    float b01 = a00 * a12 - a02 * a10;
    float b02 = a00 * a13 - a03 * a10;
    float b03 = a01 * a12 - a02 * a11;
    float b04 = a01 * a13 - a03 * a11;
    float b05 = a02 * a13 - a03 * a12;
    float b06 = a20 * a31 - a21 * a30;
    float b07 = a20 * a32 - a22 * a30;
    float b08 = a20 * a33 - a23 * a30;
    float b09 = a21 * a32 - a22 * a31;
    float b10 = a21 * a33 - a23 * a31;
    float b11 = a22 * a33 - a23 * a32;

    float det = b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06;

    return mat4(
        a11 * b11 - a12 * b10 + a13 * b09,
        a02 * b10 - a01 * b11 - a03 * b09,
        a31 * b05 - a32 * b04 + a33 * b03,
        a22 * b04 - a21 * b05 - a23 * b03,
        a12 * b08 - a10 * b11 - a13 * b07,
        a00 * b11 - a02 * b08 + a03 * b07,
        a32 * b02 - a30 * b05 - a33 * b01,
        a20 * b05 - a22 * b02 + a23 * b01,
        a10 * b10 - a11 * b08 + a13 * b06,
        a01 * b08 - a00 * b10 - a03 * b06,
        a30 * b04 - a31 * b02 + a33 * b00,
        a21 * b02 - a20 * b04 - a23 * b00,
        a11 * b07 - a10 * b09 - a12 * b06,
        a00 * b09 - a01 * b07 + a02 * b06,
        a31 * b01 - a30 * b03 - a32 * b00,
        a20 * b03 - a21 * b01 + a22 * b00) / det;
}

// Helper for smooth mixing between two colors based on their stops
vec4 mixStops(vec4 color1, vec4 color2, float stop1, float stop2, float t) {
    // Remap t from the global [0,1] range to the local [stop1, stop2] range
    float remapped_t = (t - stop1) / (stop2 - stop1);
    return mix(color1, color2, clamp(remapped_t, 0.0, 1.0));
}

// PATTERN FUNCTIONS

float dotPattern(vec2 pos, float gap, float radius) {
    vec2 grid = mod(pos, gap) - gap * 0.5;
    float dist = length(grid);
    return smoothstep(radius + 1.0, radius, dist);
}

float gridPattern(vec2 pos, float gap, float lineWidth) {
    vec2 grid = abs(mod(pos, gap) - gap * 0.5);
    float lineX = step(grid.x, lineWidth);
    float lineY = step(grid.y, lineWidth);
    return clamp(lineX + lineY, 0.0, 1.0);
}

float crossPattern(vec2 pos, float gap, float lineWidth, float crossSize) {
    vec2 grid = mod(pos, gap) - gap * 0.5;
    float horizontalBar = smoothstep(lineWidth + 0.5, lineWidth - 0.5, abs(grid.y)) * smoothstep(crossSize + 0.5, crossSize - 0.5, abs(grid.x));
    float verticalBar = smoothstep(lineWidth + 0.5, lineWidth - 0.5, abs(grid.x)) * smoothstep(crossSize + 0.5, crossSize - 0.5, abs(grid.y));
    return clamp(horizontalBar + verticalBar, 0.0, 1.0);
}

// BLEND FUNCTIONS

vec4 applyBlendMode(vec4 base, vec4 pattern, float blendModeIndex) {
    int mode = int(blendModeIndex + 0.5);
    
    if (mode == 3) { // multiply
        return vec4(base.rgb * pattern.rgb, base.a);
    } else if (mode == 4) { // screen
        return vec4(1.0 - (1.0 - base.rgb) * (1.0 - pattern.rgb), base.a);
    } else if (mode == 5) { // overlay
        vec3 result;
        for (int i = 0; i < 3; i++) {
            if (base[i] < 0.5) {
                result[i] = 2.0 * base[i] * pattern[i];
            } else {
                result[i] = 1.0 - 2.0 * (1.0 - base[i]) * (1.0 - pattern[i]);
            }
        }
        return vec4(result, base.a);
    }
    
    // Default to srcOver (mode 0)
    return mix(base, pattern, pattern.a);
}


// MAIN FUNCTION

void main() {
    vec2 pos = gl_FragCoord.xy + u_patternOffset;
    
    // Unpack parameters
    float gap = u_params.x;
    float lineWidth = u_params.y;
    float dotRadius = u_params.z;
    float crossSize = u_params.w;
    int variant = int(u_variant + 0.5);
    
    // Determine background color (solid or gradient)
    vec4 bgColor = u_bgColor;
    if (u_hasGradient > 0.5) {
        // Apply the INVERSE transform to the fragment coordinate to handle rotation/scaling
        vec4 transformed_fragCoord = matrixInverse(u_transform) * vec4(gl_FragCoord.xy, 0.0, 1.0);
    
        vec2 grad_vector = u_gradientEnd - u_gradientBegin;
        vec2 frag_vector = transformed_fragCoord.xy - u_gradientBegin;
        
        // Project the fragment's vector onto the gradient's vector to find the interpolation factor 't'
        float t = dot(frag_vector, grad_vector) / dot(grad_vector, grad_vector);

        // Apply TileMode logic
        int tileMode = int(u_tileMode + 0.5);
        if (tileMode == 1) { // Repeated
            t = fract(t);
        } else if (tileMode == 2) { // Mirror
            t = 1.0 - abs(fract(t * 2.0) - 1.0);
        } else { // Clamp (default)
            t = clamp(t, 0.0, 1.0);
        }
        
        int colorCount = int(u_gradientColorCount + 0.5);
        
        // Mix colors based on their specified stops
        if (colorCount == 2) {
            bgColor = mixStops(u_gradientColors[0], u_gradientColors[1], u_gradientStops[0], u_gradientStops[1], t);
        } else if (colorCount == 3) {
            if (t <= u_gradientStops[1]) {
                bgColor = mixStops(u_gradientColors[0], u_gradientColors[1], u_gradientStops[0], u_gradientStops[1], t);
            } else {
                bgColor = mixStops(u_gradientColors[1], u_gradientColors[2], u_gradientStops[1], u_gradientStops[2], t);
            }
        } else if (colorCount >= 4) {
             if (t <= u_gradientStops[1]) {
                bgColor = mixStops(u_gradientColors[0], u_gradientColors[1], u_gradientStops[0], u_gradientStops[1], t);
            } else if (t <= u_gradientStops[2]) {
                bgColor = mixStops(u_gradientColors[1], u_gradientColors[2], u_gradientStops[1], u_gradientStops[2], t);
            } else {
                bgColor = mixStops(u_gradientColors[2], u_gradientColors[3], u_gradientStops[2], u_gradientStops[3], t);
            }
        }
    }
    
    // Select and calculate the geometric pattern
    float pattern = 0.0;
    if (variant == 0) {
        pattern = dotPattern(pos, gap, dotRadius);
    } else if (variant == 1) {
        pattern = gridPattern(pos, gap, lineWidth);
    } else if (variant == 2) {
        pattern = crossPattern(pos, gap, lineWidth, crossSize);
    }
    
    // Combine the background color and the pattern using the specified blend mode
    vec4 patternColorWithAlpha = vec4(u_patternColor.rgb, u_patternColor.a * pattern);
    fragColor = applyBlendMode(bgColor, patternColorWithAlpha, u_blendMode);
}