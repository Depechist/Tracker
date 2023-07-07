//
//  SheduleViewController.swift
//  Tracker
//
//  Created by Artem Adiev on 07.07.2023.
//

// MARK: ЭКРАН РАСПИСАНИЯ ПРИВЫЧКИ

import UIKit

// MARK: WEEKDAY CELL

class SheduleTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .ypBackground
        self.selectionStyle = .none
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SheduleViewController: UIViewController {
    
    // MARK: UI ELEMENTS
    
    let navBar = UINavigationBar()
    
    let weekDayTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.layer.cornerRadius = 16
        return tableView
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()
    
    // MARK: LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        weekDayTableView.register(SheduleTableViewCell.self, forCellReuseIdentifier: "SheduleTableViewCell")
        
        navBar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 49)
        navBar.barTintColor = .ypWhite
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), for: .default)
        view.addSubview(navBar)
        let navTitle = UINavigationItem(title: "Расписание")
        navBar.setItems([navTitle], animated: false)
        
        addSubviews()
    }
    
    // MARK: LAYOUT
    
    private func addSubviews() {
        weekDayTableView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weekDayTableView)
        view.addSubview(doneButton)
        
        weekDayTableView.dataSource = self
        weekDayTableView.delegate = self
        
        NSLayoutConstraint.activate([
            weekDayTableView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 16),
            weekDayTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weekDayTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weekDayTableView.widthAnchor.constraint(equalToConstant: 75),
            weekDayTableView.heightAnchor.constraint(equalToConstant: 525),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

// MARK: EXTENSIONS

extension SheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SheduleTableViewCell", for: indexPath) as! SheduleTableViewCell
        
        let daysOfWeek = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
        
        cell.textLabel?.text = daysOfWeek[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        
        let switchView = UISwitch(frame: .zero)
        cell.accessoryView = switchView
        
        if indexPath.row == daysOfWeek.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        }
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
