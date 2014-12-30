//
//  TimerController.h
//  Seize
//
//  Created by Yurim Jin on 2014. 12. 29..
//  Copyright (c) 2014년 Yurim Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *display;
- (IBAction)buttonPressed:(id)sender;

@end
