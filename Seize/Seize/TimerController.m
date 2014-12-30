//
//  TimerController.m
//  Seize
//
//  Created by Yurim Jin on 2014. 12. 29..
//  Copyright (c) 2014년 Yurim Jin. All rights reserved.
//

#import "TimerController.h"

@interface TimerController () {
    bool start;
    NSTimeInterval time;
}

@end

@implementation TimerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.display.text = @"0:00";
    start = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)update {
    if (start == false) {
        return;
    }

    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsedTime = currentTime - time;
    
    int minutes = (int)(elapsedTime / 60.0);
    int seconds = (int)(elapsedTime = elapsedTime - (minutes * 60));
    
    self.display.text = [NSString stringWithFormat:@"%u:%02u", minutes, seconds];
    
    // update 재귀호출
    [self performSelector:@selector(update) withObject:self afterDelay:0.1];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buttonPressed:(id)sender {
    if (start == false) {
        start = true;

        time = [NSDate timeIntervalSinceReferenceDate];
        [sender setTitle:@"Stop!" forState:UIControlStateNormal];
        [self update];
    }else {
        start = false;
        [sender setTitle:@"Start" forState:UIControlStateNormal];
    }
}
@end
