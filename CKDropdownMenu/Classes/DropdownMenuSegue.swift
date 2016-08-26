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
        let containerViewController: DropdownMenuController = (self.sourceViewController as! DropdownMenuController)
        let nextViewController: UIViewController = (self.destinationViewController )
        let currentViewController: UIViewController
        if let currentControler = containerViewController.currentViewController {
            currentViewController = currentControler
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
                containerViewController.currentViewController = nextViewController
                currentViewController.removeFromParentViewController()
                nextViewController.didMove(toParentViewController: containerViewController)
        })
    }
}
