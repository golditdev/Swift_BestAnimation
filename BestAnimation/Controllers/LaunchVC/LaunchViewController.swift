//
//  LaunchViewController.swift
//  PSTAR Prep
//
//  Created by Crane on 4/2/19.
//  Copyright © 2019 Yuriy Glivchuk. All rights reserved.
//

import UIKit
import AVFoundation

class LaunchViewController: UIViewController {
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var ivLogo: UIImageView!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var loader: UIView!
    @IBOutlet weak var logoBottomAnchor: NSLayoutConstraint!
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var circleView: CircleView!
    
    var count: Int = 0
    let reatCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlpath = Bundle.main.url(forResource: "Logo_Animation", withExtension: "mov")
        
        if let urlPath = urlpath {
            player = AVPlayer.init(url: urlPath)
            
            playerLayer = AVPlayerLayer(player: player)
            videoView.layer.addSublayer(playerLayer)
            playerLayer.frame = videoView.bounds
        }

        lblDetails.font = UIFont.sfProDisplayMediumFont(15)
        circleView = CircleView(frame: CGRect(x: 0, y: 0, width: loader.bounds.width, height: loader.bounds.height))
        loader.addSubview(circleView)
        
        ivLogo.alpha = 0
        lblDetails.alpha = 0
        loader.alpha = 0
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startAnimation()
    }
    
    @objc func startAnimation() {
        if count >= reatCount {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showMainVC()
                
                return
            }
        }
        count = count + 1
        
        ivLogo.alpha = 0.0
        lblDetails.alpha = 0
        loader.alpha = 0
        
        player.seek(to: CMTime.zero)
        player.play()
        self.perform(#selector(showLogoImage), with: nil, afterDelay: 1.5)
    }
    
    @objc func showCircleView() {
        loader.alpha = 1
        circleView.animateCircle()
        
        self.perform(#selector(self.startAnimation), with: nil, afterDelay: 3)
    }

    func showDescLabel() {
        self.lblDetails.alpha = 0.2
        UIView.animate(withDuration: 0.3, animations: {
            self.lblDetails.alpha = 0.7
        }, completion: { (action) in
            self.lblDetails.alpha = 1.0
            self.perform(#selector(self.showCircleView), with: nil, afterDelay: 0.5)
        })
    }
    
    @objc func showLogoImage() {
        ivLogo.alpha = 0.2
        logoBottomAnchor.constant = CGFloat(35)
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.logoBottomAnchor.constant = CGFloat(12)
            self.ivLogo.alpha = 0.7
            self.view.layoutIfNeeded()
        }) { (_) in
            self.ivLogo.alpha = 1.0
            self.showDescLabel()
        }
    }
    
    override func viewDidLayoutSubviews() {
        playerLayer.frame = videoView.bounds
        circleView.frame = CGRect(x: 0, y: 0, width: loader.bounds.width, height: loader.bounds.height)
    }

}
