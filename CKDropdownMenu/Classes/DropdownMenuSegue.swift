//
//  DropdownMenuSegue.swift
//  Pods
//
//  Created by Caleb Kleveter on 8/26/16.
//
//

import Foundation
import UIKit

public class DropdownMenuSegue: UIStoryboardSegue {
    
    public var containerViewController: DropdownMenuController
    public var nextViewController: UIViewController
    public var currentViewController: UIViewController
    
    init(containerViewController: DropdownMenuController, currentViewController: UIViewController, nextViewController: UIViewController) {
        self.containerViewController = containerViewController
        self.nextViewController = nextViewController
        self.currentViewController = currentViewController
        super.init(identifier: nil, source: currentViewController, destination: nextViewController)
        self.containerViewController = (self.sourceViewController as! DropdownMenuController)
        self.nextViewController = (self.destinationViewController)
    }
    
    public override func perform() {
        
        var currentController: UIViewController
        
        if let controller = containerViewController.currentViewController {
            currentController = controller
        } else {
            return
        }

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
                currentController = self.nextViewController
                self.currentViewController.removeFromParentViewController()
                self.nextViewController.didMove(toParentViewController: self.containerViewController)
        })
    }
}
