//
//  ViewController.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/05.
//

import UIKit

class MainViewController: UIViewController {

    var tableView: UITableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        [tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
         tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
         tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
         tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)].forEach{$0.isActive = true}
        tableView.registerCell(cellType: MainTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension UITableView {
    func registerCell(cellType: UITableViewCell.Type, reuseIdentifier: String? = nil){
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

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MainTableViewCell = tableView.dequeueCell(indexPath: indexPath)
        return cell
    }
}
