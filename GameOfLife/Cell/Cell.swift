//
//  Cell.swift
//  GameOfLife
//
//  Created by Chase Allen on 4/20/21.
//

import UIKit

struct Cell {
    var generationsAlive = 0
    var currentState: CellState
    var value: Int {
        return currentState.rawValue
    }
    
    enum CellState: Int {
        case dead = 0
        case alive = 1
    }
    
    init(state: CellState) {
        self.currentState = state
    }
    
    init(_ number: Int) {
        currentState = CellState(rawValue: number) ?? .dead
    }
    
    mutating func setState(_ state: Cell.CellState) {
        guard state != currentState else {
            generationsAlive += 1
            return
        }
        generationsAlive = 0
        currentState = state
    }
    
    func colorForCell() -> CGColor {
        switch currentState {
            case .dead:
                return UIColor.black.cgColor
            case .alive:
                return aliveColor().cgColor
        }
    }
    
    func aliveColor() -> UIColor {
        switch generationsAlive {
            case 0...1:
                return .white
            case 2:
                return .cyan
            case 3:
                return .magenta
            case 4:
                return .purple
            default:
                return .red
        }
    }
}
