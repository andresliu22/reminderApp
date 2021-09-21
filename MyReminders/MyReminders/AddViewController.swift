//
//  AddViewController.swift
//  MyReminders
//
//  Created by Andres Liu on 8/5/21.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    public var completion: ((String, String, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "New Reminder"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
        
        titleField.delegate = self
        bodyField.delegate = self
        
        titleField.placeholder = "Enter title..."
        bodyField.placeholder = "Enter body..."
        
        //datePicker.datePickerMode = .dateAndTime
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleField {
            bodyField.becomeFirstResponder()
        } else {
            bodyField.resignFirstResponder()
            didTapSave()
        }
        return true
    }

    @objc func didTapSave() {
        let date = datePicker.date
        
        guard let title = titleField.text, let body = bodyField.text, !title.isEmpty, !body.isEmpty, date.timeIntervalSinceNow > 0 else {
            return
        }
        completion?(title, body, date)
        
    }
}
