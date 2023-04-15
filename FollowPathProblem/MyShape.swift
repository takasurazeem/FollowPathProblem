//
//  MyShape.swift
//  SunriseSunset
//
//  Created by Takasur Azeem on 15/04/2023.
//

import SwiftUI

struct MyCustomShape: Shape {
    func path(in rect: CGRect) -> Path {
        return MyCustomShape.createShape(in: rect)
    }
    
    static func createShape(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0.18658*width, y: -0.73332*height))
        path.addLine(to: CGPoint(x: 0.48443*width, y: -0.95262*height))
        path.addLine(to: CGPoint(x: 0.79144*width, y: -0.73332*height))
        path.addLine(to: CGPoint(x: 0.98181*width, y: 0))
        return path
    }
}
