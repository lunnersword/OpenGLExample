//
//  DrawCommandsRender.swift
//  OpenGLKit
//
//  Created by lunner on 2018/8/1.
//  Copyright © 2018 lunner. All rights reserved.
//
#if os(iOS)
import OpenGLES
import GLKit
#elseif os(OSX)
import OpenGL
#endif

import GLHelper

class DrawCommandsRender: RenderProtocol {
    var program: GLProgram!
    var vao = GLuint()
    var vbo = GLuint()
    var ebo = GLuint()
    var aspect: Float = 0
    
    var modelMatrixLoc = GLint()
    var projectMatrixLoc = GLint()
    
    var vertexShader: String = """
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
uniform mat4 model_matrix;
uniform mat4 projection_matrix;

 in vec4 position;
 in vec4 color;

out vec4 vs_fs_color;

void main(void)
{
vs_fs_color = color;
gl_Position = projection_matrix * (model_matrix * position);
}
"""
    
    var fragmentShader: String = """
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

void main(void)
{
color = vs_fs_color;
}
"""
    
    let vertexPositions: [GLfloat] = [
        -1.0, -1.0, 0.0, 1.0,
        1.0, -1.0, 0.0, 1.0,
        -1.0, 1.0, 0.0, 1.0,
        -1.0, -1.0, 0.0, 1.0,]
    let vertexColors: [GLfloat] = [1.0, 1.0, 1.0, 1.0,
                                   1,0, 1.0, 0.0, 1.0,
                                   1.0, 0.0, 1.0, 1.0,
                                   0.0, 1.0, 1.0, 1.0]
    let vertexIndices: [GLuint] = [0, 1, 2]
    
    func setup() {
        program = GLProgram()
        program.addShaderFromSource(type: GLenum(GL_VERTEX_SHADER), source: vertexShader)
        program.addShaderFromSource(type: GLenum(GL_FRAGMENT_SHADER), source: fragmentShader)
        program.link()
        
        
        modelMatrixLoc = program.getUniformLocation(name: "model_matrix")
        projectMatrixLoc = program.getUniformLocation(name: "projection_matrix")
        
        // Set up the vertex attributes
        let vertexAttribPosition: GLuint = GLuint(program.getAttributeLocation(name: "position"))
        let vertexAttribColor: GLuint = GLuint(program.getAttributeLocation(name: "color"))

        let vertexStride = MemoryLayout<GLfloat>.stride * 4
        let colorStride = MemoryLayout<GLfloat>.stride * 4
        let colorOffsetPointer = UnsafeRawPointer(bitPattern: vertexPositions.size())
        glGenVertexArraysOES(1, &vao)
        glBindVertexArrayOES(vao)
        
        glGenBuffers(1, &vbo)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo)
        glBufferData(GLenum(GL_ARRAY_BUFFER), vertexPositions.size() + vertexColors.size(), nil, GLenum(GL_STATIC_DRAW))
        glBufferSubData(GLenum(GL_ARRAY_BUFFER), 0, vertexPositions.size(), vertexPositions)
        glBufferSubData(GLenum(GL_ARRAY_BUFFER), vertexPositions.size(), vertexColors.size(), vertexColors)
        glVertexAttribPointer(vertexAttribPosition, 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(vertexStride), nil)
        glVertexAttribPointer(vertexAttribColor, 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(colorStride), colorOffsetPointer)
        glEnableVertexAttribArray(vertexAttribPosition)
        glEnableVertexAttribArray(vertexAttribColor)
        
        // Creating EBO Buffers
        glGenBuffers(1, &ebo)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), ebo)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), vertexIndices.size(), vertexIndices, GLenum(GL_STATIC_DRAW))
        
        // Unbind
        glBindVertexArrayOES(0)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
    }
    
    func tearDown() {
        glDeleteBuffers(1, &vao)
        glDeleteBuffers(1, &vbo)
        glDeleteBuffers(1, &ebo)
        program.validate()
    }
    
    func glkViewControllerUpdate(_ controller: GLKViewController) {
        aspect = fabsf(Float(controller.view.bounds.size.width) / Float(controller.view.bounds.size.height))
        // Set up the projection matrix
        
        var projectionMatrix = GLKMatrix4MakeFrustum(-1.0, 1.0, -aspect, aspect, 1.0, 500.0)
        let components = MemoryLayout.size(ofValue: projectionMatrix.m)/MemoryLayout.size(ofValue: projectionMatrix.m.0)
        withUnsafePointer(to: &projectionMatrix.m) {
            $0.withMemoryRebound(to: GLfloat.self, capacity: components) {ptr in
                glProgramUniformMatrix4fvEXT(program.program, projectMatrixLoc, 1, GLboolean(GL_FALSE), ptr)
            }
        }
    }
    
    func glkView(_ view: GLKView, drawIn rect: CGRect, in viewController: GLKViewController) {
        glClearColor(0.0, 0.0, 0.0, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))

        program.use()

        glBindVertexArrayOES(vao)
        
        // Draw Arrays...
        var modelMatrix = GLKMatrix4MakeTranslation(-3.0, 0.0, -5.0)
        let mComponents = MemoryLayout.size(ofValue: modelMatrix.m) / MemoryLayout.size(ofValue: modelMatrix.m.0)
        withUnsafePointer(to: &modelMatrix.m) {
            $0.withMemoryRebound(to: GLfloat.self, capacity: mComponents) {ptr in
                glProgramUniformMatrix4fvEXT(program.program, modelMatrixLoc, 1, GLboolean(GL_FALSE), ptr)
            }
        }
        
        
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
        
        // DrawElements
        modelMatrix = GLKMatrix4MakeTranslation(-1.0, 0.0, -5.0)
        withUnsafePointer(to: &modelMatrix.m) {
            $0.withMemoryRebound(to: GLfloat.self, capacity: mComponents) {ptr in
                glProgramUniformMatrix4fvEXT(program.program, modelMatrixLoc, 1, GLboolean(GL_FALSE), ptr)
            }
        }
        glDrawElements(GLenum(GL_TRIANGLES), 3, GLenum(GL_UNSIGNED_INT), nil)
        
        // DrawElementsBaseVertex
        //        #if os(OSX)
        //        modelMatrix = GLKMatrix4MakeTranslation(1.0, 0.0, -5.0)
        //        withUnsafePointer(to: &modelMatrix.m) {
        //            $0.withMemoryRebound(to: GLfloat.self, capacity: mComponents, {ptr in
        //                glProgramUniformMatrix4fvEXT(program.program, modelMatrixLoc, 1, GLboolean(GL_FALSE), ptr)
        //            })
        //        }
        //        gldrawelementsBaseVertex(
        //        #endif
        
        // DrawArraysInstanced
        modelMatrix = GLKMatrix4MakeTranslation(3.0, 0.0, -5.0)
        withUnsafePointer(to: &modelMatrix.m) {
            $0.withMemoryRebound(to: GLfloat.self, capacity: mComponents, {ptr in
                glProgramUniformMatrix4fvEXT(program.program, modelMatrixLoc, 1, GLboolean(GL_FALSE), ptr)
            })
        }
        glDrawArraysInstanced(GLenum(GL_TRIANGLES), 0, 3, 1);
        
        
        glBindVertexArrayOES(0)

        
    }
    
    
}
