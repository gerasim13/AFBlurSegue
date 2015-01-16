//
//  AFBlurSegue.m
//  AFBlurSegue-Demo
//
//  Created by Alvaro Franco on 6/5/14.
//  Copyright (c) 2014 AlvaroFranco. All rights reserved.
//

//______________________________________________________________________________________________________________________

#import "AFBlurSegue.h"
#import "UIImage+ImageEffects.h"
#import "UIDevice+Hardware.h"

//______________________________________________________________________________________________________________________

@interface AFBlurSegue ()
@property (nonatomic, readonly) BOOL canBlur;
@end

//______________________________________________________________________________________________________________________

@implementation AFBlurSegue
@dynamic canBlur;

//______________________________________________________________________________________________________________________

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
    
    if (!self.canBlur)
    {
        
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

- (BOOL)canBlur
{
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_1)
    {
        NSString *device =[UIDevice deviceName];
        // Detect simulator
#ifdef DEBUG
        if([device isEqualToString:@"i386"] || [device isEqualToString:@"x86_64"])
        {
            NSInteger quality = [[UIDevice currentDevice] performSelector:@selector(_graphicsQuality)];
            return quality > 40;
        }
#endif
        // Device with poor graphics, blur not supported
        NSSet *const graphicsQuality = [NSSet setWithObjects:@[@"iPad", @"iPad1,1", @"iPhone1,1", @"iPhone1,2",
                                                               @"iPhone2,1", @"iPhone3,1", @"iPhone3,2", @"iPhone3,3",
                                                               @"iPod1,1", @"iPod2,1", @"iPod2,2", @"iPod3,1",
                                                               @"iPod4,1", @"iPad2,1", @"iPad2,2", @"iPad2,3",
                                                               @"iPad2,4", @"iPad3,1", @"iPad3,2", @"iPad3,3"], nil];
        return ![graphicsQuality containsObject:device];
    }
    return NO;
}

//______________________________________________________________________________________________________________________

@end