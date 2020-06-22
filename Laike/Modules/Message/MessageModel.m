//
//  MessageModel.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/3.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"from": MessageUserModel.class,
             @"create": MessageUserModel.class
    };
}

- (NSString *)typeName {
    if (!_typeName) {
        switch (self.type) {
            case 101000:
                _typeName = @"系统通知";
                break;
                
            case 101001:
            case 101002:
            case 101003:
                _typeName = @"提到我的";
                break;
            
            case 102001:
                _typeName = @"评论我的";
                break;
                
            case 103001:
            case 103002:
            case 103003:
            case 103004:
            case 103005:
                _typeName = @"赞我的";
                break;
                
            case 104001:
                _typeName = @"关注我的";
                break;
            
            case 105001:
            case 105002:
            case 105003:
            case 105004:
            case 105005:
                _typeName = @"分享我的";
                break;
                
            default:
                break;
        }
    }
    return _typeName;
}

@end

@implementation MessageUserModel

@end
