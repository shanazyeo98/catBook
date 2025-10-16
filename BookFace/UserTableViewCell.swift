//
//  UserTableViewCell.swift
//  BookFace
//
//  Created by Shanaz Yeo on 16/10/25.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    let userImageView: UIImageView = UIImageView()
    let nameLabel: UILabel = UILabel()
    let addressLabel: UILabel = UILabel()
    let birthDateLabel: UILabel = UILabel()
    let detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let padding: CGFloat = 16
    
    static let cellIdentifier = "UserTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 20
        contentView.addSubview(userImageView)
        contentView.addSubview(detailsStackView)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 26, weight: .bold)
        detailsStackView.addArrangedSubview(nameLabel)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.font = .systemFont(ofSize: 18, weight: .regular)
        addressLabel.textColor = .systemGray
        detailsStackView.addArrangedSubview(addressLabel)
        birthDateLabel.translatesAutoresizingMaskIntoConstraints = false
        birthDateLabel.font = .systemFont(ofSize: 18)
        birthDateLabel.textColor = .systemGray
        detailsStackView.addArrangedSubview(birthDateLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            userImageView.widthAnchor.constraint(equalToConstant: 80),
            userImageView.heightAnchor.constraint(equalTo: userImageView.widthAnchor, multiplier: 1.0),
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            userImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            detailsStackView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: padding),
            detailsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            detailsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
    
    func configure(user: User) {
//        print(user.profileImage)
//        if let imageData = Data(base64Encoded: user.profileImage) {
//            if let image = UIImage(data: imageData) {
//                userImageView.image = image
//            }
//        }
        if let data = user.picture, let image = UIImage(data: data) {
            userImageView.image = image
        }
        nameLabel.text = user.fullName
        addressLabel.text = "📍\(user.city), \(user.state)"
        birthDateLabel.text = "Birthday: \(user.birthDate)"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
