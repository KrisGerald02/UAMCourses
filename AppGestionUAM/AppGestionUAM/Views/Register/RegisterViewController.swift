//
//  RegisterViewController.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 17/11/24.
//
import UIKit


class RegisterViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    //ViewModel
    private var registerViewModel = RegisterViewModel()
    
    
    // MARK: - Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBindings()
        setAllElements()
        gestosKeyboard()
        setupTextField()
        //Login Button
        registerButton.layer.cornerRadius = 10
        registerButton.clipsToBounds = true
        //Animation Email
        // Configura el borde inicial del text field
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.05).cgColor
        emailTextField.layer.cornerRadius = 5
        //Animacion Password
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.05).cgColor
        passwordTextField.layer.cornerRadius = 5
        
        //Animacion Name
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.05).cgColor
        nameTextField.layer.cornerRadius = 5
        
        
        // Configura los eventos de inicio y fin de edición
        nameTextField.addTarget(self, action: #selector(nameTextFieldEditingDidBegin(_:)), for: .editingDidBegin)
        nameTextField.addTarget(self, action: #selector(nameTextFieldEditingDidEnd(_:)), for: .editingDidEnd)
        
        // Configura los eventos de inicio y fin de edición para passwordTextField
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldEditingDidBegin(_:)), for: .editingDidBegin)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldEditingDidEnd(_:)), for: .editingDidEnd)
        
        emailTextField.addTarget(self, action: #selector(emailTextFieldEditingDidBegin(_:)), for: .editingDidBegin)
        emailTextField.addTarget(self, action: #selector(emailTextFieldEditingDidEnd(_:)), for: .editingDidEnd)
        
    }
    
    
    
    
    
    
    @objc func emailTextFieldEditingDidBegin(_ sender: UITextField) {
        // Cuando el campo es tocado, cambiamos el borde a teal con animación
        UIView.animate(withDuration: 0.3) {
            sender.layer.borderColor = UIColor.systemTeal.cgColor
        }
    }
    
    @objc func emailTextFieldEditingDidEnd(_ sender: UITextField) {
        // Cuando el campo deja de ser tocado, se restaura el borde a su color por defecto
        UIView.animate(withDuration: 0.3) {
            sender.layer.borderColor = UIColor.gray.withAlphaComponent(0.05).cgColor  // Borde gris por defecto
        }
    }
    
    // Animación para passwordTextField cuando se toca
    @objc func passwordTextFieldEditingDidBegin(_ sender: UITextField) {
        UIView.animate(withDuration: 0.3) {
            sender.layer.borderColor = UIColor.systemTeal.cgColor
        }
    }
    
    // Animación para passwordTextField cuando deja de ser tocado
    @objc func passwordTextFieldEditingDidEnd(_ sender: UITextField) {
        UIView.animate(withDuration: 0.3) {
            sender.layer.borderColor = UIColor.gray.withAlphaComponent(0.05).cgColor  // Borde gris muy tenue
        }
    }
    
    // Animación para passwordTextField cuando se toca
    @objc func nameTextFieldEditingDidBegin(_ sender: UITextField) {
        UIView.animate(withDuration: 0.3) {
            sender.layer.borderColor = UIColor.systemTeal.cgColor
        }
    }
    
    // Animación para passwordTextField cuando deja de ser tocado
    @objc func nameTextFieldEditingDidEnd(_ sender: UITextField) {
        UIView.animate(withDuration: 0.3) {
            sender.layer.borderColor = UIColor.gray.withAlphaComponent(0.05).cgColor  // Borde gris muy tenue
        }
    }
    
    func gestosKeyboard(){
        //Gesto para quitar
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Configuración de bindings
    private func configureBindings() {
        registerViewModel.errorMessageHandler = { [weak self] errorMessage in
            self?.showError(message: errorMessage)
        }
        
        registerViewModel.registrationStatusHandler = { [weak self] isSuccess in
            if isSuccess {
                self?.showSuccessMessage()
                self?.navigateToLogin()
            }
        }
    }
    
    // MARK: - Tap en "Register"
    @IBAction func tapOnRegister(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showError(message: "Please fill in all fields.")
            return
        }
        
        registerViewModel.register(name: name, email: email, password: password)
    }
    
    @IBAction func btnLogInn(_ sender: Any) {
        let loginViewController = LoginViewController()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    // MARK: - Helpers
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showSuccessMessage() {
        let alert = UIAlertController(title: "Exito", message: "Registro exitoso!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigateToLogin()
        }))
        present(alert, animated: true)
    }
    // MARK: - Navegación
    private func navigateToCourseList() {
        // navigationController?.pushViewController(courseListViewController, animated: true)
    }
    
    func navigateToLogin(){
        let loginViewController = LoginViewController()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    private func setAllElements() {
        navigationItem.hidesBackButton = true
        
        // Definir el color personalizado
        let customColor = UIColor(red: 68/255, green: 153/255, blue: 167/255, alpha: 1.0)
        
        // Crear botones
        let btnCreate = UIButton(type: .system)
        let btnLogIn = UIButton(type: .system)
        
        // Configuración "Crear Cuenta"
        btnCreate.setTitle("Crear Cuenta", for: .normal)
        btnCreate.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btnCreate.backgroundColor = customColor
        btnCreate.setTitleColor(.white, for: .normal)
        btnCreate.layer.cornerRadius = 10
        btnCreate.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        btnCreate.addTarget(self, action: #selector(goToRegister(_:)), for: .touchUpInside)
        
        // Configuración "Iniciar Sesión"
        btnLogIn.setTitle("Iniciar Sesión", for: .normal)
        btnLogIn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btnLogIn.backgroundColor = .white
        btnLogIn.setTitleColor(customColor, for: .normal)
        btnLogIn.layer.cornerRadius = 10
        btnLogIn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        btnLogIn.layer.borderWidth = 2
        btnLogIn.layer.borderColor = customColor.cgColor
        btnLogIn.addTarget(self, action: #selector(goToLogin(_:)), for: .touchUpInside)
        
        // Usar UIStackView
        let stackView = UIStackView(arrangedSubviews: [btnCreate, btnLogIn])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        
        // Agregar StackView a la vista
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // Constraints
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -5),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            stackView.widthAnchor.constraint(equalToConstant: 340),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Guardar referencias a los botones en propiedades para usarlos en la animación
        self.btnCreate = btnCreate
        self.btnLogIn = btnLogIn
    }
    
    // Referencias de los botones como propiedades de la clase
    private var btnCreate: UIButton!
    private var btnLogIn: UIButton!
    
    // Navegar a LoginViewController con animación de color
    @objc func goToLogin(_ sender: UIButton) {
        sender.isEnabled = false
        let customColor = UIColor(red: 68/255, green: 153/255, blue: 167/255, alpha: 1.0)
        
        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut, animations: {
            self.btnCreate.backgroundColor = .white
            self.btnCreate.setTitleColor(customColor, for: .normal)
            
            self.btnLogIn.backgroundColor = customColor
            self.btnLogIn.setTitleColor(.white, for: .normal)
            
            self.view.layoutIfNeeded()
        }, completion: { _ in
            let loginVC = LoginViewController()
            self.navigationController?.pushViewController(loginVC, animated: false)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                sender.isEnabled = true
            }
        })
        
        
        //Email textfield
        emailTextField.borderStyle = .roundedRect
        emailTextField.layer.cornerRadius = 6
        emailTextField.clipsToBounds = true
        
        //Password Textfield
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.cornerRadius = 6
        passwordTextField.clipsToBounds = true
        
        //Nombre
        nameTextField.borderStyle = .roundedRect
        nameTextField.layer.cornerRadius = 6
        nameTextField.clipsToBounds = true
        

        
        
    }
    
    // Navegar a RegisterViewController sin animación
    @objc func goToRegister(_ sender: UIButton) {
        sender.isEnabled = false
        
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            sender.isEnabled = true
        }
    }
    
    // Función para agregar borde personalizado a "Crear Cuenta"
    func addBorder(to button: UIButton, excludeRight: Bool = false, color: UIColor) {
        let borderLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        let width = button.bounds.width
        let height = button.bounds.height
        
        if path.isEmpty { path.move(to: CGPoint(x: 0, y: height)) }
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        if !excludeRight { path.addLine(to: CGPoint(x: width, y: height)) }
        
        borderLayer.path = path.cgPath
        borderLayer.strokeColor = color.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 2
        
        button.layer.addSublayer(borderLayer)
    }
    
    
    //MARK: - Configuracion de Text Field
    func setupTextField() {
        
        let lockIcon = UIImageView(image: UIImage(systemName: "lock"))
        lockIcon.tintColor = .systemTeal
        lockIcon.contentMode = .scaleAspectFit
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: passwordTextField.frame.height))
        lockIcon.frame = CGRect(x: 10, y: (paddingView.frame.height - 20) / 2, width: 20, height: 20)
        
        paddingView.addSubview(lockIcon)
        
        passwordTextField.leftView = paddingView
        passwordTextField.leftViewMode = .always
        
        let emailIcon = UIImageView(image: UIImage(systemName: "envelope"))
        emailIcon.tintColor = .systemTeal
        emailIcon.contentMode = .scaleAspectFit
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: emailTextField.frame.height))
        emailIcon.frame = CGRect(x: 10, y: (leftPaddingView.frame.height - 20) / 2, width: 20, height: 20)
        leftPaddingView.addSubview(emailIcon)
        
        emailTextField.leftView = leftPaddingView
        emailTextField.leftViewMode = .always
        
        let nameIcon = UIImageView(image: UIImage(systemName: "person"))
        nameIcon.tintColor = .systemTeal
        nameIcon.contentMode = .scaleAspectFit
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: nameTextField.frame.height))
        nameIcon.frame = CGRect(x: 10, y: (leftView.frame.height - 20) / 2, width: 20, height: 20)
        leftView.addSubview(nameIcon)
        
        nameTextField.leftView = leftView
        nameTextField.leftViewMode = .always
        
    }
    
}
