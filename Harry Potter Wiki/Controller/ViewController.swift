//
//  ViewController.swift
//  Harry Potter Wiki
//
//  Created by Halil Ibrahim Andic on 2.01.2023.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Characters, Spells or Elixirs button is tapped
    @IBAction func didTapButton(_ sender: UIButton) {
        let choice = sender.currentTitle ?? ""
        
        // create an instance of tableView Storyboard
        if let tableVC = storyboard?.instantiateViewController(identifier: "TableViewController") as? TableViewController {
            
            //notifies tableView which button is tapped
            tableVC.choiceName = choice
            tableVC.title = choice
            
            // change endpoint wrt tapped button
            determineAPI(choice, tableVC)
            
            // go tableview with navigation controller
            navigationController?.pushViewController(tableVC, animated: true)
        }
    }
    
    // 'Post a feedback' button is tapped
    @IBAction func postButton(_ sender: Any) {
        
        //create an instance of feedback Storyboard
        if let feedbackVC = storyboard?.instantiateViewController(identifier: "feedbackStoryboard") as? FeedbackViewController {
            
            feedbackVC.title = "Feedback"
            navigationController?.pushViewController(feedbackVC, animated: true)
        }
    }
}

//MARK: - EXTENSION
extension ViewController {
    func determineAPI(_ choice: String,_ tableVC: TableViewController) {
        switch choice {
            case "Characters":
                tableVC.choiceURL = "https://hp-api.onrender.com/api/characters"
            case "Spells":
                tableVC.choiceURL = "https://hp-api.onrender.com/api/spells"
            case "Elixirs":
                tableVC.choiceURL = "https://wizard-world-api.herokuapp.com/Elixirs"
            default:
                print("Error: Invalid URL")
        }
    }
}
