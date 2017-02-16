//
//  LoginViewController.swift
//  Gradebook
//
//  Created by Austin McInnis on 2/14/17.
//  Copyright © 2017 Austin McInnis. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var urlTextField: UITextField!
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func testLogin(_ sender: Any) {
        var hey = "hey"
        urlTextField.text = "https://users.csc.calpoly.edu/~bellardo/cgi-bin/test/grades.json"
        loginTextField.text = "test"
        passwordTextField.text = "fSxgQfMdm6"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
