//
//  Vertex.swift
//  OpenGLKit
//
//  Created by lunner on 2018/7/13.
//  Copyright © 2018 lunner. All rights reserved.
//

import GLKit

extension Array {
    func size() -> Int {
        return MemoryLayout<Element>.stride * self.count
    }
}
public struct Vertex {
    var x: GLfloat
    var y: GLfloat
    var z: GLfloat
    var r: GLfloat
    var g: GLfloat
    var b: GLfloat
    var a: GLfloat
}
