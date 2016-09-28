//
//  PXView.h
//  PXImageView
//
//  Created by Calvin Kern on 5/26/15.
//  Copyright (c) 2015 Daniel Blakemore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PXImageView/PXImageView.h>

@interface PXView : UIView

@property (nonatomic, readonly) UIPickerView* contentModePicker;
@property (nonatomic, readonly) PXImageView* imageView;

typedef NS_ENUM(NSInteger, PXAnimationOrientation) {
    PXAnimationOrientationHoriztonal,
    PXAnimationOrientationVertical
};

- (void)animateDirection:(PXAnimationOrientation) orientation;

- (void)handleTap:(UITapGestureRecognizer*)sender;

@end
