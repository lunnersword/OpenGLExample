//
//  ViewController.swift
//  OpenGLKit
//
//  Created by lunner on 2018/7/13.
//  Copyright © 2018 lunner. All rights reserved.
//

import UIKit
import GLKit
import GLHelper



class ViewController: GLKViewController {
    private var context: EAGLContext!
    var render: RenderProtocol!
    deinit {
        tearDownGL()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGL()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupGL() {
        context = EAGLContext(api: .openGLES3)
        EAGLContext.setCurrent(context)
        if let view = self.view as? GLKView, let context = context {
            view.context = context
            delegate = self
            // Configure renderbuffers created by the view
            view.drawableColorFormat = .RGBA8888
            view.drawableDepthFormat = .format24;
            view.drawableStencilFormat = .format8;
            
            // Enable multisampling
//            view.drawableMultisample = .multisample4X;

        }
        render = ExampleRender()
        render.setup()
    }
    
    private func tearDownGL() {
        EAGLContext.setCurrent(context)
        render.tearDown()
        EAGLContext.setCurrent(nil)
        context = nil
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        render.glkView(view, drawIn: rect, in: self)
    }
}

extension ViewController: GLKViewControllerDelegate {
    
    func glkViewControllerUpdate(_ controller: GLKViewController) {
        
//        let modelMatrix = GLKMatrix4Identity
//        var cameraTransformation = GLKMatrix4Identity
//        cameraTransformation = GLKMatrix4Rotate(cameraTransformation, GLKMathDegreesToRadians(rotation), 0, 1, 0)
//        cameraTransformation = GLKMatrix4Rotate(cameraTransformation, GLKMathDegreesToRadians(rotation), 1, 0, 0)
//
//        var cameraPostion: GLKVector3 = GLKMatrix4MultiplyVector3(cameraTransformation, GLKVector3Make(0.0, 0.0, 1000))
//        var cameraUpDirection: GLKVector3 = GLKMatrix4MultiplyVector3(cameraTransformation, GLKVector3Make(0.0, 1.0, 0.0))
//        let viewMatrix = GLKMatrix4MakeLookAt(cameraPostion.x, cameraPostion.y, cameraPostion.z, 0.0, 0.0, 0.0, cameraUpDirection.x, cameraUpDirection.y, cameraUpDirection.z)
//        let modelViewMatrix = GLKMatrix4Multiply(viewMatrix, modelMatrix)//
        
        render.glkViewControllerUpdate(self)
       
    }
 
    
}

