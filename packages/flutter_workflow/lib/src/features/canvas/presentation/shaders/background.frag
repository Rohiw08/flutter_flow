#version 460 core
#include <flutter/runtime_effect.glsl>

//_Resolution is a built-in from Flutter for the widget's size
uniform vec2 uOffset;
uniform float uScale;
uniform vec4 uColor;
uniform float uGap;
// Pattern Type: 0=Dots, 1=Grid, 2=Cross
uniform int uPatternType; 
uniform float uDotRadius;
uniform float uCrossSize;

out vec4 fragColor;

void main() {
    // Get pixel coordinate from Flutter
    vec2 pos = FlutterGetPosition();
    
    // Apply pan and zoom from the InteractiveViewer
    pos = (pos + uOffset) / uScale;
    
    // Calculate grid coordinates
    vec2 grid_coord = mod(pos, uGap);
    
    float alpha = 0.0;
    
    if (uPatternType == 0) { // Dots
        vec2 center = vec2(uGap * 0.5);
        float dist = distance(grid_coord, center);
        alpha = 1.0 - smoothstep(uDotRadius - 1.0, uDotRadius, dist);
    } else if (uPatternType == 1) { // Grid
        float lineWidth = 1.0;
        if (grid_coord.x < lineWidth || grid_coord.y < lineWidth) {
            alpha = 1.0;
        }
    } else if (uPatternType == 2) { // Cross
        vec2 center = vec2(uGap * 0.5);
        float half_cross = uCrossSize * 0.5;
        bool is_horizontal = abs(grid_coord.y - center.y) < 1.0 && abs(grid_coord.x - center.x) <= half_cross;
        bool is_vertical = abs(grid_coord.x - center.x) < 1.0 && abs(grid_coord.y - center.y) <= half_cross;
        if (is_horizontal || is_vertical) {
            alpha = 1.0;
        }
    }
    
    fragColor = vec4(uColor.rgb, uColor.a * alpha);
}
