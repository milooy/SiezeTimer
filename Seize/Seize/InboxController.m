//
//  InboxController.m
//  Seize
//
//  Created by Yurim Jin on 2014. 11. 29..
//  Copyright (c) 2014년 Yurim Jin. All rights reserved.
//

#import "InboxController.h"
#import "ToDoItem.h"

@interface InboxController () {
    NSMutableArray* _toDoItems;
}

@end

@implementation InboxController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    _toDoItems = [[NSMutableArray alloc] init];
    [_toDoItems addObject:[ToDoItem toDoItemWithText:@"iOS 공부하기"]];
    [_toDoItems addObject:[ToDoItem toDoItemWithText:@"공차 사먹기"]];
    [_toDoItems addObject:[ToDoItem toDoItemWithText:@"타블렛 사기"]];
    [_toDoItems addObject:[ToDoItem toDoItemWithText:@"김정교수님 찾아가기"]];
    [_toDoItems addObject:[ToDoItem toDoItemWithText:@"외주받아서 돈벌기"]];
    [_toDoItems addObject:[ToDoItem toDoItemWithText:@"고대생막창 먹기"]];
    [_toDoItems addObject:[ToDoItem toDoItemWithText:@"JWP 공부하기"]];
    [_toDoItems addObject:[ToDoItem toDoItemWithText:@"영화보기"]];
    [_toDoItems addObject:[ToDoItem toDoItemWithText:@"아이폰 사기"]];
    [_toDoItems addObject:[ToDoItem toDoItemWithText:@"앱 만들기"]];
    [_toDoItems addObject:[ToDoItem toDoItemWithText:@"캐릭터 그리기"]];
    [_toDoItems addObject:[ToDoItem toDoItemWithText:@"타블렛으로 그리기"]];
    
    self.tableView.dataSource = self; //데이터소스 등록
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"]; //UITableViewCell 클래스를 테이블뷰에 공급하는걸로 만듦
    //    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"cell"]; //TableViewCell 클래스를 테이블뷰에 공급하는걸로 만듦
    
    //델리게이트 설정
    self.tableView.delegate = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:237/255.0 green:107/255.0 blue:90/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource protocol methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _toDoItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"cell";
    // re-use or create a cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
    // find the to-do item for this index
    int index = [indexPath row];
    ToDoItem *item = _toDoItems[_toDoItems.count-index-1];
    // set the text
    cell.textLabel.text = item.text;
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
    /*
     ToDoItem *item = _toDoItems[indexPath.row];
     if (item.completed) {
     cell.backgroundColor = [UIColor greenColor];
     }
     */
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
    _taskField.text = @"";
    [[self view] endEditing:YES];
    [self.tableView reloadData];
    NSLog(@"hahaha");
}
@end
