//
//  TableViewController.swift
//  Harry Potter Wiki
//
//  Created by Halil Ibrahim Andic on 3.01.2023.
//

import UIKit

class TableViewController: UIViewController {
    
    // Outlets of TableView and Activity Indicator elements
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Create each row entry with respect to (wrt) declared Model: HPManager
    private var entries: [HPManager] = []
    var choiceName: String = ""
    var choiceURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set TableView properties
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: "SpellsCell", bundle: nil), forCellReuseIdentifier: "SpellsCellIdentifier")
        
        // Call the function which handles data fetch operation
        fetchData()
    }
}

//MARK: - TableView Extensions
extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension TableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Introduce our custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpellsCellIdentifier", for: indexPath) as! SpellsCell
        // Introduce our row
        let indexRow = indexPath.row
        // Call the function which modifies our cell component wrt the fetched data
        determineContent(cell, indexRow)
        
        return cell
    }
}

//MARK: - Controller Extensions
extension TableViewController {
    
    // this function obtain the data
    func fetchData() {
        // 1. Create the URL
        if let url = URL(string: choiceURL) {
            
            // 2. Create the Session
            let session = URLSession.shared

            // 3. Create the Request
            var request: URLRequest = .init(url: url)
            request.httpMethod = "GET"
            
            // 4. Give session a task with the request
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
                if error != nil {
                    print("Task not completed!")
                    return
                }
                
                // make sure we have data to decode
                if let data = data {
                    //call our JSON parsing function
                    self.parseJson(data)
                }
            }
            //5. Start the task
            task.resume()
        }
    }
    
    // this function decodes incoming data
    func parseJson(_ data: Data) {
        do {
            // decode incoming data wrt my Model declared in HPManager
            let entries = try JSONDecoder().decode([HPManager].self, from: data)
            self.entries = entries
            
            // Things to do when the data is ready to show
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.loadingLabel.isHidden = true
                self.tableView.separatorStyle = .singleLine
            }
        } catch {
            print("decoding error")
        }
    }
    
    // This functions modifies the UI wrt the clicked button and incoming data
    func determineContent(_ cell: SpellsCell,_ indexRow: Int) {
        
        // Change the Name label (upper one)
        cell.entryNameLabel.text = entries[indexRow].name
        
        // Change imageView and Description label
        switch choiceName {
        case "Characters":
            cell.entryDescriptionLabel.text = entries[indexRow].house
            cell.entryImage.image = UIImage(named: "witch")
        case "Spells":
            cell.entryDescriptionLabel.text = entries[indexRow].description
            cell.entryImage.image = UIImage(named: "wand2")
        case "Elixirs":
            cell.entryDescriptionLabel.text = entries[indexRow].effect
            cell.entryImage.image = UIImage(named: "cauldron")
        default:
            print("Error: Wrong entry")
        }
        
        // Modifies cell BG color wrt house of character
        let house = entries[indexRow].house
        switch  house {
        case "Gryffindor":
            cell.backgroundColor = #colorLiteral(red: 0.4549019608, green: 0, blue: 0.003921568627, alpha: 1)
            cell.entryNameLabel.textColor = .white
            cell.entryDescriptionLabel.textColor = .white
        case "Slytherin":
            cell.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.2784313725, blue: 0.1647058824, alpha: 1)
            cell.entryNameLabel.textColor = .white
            cell.entryDescriptionLabel.textColor = .white
        case "Hufflepuff":
            cell.backgroundColor = #colorLiteral(red: 1, green: 0.8470588235, blue: 0, alpha: 1)
            cell.entryNameLabel.textColor = .black
            cell.entryDescriptionLabel.textColor = .black
        case "Ravenclaw":
            cell.backgroundColor = #colorLiteral(red: 0.05490196078, green: 0.1019607843, blue: 0.2509803922, alpha: 1)
            cell.entryNameLabel.textColor = .white
            cell.entryDescriptionLabel.textColor = .white
        case "":
            cell.backgroundColor = .white
            cell.entryNameLabel.textColor = .black
            cell.entryDescriptionLabel.textColor = .black
        default:
            cell.backgroundColor = .white
            cell.entryNameLabel.textColor = .black
            cell.entryDescriptionLabel.textColor = .black
        }
    }
}
