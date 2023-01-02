//
//  ViewController.swift
//  Earthquake Tracker
//
//  Created by Halil Ibrahim Andic on 30.12.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func buttonPressed(_ sender: Any) {
        
        if let secondVC = storyboard?.instantiateViewController(identifier: "TableViewController") as? TableViewController {
            secondVC.modalPresentationStyle = .fullScreen
            present(secondVC, animated: true, completion: nil)
        }
    }
    

    
}

