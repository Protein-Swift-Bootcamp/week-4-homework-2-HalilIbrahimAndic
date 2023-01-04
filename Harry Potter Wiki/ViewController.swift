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
        let choice = sender.currentTitle ?? "a"
        
        if let tableVC = storyboard?.instantiateViewController(identifier: "TableViewController") as? TableViewController {
            tableVC.choiceName = choice
            tableVC.title = choice
            
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
            
            navigationController?.pushViewController(tableVC, animated: true)
        }
    }
}
