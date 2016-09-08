//
//  DropdownMenuSegue.swift
//  Pods
//
//  Created by Caleb Kleveter on 8/26/16.
//
//

import Foundation
import UIKit

class DropdownMenuSegue: UIStoryboardSegue {
    
    override func perform() {
        var containerViewController = (self.sourceViewController as! DropdownMenuController)
        var nextViewController = (self.destinationViewController as! UIViewController)
        
        guard let currentController = containerViewController.currentViewController else {
            return
        }
        
        var currentViewController: UIViewController = (currentController as! UIViewController)
        // Add nextViewController as child of container view controller.
        containerViewController.addChildViewController(nextViewController)
        // Tell current View controller that it will be removed.
        currentViewController.willMove(toParentViewController: nil)
        // Set the frame of the next view controller to equal the outgoing (current) view controller
        nextViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        nextViewController.view.frame = currentViewController.view.frame
        nextViewController.view.translatesAutoresizingMaskIntoConstraints = true
        // Make the transition with a very short Cross disolve animation
        containerViewController.transition(from: currentViewController, to: nextViewController, duration: 0.1, options: .transitionCrossDissolve, animations: {() -> Void in
            }, completion: {(finished: Bool) -> Void in
                //                containerViewController.currentViewController = nextViewController
                currentViewController.removeFromParentViewController()
                nextViewController.didMove(toParentViewController: containerViewController)
        })
    }
}
