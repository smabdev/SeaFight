//
//  singleton.swift
//  SeaFight
//
//  Created by Алех on 26.01.18.
//  Copyright © 2018 Алех. All rights reserved.
//

import UIKit
import Foundation


class Sea {
    
    struct Settings {
        var seaSizeIndex: Int
        var firstTurnIndex: Int
        var isDebugMode: Bool
    }
    
    enum CellStatus {
        case free
        case miss
        case own
        case own_hit
        case enemy
        case enemy_hit
        case oil
        case oil_hit
    }
    
    enum Turn {
        case own
        case enemy
    }
    

    var cellWight: CGFloat {
        return (UIApplication.shared.keyWindow?.frame.width)! / CGFloat (sea.dimension)
    }
    
    var ownMatrix = [[CellStatus]]()
    var enemyMatrix = [[CellStatus]]()
    
    
    let dimensions = [4, 8, 10, 12, 14, 16 ]
    // количество 1х, 2х, 3х, 4х кораблей
    let shipsCount = [[2, 0, 1, 0], [3, 2, 1, 0], [4, 3, 2, 1], [5, 4, 3, 2], [6, 5, 4, 3], [7, 6, 5, 4]]
    
    // чей ход
    var shootNow: Turn = .own
    
    // для установки значений при возвращении на экран настроек
    var settings = Settings(seaSizeIndex: 1, firstTurnIndex: 0, isDebugMode: true)
    
    var dimension = 10
    
  // ячейки кораблей и их периметров
    var ownShipsCells: [Ship.Cells] = []
    var enemyShipsCells: [Ship.Cells] = []
    
    
    
    private init () { }
    static let shared = Sea()
    
}

let sea = Sea.shared



extension Sea {
    
    // очистка переменных для новой игры
    func reset() {
        sea.ownShipsCells.removeAll()
        sea.enemyShipsCells.removeAll()
        Deploy.resetMatrix(for: .enemy)
        Deploy.resetMatrix(for: .own)

        Deploy.isProccessed = false
    }
    

    
    
    // проверка на конец игры (победа)
    func liveShipCells(for playerType: Sea.Turn) -> Int {
        
        // количество 'живых' клеток
        var enemyCells: Int = 0
        var ownCells: Int = 0
        
       
        for y in 0 ..< sea.dimension {
            for x in 0 ..< sea.dimension {
                
                switch playerType {
                case .enemy:
                    if sea.enemyMatrix[y][x] == .enemy {
                        enemyCells += 1
                    }
                case .own:
                    if sea.ownMatrix[y][x] == .own {
                        ownCells += 1
                    }
                }
            }
        }
        
        switch playerType {
        case .own:
            return ownCells
        case .enemy:
            return enemyCells
        }
        

    }
    
    
    // счетчик пораженных клеток
    func getCount(for playerType: Sea.Turn) -> Int {
        var counter = 0
        
        for y in 0 ..< sea.dimension {
            for x in 0 ..< sea.dimension {
                
                switch playerType {
                case .own:
                    if sea.enemyMatrix[y][x] == .enemy_hit {
                        counter += 1
                    }
                case .enemy:
                    if sea.ownMatrix[y][x] == .own_hit {
                        counter += 1
                    }
                }
            }
        }
        return counter
    }
    
    // вывод матрицы с кораблями в консоль
    func printToConsole(forPlayer player: Sea.Turn) {
        var matrix = Array(repeating: Array(repeating: Sea.CellStatus.free, count: sea.dimension), count: sea.dimension)
        
        switch player {
        case .enemy:
            matrix = sea.enemyMatrix
            print ("enemy matrix")
        case .own:
            matrix = sea.ownMatrix
            print ("own matrix")
        }
        
        print ("\n")
        for y in 0 ..< sea.dimension {
            var str = ""
            for x in 0 ..< sea.dimension {
                if matrix[y][x] == .free {
                    str = str + "0"
                } else {
                    str = str + "X"
                }
            }
            print (str)
        }
    }
    
    
    // отмечает пораженные клетки корабля в sea.enemyShipsCells или sea.ownShipsCells
    // изменяет клетки по периметру потопленного корабля
    
    func setPerimeter(forShip player: Sea.Turn, posX: Int, posY: Int) {
        
        var shipsCells: [Ship.Cells] = []
        var matrix: [[CellStatus]] = []
        
        // по кому стреляют
        switch player {
        case .enemy:
            shipsCells = sea.enemyShipsCells
            matrix = sea.enemyMatrix
        case .own:
            shipsCells = sea.ownShipsCells
            matrix = sea.ownMatrix
        }
        
        
        
        
        var shipIndex = 0
        repeat {
            if let cellIndex = shipsCells[shipIndex].cells.index(of: CGPoint(x: posX, y: posY)) {
                shipsCells[shipIndex].cells[cellIndex] = CGPoint(x: -1, y: -1)
                
                if shipsCells[shipIndex].isSink {
                    for perimetrCell in shipsCells[shipIndex].perimetr {
                        let x = Int (perimetrCell.x)
                        let y = Int (perimetrCell.y)
                        
                        if (x < 0 || x >= sea.dimension ||  y < 0 || y >= sea.dimension) {
                            continue
                        }
                        
                        switch matrix[y][x] {
                        case .free:
                            matrix[y][x] = .oil
                        case .miss:
                            matrix[y][x] = .oil_hit
                        default:
                            break
                        }
                    }
                }
            }
            shipIndex += 1
        } while shipIndex < shipsCells.count
        
        
        switch player {
        case .enemy:
            sea.enemyShipsCells = shipsCells
            sea.enemyMatrix = matrix
        case .own:
            sea.ownShipsCells = shipsCells
            sea.ownMatrix = matrix
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
}





