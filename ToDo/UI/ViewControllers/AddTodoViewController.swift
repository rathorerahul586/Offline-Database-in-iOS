//
//  AddTodo.swift
//  ToDo
//
//  Created by Rahul Kumar on 25/08/23.
//

import Foundation
import UIKit
import CoreData

class AddTodoViewController: UIViewController {
    
    private var viewModel: (any AddTaskProtocal)?
    
    @IBOutlet weak var todoTitle: UITextField!
    @IBOutlet weak var todoTitleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var todoDescription: UITextView!
    @IBOutlet weak var datePickerStackVIew: UIStackView!
    @IBOutlet weak var selectDateLabel: UILabel!
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    
    @IBOutlet weak var todoCard: UIView!
    
    @IBOutlet weak var cardTodoTitle: UILabel!
    @IBOutlet weak var cardTodoDescriptions: UITextView!
    @IBOutlet weak var cardDateSuperView: UIView!
    @IBOutlet weak var cardTodoDate: UILabel!
    
    @IBOutlet weak var saveTodoButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    private let todoDecriptionPlaceholder = L10n.descriptionHint
    
    private var isEditable: Bool = false
    private var taskId: String?
    private var taskTitle: String?
    private var taskDesctiption: String?
    private var taskDate: Date?
    
    override func viewDidLoad() {
        title = L10n.addTodo
        view.backgroundColor = Asset.Colors.colorLightGrey.color
        setUI()
        setCardUI()
        validateTitleAndDescription()
        hideKeyboardWhenTappedAround()
        if isEditable {
            setEditableValues()
        }
    }
    
    func initializeViewModel(dbType: DatabaseTypeEnum){
        switch (dbType) {
        case .coreData : viewModel = CoreDataAddTodoViewModel()
        case .realm : viewModel = RealmAddTodoViewModel()
        case .sqlite : viewModel = SQLiteAddTodoViewModel()
        case .grdb : viewModel = GrdbAddTodoViewModel()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        todoTitle.becomeFirstResponder()
    }
    
    private func setUI(){
        todoTitle.placeholder = L10n.titleHint
        todoTitle.addTarget(self, action: #selector(doOnTitleChange), for: .editingChanged)
        todoTitle.font = .systemFont(ofSize: 16)
       
        todoDescription.delegate = self
        todoDescription.layer.cornerRadius = CGFloat(4)
        todoDescription.text = todoDecriptionPlaceholder
        todoDescription.textColor = .lightGray
        todoDescription.font = .systemFont(ofSize: 14)
        
        selectDateLabel.font = .systemFont(ofSize: 14)
        
        datePickerStackVIew.layer.cornerRadius = CGFloat(4)
        datePickerStackVIew.backgroundColor = .white
        
        dateTimePicker.backgroundColor = .white
        dateTimePicker.contentHorizontalAlignment = .center
        dateTimePicker.addTarget(self, action: #selector(doOnDateTimeChange), for: .valueChanged)
        dateTimePicker.preferredDatePickerStyle = .wheels
        dateTimePicker.minimumDate = Date()
        dateTimePicker.date = Date().addingTimeInterval(3600)
        
        todoCard.layer.cornerRadius = CGFloat(16)
        todoCard.backgroundColor = .white
        
        saveTodoButton.setTitle(L10n.saveTodo, for: .normal)
        
        cancelButton.setTitle(L10n.cancel, for: .normal)
    }
    
    private func setCardUI(){
        
        cardTodoTitle.font = .systemFont(ofSize: 16)
        
        cardTodoDescriptions.isHidden = true
        cardTodoDescriptions.font = .systemFont(ofSize: 12)
        cardTodoDescriptions.isEditable = false
        cardTodoDescriptions.isSelectable = false
        
        
        cardTodoDate.textColor = .gray
        cardTodoDate.font = .systemFont(ofSize: 10)
        cardTodoDate.text = dateTimePicker.date.formatDate()
    }
    
    @IBAction
    private func cancelTodo(){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction
    private func saveTodo() {
        isEditable ? updateTodo() : saveTodoInDb()
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func doOnTitleChange(_ textField: UITextField){
        cardTodoTitle.text = todoTitle.text
        validateTitleAndDescription()
    }
    
    @objc
    private func doOnDescriptionChange(){
        cardTodoDescriptions.text = todoDescription.text
        cardTodoDescriptions.scrollToBotom()
        validateTitleAndDescription()
        
    }
    
    @objc
    private func doOnDateTimeChange(_ datePicker: UIDatePicker){
        cardTodoDate.text = datePicker.date.formatDate()
    }
    
    private func validateTitleAndDescription(){
        todoCard.isHidden = todoTitle.text?.isEmpty ?? true && (todoDescription.text == todoDecriptionPlaceholder || todoDescription.text?.isEmpty ?? true)
        cardTodoDescriptions.isHidden = todoDescription.text == todoDecriptionPlaceholder || todoDescription.text?.isEmpty ?? true
        
        if todoTitle.text?.isEmpty ?? true {
            cardTodoTitle.text = "\(L10n.todo): \(dateTimePicker.date.formatDate())"
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        if todoCard.isHidden {
            todoTitleTopConstraint.constant = 16
        } else {
            todoTitleTopConstraint.constant = todoCard.frame.height + 30
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func saveTodoInDb(){
        viewModel?.insertNewTask(
            title: cardTodoTitle.text,
            description: cardTodoDescriptions.text,
            todoDate: dateTimePicker.date
        )
    }
    
    private func updateTodo(){
        self.viewModel?.updateTask(
            taskId: taskId ?? "",
            title: cardTodoTitle.text,
            description: cardTodoDescriptions.text,
            todoDate: dateTimePicker.date
        )
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setEditable(taskId: String?, title: String?, desc: String?, taskDate: Date?){
        self.isEditable = true
        self.taskId = taskId
        self.taskTitle = title
        self.taskDesctiption = desc
        self.taskDate = taskDate
    }
    
    private func setEditableValues(){
        self.todoTitle.text = self.taskTitle
        self.cardTodoTitle.text = self.taskTitle
        
        self.todoDescription.text = self.taskDesctiption
        self.todoDescription.textColor = .black
        self.cardTodoDescriptions.text = self.taskDesctiption
        self.cardTodoDescriptions.scrollToBotom()
        
        self.dateTimePicker.date = self.taskDate ?? Date()
        validateTitleAndDescription()
    }
}

extension AddTodoViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = todoDecriptionPlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        doOnDescriptionChange()
    }
}

extension UITextView {
    
    func scrollToBotom() {
        let range = NSMakeRange(text.count - 1, 1)
        scrollRangeToVisible(range)
    }
    
}
