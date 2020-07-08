//
//  CRMTopOperationView.m
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CRMTopOperationView.h"
#import "CTMediator.h"

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
    self.leftOperationView.dataDic = leftDic;
    self.rightOperationView.dataDic = rightDic;
}

@end

#import "QHWShareView.h"
#import "UserModel.h"

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

        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelfView)]];
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.logoImgView.image = kImageMake(dataDic[@"logo"]);
    self.titleLabel.text = dataDic[@"title"];
    self.subTitleLabel.text = dataDic[@"subTitle"];
}

- (void)tapSelfView {
    NSString *identifier = self.dataDic[@"identifier"];
    [CTMediator.sharedInstance performTarget:self action:kFormat(@"click_%@", identifier) params:nil];
}

- (void)click_communityArticle {
    [self.getCurrentMethodCallerVC.navigationController pushViewController:NSClassFromString(@"CommunityArticleViewController").new animated:YES];
}

- (void)click_shareArticle {
    [self.getCurrentMethodCallerVC.navigationController pushViewController:NSClassFromString(@"CommunityPublishViewController").new animated:YES];
}

- (void)click_sendCard {
    QHWShareView *shareView = [[QHWShareView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 220) dict:@{@"detailModel":UserModel.shareUser, @"shareType": @(ShareTypeConsultant)}];
    [shareView show];
}

- (void)click_customerProcess {
    [self.getCurrentMethodCallerVC.navigationController pushViewController:NSClassFromString(@"DistributionClientViewController").new animated:YES];
}

- (void)click_bookAppointment {
    [self.getCurrentMethodCallerVC.navigationController pushViewController:NSClassFromString(@"BookAppointmentViewController").new animated:YES];
}

@end
