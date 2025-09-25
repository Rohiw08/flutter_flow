precision highp float;

// Simplified uniforms - no matrix needed
uniform vec2 u_resolution;     // (0,1)
uniform vec4 u_bgColor;        // (2..5)
uniform vec4 u_patternColor;   // (6..9)
uniform vec4 u_params;         // (10..13) gap, lineWidth, dotRadius, crossSize
uniform float u_variant;       // (14) variant

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
    float lineX = step(abs(grid.x), lineWidth) * step(abs(grid.y), crossSize);
    float lineY = step(abs(grid.y), lineWidth) * step(abs(grid.x), crossSize);
    return lineX + lineY;
}

void main() {
    // Use fragment coordinates directly - no transformation
    vec2 pos = gl_FragCoord.xy;
    
    // Unpack parameters
    float gap = u_params.x;
    float lineWidth = u_params.y;
    float dotRadius = u_params.z;
    float crossSize = u_params.w;
    int variant = int(u_variant + 0.5);
    
    // Pattern selection
    float pattern = 0.0;
    if (variant == 0) {
        pattern = dotPattern(pos, gap, dotRadius);
    } else if (variant == 1) {
        pattern = gridPattern(pos, gap, lineWidth);
    } else if (variant == 2) {
        pattern = crossPattern(pos, gap, lineWidth, crossSize);
    }
    
    // Mix colors
    fragColor = mix(u_bgColor, u_patternColor, pattern);
}