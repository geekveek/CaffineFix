//
//  CoffeeEntryTableViewCell.swift
//  CaffineFix
//
//  Created by Victor Chan on 31/1/15.
//  Copyright (c) 2015 Spark Plug Studio. All rights reserved.
//

import UIKit

class CoffeeEntryTableViewCell: UITableViewCell {

    @IBOutlet weak var shopImage:UIImageView!
    @IBOutlet weak var shopNameLabel:UILabel!
    @IBOutlet weak var shopAddressLabel:UILabel!
    @IBOutlet weak var shopPriceLabel:UILabel!
    @IBOutlet weak var distanceLabel:UILabel!
    @IBOutlet weak var openingStatusLabel: UILabel!
    
    let thumbnailRes:NSInteger = 100
    var venue: Venue?{
        didSet{
            //Set shop name
            if let venueItem = venue{
                shopNameLabel.text = venueItem.shopName
                shopAddressLabel.text=venueItem.address
                
                let distance = Int(round(Float(venueItem.distance)/50.0)*50)
                if distance>=1000{
                    distanceLabel.text = String(format: "%.02f km",round(Float(distance)/50.0)/20)
                }else{
                    distanceLabel.text = String(format:"%d m",distance)
                }
                
                if venueItem.priceRating>0{
                    shopPriceLabel.attributedText=NSAttributedString(string: "$$$$", attributes: [NSForegroundColorAttributeName:UIColor.grayColor(),NSFontAttributeName:UIFont.systemFontOfSize(shopPriceLabel.font.pointSize)])
                    let priceString = NSMutableAttributedString(attributedString: shopPriceLabel.attributedText)
                    priceString.setAttributes([NSForegroundColorAttributeName:UIColor.blackColor(),NSFontAttributeName:UIFont.boldSystemFontOfSize(shopPriceLabel.font.pointSize)], range: NSMakeRange(0, venueItem.priceRating))
                    shopPriceLabel.attributedText = priceString
                }
                
                openingStatusLabel.text = venueItem.openStatus
                
                if venueItem.isOpen{
                    openingStatusLabel.textColor = UIColor.greenColor()
                }else{
                    openingStatusLabel.textColor = UIColor.redColor()
                }
                
                if venueItem.hasPhoto{
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)){
                        //Getting image in background
                        //Construct URL to get the image
                        let photoRes = "\(self.thumbnailRes)x\(self.thumbnailRes)"
                        var urlString = "\(venueItem.photoPrefix)\(photoRes)\(venueItem.photoSuffix)"
                        
                        UIApplication.sharedApplication().networkActivityIndicatorVisible=true
                        let image: UIImage? = UIImage(data: NSData(contentsOfURL: NSURL(string: urlString)!)!)
                        UIApplication.sharedApplication().networkActivityIndicatorVisible=false
                        
                        dispatch_async(dispatch_get_main_queue()){
                            self.shopImage.image = image
                        }
                    }
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        shopNameLabel.text=""
        shopAddressLabel.text=""
        openingStatusLabel.text=""
        
        shopPriceLabel.attributedText=NSAttributedString(string: "", attributes: [NSForegroundColorAttributeName:UIColor.grayColor(),NSFontAttributeName:UIFont.systemFontOfSize(shopPriceLabel.font.pointSize)])
        
        self.shopImage.image = UIImage(named: "PlaceholderImage")
        shopImage.layer.masksToBounds=true
        
        //square photo
        //shopImage.layer.cornerRadius = 5.0
        
        //circular photo
        shopImage.layer.cornerRadius=shopImage.bounds.size.height/2
        shopImage.layer.borderWidth=0
    }

}
