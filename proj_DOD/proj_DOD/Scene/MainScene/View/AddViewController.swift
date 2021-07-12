//
//  AddViewController.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/05/02.
//

import Foundation
import UIKit

class AddViewController: UIViewController {
    var dataService: DataService = DataService.shared
    var scrollView: UIScrollView = UIScrollView()
    var contentView: UIView = UIView()
    var titleTextField: DODTextfieldView = DODTextfieldView()
    var datePicker: UIDatePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    var selectedDate: String = Date().toString()
    var addViewModel: AddViewModel = AddViewModel()
    var arrow: UIImage = UIImage(named: "backarrow")!
    let navDoneItem: UIBarButtonItem = UIBarButtonItem()
    var addToDo: UILabel = {
        let lbl = UILabel()
        lbl.text = "할 일 추가"
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textColor = .black
        return lbl
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.setNeedsDisplay()
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
            lbl.text = "할 일"
            lbl.font = UIFont.boldSystemFont(ofSize: 15)
            return lbl
        }()
        
        let datePickerLabel: UILabel = {
            let lbl = UILabel()
            lbl.text = "완료 예정일"
            lbl.font = UIFont.boldSystemFont(ofSize: 15)
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
            titleTextField.topAnchor.constraint(equalTo: inputTitleLabel.bottomAnchor, constant: 15),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: 30)
        ])
        titleTextField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        titleTextField.backgroundColor = .dodWhite1
        
        datePickerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePickerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            datePickerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            datePickerLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 40)
        ])
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: datePickerLabel.bottomAnchor, constant: 15),
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        let loc = Locale(identifier: "ko_KR")
        datePicker.locale = loc
        datePicker.tintColor = .dodRed1
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.setValue(UIColor.dodRed1, forKey: "textColor")
        datePicker.setValue(1, forKey: "alpha")
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = datePicker.date.toString()
        print(selectedDate)
    }
    private func setNavigationBar() {
        let navBar = self.navigationController!.navigationBar
        navBar.tintColor = .black
        navBar.backgroundColor = .dodWhite1
        let navItem = self.navigationItem
        let newImage = arrow.resizedImage(to: CGSize(width: 20, height: 16))
        let navDoneItem = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(doneButtonTapped(_:)))
        let navCancelItem = UIBarButtonItem(image: newImage, style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelButtonTapped(_:)))
        navItem.setLeftBarButton(navCancelItem, animated: true)
        navItem.setRightBarButton(navDoneItem, animated: true)
        navItem.rightBarButtonItem?.isEnabled = false
        navItem.titleView = addToDo
        
    }
    @objc func textChanged(_ sender: UITextField) {
         if titleTextField.text?.count == 0 {
             print(#function)
             self.navigationItem.rightBarButtonItem?.isEnabled = false
         } else {
             self.navigationItem.rightBarButtonItem?.isEnabled = true
         }
    }
    @objc func doneButtonTapped(_ sender: UIBarButtonItem!){
        let title: String = titleTextField.text!
        let date: String = selectedDate
        let status: String = "UNRESOLVED"
        dataService.createTodo(toDo: .init(id: -1, memberID: -1, title: title, status: status, dueDate: date))
        titleTextField.text = ""
        print(title, date, status)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func cancelButtonTapped(_ sender: UIBarButtonItem!){
        self.navigationController?.popViewController(animated: true)
    }
}

