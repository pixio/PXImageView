//
//  PXView.m
//  PXImageView
//
//  Created by Calvin Kern on 5/26/15.
//  Copyright (c) 2015 Daniel Blakemore. All rights reserved.
//

#import "PXView.h"

#import <PXImageView/PXImageView.h>

@implementation PXView
{
    NSLayoutConstraint* _fullWidthConstraint;
    NSLayoutConstraint* _minWidthConstraint;
    NSLayoutConstraint* _fullHeightConstraint;
    NSLayoutConstraint* _minHeightConstraint;
    
    NSLayoutConstraint* _widthConstraint;
    NSLayoutConstraint* _heightConstraint;
    
    UIView* _containerView;
    
    NSMutableArray* _constraints;
    PXAnimationOrientation _orientation;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
//        NSString* triforceString = @"http://zeldawiki.org/images/thumb/2/23/ALBW_Triforce.png/200px-ALBW_Triforce.png";
        NSString* portraitString = @"http://moodle.galenaparkisd.com/pluginfile.php/125718/course/section/38826/6440077107_23fd80e619_z.jpg";
//        NSString* _landscapeString =  @"http://dummyimage.com/600x400/000/fff";
        
        UIImage* triforcePlaceholder = [UIImage imageNamed:@"triforce.png"];
        NSURL* portraitURL = [NSURL URLWithString:portraitString];
        
        // Initialize class vars
        _constraints = [NSMutableArray array];
        UITapGestureRecognizer* tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [tapper setCancelsTouchesInView:FALSE];
        
        // Initialize Views
        _containerView = [[UIView alloc] init];
        [_containerView addGestureRecognizer:tapper];
        [_containerView setTranslatesAutoresizingMaskIntoConstraints:FALSE];
        
        _imageView = [[PXImageView alloc] init];
        [_imageView setUserInteractionEnabled:FALSE];
        [_imageView setContentMode:PXContentModeTopBottom];
        [_imageView setBackgroundColor:[UIColor blueColor]];
        [_imageView setImageWithURL:portraitURL placeholderImage:triforcePlaceholder];
        [_imageView setTranslatesAutoresizingMaskIntoConstraints:FALSE];

        _contentModePicker = [[UIPickerView alloc] init];
        [_contentModePicker setTranslatesAutoresizingMaskIntoConstraints:FALSE];
        [_contentModePicker setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [_contentModePicker setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

        // Init layout constraints
        _fullWidthConstraint = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
        _minWidthConstraint = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeWidth multiplier:0.1 constant:0.0];

        _fullHeightConstraint = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
        _minHeightConstraint = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeHeight multiplier:0.1 constant:0.0];

        // Add subviews
        [self addSubview:_containerView];
        [self addSubview:_contentModePicker];
        [_containerView addSubview:_imageView];

        _widthConstraint = _fullWidthConstraint;
        _heightConstraint = _fullHeightConstraint;
        
        [self setNeedsUpdateConstraints];
    }
    
    return self;
}

- (void)animateDirection:(PXAnimationOrientation) orientation
{
    _orientation = orientation;
    
    _widthConstraint = _fullWidthConstraint;
    _heightConstraint = _fullHeightConstraint;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    
    // Animate direction
    switch (orientation) {
        case PXAnimationOrientationHoriztonal:
            _widthConstraint = _minWidthConstraint;
            break;
        case PXAnimationOrientationVertical:
            _heightConstraint = _minHeightConstraint;
            break;
    }
    
    [self setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self animateDirection:_orientation];
        }
    }];
}

- (void)updateConstraints
{
    [self removeConstraints:_constraints];
    [_constraints removeAllObjects];
    
    NSNumber* bsp = [NSNumber numberWithInt:20];
    NSDictionary* views = NSDictionaryOfVariableBindings(_imageView, _containerView, _contentModePicker);
    NSDictionary* metrics = @{@"sp" : @20, @"ssp" : @10, @"bsp" :bsp};

    // Horizontal
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sp-[_containerView]-sp-|" options:0 metrics:metrics views:views]];
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sp-[_contentModePicker]-sp-|" options:0 metrics:metrics views:views]];
    
    // Vertical
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-sp-[_containerView]-sp-[_contentModePicker]-sp-|" options:0 metrics:metrics views:views]];
    
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];

    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    [_constraints addObject:_widthConstraint];
    [_constraints addObject:_heightConstraint];
    
    [self addConstraints:_constraints];
    [super updateConstraints];
}

- (void)handleTap:(UITapGestureRecognizer*)sender
{
    if (_orientation == PXAnimationOrientationHoriztonal) {
        _orientation = PXAnimationOrientationVertical;
    } else {
        _orientation = PXAnimationOrientationHoriztonal;
    }

    _widthConstraint = _fullWidthConstraint;
    _heightConstraint = _fullHeightConstraint;
    
    //[self animateDirection:_orientation];
}

@end
