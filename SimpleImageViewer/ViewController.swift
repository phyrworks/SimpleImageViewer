//
//  ViewController.swift
//  SimpleImageViewer
//
//  Created by Phoenix on 3/24/16.
//  Copyright © 2016 Phoenix Toews. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    /**
    Use to adjust the height of the Document View.  Use this instead of other methods when you want to resize the view.
    */
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    /**
     Use to adjust the width of the Document View.  Use this instead of other methods when you want to resize the view.
     */
    @IBOutlet weak var viewWidthConstraint: NSLayoutConstraint!
    
    /**
     A link to the NSImageView from the Storyboard.  Needed for getting the image size to calculate the zoomFactor and zoomToFit.
     */
    @IBOutlet weak var imageView: NSImageView!
    
    /**
    A link to the CenteringClipView of the NSScrollView from the Storyboard.  Needed for getting the centeringClipView size in the zoomToFit calculations.
    */
    @IBOutlet weak var clipView: CenteringClipView!
    
    /**
    A smaller zoomFactor shrinks the image, and a larger zoomFactor expands the image.  A zoomFactor of 1.0 is the actual size of the image.
    */
    var zoomFactor:CGFloat = 1.0 {
        /**
        Updates the Document View size whenever the zoomFactor is changed.
        */
        didSet {
            guard imageView.image != nil else {
                return
            }
            
            viewHeightConstraint.constant = imageView.image!.size.height * zoomFactor
            viewWidthConstraint.constant = imageView.image!.size.width * zoomFactor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DispatchQueue.main.async { [weak self]() -> Void in
            self?.zoomToFit(nil)
        }
    }
    
    /**
    Zooms in on the image.  In other words, expands or scales the image up.
    - parameters:
        - sender: The object that sent the event. The parameter is set to be optional so that it can be called with nil.
    */
    @IBAction func zoomIn(_ sender: NSMenuItem?) {
        if zoomFactor + 0.1 > 4 {
            zoomFactor = 4
        } else if zoomFactor == 0.05 {
            zoomFactor = 0.1
        } else {
            zoomFactor += 0.1
        }
        
    }
    
    /**
     Zooms out on the image.  In other words, shrinks or scales the image down.
     - parameters:
        - sender: The object that sent the event. The parameter is set to be optional so that it can be called with nil.
     */
    @IBAction func zoomOut(_ sender: NSMenuItem?) {
        if zoomFactor - 0.1 < 0.05 {
            zoomFactor = 0.05
        } else {
            zoomFactor -= 0.1
        }
    }

    /**
     Sets the image to it's default size.
     - parameters:
        - sender: The object that sent the event. The parameter is set to be optional so that it can be called with nil.
     */
    @IBAction func zoomToActual(_ sender: NSMenuItem?) {
        zoomFactor = 1.0
    }
    
    /**
     Fits the image entirely in the Scroll View content area (it's Clip View), using proportional scaling up or down.
     - parameters:
        - sender: The object that sent the event. The parameter is set to be optional so that it can be called with nil.
     */
    @IBAction func zoomToFit(_ sender: NSMenuItem?) {
        
        guard imageView!.image != nil else {
            return
        }
        
        let imSize = imageView!.image!.size
        var clipSize = clipView.bounds.size

        
        //We want a 20 pixel gutter.  To make the calculations easier, adjust the clipbounds down to account for the gutter.  Use 2 * the pixel gutter, since we are adjusting only the height and width (this accounts for the left and right margin combined, and the top and bottom margin combined).
        let imageMargin:CGFloat = 40
        
        clipSize.width -= imageMargin
        clipSize.height -= imageMargin

        guard imSize.width > 0 && imSize.height > 0 && clipSize.width > 0 && clipSize.height > 0 else {
            return
        }
        
        let clipAspectRatio = clipSize.width / clipSize.height
        let imAspectRatio = imSize.width / imSize.height
        
        if clipAspectRatio > imAspectRatio {
            zoomFactor = clipSize.height / imSize.height
        } else {
            zoomFactor = clipSize.width / imSize.width
        }
    }

}

