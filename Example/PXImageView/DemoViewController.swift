//
//  DemoViewController.swift
//  PXImageView
//
//  Created by Dave Heyborne on 2.17.16.
//  Copyright © 2016 Dave Heyborne. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    private let _contentModes: [String] = ["PXContentModeFill", "PXContentModeFit", "PXContentModeTop", "PXContentModeLeft", "PXContentModeRight", "PXContentModeBottom", "PXContentModeSides", "PXContentModeTopBottom"]
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func loadView() {
        view = DemoView()
    }
    
    var contentView: DemoView {
        return view as! DemoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PX Image View"
        
        view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        edgesForExtendedLayout = UIRectEdge.None
        
        navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        contentView.contentModePicker().delegate = self
        contentView.contentModePicker().dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        contentView.animateDirection(DemoView.PXAnimationOrientation.PXAnimationOrientationHoriztonal)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return _contentModes.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return _contentModes[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let imageView: PXImageView = contentView.imageView
        
        switch row {
        case 0:
            imageView.contentMode = PXContentMode.Fill
        case 1:
            imageView.contentMode = PXContentMode.Fit
        case 2:
            imageView.contentMode = PXContentMode.Top
        case 3:
            imageView.contentMode = PXContentMode.Left
        case 4:
            imageView.contentMode = PXContentMode.Right
        case 5:
            imageView.contentMode = PXContentMode.Bottom
        case 6:
            imageView.contentMode = PXContentMode.Sides
        case 7:
            imageView.contentMode = PXContentMode.TopBottom
        default:
            fatalError("Invalid Row Specified")
        }
    }
}
