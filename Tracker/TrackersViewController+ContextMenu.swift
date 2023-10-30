//
//  TrackersViewController+ContextMenu.swift
//  Tracker
//
//  Created by Artem Adiev on 29.10.2023.
//

import UIKit

extension TrackersViewController {
    
    func makePreviewViewController(for tracker: Tracker, width: CGFloat, height: CGFloat) -> UIViewController {
        let previewVC = TrackerPreviewViewController()
        let cellSize = CGSize(width: width, height: height)
        previewVC.configureView(sizeForPreview: cellSize, tracker: tracker)
        return previewVC
    }
    
    func makeUnpinAction(for tracker: Tracker) -> UIAction {
        UIAction(title: "Открепить", handler: { [weak self] _ in
            try? self?.trackerStore.pinTracker(tracker, isPinned: false)
            self?.reloadData()
        })
    }
    
    func makePinAction(for tracker: Tracker) -> UIAction {
        UIAction(title: "Закрепить", handler: { [weak self] _ in
            try? self?.trackerStore.pinTracker(tracker, isPinned: true)
            self?.reloadData()
        })
    }
    
    func makeEditAction(for tracker: Tracker) -> UIAction {
        return UIAction(title: "Редактировать", handler: { [weak self] _ in
            Analytics.shared.tapButton(on: .main, itemType: .edit)
            
            let editVC = NewHabitViewController()
            let navVC = UINavigationController(rootViewController: editVC)
            editVC.fillWith(tracker: tracker)
            self?.present(navVC, animated: true)
        })
    }
    
    func makeDeleteAction(for tracker: Tracker) -> UIAction {
        UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
            Analytics.shared.tapButton(on: .main, itemType: .delete)
            
            let alertController = UIAlertController(title: nil, message: "Уверены что хотите удалить трекер?", preferredStyle: .actionSheet)
            let deleteConfirmationAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
                try? self?.trackerStore.deleteTracker(tracker)
                self?.reloadData()
            }
            alertController.addAction(deleteConfirmationAction)
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            self?.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    func makeContextMenu(for tracker: Tracker) -> UIMenu {
        let pinAction = tracker.isPinned ? makeUnpinAction(for: tracker) : makePinAction(for: tracker)
        let editAction = makeEditAction(for: tracker)
        let deleteAction = makeDeleteAction(for: tracker)
        
        let actions = [pinAction, editAction, deleteAction]
        return UIMenu(title: "", children: actions)
    }
}
