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

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // triggers when cell is clicked
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

//MARK: - UITableViewDataSource
extension TableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpellsCellIdentifier", for: indexPath) as! SpellsCell
        cell.entryNameLabel.text = entries[indexPath.row].name
        
        switch choiceName {
        case "Characters":
            cell.entryDescriptionLabel.text = entries[indexPath.row].house
        case "Spells":
            cell.entryDescriptionLabel.text = entries[indexPath.row].description
        case "Elixirs":
            cell.entryDescriptionLabel.text = entries[indexPath.row].effect
        default:
            print("Error: Wrong entry")
        }
        
        return cell
    }
    
    
}
