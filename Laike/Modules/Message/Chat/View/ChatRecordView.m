//
//  ChatRecordView.m
//  UIKit
//
//  Created by kennethmiao on 2018/10/9.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "ChatRecordView.h"

@implementation ChatRecordView
- (id)init {
    self = [super init];
    if(self){
        [self setupViews];
        [self defaultLayout];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    
    _background = UIView.viewInit().bkgColor([UIColor colorWithWhite:0 alpha:0.6]).cornerRadius(5);
    [self addSubview:_background];
    
    _recordImage = UIImageView.ivInit().ivImage(kImageMake(@"record_1")).ivMode(UIViewContentModeCenter);
    _recordImage.alpha = 0.8;
    [_background addSubview:_recordImage];
    
    _title = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorThemefff).labelCornerRadius(5).labelTextAlignment(NSTextAlignmentCenter);
    [_background addSubview:_title];
}

- (void)defaultLayout {
    CGSize backSize = CGSizeMake(kScreenW * 0.4, kScreenW * 0.4);
    _title.text = @"手指上滑，取消发送";
    CGSize titleSize = [_title sizeThatFits:CGSizeMake(kScreenW, kScreenH)];
    if(titleSize.width > backSize.width){
        backSize.width = titleSize.width + 2 * 8;
    }

    _background.frame = CGRectMake((kScreenW - backSize.width) * 0.5, (kScreenH - backSize.height) * 0.5, backSize.width, backSize.height);
    CGFloat imageHeight = backSize.height - titleSize.height - 2 * 8;
    _recordImage.frame = CGRectMake(0, 0, backSize.width, imageHeight);
    CGFloat titley = _recordImage.frame.origin.y + imageHeight;
    _title.frame = CGRectMake(0, titley, backSize.width, backSize.height - titley);
}

- (void)setStatus:(RecordStatus)status {
    switch (status) {
        case Record_Status_Recording:
        {
            _title.text = @"手指上滑，取消发送";
            _title.backgroundColor = [UIColor clearColor];
            break;
        }
        case Record_Status_Cancel:
        {
            _title.text = @"松开手指，取消发送";
            _title.backgroundColor = kColorThemefb4d56;
            break;
        }
        case Record_Status_TooShort:
        {
            _title.text = @"说话时间太短";
            _title.backgroundColor = [UIColor clearColor];
            break;
        }
        case Record_Status_TooLong:
        {
            _title.text = @"说话时间太长";
            _title.backgroundColor = [UIColor clearColor];
            break;
        }
        default:
            break;
    }
}

- (void)setPower:(NSInteger)power {
    NSString *imageName = [self getRecordImage:power];
    _recordImage.image = kImageMake(imageName);
}

- (NSString *)getRecordImage:(NSInteger)power {
    // 关键代码
    power = power + 60;
    int index = 0;
    if (power < 25){
        index = 1;
    } else{
        index = ceil((power - 25) / 5.0) + 1;
    }
    
    return [NSString stringWithFormat:@"record_%d", index];
}




@end
