//
//  DemoView.swift
//  PXImageView
//
//  Created by Dave Heyborne on 2.17.16.
//  Copyright © 2016 Dave Heyborne. All rights reserved.
//

import UIKit

class View: UIView {
    enum PXAnimationOrientation {
        case PXAnimationOrientationHoriztonal
        case PXAnimationOrientationVertical
    }
    private let TriforceURL: NSURL = NSURL(string: "http://moodle.galenaparkisd.com/pluginfile.php/125718/course/section/38826/6440077107_23fd80e619_z.jpg")!
    private let TriforcePlaceholder: UIImage = UIImage(named: "triforce.png")!
    
    private var _constraints: [NSLayoutConstraint]
    
    private var _containerView: UIView
    private var _imageView: PXImageView
    private var _contentModePicker: UIPickerView
    
    private var _fullWidthConstraint: NSLayoutConstraint
    private var _minWidthConstraint: NSLayoutConstraint
    private var _fullHeightConstraint: NSLayoutConstraint
    private var _minHeightConstraint: NSLayoutConstraint
    private var _widthConstraint: NSLayoutConstraint
    private var _heightConstraint: NSLayoutConstraint
    
    private var _orientation: PXAnimationOrientation
    
    var stuff: Int = 0
    
    override init(frame: CGRect) {
        _constraints = []
        
        _containerView = UIView()
        _containerView.translatesAutoresizingMaskIntoConstraints = false
        
        _imageView = PXImageView()
        _imageView.userInteractionEnabled = false
        _imageView.contentMode = PXContentMode.TopBottom
        _imageView.backgroundColor = UIColor.blueColor()
        _imageView.setImageWithURL(TriforceURL, placeholderImage: TriforcePlaceholder)
        _imageView.translatesAutoresizingMaskIntoConstraints = false
        
        _contentModePicker = UIPickerView()
        _contentModePicker.translatesAutoresizingMaskIntoConstraints = false
        _contentModePicker.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: UILayoutConstraintAxis.Vertical)
        _contentModePicker.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: UILayoutConstraintAxis.Vertical)
        
        _fullWidthConstraint = NSLayoutConstraint(item: _imageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: _containerView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0)
        _minWidthConstraint = NSLayoutConstraint(item: _imageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: _containerView, attribute: NSLayoutAttribute.Width, multiplier: 0.1, constant: 0.0)
        _fullHeightConstraint = NSLayoutConstraint(item: _imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: _containerView, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0.0)
        _minHeightConstraint = NSLayoutConstraint(item: _imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: _containerView, attribute: NSLayoutAttribute.Height, multiplier: 0.1, constant: 0.0)
        
        _widthConstraint = _fullWidthConstraint
        _heightConstraint = _fullHeightConstraint
        
        _orientation = PXAnimationOrientation.PXAnimationOrientationHoriztonal
        
        super.init(frame: frame)
        let tapper: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap")
        tapper.cancelsTouchesInView = false
        _containerView.addGestureRecognizer(tapper)
        
        addSubview(_containerView)
        addSubview(_contentModePicker)
        _containerView.addSubview(_imageView)
        setNeedsUpdateConstraints()
    }
    
    // NOT IMPLEMENTED
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imageView: PXImageView {
        return _imageView
    }
    
    func contentModePicker() -> UIPickerView {
        return _contentModePicker
    }
    
    func animateDirection(orientation: PXAnimationOrientation) {
        _orientation = orientation
        
        _widthConstraint = _fullWidthConstraint
        _heightConstraint = _fullHeightConstraint
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
        layoutIfNeeded()
        
        switch orientation {
        case PXAnimationOrientation.PXAnimationOrientationHoriztonal:
            _widthConstraint = _minWidthConstraint
        case PXAnimationOrientation.PXAnimationOrientationVertical:
            _heightConstraint = _minHeightConstraint
        }
        setNeedsUpdateConstraints()
        
        UIView.animateKeyframesWithDuration(1, delay: 0, options: [.LayoutSubviews, .Autoreverse, .BeginFromCurrentState], animations: {self.layoutIfNeeded()}, completion: {(finished: Bool) in self.animateDirection(self._orientation)})
    }
    
    override func updateConstraints() {
        removeConstraints(_constraints)
        _constraints.removeAll()
        
        let views: [String : UIView] = ["_imageView" : _imageView, "_containerView" : _containerView, "_contentModePicker" : _contentModePicker]
        let metrics: [String : Int] = ["sp" : 20, "ssp" : 10, "bsp" : 20]
        
        _constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("H:|-sp-[_containerView]-sp-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: metrics, views: views))
        
        _constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("H:|-sp-[_contentModePicker]-sp-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: metrics, views: views))
        
        _constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("V:|-sp-[_containerView]-sp-[_contentModePicker]-sp-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: metrics, views: views))
        
        _constraints.append(NSLayoutConstraint(item: _imageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: _containerView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))
        
        _constraints.append(NSLayoutConstraint(item: _imageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: _containerView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        
        _constraints.append(_widthConstraint)
        _constraints.append(_heightConstraint)
        
        addConstraints(_constraints)
        super.updateConstraints()
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if _orientation == PXAnimationOrientation.PXAnimationOrientationHoriztonal {
            _orientation = PXAnimationOrientation.PXAnimationOrientationVertical
        } else {
            _orientation = PXAnimationOrientation.PXAnimationOrientationHoriztonal
        }
        _widthConstraint = _fullWidthConstraint
        _heightConstraint = _fullHeightConstraint
    }
}
