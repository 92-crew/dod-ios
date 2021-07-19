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
    var yPosition: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        totalToDoTableView.frame = view.frame
        view.addSubview(totalToDoTableView)
        totalToDoTableView.registerCell(cellType: TableViewCell.self, reuseIdentifier: "cell")
        totalToDoTableView.backgroundColor = .dodWhite1
        totalToDoTableView.delegate = self
        totalToDoTableView.dataSource = self
        totalToDoTableView.separatorStyle = TableViewCell.SeparatorStyle.none
        initRefreshControl()
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGesture:)))
        longPressGesture.minimumPressDuration = 1.0
        self.totalToDoTableView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        refreshTableView()
    }
    
    func initRefreshControl() {
        let refresh = UIRefreshControl()
        refresh.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        refresh.addTarget(self, action: #selector(updateUI(refresh: )), for: .valueChanged)
        refresh.attributedTitle = NSAttributedString(string: "불러오는 중")
        if #available(iOS 10.0, *) {
            totalToDoTableView.refreshControl = refresh
        } else {
            totalToDoTableView.addSubview(refresh)
        }
    }
    
    @objc func updateUI(refresh: UIRefreshControl) {
        dataService.fetchRemoteDB {
            DispatchQueue.main.async {
                self.totalToDoViewModel.refreshContentList()
                refresh.endRefreshing()
                self.totalToDoTableView.reloadData()
            }
        }
    }
    
    func refreshTableView() {
        totalToDoViewModel.refreshContentList()
        dump(totalToDoViewModel.contentList)
        totalToDoTableView.reloadData()
    }
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.totalToDoTableView)
        let indexPath = self.totalToDoTableView.indexPathForRow(at: p)
        let popUp = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let editAction = UIAlertAction(title: "할 일 수정", style: .default, handler: {(action: UIAlertAction!) in
                                        let editVC = EditViewController()
                                        editVC.willEditedTodo = self.totalToDoViewModel.contentList[indexPath!.section].todos[indexPath!.row]
                                        print(editVC.willEditedTodo as Any)
                                        self.show(editVC, sender: nil)})
        let deleteAction = UIAlertAction(title: "할 일 삭제", style: .destructive, handler: {(action: UIAlertAction!) in
            let toDelete: Todo = self.totalToDoViewModel.contentList[indexPath!.section].todos[indexPath!.row]
            dump(toDelete)
            self.dataService.deleteTodo(toDo: toDelete)
            self.refreshTableView()
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
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
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let title = totalToDoViewModel.toDoDateInSection[section]
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy년 MM월 dd일"
//        let newTitle = formatter.string(from: title.toDate())
//        let today = Date()
//        let str = formatter.string(from: today)
//        if title == str {
//            yPosition = CGFloat(section)
//        }
//
//        return newTitle
//    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .dodWhite1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
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
        return 2.0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        let separatorView = UIView(frame: CGRect(x: 0, y: footerView.frame.height, width: tableView.frame.width, height: 1))
        separatorView.backgroundColor = .dodWhite2
        footerView.addSubview(separatorView)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 60))
        let separatorView = UIView(frame: CGRect(x: 0, y: headerView.frame.height, width: tableView.frame.width, height: 1))
        separatorView.backgroundColor = .dodWhite2
        let formatter = DateFormatter()
        let title = totalToDoViewModel.toDoDateInSection[section]
        let label: UILabel = {
            let lbl = UILabel()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyy년 MM월 dd일 (E)"
            let newTitle = formatter.string(from: title.toDate())
            lbl.text = newTitle
            lbl.frame = CGRect.init(x: 20, y: 15, width: (lbl.text! as NSString).size(withAttributes: [NSAttributedString.Key.font : lbl.font as Any]).width+5, height: 30)
            lbl.font = UIFont.boldSystemFont(ofSize: 15)
            return lbl
        }()
        let labelView:UIImageView = {
            let v = UIImageView()
            v.image = UIImage(named: "todayLabel")
            v.frame = CGRect.init(x: label.frame.width+15, y: 20, width: 10, height: 10)
            return v
        }()
//        let stackView: UIStackView = {
//           let sv = UIStackView()
//
//            sv.addArrangedSubview(label)
//            sv.addArrangedSubview(labelView)
//            sv.frame = CGRect.init(x: 20, y: 0, width: headerView.frame.width / 2, height: 30)
//            NSLayoutConstraint.activate([
//                labelView.widthAnchor.constraint(equalToConstant: 10),
//                labelView.heightAnchor.constraint(equalToConstant: 10)
//            ])
//            sv.distribution = .fillProportionally
//            return sv
//        }()
//      headerView.addSubview(stackView)
        let today = Date()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayStr = formatter.string(from: today)
        if title == todayStr {
//            tableView.scrollToRow(at: IndexPath(item: 0, section: section), at: .top, animated: true)
            headerView.addSubview(label)
            headerView.addSubview(labelView)
        } else {
            
            headerView.addSubview(label)
        }
        headerView.backgroundColor = .dodWhite1
        
        return headerView
    }
}

