//
//  QHWVideoPlayerView.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWVideoPlayerView.h"
#import <WebKit/WebKit.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define VIDEO_FILEPATH                                              @"video"
@interface QHWVideoPlayerView () <NSURLSessionDelegate, AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) AVAssetWriter *assetWriter;
@property (nonatomic, strong) NSDictionary *audioCompressionSettings;
@property (nonatomic, strong) NSDictionary *videoCompressionSettings;
@property (nonatomic, strong) AVAssetWriterInput *assetWriterVideoInput;
@property (nonatomic, strong) AVAssetWriterInput *assetWriterAudioInput;
@property (strong, nonatomic) NSURL *videoURL;

@end

@implementation QHWVideoPlayerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setVideoPath:(NSString *)videoPath {
    _videoPath = videoPath;
    AVPlayer *player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:kFilePath(videoPath)]];
    self.playerVC = [[AVPlayerViewController alloc] init];
    self.playerVC.player = player;
    self.playerVC.view.frame = self.bounds;
    self.playerVC.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self addSubview:self.playerVC.view];
//    [self startDownLoadVedioWithModel:videoPath];
}

- (void)startDownLoadVedioWithModel:(NSString *)videoPath {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    self.downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:videoPath]];
    [self.downloadTask resume];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    //下载进度
    CGFloat progress = totalBytesWritten / (double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%.2f%%",progress*100]];
        
    });
}
    //下载完成
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    //1.拿到cache文件夹的路径
    NSString *cache=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    //2,拿到cache文件夹和文件名
    NSString *file=[cache stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:file] error:nil];
    
//    AVPlayer *player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:kFilePath(file)]];
//    self.playerVC = [[AVPlayerViewController alloc] init];
//    self.playerVC.player = player;
//    self.playerVC.view.frame = self.bounds;
//    [self addSubview:self.playerVC.view];
        
    self.videoURL = [NSURL URLWithString:[self createVideoFilePath]];
    self.assetWriter = [AVAssetWriter assetWriterWithURL:self.videoURL fileType:AVFileTypeMPEG4 error:nil];
    //写入视频大小
    NSInteger numPixels = self.width * self.height;
    //每像素比特
    CGFloat bitPerPixels = 6.0;
    NSInteger bitsPerSecond = numPixels * bitPerPixels;
    // 码率和帧率设置
    NSDictionary *compressionProperties = @{AVVideoAverageBitRateKey: @(bitsPerSecond),
                                            AVVideoExpectedSourceFrameRateKey: @(15),
                                            AVVideoMaxKeyFrameIntervalKey: @(15),
                                            AVVideoProfileLevelKey: AVVideoProfileLevelH264BaselineAutoLevel};
    
    //视频属性
    self.videoCompressionSettings = @{AVVideoCodecKey: AVVideoCodecH264,
                                      AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill,
                                      AVVideoWidthKey: @(self.width * 2),
                                      AVVideoHeightKey: @(self.height * 2),
                                      AVVideoCompressionPropertiesKey: compressionProperties};
    
    self.assetWriterVideoInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeVideo outputSettings:self.videoCompressionSettings];
    self.assetWriterVideoInput.expectsMediaDataInRealTime = YES;
    self.assetWriterVideoInput.transform = CGAffineTransformMakeRotation(M_PI/2.0);
    
    self.audioCompressionSettings = @{AVEncoderBitRatePerChannelKey: @(28000),
                                      AVFormatIDKey: @(kAudioStreamAnyRate),
                                      AVNumberOfChannelsKey: @(1),
                                      AVSampleRateKey: @(22050)};
    
    self.assetWriterAudioInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeAudio outputSettings:self.audioCompressionSettings];
    self.assetWriterAudioInput.expectsMediaDataInRealTime = YES;
    
    if ([self.assetWriter canAddInput:self.assetWriterVideoInput]) {
        [self.assetWriter addInput:self.assetWriterVideoInput];
    } else {
        NSLog(@"AssetWriter videoInput append Failed");
    }
    if ([self.assetWriter canAddInput:self.assetWriterAudioInput]) {
        [self.assetWriter addInput:self.assetWriterAudioInput];
    } else {
        NSLog(@"AssetWriter audioInput append Failed");
    }
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if ([output connectionWithMediaType:AVMediaTypeVideo] == connection) {
        [self.assetWriter startWriting];
        [self.assetWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
        
        //写入视频数据
        if (self.assetWriterVideoInput.readyForMoreMediaData)
        {
            BOOL success = [self.assetWriterVideoInput appendSampleBuffer:sampleBuffer];
            if (!success)
            {
                @synchronized (self)
                {
//                    [self stopVideoRecorder];
                    [self saveVideoWithVideoUrl:self.videoURL andAssetCollectionName:nil withCompletion:^(NSURL *vedioUrl, NSError *error) {
                        
                        AVPlayer *player = [[AVPlayer alloc] initWithURL:vedioUrl];
                        self.playerVC = [[AVPlayerViewController alloc] init];
                        self.playerVC.player = player;
                        self.playerVC.view.frame = self.bounds;
                        [self addSubview:self.playerVC.view];
                        
                        [[NSFileManager defaultManager] removeItemAtURL:self.videoURL error:nil];
                        self.videoURL = nil;
                    }];
                }
            }
        }
    }
}

