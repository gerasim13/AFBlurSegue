//
//  AFBlurSegue.m
//  AFBlurSegue-Demo
//
//  Created by Alvaro Franco on 6/5/14.
//  Copyright (c) 2014 AlvaroFranco. All rights reserved.
//

#import "AFBlurSegue.h"
#import "UIImage+ImageEffects.h"

@implementation AFBlurSegue

-(id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination {
    
    self = [super initWithIdentifier:identifier source:source destination:destination];
    
    if (self) {
        _blurRadius = 20;
        _tintColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        _saturationDeltaFactor = 0.5;
    }
    
    return self;
}

-(void)perform {
    
    UIViewController *sourceController = self.sourceViewController;
    UIViewController *destinationController = self.destinationViewController;
    
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
        
        UIGraphicsBeginImageContextWithOptions(sourceController.view.frame.size, YES, [[UIScreen mainScreen] scale]);
        
        BOOL success = [sourceController.view drawViewHierarchyInRect:CGRectMake(0.0, 0.0, sourceController.view.frame.size.width, sourceController.view.frame.size.height) afterScreenUpdates:NO];
        
        UIImage *backgroundImage;
        if ( success )
        {
            backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        UIImageView *blurredBackground = [[UIImageView alloc]initWithImage:[backgroundImage applyBlurWithRadius:_blurRadius tintColor:_tintColor saturationDeltaFactor:_saturationDeltaFactor maskImage:nil]];
        
        CGRect backgroundRect = [sourceController.view convertRect:sourceController.view.window.bounds fromView:Nil];
        
        if (destinationController.modalTransitionStyle == UIModalTransitionStyleCoverVertical) {
            blurredBackground.frame = CGRectMake(0, -backgroundRect.size.width, backgroundRect.size.width, backgroundRect.size.height);
        } else {
            blurredBackground.frame = CGRectMake(0, 0, backgroundRect.size.width, backgroundRect.size.height);
        }
        
        
        destinationController.view.backgroundColor = [UIColor clearColor];
        
        if ([destinationController isKindOfClass:[UITableViewController class]]) {
            [[(UITableViewController *)destinationController tableView]setBackgroundView:blurredBackground];
        } else {
            [destinationController.view addSubview:blurredBackground];
            [destinationController.view sendSubviewToBack:blurredBackground];
        }
        
        [sourceController presentViewController:destinationController animated:YES completion:nil];
        
        [destinationController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            
            [UIView animateWithDuration:[context transitionDuration] animations:^{
                blurredBackground.frame = CGRectMake(0, 0, backgroundRect.size.width, backgroundRect.size.height);
            }];
        } completion:nil];
    } else {
        
        UIVisualEffect *visualEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:visualEffect];
        
        blurView.translatesAutoresizingMaskIntoConstraints = NO;

        [destinationController.view insertSubview:blurView atIndex:0];
        
        [blurView.superview addConstraint:[NSLayoutConstraint constraintWithItem:blurView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:blurView.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [blurView.superview addConstraint:[NSLayoutConstraint constraintWithItem:blurView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:blurView.superview attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [blurView.superview addConstraint:[NSLayoutConstraint constraintWithItem:blurView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:blurView.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [blurView.superview addConstraint:[NSLayoutConstraint constraintWithItem:blurView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:blurView.superview attribute:NSLayoutAttributeRight multiplier:1 constant:0]];

        destinationController.view.backgroundColor = [UIColor clearColor];
        destinationController.modalPresentationStyle = UIModalPresentationOverFullScreen;

        [sourceController presentViewController:destinationController animated:YES completion:^{
            
        }];

        [destinationController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            
        } completion:nil];
    }
}

@end