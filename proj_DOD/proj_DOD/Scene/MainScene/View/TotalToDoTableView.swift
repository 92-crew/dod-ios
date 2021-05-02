//
//  TotalToDoTableView.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/28.
//

import Foundation
import UIKit

class TotalToDoTableView: UIViewController {
    var totalToDoViewModel: TotalToDoViewModel = TotalToDoViewModel.init(toDoService: ToDoService.factory())
    var totalToDoTableView: UITableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        totalToDoTableView.frame = view.frame
        view.addSubview(totalToDoTableView)
        totalToDoTableView.registerCell(cellType: TableViewCell.self)
        totalToDoTableView.delegate = self
        totalToDoTableView.dataSource = self
    }
}

extension TotalToDoTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalToDoViewModel.toDoCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueCell(indexPath: indexPath)
        cell.setUp(cellViewModel: totalToDoViewModel.cellViewModels(row: indexPath.row))
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return totalToDoViewModel.toDoCount
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return totalToDoViewModel.toDoDateInSection[section]
    }
    
}

