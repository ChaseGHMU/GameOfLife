//
//  Grid.swift
//  GameOfLife
//
//  Created by Chase Allen on 4/20/21.
//

import Foundation

struct Grid {
    private let width: Int
    private let height: Int
    var pieces: [[Cell]]
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        
        self.pieces = Array(repeating: Array(repeating: Cell(state: .dead), count: width), count: height)
        self.randomizeBoard()
    }
    
    mutating func randomizeBoard() {
        for y in 0..<self.pieces.count {
            let y_array = self.pieces[y]
            for x in 0..<y_array.count {
                self.pieces[y][x] = Cell(0)
            }
        }
    }
    
    mutating func generation() {
        var newArray: [[Cell]] = pieces
        
        for y in 0..<self.pieces.count {
            let y_array = self.pieces[y]
            for x in 0..<y_array.count {
                let sum = checkNeighbors(x: x, y: y)
                if sum == 3 {
                    newArray[y][x].setState(.alive)
                } else if sum > 3 || sum < 2 {
                    newArray[y][x].setState(.dead)
                } else {
                    newArray[y][x] = pieces[y][x]
                    newArray[y][x].generationsAlive += 1
                }
            }
        }

        pieces = newArray
    }
    
    private func checkNeighbors(x: Int, y: Int) -> Int {
        var sum = 0
        for i in -1...1 {
            for j in -1...1 {
                let wrappedY = (i + y + height) % height
                let wrappedX = (j + x + width) % width
                
                sum = sum + pieces[wrappedY][wrappedX].value
            }
            
        }
        sum = sum - pieces[y][x].value
        return sum
    }
}
