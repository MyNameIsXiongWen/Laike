//
//  QHWTagView.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/20.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWTagView : UIView

/**
 标签文本赋值

 @param arr 标签数组
 */
-(void)setTagWithTagArray:(NSArray*)arr;
@property (nonatomic,assign)CGFloat tagViewHeight;
@end

NS_ASSUME_NONNULL_END
