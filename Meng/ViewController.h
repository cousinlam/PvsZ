//
//  ViewController.h
//  Meng
//
//  Created by Cousin Lam on 9/1/15.
//  Copyright (c) 2015 Targa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface ViewController : UIViewController <UIGestureRecognizerDelegate, UIAccelerometerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *IBJetpack;
@property (weak, nonatomic) IBOutlet UIImageView *IBTurnip;
@property (weak, nonatomic) IBOutlet UIImageView *IBRepeater;
@property (weak, nonatomic) IBOutlet UIImageView *IBBloomerang;
@property (weak, nonatomic) IBOutlet UIImageView *IBPirate;

@property (nonatomic,strong) CMMotionManager *motionManager;
// Just test GitHub

@end

