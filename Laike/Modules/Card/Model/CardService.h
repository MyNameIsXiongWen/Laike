//
//  CardService.h
//  Laike
//
//  Created by xiaobu on 2020/6/27.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWBaseService.h"
#import "QHWItemPageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardService : QHWBaseService

///1:访客  2:点赞  3:粉丝
@property (nonatomic, assign) NSInteger cardType;
@property (nonatomic, strong) QHWItemPageModel *itemPageModel;
- (void)getCardDataRequestWithComplete:(void (^)(void))complete;

@end

@interface CardModel : NSObject

@property (nonatomic, assign) NSInteger cardType;

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *nickname;
///头像路径,七牛云
@property (nonatomic, copy) NSString *headPath;
@property (nonatomic, copy) NSString *lastTime;
///浏览数量
@property (nonatomic, assign) NSInteger browseCount;


@property (nonatomic, copy) NSString *modifyTime;
@property (nonatomic, copy) NSString *coverPath;
@property (nonatomic, copy) NSString *businessId;
@property (nonatomic, assign) NSInteger businessType;


@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *subjectId;
@property (nonatomic, assign) NSInteger subject;

@end

NS_ASSUME_NONNULL_END
