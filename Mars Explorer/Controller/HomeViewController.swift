//
//  HomeViewController.swift
//  Mars Explorer
//
//  Created by Asad Ahmed on 8/6/17.
//  Copyright © 2017 Asad Ahmed. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController
{
    // MARK:- IBOutlets
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var loadingMessageLabel: UILabel!
    @IBOutlet weak var scifiSpinner: SciFiActivitySpinner!
    @IBOutlet weak var roverButton: UIButton!
    @IBOutlet weak var solButton: UIButton!
    @IBOutlet weak var roverSelectionPanel: UIView!
    @IBOutlet weak var roverManifestPanel: UIView!
    @IBOutlet var roverButtons: [UIButton]!
    @IBOutlet weak var exploreButton: UIButton!
    @IBOutlet weak var roverSelectionPanelCenterYConstraint: NSLayoutConstraint!
    
    // MARK:- Variables
    
    fileprivate let BUTTON_ID_ROVER = 0
    fileprivate let BUTTON_ID_SOL = 1
    
    fileprivate let ROVER_BUTTON_ID_CURIOSITY = 0
    fileprivate let ROVER_BUTTON_ID_OPPORTUNITY = 1
    fileprivate let ROVER_BUTTON_ID_SPIRIT = 2
    
    fileprivate var manifests: [Rover: RoverManifest]? = nil
    
    fileprivate var selectedRover: Rover? = nil
    
    // MARK:- Setup
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupUI()
    }

    // Setup the UI
    fileprivate func setupUI()
    {
        // background image
        ViewBuilder.setupHomeScreenBackground(view: view)
        
        // message view
        ViewBuilder.setupTranslucentBlackViewWithGradientBorder(view: messageView)
        messageView.isHidden = true
        
        // rover selection panel
        ViewBuilder.setupTranslucentBlackViewWithGradientBorder(view: roverSelectionPanel)
        roverSelectionPanel.isHidden = true
        
        // rover manifest panel
        ViewBuilder.setupTranslucentBlackViewWithGradientBorder(view: roverManifestPanel)
        roverManifestPanel.isHidden = true
        exploreButton.isHidden = true
        
        // rover manifest panel imageview
        let imageview = roverManifestPanel.subviews.first { $0 is UIImageView } as! UIImageView
        ViewBuilder.setupTranslucentBlackViewWithGradientBorder(view: imageview)
        
        // ambience music
        SoundEffectPlayer.shared.playBackgroundAmbience(filename: UIConstants.BACKGROUND_AMBIENCE_PATH)
    }
    
    // MARK:- Events
    
    // User taps on the button to decide on SOL or rover selection
    @IBAction func buttonTapped(_ sender: UIButton)
    {
        switch sender.tag
        {
        case BUTTON_ID_SOL:
            scifiSpinner.stopAnimating()
            
        case BUTTON_ID_ROVER:
            if manifests == nil
            {
                scifiSpinner.startAnimating()
                loadingMessageLabel.text = "Downloading Rover Manifests..."
                messageView.isHidden = false
                
                NASADataAPI.shared.downloadRoverManifests(callback: { [weak self] (manifests, error) in
                    DispatchQueue.main.async {
                        ViewAnimator.animateRoverSelectionPanelEntry(panel: (self?.roverSelectionPanel)!)
                        SoundEffectPlayer.shared.playSoundEffectOnce(filename: UIConstants.UI_SOUND_EFFECT_PATH)
                        
                        self?.scifiSpinner.stopAnimating()
                        self?.messageView.isHidden = true
                        
                        if let manifests = manifests
                        {
                            self?.manifests = manifests
                            self?.roverSelectionPanel.isHidden = false
                        }
                    }
                })
            }
            
        default:
            return
        }
    }
    
    // User taps on a button to select a rover to view the manifest
    @IBAction func roverButtonTapped(_ sender: UIButton)
    {
        // update the view controller state
        switch sender.tag
        {
        case ROVER_BUTTON_ID_CURIOSITY:
            selectedRover = .curiousity
            
        case ROVER_BUTTON_ID_OPPORTUNITY:
            selectedRover = .opportunity
            
        case ROVER_BUTTON_ID_SPIRIT:
            selectedRover = .spirit
            
        default:
            selectedRover = nil
            return
        }
        
        // play sound effect for UI
        SoundEffectPlayer.shared.playSoundEffectOnce(filename: UIConstants.UI_SOUND_EFFECT_PATH)
        
        // animate the selection panel and show the rover manifest panel
        if roverManifestPanel.isHidden {
            ViewAnimator.animateRoverSelectionPanelUp(panel: roverSelectionPanel, centerYConstraint: roverSelectionPanelCenterYConstraint)
        }
        
        // show the rover manifest panel with an animation
        roverManifestPanel.isHidden = false
        ViewAnimator.animatePanelFlipFromBottom(panel: roverManifestPanel)
        ViewBuilder.fillRoverManifestPanelWithInfo(panel: roverManifestPanel, rover: selectedRover!, manifest: manifests![selectedRover!]!)
        exploreButton.isHidden = false
    }
    
    // User taps on the explore button to begin the explore experience
    @IBAction func exploreButtonTapped(_ sender: UIButton)
    {
        
    }
}
