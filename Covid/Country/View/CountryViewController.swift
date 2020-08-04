//
//  CountryViewController.swift
//  Covid
//
//  Created by Kirill Selivanov on 02.08.2020.
//  Copyright © 2020 Kirill Selivanov. All rights reserved.
//

import UIKit

final class CountryViewController: UIViewController {
    
    // MARK: - Properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var presenter: CountryViewOutput!
    var country: String!
    
    private let scrollView = UIScrollView()
    private let backButton = UIButton()
    private let defaultCountryButton = UIButton()
    private let countryStatisticsStackView = StatisticsStackView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.black
        
        setupView()
        presenter.loadData(country: country)
    }
    
    // MARK: - Configurations
    
    private func setupView() {
        
        
        configureButton(button: backButton, text: "< Назад", action: #selector(backAction))
        configureButton(button: defaultCountryButton, text: "По умолчанию", action: #selector(defaultCountryAction))
        configureButtonsConstraint()
        
        configureScrollView()
        
        NSLayoutConstraint.activate([
            countryStatisticsStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            countryStatisticsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constraints.leadingOfView),
            countryStatisticsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constraints.trailingOfView),
            countryStatisticsStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func configureButton(button: UIButton, text: String, action: Selector) {
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.titleLabel?.textColor = Colors.white
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.addTarget(self, action: action, for: .touchUpInside)
    }
    
    private func configureButtonsConstraint() {
        var constraints = [backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constraints.leadingOfView), defaultCountryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constraints.trailingOfView)]
        
        if #available(iOS 11.0, *) {
            constraints.append(backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
            constraints.append(defaultCountryButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        } else {
            constraints.append(backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constraints.safeAreaTop))
            constraints.append(defaultCountryButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constraints.safeAreaTop))
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(countryStatisticsStackView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [
            scrollView.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constraints.leadingOfView),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constraints.trailingOfView)
        ]
        
        if #available(iOS 11.0, *) {
            constraints.append(scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constraints.BottomOfView))
        } else {
            constraints.append(scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constraints.BottomOfView))
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Action
    
    @objc private func backAction() {
        presenter.dismissView()
    }
    
    @objc private func defaultCountryAction() {
        presenter.changeDefaultCountry(country: country)
    }
    
}


// MARK: - CountryViewInput
extension CountryViewController: CountryViewInput {
    func success(statistics: Statistics) {
        countryStatisticsStackView.changeStatisticsView(statistics: statistics)
    }
    
    func failure() {
        presenter.presentFailureAlert(title: Errors.error, message: Errors.data)
    }
}