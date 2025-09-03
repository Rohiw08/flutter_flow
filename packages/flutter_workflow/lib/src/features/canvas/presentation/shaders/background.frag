precision highp float;

// Packed uniforms
uniform vec2 u_resolution;     // (0,1)
uniform mat4 u_matrix;         // (2..17) 
uniform vec4 u_bgColor;        // (18..21)
uniform vec4 u_patternColor;   // (22..25)
uniform vec4 u_params;         // (26..29) gap, lineWidth, dotRadius, crossSize
uniform vec2 u_config;         // (30,31) opacity, variant

out vec4 fragColor;

// Branchless pattern functions
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
    // Transform position once
    vec2 pos = (u_matrix * vec4(gl_FragCoord.xy, 0.0, 1.0)).xy;
    
    // Unpack parameters
    float gap = u_params.x;
    float lineWidth = u_params.y;
    float dotRadius = u_params.z;
    float crossSize = u_params.w;
    float opacity = u_config.x;
    int variant = int(u_config.y + 0.5);
    
    // Branchless pattern selection (if you want single shader)
    float dotMask = float(variant == 0);
    float gridMask = float(variant == 1);
    float crossMask = float(variant == 2);
    
    float pattern = dotMask * dotPattern(pos, gap, dotRadius) +
                   gridMask * gridPattern(pos, gap, lineWidth) +
                   crossMask * crossPattern(pos, gap, lineWidth, crossSize);
    
    // Mix colors
    vec4 color = mix(u_bgColor, u_patternColor, pattern);
    fragColor = vec4(color.rgb, color.a * opacity);
}