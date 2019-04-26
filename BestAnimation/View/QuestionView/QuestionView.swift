
import UIKit

class QuestionView: UIView {

    @IBOutlet var content: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblQuestion: KernLabel!
    @IBOutlet weak var lblResult: KernLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    
    private func configure() {
        Bundle.main.loadNibNamed("QuestionView", owner: self, options: nil)
        addSubview(content)
        
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        content.layer.cornerRadius = 10
        content.layer.applySketchShadow(color: Colors.shadowColor, alpha: 1.0, x: 0, y: 5, blur: 25, spread: 0)
        content.backgroundColor = UIColor.white
        
    }
    
}
