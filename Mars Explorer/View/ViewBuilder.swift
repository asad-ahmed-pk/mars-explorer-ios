//
//  ViewBuilder.swift
//  Mars Explorer
//
//  Created by Asad Ahmed on 8/8/17.
//  Copyright © 2017 Asad Ahmed. All rights reserved.
//
//  Contructs views and deals with all UI mangement for view controllers of this app
//

import UIKit

class ViewBuilder
{
    // MARK:- Constants
    fileprivate static let ROVER_MANIFEST_PANEL_ROVER_NAME_TAG = 0
    fileprivate static let ROVER_MANIFEST_PANEL_LAND_DATE_TAG = 1
    fileprivate static let ROVER_MANIFEST_PANEL_LAUNCH_DATE_TAG = 2
    fileprivate static let ROVER_MANIFEST_PANEL_STATUS_TAG = 3
    fileprivate static let ROVER_MANIFEST_PANEL_SOL_TAG = 4
    fileprivate static let ROVER_MANIFEST_PANEL_PHOTOS_TAG = 5
    
    // MARK:- Public API
    
    // Sets up the home screen background
    static func setupHomeScreenBackground(view: UIView)
    {
        view.layer.contents = #imageLiteral(resourceName: "Background").cgImage
        view.layer.contentsGravity = kCAGravityResizeAspectFill
    }
    
    // Sets up the given view to have a translucent black background and a gradient border appropriate for this app
    static func setupTranslucentBlackViewWithGradientBorder(view: UIView)
    {
        view.layer.borderColor = UIColor.clear.cgColor
        view.backgroundColor = UIConstants.PANEL_BACKGROUND_COLOR
        
        // gradient color
        let gradient = CAGradientLayer()
        gradient.masksToBounds = true
        gradient.frame = CGRect(origin: CGPoint.zero, size: view.frame.size)
        gradient.colors = UIConstants.GRADIENT_COLORS_BORDER
        
        // apply gradient to outline of the view
        let shape = CAShapeLayer()
        shape.lineWidth = 2
        shape.path = UIBezierPath(rect: view.bounds).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        view.layer.addSublayer(gradient)
    }
    
    // Sets up the loading message view that contains a label for setting the message
    static func setupMessageView(messageView: UIView)
    {
        messageView.backgroundColor = UIColor.clear
        messageView.layer.contents = #imageLiteral(resourceName: "Loading Message Panel").cgImage
        messageView.layer.contentsGravity = kCAGravityResizeAspect
    }
    
    // Fills the rover manifest panel with info based on the rover manifest data
    static func fillRoverManifestPanelWithInfo(panel:UIView, rover: Rover, manifest: RoverManifest)
    {
        // the rover image
        let image = UIImage(named: UIConstants.ROVER_IMAGE_NAMES[rover]!)!
        let imageview = (panel.subviews.first { $0 is UIImageView }) as! UIImageView
        imageview.image = image
        
        // rover name label
        let nameLabel = panel.subviews.first { $0 is UILabel } as! UILabel
        nameLabel.text = manifest.name
        
        // get the stack view that holds the info labels
        let stackview = panel.subviews.first { $0 is UIStackView } as! UIStackView
        
        // manifest info labels
        for view in stackview.arrangedSubviews
        {
            if let label = view as? UILabel
            {
                switch label.tag
                {
                    
                case ROVER_MANIFEST_PANEL_SOL_TAG:
                    label.text = "Time On Mars: \(manifest.totalSols) Sols"
                    
                case ROVER_MANIFEST_PANEL_LAND_DATE_TAG:
                    label.text = "Landing Date: \(manifest.landingDate)"
                    
                case ROVER_MANIFEST_PANEL_LAUNCH_DATE_TAG:
                    label.text = "Launch Date: \(manifest.launchDate)"
                    
                case ROVER_MANIFEST_PANEL_STATUS_TAG:
                    label.text = "Status: \(manifest.status)"
                    
                case ROVER_MANIFEST_PANEL_PHOTOS_TAG:
                    label.text = "Total Photos Taken: \(manifest.totalPhotos)"
                    
                default:
                    break
                }
            }
        }
    }
}
