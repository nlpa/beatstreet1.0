//
//  ReportViewController.swift
//  beatstreet1.0
//
//  Created by Natalie Lampa on 7/29/20.
//

import Foundation
import UIKit
import Firebase
import SDWebImage

class ReportViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var mobileNumber: UITextField!
    @IBOutlet var wardInput: UITextField!
    @IBOutlet var imgInput: UIImageView!
    
    let listToUsers = "ListToUsers"
    
    var items: [Report] = []
    var user: User!
    var userCountBarButtonItem: UIBarButtonItem!
    var reportType = "beat street"
    let rootRef = Database.database().reference()
    let ref = Database.database().reference(withPath: "reports")
//    let usersRef = Database.database().reference(withPath: "online")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    // To upload Images or to take a pic with the camera
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func chooseImage(_ sender: Any)
    {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController (title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true)
            } else {
                print("no camera")
            }
        }
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true)
            
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(libraryAction)
        present(actionSheet, animated: true)
        
}
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: true)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = image
            
            let dateFormatter = DateFormatter()
            let date = Date(timeIntervalSinceReferenceDate: 118800)
            dateFormatter.locale = Locale(identifier: "en_US")
            print(dateFormatter.string(from: date)) // Jan 2, 2001
            
            
            // Data in memory -- save to database
            var data = Data()
            data = image.jpegData(compressionQuality: 0.8)! as Data
            
            // set upload path
            let filePath = "/image/report.jpg" // path where you wanted to store img in storage
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"

            let imageRef = Storage.storage().reference()
            imageRef.child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let size = metaData!.size
                // You can also access to download URL after upload.
                imageRef.downloadURL { (url, error) in
                  guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                  }
                }
            }
//            // Create a ref to the file we are uploading
//            let imageRef = Storage.storage().reference().child("images/report.jpg");
//
//            // Upload file to the path
//            _ = imageRef.put(data, metadata: nil) {metadata, error} in
//            guard let metadata = metadata else {
//                // error
//                return
//            }
//            let downloadURL = metadata.downloadURL()
        }
        else{
            print("no image")

        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    //-------------------------------
//    @IBOutlet weak var TitleScreenLable: UILabel! // label will switch fron beat street to bestowed road when slectd
    
    @IBOutlet weak var segue: UISegmentedControl! // stands as the segue selction for beat street or bestowed road
    
    @IBAction func segueChangeSelect(_ sender: Any) // when one is selected the reportType will be updated
    {
        
        
        if segue.selectedSegmentIndex == 0 // zero for option 1 "Report a Street"
        {
//            TitleScreenLable.text = "Report A Street"
            self.reportType = "beat street"
        }
        
        if segue.selectedSegmentIndex == 1 // one for option 2 "Submit Bestowed Road"
        {
//            TitleScreenLable.text = "Submit A Bestowed Road"
            self.reportType = "bestowed road"
        }
        
        
    }// [segueChangeSelect END]
    
    
    @IBAction func onWardButtonPress(_ sender: UIButton) // button used to guide users to alderman website if help is needed ("ward num")
    {
        UIApplication.shared.open(URL(string:"https://www.chicago.gov/city/en/depts/mayor/iframe/lookup_ward_and_alderman.html")! as URL, options: [:], completionHandler: nil)
    } // [onWardButtonPress end]
    
 
//    @IBAction func wardDismiss(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }

    
    @IBAction func onSubmitPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Report Submission",
                                      message: "Would you like to submit your report?",
                                      preferredStyle: .alert)
        
        
        
        let submitAction = UIAlertAction(title: "Submit",
                                       style: .default) { _ in
            // 1
            guard let text = self.mobileNumber.text else {return}
            guard let wardText = Int(self.wardInput.text!) else {return}

            self.rootRef.child("reports/" + text).observeSingleEvent(of: .value, with: { (snapshot) in
                //update votes if mobileNumber report exists
                if snapshot.exists(){
                    self.updateCount(str: text)
                }else{ // make new report
                    // 2
                    let report = Report(type: self.reportType, mobileNumber: text, ward: wardText, votes: 1)
                    // 3 unsure if #3/4 needed??
                    let reportRef = self.ref.child(text.lowercased())

                    // 4
                    reportRef.setValue(report.toAnyObject())
                }
            })
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)

    }
    
    func updateCount(str: String) {
       let votesRef = self.ref.child(str).child("votes")
       votesRef.observeSingleEvent(of: .value, with: { snapshot in
          var currentCount = snapshot.value as? Int ?? 0
          currentCount += 1
          votesRef.setValue(currentCount)
       })
    }
    
    
}// [class end]
