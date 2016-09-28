//
//  PXSwiftViewController.swift
//  PXImageView
//
//  Created by Dave Heyborne on 2.17.16.
//  Copyright © 2016 Dave Heyborne. All rights reserved.
//

import UIKit
import PXImageView

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    fileprivate let _contentModes: [String] = ["PXContentModeFill", "PXContentModeFit", "PXContentModeTop", "PXContentModeLeft", "PXContentModeRight", "PXContentModeBottom", "PXContentModeSides", "PXContentModeTopBottom"]
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func loadView() {
        view = View()
    }
    
    var contentView: View {
        return view as! View
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PX Image View"
        
        view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        edgesForExtendedLayout = UIRectEdge()
        
        navigationController?.navigationBar.barTintColor = UIColor.orange
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        contentView.contentModePicker().delegate = self
        contentView.contentModePicker().dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.animateDirection(View.PXAnimationOrientation.pxAnimationOrientationHoriztonal)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return _contentModes.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return _contentModes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let imageView: PXImageView = contentView.imageView
        
        switch row {
        case 0:
            imageView.contentMode = PXContentMode.fill
        case 1:
            imageView.contentMode = PXContentMode.fit
        case 2:
            imageView.contentMode = PXContentMode.top
        case 3:
            imageView.contentMode = PXContentMode.left
        case 4:
            imageView.contentMode = PXContentMode.right
        case 5:
            imageView.contentMode = PXContentMode.bottom
        case 6:
            imageView.contentMode = PXContentMode.sides
        case 7:
            imageView.contentMode = PXContentMode.topBottom
        default:
            fatalError("Invalid Row Specified")
        }
    }
}
