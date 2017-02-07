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
    var filteredEvents = [Event]()
    
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupTableView()
        setupSearchBar()
    }
    
    private func setupTableView() {
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.placeholder = "Search for Event by Name" // Name for now, we can make this more complex as needed
    }
    
    func filterEvents(forText searchText: String) {
        filteredEvents = events.filter({ (event) -> Bool in
            var matchFound = false
            if let eventName = event.name {
                matchFound = eventName.lowercased().contains(searchText.lowercased())
            }
            return matchFound
        })
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DataManager.sharedInstance.getEvents { (result) in
            switch result {
            case .success(let events):
                self.events = events
                self.tableView.reloadData()
            case .error(let error):
                dump(error)
            }
        }
    }
}

extension ViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        filterEvents(forText: searchText)
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredEvents.count
        }
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PrototypeEventCell else {
            fatalError("Where is our cell!?? 😱")
        }
        
        let event = searchController.isActive && searchController.searchBar.text != "" ? filteredEvents[indexPath.row] : events[indexPath.row]
        cell.event = event
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}

extension ViewController: UITableViewDelegate {

}

class PrototypeEventCell: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var movementIdLabel: UILabel!
    @IBOutlet weak var categoryIdLabel: UILabel!
    @IBOutlet weak var organizationIdLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var updatedTimeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var estimatedSizeLabel: UILabel!
    @IBOutlet weak var actualSizeLabel: UILabel!
    
    var event: Event? {
        didSet {
            if let topNameLabel = contentView.viewWithTag(1) as? UILabel {
                topNameLabel.text = event?.name
            }
            idLabel.text = String(describing: event?.id)
            movementIdLabel.text = String(describing: event?.movementId)
            categoryIdLabel.text = String(describing: event?.categoryId)
            organizationIdLabel.text = String(describing: event?.organizationId)
            nameLabel.text = event?.name
            timeLabel.text = String(describing: event?.time)
            createdTimeLabel.text = String(describing: event?.created)
            updatedTimeLabel.text = String(describing: event?.updated)
            cityLabel.text = event?.city
            stateLabel.text = event?.state
            locationLabel.text = event?.location
            descriptionLabel.text = event?.description
            tagsLabel.text = event?.tags?.joined(separator: ", ") ?? "No Tags"
            linkLabel.text = event?.link?.absoluteString
            estimatedSizeLabel.text = String(describing: event?.estimatedSize)
            actualSizeLabel.text = String(describing: event?.actualSize)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for infoLabel in contentView.subviews where infoLabel is UILabel && infoLabel.tag != 100 {
            (infoLabel as? UILabel)?.text = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
