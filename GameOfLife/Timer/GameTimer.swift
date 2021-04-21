//
//  GameTimer.swift
//  GameOfLife
//
//  Created by Chase Allen on 4/20/21.
//

import Foundation

final class GameTimer {
    enum TimerState {
        case running
        case paused
    }
    
    private let timer: DispatchSourceTimer
    private(set) var currentState: TimerState = .paused
    
    init(handler: @escaping ()->Void) {
        self.timer = DispatchSource.makeTimerSource()
        timer.schedule(deadline: .now(), repeating: .milliseconds(250))
        
        timer.setEventHandler(handler: handler)
    }
    
    func toggleState() {
        switch self.currentState {
            case .paused:
                timer.resume()
                self.currentState = .running
                
            case .running:
                timer.suspend()
                self.currentState = .paused
        }
    }
    
}
