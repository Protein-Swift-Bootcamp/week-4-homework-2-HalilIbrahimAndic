//
//  TableViewController.swift
//  Earthquake Tracker
//
//  Created by Halil Ibrahim Andic on 31.12.2022.
//

import UIKit

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var earthquakes = Earthquake(features: [Feature(properties: Properties(url: "", title: ""))])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: "EarthquakeCell", bundle: nil), forCellReuseIdentifier: "EarthquakeCellIdentifier")
        
        fetchData()
    }
    
    func fetchData() {
        //1. Create a URL
        if let url = URL(string: "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&minlatitude=35.9025&maxlatitude=42.02683&minlongitude=25.90902&maxlongitude=44.5742&starttime=2022-01-01") {
            
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
            let earthquakes = try JSONDecoder().decode(Earthquake.self, from: data)
            self.earthquakes = earthquakes
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("decoding error")
        }
    }
}

//MARK: - EXTENSIONS

extension TableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eqURL = URL(string: earthquakes.features[indexPath.row].properties.url)!
        UIApplication.shared.open(eqURL)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension TableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earthquakes.features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EarthquakeCellIdentifier", for: indexPath) as! EarthquakeCell
        
        //datamızı cell'in içine basıyoruz
        cell.eqNameLabel.text = earthquakes.features[indexPath.row].properties.title
        
        return cell
    }
}
