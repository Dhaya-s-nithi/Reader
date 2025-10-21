//
//  NewsTableViewCell.swift
//  Reader
//
//  Created by Dhayanithi on 19/10/25.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var newsHeadingLavel: UILabel!
    @IBOutlet weak var DescriptionText: UILabel!
    
    @IBOutlet weak var NewsDataMainView: UIView!
    @IBOutlet weak var newsImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        NewsDataMainView.frame.size.height = 170
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
