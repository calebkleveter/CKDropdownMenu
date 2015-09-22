//
//  DropdownMenuSegue.swift
//  SwiftDropdownMenu
//
//  Created by Caleb Kleveter on 9/22/15.
//
//

import Foundation
import UIKit

class DropdownMenuSegue {
    
    func perform() {
        var containerViewController: DropdownMenuController = self.sourceViewController
        var nextViewController: UIViewController = self.destinationViewController
        var currentViewController: UIViewController = containerViewController.currentViewController
        
        // Add nextViewController as child of container view controller.
        containerViewController.addChildViewController(nextViewController)
        // Tell current View controller that it will be removed.
        currentViewController.willMoveToParentViewController(nil)
        
        // Set the frame of the next view controller to equal the outgoing (current) view controller
        nextViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
        nextViewController.view.frame = currentViewController.view.frame
        nextViewController.view.translatesAutoresizingMaskIntoConstraints = true
        
        containerViewController.transitionFromViewController(currentViewController,
                                            toViewController: nextViewController,
                                                    duration: 0.1,
                                                     options: UIViewAnimationOptionTransitionCrossDissolve,
                                                  animations: {
                                                    
                                                  },
                                                  completion: {(finished: Bool) in
                                                    containerViewController.currentViewController = nextViewController
                                                    currentViewController.removeFromParentViewController()
                                                    nextViewController.didMoveToParentViewController(containerViewController)
                                                  })
    }
}
