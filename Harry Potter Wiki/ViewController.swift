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
    
    @IBAction func didTapButton(_ sender: Any) {
               
        if let tableVC = storyboard?.instantiateViewController(identifier: "TableViewController") as? TableViewController {
            tableVC.title = "Deneme"
            navigationController?.pushViewController(tableVC, animated: true)
        }
    }
}
