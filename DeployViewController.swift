//
//  DeployViewController.swift
//  SeaFight
//
//  Created by Алех on 26.01.18.
//  Copyright © 2018 Алех. All rights reserved.
//

import UIKit
import Foundation

class DeployViewController: UIViewController {
    

    
    @IBOutlet weak var seaView: UIView!
    
    @IBOutlet var shipButtons: [UIButton]!
    @IBOutlet var shipLabels: [UILabel]!
    
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    @IBOutlet var rotationGesture: UIRotationGestureRecognizer!
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sea.reset()
        Deploy.random(for: .enemy)
        Deploy.shipsCount = sea.shipsCount[sea.settings.seaSizeIndex]
        refreshDeployViewController()
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    @IBAction func menuButtonClick(_ sender: Any) {

        var menuItems = ["Remove all ships",
                         "Automatic deploy",
                         "Back to settings",
        ]
        
        if Deploy.shipsCount[0] + Deploy.shipsCount[1] + Deploy.shipsCount[2] + Deploy.shipsCount[3] == 0 {
            menuItems.append("Start game")
        }

        
        let myActionSheet = UIAlertController(title: "Action", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        for index in 0 ..< menuItems.count {
            let button = UIAlertAction(title: menuItems[index], style: .default)  { (ACTION) in
                self.menuActionSelected(withIndex: index)
            }
            myActionSheet.addAction(button)
        }
        
        
        let buttonCancell = UIAlertAction(title: "Cancel", style: .cancel)  { (ACTION) in }
        myActionSheet.addAction(buttonCancell)
        self.present(myActionSheet, animated: true, completion: nil)
        
    }
    
    
    
    func menuActionSelected (withIndex index: Int) {
        switch index {
        case 0: // Remove all ships
            Deploy.resetMatrix(for: .own)
            Deploy.isProccessed = false
            refreshDeployViewController()
            
        case 1: // Automatic deploy
            Deploy.resetMatrix(for: .own)
            Deploy.isProccessed = false
            Deploy.random(for: .own)
            refreshDeployViewController()
            
        case 2: //  Back to settings
            performSegue(withIdentifier: "settingsSegue", sender: self)
            
        case 3: // Start Game
            performSegue(withIdentifier: "gameSegue", sender: self)
            
        default: return
        }

    }
    


    // двойное нажатие - уставновка корабля на матрицу
    @IBAction func doubleTap(_ sender: Any) {
        if Deploy.newShip.isConformFor(player: .own) == false {
            return
        }
        
        Deploy.onMatrix(forPlayer: .own)
        Deploy.isProccessed = false
        refreshDeployViewController()
        print ("doubleTap")
    }

    
    
    
    
    // движение пальца
    @IBAction func panRecognize(_ sender: Any) {
        if panGesture.state == .began {
            Deploy.beginTracking()
            return
        }
        
        let translation = panGesture.translation(in: panGesture.view!)
        Deploy.calculateNewPos(forTranslation: translation)
        refreshDeployViewController()
    }
    
    
    // распознавание вращения
    @IBAction func rotationRecognaze(_ sender: Any) {
        
        
        // угол поворота в градусах
        let deg = (rotationGesture.rotation * 180) / CGFloat.pi

        let angle = abs (deg.truncatingRemainder(dividingBy: 360))
        print (angle)
        
        //поворот на 90 или на 270
        if angle > 90 && angle < 180 || angle > 270 && angle < 360 {
            rotationGesture.rotation = 0
            
            // при повороте выходит за границы экрана
            if Deploy.newShip.rotate(angle: angle).isConformFor(player: .own) == false {
                Deploy.beginTracking()
                Deploy.calculateNewPos(forTranslation: CGPoint(x: 0, y: 0))
            }
            refreshDeployViewController()
        }
        
    }
    

    
    
    
    func refreshDeployViewController() {
        
        DispatchQueue.main.async {
            self.seaView.set(forMatrix: .own)
            
            // установка состояния кнопок и лейблов количества кораблей
            for index in 0 ..< self.shipButtons.count {
                self.shipLabels[index].text = Deploy.shipsCount[index].description
                
                if Deploy.shipsCount[index] > 0 {
                    self.shipButtons[index].isEnabled = true
                } else {
                    self.shipButtons[index].isEnabled = false
                }
            }
            
        }

    }
    


    // нажатие одной из 4х кнопок выбора размещаемого корабля
    @IBAction func deployShipClick(_ sender: Any) {

        if Deploy.isProccessed == true {
            Deploy.shipsCount[Deploy.newShip.lenght - 1] += 1
        }
        
        let tag = (sender as! UIButton).tag
        Deploy.newShip(withSize: Ship.Size(rawValue: tag)!)
        Deploy.shipsCount[tag] -= 1
        refreshDeployViewController()
    }
    
    

    
    
    
    

    
    
}






