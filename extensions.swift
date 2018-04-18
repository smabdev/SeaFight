//
//  extension.swift
//  SeaFight
//
//  Created by Алех on 28.01.18.
//  Copyright © 2018 Алех. All rights reserved.
//

import UIKit
import Foundation



extension UIView {
    
    // возвращает view с изображением состояния
    func set(forMatrix matrixType: Sea.Turn) {
        
        // очистка матрицы
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        
        // размеры клетки поля
        let dotSize = CGSize(width: sea.cellWight, height: sea.cellWight)
        
        // создание view с клетками матрицы
        for y in 0 ..< sea.dimension {
            for x in 0 ..< sea.dimension {
                let origin = CGPoint(x: CGFloat(x) * sea.cellWight, y: CGFloat(y) * sea.cellWight)
                
                let newDotView = UIImageView(frame: CGRect(origin: origin, size: dotSize))
                newDotView.tag = y*8 + x
                
                if matrixType == .enemy {
                    switch sea.enemyMatrix[y][x]  {
                    case .miss:
                        newDotView.image = #imageLiteral(resourceName: "miss")
                        
                    // в отладочном режиме видны корабли противника 
                    case .enemy:
                        if sea.settings.isDebugMode {
                            newDotView.image = #imageLiteral(resourceName: "enemy")
                        } else {
                            newDotView.image = #imageLiteral(resourceName: "freeCell")
                        }
                        
                    case .enemy_hit:
                        newDotView.image = #imageLiteral(resourceName: "enemy_hit")
                    case .oil:
                        newDotView.image = #imageLiteral(resourceName: "oil")
                    case .oil_hit:
                        newDotView.image = #imageLiteral(resourceName: "oil_hit")
                    default:
                        newDotView.image = #imageLiteral(resourceName: "freeCell")
                    }
                    
                    
                } else {
                    switch sea.ownMatrix[y][x]  {
                    case .miss:
                        newDotView.image = #imageLiteral(resourceName: "miss")
                    case .own:
                        newDotView.image = #imageLiteral(resourceName: "own_ship")
                    case .own_hit:
                        newDotView.image = #imageLiteral(resourceName: "own_hit")
                    case .oil:
                        newDotView.image = #imageLiteral(resourceName: "oil")
                    case .oil_hit:
                        newDotView.image = #imageLiteral(resourceName: "oil_hit")
                    default:
                        newDotView.image = #imageLiteral(resourceName: "freeCell")
                        
                    }
                }
                self.addSubview(newDotView)
            }
        }
        
        
        // добавление view размещаемого на матрице корабля (если в режиме размещения)
        if Deploy.isProccessed {
            let origin = CGPoint(x: CGFloat(Deploy.newShip.x) * sea.cellWight, y:   CGFloat(Deploy.newShip.y) * sea.cellWight)
            let size = CGSize(width: CGFloat(Deploy.newShip.mask.widht - 2) * sea.cellWight, height:    CGFloat(Deploy.newShip.mask.height - 2) * sea.cellWight)
            
            Deploy.newShipView = UIView(frame: CGRect(origin: origin, size: size))
            
            if Deploy.newShip.isConformFor(player: .own) {
                Deploy.newShipView.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
            } else {
                Deploy.newShipView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
            }
            
            
            if Deploy.newShipView != nil {
                self.addSubview(Deploy.newShipView)
            }
        }
        
        
        
        
        
        
    }
    
}




