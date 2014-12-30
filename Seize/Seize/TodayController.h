//
//  TodayController.h
//  Seize
//
//  Created by Yurim Jin on 2014. 12. 28..
//  Copyright (c) 2014년 Yurim Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InboxController.h"

@interface TodayController : UIViewController<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *taskField;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
- (IBAction)addBtnClick:(id)sender;

@property (strong, nonatomic) NSMutableArray *toDoItems;

@end
