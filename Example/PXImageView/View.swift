//
//  DemoView.swift
//  PXImageView
//
//  Created by Dave Heyborne on 2.17.16.
//  Copyright © 2016 Dave Heyborne. All rights reserved.
//

import UIKit
import PXImageView

class View: UIView {
    enum PXAnimationOrientation {
        case pxAnimationOrientationHoriztonal
        case pxAnimationOrientationVertical
    }
    fileprivate let TriforceURL: URL = URL(string: "http://moodle.galenaparkisd.com/pluginfile.php/125718/course/section/38826/6440077107_23fd80e619_z.jpg")!
    fileprivate let TriforcePlaceholder: UIImage = UIImage(named: "triforce.png")!
    
    fileprivate var _constraints: [NSLayoutConstraint]
    
    fileprivate var _containerView: UIView
    fileprivate var _imageView: PXImageView
    fileprivate var _contentModePicker: UIPickerView
    
    fileprivate var _fullWidthConstraint: NSLayoutConstraint
    fileprivate var _minWidthConstraint: NSLayoutConstraint
    fileprivate var _fullHeightConstraint: NSLayoutConstraint
    fileprivate var _minHeightConstraint: NSLayoutConstraint
    fileprivate var _widthConstraint: NSLayoutConstraint
    fileprivate var _heightConstraint: NSLayoutConstraint
    
    fileprivate var _orientation: PXAnimationOrientation
    
    var stuff: Int = 0
    
    override init(frame: CGRect) {
        _constraints = []
        
        _containerView = UIView()
        _containerView.translatesAutoresizingMaskIntoConstraints = false
        
        _imageView = PXImageView()
        _imageView.isUserInteractionEnabled = false
        _imageView.contentMode = PXContentMode.topBottom
        _imageView.backgroundColor = UIColor.blue
        _imageView.setImageWith(TriforceURL, placeholderImage: TriforcePlaceholder)
        _imageView.translatesAutoresizingMaskIntoConstraints = false
        
        _contentModePicker = UIPickerView()
        _contentModePicker.translatesAutoresizingMaskIntoConstraints = false
        _contentModePicker.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: UILayoutConstraintAxis.vertical)
        _contentModePicker.setContentHuggingPriority(UILayoutPriorityRequired, for: UILayoutConstraintAxis.vertical)
        
        _fullWidthConstraint = NSLayoutConstraint(item: _imageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: _containerView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0.0)
        _minWidthConstraint = NSLayoutConstraint(item: _imageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: _containerView, attribute: NSLayoutAttribute.width, multiplier: 0.1, constant: 0.0)
        _fullHeightConstraint = NSLayoutConstraint(item: _imageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: _containerView, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0.0)
        _minHeightConstraint = NSLayoutConstraint(item: _imageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: _containerView, attribute: NSLayoutAttribute.height, multiplier: 0.1, constant: 0.0)
        
        _widthConstraint = _fullWidthConstraint
        _heightConstraint = _fullHeightConstraint
        
        _orientation = PXAnimationOrientation.pxAnimationOrientationHoriztonal
        
        super.init(frame: frame)
        let tapper: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
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
    
    func animateDirection(_ orientation: PXAnimationOrientation) {
        _orientation = orientation
        
        _widthConstraint = _fullWidthConstraint
        _heightConstraint = _fullHeightConstraint
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
        layoutIfNeeded()
        
        switch orientation {
        case PXAnimationOrientation.pxAnimationOrientationHoriztonal:
            _widthConstraint = _minWidthConstraint
        case PXAnimationOrientation.pxAnimationOrientationVertical:
            _heightConstraint = _minHeightConstraint
        }
        setNeedsUpdateConstraints()
        
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.layoutSubviews, .autoreverse, .beginFromCurrentState], animations: {self.layoutIfNeeded()}, completion: {(finished: Bool) in self.animateDirection(self._orientation)})
    }
    
    override func updateConstraints() {
        removeConstraints(_constraints)
        _constraints.removeAll()
        
        let views: [String : UIView] = ["_imageView" : _imageView, "_containerView" : _containerView, "_contentModePicker" : _contentModePicker]
        let metrics: [String : Int] = ["sp" : 20, "ssp" : 10, "bsp" : 20]
        
        _constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-sp-[_containerView]-sp-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: metrics, views: views))
        
        _constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-sp-[_contentModePicker]-sp-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: metrics, views: views))
        
        _constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-sp-[_containerView]-sp-[_contentModePicker]-sp-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: metrics, views: views))
        
        _constraints.append(NSLayoutConstraint(item: _imageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: _containerView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0))
        
        _constraints.append(NSLayoutConstraint(item: _imageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: _containerView, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0))
        
        _constraints.append(_widthConstraint)
        _constraints.append(_heightConstraint)
        
        addConstraints(_constraints)
        super.updateConstraints()
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        if _orientation == PXAnimationOrientation.pxAnimationOrientationHoriztonal {
            _orientation = PXAnimationOrientation.pxAnimationOrientationVertical
        } else {
            _orientation = PXAnimationOrientation.pxAnimationOrientationHoriztonal
        }
        _widthConstraint = _fullWidthConstraint
        _heightConstraint = _fullHeightConstraint
    }
}
