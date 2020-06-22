//
//  UICreateView.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/10.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICreateView : NSObject

/**
 创建view
 
 @param rect view大小
 @param backgroundColor view背景色
 @return view
 */
+ (UIView *)initWithFrame:(CGRect)rect
          BackgroundColor:(UIColor *)backgroundColor
             CornerRadius:(CGFloat)radius;

/**
 创建UILabel
 
 @param rect frame
 @param text text
 @param font font
 @param textColor textcolor
 @return label
 */
+ (UILabel *)initWithFrame:(CGRect)rect
                      Text:(NSString *)text
                      Font:(UIFont *)font
                 TextColor:(UIColor *)textColor
           BackgroundColor:(UIColor *)backgroundColor;

/**
 创建Button
 
 @param rect rect
 @param title title
 @param image image
 @param selectedImage selectedImage
 @param font font
 @param titleColor titleColor
 @return btn
 */
+ (UIButton *)initWithFrame:(CGRect)rect
                      Title:(NSString *)title
                      Image:(nullable UIImage *)image
              SelectedImage:(nullable UIImage *)selectedImage
                       Font:(nullable UIFont *)font
                 TitleColor:(nullable UIColor *)titleColor
            BackgroundColor:(nullable UIColor *)backgroundColor
               CornerRadius:(CGFloat)radius;


/**
 创建UITextField

 @param rect frame
 @param text text
 @param placeholder placeholder
 @param font font
 @param textColor textColor
 @param borderColor borderColor
 @param radius radius
 @return textField
 */
+ (UITextField *)initWithFrame:(CGRect)rect
                          Text:(NSString *)text
                   Placeholder:(NSString *)placeholder
                          Font:(UIFont *)font
                     TextColor:(UIColor *)textColor
                   BorderColor:(nullable UIColor *)borderColor
                  CornerRadius:(CGFloat)radius;

/**
 创建textView
 
 @param rect 大小
 @param text 内容
 @param placeholder 默认内容
 @param font 字体大小
 @param textColor 字体颜色
 @return textView
 */
+ (UITextView *)initWithFrame:(CGRect)rect
                         Text:(NSString *)text
                  Placeholder:(NSString *)placeholder
                         Font:(UIFont *)font
                    TextColor:(UIColor *)textColor;

/**
 创建UIImageView
 
 @param rect 图片大小
 @param imageUrl 图片地址
 @param image 默认图片
 @param mode 显示类型
 @return 图片视图
 */
+ (UIImageView *)initWithFrame:(CGRect)rect
                      ImageUrl:(NSString *)imageUrl
                         Image:(UIImage *)image
                   ContentMode:(UIViewContentMode)mode;

#pragma mark ------------以上初始化方法后面都改用链式语法-------------

/**
 创建UITableView

 @param rect frame
 @param style style
 @param object object
 @return tableview
 */
+ (UITableView *)initWithFrame:(CGRect)rect
                         Style:(UITableViewStyle)style
                        Object:(id)object;

/**
 创建UITableView 识别多个手势的

 @param rect frame
 @param style style
 @param object object
 @return tableview
 */
+ (UITableView *)initWithRecognizeSimultaneouslyFrame:(CGRect)rect
                                                Style:(UITableViewStyle)style
                                               Object:(id)object;


/**
 UICollectionView

 @param rect fame
 @param layout layout
 @param object object
 @return CollectionView
 */
+ (UICollectionView *)initWithFrame:(CGRect)rect
                             Layout:(UICollectionViewFlowLayout *)layout
                             Object:(id)object;

@end

NS_ASSUME_NONNULL_END
