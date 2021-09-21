//
//  ReminderTableViewCell.swift
//  MyReminders
//
//  Created by Andres Liu on 8/5/21.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    static let identifier = "ReminderTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ReminderTableViewCell", bundle: nil)
    }
    
    func config(with model: MyReminder) {
        self.titleLabel.text = model.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM, d, YYYY"
        self.dateLabel.text = dateFormatter.string(from: model.date)
    }
}
