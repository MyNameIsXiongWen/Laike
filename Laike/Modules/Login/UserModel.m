//
//  UserModel.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/31.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "UserModel.h"
#import "CTMediator+ViewController.h"
#import "AppDelegate.h"
#import <HyphenateLite/HyphenateLite.h>
#import <CL_ShanYanSDK/CL_ShanYanSDK.h>

static UserModel *user = nil;
static dispatch_once_t onceToken;
@implementation UserModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"consultantList": QHWConsultantModel.class};
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(self.class, &outCount);
    for (i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char *char_name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_name];
        id propertyValue = [self valueForKey:propertyName];
        if (propertyValue) {
            [aCoder encodeObject:propertyValue forKey:propertyName];
        }
    }
    free(properties);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super init]) {
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList(self.class, &outCount);
        for (i=0; i<outCount; i++) {
            objc_property_t property = properties[i];
            const char *char_name = property_getName(property);
            NSString *propertyName = [NSString stringWithUTF8String:char_name];
            id propertyValue = [aDecoder decodeObjectForKey:propertyName];
            if (propertyValue) {
                [self setValue:propertyValue forKey:propertyName];
            }
        }
        free(properties);
    }
    return self;
}

+ (UserModel *)shareUser {
    if (!user.id) {
        user = [self keyUnarchiveUserModel];
    }
    if (@available(iOS 11.0, *)) {
        dispatch_once(&onceToken, ^{
            unsigned int outCount, i;
            objc_property_t *properties = class_copyPropertyList(self.class, &outCount);
            for (i=0; i<outCount; i++) {
                objc_property_t property = properties[i];
                const char *char_name = property_getName(property);
                NSString *propertyName = [NSString stringWithUTF8String:char_name];
                [user addObserver:user forKeyPath:propertyName options:NSKeyValueObservingOptionNew context:nil];
            }
            free(properties);
        });
    }
    return user;
}

- (void)keyArchiveUserModel {
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docPath.firstObject stringByAppendingPathComponent:@"user.lk"];
    BOOL success = [NSKeyedArchiver archiveRootObject:self toFile:path];
    NSLog(@"keyarchive=====%d",success);
}

+ (UserModel *)keyUnarchiveUserModel {
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docPath.firstObject stringByAppendingPathComponent:@"user.lk"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if ([data isKindOfClass:NSData.class]) {
        UserModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return model;
    } else {
        return UserModel.new;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [UserModel.shareUser keyArchiveUserModel];
}

+ (void)clearUser {
    if (@available(iOS 11.0, *)) {
        dispatch_once(&onceToken, ^{
            unsigned int outCount, i;
            objc_property_t *properties = class_copyPropertyList(self.class, &outCount);
            for (i=0; i<outCount; i++) {
                objc_property_t property = properties[i];
                const char *char_name = property_getName(property);
                NSString *propertyName = [NSString stringWithUTF8String:char_name];
                [user removeObserver:user forKeyPath:propertyName];
            }
            free(properties);
        });
    }
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docPath.firstObject stringByAppendingPathComponent:@"user.lk"];
    [NSFileManager.defaultManager removeItemAtPath:path error:nil];
    user = nil;
    onceToken = 0;
}

+ (void)logout {
    [kUserDefault removeObjectForKey:kConstToken];
    [UserModel clearUser];
    [EMClient.sharedClient logout:YES completion:^(EMError *aError) {
        
    }];
    [CLShanYanSDKManager initWithAppId:kSYAppId complete:^(CLCompleteResult * _Nonnull completeResult) {
        
    }];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = [CTMediator.sharedInstance CTMediator_viewControllerForLogin];
}

- (void)hxLogin {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *account = self.id;
        NSString *pwd1 = account.uppercaseString.md5Str;
        NSString *pwd2 = pwd1.uppercaseString.md5Str;
        [EMClient.sharedClient loginWithUsername:account password:pwd2 completion:^(NSString *aUsername, EMError *aError) {
            if (!aError) {
                [NSNotificationCenter.defaultCenter postNotificationName:kNotificationHXLoginSuccess object:nil];
                NSLog(@"登录成功");
            } else {
                NSLog(@"登录失败的原因---%@", aError.errorDescription);
            }
        }];
    });
}

- (NSString *)genderStr {
    switch (self.gender) {
        case 1:
            return @"男";
            break;
            
        case 2:
            return @"女";
            break;
            
        default:
            return @"未设置";
            break;
    }
}

- (NSString *)marriageStr {
    switch (self.marriageStatus) {
        case 1:
            return @"未婚";
            break;
        case 2:
            return @"已婚";
        break;
        
        case 3:
            return @"丧偶";
        break;
        
        case 4:
            return @"离异";
        break;
            
        default:
            return @"未设置";
            break;
    }
}

@end
