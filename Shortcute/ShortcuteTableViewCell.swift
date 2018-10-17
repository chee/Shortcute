//
//  ShortcuteTableViewCell.swift
//  Shortcute
//
//  Created by chee on 09/10/2018.
//  Copyright © 2018 snoots & co. All rights reserved.
//

import UIKit

class ShortcuteTableViewCell: UITableViewCell {
	let view = UIView()
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var shortcuteLabel: UILabel!
	@IBOutlet weak var inputLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	override func layoutSubviews() {
		super.layoutSubviews()
		view.backgroundColor = UIColor.white
		self.backgroundView = view
		backgroundView?.frame = backgroundView?
			.frame
			.inset(
				by: UIEdgeInsets(
					top: 2,
					left: 0,
					bottom: 0,
					right: 0
				)
			) ?? CGRect.zero
	}
}
