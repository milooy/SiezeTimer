//
//  TableViewCell.m
//  FoodTodo
//
//  Created by Yurim Jin on 2014. 8. 27..
//  Copyright (c) 2014년 Yurim Jin. All rights reserved.
//

#import "TableViewCell.h"
#import "ToDoItem.h"
#import "StrikethroughLabel.h"

@implementation TableViewCell {
    CGPoint _originalCenter;
    BOOL _deleteOnDragRelease;
    BOOL _markCompleteOnDragRelease; //내가추가
    StrikethroughLabel *_label;
    CALayer *_itemCompleteLayer;
    UILabel *_tickLabel;
    UILabel *_crossLabel;
}

const float LABEL_LEFT_MARGIN = 15.0f;
const float UI_CUES_MARGIN = 10.0f;
const float UI_CUES_WIDTH = 50.0f;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //라벨만들기
        _label = [[StrikethroughLabel alloc]initWithFrame:CGRectNull];
        _label.textColor = [UIColor colorWithRed:63/255.0 green:63/255.0 blue:63/255.0 alpha:1.0];
        _label.font = [UIFont boldSystemFontOfSize:16];
        _label.backgroundColor = [UIColor clearColor];
        [self addSubview:_label];
        
        //원래 선택된 셀의 디폴트 파랑 하이라이트 없애기
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //컴플릿되면 초록배경
        _itemCompleteLayer = [CALayer layer];
        _itemCompleteLayer.backgroundColor = [[[UIColor alloc]initWithRed:144/255.0 green:229/255.0 blue:234/255.0 alpha:0.6]CGColor];
        _itemCompleteLayer.hidden = YES;
        [self.layer insertSublayer:_itemCompleteLayer atIndex:0];
        
        //모든 pan events는 handlePan으로 전달된다.
        UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
        
        //햇님, 엑스 추가
        _tickLabel = [self createCueLabel];
        _tickLabel.text = @"\u2713";
        _tickLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_tickLabel];
        _crossLabel = [self createCueLabel];
        _crossLabel.text = @"\u2718";
        _crossLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_crossLabel];
    }
    return self;
}

-(UILabel*)createCueLabel{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectNull];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:32.0];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews {
    [super layoutSubviews];
    _itemCompleteLayer.frame = self.bounds;
    _label.frame = CGRectMake(LABEL_LEFT_MARGIN, 0, self.bounds.size.width - LABEL_LEFT_MARGIN, self.bounds.size.height);
    
    _tickLabel.frame = CGRectMake(-UI_CUES_WIDTH - UI_CUES_MARGIN, 0, UI_CUES_WIDTH, self.bounds.size.height);
    _crossLabel.frame = CGRectMake(self.bounds.size.width + UI_CUES_MARGIN, 0, UI_CUES_WIDTH, self.bounds.size.height);

}

-(void)setTodoItem:(ToDoItem *)todoItem {
    _todoItem = todoItem;
    _label.text = todoItem.text;
    _label.strikethrough = todoItem.completed;
    _itemCompleteLayer.hidden = !todoItem.completed;
}

#pragma mark - 펜제스쳐
-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:[self superview]];
    //가로 제스쳐 판별
    if(fabsf(translation.x) > fabsf(translation.y)) {
        return YES;
    }
    return NO;
}

//손가락 위치 판별
-(void)handlePan:(UIPanGestureRecognizer *)recognizer {
    //1 방금시작한 제스쳐의 현재 중점을 originalCenter에 기록
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        _originalCenter = self.center;
    }
    
    //2 움직인 x가 셀너비/2보다 크면 지우는거다.
    if(recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        self.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
        _markCompleteOnDragRelease = self.frame.origin.x > self.frame.size.width / 2;
        _deleteOnDragRelease = self.frame.origin.x < -self.frame.size.width/2;
        
        /*
        NSInteger transparency = self.frame.size.width/2 - self.frame.origin.x;
        [self.delegate toDoItemCompleting:self.todoItem transparency:transparency];
//        NSLog(@"x-y: %f", self.frame.size.width/2 - self.frame.origin.x);
        */
    }
    
    //갈수록 진해지는 햇님과 엑스
    float cueAlpha = fabsf(self.frame.origin.x)/(self.frame.size.width/2);
    _tickLabel.alpha = cueAlpha;
    _crossLabel.alpha = cueAlpha;
    
    //complete이면 초록 delete면 빨강 글씨
    _tickLabel.textColor = _markCompleteOnDragRelease?[UIColor colorWithRed:146/255.0 green:229/255.0 blue:233/255.0 alpha:1.0]:[UIColor whiteColor];
    _crossLabel.textColor = _deleteOnDragRelease? [UIColor colorWithRed:188/255.0 green:27/255.0 blue:33/255.0 alpha:1.0]:[UIColor whiteColor];
    
    
    //3
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        CGRect originalFrame = CGRectMake(0, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
        //반절까지 안차지면 다시 원자리로 돌아감
        if(!_deleteOnDragRelease) {
            [UIView animateWithDuration:0.2 animations:^{self.frame = originalFrame;}];
        }
        
        //delegate에게 "이 아이템 지워져야한다!"메세지 보내기
        if(_deleteOnDragRelease) {
            [self.delegate toDoItemDeleted:self.todoItem];
        }
        
        
        if(_markCompleteOnDragRelease){
            self.todoItem.completed = YES;
            _itemCompleteLayer.hidden = NO;
            _label.strikethrough = YES;
            [self.delegate toDoItemCompleted:self.todoItem];
        }
        
        
        
        
        /*
        if (_markCompleteOnDragRelease) {
            // mark the item as complete and update the UI state
            self.todoItem.completed = YES;
            [self.delegate toDoItemCompleted:self.todoItem];
            if (self.todoItem.completed) {
                self.todoItem.completed = NO;
                NSLog(@"NO completed");
            }
            NSLog(@"completed");
        }
         */
        
    }

}

@end
