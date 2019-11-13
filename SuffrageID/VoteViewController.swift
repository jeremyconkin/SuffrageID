//
//  VoteViewController.swift
//  SuffrageID
//
//  Created by Jeremy Conkin on 11/15/18.
//  Copyright © 2018 Slalom. All rights reserved.
//

import UIKit

class VoteViewController : UIViewController{
    
    @IBAction func didTap1(_ sender: AnyObject) {
        
        ResultsViewController.votingResults[0] += 1;
        showResults();
    }
    @IBAction func didTap2(_ sender: AnyObject) {
        
        ResultsViewController.votingResults[1] += 1;
        showResults();
    }
    @IBAction func didTap3(_ sender: AnyObject) {
        
        ResultsViewController.votingResults[2] += 1;
        showResults();
    }
    @IBAction func didTap4(_ sender: AnyObject) {
        
        ResultsViewController.votingResults[3] += 1;
        showResults();
    }
    @IBAction func didTap5(_ sender: AnyObject) {
        
        ResultsViewController.votingResults[4] += 1;
        showResults();
    }
    @IBAction func didTap6(_ sender: AnyObject) {
        
        ResultsViewController.votingResults[5] += 1;
        showResults();
    }
    @IBAction func didTap7(_ sender: AnyObject) {
        
        ResultsViewController.votingResults[6] += 1;
        showResults();
    }
    @IBAction func didTap8(_ sender: AnyObject) {
        
        ResultsViewController.votingResults[7] += 1;
        showResults();
    }
    @IBAction func didTap9(_ sender: AnyObject) {
        
        ResultsViewController.votingResults[8] += 1;
        showResults();
    }
    @IBAction func didTap10(_ sender: AnyObject) {
        
        ResultsViewController.votingResults[9] += 1;
        showResults();
    }
    @IBAction func didTap11(_ sender: AnyObject) {
        
        ResultsViewController.votingResults[10] += 1;
        showResults();
    }
    @IBAction func didTap12(_ sender: AnyObject) {
        
        ResultsViewController.votingResults[11] += 1;
        showResults();
    }
    
    
    private func showResults() {
        performSegue(withIdentifier: "showResults", sender: self)
    }

}
