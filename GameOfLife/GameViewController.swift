//
//  GameViewController.swift
//  GameOfLife
//
//  Created by Chase Allen on 4/20/21.
//

import UIKit

final class GameViewController: UIViewController {
    
    private lazy var gridView: GridView = lazyGridView()
    private lazy var startButton: UIButton = lazyStartButton()
    private lazy var generationLabel: UILabel = lazyGenerationLabel()
    private lazy var timer: GameTimer = lazyGameTimer()
    
    
    private lazy var stackView: UIStackView = lazyStackView(items: [generationLabel, startButton])
    
    var generation: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Game Of Life"

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(menuTapped))
        view.backgroundColor = .systemBlue
        initializeView()
    }
    
    private func initializeView() {
        self.view.addSubview(gridView)
        self.view.addSubview(stackView)
        
        
        let guide = view.readableContentGuide
        
        NSLayoutConstraint.activate([
            gridView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 50),
            gridView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            gridView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            gridView.heightAnchor.constraint(lessThanOrEqualToConstant: view.bounds.height / 2).withPriority(.required - 1),
            stackView.topAnchor.constraint(equalTo: gridView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        ])
        
        gridView.setNeedsDisplay()
    }
}

extension GameViewController {
    @objc
    private func startGame() {
        self.timer.toggleState()
        
        switch self.timer.currentState {
            case .running:
                startButton.isSelected = true
                gridView.isUserInteractionEnabled = false
            case .paused:
                startButton.isSelected = false
                gridView.isUserInteractionEnabled = true
        }
    }
    
    @objc
    private func menuTapped() {
        print("Menu Tapped")
    }
    
    @objc
    private func fingerDragged(_ gesture: UIGestureRecognizer) {
        gridView.fingerTouched(gesture: gesture)
    }
}

extension GameViewController {
    private func lazyGridView() -> GridView {
        let grid = GridView()
        grid.isUserInteractionEnabled = true
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(fingerDragged(_:)))
        grid.addGestureRecognizer(recognizer)
        grid.translatesAutoresizingMaskIntoConstraints = false
        
        return grid
    }
    
    private func lazyStartButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Start Game", for: .normal)
        button.setTitle("Stop Game", for: .selected)
        button.setTitleColor(.systemGreen, for: .normal)
        button.setTitleColor(.systemRed, for: .selected)
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    private func lazyGenerationLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Generation: 0"
        return label
    }
    
    private func lazyGameTimer() -> GameTimer {
        let timer = GameTimer {
            self.gridView.grid.generation()
            self.generation += 1
            DispatchQueue.main.async {
                self.generationLabel.text = "Generation: \(self.generation)"
                self.generationLabel.setNeedsDisplay()
                self.gridView.setNeedsDisplay()
            }
        }
        
        return timer
    }
    
    private func lazyStackView<T: UIView>(items: [T]) -> UIStackView {
        let stackView = UIStackView()
        items.forEach { (view) in
            stackView.addArrangedSubview(view)
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }
}


extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint{
        self.priority = priority
        
        return self
    }
}
