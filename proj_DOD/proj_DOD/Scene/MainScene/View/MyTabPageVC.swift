////
////  MyTabPageVC.swift
////  Mongle
////
////  Created by 이예슬 on 7/15/20.
////  Copyright © 2020 이주혁. All rights reserved.
////
//
//import UIKit
//
//class MyTabPageVC: UIPageViewController {
//
//    var previousPage: UIViewController?
//    var mainVC: MyTabVC?
//    var nextPage: UIViewController?
//    var realNextPage: UIViewController?
//    let identifiers: NSArray = ["MyTabThemeVC", "MyTabSentenceVC","MyTabCuratorVC"]
//    var vcArr: [UIViewController]?
//    var keyValue = KVOObject()
//    var sentenceFlag = false
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.delegate = self
//        self.dataSource = self
//        vcArr = identifiers.compactMap {
//            let id = $0 as! String
//            
//            if id == "MyTabThemeVC" {
//                let vc = self.storyboard?.instantiateViewController(identifier: $0 as! String) as! MyTabThemeVC
//                return vc
//            }
//            else if id == "MyTabSentenceVC"{
//                let vc = self.storyboard?.instantiateViewController(identifier: $0 as! String) as! MyTabSentenceVC
//                vc.mainVC = self.mainVC
//                return vc
//            }
//            else{
//                let vc = self.storyboard?.instantiateViewController(identifier: $0 as! String) as! MyTabCuratorVC
//                return vc
//            }
//            
//            
//        }
//        if sentenceFlag{
//            sentenceFlag = false
//            if let sentenceVC = vcArr?[1] as? MyTabSentenceVC{
//                setViewControllers([sentenceVC], direction: .forward, animated: false, completion: nil)
//                sentenceVC.bookmarkBtnIdx = 1
//                sentenceVC.doNotReload = true
//                
//               sentenceVC.sentenceTableView.reloadData()
//            }
//        }
//        else{
//            if let firstVC = vcArr?.first {
//                setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
//            }
//        }
//    
//    }
//    
//    // 스크롤 방식 변경, inspector Builder에서 변경할 수도 있지만 커스텀 으로 생성하기 때문에 이런식으로 설정
//    required init?(coder: NSCoder) {
//        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//    }
//}
//
//extension MyTabPageVC: UIPageViewControllerDelegate {
//    //이부분만
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//
//        if completed {
//            previousPage = previousViewControllers[0]
//            realNextPage = nextPage
//            print(realNextPage)
//            if realNextPage is Mongle.MyTabThemeVC {
//                self.keyValue.curPresentViewIndex = 0
//            
//            }
//            else if realNextPage is Mongle.MyTabSentenceVC {
//                self.keyValue.curPresentViewIndex = 1
//            }
//            else{
//                self.keyValue.curPresentViewIndex = 2
//            }
//        }
//    
//    }
//    
//    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
//        nextPage = pendingViewControllers[0]
//    }
//}
//
//extension MyTabPageVC: UIPageViewControllerDataSource {
//    // 이 함수가 뭔지 살짝 이해 안됨
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        
//        guard let viewControllerIndex = vcArr?.firstIndex(of: viewController) else {
//            return nil
//        }
//        
//        let previousIndex = viewControllerIndex - 1
//        //infinite 아니고 끝에선 튕기게
//        if previousIndex < 0 {
//            return nil
//        }
//        else {
//            return vcArr![previousIndex]
//        }
//    }
//    // KVO
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        
//        guard let viewControllerIndex = vcArr?.firstIndex(of: viewController) else {
//            return nil
//        }
//        
//        let nextIndex = viewControllerIndex + 1
//        if nextIndex >= vcArr!.count {
//            return nil
//        } else {
//            return vcArr![nextIndex]
//        }
//    }
//
//}
