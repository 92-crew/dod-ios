//
//  TodayToDoTableView.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/28.
//

import Foundation
import UIKit
class TodayToDoTableView: UIViewController {
    private let editViewController: UIViewController = EditViewController()
    private let evc: EditViewController = EditViewController()
    var todayToDoViewModel: TodayToDoViewModel = TodayToDoViewModel.init(toDoService: ToDoService.factory())
    var todayToDoTableView: UITableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        todayToDoTableView.frame = view.frame
        view.addSubview(todayToDoTableView)
        todayToDoTableView.registerCell(cellType: TableViewCell.self)
        todayToDoTableView.backgroundColor = .dodWhite1
        todayToDoTableView.delegate = self
        todayToDoTableView.dataSource = self
        todayToDoTableView.separatorStyle = TableViewCell.SeparatorStyle.none
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGesture:)))
        longPressGesture.minimumPressDuration = 1.0
        self.todayToDoTableView.addGestureRecognizer(longPressGesture)
        
    }
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let popUp = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: {(action: UIAlertAction!) in
                                        let editVC = EditViewController()
                                        editVC.willEditedTodo = self.todayToDoViewModel.toDo
                                        print(editVC.willEditedTodo as Any)
                                        self.show(editVC, sender: nil)})
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        popUp.addAction(editAction)
        popUp.addAction(deleteAction)
        popUp.addAction(cancelAction)
        
        let p = longPressGesture.location(in: self.todayToDoTableView)
        let indexPath = self.todayToDoTableView.indexPathForRow(at: p)
        if indexPath == nil {
            print("Long press on tbv, not row")
        } else if longPressGesture.state == UIGestureRecognizer.State.began {
            print("Long press on row, at \(indexPath!.row)")
            present(popUp, animated: true, completion: nil)
        }
    }
}

extension TodayToDoTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueCell(indexPath: indexPath)
        cell.setUp(cellViewModel: todayToDoViewModel.cellViewModels(row: 0))
        cell.backgroundColor = .dodWhite1
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? TableViewCell else { return }
        if cell.select {
            cell.setStatusUnresolved()
            print("UNRESOLVED")
        } else {
            cell.setStatusResolved()
            print("RESOLVED")
        }
    }
}
