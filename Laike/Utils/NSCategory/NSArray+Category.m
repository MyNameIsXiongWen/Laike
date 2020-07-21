//
//  NSArray+Category.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/10/24.
//  Copyright © 2018年 xiaobu. All rights reserved.
//

#import "NSArray+Category.h"
//#import "MKImageModel.h"

@implementation NSArray (Category)

- (NSString *)toJSONString {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                     error:nil];
    
    if (data == nil) {
        return nil;
    }
    
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    return string;
}

- (NSString *)toReadableJSONString {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    if (data == nil) {
        return nil;
    }
    
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    return string;
}

- (NSData *)toJSONData {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    return data;
}

- (NSMutableArray *)convertToTitleArrayWithKeyName:(NSString *)keyName {
    NSMutableArray *titleArray = @[].mutableCopy;
    for (NSObject *model in self) {
        if ([model isKindOfClass:NSDictionary.class]) {
            NSDictionary *modelDic = (NSDictionary *)model;
            if ([modelDic.allKeys containsObject:keyName]) {
                [titleArray addObject:modelDic[keyName]];
            } else {
                [titleArray addObject:@""];
            }
        } else {
            if ([model containsProperty:keyName]) {
                [titleArray addObject:[model valueForKey:keyName]];
            } else {
                [titleArray addObject:@""];
            }
        }
    }
    return titleArray;
}

//- (void)uploadImageWithComplete:(void (^)(BOOL, NSMutableArray * _Nonnull))complete {
//    NSMutableArray *resultArray = NSMutableArray.array;
//    NSMutableArray *urlArray = NSMutableArray.array;
//    for (MKImageModel *model in self) {
//        if (model.imgUrl) {
//            [urlArray addObject:model.imgUrl];
//        } else {
//            [resultArray addObject:model.image];
//        }
//    }
//    if (resultArray.count > 0) {
//        [SVProgressHUD showWithStatus:@"上传图片中"];
//    } else {
//        complete(YES, urlArray);
//        return;
//    }
//    [HttpManager.sharedInstance UPLOAD:kMankuSystemAdmin(kSystemUploadFile) parameters:nil uploadParam:resultArray success:^(id responseObject) {
//        [SVProgressHUD show];
//        [urlArray addObjectsFromArray:responseObject[@"data"]];
//        complete(YES, urlArray);
//    } failure:^(NSError *error) {
//        complete(NO, NSMutableArray.array);
//    } progress:^(NSProgress *uploadProgress) {
//
//    }];
//}

@end
