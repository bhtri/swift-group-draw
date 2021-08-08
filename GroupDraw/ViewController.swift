//
//  ViewController.swift
//  GroupDraw
//
//  Created by bht on 2021/08/09.
//

import UIKit
import PencilKit

class ViewController: UIViewController {

    private lazy var canvasView: PKCanvasView = {
        let canvasView = PKCanvasView()
        canvasView.drawingPolicy = .anyInput
        canvasView.delegate = self
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        return canvasView
    }()

    private lazy var toolPicker: PKToolPicker = {
        let toolPicker = PKToolPicker()
        return toolPicker
    }()

    private lazy var undoBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "arrow.uturn.backward"), style: .plain, target: self, action: #selector(handleUndoStroke))
        button.isEnabled = false
        return button
    }()

    private lazy var redoBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "arrow.uturn.forward"), style: .plain, target: self, action: #selector(handleRedoStroke))
        button.isEnabled = false
        return button
    }()

    private var removedStrokes = [PKStroke]() {
        didSet {
            undoBarButtonItem.isEnabled = !canvasView.drawing.strokes.isEmpty
            redoBarButtonItem.isEnabled = !removedStrokes.isEmpty
        }
    }

    private var isAddedNewStroke = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        setupViews()
        setupToolPicker()

        navigationItem.title = "My Canvas"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(handleClearCanvas))
        navigationItem.rightBarButtonItems = [redoBarButtonItem, undoBarButtonItem]
    }

    @objc func handleUndoStroke() {
        if !canvasView.drawing.strokes.isEmpty {
            let stroke = canvasView.drawing.strokes.removeLast()
            removedStrokes.append(stroke)
        }
    }

    @objc func handleRedoStroke() {
        if !removedStrokes.isEmpty {
            let stroke = removedStrokes.removeLast()
            canvasView.drawing.strokes.append(stroke)
        }
    }

    @objc func handleClearCanvas() {
        canvasView.drawing = PKDrawing()
        removedStrokes.removeAll()
    }

    private func setupToolPicker() {
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
    }

    private func setupViews() {
        view.addSubview(canvasView)

        canvasView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        canvasView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        canvasView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        canvasView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

}

extension ViewController: PKCanvasViewDelegate {
    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        isAddedNewStroke = true
    }

    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        if isAddedNewStroke {
            isAddedNewStroke = false
            removedStrokes.removeAll()
        }
    }
}
