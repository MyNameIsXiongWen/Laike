//
//  CommunityPublishService.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/21.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CommunityPublishService.h"
#import "QHWSystemService.h"
#import "UserModel.h"
#import "CTMediator+Publish.h"

@implementation CommunityPublishService

- (void)publishRequestWithContent:(NSString *)content Image:(NSArray *)array Completed:(void (^)(void))completed {
    [QHWHttpLoading showWithMaskTypeBlack];
    //fileType: 文件类型：1--视频；2-图片
    [QHWHttpManager.sharedInstance QHW_POST:kCommunityAdd parameters:@{@"content": content,
                                                                           @"filePathList": array,
                                                                           @"industryId": @(self.industryId),
                                                                           @"fileType": @"2"} success:^(id responseObject) {
        completed();
    } failure:^(NSError *error) {
        
    }];
}

- (void)uploadImageWithContent:(NSString *)content Completed:(void (^)(void))completed {
    [QHWSystemService.new uploadImageWithArray:self.imageArray Completed:^(NSMutableArray * _Nonnull pathArray) {
        [self publishRequestWithContent:content Image:pathArray Completed:completed];
    }];
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = NSArray.array;
    }
    return _dataSource;
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = NSMutableArray.array;
    }
    return _imageArray;
}

- (NSArray *)industryArray {
    if (!_industryArray) {
        _industryArray = @[@"房产", @"游学", @"移民", @"留学", @"医疗"];
    }
    return _industryArray;
}

@end
