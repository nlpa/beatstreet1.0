//
//  ViewController.swift
//  beatstreet1.0
//
//  Created by Natalie Lampa on 12/9/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickWardHelp(_ sender: UIButton) {
        UIApplication.shared.open(URL(string:"https://www.chicago.gov/city/en/about/wards.html")! as URL, options: [:], completionHandler: nil)
        
    }
    
    
    @IBAction func unwindToRed(unwindSegue: UIStoryboardSegue) { } // func used to revert setting screen to menu


}

