//
//  InboxController.h
//  Seize
//
//  Created by Yurim Jin on 2014. 11. 29..
//  Copyright (c) 2014년 Yurim Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InboxController : UIViewController <UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>
//@property (strong, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) IBOutlet UITextField *taskField;
//- (IBAction)addBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) IBOutlet UITextField *taskField;
@property (retain,nonatomic) NSMutableArray *toDoItems;
- (IBAction)addBtnClick:(id)sender;
@end
