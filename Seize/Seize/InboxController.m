//
//  InboxController.m
//  Seize
//
//  Created by Yurim Jin on 2014. 11. 29..
//  Copyright (c) 2014년 Yurim Jin. All rights reserved.
//

#import "InboxController.h"
#import "TodayController.h"
#import "ToDoItem.h"
#import "TableViewCell.h"

@interface InboxController ()
@end

@implementation InboxController
@synthesize realm;

-(void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];


    _toDoItems = [[NSMutableArray alloc] init];
    [_toDoItems addObject:[ToDoItem toDoItemWithText:@"iOS 공부하기"]];
    [_toDoItems addObject:[ToDoItem toDoItemWithText:@"공차 사먹기"]];
    [_toDoItems addObject:[ToDoItem toDoItemWithText:@"타블렛 사기"]];
    
    // Get the default Realm
    realm = [RLMRealm defaultRealm];
    // You only need to do this once (per thread)

    RLMResults *toDos = [ToDoModel allObjects];
    for (int i=0; i<toDos.count; i++) {
        NSLog(@"kaka: %@", toDos[i]);
        [_toDoItems addObject:[ToDoItem toDoItemWithText:toDos[i][@"text"]]];
    }
    
    
    self.tableView.dataSource = self; //데이터소스 등록
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"cell"]; //UITableViewCell 클래스를 테이블뷰에 공급하는걸로 만듦
     
    //델리게이트 설정
    self.tabBarController.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.taskField.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:237/255.0 green:107/255.0 blue:90/255.0 alpha:1.0];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView:)];
    [self.tableView addGestureRecognizer:tap];
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[TodayController class]]){
        TodayController *todayCtr = (TodayController *) viewController;
        todayCtr.toDoItems = self.toDoItems;
        todayCtr.realm = self.realm;
    }
    return TRUE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) didTapOnTableView:(UIGestureRecognizer*) recognizer {
    CGPoint tapLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
    ToDoItem *item = _toDoItems[_toDoItems.count-indexPath.row-1];
    
    NSString *text = item.text;
    NSString *query = [NSString stringWithFormat:@"text = '%@'", text];
    RLMResults *rlmObjects = [ToDoModel objectsWhere:query];
    ToDoModel *toDoModel = [rlmObjects firstObject];

    if(item.isTodayItem){
        item.isTodayItem = NO;
        [realm beginWriteTransaction];
        toDoModel.isTodayItem = false;
        [realm commitWriteTransaction];
    } else {
        [realm beginWriteTransaction];
        toDoModel.isTodayItem = true;
        [realm commitWriteTransaction];
        item.isTodayItem = YES;
    }
    [self.tableView reloadData];
    
    if (indexPath) { //we are in a tableview cell, let the gesture be handled by the view
        recognizer.cancelsTouchesInView = NO;
    } else { // anywhere else, do what is needed for your case
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewDataSource protocol methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _toDoItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"cell";
    // re-use or create a cell
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
    // find the to-do item for this index
    int index = [indexPath row];
    ToDoItem *item = _toDoItems[_toDoItems.count-index-1];
    // set the text
//    cell.textLabel.text = item.text;
    cell.delegate = self;
    cell.todoItem = item;

    return cell;
}
//단계별 색상 설정
-(UIColor*)colorForIndex:(NSInteger) index {
    NSUInteger itemCount = _toDoItems.count -1;
    float val = ((float)index / (float)itemCount) * 0.9;
    return [UIColor colorWithRed:255/255.0 green:201/255.0 blue:val alpha:1.0];
}

#pragma mark - UITableViewDataDelegate프로토콜 메서드들
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

-(void)tableView: (UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [self colorForIndex:indexPath.row];
    ToDoItem *item = _toDoItems[_toDoItems.count-indexPath.row-1];
    
    NSString *text = item.text;
    NSString *query = [NSString stringWithFormat:@"text = '%@'", text];
    RLMResults *rlmObjects = [ToDoModel objectsWhere:query];
    ToDoModel *toDoModel = [rlmObjects firstObject];
    
    if(item.isTodayItem && toDoModel.isTodayItem) {
        NSUInteger itemCount = _toDoItems.count -1;
        float val = ((float)indexPath.row / (float)itemCount) * 0.9;
        cell.backgroundColor = [UIColor colorWithRed:237/255.0 green:107/255.0 blue:val/255.0 alpha:0.3];
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
    if(_taskField.text && _taskField.text.length > 0){
        NSLog(@"not empty: %@", _taskField.text);
        
        ToDoModel *toDoModel = [[ToDoModel alloc]init];
        toDoModel.text = _taskField.text;
        
        // Add to Realm with transaction
        [realm beginWriteTransaction];
        [realm addObject:toDoModel];
        [realm commitWriteTransaction];
        
        [_toDoItems addObject:[ToDoItem toDoItemWithText:_taskField.text]];
        _taskField.text = @"";
        [[self view] endEditing:YES];
        [self.tableView reloadData];
    }
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
    NSUInteger index = [_toDoItems indexOfObject:todoItem];
    [self.tableView beginUpdates];
    [_toDoItems removeObject:todoItem];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_toDoItems.count-index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    NSString *text = todoItem.text;
    NSString *query = [NSString stringWithFormat:@"text = '%@'", text];
    RLMResults *rlmObject = [ToDoModel objectsWhere:query];
    [realm beginWriteTransaction];
    [realm deleteObject:rlmObject.firstObject];
    [realm commitWriteTransaction];
    
    [self.tableView endUpdates];
    
}

-(void)toDoItemCompleted:(ToDoItem *)todoItem {
    
}
@end
