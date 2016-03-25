//
//  ViewController.swift
//  SimpleImageViewer
//
//  Created by Phoenix on 3/24/16.
//  Copyright © 2016 Phoenix Toews. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageView: NSImageView!
    
    @IBOutlet weak var clipView: CenteringClipView!
    
    var zoomFactor:CGFloat = 1.0 {
        didSet {
            guard imageView.image != nil else {
                return
            }
            
            viewHeightConstraint.constant = (imageView.image?.size.height)! * zoomFactor
            viewWidthConstraint.constant = (imageView.image?.size.width)! * zoomFactor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        zoomFactor = 2.0
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func zoomToActual(sender: NSMenuItem?) {
        zoomFactor = 1.0
    }
    
    @IBAction func zoomIn(sender: NSMenuItem?) {

        if zoomFactor + 0.25 > 4 {
            zoomFactor = 4
        } else if zoomFactor == 0.05 {
            zoomFactor = 0.25
        } else {
            zoomFactor += 0.25
        }
        
    }
    
    @IBAction func zoomOut(sender: NSMenuItem?) {
        if zoomFactor - 0.25 < 0.05 {
            zoomFactor = 0.05
        } else {
            zoomFactor -= 0.25
        } 
    }
    
    @IBAction func zoomToFit(sender: NSMenuItem?) {
        
        guard imageView!.image != nil else {
            return
        }
        
        let imSize = imageView!.image!.size
        
        guard imSize.width > 0 && imSize.height > 0 else {
            return
        }
        
        //we want a 20 pixel gutter.  To make the calculations easier, adjust the clipbounds down to account for the gutter
        let imageMargin:CGFloat = 20
        var clipSize = clipView.bounds.size
        
        clipSize.width -= imageMargin * 2
        clipSize.height -= imageMargin * 2
        
        let clipAspectRatio = clipSize.width / clipSize.height
        let imAspectRatio = imSize.width / imSize.height
        
        if clipAspectRatio > imAspectRatio {
            zoomFactor = clipSize.height / imSize.height
        } else {
            zoomFactor = clipSize.width / imSize.width
        }
    }

}

