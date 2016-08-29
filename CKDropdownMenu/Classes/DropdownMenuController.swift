//
//  DropdownMenuController.swift
//  Pods
//
//  Created by Caleb Kleveter on 8/26/16.
//
//

import Foundation
import UIKit

/**
 A UIViewController that works as a dropdown menu
*/
public class DropdownMenuController: UIViewController {
    
    /// The dropdown's container. This is the view that the dropdown is for.
    @IBOutlet public weak var container: UIView!
    
    /// The menu bar for the dropdown. This is probably where you have the button to activate the menu.
    @IBOutlet public weak var menubar: UIView!
    
    /// The view that will act as the menu.
    @IBOutlet public weak var menu: UIView!
    
    /// The button that is used to activate the menu.
    @IBOutlet public weak var menuButton: UIButton!
    
    /// The label that shows the name of the current view controller.
    @IBOutlet public weak var titleLabel: UILabel!
    
    /// The buttons that are in the menu.
    @IBOutlet public var buttons: [UIButton]!
    
    // The current view controller being shown.
    public private(set) weak var currentViewController: UIViewController?
    
    /// The identifire of the current segue being used.
    public private(set) var currentSegueIdentifier = ""
    
    public private(set) var shouldDisplayDropShape: Bool = true
    public private(set) var fadeAlpha: Float = 0.0
    public private(set) var trianglePlacement: Float = 0.0
    
