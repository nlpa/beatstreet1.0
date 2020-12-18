//
//  ReportViewController.swift
//  beatstreet1.0
//
//  Created by Natalie Lampa on 12/7/2020.
//

import UIKit
import Firebase
import SDWebImage

class VoteStreetTableViewController: UITableViewController // view controller holding some basic preset data as examples
{
    var items: [Report] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    //        getReport { (reports) in
    //           print(reports.count)
            // Uncomment the following line to preserve selection between presentations
            // self.clearsSelectionOnViewWillAppear = false

            // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
            // self.navigationItem.rightBarButtonItem = self.editButtonItem
            
        }
    
    
    
    //    func getReport(completion: @escaping ([Report]) -> Void){
    //      var items: [Report] = []
    //      var userCountBarButtonItem: UIBarButtonItem!
    //      var reportType = "beat street"
    //      let reportRef = Database.database().reference().child("Report")
    //      reportRef.observe(.value, with: { (snapshot) in
    //        for snap in snapshot.children {
    //          guard let reportSnap = snap as? DataSnapshot else {
    //            print("Something is wrong with Firebase DataSnapshot")
    //              completion(items)
    //              return
    //          }
    //            let item = Report(snapshot: reportSnap)!
    //            items.append(item)
    //        }
    //        completion(items)
    //      })
    //    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}// [CLASS END]
