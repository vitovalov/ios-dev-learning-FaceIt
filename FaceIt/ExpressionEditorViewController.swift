//
//  ExpressionEditorViewController.swift
//  FaceIt
//
//  Created by Vito on 29/05/2017.
//  Copyright © 2017 Vito. All rights reserved.
//

import UIKit

// Instructor told that he tend to not name his Static tableVCs with word TableVC
class ExpressionEditorViewController: UITableViewController, UITextFieldDelegate {
    
    var name: String {
        return nameTextField?.text ?? ""
    }
    
    private let eyeChoices = [FacialExpression.Eyes.open, .closed, .squinting]
    
    private let mouthChoices = [FacialExpression.Mouth.frown, .smirk, .neutral, .grin, .smile]
    
    var expression: FacialExpression {
        return FacialExpression(
            eyes: eyeChoices[eyeControl?.selectedSegmentIndex ?? 0],
            mouth: mouthChoices[mouthControl?.selectedSegmentIndex ?? 0])
    }
    
    @IBAction func updateFace(_ sender: Any) {
        print("\(name) = \(expression)")
        faceViewController?.expression = expression
    }
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var eyeControl: UISegmentedControl!
    
    @IBOutlet weak var mouthControl: UISegmentedControl!
    
    private var faceViewController: BlinkingViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Embed Face" {
            faceViewController = segue.destination as? BlinkingViewController
            faceViewController?.expression = expression
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return tableView.bounds.size.width
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
    
}
