//
//  SecondUIKitViewController.swift
//  SampleApp
//
//  Created by bruno on 7/22/25.
//

import UIKit

// MARK: - Second UIKit View Controller
class SecondUIKitViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGreen
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "Second UIKit View"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        
        let pushButton = UIButton(type: .system)
        pushButton.setTitle("SwiftUI Navigation으로 Push", for: .normal)
        pushButton.setTitleColor(.white, for: .normal)
        pushButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        pushButton.backgroundColor = .systemBlue
        pushButton.layer.cornerRadius = 8
        pushButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        pushButton.addTarget(self, action: #selector(pushSwiftUINavigation), for: .touchUpInside)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(pushButton)
        
        let titleLabel2 = UILabel()
        titleLabel2.text = "Root View"
        titleLabel2.textColor = .white
        titleLabel2.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel2.textAlignment = .center
        
        let pushButton2 = UIButton(type: .system)
        pushButton2.setTitle("Pop To Root View", for: .normal)
        pushButton2.setTitleColor(.white, for: .normal)
        pushButton2.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        pushButton2.backgroundColor = .systemBlue
        pushButton2.layer.cornerRadius = 8
        pushButton2.contentEdgeInsets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        pushButton2.addTarget(self, action: #selector(popToRootView), for: .touchUpInside)
        
        stackView.addArrangedSubview(titleLabel2)
        stackView.addArrangedSubview(pushButton2)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func pushSwiftUINavigation() {
        AppDelegate.main.router.routeInUIKit(to: .SwiftUIRoot())
    }
    
    @objc private func popToRootView() {
        AppDelegate.main.router.popToRoot()
    }
}
