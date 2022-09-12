#version 300 es

// This is a fragment shader. If you've opened this file first, please
// open and read lambert.vert.glsl before reading on.
// Unlike the vertex shader, the fragment shader actually does compute
// the shading of geometry. For every pixel in your program's output
// screen, the fragment shader is run for every bit of geometry that
// particular pixel overlaps. By implicitly interpolating the position
// data passed into the fragment shader by the vertex shader, the fragment shader
// can compute what color to apply to its pixel based on things like vertex
// position, light position, and vertex color.
precision highp float;

uniform vec4 u_Color; // The color with which to render this instance of geometry.

// These are the interpolated values out of the rasterizer, so you can't know
// their specific values without knowing the vertices that contributed to them
in vec4 fs_Nor;
in vec4 fs_LightVec;
in vec4 fs_Col;
in vec4 fs_Pos;  

out vec4 out_Col; // This is the final output color that you will see on your
                  // screen for the pixel that is currently being processed.

// vec4 noised(int x){
//     float d = fract((x*1.)*3.1415);
//     return vec4(d);
// }

// vec4 fbm( vec3 x, int octaves )
// {
//     float f = 1.98;  // could be 2.0
//     float s = 0.49;  // could be 0.5
//     float a = 0.0;
//     float b = 0.5;
//     vec3  d = vec3(0.0);
//     mat3  m = mat3(1.0,0.0,0.0,
//     0.0,1.0,0.0,
//     0.0,0.0,1.0);
//     for( int i=0; i < octaves; i++ )
//     {
//         vec4 n = vec4(); //noised(x);
//         a += b*n.x;          // accumulate values
//         d += b*m*n.yzw;      // accumulate derivatives
//         b *= s;
//         x = f*m3*x;
//         m = f*m3i*m;
//     }
//     return vec4( a, d, 1, 1 );
// }

void main()
{
    
    // Material base color (before shading)
        vec4 diffuseColor = u_Color;
        //vec4 diffuseColor = fs_Pos;  
        //float f = fbm(1, diffuseColor.x, diffuseColor.y, diffuseColor.z, 6);
        //diffuseColor *= diffuseColor;

        // Calculate the diffuse term for Lambert shading
        float diffuseTerm = dot(normalize(fs_Nor), normalize(fs_LightVec));
        // Avoid negative lighting values
        // diffuseTerm = clamp(diffuseTerm, 0, 1);

        float ambientTerm = 0.2;

        float lightIntensity = diffuseTerm + ambientTerm;   //Add a small float value to the color multiplier
                                                            //to simulate ambient lighting. This ensures that faces that are not
                                                            //lit by our point light are not completely black.

        // Compute final shaded color
        out_Col = vec4(diffuseColor.rgb * lightIntensity, diffuseColor.a);

}
