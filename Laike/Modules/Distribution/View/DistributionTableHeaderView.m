//
//  DistributionTableHeaderView.m
//  Laike
//
//  Created by xiaobu on 2020/9/27.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "DistributionTableHeaderView.h"

@implementation DistributionTableHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.searchBkgView];
        [self addSubview:self.topOperationView];
        [self addSubview:self.brandView];
    }
    return self;
}
- (SearchBkgView *)searchBkgView {
    if (!_searchBkgView) {
        _searchBkgView = [[SearchBkgView alloc] initWithFrame:CGRectMake(0, 10, kScreenW, 32)];
        _searchBkgView.placeholderLabel.text = @"输入产品名称";
        WEAKSELF
        _searchBkgView.clickSearchBkgBlock = ^{
            [weakSelf.getCurrentMethodCallerVC.navigationController pushViewController:NSClassFromString(@"DistributionSearchViewController").new animated:YES];
        };
    }
    return _searchBkgView;
}

- (CRMTopOperationView *)topOperationView {
    if (!_topOperationView) {
        _topOperationView = [[CRMTopOperationView alloc] initWithFrame:CGRectMake(0, self.searchBkgView.bottom+15, kScreenW, 70)];
        _topOperationView.dataArray = @[[TopOperationModel initialWithLogo:@"distribution_clientProcess"
                                                                     Title:@"客户进度"
                                                                  SubTitle:@"实时进度 全程跟踪"
                                                                Identifier:@"customerProcess"],
                                        [TopOperationModel initialWithLogo:@"distribution_bookAppointment"
                                                                     Title:@"报备客户"
                                                                  SubTitle:@"客户盘活 高佣结算"
                                                                Identifier:@"bookAppointment"]
        ];
    }
    return _topOperationView;
}

- (BrandView *)brandView {
    if (!_brandView) {
        _brandView = [[BrandView alloc] initWithFrame:CGRectMake(0, self.topOperationView.bottom, kScreenW, 110)];
        _brandView.dataArray = @[@"", @"", @""];
    }
    return _brandView;
}

@end
