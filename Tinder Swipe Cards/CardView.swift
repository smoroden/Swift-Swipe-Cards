
//  Created by Zach Smoroden on 2015-10-12.
//  Copyright © 2015 Zach Smoroden. All rights reserved.
//

import UIKit

class CardView: UIView
{
    
    let ACTION_MARGIN:CGFloat = 120
    let SCALE_STRENGTH:CGFloat = 4
    let SCALE_MAX:CGFloat = 0.93
    let ROTATION_MAX:CGFloat = 1
    let ROTATION_STRENGTH:CGFloat = 320
    let ROTATION_ANGLE:CGFloat = CGFloat(M_PI/8)
    
    var xFromCentre:CGFloat?
    var yFromCentre:CGFloat?
    
    var originalPoint:CGPoint?
    
    var panGestureRecogniser: UIPanGestureRecognizer?
    var information: UILabel?
    var cardViewOverlay: CardViewOverlay?
    
    var delegate:CardViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
        
        information = UILabel(frame: CGRectMake(0, 50, self.frame.size.width, 200))
        information!.text = "Not Set"
        information!.textAlignment = NSTextAlignment.Center
        information!.textColor = UIColor.blackColor()
        information!.font = UIFont(name: "GreatVibes-Regular", size: 50.0)
        
        self.backgroundColor = UIColor.whiteColor()
        
        panGestureRecogniser = UIPanGestureRecognizer(target: self, action: "isDragged:")
        
        self.addGestureRecognizer(panGestureRecogniser!)
        self.addSubview(information!)
        
        cardViewOverlay = CardViewOverlay(frame: self.bounds)
        cardViewOverlay!.alpha = 0
        self.addSubview(cardViewOverlay!)
        
        
    }

    
    private func setupView() {
        self.layer.cornerRadius = 4
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSizeMake(1, 1)
    }

    
    func isDragged(gestureRecogniser: UIPanGestureRecognizer) {
        xFromCentre = gestureRecogniser.translationInView(self).x
        yFromCentre = gestureRecogniser.translationInView(self).y
        
        switch gestureRecogniser.state {
        case UIGestureRecognizerState.Began:
            self.originalPoint = self.center
        case UIGestureRecognizerState.Changed:
            let rotationStrength:CGFloat = min(xFromCentre!/CGFloat(ROTATION_STRENGTH), CGFloat(ROTATION_MAX))
            let rotationAngle:CGFloat = CGFloat(CGFloat(ROTATION_ANGLE) * rotationStrength)
            let scale:CGFloat = max(CGFloat(1-fabsf(Float(rotationStrength))) / CGFloat(SCALE_STRENGTH), CGFloat(SCALE_MAX))
            self.center = CGPointMake(self.originalPoint!.x + xFromCentre!, self.originalPoint!.y + yFromCentre!)
            let transform: CGAffineTransform = CGAffineTransformMakeRotation(rotationAngle)
            let scaleTransform: CGAffineTransform = CGAffineTransformScale(transform, scale, scale)
            
            self.transform = scaleTransform
            self.updateOverlay(xFromCentre!)
        case UIGestureRecognizerState.Ended:
            self.afterSwipeAction()
        default: ()
            
        }
        
    }

    private func updateOverlay(distance: CGFloat) {
        if (distance > 0)
        {
            cardViewOverlay!.setMode(CardViewOverlayMode.Right)
        } else if (distance <= 0)
        {
            cardViewOverlay!.setMode(CardViewOverlayMode.Left)
        }
        let overlayStrength:CGFloat = min(CGFloat(fabsf(Float(distance))) / 100, 0.5)
        cardViewOverlay!.alpha = overlayStrength
    }
    
    private func afterSwipeAction() {
        if (xFromCentre > ACTION_MARGIN) {
            self.rightAction()
        } else if (xFromCentre < -ACTION_MARGIN) {
            self.leftAction()
        } else {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.center = self.originalPoint!
                self.transform = CGAffineTransformMakeRotation(0)
                self.cardViewOverlay?.alpha = 0
            })
        }
    }
    
    private func rightAction() {
        let finishPoint:CGPoint = CGPointMake(500, 2*yFromCentre! + self.originalPoint!.y)
        UIView.animateWithDuration(0.3, animations: { () -> Void in self.center = finishPoint }, completion: { _ in self.removeFromSuperview()
            
        })
        delegate!.cardSwipedRight(self)
        
        print("Swiped Right!")
    }
    
    private func leftAction() {
        let finishPoint:CGPoint = CGPointMake(-500, 2*yFromCentre! + self.originalPoint!.y)
        UIView.animateWithDuration(0.3, animations: { _ in self.center = finishPoint }, completion: { _ in self.removeFromSuperview() })
        delegate!.cardSwipedLeft(self)

        print("Swiped Left!")
    }
    
    private func upAction() {
        let finishPoint:CGPoint = CGPointMake(2*xFromCentre! + self.originalPoint!.x, -200 )
        UIView.animateWithDuration(0.3, animations: { _ in
            self.center = finishPoint
            self.transform = CGAffineTransformMakeScale(0.3, 0.3)
            }, completion: { _ in
                self.removeFromSuperview()
        })
        delegate!.cardSwipedUp(self)
        
        print("Swiped Up!")
    }
    
    private func downAction() {
        let finishPoint:CGPoint = CGPointMake(2*xFromCentre! + self.originalPoint!.x, 900 )
        UIView.animateWithDuration(0.3, animations: { _ in
            self.center = finishPoint
            self.transform = CGAffineTransformMakeScale(0.3, 0.3)
            }, completion: { _ in
                self.removeFromSuperview()
        })
        delegate!.cardSwipedDown(self)
        
        print("Swiped Down!")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func yesClickAction(){
        let finishPoint = CGPointMake(600, self.center.y)
        UIView.animateWithDuration(0.3, animations: { _ in
            self.center = finishPoint
            self.transform = CGAffineTransformMakeRotation(1)
            }, completion: { _ in
                self.removeFromSuperview()
        })
    }
    
    func noClickAction(){
        let finishPoint = CGPointMake(-600, self.center.y)
        UIView.animateWithDuration(0.3, animations: { _ in
            self.center = finishPoint
            self.transform = CGAffineTransformMakeRotation(-1)
            }, completion: { _ in
                self.removeFromSuperview()
        })

    }

}

protocol CardViewDelegate {
    func cardSwipedLeft(card: UIView)
    func cardSwipedRight(card: UIView)
    func cardSwipedUp(card: UIView)
    func cardSwipedDown(card: UIView)
}