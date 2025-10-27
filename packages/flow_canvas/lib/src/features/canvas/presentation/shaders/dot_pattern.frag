// background_dot.frag
precision highp float;

// =============================================================================
// CONSTANTS
// =============================================================================

const int BLEND_SRC_OVER = 0;
const int BLEND_MULTIPLY = 3;
const int BLEND_SCREEN = 4;
const int BLEND_OVERLAY = 5;

const int TILE_CLAMP = 0;
const int TILE_REPEAT = 1;
const int TILE_MIRROR = 2;

// =============================================================================
// UNIFORMS
// =============================================================================

uniform vec2 u_resolution;
uniform vec4 u_bgColor;
uniform vec4 u_patternColor;
uniform vec2 u_patternParams;        // gap, dotRadius (only 2 params needed!)
uniform vec2 u_patternOffset;
uniform float u_blendMode;

// Gradient Properties
uniform float u_hasGradient;
uniform vec2 u_gradientBegin;
uniform vec2 u_gradientEnd;
uniform vec4 u_gradientColors[4];
uniform float u_gradientStops[4];
uniform float u_gradientColorCount;
uniform float u_tileMode;
uniform mat4 u_inverseTransform;

out vec4 fragColor;

// =============================================================================
// HELPER FUNCTIONS
// =============================================================================

highp vec4 mixStops(highp vec4 color1, highp vec4 color2, highp float stop1, highp float stop2, highp float t) {
    highp float remapped_t = (t - stop1) / (stop2 - stop1);
    return mix(color1, color2, clamp(remapped_t, 0.0, 1.0));
}

highp vec4 applyBlendMode(highp vec4 base, highp vec4 pattern, int blendModeIndex) {
    if (blendModeIndex == BLEND_MULTIPLY) {
        return vec4(base.rgb * pattern.rgb, base.a);
    }
    if (blendModeIndex == BLEND_SCREEN) {
        return vec4(1.0 - (1.0 - base.rgb) * (1.0 - pattern.rgb), base.a);
    }
    if (blendModeIndex == BLEND_OVERLAY) {
        highp vec3 result;
        for (int i = 0; i < 3; i++) {
            result[i] = (base[i] < 0.5) 
                ? 2.0 * base[i] * pattern[i]
                : 1.0 - 2.0 * (1.0 - base[i]) * (1.0 - pattern[i]);
        }
        return vec4(result, base.a);
    }
    return mix(base, pattern, pattern.a);
}

highp vec4 calculateGradient() {
    highp vec4 transformed_fragCoord = u_inverseTransform * vec4(gl_FragCoord.xy, 0.0, 1.0);
    highp vec2 grad_vector = u_gradientEnd - u_gradientBegin;
    highp vec2 frag_vector = transformed_fragCoord.xy - u_gradientBegin;
    highp float t = dot(frag_vector, grad_vector) / dot(grad_vector, grad_vector);
    
    int tileMode = int(u_tileMode + 0.5);
    if (tileMode == TILE_REPEAT) {
        t = fract(t);
    } else if (tileMode == TILE_MIRROR) {
        t = 1.0 - abs(fract(t * 2.0) - 1.0);
    } else {
        t = clamp(t, 0.0, 1.0);
    }
    
    int colorCount = int(u_gradientColorCount + 0.5);
    if (colorCount == 2) {
        return mixStops(u_gradientColors[0], u_gradientColors[1], 
                       u_gradientStops[0], u_gradientStops[1], t);
    }
    if (colorCount == 3) {
        return (t <= u_gradientStops[1])
            ? mixStops(u_gradientColors[0], u_gradientColors[1], 
                      u_gradientStops[0], u_gradientStops[1], t)
            : mixStops(u_gradientColors[1], u_gradientColors[2], 
                      u_gradientStops[1], u_gradientStops[2], t);
    }
    if (t <= u_gradientStops[1]) {
        return mixStops(u_gradientColors[0], u_gradientColors[1], 
                       u_gradientStops[0], u_gradientStops[1], t);
    } else if (t <= u_gradientStops[2]) {
        return mixStops(u_gradientColors[1], u_gradientColors[2], 
                       u_gradientStops[1], u_gradientStops[2], t);
    } else {
        return mixStops(u_gradientColors[2], u_gradientColors[3], 
                       u_gradientStops[2], u_gradientStops[3], t);
    }
}

// =============================================================================
// DOT PATTERN (SPECIALIZED)
// =============================================================================

highp float dotPattern(highp vec2 pos, highp float gap, highp float radius) {
    highp vec2 grid = mod(pos, gap) - gap * 0.5;
    highp float dist = length(grid);
    return smoothstep(radius + 1.0, radius, dist);
}

// =============================================================================
// MAIN SHADER - DOT VARIANT
// =============================================================================

void main() {
    highp vec2 pos = gl_FragCoord.xy + u_patternOffset;
    highp vec4 bgColor = (u_hasGradient > 0.5) ? calculateGradient() : u_bgColor;
    
    // Specialized: only dot pattern, no branching
    highp float gap = u_patternParams.x;
    highp float dotRadius = u_patternParams.y;
    highp float pattern = dotPattern(pos, gap, dotRadius);
    
    if (pattern < 0.001) {
        fragColor = bgColor;
        return;
    }
    
    highp vec4 patternColorWithAlpha = vec4(u_patternColor.rgb, u_patternColor.a * pattern);
    int blendMode = int(u_blendMode + 0.5);
    fragColor = applyBlendMode(bgColor, patternColorWithAlpha, blendMode);
}
