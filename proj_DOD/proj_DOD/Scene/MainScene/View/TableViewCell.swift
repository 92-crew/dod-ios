//
//  TableViewCell.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/22.
//

import Foundation
import UIKit
class TableViewCell: UITableViewCell {
    var nameLabel: UILabel = UILabel()
    var select: Bool = false
    var checkbox: DODCheckBoxView = DODCheckBoxView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView() {
        self.addSubview(nameLabel)
        self.addSubview(checkbox)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        [checkbox.centerYAnchor.constraint(equalTo: self.centerYAnchor),
         checkbox.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
         checkbox.widthAnchor.constraint(equalToConstant: 20),
         checkbox.heightAnchor.constraint(equalToConstant: 20)].forEach{$0.isActive = true}
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        [nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
         nameLabel.leadingAnchor.constraint(equalTo: self.checkbox.leadingAnchor, constant: 40),
         nameLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)].forEach{$0.isActive = true}
    }
    
    func setUp(cellViewModel: ToDoCellViewModel) {
        nameLabel.text = cellViewModel.toDoTitle
    }
    func setStatusUnresolved() {
        select = false
        checkbox.isSelected = select
        checkbox.check()
        
        nameLabel.textColor = .black
        let attributeStr: NSMutableAttributedString = NSMutableAttributedString(string: nameLabel.text!)
        attributeStr.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeStr.length))
        nameLabel.attributedText = attributeStr
    }
    func setStatusResolved() {
        select = true
        checkbox.isSelected = select
        checkbox.check()
        
        nameLabel.textColor = .dodWhite2
        let attributeStr: NSMutableAttributedString = NSMutableAttributedString(string: nameLabel.text!)
        attributeStr.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeStr.length))
        nameLabel.attributedText = attributeStr
    }
}
extension UITableView {
    func registerCell(cellType: UITableViewCell.Type, reuseIdentifier: String? = nil){
        let reuseIdentifier = reuseIdentifier ?? String(describing: cellType.self)
        self.register(cellType, forCellReuseIdentifier: reuseIdentifier)
    }
    func dequeueCell<T: UITableViewCell>(reuseIdentifier: String? = nil, indexPath: IndexPath) -> T {
        let reuseIdentifier = reuseIdentifier ?? String(describing: T.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueCell(indexPath: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
}
