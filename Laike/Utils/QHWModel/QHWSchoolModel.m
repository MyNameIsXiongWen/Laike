//
//  QHWSchoolModel.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/28.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWSchoolModel.h"

@implementation QHWSchoolModel

- (NSString *)videoPath {
    if (!_videoPath) {
        if (self.filePathList.count > 0) {
            _videoPath = kFilePath(self.filePathList.firstObject[@"path"]);
        }
    }
    return _videoPath;
}

@end
