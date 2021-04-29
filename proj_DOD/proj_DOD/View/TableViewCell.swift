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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView() {
        
    }
    func setUp(cellViewModel: ToDoCellViewModel) {
        nameLabel.text = cellViewModel.toDoTitle
    }
}
extension UITableView {
    func registerCell(cellType: UITableViewCell.Type, reuseIdentifier: String? = nil) {
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
