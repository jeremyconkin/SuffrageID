//
//  VotingViewController.swift
//  SuffrageID
//
//  Created by Jeremy Conkin on 9/30/18.
//  Copyright © 2018 Slalom. All rights reserved.
//

import UIKit

class VotingViewController: UIViewController {

    @IBOutlet weak var votingTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        votingTable.dataSource = self
        votingTable.delegate = self
    }
}

extension VotingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension VotingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "candidateCell")
        
        var candidateName: String {
            switch indexPath.row {
            case 1:
                return "anthony"
            case 2:
                return "binh"
            default:
                return "eric"
            }
        }
        
        var candidatePrettyPrintName: String {
            switch candidateName {
            case "anthony":
                return "Anthony Marquardt"
            case "binh":
                return "Binh Diep"
            default:
                return "Eric Olson"
            }
        }
        
        cell.textLabel?.text = candidatePrettyPrintName
        cell.textLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.imageView?.image = UIImage(named: candidateName)
        cell.contentView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        return cell
    }
}
