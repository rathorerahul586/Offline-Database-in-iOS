//
//  ViewController.swift
//  ToDo
//
//  Created by Rahul Kumar on 25/08/23.
//

import UIKit
import CoreData
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet private weak var todoTable: UITableView!
    
    private var viewModel: (any TodoListViewModelProtocal)?
    private var updateIndex: Int?
    private var todoList: [TodoTaskProtocal] = []
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var tabsStackView: UIStackView!
    @IBOutlet weak var overdueButton: UIButton!
    @IBOutlet weak var todoButton: UIButton!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var noDataView: UIStackView!
    @IBOutlet weak var noDataTitleLabel: UILabel!
    @IBOutlet weak var noDataSubTitleLabel: UILabel!
    
    private var selectedDbType: DatabaseTypeEnum = .coreData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.colorLightGrey.color
        addAddButton()
        title = L10n.todo
        setTabs()
        setTodoTable()
        setNoDataView()
        observeTodosData()
        selectTab(selectedLabel: todoButton)
    }
    
    func setDatabaseType(dbType: DatabaseTypeEnum){
        selectedDbType = dbType
        
        switch (selectedDbType) {
        case .coreData : viewModel = CoreDataDBViewModel()
        case .realm : viewModel = RealmDBViewModel()
        case .sqlite : viewModel = SQLiteViewModel()
        case .grdb : viewModel = GrdbViewModel()
        }
    }
    
    private func setTodoTable() {
        todoTable.register(UINib(nibName: "TodoTableViewCell", bundle: nil), forCellReuseIdentifier: "TodoTableViewCell")
        todoTable.backgroundColor = .clear
        todoTable.delegate = self
        todoTable.dataSource = self
        todoTable.allowsSelection = false
        todoTable.separatorStyle = .none
    }
    
    private func setNoDataView(){
        noDataTitleLabel.font = .systemFont(ofSize: 20)
        noDataSubTitleLabel.font = .systemFont(ofSize: 16)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.retriveTodosData()
    }
    
    private func addAddButton(){
        let addButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(showAddTodoScreen))
        addButton.image = UIImage(systemName: "plus")
        // Assign the custom UIBarButtonItem to the navigation item's rightBarButtonItem
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc
    private func showAddTodoScreen() {
        if let viewController = storyboard?.instantiateViewController(identifier: "AddTodoViewController") as? AddTodoViewController {
            viewController.initializeViewModel(dbType: selectedDbType)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func observeTodosData(){
        viewModel?.todoListPublishObject.subscribe { list in
            self.todoList = list
            self.todoTable.reloadData()
            self.handelNoDataView()
        }.disposed(by: disposeBag)
    }
    
    private func handelNoDataView(){
        if todoList.isEmpty {
            noDataView.isHidden = false
            todoTable.isHidden = true
            switch(self.viewModel?.selectedTabType) {
            case .overdue:
                noDataTitleLabel.text = L10n.noOverdue
                noDataSubTitleLabel.text = L10n.noOverdueSubTitle
            case .incomplete:
                noDataTitleLabel.text = L10n.noIncomplete
                noDataSubTitleLabel.text = L10n.noIncompleteSubtitle
            case .completed:
                noDataTitleLabel.text = L10n.noCompleted
                noDataSubTitleLabel.text = L10n.noCompletedSubtitle
            case .none:
                noDataTitleLabel.text = L10n.noIncomplete
                noDataSubTitleLabel.text = L10n.noIncompleteSubtitle
            }
            
        } else {
            noDataView.isHidden = true
            todoTable.isHidden = false
        }
    }
    
    private func setTabs(){
        [overdueButton, todoButton, completedButton].forEach { button in
            button.layer.cornerRadius = 8
            button.backgroundColor = UIColor.clear
            button.setTitleColor(.white, for: .selected)
            button.setTitleColor(.systemBlue, for: .normal)
        }
        
        overdueButton.setTitle(L10n.overdue, for: .normal)
        todoButton.setTitle(L10n.incomplete, for: .normal)
        completedButton.setTitle(L10n.completed, for: .normal)
        
        tabsStackView.layer.cornerRadius = 8
        tabsStackView.backgroundColor = UIColor.white
    }
    
    private func deleteTodo(){
        
        let alert = UIAlertController(
            title: "",
            message: L10n.deleteMessage,
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: L10n.cancel,
                style: .default,
                handler: { _ in
                    self.dismiss(animated: true)
                }
            )
        )
        
        alert.addAction(
            UIAlertAction(
                title: L10n.yesDelete,
                style: .default,
                handler: { _ in
                    let task = self.todoList[self.updateIndex ?? 0]
                    self.viewModel?.deleteTodo(todoId: task.todoId ?? "", completion: {
                        if let index = self.updateIndex {
                            let rowPath = IndexPath(row: index, section: 0)
                            self.todoList.remove(at: index)
                            self.todoTable.beginUpdates()
                            self.todoTable.deleteRows(
                                at: [rowPath], with: .fade
                            )
                            self.todoTable.endUpdates()
                            self.todoTable.reloadRows(at: [rowPath], with: .fade)
                            self.handelNoDataView()
                        }
                    })
                    
                }
            )
        )
        
        present(alert, animated: true, completion: nil)
        
    }
    
    private func markAsCompleted(isCompleted: Bool){
        
        let alert = UIAlertController(
            title: isCompleted ? L10n.notCompletedMessage : L10n.completedMessage ,
            message: "",
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: L10n.cancel,
                style: .default,
                handler: { _ in
                    self.dismiss(animated: true)
                }
            )
        )
        
        alert.addAction(
            UIAlertAction(
                title: L10n.yes,
                style: .default,
                handler: { _ in
                    let task = self.todoList[self.updateIndex ?? 0]
                    self.viewModel?.markAsCompleted(
                        todoId: task.todoId ?? "", isCompleted: isCompleted
                    )
                }
            )
        )
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction
    private func didTabTapped(_ sender: UIButton){
        selectTab(selectedLabel: sender)
    }
    
    private func setTabType(selectedButton: UIButton){
        switch selectedButton {
        case overdueButton:
            viewModel?.selectedTabType = .overdue
        case completedButton:
            viewModel?.selectedTabType = .completed
        default:
            viewModel?.selectedTabType = .incomplete
        }
        viewModel?.retriveTodosData()
    }
    
    private func selectTab(selectedLabel: UIButton){
        setTabType(selectedButton: selectedLabel)
        [overdueButton, todoButton, completedButton].forEach { button in
            if selectedLabel == button {
                button.backgroundColor = UIColor.systemBlue
                button.isSelected = true
                
            } else {
                button.backgroundColor = UIColor.white
                button.isSelected = false
            }
        }
    }
    
    private func editTodo(){
        if let viewController = storyboard?.instantiateViewController(
            identifier: "AddTodoViewController") as? AddTodoViewController {
            viewController.initializeViewModel(dbType: selectedDbType)
            
            let task = todoList[updateIndex ?? 0]
            viewController.setEditable(
                taskId: task.todoId,
                title: task.title,
                desc: task.des,
                taskDate: task.todoDate
            )
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        
        let task = todoList[indexPath.row]
        cell.setTodoTitle(
            id: task.todoId, taskTitle: task.title,
            taskDesctiption: task.des, taskDate: task.todoDate,
            createdAt: task.createdAt, updatedAt: task.updatedAt,
            isCompleted: task.isCompleted
        )
        
        cell.didDeleteButtonTapped = {
            self.updateIndex = indexPath.row
            self.deleteTodo()
        }
        
        cell.didMarkAsCompletedButtonTapped = { isCompleted in
            self.updateIndex = indexPath.row
            self.markAsCompleted(isCompleted: isCompleted)
        }
        
        cell.didCardTapped = {
            self.updateIndex = indexPath.row
            self.editTodo()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

