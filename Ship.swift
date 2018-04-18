//
//  Ship.swift
//  SeaFight
//
//  Created by Алех on 04.02.18.
//  Copyright © 2018 Алех. All rights reserved.
//

import UIKit
import Foundation


// класс нового корабля, размещаемого на матрице
class Ship {
    
    enum Size: Int {
        case oneCell
        case twoCell
        case threeCell
        case fourCell
    }
    
    // координаты ячеек корабля и периметра
    // битая ячейка корабля устанавливается в -1
    struct Cells {
        var isSink: Bool {
            for cell in cells {
                if cell != CGPoint(x: -1, y: -1) {
                    return false
                }
            }
            return true
        }
        var cells: [CGPoint] = []
        var perimetr: [CGPoint] = []
    }

    struct Mask {
        var widht = 0
        var height = 0
        var originX = 0
        var originY = 0
    }
    
    enum Direction {
        // top to bottom
        case vertical
        // left to right
        case horizontal
    }

    
    var x: Int
    var y: Int
    var lenght: Int
    var direction: Direction
    
    
    // маска
    // возвращает размеры маски: корабль + клетки по периметру
    var mask: Mask {
        return getMask()
    }
    
    

    
    

    
    init (x: Int, y: Int, lenght: Int, direction: Direction) {
        self.x = x
        self.y = y
        self.direction = direction
        self.lenght = lenght
    }
        
    init (lenght: Int) {
        self.x = sea.dimension/2 - 1
        self.y = sea.dimension/2 - 1
        self.direction = .vertical
        self.lenght = lenght
        
    }
  
    
    // возвращает корабль, развернутый на угол
    // поворот по солнцу, против
    func rotate(angle: CGFloat) -> Ship {
        enum Direction {
            case vertical
            case horizontal
        }
        
        let testShip: Ship = Deploy.newShip
    
        switch abs (angle.truncatingRemainder(dividingBy: 360)) {
        case 90..<180:
            
            print ("+90")
            if testShip.direction == .horizontal {
                testShip.direction = .vertical
                testShip.x = testShip.x + testShip.lenght / 2
                testShip.y = testShip.y - testShip.lenght / 2
            } else {
                testShip.direction = .horizontal
                testShip.x = testShip.x - testShip.lenght / 2
                testShip.y = testShip.y + testShip.lenght / 2
            }

        default:
            break
        }
        
        return Ship(x: testShip.x, y: testShip.y, lenght: testShip.lenght, direction: testShip.direction)
        
    }
    
    
    // маска
    // возвращает размеры маски: корабль + клетки по периметру
    fileprivate func getMask() -> Mask {
        var mask = Mask()
        
        mask.originX = self.x - 1
        mask.originY = self.y - 1
        
        switch self.direction {
        case .horizontal:
            mask.widht = self.lenght + 2
            mask.height = 3
        case .vertical:
            mask.height = self.lenght + 2
            mask.widht = 3
        }
        return mask
    }
    
    
    // на матрицу накладывается маска соответствующая размеру корабля + клетки по периметру
    // проверяется, возможно ли установить сюда корабль
    func isConformFor(player: Sea.Turn) -> Bool {
        
        // маска вмещается целиком в матрицу
        
        if y < 0 || y + mask.height - 2 > sea.dimension {
            return false
        }
        if x < 0 || x + mask.widht - 2 > sea.dimension {
            return false
        }

        
        
        // в соответствующей маске матрице нет кораблей
        for y in mask.originY ..< mask.originY + mask.height {
            for x in mask.originX ..< mask.originX + mask.widht {
                if x < 0 || y < 0 {
                    continue
                }
                
                if x >= sea.dimension || y >= sea.dimension  {
                    continue
                }
                
                switch player {
                case .own:
                    if sea.ownMatrix[y][x] != .free {
                        return false
                    }

                case .enemy:
                    if sea.enemyMatrix[y][x] != .free {
                        return false
                    }
                }
                
            }
        }

    return true
    }
    
    
    
    
    
}
