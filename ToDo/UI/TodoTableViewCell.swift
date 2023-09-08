//
//  TodoTableViewCell.swift
//  ToDo
//
//  Created by Rahul Kumar on 25/08/23.
//

import UIKit
import CoreData

class TodoTableViewCell: UITableViewCell {

    @IBOutlet weak var superView: UIView!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var todoTitle: UILabel!
    @IBOutlet weak var todoDescription: UILabel!
    @IBOutlet weak var todoTime: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var markAsComplete: UIButton!
    @IBOutlet weak var createdTimeLabel: UILabel!
    
    private var isTodoCompleted: Bool = false
    private var isOverdue: Bool = false
    var didDeleteButtonTapped: (() -> Void)?
    var didMarkAsCompletedButtonTapped: ((Bool) -> Void)?
    var didCardTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCardUI()
    }
    
    func setTodoTitle(
        id: String?,
        taskTitle: String?,
        taskDesctiption: String?,
        taskDate: Date?,
        createdAt: Date?,
        updatedAt: Date?,
        isCompleted: Bool
    ){
        self.todoTitle.text = taskTitle
        self.todoDescription.text = taskDesctiption
        self.todoDescription.isHidden = description.isEmpty
        if let date = taskDate {
            self.todoTime.text = date.formatDate()
            self.isOverdue = Date().compare(date) == .orderedDescending
        }
        
        markAsComplete.setTitle(
            isCompleted ? L10n.markAsIncomplete : L10n.markAsCompleted,
            for: .normal)
        isTodoCompleted = isCompleted
        
        if let createdDate = createdAt {
            let createdAtText = L10n.createdAt
            let updatedText = "\(createdAtText) \(createdDate.formatDate())"
            let attributedText = NSMutableAttributedString(string: updatedText)
            let boldFont = UIFont.boldSystemFont(ofSize: 10)
            let rangeBold = (updatedText as NSString).range(of: createdAtText)
            attributedText.addAttribute(.font, value: boldFont, range: rangeBold)
            createdTimeLabel.attributedText = attributedText
        }
        
        if let lastUpdate = updatedAt {
            let lastUpdateAtText = L10n.lastUpdatedAt
            let updatedText = "\(lastUpdateAtText) \(lastUpdate.formatDate())"
            let attributedText = NSMutableAttributedString(string: updatedText)
            let boldFont = UIFont.boldSystemFont(ofSize: 10)
            let rangeBold = (updatedText as NSString).range(of: lastUpdateAtText)
            attributedText.addAttribute(.font, value: boldFont, range: rangeBold)
            createdTimeLabel.attributedText = attributedText
        }
        
        setCardBottomViewColor()
    }
    
    private func setCardBottomViewColor(){
        if isTodoCompleted {
            superView.backgroundColor = .systemGreen
        } else if isOverdue {
            superView.backgroundColor = .systemPink
        } else {
            superView.backgroundColor = .systemMint
        }
    }
    
    private func setCardUI(){
        cellView.layer.cornerRadius = CGFloat(16)
        cellView.backgroundColor = .white
        backgroundColor = .clear
        
        superView.layer.cornerRadius = CGFloat(16)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didCardTap))
        superView.addGestureRecognizer(tapGesture)
        superView.isUserInteractionEnabled = true
        
        todoTitle.font = .systemFont(ofSize: 16)
        
        todoDescription.font = .systemFont(ofSize: 12)
        todoDescription.numberOfLines = 0
        
        todoTime.textColor = .gray
        todoTime.font = .systemFont(ofSize: 10)
        
        createdTimeLabel.textColor = .white
        createdTimeLabel.font = .systemFont(ofSize: 10)
        
        deleteButton.setTitle(L10n.delete, for: .normal)
        deleteButton.tintColor = .systemPink
        
        markAsComplete.setTitle(L10n.markAsCompleted, for: .normal)
        markAsComplete.tintColor = .systemBlue
    }
    
    @IBAction
    private func didDeleteTodo(){
        didDeleteButtonTapped?()
    }
    
    @IBAction
    private func didMarkAsComplete(){
        didMarkAsCompletedButtonTapped?(isTodoCompleted)
    }
    
    @objc
    private func didCardTap(){
        didCardTapped?()
    }
}
