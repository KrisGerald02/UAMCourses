//
//  RegisterViewModel.swift
//  AppGestionUAM
//
//


import Foundation

class RegisterViewModel {
    // MARK: - Propiedades
    var name: String = ""
    var email: String = ""
    var password: String = ""

    // Handlers for View Communication
    var errorMessageHandler: ((String) -> Void)?
    var registrationStatusHandler: ((Bool) -> Void)?

    // MARK: - Metodos
    func register(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password

        // Validations
        guard validateFields() else { return }

        // Simulate API Call
        Task {
            do {
                let response = try await APIClient.shared.register(
                    name: self.name,
                    email: self.email,
                    password: self.password
                )
                DispatchQueue.main.async {
                    self.registrationStatusHandler?(true)
                    print("Registration successful: \(response.user.name)")
                }
            } catch let apiError as APIError {
                DispatchQueue.main.async {
                    self.errorMessageHandler?(apiError.localizedDescription)
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessageHandler?("An unknown error occurred.")
                }
            }
        }
    }

    // MARK: - Privados
    private func validateFields() -> Bool {
        if name.isEmpty || email.isEmpty || password.isEmpty {
            errorMessageHandler?("All fields are required.")
            return false
        }

        guard isValidEmail(email) else {
            errorMessageHandler?("Please enter a valid email address.")
            return false
        }

        return true
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return predicate.evaluate(with: email)
    }
}
