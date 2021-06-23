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
//    var sectionDate: String = ""
//    var toDoTitle: String = ""
//    var currentStatus: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalToDoTableView.frame = view.frame
        view.addSubview(totalToDoTableView)
        totalToDoTableView.registerCell(cellType: TableViewCell.self)
        totalToDoTableView.backgroundColor = .dodWhite1
        totalToDoTableView.delegate = self
        totalToDoTableView.dataSource = self
        totalToDoTableView.separatorStyle = TableViewCell.SeparatorStyle.none
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGesture:)))
        longPressGesture.minimumPressDuration = 1.0
        self.totalToDoTableView.addGestureRecognizer(longPressGesture)
    }
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let popUp = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: {(action: UIAlertAction!) in
                                        let editVC = EditViewController()
                                        editVC.willEditedTodo = self.totalToDoViewModel.toDo
                                        print(editVC.willEditedTodo as Any)
                                        self.show(editVC, sender: nil)})
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        popUp.addAction(editAction)
        popUp.addAction(deleteAction)
        popUp.addAction(cancelAction)
        
        let p = longPressGesture.location(in: self.totalToDoTableView)
        let indexPath = self.totalToDoTableView.indexPathForRow(at: p)
        if indexPath == nil {
            print("Long press on tbv, not row")
        } else if longPressGesture.state == UIGestureRecognizer.State.began {
            print("Long press on row, at \(indexPath!.row)")
            present(popUp, animated: true, completion: nil)
        }
    }
    
}

extension TotalToDoTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalToDoViewModel.contentCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueCell(indexPath: indexPath)
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
            print("UNRESOLVED")
        } else {
            cell.setStatusResolved()
            print("RESOLVED")
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

