

import UIKit

class TestViewController: BaseController {
    @IBOutlet weak var progressBarWidthContrast: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var questionContentView: UIView!    
    @IBOutlet weak var progressBar: UIView!
    private var questionView: QuestionView!
    private var questionViewLeftMargin: NSLayoutConstraint!
    @IBOutlet weak var topHeadView: UIView!
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var hintHand: UIImageView!
    @IBOutlet weak var hintHandCenterHandle: NSLayoutConstraint!
    
    private var scoreView: ScoreView!
    private var resultView: UIView!
    
    private var questionViewWidth: CGFloat = 0
    private var startPointX: CGFloat = 0
    private var marginQV: CGFloat = 20
    private var resultLabel: KernLabel!
    
    fileprivate var answers = [String]()
    fileprivate var questions = [String]()
    
    fileprivate var currentIndex = 0
    fileprivate var isDisplayAnswers: Bool = false
    fileprivate let cellHeight = CGFloat(90)
    
    fileprivate var isAnswered: Bool = false
    fileprivate var isCorrect: Bool = false
    fileprivate var correctCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        questions = ["To avoid wake turbulence when taking off behind large aircraft, the pilot should...",
                    "After accepting a clearance and subsequetly finding that it cannot be complied with, a pilot should..."]
        answers = ["Taxi until the rotation point of the large aircraft, then take off and remain below its climb path",
                     "Become airborne before the rotation point of the large aircraft and stay above its departure path or request a turn to avoid the departure path",
                     "Remain in ground effect until past the rotation point of the large aircraft",
                     "Become airborn in the calm airspace between the vortices"]
        
        
        startPointX = self.screenSize.width + 10
        topHeadView.clipsToBounds = true
        addQuestionView()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleTap))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        swipeView.addGestureRecognizer(swipeLeft)
        swipeView.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        hideQuestion()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        showQuestion()
    }
    
    private func addQuestionView() {
        questionView = QuestionView()
        
        questionViewWidth = questionContentView.bounds.width - marginQV * 2
        questionView.frame = CGRect(x: startPointX, y: 0, width: questionViewWidth, height: 152)
        questionContentView.addSubview(questionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        questionViewWidth = questionContentView.bounds.width - marginQV * 2
        questionView.frame = CGRect(x: startPointX, y: 0, width: questionViewWidth, height: 152)
    }
    
    //Mark - QuestionView
    @objc func showQuestion() {
        currentIndex = currentIndex + 1
        if currentIndex > questions.count {
            showScoreView()
            return
        }
        
        questionView.lblQuestion.text = questions[currentIndex-1]
        questionView.lblTitle.text = "Question \(currentIndex) / \(questions.count)"
        
        self.perform(#selector(self.startQuestion), with: nil, afterDelay: 0.3)
    }
    
    @objc func startQuestion() {
        questionView.frame = CGRect(x: startPointX, y: 0, width: questionViewWidth, height: 152)
        UIView.animate(withDuration: 0.7, animations: {
            self.questionView.frame = CGRect(x: self.marginQV - 10, y: 0, width: self.questionViewWidth, height: 152)
        }) { (action) in
            self.questionView.shakePlace(offset: 10)
            self.isDisplayAnswers = true
            self.updateProgressBar()
            self.tableView.reloadWithAnimation()
        }
    }
    
    
    @objc func answered() {
        topHeadView.removeAllSubViews()
        
        let v = UIView.init(frame: CGRect(x: topHeadView.center.x, y: topHeadView.bounds.height, width: 0.1, height: 0.1))
        v.backgroundColor = isCorrect ? Colors.pStarGreenColor : Colors.pStarRedColor
        topHeadView.addSubview(v)
        
        v.animateTo(frame: topHeadView.bounds, withDuration: 0.3, delay: 0) { finish in
            self.perform(#selector(self.hideAnswerView), with: nil, afterDelay: 1)
        }
        resultView = v
        
        questionView.lblQuestion.isHidden = true
        let label = KernLabel.init()
        label.textColor = isCorrect ? Colors.pStarGreenColor : Colors.pStarRedColor
        label.text = isCorrect ? "Correct!" : "Try again"
        label.font = UIFont.sfProDisplaySemiboldFont(30)
        label.setLineSpacing(lineSpacing: 0.6)
        label.textAlignment = .center
        
        label.frame = CGRect(x: 0, y: 0, width: questionViewWidth, height: 152)
        questionView.addSubview(label)
        
        label.shakeVPlace(offset: 1)
        resultLabel = label
        
        self.tableView.reloadData()
    }
    
    @objc func hideAnswerView() {
        guard let v = resultView else {
            return
        }
        
        let frame = CGRect(x: topHeadView.center.x, y: topHeadView.bounds.height, width: 0.1, height: 0.1)
        
        v.animateTo(frame: frame, withDuration: 0.3, delay: 0)
        
        resultLabel.removeFromSuperview()        
        questionView.lblQuestion.isHidden = false
        self.swipeView.isHidden = false
        self.hintHand.isHidden = true
        
        self.perform(#selector(self.showHint), with: nil, afterDelay: 2)
    }
    
    @objc func showHint() {
        if !isAnswered {
            return
        }
        
        self.hintHand.isHidden = false
        hintHandCenterHandle.constant = 30
        swipeView.setNeedsFocusUpdate()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.hintHandCenterHandle.constant = -30
            self.swipeView.layoutIfNeeded()
        }) { (_) in
            self.perform(#selector(self.hintAgain), with: nil, afterDelay: 0.5)
        }
    }
    
    @objc func hintAgain() {
        self.hintHandCenterHandle.constant = 30
        self.hintHand.isHidden = true
        self.perform(#selector(self.showHint), with: nil, afterDelay: 1)
    }
    
    private func updateProgressBar() {
        print(progressBar.bounds.width)
        let currentWidth: CGFloat = progressBar.bounds.width * (CGFloat)(currentIndex) / (CGFloat)(questions.count)
        UIView.animate(withDuration: 0.3) {
            self.progressBarWidthContrast.constant = currentWidth
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideQuestion() {
        isAnswered = false
        isCorrect = false
        swipeView.isHidden = true
        
        UIView.animate(withDuration: 0.7, animations: {
            self.questionView.frame = CGRect(x: -(10 + self.questionViewWidth), y: 0, width: self.questionViewWidth, height: 152)
            
        }) { (action) in
            self.tableView.hideWithAnimation()
            
            self.perform(#selector(self.showQuestion), with: nil, afterDelay: 0.1)
        }
    }
    
    //Mark - ScoreView
    private func showScoreView() {
        scoreView = ScoreView()
        scoreView.frame = CGRect(x: self.view.bounds.width + 10, y: 100 , width: self.view.bounds.width - 80, height: 380)
        view.addSubview(scoreView)
        scoreView.btnTest.setTitle("Finish test", for: .normal)
        scoreView.btnTest.addTarget(self, action: #selector(onClicked), for: .touchUpInside)
        
        scoreView.setTitle(highlitedText: "Latest", text: "April 8")
        scoreView.setMessage(highlitedText: "Needs Work", text: "You have failed \(questions.count - correctCount) questions.  They appear in Needs Work section for review.")
        
        UIView.animate(withDuration: 0.7, animations: {
            self.scoreView.frame = CGRect(x: 40 - 10, y: 100, width: self.view.bounds.width - 80, height: 380)
        }) { (action) in
            self.scoreView.shakePlace(offset: 10)
            self.scoreView.setScore(CGFloat(self.correctCount * 100 / self.questions.count))
        }
        
    }
    
    @objc func onClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension TestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TestViewCell.cellId, for: indexPath) as! TestViewCell
        
        if isAnswered {
            cell.setCell(isCorrect: indexPath.row == 1)
        } else {
            cell.displayCell(answer: answers[indexPath.row], isDisplay: isDisplayAnswers)
        }
        
        return cell
    }
}

extension TestViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? TestViewCell else {
            return
        }
        
        if isAnswered || !isDisplayAnswers {
            return
        }
        
        isAnswered = true
        
        if indexPath.row == 1 {
            isCorrect = true
            correctCount += 1
            cell.showResult(correct: true)
        } else {
            cell.showResult(correct: false)
        }
        
        self.perform(#selector(self.answered), with: nil, afterDelay: 1)
    }
}

extension TestViewController {
    static func onCreate() -> TestViewController {
        return UIStoryboard.test.instantiateViewController(withIdentifier: "TestViewController") as! TestViewController
    }
}
