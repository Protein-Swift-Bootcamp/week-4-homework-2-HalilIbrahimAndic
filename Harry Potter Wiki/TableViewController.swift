//
//  TableViewController.swift
//  Harry Potter Wiki
//
//  Created by Halil Ibrahim Andic on 3.01.2023.
//

import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var entries: [HPManager] = []
    var choiceName: String = ""
    var choiceURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: "SpellsCell", bundle: nil), forCellReuseIdentifier: "SpellsCellIdentifier")
        
        fetchData()
    }
    
    func fetchData() {
        //1. Create a URL
        if let url = URL(string: choiceURL) {
        //if let url = URL(string: "https://api.coingecko.com/api/v3/coins/list") {

            //2. Create a URL Request
            var request: URLRequest = .init(url: url)
            request.httpMethod = "GET"
            
            //3. Give session a task with request
            let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                if error != nil {
                    print("Task not completed!")
                    return
                }
                
                if let data = data {
                    //call JSON parsing function
                    self.parseJson(data)
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJson(_ data: Data) {
        do {
            let entries = try JSONDecoder().decode([HPManager].self, from: data)
            self.entries = entries
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("decoding error")
        }
    }
}

//MARK: - TableView - Delegate
extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//MARK: - TableView - Data Source
extension TableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpellsCellIdentifier", for: indexPath) as! SpellsCell
        let indexRow = indexPath.row
        
        determineContent(cell, indexRow)
        return cell
    }
}

//MARK: - EXTENSION
extension TableViewController {
    
    func determineContent(_ cell: SpellsCell,_ indexRow: Int) {
        cell.entryNameLabel.text = entries[indexRow].name
        
        // Modifies cell content wrt selected button
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
