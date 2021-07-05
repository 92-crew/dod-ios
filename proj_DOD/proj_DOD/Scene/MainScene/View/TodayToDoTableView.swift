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
    var dataService: DataService = DataService.shared
    var todayToDoViewModel: TodayToDoViewModel = TodayToDoViewModel.init(dataService: DataService.shared)
    var todayToDoTableView: UITableView = UITableView()
    var toDoArr: [Todo] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        todayToDoTableView.frame = view.frame
        view.addSubview(todayToDoTableView)
        todayToDoTableView.registerCell(cellType: TableViewCell.self)
        todayToDoTableView.backgroundColor = .dodWhite1
        todayToDoTableView.delegate = self
        todayToDoTableView.dataSource = self
        todayToDoTableView.separatorStyle = TableViewCell.SeparatorStyle.none
        initRefreshControl()
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGesture:)))
        longPressGesture.minimumPressDuration = 1.0
        self.todayToDoTableView.addGestureRecognizer(longPressGesture)
        
    }
    
    func initRefreshControl() {
        let refresh = UIRefreshControl()
        refresh.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        refresh.addTarget(self, action: #selector(updateUI(refresh: )), for: .valueChanged)
        refresh.attributedTitle = NSAttributedString(string: "불러오는 중")
        if #available(iOS 10.0, *) {
            todayToDoTableView.refreshControl = refresh
        } else {
            todayToDoTableView.addSubview(refresh)
        }
    }
    
    @objc func updateUI(refresh: UIRefreshControl) {
        dataService.fetchRemoteDB {
            DispatchQueue.main.async {
                self.todayToDoViewModel.refreshToDoList()
                refresh.endRefreshing()
                self.todayToDoTableView.reloadData()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshTableView()
    }
    
    func refreshTableView() {
        todayToDoViewModel.refreshToDoList()
        todayToDoTableView.reloadData()
    }
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.todayToDoTableView)
        let indexPath = self.todayToDoTableView.indexPathForRow(at: p)
        let popUp = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: {(action: UIAlertAction!) in
                                        let editVC = EditViewController()
                                        editVC.willEditedTodo = self.todayToDoViewModel.toDoList[indexPath!.row]
                                        print(editVC.willEditedTodo as Any)
                                        self.show(editVC, sender: nil)})
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(action: UIAlertAction!) in
            let toDelete: Todo = self.todayToDoViewModel.toDoList[indexPath!.row]
            dump(toDelete)
            self.dataService.deleteTodo(toDo: toDelete)
            self.refreshTableView()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        popUp.addAction(editAction)
        popUp.addAction(deleteAction)
        popUp.addAction(cancelAction)
        
        
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
        return todayToDoViewModel.toDoList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueCell(indexPath: indexPath)
        cell.nameLabel.attributedText = nil
        cell.nameLabel.text = ""
        cell.todaySetUp(todayToDoViewModel: todayToDoViewModel, indexPath: indexPath)
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
            dataService.updateTodoStatus(at: todayToDoViewModel.toDoList[indexPath.row], to:  .UNRESOLVED)
        } else {
            cell.setStatusResolved()
            dataService.updateTodoStatus(at: todayToDoViewModel.toDoList[indexPath.row], to:  .RESOLVED)
        }
    }
}
