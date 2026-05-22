//
//  ViewController.swift
//  MyApp
//

import UIKit

import MyUI
import CobrowseSDK

class ViewController: UIViewController {

    let codeLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        CobrowseIO.instance().delegate = self
        getSession()
        
        view.backgroundColor = .systemBackground
        
        var swiftUIConfig = UIButton.Configuration.filled()
        swiftUIConfig.title = "Show view"

        let swiftUIButton = UIButton(configuration: swiftUIConfig, primaryAction: UIAction { _ in
            MyUI.show()
        })

        var wrappedConfig = UIButton.Configuration.filled()
        wrappedConfig.title = "Show wrapped"

        let wrappedButton = UIButton(configuration: wrappedConfig, primaryAction: UIAction { _ in
            MyUI.showWrapped()
        })

        let stack = UIStackView(arrangedSubviews: [codeLabel, swiftUIButton, wrappedButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    func getSession() {
        
        CobrowseIO.instance().createSession { [unowned self] error, session in
            guard error == nil, let code = session?.code()
                else { return }
            
            codeLabel.text = "\(code)"
        }
    }
}

extension ViewController: CobrowseIODelegate {
    
    func cobrowseSessionDidUpdate(_ session: CBIOSession) {
        guard session.isActive()
            else { return }
        
        codeLabel.text = ""
    }
    
    func cobrowseSessionDidEnd(_ session: CBIOSession) {
        Task {
            getSession()
        }
    }
}
