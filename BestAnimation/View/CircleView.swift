
import UIKit

class CircleView: UIView {
    var circleLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 0/255, green: 177/255, blue: 255/255, alpha: 1.0)

        let path: UIBezierPath = UIBezierPath()
        
        path.addArc(withCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2),
                    radius: frame.size.width / 2,
                    startAngle: -(.pi / 2),
                    endAngle: .pi + .pi / 2,
                    clockwise: true)
        circleLayer = CAShapeLayer()
        circleLayer.path = path.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.init(red: 151/255, green: 239/255, blue: 253/255, alpha: 1.0).cgColor
        circleLayer.lineWidth = 3.0;
        circleLayer.backgroundColor = nil        
        circleLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        
        layer.addSublayer(circleLayer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func animateCircle() {
   
        let beginTime: Double = 0.5
        let strokeStartDuration: Double = 0.8
        let strokeEndDuration: Double = 1.5
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.byValue = Float.pi * 2
        #if swift(>=4.2)
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        #else
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        #endif
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.duration = strokeEndDuration
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        strokeEndAnimation.beginTime = beginTime
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.duration = strokeStartDuration
        strokeStartAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1
        
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [rotationAnimation, strokeStartAnimation, strokeEndAnimation]
        groupAnimation.duration = strokeEndDuration + beginTime

        #if swift(>=4.2)
        groupAnimation.fillMode = .forwards
        #else
        groupAnimation.fillMode = kCAFillModeForwards
        #endif
        circleLayer.frame = self.frame
        circleLayer.add(groupAnimation, forKey: "animation")
    }
}
