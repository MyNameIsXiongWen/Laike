//
//  AppMacro.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/4/26.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define kNavigationBarHeight 44
#define kTabbarHeight 49
#define kBangs (kScreenH > 736) //是否有刘海
#define kStatusBarHeight ((kBangs) ? 44 : 20)
#define kBottomDangerHeight ((kBangs) ? 34 : 0)
//顶部状态栏和导航栏的高度之和
#define kTopBarHeight (kStatusBarHeight + kNavigationBarHeight)
//底部菜单和安全区域的高度之和
#define kBottomBarHeight (kTabbarHeight + kBottomDangerHeight)


#define kFontTheme24 [UIFont systemFontOfSize:24]
#define kFontTheme22 [UIFont systemFontOfSize:22]
#define kFontTheme20 [UIFont systemFontOfSize:20]
#define kFontTheme18 [UIFont systemFontOfSize:18]
#define kFontTheme16 [UIFont systemFontOfSize:16]
#define kFontTheme15 [UIFont systemFontOfSize:15]
#define kFontTheme14 [UIFont systemFontOfSize:14]
#define kFontTheme13 [UIFont systemFontOfSize:13]
#define kFontTheme12 [UIFont systemFontOfSize:12]
#define kFontTheme11 [UIFont systemFontOfSize:11]
#define kFontTheme10 [UIFont systemFontOfSize:10]
#define kMediumFontTheme12 [UIFont systemFontOfSize:12 weight:UIFontWeightMedium]
#define kMediumFontTheme14 [UIFont systemFontOfSize:14 weight:UIFontWeightMedium]
#define kMediumFontTheme15 [UIFont systemFontOfSize:15 weight:UIFontWeightMedium]
#define kMediumFontTheme16 [UIFont systemFontOfSize:16 weight:UIFontWeightMedium]
#define kMediumFontTheme17 [UIFont systemFontOfSize:17 weight:UIFontWeightMedium]
#define kMediumFontTheme18 [UIFont systemFontOfSize:18 weight:UIFontWeightMedium]
#define kMediumFontTheme20 [UIFont systemFontOfSize:20 weight:UIFontWeightMedium]
#define kMediumFontTheme24 [UIFont systemFontOfSize:24 weight:UIFontWeightMedium]


#define kColorTheme000 kColorFromHexString(@"000000")
#define kColorTheme444 kColorFromHexString(@"444444")
#define kColorTheme666 kColorFromHexString(@"666666")
#define kColorTheme999 kColorFromHexString(@"999999")
#define kColorThemeeee kColorFromHexString(@"eeeeee")
#define kColorThemefff kColorFromHexString(@"ffffff")
#define kColorThemef5f5f5 kColorFromHexString(@"f5f5f5")
#define kColorThemee4e4e4 kColorFromHexString(@"e4e4e4")
#define kColorThemec8c8c8 kColorFromHexString(@"c8c8c8")
#define kColorTheme707070 kColorFromHexString(@"707070")
#define kColorTheme2a303c kColorFromHexString(@"2a303c")
#define kColorThemea4abb3 kColorFromHexString(@"a4abb3")
#define kColorThemefb4d56 kColorFromHexString(@"fb4d56")
#define kColorTheme5c98f8 kColorFromHexString(@"5c98f8")
#define kColorTheme9399a5 kColorFromHexString(@"9399a5")
#define kColorTheme6d7278 kColorFromHexString(@"6d7278")
#define kColorThemeed2530 kColorFromHexString(@"ed2530")
#define kColorTheme3cb584 kColorFromHexString(@"3cb584")
#define kColorTheme8a90a6 kColorFromHexString(@"8a90a6")
#define kColorTheme3cb584 kColorFromHexString(@"3cb584")
#define kColorThemef2a12f kColorFromHexString(@"f2a12f")
#define kColorTheme21a8ff kColorFromHexString(@"21a8ff")
#define kColorThemeff7919 kColorFromHexString(@"ff7919")


#define kTOKEN [[NSUserDefaults standardUserDefaults] objectForKey:@"ConstToken"]
#define kSHOPID [[NSUserDefaults standardUserDefaults] objectForKey:@"shopId"]

#define kPlaceHolderImage_Rectangle [UIImage imageNamed:@"rectangle_placeholder"]
#define kPlaceHolderImage_Square [UIImage imageNamed:@"square_placeholder"]
#define kPlaceHolderImage_Banner [UIImage imageNamed:@"default_noImage_scheme"]
#define kPlaceHolderImage_Avatar [UIImage imageNamed:@"AppIcon"]

#pragma mark ------------IM缓存路径-------------
#define TIMChat_Image_Path [NSHomeDirectory() stringByAppendingString:@"/Documents/com_qhw_data/image/"]
#define TIMChat_Video_Path [NSHomeDirectory() stringByAppendingString:@"/Documents/com_qhw_data/video/"]
#define TIMChat_Voice_Path [NSHomeDirectory() stringByAppendingString:@"/Documents/com_qhw_data/voice/"]
#define TIMChat_Location_Path [NSHomeDirectory() stringByAppendingString:@"/Documents/com_qhw_data/location/"]

#endif /* AppMacro_h */
