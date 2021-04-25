//
//  ViewController.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/05.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func moveLogin(_ sender: Any) {
        let loginVC = LoginViewController()
        
        self.present(loginVC, animated: true)
    }
    
}

