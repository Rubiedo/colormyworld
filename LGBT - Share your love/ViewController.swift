//
//  ViewController.swift
//  LGBT - Share your love
//
//  Created by Stephen Wu on 7/7/15.
//  Copyright (c) 2015 Stephen Wu. All rights reserved.
//

import UIKit
import iAd
import Social


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ADBannerViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bannerView: ADBannerView!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var colorify: UIButton!
    @IBOutlet weak var savePhoto: UIButton!
    @IBOutlet weak var facebook: UIButton!
    @IBOutlet weak var twitter: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bannerView.hidden = true
        bannerView.delegate = self
        self.canDisplayBannerAds = true
        label.hidden = true
        facebook.hidden = true
        twitter.hidden = true
        colorify.enabled = false
        savePhoto.enabled = false
        facebook.enabled = false
        twitter.enabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func colorify(sender: UIButton) {
        
        let newImage:UIImage = loveWins(imageView.image!)
        imageView.image = newImage
        colorify.enabled = false
        label.hidden = false
        facebook.hidden = false
        twitter.hidden = false
        facebook.enabled = true
        twitter.enabled = true
        
    }
    
    func loveWins(img: UIImage) -> UIImage {
        
        
        
        // create a CGRect representing the full size of our input iamge
        let flagRect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        
        // figure out the height of one flag section (there are six)
        let sectionHeight = img.size.height / 6
        
        // set up the colors for our flag – these are based on my trial and error
        // based on what looks good blended with white using Core Graphics blend modes
        let red = UIColor(red: 1, green: 0.5, blue: 0.5, alpha: 0.8).CGColor
        let orange = UIColor(red: 1, green: 0.7, blue: 0.35, alpha: 0.8).CGColor
        let yellow = UIColor(red: 1, green: 0.85, blue: 0.1, alpha: 0.65).CGColor
        let green = UIColor(red: 0, green: 0.7, blue: 0.2, alpha: 0.5).CGColor
        let blue = UIColor(red: 0, green: 0.35, blue: 0.7, alpha: 0.5).CGColor
        let purple = UIColor(red: 0.3, green: 0, blue: 0.5, alpha: 0.6).CGColor
        let colors = [red, orange, yellow, green, blue, purple]
        
        // set up our drawing context
        UIGraphicsBeginImageContextWithOptions(img.size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        
        // fill the background with white so that translucent colors get lighter
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillRect(context, flagRect)
        
        // loop through all six colors
        autoreleasepool{
        for i in 0 ..< 6 {
            let color = colors[i]
            
            // figure out the rect for this flag section
            let rect = CGRect(x: 0, y: CGFloat(i) * sectionHeight, width: flagRect.width, height: sectionHeight)
            
            // draw it onto the context at the right place
            CGContextSetFillColorWithColor(context, color)
            CGContextFillRect(context, rect)
        }
        }
        // now draw our input image over using Luminosity mode, with a little bit of alpha to make it fainter
        // IF YOU ARE USING SWIFT 2: Change "kCGBlendModeLuminosity" to ".Luminosity" and you're done
        img.drawInRect(flagRect, blendMode: kCGBlendModeLuminosity, alpha: 0.6)
        
        // grab the finished image and return it
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
        
    }
    
    @IBAction func takePhoto(sender: UIButton) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Choose image source", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) -> Void in
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Camera Roll", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
            
            imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imagePickerController, animated: true, completion: nil)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let image:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismissViewControllerAnimated(true, completion: nil)
        imageView.image = image
        colorify.enabled = true
        savePhoto.enabled = true
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func savePhoto(sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(imageView.image, nil, nil, nil)
    }
    
    @IBAction func shareOnFacebook(sender: UIButton) {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            var facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("#lovewins #shareyourlove")
            facebookSheet.addImage(imageView.image)
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func shareOnTwitter(sender: UIButton) {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            var twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText("#lovewins #shareyourlove")
            twitterSheet.addImage(imageView.image)
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }

    func bannerViewDidLoadAd(banner: ADBannerView!) {
        bannerView.hidden = false
    }
    
}