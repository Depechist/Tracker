//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Artem Adiev on 25.10.2023.
//

import UIKit
import CoreData

final class CategoryViewModel {
        
    static let shared = CategoryViewModel()
    private var categoryStore = TrackerCategoryStore()
    private (set) var categories: [TrackerCategory] = []
    
    @Observable
    private (set) var selectedCategory: TrackerCategory?
    
    init() {
        categoryStore.delegate = self
        self.categories = categoryStore.trackerCategories
    }
    
    func addCategory(_ toAdd: String) {
        try? self.categoryStore.addNewCategory(TrackerCategory(header: toAdd, trackers: []))
    }
    
    func addTrackerToCategory(to category: TrackerCategory?, tracker: Tracker) {
        try? self.categoryStore.addTrackerToCategory(to: category, tracker: tracker)
    }
    
    func selectCategory(_ at: Int) {
        self.selectedCategory = self.categories[at]
    }
}

extension CategoryViewModel: TrackerCategoryStoreDelegate {
    func storeCategoriesDidUpdate(_ store: TrackerCategoryStore) {
        self.categories = store.trackerCategories
    }
}
