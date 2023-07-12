//
//  ViewController.swift
//  WaterTracker
//
//  Created by Илья Алексейчук on 03.07.2023.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var factLabel: UILabel!
    
    let networkModel = NetworkModel()
    let settings = Settings.shared
    let notifications = Notifications()
    
    
    var addingAmount: Int?
    
    var currentPos: Double!
    
    var shapeLayer: CAShapeLayer! {
        didSet {
            shapeLayer.lineWidth = 200
            shapeLayer.lineCap = .butt
            shapeLayer.fillColor = nil
            shapeLayer.strokeEnd = 1
            let color = UIColor.white.withAlphaComponent(0.75).cgColor
            shapeLayer.strokeColor = color
            
            
        }
    }
    
    var overShapeLayer: CAShapeLayer! {
        didSet {
            overShapeLayer.lineWidth = 200
            overShapeLayer.lineCap = .butt
            overShapeLayer.fillColor = nil
            overShapeLayer.strokeEnd = 0
            let color = UIColor(named: "waterColor")?.cgColor
            overShapeLayer.strokeColor = color
            
        }
    }
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shapeLayer = CAShapeLayer()
        view.layer.addSublayer(shapeLayer)
        
        overShapeLayer = CAShapeLayer()
        view.layer.addSublayer(overShapeLayer)
        
        
        networkModel.onCompelition = { [weak self] fact in
            DispatchQueue.main.async {
                self?.factLabel.text = fact.fact
            }
        }
        
        notifications.scheduleNotification()
        
        networkModel.fetchFact()
        
        
        
        checkDay()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        currentPos = Double(Settings.shared.currentWaterSettings.currentAmount) / Double(Settings.shared.currentWaterSettings.finalAmount)
        
        animateWater()
        
        if let amount = addingAmount {
            addWater(amount: amount)
        }
        
        amountLabel.text = "\(settings.currentWaterSettings.currentAmount)/\(settings.currentWaterSettings.finalAmount)"
        
    }
    
    
    override func viewDidLayoutSubviews() {
        configShapeLayer(shapeLayer)
        configShapeLayer(overShapeLayer)
    }
    
    func configShapeLayer(_ shapeLayer: CAShapeLayer) {
        shapeLayer.frame = view.bounds
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.view.frame.width / 2, y: self.amountLabel.frame.minY - 20))
        path.addLine(to: CGPoint(x: self.view.frame.width / 2, y: self.settingsButton.frame.maxY + 20))
        shapeLayer.path = path.cgPath
    }
    
    
    
    
    func addWater(amount: Int) {
        
        currentPos += Double(amount) / Double(settings.currentWaterSettings.finalAmount)
        settings.currentWaterSettings.currentAmount += amount
        
        animateWater()
        
        
        addingAmount = nil
    }
    

    func animateWater() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.toValue = currentPos
        animation.duration = 1.5
        
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.fillMode = CAMediaTimingFillMode.both
        animation.isRemovedOnCompletion = false
        
        overShapeLayer.add(animation, forKey: nil)
    }
    
    func checkDay() {
        let date = Date()
        let calendar = Calendar.current
        let currentDay = String(calendar.component(.day, from: date))
        
        if settings.currentDateOnScreen != currentDay {
            settings.currentDateOnScreen = currentDay
            settings.currentWaterSettings.currentAmount = 0
        }
    }
    
}

