//
//  TableViewCell.h
//  FoodTodo
//
//  Created by Yurim Jin on 2014. 8. 27..
//  Copyright (c) 2014년 Yurim Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoItem.h"
#import "TableViewCellDelegate.h"

//Custom TableView Cell
@interface TableViewCell : UITableViewCell

@property (nonatomic) ToDoItem *todoItem;

//Delegate
@property (nonatomic, assign) id<TableViewCellDelegate> delegate;

@end
