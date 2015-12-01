
//  Created by Zach Smoroden on 2015-10-12.
//  Copyright © 2015 Zach Smoroden. All rights reserved.
//

import UIKit

enum CardViewOverlayMode: Int {
    case Left
    case Right
}

class CardViewOverlay: UIView {
    
    var mode: CardViewOverlayMode?
    private var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        imageView = UIImageView(image: UIImage(named: "x"))
        self.addSubview(imageView!)
    }
    
     func setMode(mode: CardViewOverlayMode) {
        if (self.mode == mode) {
            return
        }
        
        self.mode = mode
        
        if (mode == CardViewOverlayMode.Left) {
            imageView!.image = UIImage(named: "x")
        } else {
            imageView!.image = UIImage(named: "check")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView!.frame = CGRectMake(50, 50, 100, 100)
        imageView!.center = CGPointMake(self.bounds.height/2, self.bounds.width/2)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}