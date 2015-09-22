//
//  DropdownMenuController.swift
//  SwiftDropdownMenu
//
//  Created by Caleb Kleveter on 9/22/15.
//
//

import UIKit

class DropdownMenuController {

    var offset: CGFloat
    func iOS6_hideMenuCompleted()
    
}

class DropdownMenuController: UIViewController {

//  MARK: - Variables
    weak var currentViewController: UIViewController?
    var currentSegueIdentifier: String?
    
    var openMenuShape: CAShapeLayer
    var closedMenuShape: CAShapeLayer
    
    var shouldDisplayDropShape: Bool
    var fadeAlpha: Float
    var trianglePlacement: Float
    
//  MARK: - Outlets
    
    @IBOutlet weak var container: UIImageView!
    @IBOutlet weak var menubar: UIImageView!
    @IBOutlet weak var menu: UIImageView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!
    

//  MARK: - Default Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        shouldDisplayDropShape = true
        fadeAlpha = 0.5
        trianglePlacement = 0.87
    }

    override func viewDidAppear(animated:BOOL) {
        super.viewDidAppear(animated)
        
        // Set the current view controller to the one embedded (in the storyboard).
        self.currentViewController = self.childViewControllers.firstObject
        
        // Draw the shapes for the open and close menu triangle.
        self.drawOpenLayer
        self.drawClosedLayer
    }
    
//  MARK: - Custom Functions
    
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
    
//  MARK: - Menu Buttons
    
    @IBAction func menuButtonAction(sender: UIButton) {
        self.toggleMenu()
    }
    
    @IBAction func listButtonAction(sender: UIButton) {
        self.hideMenu()
    }
    
