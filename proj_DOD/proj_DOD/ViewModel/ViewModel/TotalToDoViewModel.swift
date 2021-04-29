//
//  MainViewModel.swift
//  proj_DOD
//
//  Created by 이강욱 on 2021/04/06.
//

import Foundation
class MainViewModel {
    private var toDo: ToDo
    
}

extension MainViewModel {
    
    func mainCellViewModel(row: Int) -> MainCellViewModel {
        return MainCellViewModel(toDo: self.toDo)
    }
}
