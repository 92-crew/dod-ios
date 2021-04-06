//
//  MainTableViewCell.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/06.
//

import Foundation
import UIKit
class MainTableViewCell: UITableViewCell {
    var toDoLabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setText(cellViewModel: MainCellViewModel) {
        
    }
}
