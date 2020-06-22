//
//  NSString+Category.m
//  beichoo_N_ios
//
//  Created by 陈健 on 2017/8/21.
//  Copyright © 2017年 陈健. All rights reserved.
//

#import "NSString+Category.h"
#import <CommonCrypto/CommonDigest.h>
#import <AVFoundation/AVFoundation.h>

@implementation NSString (Category)

- (NSString *)md5Str
{
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    return digest;
}

- (NSString*)sha1Str {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int) data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

- (NSString *)passwordEncrypt {
    NSString *password = [NSString stringWithFormat:@"%@%@",@"pony-b:",self];
    password = [password sha1Str];
    return password;
}

- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    CGSize resultSize = CGSizeZero;
    @try {
        if (self.length <= 0) {
            return resultSize;
        }
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        style.lineBreakMode = NSLineBreakByWordWrapping;
        resultSize = [self boundingRectWithSize:CGSizeMake(floor(size.width), floor(size.height))//用相对小的 width 去计算 height / 小 heigth 算 width
                                        options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                     attributes:@{NSFontAttributeName: font,
                                                  NSParagraphStyleAttributeName: style}
                                        context:nil].size;
        resultSize = CGSizeMake(floor(resultSize.width + 1), floor(resultSize.height + 1));//上面用的小 width（height） 来计算了，这里要 +1
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    return resultSize;
}

- (CGFloat)getHeightWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    return [self getSizeWithFont:font constrainedToSize:size].height;
}

- (CGFloat)getWidthWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    return [self getSizeWithFont:font constrainedToSize:size].width;
}
-(NSString *)getAleberNumber
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
    return [NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithInteger:[self integerValue]]]];
}
// 纯数字
- (BOOL)iSNumStr {
    if (self.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}
-(NSString *)bankNumberFormatter
{
    if (self.length == 0) {
        return @"";
    }
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.length; i++) {
        if (i % 4 == 0 && i != 0) {
            [array addObject:@" "];
        }else
        {
            [array addObject:[self substringWithRange:NSMakeRange(i, 1)]];
        }
    }
    return [array componentsJoinedByString:@""];
}
- (BOOL)isLegalMoneyInput
{
    if (self.length == 0) {
        return NO;
    }
    NSString *regex = @"^\\d+$|^\\d*\\.\\d+$/g";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}
// 纯数字
- (BOOL)iSNumStrExceptDot {
    if (self.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

//判断是否为整形
- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形
- (BOOL)isPureFloat{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
//判断是否是邮箱
- (BOOL)isEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}
//判断是否是手机号码
- (BOOL)isValidatePhone {
    if (self.length != 11) {
        return NO;
    } else {
        NSString *phone_NUM = @"^(13|14|15|16|17|18|19)[0-9]{9}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phone_NUM];
        BOOL isMatch = [pred evaluateWithObject:self];
        return isMatch;
    }
}
-(NSString *)getDoubleString
{
    return [NSString stringWithFormat:@"%.2f",self.doubleValue];
}
- (BOOL)isBankNo
{
    NSString *passwordRegex = @"^\\d{15,19}$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [passwordTest evaluateWithObject:self];
}
-(NSString *)getMoneyFormatter
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.00;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:self.doubleValue]];
    return formattedNumberString;
}
- (BOOL)checkPassword {
    NSString *passwordRegex = @"[A-Z0-9a-z]{6,16}";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [passwordTest evaluateWithObject:self];
}

- (BOOL)isGK {
    NSString *gkRegex = @"[A-Z0-9a-z-_]{3,32}";
    NSPredicate *gkTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", gkRegex];
    return [gkTest evaluateWithObject:self];
}
- (BOOL)isFileName {
    NSString *phoneRegex = @"[a-zA-Z0-9\\u4e00-\\u9fa5\\./_-]+$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}
- (BOOL)hasEmoji {
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

+ (NSString*)encodeString:(NSString*)unencodedString {
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                    (CFStringRef)unencodedString,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8));
    
    return encodedString;
}

//URLDEcode
+ (NSString *)decodeString:(NSString*)encodedString {
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,(__bridge CFStringRef)encodedString,CFSTR(""),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}
+ (NSString *)shortUrlString:(NSString *)longUrlString
{
    //待解决
    return longUrlString;
}
/**
 判断字符串是否为空
 
 */
+ (BOOL)isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        return YES;
        
    }
    return NO;
}
#pragma mark -- 处理json格式的字符串中的换行符、回车符
+ (NSString *)deleteSpecialCodeWithStr:(NSString *)str {
    NSString *string = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    return string;
}

//字符串去掉最后一个
+(NSString*)removeLastOneChar:(NSString*)origin
{
    NSString* cutted;
    if([origin length] > 0){
        cutted = [origin substringToIndex:([origin length]-1)];// 去掉最后一个","
    }else{
        cutted = origin;
    }
    return cutted;
}
+ (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString = @"";
    if (! jsonData){  NSLog(@"Got an error: %@", error);
    }else{
        jsonString = [[NSString alloc] initWithData:jsonData
                                           encoding:NSUTF8StringEncoding];
    }
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return jsonString;
}

