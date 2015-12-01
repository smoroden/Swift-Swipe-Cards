//
//  ViewController.swift
//  Tinder Swipe Cards
//
//  Created by Zach Smoroden on 2015-11-29.
//  Copyright © 2015 Zach Smoroden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var cardViewFactory : CardViewFactory?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        cardViewFactory = CardViewFactory(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        if let cardViewFactory = cardViewFactory {
            self.view.addSubview(cardViewFactory)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var hasFactory:Bool = false
        for x in self.view.subviews {
            if x.isKindOfClass(CardViewFactory){
                hasFactory = true
            }
        }
        
        // If we navigate to another page we want to make sure that only one factory has been made.
        // If for whatever reason the factory no longer exists we make a new one, otherwise we refresh the data.
        if !hasFactory{
            cardViewFactory = CardViewFactory(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
            if let cardViewFactory = cardViewFactory {
                self.view.addSubview(cardViewFactory)
            }
        } else {
//            if let cardViewFactory = cardViewFactory {
//                // Could call something like this if implemented.
//                cardViewFactory.refreshData()
//            }
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

