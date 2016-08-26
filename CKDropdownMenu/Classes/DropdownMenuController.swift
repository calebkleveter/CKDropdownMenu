//
//  DropdownMenuController.swift
//  Pods
//
//  Created by Caleb Kleveter on 8/26/16.
//
//

import Foundation
import UIKit

class DropdownMenuController: UIViewController {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var menubar: UIView!
    @IBOutlet weak var menu: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!
    weak var currentViewController: UIViewController?
    var currentSegueIdentifier = ""
    
    var shouldDisplayDropShape: Bool = true
    var fadeAlpha: Float = 0.0
    var trianglePlacement: Float = 0.0
    
    var openMenuShape: CAShapeLayer = CAShapeLayer()
    var closedMenuShape: CAShapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shouldDisplayDropShape = true
        fadeAlpha = 0.5
        trianglePlacement = 0.87
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Set the current view controller to the one embedded (in the storyboard).
        self.currentViewController = self.childViewControllers.first
        // Draw the shapes for the open and close menu triangle.
        self.drawOpenLayer()
        self.drawClosedLayer()
    }
    //Enables/Disables the 'drop' triangle from displaying when down
    
    func dropShapeShouldShowWhenOpen(shouldShow: Bool) {
        shouldDisplayDropShape = shouldShow
    }
    //Sets the color that background content will fade to when the menu is open
    
    func setFadeTintWithColor(color: UIColor) {
        self.view.backgroundColor = color
    }
    //Sets the amount of fade that should be applied to background content when menu is open
    
    func setFadeAmountWithAlpha(alphaVal: Float) {
        fadeAlpha = alphaVal
    }
    
    func setTrianglePlacement(trianglePlacementVal: Float) {
        trianglePlacement = trianglePlacementVal
    }
    
    func setMenubarTitle(menubarTitle: String) {
        self.titleLabel.text = menubarTitle
    }
    
    func setMenubarBackground(color: UIColor) {
        self.menubar.backgroundColor = color
    }
    
    @IBAction func menuButtonAction(sender: UIButton) {
        self.toggleMenu()
    }
    
    @IBAction func listButtonAction(sender: UIButton) {
        self.hideMenu()
    }
    
    func toggleMenu() {
        if self.menu.isHidden {
            self.showMenu()
        }
        else {
            self.hideMenu()
        }
    }
    
    func showMenu() {
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
        
        if #available(iOS 7.0, *) {
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 4.0, options: [.curveEaseIn, .curveEaseOut], animations: {() -> Void in
                self.menu.frame = menuFrame
                self.container.alpha = CGFloat(containerAlpha)
                }, completion: {(finished: Bool) -> Void in
            })
        } else {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationCurve(.easeInOut)
            self.menu.frame = menuFrame
            self.container.alpha = CGFloat(containerAlpha)
        }
        
        //        if SYSTEM_VERSION_LESS_THAN("7.0") {
        //            UIView.beginAnimations(nil, context: nil)
        //            UIView.animationCurve = .EaseInOut
        //            self.menu.frame = menuFrame
        //            self.container.alpha = containerAlpha
        //        }
        //        else {
        //            UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 4.0, options: .curveEaseInOut, animations: {() -> Void in
        //                self.menu.frame = menuFrame
        //                self.container.alpha = containerAlpha
        //                }, completion: {(finished: Bool) -> Void in
        //            })
        //        }
        UIView.commitAnimations()
    }
    
    func hideMenu() {
        // Set the border layer to hidden menu state
        openMenuShape.removeFromSuperlayer()
        self.view!.layer.addSublayer(closedMenuShape)
        // Set new origin of menu
        var menuFrame: CGRect = self.menu.frame
        menuFrame.origin.y = self.menubar.frame.size.height - menuFrame.size.height
        // Set new alpha of Container View (to get fade effect)
        let containerAlpha: Float = 1.0
        
        if #available(iOS 7.0, *) {
            UIView.animate(withDuration: 0.3, delay: 0.05, usingSpringWithDamping: 1.0, initialSpringVelocity: 4.0, options: [.curveEaseIn, .curveEaseOut], animations: {() -> Void in
                self.menu.frame = menuFrame
                self.container.alpha = CGFloat(containerAlpha)
                }, completion: {(finished: Bool) -> Void in
                    self.menu.isHidden = true
            })
        } else {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationCurve(.easeInOut)
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDidStop(#selector(DropdownMenuController.iOS6_hideMenuCompleted))
            self.menu.frame = menuFrame
            self.container.alpha = CGFloat(containerAlpha)
        }
        
        //        if SYSTEM_VERSION_LESS_THAN("7.0") {
        //            UIView.beginAnimations(nil, context: nil)
        //            UIView.animationCurve = .EaseInOut
        //            UIView.animationDelegate = self
        //            UIView.animationDidStopSelector = "iOS6_hideMenuCompleted"
        //            self.menu.frame = menuFrame
        //            self.container.alpha = containerAlpha
        //        }
        //        else {
        //            UIView.animate(withDuration: 0.3, delay: 0.05, usingSpringWithDamping: 1.0, initialSpringVelocity: 4.0, options: .curveEaseInOut, animations: {() -> Void in
        //                self.menu.frame = menuFrame
        //                self.container.alpha = CGFloat(containerAlpha)
        //                }, completion: {(finished: Bool) -> Void in
        //                    self.menu.isHidden = true
        //            })
        //        }
        UIView.commitAnimations()
    }
    
    func iOS6_hideMenuCompleted() {
        self.menu.isHidden = true
    }
    
    func offset() -> CGFloat {
        
        if #available(iOS 8.0, *) {
            if self.isLandscape() {
                return CGFloat(20.0)
            } else {
                return CGFloat(0.0)
            }
        } else {
            return CGFloat(0.0)
        }
    }
    
    func isLandscape() -> Bool {
        var interfaceOrientation: UIInterfaceOrientation
        // Check if we are running an iOS version that support `interfaceOrientation`
        // Otherwise, use statusBarOrientation.
        if #available(iOS 8.0, *) {
            interfaceOrientation = UIApplication.shared().statusBarOrientation
        }
        else {
            interfaceOrientation = self.interfaceOrientation
        }
        
        if interfaceOrientation == .landscapeLeft || interfaceOrientation == .landscapeRight {
            return true
        } else {
            return false
        }
    }
    
    func correctWidth() -> CGFloat {
        let screenRect = UIScreen.main().bounds
        let maxSize: CGFloat = max(screenRect.size.width, screenRect.size.height)
        let minSize: CGFloat = min(screenRect.size.width, screenRect.size.height)
        return self.isLandscape() ? maxSize : minSize
    }
    
    func drawOpenLayer() {
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
    
    func drawClosedLayer() {
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
    
    @IBAction func displayGestureForTapRecognizer(recognizer: UITapGestureRecognizer) {
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
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
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
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        if let identifier = segue.identifier {
            self.currentSegueIdentifier = identifier
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject) -> Bool {
        if self.currentSegueIdentifier.isEqual(identifier) {
            //Dont perform segue, if visible ViewController is already the destination ViewController
            return false
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
