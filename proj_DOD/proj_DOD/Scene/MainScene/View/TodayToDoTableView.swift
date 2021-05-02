//
//  TodayToDoTableView.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/28.
//

import Foundation
import UIKit

class TodayToDoTableView: UIViewController {
    var todayToDoViewModel: TodayToDoViewModel = TodayToDoViewModel.init(toDoService: ToDoService.factory())
    var todayToDoTableView: UITableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
//        todayToDoTableView.translatesAutoresizingMaskIntoConstraints = false
//        [todayToDoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//         todayToDoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//         todayToDoTableView.topAnchor.constraint(equalTo: view.topAnchor)].forEach{$0.isActive = true}
        todayToDoTableView.frame = view.frame
        view.addSubview(todayToDoTableView)
        todayToDoTableView.registerCell(cellType: TableViewCell.self)
        todayToDoTableView.backgroundColor = .dodWhite1
        todayToDoTableView.delegate = self
        todayToDoTableView.dataSource = self
    }
}

extension TodayToDoTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueCell(indexPath: indexPath)
        cell.setUp(cellViewModel: todayToDoViewModel.cellViewModels(row: 0))
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date: String = todayToDoViewModel.cellViewModels(row: 0).toDoDate
        return date
    }
}