    public private(set) var openMenuShape: CAShapeLayer = CAShapeLayer()
    public private(set) var closedMenuShape: CAShapeLayer = CAShapeLayer()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        shouldDisplayDropShape = true
        fadeAlpha = 0.5
        trianglePlacement = 0.87
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Set the current view controller to the one embedded (in the storyboard).
        self.currentViewController = self.childViewControllers.first
        // Draw the shapes for the open and close menu triangle.
        self.drawOpenLayer()
        self.drawClosedLayer()
    }
    
    /**
     Enables/Disables the 'drop' triangle from displaying when down.
     
     - parameter shouldShow: Sets whether or not the dropdown triangle should show when the menu is activated.
    */
    public func dropShapeShouldShowWhenOpen(shouldShow: Bool) {
        shouldDisplayDropShape = shouldShow
    }
    
    /** 
     Sets the color that background content will fade to when the menu is opened.
     
     - parameter color: The color of the tint when the menu is activated.
    */
    public func setFadeTint(withColor color: UIColor) {
        self.view.backgroundColor = color
    }
    
    /**
     Sets the amount of fade that should be applied to background content when menu is open.
    
     - parameter alphaVal: How much the background will fade when the mnu is activated.activated
    */
    public func setFadeAmount(withAlpha alphaVal: Float) {
        fadeAlpha = alphaVal
    }
    
    /**
     Sets the placement of the dropdown triangle along the menu bar when the menu is activated.
     
     - parameter trianglePlacementVal: The position along the menu bar where the triangle is placed.
    */
    public func setTrianglePosition(_ trianglePlacementVal: Float) {
        trianglePlacement = trianglePlacementVal
    }
    
    /**
     Sets the title on the menu bar.
     
     - parameter menubarTitle: The title that is used for the menu bar.
    */
    public func setMenubarTitle(_ menubarTitle: String) {
        self.titleLabel.text = menubarTitle
    }
    
    /**
     Sets the background color of the menu bar.
     
     - parameter color: The color of the menu bar.
    */
    public func setMenubarBackground(_ color: UIColor) {
        self.menubar.backgroundColor = color
    }
    
    /**
     The action for the button that opens and closes the menu.
     
     - parameter sender: The button that fired th action.
    */
    @IBAction public func menuButtonAction(_ sender: UIButton) {
        self.toggleMenu()
    }
    
    /**
     An action for the buttons in the menu to close the menu when a button is pressed.
     
     - parameter sender: The button that was pressed.
    */
    @IBAction public func listButtonAction(_ sender: UIButton) {
        self.hideMenu()
    }
    
    /// Toggles the menu open and closed.
    public func toggleMenu() {
        if self.menu.isHidden {
            self.showMenu()
        }
        else {
            self.hideMenu()
        }
    }
    
    /// Shows/opens the dropdown menu.
    public func showMenu() {
        self.menu.isHidden = false
        self.menu.translatesAutoresizingMaskIntoConstraints = true
        closedMenuShape.removeFromSuperlayer()
        if shouldDisplayDropShape {
            self.view!.layer.addSublayer(openMenuShape)
        }
        // Set new origin of menu
        var menuFrame: CGRect = self.menu.frame
        menuFrame.origin.y = self.menubar.frame.size.height - self.offset()
        // Set new alpha of Container View (to get fade effect)
        let containerAlpha: Float = fadeAlpha
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 4.0, options: [.curveEaseIn, .curveEaseOut], animations: {() -> Void in
            self.menu.frame = menuFrame
            self.container.alpha = CGFloat(containerAlpha)
            }, completion: {(finished: Bool) -> Void in
        })

        UIView.commitAnimations()
    }
    
    /// Closes/hides the dropdown menu
    public func hideMenu() {
        // Set the border layer to hidden menu state
        openMenuShape.removeFromSuperlayer()
        self.view!.layer.addSublayer(closedMenuShape)
        // Set new origin of menu
        var menuFrame: CGRect = self.menu.frame
        menuFrame.origin.y = self.menubar.frame.size.height - menuFrame.size.height
        // Set new alpha of Container View (to get fade effect)
        let containerAlpha: Float = 1.0
        
        UIView.animate(withDuration: 0.3, delay: 0.05, usingSpringWithDamping: 1.0, initialSpringVelocity: 4.0, options: [.curveEaseIn, .curveEaseOut], animations: {() -> Void in
            self.menu.frame = menuFrame
            self.container.alpha = CGFloat(containerAlpha)
            }, completion: {(finished: Bool) -> Void in
                self.menu.isHidden = true
        })

        UIView.commitAnimations()
    }
    
    /// Hides the menu after it has animated out of frame.
    public func iOS6_hideMenuCompleted() {
        self.menu.isHidden = true
    }
    
    
    public func offset() -> CGFloat {
        
        if self.isLandscape() {
            return CGFloat(20.0)
        } else {
            return CGFloat(0.0)
        }
    }
    
    public func isLandscape() -> Bool {
        var interfaceOrientation: UIInterfaceOrientation
        // Check if we are running an iOS version that support `interfaceOrientation`
        // Otherwise, use statusBarOrientation.

        interfaceOrientation = UIApplication.shared().statusBarOrientation
        
        if interfaceOrientation == .landscapeLeft || interfaceOrientation == .landscapeRight {
            return true
        } else {
            return false
        }
    }
    
    public func correctWidth() -> CGFloat {
        let screenRect = UIScreen.main().bounds
        let maxSize: CGFloat = max(screenRect.size.width, screenRect.size.height)
        let minSize: CGFloat = min(screenRect.size.width, screenRect.size.height)
        return self.isLandscape() ? maxSize : minSize
    }
    
    public func drawOpenLayer() {
        openMenuShape.removeFromSuperlayer()
        openMenuShape = CAShapeLayer()
        // Constants to ease drawing the border and the stroke.
        let height: Int = Int(self.menubar.frame.size.height)
        let width: Int = Int(self.menubar.frame.size.width)
        let triangleDirection: Int = 1
        // 1 for down, -1 for up.
        let triangleSize: Int = 8
        let trianglePosition: Int = Int(trianglePlacement) * width
        // The path for the triangle (showing that the menu is open).
        let triangleShape: UIBezierPath = UIBezierPath()
        triangleShape.move(to: CGPoint(x: CGFloat(trianglePosition), y: CGFloat(height)))
        triangleShape.addLine(to: CGPoint(x: trianglePosition + triangleSize, y: height + triangleDirection * triangleSize))
        triangleShape.addLine(to: CGPoint(x: trianglePosition + 2 * triangleSize, y: height))
        triangleShape.addLine(to: CGPoint(x: CGFloat(trianglePosition), y: CGFloat(height)))
        openMenuShape.path = triangleShape.cgPath
        openMenuShape.fillColor = self.menubar.backgroundColor?.cgColor
        //[openMenuShape setFillColor:[self.menu.backgroundColor CGColor]];
        let borderPath: UIBezierPath = UIBezierPath()
        borderPath.move(to: CGPoint(x: 0, y: CGFloat(height)))
        borderPath.addLine(to: CGPoint(x: CGFloat(trianglePosition), y: CGFloat(height)))
        borderPath.addLine(to: CGPoint(x: trianglePosition + triangleSize, y: height + triangleDirection * triangleSize))
        borderPath.addLine(to: CGPoint(x: trianglePosition + 2 * triangleSize, y: height))
        borderPath.addLine(to: CGPoint(x: CGFloat(width), y: CGFloat(height)))
        openMenuShape.path = borderPath.cgPath
        openMenuShape.strokeColor = UIColor.white().cgColor
        openMenuShape.bounds = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(width), height: CGFloat(height + triangleSize))
        openMenuShape.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        openMenuShape.position = CGPoint(x: 0.0, y: -self.offset())
    }
    
    public func drawClosedLayer() {
        closedMenuShape.removeFromSuperlayer()
        closedMenuShape = CAShapeLayer()
        // Constants to ease drawing the border and the stroke.
        let height: Int = Int(self.menubar.frame.size.height)
        let width: Int = Int(self.menubar.frame.size.width)
        // The path for the border (just a straight line)
        let borderPath: UIBezierPath = UIBezierPath()
        borderPath.move(to: CGPoint(x: 0, y: CGFloat(height)))
        borderPath.addLine(to: CGPoint(x: CGFloat(width), y: CGFloat(height)))
        closedMenuShape.path = borderPath.cgPath
        closedMenuShape.strokeColor = UIColor.white().cgColor
        closedMenuShape.bounds = CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height))
        closedMenuShape.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        closedMenuShape.position = CGPoint(x: 0.0, y: -self.offset())
    }
    
    @IBAction public func displayGestureForTapRecognizer(recognizer: UITapGestureRecognizer) {
        // Get the location of the gesture
        let tapLocation: CGPoint = recognizer.location(in: self.view!)
        // NSLog(@"Tap location X:%1.0f, Y:%1.0f", tapLocation.x, tapLocation.y);
        // If menu is open, and the tap is outside of the menu, close it.
        if !self.menu.frame.contains(tapLocation) && !self.menu.isHidden {
            self.hideMenu()
        }
    }
    
    //    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
    //        super.didRotate(from: fromInterfaceOrientation)
    //        var menuFrame: CGRect = self.menu.frame
    //        menuFrame.origin.y = self.menubar.frame.size.height - self.offset()
    //        self.menu.frame = menuFrame
    //        self.drawClosedLayer()
    //        self.drawOpenLayer()
    //        if self.menu.isHidden {
    //            self.view!.layer.addSublayer(closedMenuShape)
    //        }
    //        else {
    //            if shouldDisplayDropShape {
    //                self.view!.layer.addSublayer(openMenuShape)
    //            }
    //        }
    //    }
    
    //    func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
    //        super.willRotate(to: toInterfaceOrientation, duration: duration)
    //        closedMenuShape.removeFromSuperlayer()
    //        openMenuShape.removeFromSuperlayer()
    //    }
    
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { (context) in
        }) { (context) in
            var menuFrame: CGRect = self.menu.frame
            menuFrame.origin.y = self.menubar.frame.size.height - self.offset()
            self.menu.frame = menuFrame
            self.drawClosedLayer()
            self.drawOpenLayer()
            if self.menu.isHidden {
                self.view!.layer.addSublayer(self.closedMenuShape)
            }
            else {
                if self.shouldDisplayDropShape {
                    self.view!.layer.addSublayer(self.openMenuShape)
                }
            }
        }
        
        super.viewWillTransition(to: size, with: coordinator)
        closedMenuShape.removeFromSuperlayer()
        openMenuShape.removeFromSuperlayer()
    }
    
    public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        if let identifier = segue.identifier {
            self.currentSegueIdentifier = identifier
            super.prepare(for: segue, sender: sender)
        }
    }
    
    public func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject) -> Bool {
        if self.currentSegueIdentifier.isEqual(identifier) {
            //Dont perform segue, if visible ViewController is already the destination ViewController
            return false
        }
        return true
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
