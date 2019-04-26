
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func takeTest(_ sender: Any) {
        let vc = TestViewController.onCreate()
        self.present(vc, animated: true, completion: nil)
    }
    
}

