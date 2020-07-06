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

- (void)publishRequestWithContent:(NSString *)content Image:(NSArray *)array CoverImage:(NSString *)coverImg Completed:(void (^)(void))completed {
    [QHWHttpLoading showWithMaskTypeBlack];
    //fileType: 文件类型：1--视频；2-图片
    NSMutableDictionary *params = @{@"content": content,
                                    @"filePathList": array,
                                    @"industryId": @(self.industryId),
                                    @"coverPath": coverImg,
                                    @"fileType": @(self.fileType)}.mutableCopy;
    if (self.fileType == 1) {
        params[@"videoSatus"] = @"2";
    }
    [QHWHttpManager.sharedInstance QHW_POST:kCommunityAdd parameters:params success:^(id responseObject) {
        completed();
    } failure:^(NSError *error) {
        
    }];
}

- (void)uploadImageWithContent:(NSString *)content Completed:(void (^)(void))completed {
    if (self.fileType == 1 && self.imageArray.count == 1) {
        QHWImageModel *imgModel = self.imageArray.firstObject;
        dispatch_group_t group = dispatch_group_create();
        __block NSString *coverPath = @"";
        __block NSArray *imgArray = NSArray.array;
        dispatch_group_enter(group);
        [QHWSystemService.new uploadVideoWithURL:imgModel.URL Completed:^(NSMutableArray * _Nonnull pathArray) {
            dispatch_group_leave(group);
            imgArray = pathArray;
        }];
        dispatch_group_enter(group);
        [QHWSystemService.new uploadImageWithArray:@[imgModel] Completed:^(NSMutableArray * _Nonnull pathArray) {
            dispatch_group_leave(group);
            NSDictionary *dic = (NSDictionary *)pathArray.firstObject;
            coverPath = dic[@"path"];
        }];
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [self publishRequestWithContent:content Image:imgArray CoverImage:coverPath Completed:completed];
        });
    } else {
        [QHWSystemService.new uploadImageWithArray:self.imageArray Completed:^(NSMutableArray * _Nonnull pathArray) {
            NSDictionary *dic = (NSDictionary *)pathArray.firstObject;
            [self publishRequestWithContent:content Image:pathArray CoverImage:dic[@"path"] Completed:completed];
        }];
    }
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
