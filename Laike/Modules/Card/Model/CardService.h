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

@class CardModel;
@interface CardService : QHWBaseService

///1:访客  2:点赞  3:粉丝
@property (nonatomic, assign) NSInteger cardType;
@property (nonatomic, strong) QHWItemPageModel *itemPageModel;
@property (nonatomic, strong) CardModel *cardDetailModel;
@property (nonatomic, copy) NSString *userId;
- (void)getCardListDataRequestWithComplete:(void (^)(void))complete;
- (void)getCardDetailInfoRequestWithComplete:(void (^)(void))complete;

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
///访问页面次数
@property (nonatomic, assign) NSInteger browsePageCount;


@property (nonatomic, copy) NSString *modifyTime;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *coverPath;
@property (nonatomic, copy) NSString *businessId;
@property (nonatomic, copy) NSString *businessName;
@property (nonatomic, assign) NSInteger businessType;
@property (nonatomic, assign) CGFloat businessHeight;


@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *subjectId;
@property (nonatomic, assign) NSInteger subject;

@end

NS_ASSUME_NONNULL_END
