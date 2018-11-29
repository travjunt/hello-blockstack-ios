//
//  ViewController.swift
//  hello-blockstack-ios
//
//  Created by Travis McCormick on 11/29/18.
//  Copyright © 2018 Travis McCormick. All rights reserved.
//

import UIKit
import Blockstack

class ViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            if Blockstack.shared.isUserSignedIn() {
                // Read user profile data
                let retrievedUserData = Blockstack.shared.loadUserData()
                print(retrievedUserData?.profile?.name as Any)
                let name = retrievedUserData?.profile?.name ?? "Nameless Person"
                self.nameLabel?.text = "Hello, \(name)"
                self.nameLabel?.isHidden = false
                self.signInButton?.setTitle("Sign Out", for: .normal)
                print("UI update SIGNED_IN")
            } else {
                self.nameLabel?.text = "hello-blockstack-ios"
                self.signInButton?.setTitle("Sign into Blockstack", for: .normal)
                print("UI update SIGNED_OUT")
            }
        }
    }

    @IBAction func signIn(_ sender: UIButton) {
        if Blockstack.shared.isUserSignedIn() {
            print("Currently signed in so signing out.")
            Blockstack.shared.signUserOut()
            self.updateUI()
        } else {
            print("Currently signed out so signing in.")
            Blockstack.shared.signIn(
                redirectURI: "https://heuristic-brown-7a88f8.netlify.com/redirect.html",
                appDomain: URL(string: "https://heuristic-brown-7a88f8.netlify.com")!) {
                    authResult in
                        switch authResult {
                            case .success(let userData):
                                print("Sign in SUCCESS", userData.profile?.name as Any)
                                self.updateUI()
                            case .cancelled:
                                print("Sign in CANCELLED")
                            case .failed(let error):
                                print("Sign in FAILED, error: ", error ?? "n/a")
                        }
                }
        }
        
    }

}

