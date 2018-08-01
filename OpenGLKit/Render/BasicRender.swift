
//
//  File.swift
//  OpenGLKit
//
//  Created by lunner on 2018/7/18.
//  Copyright © 2018 lunner. All rights reserved.
//
import OpenGLES
import GLKit
import GLHelper

public protocol RenderProtocol {
    var vertexShader: String { get set }
    var fragmentShader: String { get set }
    func setup()
    func tearDown()
    
    func glkViewControllerUpdate(_ controller: GLKViewController)
    func glkView(_ view: GLKView, drawIn rect: CGRect, in viewController: GLKViewController)
}

public protocol RenderDelegate {
    func renderSetup(render: RenderProtocol)
    
}

public class BasicRender: RenderProtocol {
    public var clearColor: UIColor = UIColor.black
    var program: GLProgram!
    public var vertexShader = """
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
        """
    
    public var fragmentShader = """
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

            in vec4 color;
            out vec4 finalColor;

            void main()
            {
            finalColor = color;
            }
        """

    public func setup() {
        program = GLProgram()
        program.addShaderFromSource(type: GLenum(GL_VERTEX_SHADER), source: vertexShader)
        program.addShaderFromSource(type: GLenum(GL_FRAGMENT_SHADER), source: fragmentShader)
        program.link()

    }
    
    public func tearDown() {
        program.validate()
    }
    
    public func glkViewControllerUpdate(_ controller: GLKViewController) {
        
    }
    
    public func glkView(_ view: GLKView, drawIn rect: CGRect, in viewController: GLKViewController) {
        var red = CGFloat()
        var green = CGFloat()
        var blue = CGFloat()
        var alpha = CGFloat()
        clearColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        glClearColor(GLclampf(red), GLclampf(green), GLclampf(blue), GLclampf(alpha))
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        program.use()
        
        
    }
}
