//
//  ViewController.swift
//  CustomKeyboard
//
//  Created by dong eun shin on 2022/07/12.
//

import UIKit

class CreateReviewViewController: UIViewController {
    
    let createReviewViewModel = CreateReviewViewModel()
    let homeViewModel = HomeViewModel(networkService: NetworkService())
    let keyboard = keyboardView()
    lazy var textfield: UITextField = {
        var textfield = UITextField()
        textfield.backgroundColor = .gray
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(tapDoneButton)
        )
        setConstraints()
        
        keyboard.button1.addTarget(self, action: #selector(tapKeyboard(_:)), for: .touchDown) //0x11B8
        keyboard.button8.addTarget(self, action: #selector(tapKeyboard(_:)), for: .touchDown) //0x1163
    }
    func setConstraints() {
        view.addSubview(textfield)
        view.addSubview(keyboard)
        keyboard.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textfield.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textfield.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textfield.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textfield.heightAnchor.constraint(equalToConstant: 200),
            
            keyboard.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            keyboard.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboard.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboard.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    @objc
    func tapDoneButton(){
        guard let condent = textfield.text else { return }
        createReviewViewModel.uploadReview(condent: condent) {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @objc
    func tapKeyboard(_ sender: UIButton){
        let char = sender.titleLabel?.text
        DispatchQueue.main.async {
            self.textfield.text = char
        }
    }
}
