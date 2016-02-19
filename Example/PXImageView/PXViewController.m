//
//  PXViewController.m
//  PXImageView
//
//  Created by Daniel Blakemore on 05/01/2015.
//  Copyright (c) 2014 Daniel Blakemore. All rights reserved.
//

#import "PXViewController.h"
#import "PXView.h"

@interface PXViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation PXViewController
{
    NSArray* _contentModes;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)loadView
{
    [self setView:[[PXView alloc] init]];
}

- (PXView*)contentView
{
    return (PXView*)[self view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setTitle:@"PX Image View"];

    [[self view] setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];

    [[[self navigationController] navigationBar] setBarTintColor:[UIColor orangeColor]];
    [[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    _contentModes = @[@"PXContentModeFill", @"PXContentModeFit", @"PXContentModeTop", @"PXContentModeLeft", @"PXContentModeRight", @"PXContentModeBottom", @"PXContentModeSides", @"PXContentModeTopBottom"];
    
    // Set Delegates for content view picker
    [[[self contentView] contentModePicker] setDelegate:self];
    [[[self contentView] contentModePicker] setDataSource:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[self contentView] animateDirection:PXAnimationOrientationHoriztonal];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_contentModes count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _contentModes[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    PXImageView* imageView = [[self contentView] imageView];
    switch (row) {
        case 0:
            [imageView setContentMode:PXContentModeFill];
            break;
        case 1:
            [imageView setContentMode:PXContentModeFit];
            break;
        case 2:
            [imageView setContentMode:PXContentModeTop];
            break;
        case 3:
            [imageView setContentMode:PXContentModeLeft];
            break;
        case 4:
            [imageView setContentMode:PXContentModeRight];
            break;
        case 5:
            [imageView setContentMode:PXContentModeBottom];
            break;
        case 6:
            [imageView setContentMode:PXContentModeSides];
            break;
        case 7:
            [imageView setContentMode:PXContentModeTopBottom];
            break;
    }
}

@end





