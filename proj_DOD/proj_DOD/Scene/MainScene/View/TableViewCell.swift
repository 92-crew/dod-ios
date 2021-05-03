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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView() {
        self.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        [nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
         nameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
         nameLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)].forEach{$0.isActive = true}
    }
    func setUp(cellViewModel: ToDoCellViewModel) {
        nameLabel.text = cellViewModel.toDoTitle
    }
    func setStatusResolved() {
        select = false
        nameLabel.textColor = .black
    }
    func setStatusUnresolved() {
        select = true
        nameLabel.textColor = .dodWhite2
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
        cell.contentView.backgroundColor = .dodNavy1
//        cell.setText(cellViewModel: self.v)
        return cell
    }
    
}
