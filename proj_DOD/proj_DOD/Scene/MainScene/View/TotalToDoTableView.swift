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
    
//    var sectionDate: String = ""
//    var toDoTitle: String = ""
//    var currentStatus: String = ""
    
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
//        toDoTitle = cell.nameLabel.text!
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return totalToDoViewModel.toDoCount
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        sectionDate = totalToDoViewModel.toDoDateInSection[section]
        return totalToDoViewModel.toDoDateInSection[section]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? TableViewCell else { return }
        
        if !cell.select {
            cell.setStatusUnresolved()
            print("UNRESOLVED")
        } else {
            cell.setStatusResolved()
            print("RESOLVED")
        }
    }
}

