//
//  StrikethroughLabel.m
//  FoodTodo
//
//  Created by Yurim Jin on 2014. 9. 25..
//  Copyright (c) 2014년 Yurim Jin. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "StrikethroughLabel.h"

@implementation StrikethroughLabel{
    bool _strikethrough;
    CALayer* _strikethroughLayer;
}

const float STRIKEOUT_THICKNESS = 5.0f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _strikethroughLayer = [CALayer layer];
        _strikethroughLayer.backgroundColor = [[UIColor colorWithRed:239/255.0 green:108/255.0 blue:90/255.0 alpha:1.0] CGColor];
        _strikethroughLayer.hidden = YES;
        [self.layer addSublayer:_strikethroughLayer];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self resizeStrikeThrough];
}

-(void) setText:(NSString *)text{
    [super setText:text];
    [self resizeStrikeThrough];
}

//텍스트사이즈에 맞춰서 취소선 긋기
-(void)resizeStrikeThrough {
//    CGSize textSize = [self.text sizeWithFont:self.font];
    CGSize textSize = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    _strikethroughLayer.frame = CGRectMake(0, self.bounds.size.height/2, textSize.width, STRIKEOUT_THICKNESS);
}

-(void)setStrikethrough:(bool)strikethrough {
    _strikethrough = strikethrough;
    _strikethroughLayer.hidden = !strikethrough;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
