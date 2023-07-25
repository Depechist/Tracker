//
//  EmojiCell.swift
//  Tracker
//
//  Created by Artem Adiev on 23.07.2023.
//

import UIKit

final class EmojiCell: UICollectionViewCell {
    var emojiLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        emojiLabel = UILabel(frame: contentView.bounds)
        emojiLabel.textAlignment = .center
        emojiLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        contentView.addSubview(emojiLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
