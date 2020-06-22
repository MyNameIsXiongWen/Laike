//
//  QHWTagView.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/20.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWTagView.h"
#import "QHWTagListModel.h"

#define LABEL_SPACE        5
#define BOTTOM_MARGIN      10

@interface QHWTagView (){
    CGRect previousFrame ;
}
@end
@implementation QHWTagView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}

-(void)setTagWithTagArray:(NSArray*)arr {
    previousFrame = CGRectZero;
    CGFloat lblH = 15;
    self.tagViewHeight = 25;
    for (UIView *subviews in self.subviews) {
        [subviews removeFromSuperview];
    }
    
    [arr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        UILabel *label = UILabel.labelFrame(CGRectMake(0, 0, 100, lblH))
                                .labelText(obj)
                                .labelFont(kFontTheme11)
                                .labelTitleColor(kColorThemefff)
                                .labelBkgColor(kColorTheme5c98f8)
                                .labelTextAlignment(NSTextAlignmentCenter)
                                .labelCornerRadius(2);
        
        [self setTagLabelMargin:label fontMargin:LABEL_SPACE];
        [self addSubview:label];
        CGRect newRect = CGRectZero;
        newRect.size = label.frame.size;
        if (self->previousFrame.origin.x + self->previousFrame.size.width + label.width > kScreenW - 40){
            self.tagViewHeight += 25;
            newRect.origin = CGPointMake(0, self->previousFrame.origin.y + label.height + BOTTOM_MARGIN);
        } else {
            if (idx == 0) {
                newRect.origin = CGPointMake(self->previousFrame.origin.x + self->previousFrame.size.width, self->previousFrame.origin.y);
            } else {
                newRect.origin = CGPointMake(self->previousFrame.origin.x + self->previousFrame.size.width + LABEL_SPACE, self->previousFrame.origin.y);
            }
        }
        label.x = newRect.origin.x;
        label.y = newRect.origin.y;
        self->previousFrame = label.frame;
    }];
}

// 设置label的边距、间隙
- (void)setTagLabelMargin:(UILabel*)lbl fontMargin:(CGFloat)fontMargin{
    [lbl sizeToFit];
    CGRect frame = lbl.frame;
    frame.size.width += fontMargin*2;
    frame.size.height = 15;
    lbl.frame = frame;
}
@end
