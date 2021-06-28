//
//  ViewController.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/05.
//

import UIKit

class MainViewController: UIPageViewController {
    private let todayToDoView: TodayToDoTableView = TodayToDoTableView()
    private let totalToDoView: TotalToDoTableView = TotalToDoTableView()
    private let addViewController: UIViewController = AddViewController()
    private var vcArr: [UIViewController] = []
    var pages = [UIViewController]()
    var currentIndex: Int = 0
    var todayToDoBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("오늘", for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.setTitleColor(.black, for: UIControl.State.normal)
        btn.isEnabled = false
        return btn
    }()
    var totalToDoBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("전체", for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.setTitleColor(.dodWhite2, for: UIControl.State.normal)
        btn.isEnabled = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func loadView() {
        super.loadView()
        setPageViewController()
        setNavigationBar()
        let statusBar = UIView()
        statusBar.frame = UIApplication.shared.statusBarFrame
        statusBar.backgroundColor = .dodWhite1
        UIApplication.shared.keyWindow?.addSubview(statusBar)
    }
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        todayToDoView.refreshTableView()
        totalToDoView.refreshTableView()
    }
    
    private func setPageViewController(){
        self.dataSource = self
        self.delegate = self
        vcArr = [todayToDoView, totalToDoView]
        pages = vcArr
        if let firstVC = vcArr.first as? TodayToDoTableView {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        self.todayToDoView.additionalSafeAreaInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        self.totalToDoView.additionalSafeAreaInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    private func setNavigationBar() {
        let navBar = self.navigationController!.navigationBar
        navBar.tintColor = .black
        navBar.backgroundColor = .dodWhite1
        let navItem = self.navigationItem
        let navAddItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(_:)))
        let leftItem = UIBarButtonItem(customView: titleView())
        self.navigationItem.leftBarButtonItem = leftItem
        navItem.setRightBarButton(navAddItem, animated: true)
    }
    
    @objc func addButtonTapped(_ sender: UIBarButtonItem!){
        self.show(addViewController, sender: nil)
    }
    
    private func titleView() -> UIView{
        let titleView: UIStackView = {
            let sv = UIStackView(arrangedSubviews: [todayToDoBtn, totalToDoBtn])
            sv.axis = .horizontal
            sv.spacing = 8
            return sv
        }()
        return titleView
    }
    
}

extension MainViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentVC = pageViewController.viewControllers?.first, let index = pages.firstIndex(of: currentVC){
                currentIndex = index
            }
        }
        if currentIndex == 0 {
            totalToDoBtn.setTitleColor(.dodWhite2, for: UIControl.State.normal)
            todayToDoBtn.setTitleColor(.black, for: UIControl.State.normal)
        } else if currentIndex == 1 {
            totalToDoBtn.setTitleColor(.black, for: UIControl.State.normal)
            todayToDoBtn.setTitleColor(.dodWhite2, for: UIControl.State.normal)
        }
    }
    
}

extension MainViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = vcArr.firstIndex(of: viewController) else{
            return nil
        }
        let previousIndex = index - 1
        
        if previousIndex < 0 {
            return nil
        }
        
        else {
            return vcArr[previousIndex]
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = vcArr.firstIndex(of: viewController) else{
            return nil
        }
        
        let nextIndex = index + 1
        if nextIndex >= 2 {
            return nil
        }
        else {
            return vcArr[nextIndex]
        }
    }
    
}
extension UINavigationBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 50)
    }
}
