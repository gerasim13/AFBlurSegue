//
//  AFBlurSegue.h
//  AFBlurSegue-Demo
//
//  Created by Alvaro Franco on 6/5/14.
//  Copyright (c) 2014 AlvaroFranco. All rights reserved.
//

//______________________________________________________________________________________________________________________

#import <UIKit/UIKit.h>

//______________________________________________________________________________________________________________________

@interface AFBlurSegue : UIStoryboardSegue

@property (nonatomic) CGFloat blurRadius UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *tintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat saturationDeltaFactor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) UIBlurEffectStyle blurEffectStyle UI_APPEARANCE_SELECTOR;

@end

//______________________________________________________________________________________________________________________
