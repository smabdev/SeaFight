//
//  ViewController.swift
//  SeaFight
//
//  Created by Алех on 26.01.18.
//  Copyright © 2018 Алех. All rights reserved.
//

import UIKit
import Foundation



class OwnShipsViewController: UIViewController {


    
    @IBOutlet weak var youCountLabel: UILabel!
    @IBOutlet weak var enemyCountLabel: UILabel!
    @IBOutlet weak var ownShipsView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshOwnShipsViewController()
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    override func viewDidAppear(_ animated: Bool) {
        if sea.shootNow == .enemy {
            navigationItem.backBarButtonItem?.isEnabled = false
            enemyShoot ()
        } else {
            navigationItem.backBarButtonItem?.isEnabled = true
        }
       
    }
    

    
    
    
    func enemyShoot () {
        var randomX: Int
        var randomY: Int
        
        // если должен стрелять компьютер

            repeat {
                randomX = Int(arc4random() % UInt32(sea.dimension))
                randomY = Int(arc4random() % UInt32(sea.dimension))
            } while sea.ownMatrix[randomY][randomX] != .own && sea.ownMatrix[randomY][randomX] != .free
        
            sea.setPerimeter(forShip: .own, posX: randomX, posY: randomY)
        
        
            
            switch sea.ownMatrix[randomY][randomX] {
            // компьютер промахнулся
            case .free:
                sea.ownMatrix[randomY][randomX] = .miss
                Sound.play(type: .miss)
                sea.shootNow = .own
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Sound.kLenght), execute: {
                    _ = self.navigationController?.popViewController(animated: true)
                })
                
            // компьютер попал
            case .own:
                sea.ownMatrix[randomY][randomX] = .own_hit
                Sound.play(type: .hit)
                
                // проверка на конец игры
                if sea.liveShipCells(for: .own) == 0 {
                    showAllert (title: "Поражение!", message: "Все ваши корабли потоплены")

                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Sound.kLenght), execute: {
                        self.enemyShoot ()
                    })
                }

                
            default:
                break
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.refreshOwnShipsViewController()
            })
            
      
    }
    
    
    func showAllert (title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "ОК", style: .default)  { (_) in
            self.performSegue(withIdentifier: "newGameSegue2", sender: self)
        }
        
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    func refreshOwnShipsViewController() {

        DispatchQueue.main.async {
            self.ownShipsView.set(forMatrix: .own)
            self.youCountLabel.text = sea.getCount(for: .own).description
            self.enemyCountLabel.text = sea.getCount(for: .enemy).description
        }
    }
    
  
    
}















    
    
    
    
    
    
    
    


