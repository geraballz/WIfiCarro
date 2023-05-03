//
//  ViewController.swift
//  wifiCarro
//
//  Created by Gerardo Herrera on 22/07/22.
//

import UIKit
import Network

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
    var connection: NWConnection?

    func someFunc() {
        
        self.connection = NWConnection(host: "192.168.4.1", port: 8888, using: .udp)
        "192.168.4.1"
        "nc -u -lk 8080"
        self.connection?.stateUpdateHandler = { (newState) in
            switch (newState) {
            case .ready:
                print("ready")
            case .setup:
                print("setup")
            case .cancelled:
                print("cancelled")
            case .preparing:
                print("Preparing")
            default:
                print("waiting or failed")

            }
        }
        self.connection?.start(queue: .global())

    }

    func send(instruction: String, completion: @escaping()->()) {
        self.connection?.send(content: instruction.data(using: String.Encoding.utf8), completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
            completion()
        })))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
        someFunc()
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
        
        /*
        stopView.addAction(#selector(stopViewAction), target: self)
        rightUpView.addAction(#selector(rightUpViewAction), target: self)
        rightDownView.addAction(#selector(rightDownViewAction), target: self)
        leftUpView.addAction(#selector(leftUpViewAction), target: self)
        leftDownView.addAction(#selector(leftDownViewAction), target: self)
        speakerView.addAction(#selector(speakerViewAction), target: self)
         */
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
    /*
    @objc func stopViewAction() {
        guard !indicatorView.isAnimating else { return }
        startAnimation()
        stopView.isUserInteractionEnabled = false
        stopView.showAnimation {
            Utils().sendInstruction(instruction: "S") {
                self.stopView.isUserInteractionEnabled = true
                self.stopAnimation()
            }
        }
    }
    
    @objc func rightUpViewAction() {
        guard !indicatorView.isAnimating else { return }
        startAnimation()
        rightUpView.isUserInteractionEnabled = false
        rightUpView.showAnimation {
            Utils().sendInstruction(instruction: "I") {
                self.rightUpView.isUserInteractionEnabled = true
                self.stopAnimation()
            }
        }
    }
    
    @objc func rightDownViewAction() {
        guard !indicatorView.isAnimating else { return }
        startAnimation()
        rightDownView.isUserInteractionEnabled = false
        rightDownView.showAnimation {
            Utils().sendInstruction(instruction: "J") {
                self.rightDownView.isUserInteractionEnabled = true
                self.stopAnimation()
            }
        }
    }
    
    @objc func leftUpViewAction() {
        guard !indicatorView.isAnimating else { return }
        startAnimation()
        leftUpView.isUserInteractionEnabled = false
        leftUpView.showAnimation {
            Utils().sendInstruction(instruction: "G") {
                self.leftUpView.isUserInteractionEnabled = true
                self.stopAnimation()
            }
        }
    }
    
    @objc func leftDownViewAction() {
        guard !indicatorView.isAnimating else { return }
        startAnimation()
        leftDownView.isUserInteractionEnabled = false
        leftDownView.showAnimation {
            Utils().sendInstruction(instruction: "H") {
                self.leftDownView.isUserInteractionEnabled = true
                self.stopAnimation()
            }
        }
    }
    
    @objc func speakerViewAction() {
        guard !indicatorView.isAnimating else { return }
        startAnimation()
        let value = speaker ? "V" : "v"
        speakerView.isUserInteractionEnabled = false
        speakerView.showAnimation {
            Utils().sendInstruction(instruction: value) {
                self.speakerView.isUserInteractionEnabled = true
                self.stopAnimation()
            }
        }
    }
    */
    @IBAction func speedAction(_ sender: UISlider) {
        let value = Int(sender.value)
        self.send(instruction: String(value)) { }
    }
    
    @IBAction func frontLight(_ sender: UISwitch) {
        let state: String = sender.isOn ? "W" : "w"
    }
    
    @IBAction func backLight(_ sender: UISwitch) {
        let state: String = sender.isOn ? "U" : "u"
    }
    
}
