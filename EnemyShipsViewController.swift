//
//  MainViewController.swift
//  SeaFight
//
//  Created by Алех on 26.01.18.
//  Copyright © 2018 Алех. All rights reserved.
//

import UIKit
import Foundation

class EnemyShips {
    
    // координаты прицела
    static var oldSightX = sea.dimension/2
    static var oldSightY = sea.dimension/2
    
    static var sightX = sea.dimension/2
    static var sightY = sea.dimension/2
    
    static var inSight: Bool {
        if sea.enemyMatrix[sightY][sightX] == .enemy {
            return true
        } else {
            return false
        }
        
    }
    
    
    static func beginTracking() {
        oldSightX = sightX
        oldSightY = sightY
    }



    // обработка перемещения прицела
    static func calculateNewSight(for gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: gesture.view!)
        let transitionX = Int (translation.x / sea.cellWight)
        let transitionY = Int (translation.y / sea.cellWight)
        
        
        switch (oldSightX + transitionX) {
        case -100...0:
            sightX = 0
        case (sea.dimension - 1)...999:
            sightX = sea.dimension - 1
        default:
            sightX = oldSightX + transitionX
        }
        
        switch (oldSightY + transitionY) {
        case -100...0:
            sightY = 0
        case (sea.dimension - 1)...999:
            sightY = sea.dimension - 1
        default:
            sightY = oldSightY + transitionY
        }
        
        print (sightX.description + "-" + sightY.description)
    }
    
}








class EnemyShipsViewController: UIViewController {

    @IBOutlet weak var enemyShipsView: UIView!
    @IBOutlet weak var shootButton: UIButton!
    
    var sightImageView = UIImageView(image: #imageLiteral(resourceName: "sight"))
    var panGesture = UIPanGestureRecognizer()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panRecognize))
        view.addGestureRecognizer(panGesture)
        
        shootButton.layer.cornerRadius = shootButton.frame.width/2
        shootButton.layer.borderColor = UIColor.blue.cgColor
        shootButton.layer.borderWidth = 1


    }

    
    override func viewDidAppear(_ animated: Bool) {
        refreshEnemyShipsViewController()
        shootButton.isEnabled = true
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        if sea.shootNow == .enemy {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                UIApplication.shared.sendAction( (self.navigationItem.rightBarButtonItem?.action)!, to: self.navigationItem.rightBarButtonItem?.target, from: self, for: nil)
            })
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    
    @IBAction func menuButtonClick(_ sender: Any) {

        var menuItems = ["Start new game"]
        
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
        case 0: // Start new game
            performSegue(withIdentifier: "newGameSegue", sender: self)
  
        default: return
        }
    }


    
    func panRecognize(gesture: UIPanGestureRecognizer) {

        if gesture.state == .began {
            EnemyShips.beginTracking()
            return
        }
       
        EnemyShips.calculateNewSight(for: gesture)
        refreshSightView()
    }
    
    
    
    
    @IBAction func shootButtonClick(_ sender: Any) {
        shootButton.isEnabled = false
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        
        
        
        
        
        
        switch EnemyShips.inSight {
            
            // попадание
        case true:
            sea.enemyMatrix[EnemyShips.sightY][EnemyShips.sightX] = .enemy_hit
            Sound.play(type: .hit)
            
            
            sea.setPerimeter(forShip: .enemy, posX: EnemyShips.sightX, posY: EnemyShips.sightY)
            
           /*
            var shipIndex = 0
            repeat {
                if let cellIndex = sea.enemyShipsCells[shipIndex].cells.index(of: CGPoint(x: EnemyShips.sightX, y: EnemyShips.sightY)) {
                    sea.enemyShipsCells[shipIndex].cells[cellIndex] = CGPoint(x: -1, y: -1)
                    
                    if sea.enemyShipsCells[shipIndex].isSink {
                        for perimetrCell in sea.enemyShipsCells[shipIndex].perimetr {
                            let x = Int (perimetrCell.x)
                            let y = Int (perimetrCell.y)
                            
                            if (x < 0 || x >= sea.dimension ||  y < 0 || y >= sea.dimension) {
                                continue
                            }
                            
                            switch sea.enemyMatrix[y][x] {
                            case .free:
                                sea.enemyMatrix[y][x] = .oil
                            case .miss:
                                sea.enemyMatrix[y][x] = .oil_hit
                            default:
                                break
                            }
                        }
                    }   
                }
                shipIndex += 1
            } while shipIndex < sea.enemyShipsCells.count
        */
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Sound.kLenght), execute: {
                self.shootButton.isEnabled = true
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                // проверка на конец игры
                if sea.liveShipCells(for: .enemy) == 0 {
                    self.showAllert (title: "Победа!", message: "Все вражеские корабли потоплены")
                    
                }
            })
            
            
            
            
            // промах
        case false:
            if sea.enemyMatrix[EnemyShips.sightY][EnemyShips.sightX] == .free {
                sea.enemyMatrix[EnemyShips.sightY][EnemyShips.sightX] = .miss
            }
            if sea.enemyMatrix[EnemyShips.sightY][EnemyShips.sightX] == .oil {
                sea.enemyMatrix[EnemyShips.sightY][EnemyShips.sightX] = .oil_hit
            }
            
            
            Sound.play(type: .miss)
            sea.shootNow = .enemy

            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Sound.kLenght), execute: {
            UIApplication.shared.sendAction( (self.navigationItem.rightBarButtonItem?.action)!, to: self.navigationItem.rightBarButtonItem?.target, from: self, for: nil)
            })

        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.refreshEnemyShipsViewController()
        })
        
        
    }
    
    
    
    // сообщение о победе/поражении
    func showAllert (title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "ОК", style: .default)  { (_) in
            self.performSegue(withIdentifier: "newGameSegue", sender: self)
        }
        
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    
    func refreshSightView() {
        DispatchQueue.main.async {
            self.sightImageView.frame.size.width = self.view.frame.width / CGFloat (sea.dimension)
            self.sightImageView.frame.size.height  = self.view.frame.width / CGFloat (sea.dimension)
            self.sightImageView.frame.origin.x = CGFloat(EnemyShips.sightX) * sea.cellWight
            self.sightImageView.frame.origin.y = CGFloat(EnemyShips.sightY) * sea.cellWight
            
            if self.enemyShipsView.subviews.contains(self.sightImageView) == false {
                self.enemyShipsView.addSubview(self.sightImageView)
            }
            
        }
  
    }
    
    
    
    
    func refreshEnemyShipsViewController() {
        DispatchQueue.main.async {
            self.enemyShipsView.set(forMatrix: .enemy)
        }
        refreshSightView()
    }

    
    
    
    

}
