//
//  HabitCollectionViewController.swift
//  Habits
//
//  Created by Олег Бабыр on 28.07.2021.
//

import UIKit

private let reuseIdentifier = "Cell"

class HabitCollectionViewController: UICollectionViewController {
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
    
    enum ViewModel {
        
        enum Section: Hashable, Comparable {
            
            case favorites
            case category(_ category: Category)
            
            static func < (lhs: Section, rhs: Section) -> Bool {
                switch (lhs, rhs) {
                case (.category(let l), .category(let r)):
                    return l.name < r.name
                case (.favorites, _):
                    return true
                case (_, .favorites):
                    return false
                }
            }
        }
        
        typealias Item = Habit
    }
    
    struct Model {
        var habitsByName = [String: Habit]()
        var favoriteHabits: [Habit] {
            return Settings.shared.favoriteHabits
        }
    }
    
    var dataSource: DataSourceType!
    var model = Model()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func update(){
        HabitRequest().send { result in
            switch result {
            case .success(let habits):
                self.model.habitsByName = habits
            case .failure:
                self.model.habitsByName = [:]
            }
        }
        
        DispatchQueue.main.async {
            self.updateCollectionView()
        }
    }
    
    func updateCollectionView() {
        let itemBySection = model.habitsByName.values.reduce(into: [ViewModel.Section: [ViewModel.Item]]()) { partial, habit in
            let item = habit
            
            let section: ViewModel.Section
            if model.favoriteHabits.contains(habit) {
                section = .favorites
            } else {
                section = .category(habit.category)
            }
        }
        
        let sectionIDs = itemBySection.keys.sorted()
    }

}
