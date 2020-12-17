//
//  Report.swift
//  beatstreet 1.0
//
//  Created by Natalie Lampa on 12/4/2020.
//

import Foundation
import Firebase

struct Report {
  
    let ref: DatabaseReference?
    let key: String
    let type: String
    let mobileNumber: String
    let ward: Int
    let imageName: String
    let votes: Int

//  let addedByUser: String
  
    init(type: String, mobileNumber: String, ward: Int, image: String, votes: Int, key: String = "") {
        self.ref = nil
        self.key = key
        self.type = type
        self.mobileNumber = mobileNumber
        self.ward = ward
        self.votes = votes
        self.imageName = image
//    self.addedByUser = addedByUser
  }

      init?(snapshot: DataSnapshot) {
        guard
          let value = snapshot.value as? [String: AnyObject], let type = value["type"] as? String,
            let mobileNumber = value["mobileNumber"] as? String, let ward = value["ward"] as? Int, let image = value["imageName"] as? String, let votes = value["votes"] as? Int else {
    //      , let addedByUser = value["addedByUser"] as? String else {
          return nil
        }

        self.ref = snapshot.ref
        self.key = snapshot.key
        self.type = type
        self.mobileNumber = mobileNumber
        self.ward = ward
        self.votes = votes
        self.imageName = image

    //    self.addedByUser = addedByUser
      }

      func toAnyObject() -> Any {
        return [
            "mobileNumber": mobileNumber,
            "ward": ward,
            "votes": votes,
            "type": type,
            "imageName": imageName,
//            "location": location,
    //      "addedByUser": addedByUser,
          
        ]
      }
    
}

