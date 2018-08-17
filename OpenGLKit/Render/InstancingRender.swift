//
//  InstancingRender.swift
//  OpenGLKit
//
//  Created by lunner on 2018/8/1.
//  Copyright © 2018 lunner. All rights reserved.
//

import OpenGLES
import GLKit
import GLHelper

class InstancingRender: BasicRender {
    let vs = """
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
uniform mat4 model_matrix[4];
uniform mat4 projection_matrix;

in vec4 position;
in vec3 normal;
in vec4 color;
in vec4 instance_weights;
in vec4 instnce_color;
out vec3 vs_fs_normal;
out vec4 vs_fs_color;

void main(void)
{
    int n;
    mat4 m = mat4(0.0);
    // Normalize the weights so that their sum total is 1.0
    vec4 weights = normalize(instance_weights);
    for (n = 0; n < 4; n++) {
        m += (model_matrix[n] * weights[n];
    }
    vs_fs_normal = normalize((m * vec4(normal, 0.0)).xyz);
    vs_fs_color = instance_color;
    gl_Position = projection_matrix * (m * position);
}
"""
    
    let fs = """
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

in vec4 vs_fs_color;

out vec4 color;
in vec3 vs_fs_normal;
in vec4 vs_fs_color;

void main(void)
{
    color = vs_fs_color * (0.1 + abs(vs_fs_normal.z)) + vec4(0.8, 0.9, 0.7, 1.0) * pow(abs(vs_fs_normal.z), 40.0);
}
"""

    var modelMatrixLoc = GLuint()
    var projectionMatrixLoc = GLuint()
    
    public override func setup() {
        vertexShader = vs
        fragmentShader = fs
        super.setup()

        
    }
    
    public override func tearDown() {
        
    }
    
    public override func glkViewControllerUpdate(_ controller: GLKViewController) {
        
    }
    
    public override func glkView(_ view: GLKView, drawIn rect: CGRect, in viewController: GLKViewController) {
        
    }
}
