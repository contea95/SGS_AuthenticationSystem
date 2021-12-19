//
//  LoginController.swift
//  SGS_SideProject
//
//  Created by 한상혁 on 2021/12/19.
//

import UIKit

class LoginController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = LoginViewModel()
    
    
    private let iconImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let emailTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(UIColor(white: 1, alpha: 0.5), for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Don't have an account? ", secondPart: "Sign Up")
        button.addTarget(self, action: #selector(handleShowSignup), for: .touchUpInside)
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Forgot your password? ", secondPart: "Get help signing in.")
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNotificationObservers()
    }
    
    // MARK: - Actions
    
    @objc func handleLogin(sender: UITextField) {
        // 이메일 형식 체크
        if isValidEmail(testStr: emailTextField.text!) {
            // 이메일 형식 OK
            
            // Login 체크
            LoginService(email: emailTextField.text!, password: passwordTextField.text!) { itOK in
                if itOK == 200 {
                    let controller = ClientLoginController()
                    controller.userEmail = self.emailTextField.text!

                    controller.modalPresentationStyle = .fullScreen
                    controller.modalTransitionStyle = .crossDissolve
                    self.present(controller, animated: true, completion: nil)
                } else if itOK == 404 {
                    let alert = UIAlertController(title: "This Email is not Registered" , message: "Please Sign Up using this Email", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    
                    alert.addAction(okButton)
    
                    self.present(alert, animated: true, completion: nil)
                } else if itOK == 500 {
                    let alert = UIAlertController(title: "You Input Incorrect Password" , message: "Please Check Password", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    
                    alert.addAction(okButton)
    
                    self.present(alert, animated: true, completion: nil)
                } else if itOK == 401 {
                    let alert = UIAlertController(title: "It's Login Error" , message: "Please Try Later", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    
                    alert.addAction(okButton)
    
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "You are not a registered member." , message: "Please Check Email or Password", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    
                    alert.addAction(okButton)
    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            // 이메일 형식 NO
            let alert = UIAlertController(title: "The Email Format is not correct." , message: "Please Check Email or Password", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(okButton)
            
            self.present(alert, animated: true, completion: nil)
        }
//        LoginService(email: emailTextField.text!, password: passwordTextField.text!)
        
    }
    
    @objc func handleShowSignup() {
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        updateForm()
    }
    
    // MARK: - Helper
    
    func configureUI() {
        configureGradientLayer()
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        
        // 로고 그림 설정
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        // 스택 뷰 설정
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, forgotPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

// MARK: - FormViewModel
extension LoginController: FormViewModel {
    func updateForm() {
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        loginButton.isEnabled = viewModel.formIsValid
    }
}
