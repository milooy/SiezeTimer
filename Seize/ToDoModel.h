//
//  ToDoModel.h
//  Seize
//
//  Created by Yurim Jin on 2014. 12. 30..
//  Copyright (c) 2014년 Yurim Jin. All rights reserved.
//

#import <Realm/Realm.h>

@interface ToDoModel : RLMObject
@property NSString *text; //투두내용
@property BOOL completed; //완료여부
@property BOOL isTodayItem;
@property int totalMin;
@property int totalSec;
@property int curMin;
@property int curSec;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<ToDoModel>
RLM_ARRAY_TYPE(ToDoModel)
