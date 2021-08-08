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
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        return canvasView
    }()

    private lazy var toolPicker: PKToolPicker = {
        let toolPicker = PKToolPicker()
        return toolPicker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        setupViews()
        setupToolPicker()

        navigationItem.title = "My Canvas"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(handleClearCanvas))
    }

    @objc func handleClearCanvas() {
        canvasView.drawing = PKDrawing()
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
