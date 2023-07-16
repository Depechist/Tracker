//
//  NewEventViewController.swift
//  Tracker
//
//  Created by Artem Adiev on 07.07.2023.
//

// MARK: ЭКРАН СОЗДАНИЯ СОБЫТИЯ

import UIKit

final class NewEventViewController: UIViewController {
    
    var dataManager = DataManager.shared
    
    let currentWeekDay = Calendar.current.component(.weekday, from: Date())
    
    // MARK: - UI ELEMENTS
    
    // Поле для ввода названия трекера
    let trackerNameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = .ypBackground
        textField.layer.cornerRadius = 16
        
        // Отступ от левого края textField
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        // Отступ от правого края textField
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 41, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always
        
        return textField
    }()
    
    // TableView для кнопки "Категория"
    let buttonTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    // Кнопка "Отменить"
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.cornerRadius = 16
        return button
    }()
    
    // Кнопка "Создать"
    let createButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypGray
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        return button
    }()
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        // Объявляем класс делегатом для поля ввода и отключаем кнопку, чтобы избежать отсутсвие названия
        trackerNameField.delegate = self
        
        // Заголовок экрана в навбаре
        self.title = "Новое нерегулярное событие"
        
        // Добавляем UI элементы
        addSubviews()
    }
    
    // Задаем клик по кнопке "Отменить"
    @objc func cancelButtonTapped() {
        NotificationCenter.default.post(name: NSNotification.Name("CloseAllModals"), object: nil)
    }
    
    @objc func createButtonTapped() {
        // Проверяем, что поле названия не пустое
        guard let trackerTitle = trackerNameField.text, !trackerTitle.isEmpty else {
            let alertController = UIAlertController(title: "Ой!", message: "Введите имя события", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "ОК", style: .default))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        // Если поле не пустое - создаем трекер
        let newTracker = Tracker(id: UUID(), date: Date(), emoji: "", title: trackerTitle, color: .ypRed, dayCount: 1, schedule: nil)
        dataManager.categories.append(TrackerCategory(title: trackerTitle, trackers: [newTracker]))
        
        NotificationCenter.default.post(name: NSNotification.Name("NewTrackerCreated"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("CloseAllModals"), object: nil)
    }
    
    // MARK: - LAYOUT
    
    private func addSubviews() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        trackerNameField.translatesAutoresizingMaskIntoConstraints = false
        buttonTableView.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackerNameField)
        view.addSubview(buttonTableView)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        
        // Ставим делегата и датасоурс для TableView
        buttonTableView.dataSource = self
        buttonTableView.delegate = self
        
        NSLayoutConstraint.activate([
            trackerNameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            trackerNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerNameField.widthAnchor.constraint(equalToConstant: 343),
            trackerNameField.heightAnchor.constraint(equalToConstant: 75),
            
            buttonTableView.topAnchor.constraint(equalTo: trackerNameField.bottomAnchor, constant: 24),
            buttonTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonTableView.widthAnchor.constraint(equalToConstant: 343),
            buttonTableView.heightAnchor.constraint(equalToConstant: 150),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 166),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            createButton.widthAnchor.constraint(equalToConstant: 166),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

// MARK: - EXTENSIONS

extension NewEventViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Ставим количество кнопок
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ButtonTableViewCell()
        
        // Добавляем кнопке-ячейке стрелку справа
        cell.accessoryType = .disclosureIndicator
        
        // Задаем кнопке-ячейке шрифт
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        
        cell.layer.cornerRadius = 16
        cell.textLabel?.text = "Категория"
        
        return cell
    }
    
    // Высота для каждой ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension NewEventViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        createButton.isEnabled = !updatedText.isEmpty
        return true
    }
}


