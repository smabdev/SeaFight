//
//  Deploy.swift
//  SeaFight
//
//  Created by Алех on 27.01.18.
//  Copyright © 2018 Алех. All rights reserved.
//

import UIKit
import Foundation


class Deploy {

    // количество кораблей 1x, 2x, 3x, 4x для установки на матрицу
    static var shipsCount = [0, 0, 0, 0]


    // происходит выбор места установки нового корабля
    static var isProccessed = false
    
    static var newShip: Ship!
    static var newShipView: UIView!
    
    // базовые координаты корабля при перемещении
    static var oldPosX: Int!
    static var oldPosY: Int!
    
    
    
    
    static func reset() {
        Deploy.resetMatrix(for: .enemy)
        Deploy.resetMatrix(for: .own)
        sea.ownShipsCells.removeAll()
        sea.enemyShipsCells.removeAll()
        Deploy.shipsCount = sea.shipsCount[sea.settings.seaSizeIndex]
        Deploy.isProccessed = false
    }
    
    
    
    
    
    // сохранение старой позиции при перемещении размещаемого корабля
    static func beginTracking() {
        oldPosX = newShip.x
        oldPosY = newShip.y
    }
    
    // новая позиция при перемещении размещаемого корабля
    static func calculateNewPos(forTranslation translation: CGPoint) {
        
        let transitionX = Int (translation.x / sea.cellWight)
        let transitionY = Int (translation.y / sea.cellWight)
        
        switch (oldPosX + transitionX) {
        case -999...0:
            newShip.x = 0
        case (sea.dimension - (newShip.mask.widht - 2))...999:
            newShip.x = sea.dimension - (newShip.mask.widht - 2)
        default:
            newShip.x = oldPosX + transitionX
        }
        
        switch (oldPosY + transitionY) {
        case -999...0:
            newShip.y = 0
        case (sea.dimension - (newShip.mask.height - 2))...999:
            newShip.y = sea.dimension - (newShip.mask.height - 2)
        default:
            newShip.y = oldPosY + transitionY
        }
        
        print (newShip.x.description + "-" + newShip.y.description)
    }
    
    
    
    
    // сброс матрицы и количества кораблей
    static func resetMatrix(for player: Sea.Turn) {
        let index = sea.dimensions.index(of: sea.dimension)!
        for index2 in 0 ..< shipsCount.count {
            shipsCount[index2] = sea.shipsCount[index][index2]
        }
        
        switch player {
        case .own:
            sea.ownMatrix = Array(repeating: Array(repeating: Sea.CellStatus.free, count: sea.dimension), count: sea.dimension)
        case .enemy:
            sea.enemyMatrix = Array(repeating: Array(repeating: Sea.CellStatus.free, count: sea.dimension), count: sea.dimension)
        }
        
    }
    
    

    
    
    
    // случайное размещение необходимого количества кораблей на матрице
    static func random(for player: Sea.Turn) {

        var index = shipsCount.count - 1
        repeat {
            while shipsCount[index] != 0 {
                setShip(withSize: Ship.Size(rawValue: index)!, forPlayer: player)
                shipsCount[index] -= 1
            }
            index -= 1
        } while index >= 0
        
        sea.printToConsole(forPlayer: .enemy)
    }
    

    
    // на матрицу накладывается маска соответствующая размеру корабля + клетки по периметру
    // если поле свободно - корабль устанавливается
    // если поле занято - ищется новое
    private static func setShip(withSize shipSize: Ship.Size, forPlayer player: Sea.Turn) {
        
        newShip = Ship(lenght: shipSize.rawValue + 1)
        
        // поиск места для установки корабля
        repeat {
            // рандомный выбор расположения корабля горизонтально/вертикально
            if arc4random() % 2 == 0 {
                newShip.direction = .vertical
            } else {
                newShip.direction = .horizontal
            }
            
            // случайные координаты начала корабля
            newShip.x = Int(arc4random() % UInt32(sea.dimension))
            newShip.y = Int(arc4random() % UInt32(sea.dimension))
            
            print (newShip.x.description + "-" + newShip.y.description)
            
        } while newShip.isConformFor(player: player) != true
        
        Deploy.onMatrix(forPlayer: player)
    }

    
    
    // установка корабля на матрицу
    // создание массива с данными на корабли (клетки кораблей и периметров)
    static func onMatrix(forPlayer player: Sea.Turn) {
    
        var shipCells: [CGPoint] = []
        var perimeterCells: [CGPoint] = []
        
        switch newShip.direction {
        case .horizontal:
            for index in newShip.x ..< newShip.x + newShip.lenght {
                if player == .own {
                    sea.ownMatrix[newShip.y][index] = .own
                } else {
                    sea.enemyMatrix[newShip.y][index] = .enemy
                }
                shipCells.append(CGPoint(x: index, y: newShip.y))
            }
            
            // массив точек периметра для горизонтального расположения
            for x in 0 ..< newShip.mask.widht {
                perimeterCells.append(CGPoint(x: newShip.mask.originX + x, y: newShip.mask.originY))
                perimeterCells.append(CGPoint(x: newShip.mask.originX + x, y: newShip.mask.originY + 2))
            }
            perimeterCells.append(CGPoint(x: newShip.mask.originX, y: newShip.mask.originY + 1))
            perimeterCells.append(CGPoint(x: newShip.mask.originX + newShip.mask.widht - 1, y: newShip.mask.originY + 1))
            
            
        case .vertical:
            for index in newShip.y ..< newShip.y + newShip.lenght {
                if player == .own {
                    sea.ownMatrix[index][newShip.x] = .own
                } else {
                    sea.enemyMatrix[index][newShip.x] = .enemy
                }
                shipCells.append(CGPoint(x: newShip.x, y: index))
            }
            
            // массив точек периметра для вертикального расположения
            for y in 0 ..< newShip.mask.height {
                perimeterCells.append(CGPoint(x: newShip.mask.originX , y: newShip.mask.originY + y))
                perimeterCells.append(CGPoint(x: newShip.mask.originX + 2, y: newShip.mask.originY + y))
            }
            perimeterCells.append(CGPoint(x: newShip.mask.originX + 1, y: newShip.mask.originY))
            perimeterCells.append(CGPoint(x: newShip.mask.originX + 1, y: newShip.mask.originY + newShip.mask.height - 1))
        }
        

        switch player {
        case .enemy:
            sea.enemyShipsCells.append(Ship.Cells(cells: shipCells, perimetr: perimeterCells))
        case .own:
            sea.ownShipsCells.append(Ship.Cells(cells: shipCells, perimetr: perimeterCells))

        }
        
        
        
        
 
    }


    
    // установка кораблей вручную
    static func newShip(withSize size: Ship.Size) {
        isProccessed = true
        newShip = Ship(lenght: size.rawValue + 1)
        
    }
    




    
    
    
    
    
}






