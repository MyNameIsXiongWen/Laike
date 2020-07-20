//
//  QHWCommunityArticleModel.h
//  GoOverSeas
//  海外头条Model
//  Created by xiaobu on 2020/5/16.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWCommunityArticleModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *merchantId;
@property (nonatomic, copy) NSString *merchantName;
@property (nonatomic, copy) NSString *merchantHead;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *articleDescribe;
@property (nonatomic, copy) NSString *coverPath;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *Html2Text;
@property (nonatomic, strong) NSArray *coverPathList;

@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