- (id)convertToObject {
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return object;
}

///判断是否是网址
- (BOOL)isUrlString {
    
    NSString *emailRegex = @"[a-zA-z]+://.*";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
    
}

- (NSString *)formatterTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self substringToIndex:10].longLongValue];
    NSString *time = [formatter stringFromDate:date];
    return time;
}
+ (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    return [formatter stringFromDate:NSDate.date];
}
///string to pinyin
-(NSString *)transformToPinyin
{
    NSMutableString *pinyin = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return pinyin;
}

//判断是否全是空格
+ (BOOL)isEmpty:(NSString *)str {
    if (!str) {
        return true;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

- (void)getImageHeightWithWidth:(CGFloat)width Complete:(void (^)(CGFloat))complete {
    CGImageSourceRef sourceRef = CGImageSourceCreateWithURL((CFURLRef)[NSURL URLWithString:self], NULL);
    CFDictionaryRef dictiRef = CGImageSourceCopyPropertiesAtIndex(sourceRef, 0, NULL);
    NSDictionary *imgHeader = (__bridge NSDictionary *)dictiRef;
    CGFloat height;
    if ([imgHeader[@"PixelWidth"] floatValue] > 0) {
        height = width/[imgHeader[@"PixelWidth"] floatValue]*[imgHeader[@"PixelHeight"] floatValue];
    } else {
        height = width;
    }
    if (complete) {
        complete(height);
    }
    CFRelease(sourceRef);
    CFRelease(dictiRef);
}

+ (NSString *)formatterWithValue:(double)value {
    NSString *string = @"";
    if (value > 0) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.roundingMode = kCFNumberFormatterRoundFloor;
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.groupingSeparator = @"";
        NSNumber *number = [NSNumber numberWithDouble:value];
        string = [formatter stringFromNumber:number];
    }
    return string;
}

+ (NSString *)formatterWithMoneyValue:(double)value {
    NSString *string = @"";
    if (value > 0) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.roundingMode = kCFNumberFormatterRoundFloor;
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.groupingSeparator = @"";
        NSNumber *number = [NSNumber numberWithDouble:value/1000000];
        string = [formatter stringFromNumber:number];
    }
    return string;
}

- (NSString * )convertWeeks {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:self];
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comp = [gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];
    NSInteger weekDay = [comp weekday] - 1 ;
    NSString *str = [[NSString stringWithFormat:@"%ld",weekDay] getAleberNumber];
    if (weekDay == 0) {
        str = @"日";
    }
    return str;
}

-(CGFloat)getSpaceLabelHeightwithSpace:(CGFloat)lineSpace ParagraphSpace:(CGFloat)paragraphSpacing withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    /** 行高 */
    paraStyle.lineSpacing = lineSpace;
    paraStyle.paragraphSpacing = paragraphSpacing;
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    CGSize size = [self boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

+ (NSString *)dealWithNumber:(NSInteger)number{
    NSString *numberStr = kFormat(@"%ld", (long)number);
    if (number >= 10000 && number < 1000000) {
        numberStr = kFormat(@"%ld万+", (long)number/10000);
    } else if (number >= 1000000){
        numberStr = kFormat(@"%ld百万+", (long)number/1000000);
    }
    return numberStr;
}

+ (NSString *)dealWithNumberValue:(NSInteger)value{
    NSString *valueStr = @"";
    double dValue = [kFormat(@"%ld", (long)value) doubleValue];
    if (value > 10000) {
        double dealValue = dValue/10000;
        if (value%10000 == 0) {
            valueStr = kFormat(@"%@w+", [NSNumber numberWithDouble:dealValue]);
        } else {
            valueStr = kFormat(@"%@w+", [NSNumber numberWithDouble:[kFormat(@"%.1f", dealValue) doubleValue]]);
        }
    } else {
        valueStr = kFormat(@"%ld", (long)value);
    }
    return valueStr;
}

- (void)thumbnailImageForVideoWithComplete:(void (^)(UIImage *img))complete {
    if (self.length == 0) {
        return;
    }
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:kFilePath(self)] options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CFTimeInterval thumbnailImageTime = 0; // 第0秒的截图
    NSError *thumbnailImageGenerationError = nil;

    CGImageRef thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    if (thumbnailImageGenerationError) {
        NSString *vcName = NSStringFromClass(self.getCurrentMethodCallerVC.class);
        if ([vcName isEqualToString:@"CommunityDetailViewController"] || [vcName isEqualToString:@"MainBusinessDetailViewController"]) {
            [SVProgressHUD showInfoWithStatus:@"视频解析失败"];
        }
        complete(UIImage.new);
        return;
    }
    if (thumbnailImageRef) {
        complete([[UIImage alloc] initWithCGImage: thumbnailImageRef]);
    } else {
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    }
    CFRelease(thumbnailImageRef);
}

@end

