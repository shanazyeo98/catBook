//
//  DetailViewController.swift
//  BookFace
//
//  Created by Shanaz Yeo on 17/10/25.
//

import UIKit

class DetailViewController: UIViewController {
    
    let user: User
    let imageView: UIImageView = UIImageView()
    let nameLabel: UILabel = UILabel()
    let addressLabel: UILabel = UILabel()
    let birthdayLabel: UILabel = UILabel()
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHeaderUI()
        setupHeaderConstraints()
        // Do any additional setup after loading the view.
    }
    
    func setupHeaderUI() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        if let data = user.picture, let image = UIImage(data: data) {
            imageView.image = image
        } else {
            imageView.image = UIImage(systemName: "person.crop.circle")
        }
        view.addSubview(imageView)
        nameLabel.text = user.fullName
        nameLabel.font = .systemFont(ofSize: 28, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        addressLabel.text = "📍 \(user.city), \(user.state)"
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.font = .systemFont(ofSize: 16)
        addressLabel.textColor = .systemGray
        view.addSubview(addressLabel)
        birthdayLabel.text = "\(user.birthDate)"
        birthdayLabel.translatesAutoresizingMaskIntoConstraints = false
        birthdayLabel.font = .systemFont(ofSize: 16)
        birthdayLabel.textColor = .systemGray
        view.addSubview(birthdayLabel)
    }
    
    func setupHeaderConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 125),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1.0),
            nameLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 25),
            addressLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            birthdayLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 25),
            birthdayLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            birthdayLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
    }
}
