//
//  ViewController.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/05.
//

import UIKit

class MainViewController: UIPageViewController {
    private let todayToDoView: UIViewController = TodayToDoTableView()
    private let totalToDoView: UIViewController = TotalToDoTableView()
    private var vcArr: [UIViewController] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func loadView() {
        super.loadView()
        setPageViewController()
        
    }
    private func setPageViewController(){
        self.dataSource = self
        self.delegate = self
        vcArr = [todayToDoView, totalToDoView]
        if let firstVC = vcArr.first as? TodayToDoTableView {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
}

extension MainViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
    }
}

extension MainViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = vcArr.firstIndex(of: viewController) else{
            return nil
        }
        let previousIndex = index - 1
        print(vcArr[index])
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
        print(vcArr[index])
        if nextIndex >= 2 {
            return nil
        }
        else {
            return vcArr[nextIndex]
        }
    }
}
