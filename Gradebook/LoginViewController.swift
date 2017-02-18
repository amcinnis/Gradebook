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
    
    private var loader : GradebookURLLoader?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func testLogin(_ sender: Any) {
        urlTextField.text = "https://users.csc.calpoly.edu/~bellardo/cgi-bin/test/grades.json"
        loginTextField.text = "test"
        passwordTextField.text = "fSxgQfMdm6"
    }
    
    @IBAction func liveLogin(_ sender: Any) {
        urlTextField.text = "https://users.csc.calpoly.edu/~bellardo/cgi-bin/grades.json"
        loginTextField.text = "amcinnis"
    }
    
    @IBAction func login(_ sender: Any) {
        loader = GradebookURLLoader()
        loader?.baseUrlStr = urlTextField.text!
        loader?.login(username: loginTextField.text!, password: passwordTextField.text!) {
            [weak self] (result: Bool) in
            guard let this = self else { return }
            guard result == true else { return }
            print("Auth worked!")
            this.performSegue(withIdentifier: "ShowSections", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSections" {
            if let navVC = segue.destination as? UINavigationController {
                if let dest = navVC.topViewController as? SectionsTableViewController {
                    dest.loader = loader
                }
            }
        }
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
