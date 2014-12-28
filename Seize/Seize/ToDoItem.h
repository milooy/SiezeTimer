//
//  ToDoItem.h
//  Seize
//
//  Created by Yurim Jin on 2014. 11. 20..
//  Copyright (c) 2014년 Yurim Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject

@property(nonatomic, copy) NSString *text; //투두내용
@property(nonatomic) BOOL completed; //완료여부
-(id)initWithText:(NSString*)text; //텍스트 주고 ToDoItem반환
+(id)toDoItemWithText:(NSString*)text; //클래스 메서드


@end
