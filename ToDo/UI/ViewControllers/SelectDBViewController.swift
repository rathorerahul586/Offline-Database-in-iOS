//
//  SelectDBViewController.swift
//  ToDo
//
//  Created by Rahul Kumar on 31/08/23.
//

import UIKit

class SelectDBViewController: UIViewController {

    @IBOutlet weak var coreDataLabel: UILabel!
    @IBOutlet weak var realmDataLabel: UILabel!
    @IBOutlet weak var sqliteDataLabel: UILabel!
    @IBOutlet weak var grdbDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.colorLightGrey.color
        title = L10n.chooseDatabase
        setupUI()
    }
    
    private func setupUI(){
        [coreDataLabel, realmDataLabel, sqliteDataLabel, grdbDataLabel].forEach { label in
            label.font = .systemFont(ofSize: 20)
            label.backgroundColor = .systemTeal
            label.textColor = .white
            label.textAlignment = .center
            label.layer.cornerRadius = 16
            label.clipsToBounds = true
            // Add a tap gesture recognizer
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didLabelTapped))
            label.addGestureRecognizer(tapGesture)
            label.isUserInteractionEnabled = true
        }
        coreDataLabel.text = L10n.coreData
        realmDataLabel.text = L10n.realm
        sqliteDataLabel.text = L10n.sqlite
        grdbDataLabel.text = L10n.grdb
    }
    
    @objc
    private func didLabelTapped(_ sender: UITapGestureRecognizer){
        let viewController = storyboard?.instantiateViewController(identifier: "ViewController") as? ViewController
        
        switch(sender.view as? UILabel){
        case coreDataLabel:
            viewController?.setDatabaseType(dbType: .coreData)
        case realmDataLabel:
            viewController?.setDatabaseType(dbType: .realm)
        case grdbDataLabel:
            viewController?.setDatabaseType(dbType: .grdb)
            
        default:
            viewController?.setDatabaseType(dbType: .sqlite)
        }
        
        if let vc = viewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
