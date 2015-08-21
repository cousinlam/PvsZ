//
//  ViewController.m
//  Meng
//
//  Created by Cousin Lam on 9/1/15.
//  Copyright (c) 2015 Targa. All rights reserved.
//

#import "ViewController.h"

#define moveY_slope (10.0f)

@interface ViewController ()

@end

@implementation ViewController {
    UIDeviceOrientation deviceO;
    UIView *currentView;
    CGAffineTransform currentViewOffsetTrans;
    NSArray *canTouchView;
    NSArray *canMoveCharacters;
}

@synthesize motionManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    self.motionManager = [[CMMotionManager alloc] init];
    
    [self.motionManager setAccelerometerUpdateInterval:0.02];
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 [self moveCharacter:accelerometerData.acceleration];
                                             }];
    /*
    [self.motionManager setGyroUpdateInterval:2];
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        NSLog(@"gyroData.rotationRate.x is %.2f",gyroData.rotationRate.x);
                                    }];
     */
    
    canTouchView = [[NSArray alloc] initWithObjects:_IBTurnip, _IBBloomerang, _IBRepeater, nil];
    canMoveCharacters = [[NSArray alloc] initWithObjects:
                         [[NSArray alloc] initWithObjects:_IBPirate, [NSNumber numberWithFloat:0.3f], nil],
                         [[NSArray alloc] initWithObjects:_IBJetpack, [NSNumber numberWithFloat:1.7f], nil],
                         nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([canTouchView containsObject:touch.view]) {
        currentView = touch.view;
        currentViewOffsetTrans = currentView.transform;
        [self.view bringSubviewToFront:touch.view];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if ([canTouchView containsObject:touch.view] && touch.tapCount == 3) {
        [self.view bringSubviewToFront:currentView];
        touch.view.transform = CGAffineTransformIdentity;
    }
    currentView = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    deviceO = [[UIDevice currentDevice] orientation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"*****************************");
    NSLog(@"*  didReceiveMemoryWarning  *");
    NSLog(@"*****************************");
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (void) moveCharacter:(CMAcceleration)acceleration {
    float moveX;
    float moveY;
    switch (deviceO) {
        case UIDeviceOrientationLandscapeLeft:
            moveX -= 20 * acceleration.y;
            moveY -= 20 * acceleration.x;
            break;
        case UIDeviceOrientationLandscapeRight:
            moveX += 20 * acceleration.y;
            moveY += 20 * acceleration.x;
            break;
        case UIDeviceOrientationPortrait:
            moveX += 20 * acceleration.x;
            moveY -= 20 * acceleration.y;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            moveX -= 20 * acceleration.x;
            moveY += 20 * acceleration.y;
            break;
        default:
            break;
    }
    if isnan(moveX) moveX = 0;
    if isnan(moveY) moveY = 0;
    
    for (NSArray *eachC in canMoveCharacters) {
        
        UIImageView *eachC_Image = [eachC objectAtIndex:0];
        NSNumber *eachC_Speed_NSNumber = [eachC objectAtIndex:1];
        float eachC_Speed = [eachC_Speed_NSNumber floatValue];
        
        eachC_Image.transform = CGAffineTransformTranslate(eachC_Image.transform, moveX * eachC_Speed, (moveY - moveY_slope) * eachC_Speed);
        
        if (eachC_Image.frame.origin.x > self.view.frame.size.width + 2) {
            eachC_Image.transform = CGAffineTransformTranslate(eachC_Image.transform, -2 - self.view.frame.size.width - eachC_Image.frame.size.width, 0);
        }else if (eachC_Image.frame.origin.x  < 0 - eachC_Image.frame.size.width) {
            eachC_Image.transform = CGAffineTransformTranslate(eachC_Image.transform, self.view.frame.size.width + eachC_Image.frame.size.width + 2, 0);
        }
        
        if (eachC_Image.frame.origin.y > self.view.frame.size.height + 2) {
            eachC_Image.transform = CGAffineTransformTranslate(eachC_Image.transform, 0, -2 - self.view.frame.size.height - eachC_Image.frame.size.height);
        }else if (eachC_Image.frame.origin.y <  0 - eachC_Image.frame.size.height) {
            eachC_Image.transform = CGAffineTransformTranslate(eachC_Image.transform, 0, self.view.frame.size.height + eachC_Image.frame.size.height + 2);
        }
    }

}

- (IBAction)moveView:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:currentView];
    currentView.transform = CGAffineTransformTranslate(currentViewOffsetTrans, translation.x, translation.y);
    if([sender state] == UIGestureRecognizerStateEnded){
        currentView = nil;
    }
}

- (IBAction)rotateView:(UIRotationGestureRecognizer *)sender {
    currentView.transform = CGAffineTransformRotate(currentViewOffsetTrans, [sender rotation]);
    if([sender state] == UIGestureRecognizerStateEnded){
        currentView = nil;
    }
}

- (IBAction)pinchView:(UIPinchGestureRecognizer *)sender {
    currentView.transform = CGAffineTransformScale(currentViewOffsetTrans, sender.scale, sender.scale);
    if([sender state] == UIGestureRecognizerStateEnded){
        currentView = nil;
    }
}

@end
