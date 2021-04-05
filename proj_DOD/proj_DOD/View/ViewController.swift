//
//  ViewController.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/05.
//

import UIKit

class ViewController: UIViewController {

    var tableView: UITableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
    }

}