//  MARK: - Menu Functions
    
    func toggleMenu() {
        if self.menu.hidden {
            self.showMenu()
        }
        else {
            self.hideMenu()
        }
    }
    
    func showMenu() {
        self.menu.hidden = false
        self.menu.translatesAutoresizingMaskIntoConstraints = true
        
        closedMenuShape.removeFromSuperlayer()
        
        if shouldDisplayDropShape {
            self.view().layer().addSublayer(openMenuShape)
        }
        
        // Set new origin of menu
        var menuFrame: CGRect = self.menu.frame
        menuFrame.origin.y = self.menubar.frame.size.height - self.offset
        
        
        var containerAlpha: Float = fadeAlpha
        
        if SYSTEM_VERSION_LESS_THAN("7.0") {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationCurve(UIViewAnimationCurveEaseInOut)
            self.menu.frame = menuFrame
            self.container.setAlpha(containerAlpha)
        }
        else {
            UIView.animateWithDuration(0.4,
                                delay: 0.0,
               usingSpringWithDamping: 1.0,
                initialSpringVelocity: 4.0,
                              options: UIViewAnimationOptionCurveEaseInOut,
                           animations: {
                                self.menu.frame = menuFrame
                                self.container.setAlpha(containerAlpha)
                
                }, completion: {(finished: Bool) in
             })
           }
        
        UIView.commitAnimations()
        
    }
    
    func hideMenu() {
        // Set the border layer to hidden menu state
        openMenuShape.removeFromSuperlayer()
        self.view().layer().addSublayer(closedMenuShape)
        
        // Set new origin of menu
        var menuFrame: CGRect = self.menu.frame
        menuFrame.origin.y = self.menubar.frame.size.height - menuFrame.size.height
        
        // Set new alpha of Container View (to get fade effect)
        var containerAlpha: Float = 1.0
        
        if SYSTEM_VERSION_LESS_THAN("7.0") {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationCurve(UIViewAnimationCurveEaseInOut)
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDidStopSelector("iOS6_hideMenuCompleted")
            self.menu.frame = menuFrame
            self.container.setAlpha(containerAlpha)
        }
        else {
            UIView.animateWithDuration(0.3,
                                delay: 0.05,
               usingSpringWithDamping: 1.0,
                initialSpringVelocity: 4.0,
                              options: UIViewAnimationOptionCurveEaseInOut,
                           animations: {
                                self.menu.frame = menuFrame
                                self.container.setAlpha(containerAlpha)
                
                }, completion: {(finished: Bool) in
                    self.menu.hidden = true
            })
        }
        
        UIView.commitAnimations()
    }
    
    func iOS6_hideMenuCompleted() {
        self.menu.hidden = true
    }
    
    func offset() -> CGFloat {
        var orientation: UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        return UIInterfaceOrientationIsLandscape(orientation) ? 20.0 : 0.0
    }
    
    func drawOpenLayer() {
        var removeFromSuperlayer: openMenuShape
        openMenuShape = CAShapeLayer.layer()
        
        // Constants to ease drawing the border and the stroke.
        var height: Int = self.menubar.frame.size.height
        var width: Int = self.menubar.frame.size.width
        var triangleDirection: Int = 1 // 1 for down, -1 for up.
        var triangleSize: Int = 8
        var trianglePosition: Int = trianglePlacement * width
        
        // The path for the triangle (showing that the menu is open).
        var triangleShape: UIBezierPath = UIBezierPath()
        triangleShape.moveToPoint(CGPointMake(trianglePosition, height))
        triangleShape.addLineToPoint(CGPointMake(trianglePosition + triangleSize, height + triangleDirection * triangleSize))
        triangleShape.addLineToPoint(CGPointMake(trianglePosition + 2 * triangleSize, height))
        triangleShape.addLineToPoint(CGPointMake(trianglePosition, height))
        
        openMenuShape.setPath(triangleShape.CGPath)
        openMenuShape.setFillColor(self.menubar.backgroundColor.CGColor())
        //openMenuShape.setFillColor(self.menubar.backgroundColor.CGColor())
        var borderPath: UIBezierPath = UIBezierPath()
        borderPath.moveToPoint(CGPointMake(0, height))
        borderPath.addLineToPoint(CGPointMake(trianglePosition, height))
        borderPath.addLineToPoint(CGPointMake(trianglePosition + triangleSize, height + triangleDirection * triangleSize))
        borderPath.addLineToPoint(CGPointMake(trianglePosition + 2 * triangleSize, height))
        borderPath.addLineToPoint(CGPointMake(width, height))
        
        openMenuShape.setPath(borderPath.CGPath)
        openMenuShape.setStrokeColor(UIColor.whiteColor().CGColor())
        
        openMenuShape.setBounds(CGRectMake(0.0, 0.0, height + triangleSize, width))
        openMenuShape.setAnchorPoint(CGPointMake(0.0, 0.0))
        openMenuShape.setPosition(CGPointMake(0.0, -self.offset))

    }
    
    func drawClosedLayer() {
        closedMenuShape.removeFromSuperlayer()
        closedMenuShape = CAShapeLayer.layer()
        
        // Constants to ease drawing the border and the stroke.
        var height: Int = self.menubar.frame.size.height
        var width: Int = self.menubar.frame.size.width
        
        // The path for the border (just a straight line)
        var borderPath: UIBezierPath = UIBezierPath()
        borderPath.moveToPoint(CGPointMake(0, height))
        borderPath.addLineToPoint(CGPointMake(width, height))
        
        closedMenuShape.setPath(borderPath.CGPath)
        closedMenuShape.setStrokeColor(UIColor.whiteColor().CGColor())
        
        closedMenuShape.setBounds(CGRectMake(0.0, 0.0, height, width))
        closedMenuShape.setAnchorPoint(CGPointMake(0.0, 0.0))
        closedMenuShape.setPosition(CGPointMake(0.0, -self.offset))
    }
    
    @IBAction func displayGestureForTapRecognizer(recognizer: UITapGestureRecognizer) {
        // Get the location of the gesture
        var tapLocation: CGPoint = recognizer.locationInView(self.view)
        // NSLog(@"Tap location X:%1.0f, Y:%1.0f", tapLocation.x, tapLocation.y);
        
        // If menu is open, and the tap is outside of the menu, close it.
        if !CGRectContainsPoint(self.menu.frame, tapLocation) && !self.menu.hidden {
            self.hideMenu()
        }
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------------------------------------------*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
