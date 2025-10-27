// background_cross.frag
precision highp float;

// [Same constants and helpers as dot shader]

uniform vec3 u_patternParams;  // gap, lineWidth, crossSize (3 params)

// =============================================================================
// CROSS PATTERN (SPECIALIZED)
// =============================================================================

highp float crossPattern(highp vec2 pos, highp float gap, highp float lineWidth, highp float crossSize) {
    highp vec2 grid = mod(pos, gap) - gap * 0.5;
    highp float horizontalBar = smoothstep(lineWidth + 0.5, lineWidth - 0.5, abs(grid.y)) 
                               * smoothstep(crossSize + 0.5, crossSize - 0.5, abs(grid.x));
    highp float verticalBar = smoothstep(lineWidth + 0.5, lineWidth - 0.5, abs(grid.x)) 
                             * smoothstep(crossSize + 0.5, crossSize - 0.5, abs(grid.y));
    return clamp(horizontalBar + verticalBar, 0.0, 1.0);
}

// =============================================================================
// MAIN SHADER - CROSS VARIANT
// =============================================================================

void main() {
    highp vec2 pos = gl_FragCoord.xy + u_patternOffset;
    highp vec4 bgColor = (u_hasGradient > 0.5) ? calculateGradient() : u_bgColor;
    
    // Specialized: only cross pattern, no branching
    highp float gap = u_patternParams.x;
    highp float lineWidth = u_patternParams.y;
    highp float crossSize = u_patternParams.z;
    highp float pattern = crossPattern(pos, gap, lineWidth, crossSize);
    
    if (pattern < 0.001) {
        fragColor = bgColor;
        return;
    }
    
    highp vec4 patternColorWithAlpha = vec4(u_patternColor.rgb, u_patternColor.a * pattern);
    int blendMode = int(u_blendMode + 0.5);
    fragColor = applyBlendMode(bgColor, patternColorWithAlpha, blendMode);
}
