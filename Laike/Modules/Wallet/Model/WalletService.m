//
//  WalletService.m
//  Laike
//
//  Created by xiaobu on 2020/11/5.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "WalletService.h"
#import "UserModel.h"
#import "SigninView.h"

@interface WalletService ()

@property (nonatomic, strong) SigninView *signinView;

@end

@implementation WalletService

- (void)getWalletInfoRequestWithComplete:(void (^)(NSDictionary * _Nullable))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kWalletInfo parameters:@{} success:^(id responseObject) {
        UserModel.shareUser.walletInfo = responseObject[@"data"];
        UserModel.shareUser.checkStatus = [responseObject[@"data"][@"checkStatus"] integerValue];
        complete(responseObject[@"data"]);
        
        
        NSInteger status = [responseObject[@"data"][@"checkStatus"] integerValue];//签到状态：1-未签到；2-已签到
        if (status == 1) {
            if (![NSString.getCurrentTime isEqualToString:[kUserDefault objectForKey:@"SignIn"]]) {
                self.signinView = [[SigninView alloc] initWithFrame:CGRectMake(40, (kScreenH-370)/2, kScreenW-80, 370)];
                WEAKSELF
                self.signinView.clickSigninBlock = ^{
                    [weakSelf.signinView dismiss];
                    [weakSelf signinRequestWithComplete:^{
                        
                    }];
                };
                [self.signinView show];
                [kUserDefault setObject:NSString.getCurrentTime forKey:@"SignIn"];
            }
        }
    } failure:^(NSError *error) {
        complete(nil);
    }];
}

- (void)getWalletListRequestWithComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    NSDictionary *params = @{@"currentPage": @(self.itemPageModel.pagination.currentPage),
                             @"pageSize": @(self.itemPageModel.pagination.pageSize)};
    [QHWHttpManager.sharedInstance QHW_POST:kWalletList parameters:params success:^(id responseObject) {
        self.itemPageModel = [QHWItemPageModel yy_modelWithJSON:responseObject[@"data"]];
        if (self.itemPageModel.pagination.currentPage == 1) {
            [self.tableViewDataArray removeAllObjects];
        }
        [self.tableViewDataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:WalletModel.class json:self.itemPageModel.list]];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)withdrawRequestWithMoney:(NSString *)money Complete:(void (^)(NSInteger))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    NSDictionary *params = @{@"transactionMoney": @(money.floatValue * 100)}; //单位：分
    [QHWHttpManager.sharedInstance QHW_POST:kWalletWithdraw parameters:params success:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            [SVProgressHUD showInfoWithStatus:@"提现成功"];
            complete(200);
        } else {
            complete([responseObject[@"code"] integerValue]);
            [SVProgressHUD showInfoWithStatus:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        complete(0);
    }];
}

- (void)bindAlipayRequestWithAccount:(NSString *)account Name:(NSString *)name Complete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    NSDictionary *params = @{@"account": account ?: @"",
                             @"name": name ?: @""};
    [QHWHttpManager.sharedInstance QHW_POST:kWalletBindAlipay parameters:params success:^(id responseObject) {
        [SVProgressHUD showInfoWithStatus:@"绑定成功"];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (void)signinRequestWithComplete:(void (^)(void))complete {
    [QHWHttpLoading showWithMaskTypeBlack];
    [QHWHttpManager.sharedInstance QHW_POST:kUserSignin parameters:@{} success:^(id responseObject) {
        [SVProgressHUD showInfoWithStatus:@"签到成功"];
        complete();
    } failure:^(NSError *error) {
        complete();
    }];
}

- (QHWItemPageModel *)itemPageModel {
    if (!_itemPageModel) {
        _itemPageModel = QHWItemPageModel.new;
    }
    return _itemPageModel;
}

@end
