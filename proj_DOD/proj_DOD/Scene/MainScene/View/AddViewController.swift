//
//  AddViewController.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/05/02.
//

import Foundation
import UIKit

class AddViewController: UIViewController {
    var scrollView: UIScrollView = UIScrollView()
    var contentView: UIView = UIView()
    var titleTextField: UITextField = UITextField()
    var datePicker: UIDatePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    var selectedDate: String = Date().toString()
    var addViewModel: AddViewModel = AddViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func loadView() {
        super.loadView()
        setNavigationBar()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .dodWhite1
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .dodWhite1
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20)
        ])
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 6/7)
        ])
        
        let heightConstraint = contentView.heightAnchor.constraint(equalTo: view.heightAnchor)
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true
        
        let inputTitleLabel: UILabel = {
            let lbl = UILabel()
            lbl.text = "Input To Do"
            return lbl
        }()
        
        let datePickerLabel: UILabel = {
            let lbl = UILabel()
            lbl.text = "Choose Date"
            return lbl
        }()
        contentView.addSubview(inputTitleLabel)
        contentView.addSubview(datePickerLabel)
        contentView.addSubview(titleTextField)
        contentView.addSubview(datePicker)
        
        inputTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            inputTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            inputTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: inputTitleLabel.bottomAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: 30)
        ])
        titleTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        titleTextField.backgroundColor = .dodWhite2
        
        datePickerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePickerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            datePickerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            datePickerLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor)
        ])
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: datePickerLabel.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 50),
            datePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        
    }
    @objc func textChanged(_ sender: UITextField) {
        if titleTextField.text?.count == 0 {
            print(#function)
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = datePicker.date.toString()
        print(selectedDate)
    }
    private func setNavigationBar() {
        let navBar = self.navigationController!.navigationBar
        navBar.backgroundColor = .dodWhite1
        navBar.tintColor = .black
        let navItem = self.navigationItem
        let navDoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(_:)))
        let navCancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped(_:)))
        navItem.setLeftBarButton(navCancelItem, animated: true)
        navItem.setRightBarButton(navDoneItem, animated: true)
        navItem.rightBarButtonItem?.isEnabled = false
        navItem.title = "Add To Do"
    }
    
    
    @objc func doneButtonTapped(_ sender: UIBarButtonItem!){
        let title: String = titleTextField.text!
        let date: String = selectedDate
        let status: String = "UNRESOLVED"
        print(title, date, status)
    }
    @objc func cancelButtonTapped(_ sender: UIBarButtonItem!){
        self.navigationController?.popViewController(animated: true)
    }
}

