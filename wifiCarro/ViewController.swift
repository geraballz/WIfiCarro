//
//  ViewController.swift
//  wifiCarro
//
//  Created by Gerardo Herrera on 22/07/22.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {

    @IBOutlet weak var leftDownView: UIImageView!
    @IBOutlet weak var leftUpView: UIImageView!
    @IBOutlet weak var rightDownView: UIImageView!
    @IBOutlet weak var rightUpView: UIImageView!
    @IBOutlet weak var downView: UIImageView!
    @IBOutlet weak var upView: UIImageView!
    @IBOutlet weak var leftView: UIImageView!
    @IBOutlet weak var stopView: UIView!
    @IBOutlet weak var rightView: UIImageView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var speakerView: UIImageView!
    @IBOutlet weak var speedView: UISlider!
    
    private var speaker = false
    var timerUp: Timer?
    var timerDown: Timer?
    var timerLeft: Timer?
    var timerRight: Timer?

    func send(instruction: String, completion: @escaping()->()) {
        UDPManager.shared.send(instruction: instruction, completion: completion)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
    }
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft
    }
    
    func startAnimation() {
        DispatchQueue.main.async {
            self.indicatorView.startAnimating()
            
        }
    }
    
    func stopAnimation() {
        DispatchQueue.main.async {
            self.indicatorView.stopAnimating()
        }
        
    }
    
    func setupAction() {
        upView.addAction(#selector(upViewAction), target: self)
        downView.addAction(#selector(downViewAction), target: self)
        leftView.addAction(#selector(leftViewAction), target: self)
        rightView.addAction(#selector(rightViewAction), target: self)
        
    }
    
    @objc func upViewAction(sender: UITapGestureRecognizer) {
        if sender.state == .began {
            timerUp = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {_ in
                self.send(instruction: "F") { }
                self.startAnimation()
                self.upView.showAnimation({})
            })
        } else if sender.state == .ended || sender.state == .cancelled  || sender.state == .failed {
            self.stopAnimation()
            timerUp?.invalidate()
            timerUp = nil
        }
    }
    
    @objc func downViewAction(sender: UITapGestureRecognizer) {
        
        startAnimation()
        if sender.state == .began {
            timerDown = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {_ in
                self.send(instruction: "B") { }
                self.downView.showAnimation({})
            })
        } else if sender.state == .ended || sender.state == .cancelled  || sender.state == .failed  {
            self.stopAnimation()
            timerDown?.invalidate()
            timerDown = nil
        }
    }
    
    @objc func leftViewAction(sender: UITapGestureRecognizer) {
        startAnimation()
        if sender.state == .began {
            timerLeft = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {_ in
                self.send(instruction: "L") { }
                self.leftView.showAnimation({})
            })
        } else if sender.state == .ended || sender.state == .cancelled {
            self.stopAnimation()
            timerLeft?.invalidate()
            timerLeft = nil
        }
    }
    
    @objc func rightViewAction(sender: UITapGestureRecognizer) {
        startAnimation()
        if sender.state == .began {
            timerRight = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {_ in
                self.send(instruction: "R") { }
                self.rightView.showAnimation({})
            })
        } else if sender.state == .ended || sender.state == .cancelled {
            self.stopAnimation()
            timerRight?.invalidate()
            timerRight = nil
        }
    }
    
    @IBAction func speedAction(_ sender: UISlider) {
        let value = Int(sender.value)
        self.send(instruction: String(value)) { }
        AudioServicesPlayAlertSound(SystemSoundID(1520))
    }
    
    @IBAction func frontLight(_ sender: UISwitch) {
        let state: String = sender.isOn ? "W" : "w"
    }
    
    @IBAction func backLight(_ sender: UISwitch) {
        let state: String = sender.isOn ? "U" : "u"
    }
    
}
