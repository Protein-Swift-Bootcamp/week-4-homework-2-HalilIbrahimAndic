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
    
    @IBAction func didTapButton(_ sender: UIButton) {
        let choice = sender.currentTitle ?? ""
        
        if let tableVC = storyboard?.instantiateViewController(identifier: "TableViewController") as? TableViewController {
            tableVC.choiceName = choice
            tableVC.title = choice
            determineAPI(choice, tableVC)
            
            navigationController?.pushViewController(tableVC, animated: true)
        }
    }
    
    @IBAction func postButton(_ sender: Any) {
        
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
