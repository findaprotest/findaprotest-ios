//
//  ViewController.swift
//  FindAProtest
//
//  Created by Pratikbhai Patel on 2/3/17.
//  Copyright © 2017 Find a Protest. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var events = [Event]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.sharedInstance.getevents { (result) in
            switch result {
            case .success(let events):
                self.events = events
                self.tableView.reloadData()
            case .error(let error):
                self.show(error: error, completion: nil)
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = events[indexPath.row].name 
        
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {

}
