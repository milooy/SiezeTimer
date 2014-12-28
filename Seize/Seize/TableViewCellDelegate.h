//
//  TableViewCellDelegate.h
//  FoodTodo
//
//  Created by Yurim Jin on 2014. 8. 28..
//  Copyright (c) 2014년 Yurim Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToDoItem.h"

@protocol TableViewCellDelegate <NSObject>

//Deleted된거 알려줌!
-(void) toDoItemDeleted:(ToDoItem *)todoItem;
-(void) toDoItemCompleted:(ToDoItem *)todoItem;
@end