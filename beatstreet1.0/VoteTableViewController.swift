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
    var streets = [Street]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let street1 = Street(name: "1) Pulaski & Foster  113 votes ", image: UIImage(named: "street1"), votes: 108)
        
        let street2 = Street(name: "2) Lake & Laramie    109 votes", image: UIImage(named: "street2"), votes: 87)
        
        let street3 = Street(name: "3) Lawrence & Central  101 votes", image: UIImage(named: "street3"), votes: 46)
        
        let street4 = Street(name: "4) Irving & Austin     094 votes", image: UIImage(named: "street4"), votes: 28)
        
        let street5 = Street(name: "5) 26th & Cicero     086 votes", image: UIImage(named: "street5"), votes: 18)
        
        let street6 = Street(name: "6) Lake & Laramie    082 votes", image: UIImage(named: "street6"), votes: 4)
        
        
        
        streets = [street1, street2, street3, street4 , street5 , street6] // used to append our pre-SET data.
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
        
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return streets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell // cell function to display on screen cell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! StreetTableViewCell
        let street = streets[indexPath.row]          // will tie the street class to the data
        cell.streetLabel.text = street.name         // will display the street names stored in data
        cell.streetImageView.image = street.image! // will display the images stores in data
        // Configure the cell...
            
        return cell
    } // [tableView END]
    
    
    @IBAction func shareButton(_ sender: UIButton) {
        let activityVC = UIActivityViewController(activityItems: ["self.street"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
//    func updateCount(str: String) {
//       let votesRef = self.ref.child(str).child("votes")
//       votesRef.observeSingleEvent(of: .value, with: { snapshot in
//          var currentCount = snapshot.value as? Int ?? 0
//          currentCount += 1
//          votesRef.setValue(currentCount)
//       })
//    }
    
    
    
    
}// [CLASS END]
