//
//  User.swift
//  beatstreet 1.0
//
//  Created by Natalie Lampa on 12/4/2020.
//


import Foundation
import Firebase

struct User {
  
  let uid: String
  let email: String
  
  init(authData: Firebase.User) {
    uid = authData.uid
    email = authData.email!
  }
  
  init(uid: String, email: String) {
    self.uid = uid
    self.email = email
  }
}
