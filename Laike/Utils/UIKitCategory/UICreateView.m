//
//  UICreateView.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/10.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "UICreateView.h"
#import "QHWBaseTableView.h"

@implementation UICreateView

+ (UIView *)initWithFrame:(CGRect)rect
          BackgroundColor:(UIColor *)backgroundColor
             CornerRadius:(CGFloat)radius {
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = backgroundColor;
    if (radius > 0) {
        view.layer.cornerRadius = radius;
        view.layer.masksToBounds = YES;
    }
    return view;
}

+ (UILabel *)initWithFrame:(CGRect)rect
                      Text:(NSString *)text
                      Font:(UIFont *)font
                 TextColor:(UIColor *)textColor
           BackgroundColor:(UIColor *)backgroundColor {
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    label.backgroundColor = backgroundColor;
    label.lineBreakMode = NSLineBreakByClipping;
    return label;
}

+ (UIButton *)initWithFrame:(CGRect)rect
                      Title:(NSString *)title
                      Image:(nullable UIImage *)image
              SelectedImage:(nullable UIImage *)selectedImage
                       Font:(nullable UIFont *)font
                 TitleColor:(nullable UIColor *)titleColor
            BackgroundColor:(nullable UIColor *)backgroundColor
               CornerRadius:(CGFloat)radius {
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    if (image) {
        [btn setImage:image forState:UIControlStateNormal];
    }
    if (selectedImage) {
        [btn setImage:selectedImage forState:UIControlStateSelected];
    }
    btn.titleLabel.font = font;
    btn.backgroundColor = backgroundColor;
    if (radius > 0) {
        btn.layer.cornerRadius = radius;
        btn.layer.masksToBounds = YES;
    }
    return btn;
}

+ (UITextField *)initWithFrame:(CGRect)rect
                          Text:(NSString *)text
                   Placeholder:(NSString *)placeholder
                          Font:(UIFont *)font
                     TextColor:(UIColor *)textColor
                   BorderColor:(nullable UIColor *)borderColor
                  CornerRadius:(CGFloat)radius {
    UITextField *textfield = [[UITextField alloc] initWithFrame:rect];
    textfield.text = text;
    textfield.placeholder = placeholder;
    textfield.font = font;
    textfield.textColor = textColor;
    if (borderColor) {
        textfield.layer.borderColor = borderColor.CGColor;
        textfield.layer.borderWidth = 0.5;
    }
    if (radius > 0) {
        textfield.layer.cornerRadius = radius;
        textfield.layer.masksToBounds = YES;
    }
    return textfield;
}

+ (UITextView *)initWithFrame:(CGRect)rect
                         Text:(NSString *)text
                  Placeholder:(NSString *)placeholder
                         Font:(UIFont *)font
                    TextColor:(UIColor *)textColor {
    UITextView *textView = [[UITextView alloc] initWithFrame:rect];
    textView.text = text;
    textView.font = font;
    textView.textColor = textColor;
    
    UILabel *label = [self initWithFrame:CGRectMake(5, 9, 200, 16) Text:placeholder Font:font TextColor:kColorFromHexString(@"bfbfbf") BackgroundColor:UIColor.clearColor];
    [label sizeToFit];
    [textView addSubview:label];
    [textView setValue:label forKey:@"_placeholderLabel"];
    return textView;
}

+ (UIImageView *)initWithFrame:(CGRect)rect
                      ImageUrl:(NSString *)imageUrl
                         Image:(UIImage *)image
                   ContentMode:(UIViewContentMode)mode {
    UIImageView *img = [[UIImageView alloc] initWithFrame:rect];
    [img sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:image];
    if (mode) {
        img.contentMode = mode;
    }
    img.layer.masksToBounds = YES;
    return img;
}

+ (UITableView *)initWithFrame:(CGRect)rect Style:(UITableViewStyle)style Object:(id)object {
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:style];
    tableView.backgroundColor = UIColor.whiteColor;
    tableView.delegate = object;
    tableView.dataSource = object;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    return tableView;
}

+ (UITableView *)initWithRecognizeSimultaneouslyFrame:(CGRect)rect Style:(UITableViewStyle)style Object:(id)object {
    UITableView *tableView = [[QHWBaseTableView alloc] initWithFrame:rect style:style];
    tableView.backgroundColor = UIColor.whiteColor;
    tableView.delegate = object;
    tableView.dataSource = object;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    return tableView;
}

+ (UICollectionView *)initWithFrame:(CGRect)rect Layout:(UICollectionViewFlowLayout *)layout Object:(id)object {
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    collectionView.backgroundColor = UIColor.whiteColor;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = object;
    collectionView.dataSource = object;
    return collectionView;
}

@end
