//
//  LoginViewController.swift
//  TimeForColdDrinks
//
//  Created by Vince Lee on 2017/8/29.
//  Copyright © 2017年 Vince Lee. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FacebookLogin
import FacebookCore


class LoginViewController: UIViewController, LoginButtonDelegate {
    
   
    
    @IBOutlet var loginSuperView: UIView!
    
    // facebook login
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        self.dismiss(animated: true, completion: nil)
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error)
                self.activityIndicatorView.stopAnimating()
                return
            }
            self.activityIndicatorView.stopAnimating()
            self.performSegue(withIdentifier: PropertyKeys.loginToMenuSegue, sender: self)
            print("Successfully logged in with facebook...")
        }
        
    }
    //facebook logout
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        print("Facebook logout")
        
    }
    
    
    /** @var handle
     @brief The handler for the auth state listener, to allow cancelling later.
     */
    var handle: AuthStateDidChangeListenerHandle?
    
    
    @IBAction func loginRegisterIndexChanged(_ sender: Any) {
        
        let button = emailLoginRegisterOutletButton
        switch loginRegisterSegment.selectedSegmentIndex
        {
        case 0:
            button?.setTitle("Register", for: .normal)
            nameTextField.isHidden = false
        case 1:
            button?.setTitle("Login", for: .normal)
            nameTextField.isHidden = true
        default:
            break
        }
    }
    @IBOutlet weak var loginRegisterSegment: UISegmentedControl!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailLoginRegisterOutletButton: UIButton!
    
    @IBAction func emailLoginRegisterButton(_ sender: Any) {
        activityIndicatorView.startAnimating()
        handleLoginRegister()
    }
    
    @IBOutlet weak var goCheckYourDrinkButton: UIButton!
    
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    
    func addFacebookButton() {
        let facebookLoginButton = LoginButton(readPermissions: [ .publicProfile, .email, .publicProfile ])
        facebookLoginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(facebookLoginButton)
        
        
        //facebook button design
        // need x, y, width, heigh constraints
        
        facebookLoginButton.centerXAnchor.constraint(equalTo: loginSuperView.centerXAnchor).isActive = true
        facebookLoginButton.topAnchor.constraint(equalTo: emailLoginRegisterOutletButton.bottomAnchor, constant: 20).isActive = true
        facebookLoginButton.widthAnchor.constraint(equalTo: emailLoginRegisterOutletButton.widthAnchor).isActive = true
        facebookLoginButton.heightAnchor.constraint(equalTo:emailLoginRegisterOutletButton.heightAnchor).isActive = true
        
        
        facebookLoginButton.delegate = self
    }
    
    @IBOutlet var buttonLayout: [UIButton]!
    
    @IBAction func logoutButton(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("LogoutSuccess")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutDesign()
        addFacebookButton()
        goCheckYourDrinkButton.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser != nil {
            goCheckYourDrinkButton.isHidden = false
        performSegue(withIdentifier: PropertyKeys.loginToMenuSegue, sender: true)
        } else {
            goCheckYourDrinkButton.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text
            else {
                print("RegisterError")
                return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion:
            { (user, error) in
                
                if error != nil {
                    print(error!)
                    self.failToLoginRegister()
                    return
                } else {
                }
                guard let uid = user?.uid else {
                    return
                }
                
                let value = ["name": name, "email": email]
                
                
                self.updataDisplayName(name: name)
                self.registerUserIntoDatabase(uid: uid, value: value as [String : AnyObject])
                
        })
    }
    
    func updataDisplayName(name: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { (error) in
            // ...
        }
    }
    
    private func registerUserIntoDatabase(uid: String, value: [String: AnyObject]) {
        let ref = Database.database().reference()
        let userReference = ref.child("users").child(uid)
        userReference.updateChildValues(value, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            
            //            self.messageController?.fetchUserAndSetupNavBarTitle()
            //            self.messageController?.navigationItem.title = value["name"] as? String
            
            //this setter potentially crasher if key don't match
            //            drink.setValuesForKeys(value)
            self.activityIndicatorView.stopAnimating()
            self.performSegue(withIdentifier: PropertyKeys.loginToMenuSegue, sender: self)
            
        })
        
    }
    
    func handleLogin() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("EmailLoginError")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
                self.failToLoginRegister()
                return
            } else {
                self.activityIndicatorView.stopAnimating()
                self.performSegue(withIdentifier: PropertyKeys.loginToMenuSegue, sender: self)
            }
            
            print("welcome \(String(describing: user?.email).description) login success")
        }
    }
    
    func handleLoginRegister() {
        if loginRegisterSegment.selectedSegmentIndex == 0 {
            handleRegister()
            
        } else {
            handleLogin()
        }
    }
    
    func layoutDesign() {
        for button in buttonLayout {
            button.layer.cornerRadius = 5
        }
    }
    
    func failToLoginRegister() {
        let cancelAction = UIAlertAction(title: "Retry", style: .cancel, handler: nil)
        let alertController = UIAlertController(title: "Error", message: "Wrong login information. Passwords must be above 6 characters or email has been registered", preferredStyle: .alert)
        
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: self.activityIndicatorView.stopAnimating)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    /*
     func checkLoginInfoThenPerformSegue() {
     if Auth.auth().currentUser != nil {
     performSegue(withIdentifier: PropertyKeys.loginToMenuSegue, sender: self)
     return
     } else {
     failToLoginRegister()
     }// No user is signed in.
     // ...
     }
     */
    // facebook login delegate
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        self.activityIndicatorView.startAnimating()
        if let currentFbsdkAccessToken = FBSDKAccessToken.current() {
            let credential = FacebookAuthProvider.credential(withAccessToken: currentFbsdkAccessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    print(error)
                    return
                }
                guard let uid = user?.uid else {
                    return
                }
                let value = ["name": user?.displayName, "email": user?.email]
                self.registerUserIntoDatabase(uid: uid, value: value as [String : AnyObject])
                print("Successfully logged in with facebook...")
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Facebook logout")
    }
}


// FB Login
//extension LoginViewController {
//    @objc func loginButtonClicked() {
//        let loginManager = LoginManager()
//        loginManager.logIn([ .publicProfile, .email, .publicProfile ], viewController: self) { loginResult in
//            switch loginResult {
//            case .failed(let error):
//                print(error)
//            case .cancelled:
//                print("FB Use cancelled login.")
//            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
//                print("FB Logged in!")
//            }
//        }
//    }
//
//}
//
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


