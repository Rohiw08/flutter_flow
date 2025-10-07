precision highp float;

uniform vec2 u_resolution;      // (0,1)
uniform vec4 u_bgColor;         // (2..5)
uniform vec4 u_patternColor;    // (6..9)
uniform vec4 u_params;          // (10..13) gap, lineWidth, dotRadius, crossSize
uniform float u_variant;        // (14)
uniform vec2 u_patternOffset;   // (15,16)
uniform float u_blendMode;      // (17)
uniform float u_hasGradient;    // (18)
uniform vec4 u_gradientColors[4]; // (19..34) Up to 4 gradient colors
uniform float u_gradientColorCount; // (35)

out vec4 fragColor;

// Pattern functions
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
    
    // Use smoothstep for anti-aliasing to prevent white artifacts
    float horizontalBar = smoothstep(lineWidth + 0.5, lineWidth - 0.5, abs(grid.y)) * 
                         smoothstep(crossSize + 0.5, crossSize - 0.5, abs(grid.x));
    float verticalBar = smoothstep(lineWidth + 0.5, lineWidth - 0.5, abs(grid.x)) * 
                       smoothstep(crossSize + 0.5, crossSize - 0.5, abs(grid.y));
    
    return clamp(horizontalBar + verticalBar, 0.0, 1.0);
}

// Blend mode functions
vec4 applyBlendMode(vec4 base, vec4 pattern, float blendModeIndex) {
    int mode = int(blendModeIndex + 0.5);
    
    if (mode == 0) { // srcOver (default)
        return mix(base, pattern, pattern.a);
    } else if (mode == 3) { // multiply
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
    
    // Default to srcOver
    return mix(base, pattern, pattern.a);
}

void main() {
    vec2 pos = gl_FragCoord.xy + u_patternOffset;
    
    // Unpack parameters
    float gap = u_params.x;
    float lineWidth = u_params.y;
    float dotRadius = u_params.z;
    float crossSize = u_params.w;
    int variant = int(u_variant + 0.5);
    
    // Determine background color (gradient or solid)
    vec4 bgColor = u_bgColor;
    if (u_hasGradient > 0.5) {
        // Linear gradient from top to bottom
        float t = gl_FragCoord.y / u_resolution.y;
        int colorCount = int(u_gradientColorCount + 0.5);
        
        if (colorCount == 2) {
            bgColor = mix(u_gradientColors[0], u_gradientColors[1], t);
        } else if (colorCount == 3) {
            if (t < 0.5) {
                bgColor = mix(u_gradientColors[0], u_gradientColors[1], t * 2.0);
            } else {
                bgColor = mix(u_gradientColors[1], u_gradientColors[2], (t - 0.5) * 2.0);
            }
        } else if (colorCount >= 4) {
            if (t < 0.33) {
                bgColor = mix(u_gradientColors[0], u_gradientColors[1], t * 3.0);
            } else if (t < 0.67) {
                bgColor = mix(u_gradientColors[1], u_gradientColors[2], (t - 0.33) * 3.0);
            } else {
                bgColor = mix(u_gradientColors[2], u_gradientColors[3], (t - 0.67) * 3.0);
            }
        }
    }
    
    // Pattern selection
    float pattern = 0.0;
    if (variant == 0) {
        pattern = dotPattern(pos, gap, dotRadius);
    } else if (variant == 1) {
        pattern = gridPattern(pos, gap, lineWidth);
    } else if (variant == 2) {
        pattern = crossPattern(pos, gap, lineWidth, crossSize);
    }
    
    // Apply pattern with blend mode
    vec4 patternColor = vec4(u_patternColor.rgb, u_patternColor.a * pattern);
    fragColor = applyBlendMode(bgColor, patternColor, u_blendMode);
}