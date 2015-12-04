//
//  FlickrCell.swift
//  Virtual Tourist
//
//  Created by Julia Will on 03.12.15.
//  Copyright © 2015 Julia Will. All rights reserved.
//

import UIKit

class FlickrCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        if imageView.image == nil {
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
        }
    }

}
