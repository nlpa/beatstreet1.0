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

// for image upload to firebase storage
import TinyConstraints
import Kingfisher

struct MyKeys {
    static let imagesFolder = "imagesFolder"
    static let imagesCollection = "imagesCollection"
    static let uid = "uid"
    static let imageUrl = "imageUrl"
}

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
        }
        else{
            print("No image")
        }
    }
    
    func uploadPhoto() {
        guard let image = imageView.image,
              let data = image.jpegData(compressionQuality: 1.0) else {
            presentAlert(title: "Error", message: "Something went wrong")
            return
        }
        let imageName = UUID().uuidString
        
        let imgRef = Storage.storage().reference()
            .child(MyKeys.imagesFolder)
            .child(imageName)
        
        imgRef.putData(data, metadata: nil) { (metadata, err) in
            if let err = err {
                self.presentAlert(title: "Error", message: err.localizedDescription)
                return
            }
            imgRef.downloadURL(completion: { (url, err) in
                if let err = err {
                    self.presentAlert(title: "Error", message: err.localizedDescription)
                    return
                }
                guard let url = url else {
                    self.presentAlert(title: "Error", message: "Something went wrong")
                    return
                }
                let dataReference = Firestore.firestore().collection(MyKeys.imagesCollection).document()
                let documentUid = dataReference.documentID
                let urlString = url.absoluteString
                let data = [MyKeys.uid: documentUid,
                            MyKeys.imageUrl: urlString]
                
                dataReference.setData(data, completion: { (err) in
                    if let err = err {
                        self.presentAlert(title: "Error", message: err.localizedDescription)
                        return
                    }
                    
                    UserDefaults.standard.set(documentUid, forKey: MyKeys.uid)
                    self.imageView.image = UIImage()
                    self.presentAlert(title: "Success", message: "Successfully saved image to database")
                })
                
            })
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
            
            self.uploadPhoto()
            
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
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
}// [class end]
