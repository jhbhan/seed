//
//  FeedTableCells.swift
//  seed.
//
//  Created by Jason Bhan on 8/12/20.
//  Copyright © 2020 ddevt. All rights reserved.
//

import Foundation
import UIKit

class FeedTableCells: UITableViewCell {
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var authorName: UILabel!
    @IBOutlet var postTitle: UILabel!
    @IBOutlet var numUpVotes: UILabel!
    
    var postid:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
