//
//  UserCell.swift
//  FinalUnsplashApp
//
//  Created by Ramir Amrayev on 29.04.2022.
//

import UIKit
import SnapKit

typealias UserCellConfigurator = TableCellConfigurator<UserCell, UnsplashUser>

class UserCell: UITableViewCell, ConfigurableCell {
    
    static let path = "/search/users"
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    private lazy var nameStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, usernameLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 2
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(data: UnsplashUser) {
        nameLabel.text = data.name
        usernameLabel.text = data.username
        let userImageUrl = data.profile_image["large"]
        guard let imageUrl = userImageUrl, let url = URL(string: imageUrl) else { return }
        userImageView.sd_setImage(with: url, completed: nil)
    }
    
    private func layoutUI() {
        contentView.backgroundColor = .secondarySystemBackground
        
        contentView.addSubview(userImageView)
        contentView.addSubview(nameStack)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.snp.makeConstraints {
            $0.size.equalTo(80)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
        }
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        
        nameStack.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(15)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
