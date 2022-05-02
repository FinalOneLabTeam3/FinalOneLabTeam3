//
//  MenuViewCell.swift
//  FinalUnsplashApp
//
//  Created by Ramir Amrayev on 02.05.2022.
//

import UIKit

class TopicViewCell: UICollectionViewCell {
    
    static let reuseID = "TopicCell"
    
    private let topicTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(topicTitleLabel)
        addSubview(underlineView)
        
        topicTitleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        underlineView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(2)
            $0.bottom.equalToSuperview()
        }
        underlineView.layer.cornerRadius = underlineView.frame.height / 2
    }
    
    func configureCell(topic: Topic, isSelected: Bool = false) {
        topicTitleLabel.text = topic.title
        if isSelected {
            underlineView.isHidden = false
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        underlineView.isHidden = true
    }
    
}
