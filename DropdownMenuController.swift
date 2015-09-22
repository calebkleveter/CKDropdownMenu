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

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated:BOOL) {
        super.viewDidAppear(animated)
        
    }

    
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
