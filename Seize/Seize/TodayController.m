//
//  TodayController.m
//  Seize
//
//  Created by Yurim Jin on 2014. 12. 28..
//  Copyright (c) 2014년 Yurim Jin. All rights reserved.
//

#import "TodayController.h"
#import "InboxController.h"
#import "ToDoItem.h"
#import "TableViewCell.h"

@interface TodayController () {
    NSMutableArray *todayItems;
}

@end

@implementation TodayController

-(void)viewDidAppear:(BOOL)animated {
    [self addItemToday];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addItemToday];
    self.tableView.dataSource = self; //데이터소스 등록
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"cell"]; //UITableViewCell 클래스를 테이블뷰에 공급하는걸로 만듦
    
    //델리게이트 설정
    self.tableView.delegate = self;
    self.taskField.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:237/255.0 green:107/255.0 blue:90/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addItemToday {
    todayItems = [[NSMutableArray alloc] init];
    for (ToDoItem *item in _toDoItems) {
        if(item.isTodayItem){
            [todayItems addObject:item];
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource protocol methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return todayItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
    int index = [indexPath row];
    ToDoItem *item = todayItems[todayItems.count-index-1];
//    cell.textLabel.text = item.text;
    
    cell.delegate = self;
    cell.todoItem = item;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int controllerIndex = 3;
    
    UITabBarController *tabBarController = self.tabBarController;
    UIView * fromView = tabBarController.selectedViewController.view;
    UIView * toView = [[tabBarController.viewControllers objectAtIndex:controllerIndex] view];
    
    // Transition using a page curl.
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:(controllerIndex > tabBarController.selectedIndex ? UIViewAnimationOptionTransitionCrossDissolve : UIViewAnimationOptionTransitionCrossDissolve)
                    completion:^(BOOL finished) {
                        if (finished) {
                            tabBarController.selectedIndex = controllerIndex;
                        }
                    }];
}

//단계별 색상 설정
-(UIColor*)colorForIndex:(NSInteger) index {
    NSUInteger itemCount = todayItems.count -1;
    float val = ((float)index / (float)itemCount) * 0.9;
    return [UIColor colorWithRed:255/255.0 green:201/255.0 blue:val alpha:1.0];
}

#pragma mark - UITableViewDataDelegate프로토콜 메서드들
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

-(void)tableView: (UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [self colorForIndex:indexPath.row];
    ToDoItem *item = todayItems[indexPath.row];
    if(item.isTodayItem) {
        cell.backgroundColor = [UIColor colorWithRed:237/255.0 green:107/255.0 blue:90/255.0 alpha:1.0];
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)addBtnClick:(id)sender {
    [_toDoItems addObject:[ToDoItem toDoItemWithText:_taskField.text]];
    [todayItems addObject:[ToDoItem toDoItemWithText:_taskField.text]];
    _taskField.text = @"";
    [[self view] endEditing:YES];
    [self.tableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.taskField) {
        [_addBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        [textField resignFirstResponder];
        [self.tableView reloadData];
        return NO;
    }
    return YES;
}

-(void)toDoItemDeleted:(ToDoItem *)todoItem {
    NSUInteger index = [todayItems indexOfObject:todoItem];
    [self.tableView beginUpdates];
    [_toDoItems removeObject:todoItem];
    [todayItems removeObject:todoItem];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:todayItems.count-index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
}

-(void)toDoItemCompleted:(ToDoItem *)todoItem {
    
}

@end
