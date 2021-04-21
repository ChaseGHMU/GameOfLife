//
//  GridView.swift
//  GameOfLife
//
//  Created by Chase Allen on 4/20/21.
//

import UIKit


final class GridView: UIView {
    var grid: Grid = Grid(width: 40, height: 40)
    
    var width: CGFloat {
        return self.bounds.width / 40
    }
    
    var height: CGFloat {
        return self.bounds.height / 40
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        for y in 0..<grid.pieces.count {
            let y_array = grid.pieces[y]
            for x in 0..<y_array.count {
                let cell = grid.pieces[y][x]
                context.setFillColor(cell.colorForCell())
                context.addRect(CGRect(x: CGFloat(x) * width, y: CGFloat(y) * height, width: width, height: height))
                
                context.fillPath()
            }
        }
    }
    
    @objc
    internal func fingerTouched(gesture: UIGestureRecognizer) {
        let coords = gesture.location(in: self)
        
        let x = Int(coords.x / width)
        let y = Int(coords.y / height)
        
        grid.pieces[y][x] = Cell(1)
        setNeedsDisplay()
    }
}
