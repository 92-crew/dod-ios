//
//  TotalToDoTableView.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/28.
//

import Foundation
import UIKit

class TotalToDoTableView: UIViewController {
    var totalToDoViewModel: TotalToDoViewModel = TotalToDoViewModel(dataService: DataService.shared)
    var totalToDoTableView: UITableView = UITableView()
    var coreDataManager = CoreDataManager.shared
    var dataService = DataService.shared
    var toDoArr: [Todo] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        totalToDoTableView.frame = view.frame
        view.addSubview(totalToDoTableView)
        totalToDoTableView.registerCell(cellType: TableViewCell.self, reuseIdentifier: "cell")
        totalToDoTableView.backgroundColor = .dodWhite1
        totalToDoTableView.delegate = self
        totalToDoTableView.dataSource = self
        totalToDoTableView.separatorStyle = TableViewCell.SeparatorStyle.none
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGesture:)))
        longPressGesture.minimumPressDuration = 1.0
        self.totalToDoTableView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        refreshTableView()
    }
    
    func refreshTableView() {
        totalToDoViewModel.refresh()
        dump(totalToDoViewModel.contentList)
        totalToDoTableView.reloadData()
    }
    
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.totalToDoTableView)
        let indexPath = self.totalToDoTableView.indexPathForRow(at: p)
        let popUp = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: {(action: UIAlertAction!) in
                                        let editVC = EditViewController()
                                        editVC.willEditedTodo = self.totalToDoViewModel.contentList[indexPath!.section].todos[indexPath!.row]
                                        print(editVC.willEditedTodo as Any)
                                        self.show(editVC, sender: nil)})
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(action: UIAlertAction!) in
            let toDelete: Todo = self.totalToDoViewModel.contentList[indexPath!.section].todos[indexPath!.row]
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
            print("Long press on row, at \(indexPath!.row), \(indexPath?.section)")
            present(popUp, animated: true, completion: nil)
        }
    }
    
}

extension TotalToDoTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let content = totalToDoViewModel.contentList[section]
        return content.todos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueCell(reuseIdentifier: "cell", indexPath: indexPath)
        cell.nameLabel.attributedText = nil
        cell.nameLabel.text = ""
        
        let todo = totalToDoViewModel.contentList[indexPath.section].todos[indexPath.row]
        
        cell.nameLabel.text = todo.title
        cell.totalSetUp(totalToDoViewModel: totalToDoViewModel, indexPath: indexPath)
        cell.backgroundColor = .dodWhite1

        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return totalToDoViewModel.contentCount
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return totalToDoViewModel.toDoDateInSection[section]
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .dodWhite1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? TableViewCell else { return }
        
        if cell.select {
            cell.setStatusUnresolved()
            dataService.updateTodoStatus(at: totalToDoViewModel.contentList[indexPath.section].todos[indexPath.row], to:  .UNRESOLVED)
        } else {
            cell.setStatusResolved()
            dataService.updateTodoStatus(at: totalToDoViewModel.contentList[indexPath.section].todos[indexPath.row], to:  .RESOLVED)
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30.0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        let separatorView = UIView(frame: CGRect(x: tableView.separatorInset.left, y: footerView.frame.height, width: tableView.frame.width - tableView.separatorInset.right - tableView.separatorInset.left, height: 1))
        separatorView.backgroundColor = .dodWhite2
        footerView.addSubview(separatorView)
        return footerView
    }
}

