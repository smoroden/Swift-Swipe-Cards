
//  Created by Zach Smoroden on 2015-10-12.
//  Copyright © 2015 Zach Smoroden. All rights reserved.
//

import UIKit
import GameKit

class CardViewFactory: UIView, CardViewDelegate {

    
    let MAX_BUFFER_SIZE:Int = 2
    
    let CARD_WIDTH:Int = 290
    let CARD_HEIGHT:Int = 290
    
    
    let YES_NO_BUTTON_SIZE:CGFloat = 60
    
  
    let exampleCardLabels: NSArray = ["first","second","third","fourth","last"]
    var cards : NSArray?
    
    let loadedCards: NSMutableArray = NSMutableArray()
    let allCards: NSMutableArray = NSMutableArray()
    
    var yesButton: UIButton?
    var noButton: UIButton?

    var emptyLabel: UILabel?
    
    var cardsLoadedIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.layoutSubviews()

        if loadedCards.count == 0 {
            self.setupView()
            self.loadCards()

        }

        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setupView() {
        self.layer.borderWidth = 1
        
        self.backgroundColor = UIColor.lightGrayColor()
        
        yesButton = UIButton(frame: CGRectMake(CGFloat(self.bounds.width) - (YES_NO_BUTTON_SIZE * 2), CGFloat(self.bounds.height) - YES_NO_BUTTON_SIZE - 10, YES_NO_BUTTON_SIZE, YES_NO_BUTTON_SIZE))
        yesButton?.setImage(UIImage(named: "check"), forState: UIControlState.Normal)
        yesButton?.addTarget(self, action: Selector("swipeRight"), forControlEvents: UIControlEvents.TouchUpInside)
        
        noButton = UIButton(frame: CGRectMake(YES_NO_BUTTON_SIZE, CGFloat(self.bounds.height) - YES_NO_BUTTON_SIZE - 10, YES_NO_BUTTON_SIZE, YES_NO_BUTTON_SIZE))
        noButton?.setImage(UIImage(named: "x"), forState: UIControlState.Normal)
        noButton?.addTarget(self, action: Selector("swipeLeft"), forControlEvents: UIControlEvents.TouchUpInside)

        emptyLabel = UILabel(frame: CGRectMake(0,0,0,0))
        emptyLabel?.text = "No more cards!"
        emptyLabel?.textAlignment = NSTextAlignment.Center
        emptyLabel?.numberOfLines = 2
        emptyLabel?.sizeToFit()
        emptyLabel?.center = CGPoint(x: CGFloat(self.bounds.width) / 2, y: CGFloat(self.bounds.height) / 2)

        self.addSubview(emptyLabel!)
        
        self.addSubview(noButton!)
        self.addSubview(yesButton!)

    }
    
    
    func swipeRight(){
        let cardView: CardView = loadedCards.firstObject as! CardView
        self.cardSwipedRight(cardView)
        cardView.cardViewOverlay?.setMode(CardViewOverlayMode.Right)
        UIView.animateWithDuration(0.2, animations: { _ in
            cardView.cardViewOverlay!.alpha = 1
        }, completion: { _ in
            cardView.yesClickAction()
            
        })
    }
    
    func swipeLeft(){
        let cardView: CardView = loadedCards.firstObject as! CardView
        self.cardSwipedLeft(cardView)
        cardView.cardViewOverlay?.setMode(CardViewOverlayMode.Left)
        UIView.animateWithDuration(0.2, animations: { _ in
            cardView.cardViewOverlay!.alpha = 1
            }, completion: { _ in
                cardView.noClickAction()
                
        })
    }

    private func createCardViewAtIndex(index: NSInteger) -> CardView {
        let cardView:CardView = CardView(frame: CGRectMake((CGFloat(self.frame.width) - CGFloat(CARD_WIDTH))/2, (self.frame.height - CGFloat(CARD_WIDTH))/2, CGFloat(CARD_WIDTH), CGFloat(CARD_HEIGHT)))
        cardView.information?.text = cards!.objectAtIndex(index) as? String
        cardView.delegate = self
        return cardView
    }
    
    
    func loadCards() {
        
		cards = exampleCardLabels
        if(cards!.count > 0) {
            var numLoadedCardsCap:NSInteger?
            if (cards!.count > MAX_BUFFER_SIZE) {
                numLoadedCardsCap = MAX_BUFFER_SIZE
            } else {
                numLoadedCardsCap = cards!.count
            }
            for var i = 0; i < cards!.count; i++ {
                let newCard: CardView = self.createCardViewAtIndex(i)
                
                allCards.addObject(newCard)
                
                if (i < numLoadedCardsCap) {
                    
                    loadedCards.addObject(newCard)
                }
            }
            
            for var i = 0; i < loadedCards.count; i++ {
                if (i > 0) {
                    self.insertSubview(loadedCards.objectAtIndex(i) as! CardView, belowSubview: loadedCards.objectAtIndex(i-1) as! CardView)
                } else {
                    self.addSubview(loadedCards.objectAtIndex(i) as! CardView)
                }
                cardsLoadedIndex++
            }
        }
    }
    
    func cardSwipedLeft(card: UIView) {
        loadedCards.removeObjectAtIndex(0)
        
        if (cardsLoadedIndex < allCards.count) {
            loadedCards.addObject(allCards.objectAtIndex(cardsLoadedIndex))
            cardsLoadedIndex++
            self.insertSubview(loadedCards.objectAtIndex(MAX_BUFFER_SIZE-1)  as! CardView, belowSubview: loadedCards.objectAtIndex(MAX_BUFFER_SIZE-2) as! CardView)
        }
        checkButtons()
    }
    
    func cardSwipedRight(card: UIView) {
        loadedCards.removeObjectAtIndex(0)
        
        if (cardsLoadedIndex < allCards.count) {
            loadedCards.addObject(allCards.objectAtIndex(cardsLoadedIndex))
            cardsLoadedIndex++
            self.insertSubview(loadedCards.objectAtIndex(MAX_BUFFER_SIZE-1)  as! UIView, belowSubview: loadedCards.objectAtIndex(MAX_BUFFER_SIZE-2) as! UIView)
        }
        checkButtons()
        
    }
    
    func cardSwipedUp(card: UIView) {
        loadedCards.removeObjectAtIndex(0)
        
        if (cardsLoadedIndex < allCards.count) {
            loadedCards.addObject(allCards.objectAtIndex(cardsLoadedIndex))
            cardsLoadedIndex++
            self.insertSubview(loadedCards.objectAtIndex(MAX_BUFFER_SIZE-1)  as!CardView, belowSubview: loadedCards.objectAtIndex(MAX_BUFFER_SIZE-2) as! CardView)
        }
        checkButtons()
    }
    
    func cardSwipedDown(card: UIView) {
        loadedCards.removeObjectAtIndex(0)
        
        if (cardsLoadedIndex < allCards.count) {
            loadedCards.addObject(allCards.objectAtIndex(cardsLoadedIndex))
            cardsLoadedIndex++
            self.insertSubview(loadedCards.objectAtIndex(MAX_BUFFER_SIZE-1)  as! CardView, belowSubview: loadedCards.objectAtIndex(MAX_BUFFER_SIZE-2) as! CardView)
        }
        checkButtons()
    }
    
    private func checkButtons(){
        if loadedCards.count == 0 {
            self.yesButton?.enabled = false
            self.noButton?.enabled = false
        }
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
