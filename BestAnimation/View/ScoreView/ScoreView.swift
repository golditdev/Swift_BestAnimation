
import UIKit

class ScoreView: UIView {

    @IBOutlet var content: UIView!
    @IBOutlet weak var lblTitle: KernLabel!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var lblPercent: KernLabel!
    @IBOutlet weak var lblMessage: KernLabel!
    @IBOutlet weak var btnTest: KernButton!
    private var score: CGFloat = 0
    @IBOutlet weak var btnBottomMargin: NSLayoutConstraint!
    private var currentScore: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    
    private func configure() {
        Bundle.main.loadNibNamed("ScoreView", owner: self, options: nil)
        addSubview(content)
        
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        content.layer.cornerRadius = 10
        content.layer.applySketchShadow(color: Colors.shadowColor, alpha: 1.0, x: 0, y: 5, blur: 25, spread: 0)
        content.backgroundColor = UIColor.white
        
        
        childView.layer.borderColor = Colors.borderColor.cgColor
        childView.layer.borderWidth = 1
        childView.layer.cornerRadius = childView.bounds.height / 2
        
        btnTest.layer.cornerRadius = 5
        btnTest.clipsToBounds = true
        
        lblTitle.text = ""
        lblMessage.text = ""
    }
    
    
    func setTitle (highlitedText: String, text: String) {
        let attributedString = NSMutableAttributedString(string: "\(highlitedText) \(text)", attributes: [
            .font: UIFont.sfProDisplaySemiboldFont(20),
            .foregroundColor: Colors.textDarkColor,
            .kern: -0.04
            ])
        attributedString.addAttributes([
            .font: UIFont(name: "SanFranciscoDisplay-Medium", size: 20.0)!,
            .foregroundColor: Colors.textGrayColor
            ], range: NSRange(location: highlitedText.count + 1, length: text.count))
        
        lblTitle.attributedText = attributedString
    }
    
    func setMessage (highlitedText: String = "", text: String) {
        let attributedString = NSMutableAttributedString(string: text, attributes: [
            .font: UIFont.sfProDisplayMediumFont(16),
            .foregroundColor: Colors.textGrayColor,
            .kern: -0.16
            ])
        
        if let index = text.index(of: highlitedText) {
            let substring = text[..<index]   // ab
            let string = String(substring)
            attributedString.addAttributes([
                .font: UIFont.sfProDisplayMediumFont(16),
                .foregroundColor: Colors.textDarkColor
                ], range: NSRange(location: string.count, length: highlitedText.count))
        }
        
        lblMessage.attributedText = attributedString
    }
    
    func setScore(_ score: CGFloat) {
        self.score = (score)
        
        showScoreValue()

        showScoreArch()
        self.perform(#selector(self.showButton), with: nil, afterDelay: 1.5)
    }
    
    @objc func showScoreValue() {
        if currentScore > Int(score) {
            return
        }
        
        self.lblPercent.fadeTransition(0.01)
        self.lblPercent.text = "\(self.currentScore)"
        self.currentScore += 1
        self.perform(#selector(self.showScoreValue), with: nil, afterDelay: 0.01)
        
        
    }
    
    func getScore() -> CGFloat {
        return self.score
    }
    
    func showScoreArch() {
        let scView = ScoreCircleView.init(frame: circleView.bounds)
        circleView.addSubview(scView)
        scView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        var scoreColor: UIColor
        if score < 35 {
            scoreColor = Colors.pStarBadColor
        } else if score >= 35 && score < 70 {
            scoreColor = Colors.pStarMiddleColor
        } else {
            scoreColor = Colors.pStarGoodColor
        }
        
        scView.bgColor = UIColor.clear
        scView.strokeColor = scoreColor
        scView.lineWidth = 15
        
        scView.setProgress(to: Double(score/100), withDuration: Double(0.01 * score))
    }
    
    @objc func showButton() {
        btnBottomMargin.constant = -80
        btnTest.isHidden = false
        content.setNeedsFocusUpdate()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.btnBottomMargin.constant = 20
            self.content.layoutIfNeeded()
        }) { (_) in
            self.btnTest.shakeVPlace(offset: 2)
        }
    }
}

class ScoreCircleView: UIView {
    var circleLayer = CAShapeLayer()
    var bgColor: UIColor = UIColor.clear {
        didSet {
            setNeedsLayout()
        }
    }
    var strokeColor: UIColor = Colors.mainColor {
        didSet {
            setNeedsLayout()
        }
    }
    
    private var radius: CGFloat {
        get{
            if self.frame.width < self.frame.height { return (self.frame.width - lineWidth)/2 }
            else { return (self.frame.height - lineWidth)/2 }
        }
    }
    
    private var pathCenter: CGPoint{ get{ return self.convert(self.center, from:self.superview) } }
    
    var lineWidth: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let startAngle = (-CGFloat.pi/2)
        let endAngle = 2 * CGFloat.pi + startAngle
        
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
//        circleLayer.lineCap = CAShapeLayerLineCap.round
        circleLayer.path = path.cgPath
        circleLayer.lineWidth = lineWidth
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = strokeColor.cgColor
        circleLayer.strokeEnd = 0
        
        self.layer.addSublayer(circleLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.backgroundColor = self.bgColor
        circleLayer.strokeColor = self.strokeColor.cgColor
        circleLayer.lineWidth = self.lineWidth;
    }
    
    public func setProgress(to progressConstant: Double, withDuration duration: Double) {
        
        var progress: Double {
            get {
                if progressConstant > 1 { return 1 }
                else if progressConstant < 0 { return 0 }
                else { return progressConstant }
            }
        }
        
        circleLayer.strokeEnd = CGFloat(progress)
      
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = progress
        animation.duration = CFTimeInterval(duration)
        circleLayer.add(animation, forKey: "foregroundAnimation")

        
    }
}
