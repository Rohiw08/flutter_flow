// background_grid.frag
precision highp float;

// [Same constants and helpers as dot shader]

// =============================================================================
// GRID PATTERN (SPECIALIZED)
// =============================================================================

highp float gridPattern(highp vec2 pos, highp float gap, highp float lineWidth) {
    highp vec2 grid = abs(mod(pos, gap) - gap * 0.5);
    highp float lineX = step(grid.x, lineWidth);
    highp float lineY = step(grid.y, lineWidth);
    return clamp(lineX + lineY, 0.0, 1.0);
}

// =============================================================================
// MAIN SHADER - GRID VARIANT
// =============================================================================

void main() {
    highp vec2 pos = gl_FragCoord.xy + u_patternOffset;
    highp vec4 bgColor = (u_hasGradient > 0.5) ? calculateGradient() : u_bgColor;
    
    // Specialized: only grid pattern, no branching
    highp float gap = u_patternParams.x;
    highp float lineWidth = u_patternParams.y;
    highp float pattern = gridPattern(pos, gap, lineWidth);
    
    if (pattern < 0.001) {
        fragColor = bgColor;
        return;
    }
    
    highp vec4 patternColorWithAlpha = vec4(u_patternColor.rgb, u_patternColor.a * pattern);
    int blendMode = int(u_blendMode + 0.5);
    fragColor = applyBlendMode(bgColor, patternColorWithAlpha, blendMode);
}
