#version 300 es
#ifdef GL_ES//for discriminate GLES & GL
#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#else
#define highp
#define mediump
#define lowp
#endif
uniform mat4 mvMatrix;
uniform mat4 pMatrix;

layout( location = 0 ) in vec4 vPosition;
layout( location = 1 ) in vec4 vColor;
out vec4 color;

void
main()
{
    gl_Position = pMatrix * mvMatrix * vPosition;
    color = vColor;
}
