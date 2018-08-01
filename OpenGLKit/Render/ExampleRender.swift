//
//  ExampleRender.swift
//  OpenGLKit
//
//  Created by lunner on 2018/8/1.
//  Copyright © 2018 lunner. All rights reserved.
//

import OpenGLES
import GLKit
import GLHelper

public class ExampleRender: BasicRender {
    private var ebo = GLuint()
    private var vbo = GLuint()
    private var vao = GLuint()
    private var rotation: Float = 0.0
    
    var Vertices = [
        Vertex(x:  -1, y: -1, z: 0, r: 1, g: 1, b: 1, a: 1),
        Vertex(x:  1, y:  -1, z: 0, r: 1, g: 1, b: 0, a: 1),
        Vertex(x: -1, y:  1, z: 0, r: 1, g: 0, b: 1, a: 1),
        Vertex(x: -1, y: -1, z: 0, r: 0, g: 1, b: 1, a: 1),
        ]
    
    var Indices: [GLubyte] = [
        0, 1, 2
    ]
    public override func setup() {
        super.setup()
        let vertexAttribPosition: GLuint = GLuint(program.getAttributeLocation(name: "vPosition"))
        let vertexAttribColor: GLuint = GLuint(program.getAttributeLocation(name: "vColor"))
        let vertexSize = MemoryLayout<Vertex>.stride
        let colorOffset = MemoryLayout<GLfloat>.stride * 3
        let colorOffsetPointer = UnsafeRawPointer(bitPattern: colorOffset)
        
        // Creating VAO Buffers
        glGenVertexArraysOES(1, &vao)
        glBindVertexArrayOES(vao)
        
        // Creating VBO Buffers
        glGenBuffers(1, &vbo)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo)
        glBufferData(GLenum(GL_ARRAY_BUFFER), Vertices.size(), Vertices, GLenum(GL_STATIC_DRAW))
        
        
        glVertexAttribPointer(vertexAttribPosition, 3, GLenum(GL_FLOAT), GLboolean(UInt8(GL_FALSE)), GLsizei(vertexSize), nil)
        glEnableVertexAttribArray(vertexAttribPosition)
        
        glVertexAttribPointer(vertexAttribColor, 4, GLenum(GL_FLOAT), GLboolean(UInt8(GL_FALSE)), GLsizei(vertexSize), colorOffsetPointer)
        glEnableVertexAttribArray(vertexAttribColor)
        
        // Creating EBO Buffers
        glGenBuffers(1, &ebo)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), ebo)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), Indices.size(), Indices, GLenum(GL_STATIC_DRAW))
        
        // Unbind
        glBindVertexArrayOES(0)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)

    }
    
    public override func glkViewControllerUpdate(_ controller: GLKViewController) {
//        var modelViewMatrix = GLKMatrix4MakeTranslation(0.0, 0.0, -6.0)
//        rotation += 90 * Float(controller.timeSinceLastUpdate)
//        modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(rotation), 0, 0, 1)
//        //        effect.transform.modelviewMatrix = modelViewMatrix
//        
//        let location = program.getUniformLocation(name: "mvMatrix")
//        let components = MemoryLayout.size(ofValue: modelViewMatrix.m)/MemoryLayout.size(ofValue: modelViewMatrix.m.0)
//        withUnsafePointer(to: &modelViewMatrix.m) {
//            $0.withMemoryRebound(to: GLfloat.self, capacity: components) {ptr in
//                glProgramUniformMatrix4fvEXT(program.program, location, 1, GLboolean(GL_FALSE), ptr)
//            }
//        }
        
        
        
        let aspect = fabsf(Float(controller.view.bounds.size.width) / Float(controller.view.bounds.size.height))
        var projectionMatrix = GLKMatrix4MakeFrustum(-1.0, 1.0, -aspect, aspect, 1.0, 500.0)        //        effect.transform.projectionMatrix = projectionMatrix
        let plocation = program.getUniformLocation(name: "pMatrix")
        let pcomponents = MemoryLayout.size(ofValue: projectionMatrix.m)/MemoryLayout.size(ofValue: projectionMatrix.m.0)
        withUnsafePointer(to: &projectionMatrix.m) {
            $0.withMemoryRebound(to: GLfloat.self, capacity: pcomponents) {ptr in
                glProgramUniformMatrix4fvEXT(program.program, plocation, 1, GLboolean(GL_FALSE), ptr)
            }
        }
    }
    
    public override func glkView(_ view: GLKView, drawIn rect: CGRect, in viewController: GLKViewController) {
        glClearColor(1.0, 1.0, 1.0, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        program.use()
        
        glBindVertexArrayOES(vao)
        
        // Draw Arrays...
        var modelMatrix = GLKMatrix4MakeTranslation(-3.0, 0.0, -5.0)
        let location = program.getUniformLocation(name: "mvMatrix")
        let components = MemoryLayout.size(ofValue: modelMatrix.m)/MemoryLayout.size(ofValue: modelMatrix.m.0)
        withUnsafePointer(to: &modelMatrix.m) {
            $0.withMemoryRebound(to: GLfloat.self, capacity: components) {ptr in
                glProgramUniformMatrix4fvEXT(program.program, location, 1, GLboolean(GL_FALSE), ptr)
            }
        }
        
        
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
        
        // DrawElements
        modelMatrix = GLKMatrix4MakeTranslation(-1.0, 0.0, -5.0)
        withUnsafePointer(to: &modelMatrix.m) {
            $0.withMemoryRebound(to: GLfloat.self, capacity: components) {ptr in
                glProgramUniformMatrix4fvEXT(program.program, location, 1, GLboolean(GL_FALSE), ptr)
            }
        }
        glDrawElements(GLenum(GL_TRIANGLES), 3, GLenum(GL_UNSIGNED_BYTE), nil)
        
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
            $0.withMemoryRebound(to: GLfloat.self, capacity: components) {ptr in
                glProgramUniformMatrix4fvEXT(program.program, location, 1, GLboolean(GL_FALSE), ptr)
            }
        }
        glDrawArraysInstanced(GLenum(GL_TRIANGLES), 0, 3, 1);
        
        
        glBindVertexArrayOES(0)

    }
    
    public override func tearDown() {
        
        glDeleteBuffers(1, &vao)
        glDeleteBuffers(1, &vbo)
        glDeleteBuffers(1, &ebo)
        program.validate()
    }
}
