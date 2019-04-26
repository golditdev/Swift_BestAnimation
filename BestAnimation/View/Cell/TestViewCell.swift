
import UIKit

class TestViewCell: UITableViewCell {
    static let cellId = "TestViewCell"
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var bottomLineHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomLineBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var titleLabelCenter: NSLayoutConstraint!
    @IBOutlet weak var resultBar: UIView!
    private var result: UIView!
    private var showedResult: Bool = false
    private var isCorrect: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        resultBar.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func displayCell(answer: String?, isDisplay: Bool = false) {
        showedResult = false
        isCorrect = false
        lblTitle.text = answer
        lblTitle.alpha = 0
        bottomLine.alpha = 0
        bottomLineHeight.constant = 0.6
        lblTitle.textColor = Colors.textDarkColor
        bottomLine.backgroundColor = Colors.mainColor
        contentView.backgroundColor = UIColor.clear
        resultBar.removeAllSubViews()
        
        if isDisplay {
            startAnimation()
        }
    }
    
    func setCell(isCorrect: Bool = false) {
        contentView.backgroundColor = UIColor.clear
        
        if isCorrect {
            if !self.isCorrect {
                showCorrect()
            }
        } else {
            showDisable()
        }
    }
    
    private func startAnimation() {
        contentView.transform = CGAffineTransform(translationX: 0, y: 10)
        UIView.animate(withDuration: 0.7) {
            self.contentView.transform = .identity
        }
        
        UIView.animate(withDuration: 0.7, animations: {
            self.lblTitle.alpha = 0.5
        }) { (finish) in
            self.lblTitle.alpha = 1
        }
        
        self.perform(#selector(self.bottomLineAnimation), with: nil, afterDelay: 0.3)
    }
    
    @objc func bottomLineAnimation() {
        UIView.animate(withDuration: 0.7, animations: {
            self.bottomLine.alpha = 0.5
        }) { finish in
            self.bottomLine.alpha = 1
        }
    }
    
    func showResult(correct: Bool) {
        if showedResult {
            return
        }
        
        showedResult = true
        isCorrect = correct
        
        if correct {
            showCorrect()
        } else {
            showIncorrect()
        }
    }
    
    private func hideResult() {
        result.animateTo(frame: CGRect.init(x: resultBar.bounds.width, y: 0, width: resultBar.bounds.width, height: resultBar.bounds.height), withDuration: 0.3)
    }
    
    private func showIncorrect() {
        self.contentView.shake()
        
        resultBar.removeAllSubViews()
        
        let bar = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: resultBar.bounds.height))
        bar.backgroundColor = Colors.pStarRedColor
        self.resultBar.addSubview(bar)
        bar.animateTo(frame: CGRect.init(x: 0, y: 0, width: resultBar.bounds.width, height: resultBar.bounds.height), withDuration: 0.3)
        
        result = bar
    }
    
    private func showCorrect() {
        contentView.backgroundColor = Colors.grayBGColor
        lblTitle.textColor = Colors.textDarkColor
        
        resultBar.removeAllSubViews()
        
        let bar = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: resultBar.bounds.height))
        bar.backgroundColor = Colors.pStarGreenColor
        self.resultBar.addSubview(bar)
        bar.animateTo(frame: CGRect.init(x: 0, y: 0, width: resultBar.bounds.width, height: resultBar.bounds.height), withDuration: 0.3)
        
        result = bar
    }
    
    private func showDisable() {
        lblTitle.textColor = Colors.pStartGrayColor
        bottomLine.backgroundColor = Colors.pStartGrayColor
        
        if showedResult {
            hideResult()
        }
    }
    
}
