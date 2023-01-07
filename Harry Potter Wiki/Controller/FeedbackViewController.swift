//
//  FeedbackViewController.swift
//  Harry Potter Wiki
//
//  Created by Halil Ibrahim Andic on 5.01.2023.
//

import UIKit

class FeedbackViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var feedbackTextField: UITextField!
    
    // feedbackTypes that are defined by the post server
    let feedbackTypes = ["General", "Suggestion", "Bug", "DataError"]
    var feedbackType: String = "General"
    var feedbackMessage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @IBAction func postButton(_ sender: Any) {
        // send the text written in textField as feedbackMessage to request body
        feedbackMessage = feedbackTextField.text ?? ""
        // function that handles all post request and serialize the response
        postData()
    }
}

//MARK: - PickerView - Extensions
// Feedback Types are listed with the help of UIPickerView
extension FeedbackViewController: UIPickerViewAccessibilityDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        feedbackType = feedbackTypes[row]
    }
}

extension FeedbackViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return feedbackTypes.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return feedbackTypes[row]
    }
}

//MARK: - Post Extension
extension FeedbackViewController {
    func postData() {
        let parameters: [String:String] = [
            "feedbackType" : feedbackType,
            "feedback" : feedbackMessage]

        // 1. Create the URL
        if let url = URL(string: "https://wizard-world-api.herokuapp.com/Feedback") {

            // 2. Create the Session
            let session = URLSession.shared
            
            // 3. Create the Request
            var request: URLRequest = .init(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            // convert parameters to data and place it in the body of request
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error{
                print(error.localizedDescription)
                return
            }
            
            // 4. Give session a task with the request
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
                if let error = error {
                    print("Post request error: \(error.localizedDescription)")
                    return
                }
            
                // make sure we have valid (200-209) returned Response
                guard let httpResponse = response as? HTTPURLResponse, (200...209).contains(httpResponse.statusCode)
                else {
                    print("Invalid response received from the server: \(String(describing: response))")
                    return
                }
                
                let responseCode = httpResponse.statusCode
                
                // make sure we have valid returned Data
                guard let responseData = data else {
                    print("nil Data received from the server")
                    return
                }
                // call our JSON serialization function
                self.serializeJson(responseData, responseCode)
            }
            task.resume()
        }
    }
    
    func serializeJson(_ responseData: Data, _ responseCode: Int) {
        do {
            // create JSON object from data
            if (try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String:String]) != nil {
                // show alert when everything is OK
                showAlert(responseCode)
            } else{
                //handle json response
                print("data maybe corrupted or in wrong format")
                throw URLError(.badServerResponse)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func showAlert(_ responseCode: Int) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Posted Successfully", message: "Response Code: \(responseCode)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
