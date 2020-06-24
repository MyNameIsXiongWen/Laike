//
//  CRMTopOperationView.m
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CRMTopOperationView.h"

@interface CRMTopOperationView ()

@property (nonatomic, strong) OperationCollectionSubView *leftOperationView;
@property (nonatomic, strong) OperationCollectionSubView *rightOperationView;

@end

@implementation CRMTopOperationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.leftOperationView = [[OperationCollectionSubView alloc] initWithFrame:CGRectMake(0, 0, self.width/2, 70)];
        [self addSubview:self.leftOperationView];
        
        self.rightOperationView = [[OperationCollectionSubView alloc] initWithFrame:CGRectMake(self.leftOperationView.right, 0, self.leftOperationView.width, 70)];
        [self addSubview:self.rightOperationView];
        
        [self addSubview:UIView.viewFrame(CGRectMake(self.leftOperationView.right, 10, 0.5, 50)).bkgColor(kColorThemeeee)];
        
        self.cornerRadius(10).bkgColor(kColorThemef5f5f5);
//        [self addShadowWithRadius:10 Opacity:0.2];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    NSDictionary *leftDic = dataArray.firstObject;
    NSDictionary *rightDic = dataArray.lastObject;
    
    self.leftOperationView.logoImgView.image = kImageMake(leftDic[@"logo"]);
    self.leftOperationView.titleLabel.text = leftDic[@"title"];
    self.leftOperationView.subTitleLabel.text = leftDic[@"subTitle"];
    
    self.rightOperationView.logoImgView.image = kImageMake(rightDic[@"logo"]);
    self.rightOperationView.titleLabel.text = rightDic[@"title"];
    self.rightOperationView.subTitleLabel.text = rightDic[@"subTitle"];
}

@end

@implementation OperationCollectionSubView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
//        self.backgroundColor = kColorThemefff;
        self.logoImgView = UIImageView.ivFrame(CGRectMake(15, 15, 40, 40)).ivCornerRadius(20);
        [self addSubview:self.logoImgView];
        
        self.titleLabel = UILabel.labelFrame(CGRectMake(self.logoImgView.right+10, 15, self.width-65, 25)).labelTitleColor(kColorTheme2a303c).labelFont(kFontTheme18);
        [self addSubview:self.titleLabel];
        
        self.subTitleLabel = UILabel.labelFrame(CGRectMake(self.logoImgView.right+10, self.titleLabel.bottom, self.width-65, 15)).labelTitleColor(kColorTheme707070).labelFont(kFontTheme10);
        [self addSubview:self.subTitleLabel];
    }
    return self;
}

@end