/**
 *  保存视频
 *
 *  @param videoUrl             视频地址
 *  @param assetCollectionName  相册名字，不填默认为app名字+视频
 */
- (void)saveVideoWithVideoUrl:(NSURL *)videoUrl andAssetCollectionName:(NSString *)assetCollectionName withCompletion:(void(^)(NSURL *vedioUrl, NSError *error))saveVideoCompletionBlock
{
    if (assetCollectionName == nil)
    {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        
        assetCollectionName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        
        if (assetCollectionName == nil)
        {
            assetCollectionName = @"视频相册";
        }
    }
    
    __block NSString *blockAssetCollectionName = assetCollectionName;
    __block NSURL *blockVideoUrl = videoUrl;
    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        NSError *error = nil;
        __block NSString *assetId = nil;
        __block NSString *assetCollectionId = nil;
        
        // 保存视频到【Camera Roll】(相机胶卷)
        [library performChangesAndWait:^{
            
            assetId = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:blockVideoUrl].placeholderForCreatedAsset.localIdentifier;
            
        } error:&error];
        
        NSLog(@"error1: %@", error);
        
        // 获取曾经创建过的自定义视频相册名字
        PHAssetCollection *createdAssetCollection = nil;
        PHFetchResult <PHAssetCollection*> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        for (PHAssetCollection *assetCollection in assetCollections)
        {
            if ([assetCollection.localizedTitle isEqualToString:blockAssetCollectionName])
            {
                createdAssetCollection = assetCollection;
                break;
            }
        }
        
        //如果这个自定义框架没有创建过
        if (createdAssetCollection == nil)
        {
            //创建新的[自定义的 Album](相簿\相册)
            [library performChangesAndWait:^{
                
                assetCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:blockAssetCollectionName].placeholderForCreatedAssetCollection.localIdentifier;
                
            } error:&error];
            
            NSLog(@"error2: %@", error);
            
            //抓取刚创建完的视频相册对象
            createdAssetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionId] options:nil].firstObject;
            
        }
        
        // 将【Camera Roll】(相机胶卷)的视频 添加到【自定义Album】(相簿\相册)中
        [library performChangesAndWait:^{
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdAssetCollection];
            
            [request addAssets:[PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil]];
            
        } error:&error];
        NSLog(@"error3: %@", error);
        
        // 提示信息
        if (saveVideoCompletionBlock)
        {
            if (error)
            {
                NSLog(@"保存视频失败!");
                
                saveVideoCompletionBlock(nil, error);
            }
            else
            {
                NSLog(@"保存视频成功!");
                
                saveVideoCompletionBlock(blockVideoUrl, nil);
            }
        }
        
    });
}

- (NSString *)createVideoFilePath
{
    // 创建视频文件的存储路径
    NSString *filePath = [self createVideoFolderPath];
    if (filePath == nil)
    {
        return nil;
    }
    
    NSString *videoType = @".mp4";
    NSString *videoDestDateString = [self createFileNamePrefix];
    NSString *videoFileName = [videoDestDateString stringByAppendingString:videoType];
    
    NSUInteger idx = 1;
    /*We only allow 10000 same file name*/
    NSString *finalPath = [NSString stringWithFormat:@"%@/%@", filePath, videoFileName];
    
    while (idx % 10000 && [[NSFileManager defaultManager] fileExistsAtPath:finalPath])
    {
        finalPath = [NSString stringWithFormat:@"%@/%@_(%lu)%@", filePath, videoDestDateString, (unsigned long)idx++, videoType];
    }
    
    return finalPath;
}

- (NSString *)createVideoFolderPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *homePath = NSHomeDirectory();
    
    NSString *tmpFilePath;
    
    if (homePath.length > 0)
    {
        NSString *documentPath = [homePath stringByAppendingString:@"/Documents"];
        if ([fileManager fileExistsAtPath:documentPath isDirectory:NULL] == YES)
        {
            BOOL success = NO;
            
            NSArray *paths = [fileManager contentsOfDirectoryAtPath:documentPath error:nil];
            
            //offline file folder
            tmpFilePath = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@", VIDEO_FILEPATH]];
            if ([paths containsObject:VIDEO_FILEPATH] == NO)
            {
                success = [fileManager createDirectoryAtPath:tmpFilePath withIntermediateDirectories:YES attributes:nil error:nil];
                if (!success)
                {
                    tmpFilePath = nil;
                }
            }
            return tmpFilePath;
        }
    }
    
    return false;
}

/**
 *  创建文件名
 */
- (NSString *)createFileNamePrefix
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    
    NSString *destDateString = [dateFormatter stringFromDate:[NSDate date]];
    destDateString = [destDateString stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    destDateString = [destDateString stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    destDateString = [destDateString stringByReplacingOccurrencesOfString:@":" withString:@"-"];
    
    return destDateString;
}

@end
