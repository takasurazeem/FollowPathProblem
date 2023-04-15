//------------------------------------------------------------------------
// The SwiftUI Lab: Advanced SwiftUI Animations
// https://gist.github.com/swiftui-lab/e5901123101ffad6d39020cc7a810798
// https://swiftui-lab.com/swiftui-animations-part1 (Animating Paths)
// https://swiftui-lab.com/swiftui-animations-part2 (GeometryEffect)
// https://swiftui-lab.com/swiftui-animations-part3 (AnimatableModifier)
//------------------------------------------------------------------------
import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            // TODO: - Make it accept an upper bound, lower bound and a current value
            // Like this: FollowPathView(lowerBound: 0, upperBound: 100, currentValue: 50)
            FollowPathView(lowerBound: 0, upperBound: 100, currentValue: 50)
        }
    }
}

// MARK: - FollowPath
struct FollowPathView: View {
    @State private var flag = false
    // start of the path
    let lowerBound: Double
    // end of the path
    let upperBound: Double
    // 50 will be middle of the path, but it can be anything between 0-100 and that's where the `circle.circle.fill` should be and there needs to be no animation. Do not replace Image with anything or any Shape.
    let currentValue: Double
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            // Draw the Infinity Shape
            MyCustomShape()
                .stroke(Color.black)
                .frame(width: 157, height: 88)
            
            // Animate movement of Image
            Image(systemName: "car.fill")
                .resizable()
                .frame(width: 20, height: 20).offset(x: -20/2, y: -20/2)
                .modifier(FollowEffect(pct: self.flag ? 1 : 0, path: MyCustomShape.createShape(in: CGRect(x: 0, y: 0, width: 157, height: 88)), rotate: true))
                .onAppear {
                    withAnimation(Animation.linear(duration: 4.0).repeatForever(autoreverses: false)) {
                        self.flag.toggle()
                    }
                }
        }
    }
}

struct FollowEffect: GeometryEffect {
    var pct: CGFloat = 0
    let path: Path
    var rotate = true

    var animatableData: CGFloat {
        get { return pct }
        set { pct = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {

        if !rotate {
            let pt = percentPoint(pct)

            return ProjectionTransform(CGAffineTransform(translationX: pt.x, y: pt.y))
        } else {
            // Calculate rotation angle, by calculating an imaginary line between two points
            // in the path: the current position (1) and a point very close behind in the path (2).
            let pt1 = percentPoint(pct)
            let pt2 = percentPoint(pct - 0.01)

            let a = pt2.x - pt1.x
            let b = pt2.y - pt1.y

            let angle = a < 0 ? atan(Double(b / a)) : atan(Double(b / a)) - Double.pi

            let transform = CGAffineTransform(translationX: pt1.x, y: pt1.y).rotated(by: CGFloat(angle))

            return ProjectionTransform(transform)
        }
    }

    func percentPoint(_ percent: CGFloat) -> CGPoint {

        let pct = percent > 1 ? 0 : (percent < 0 ? 1 : percent)

        let f = pct > 0.999 ? CGFloat(1-0.001) : pct
        let t = pct > 0.999 ? CGFloat(1) : pct + 0.001
        let tp = path.trimmedPath(from: f, to: t)

        return CGPoint(x: tp.boundingRect.midX, y: tp.boundingRect.midY)
    }
}


struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
