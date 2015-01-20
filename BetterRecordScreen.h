//
//  BetterRecordScreen.h
//  PzVideoFilter
//
//  Created by necixy on 23/09/13.
//  Copyright (c) 2013 necixy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gpuimage.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MBProgressHUD.h"
#import "UIImage+Resize.h"
#import "YLProgressBar.h"

@class BetterRecordScreen;
@class YLProgressBar;

@protocol BRSDelegate <NSObject>
@optional

-(void)getVideoFromPath:(NSString *)videoPath;
- (void)imagePickerController:(BetterRecordScreen *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel:(BetterRecordScreen *)picker;

@end

@interface BetterRecordScreen : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *BottomShutterView;
@property (strong, nonatomic) IBOutlet UIImageView *topShutterView;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UIImageView *topImageVIEW;
@property (nonatomic, weak) id <BRSDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *bottomBar;
@property (strong, nonatomic) IBOutlet UIScrollView *filterScrollView;
- (IBAction)filterBtnPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *captureBtn;
- (IBAction)captureBtnPressed:(id)sender;
- (IBAction)backBtnPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *flipCamera;
- (IBAction)flipCameraPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *flashBtn;
- (IBAction)flashBtnPressed:(id)sender;
- (IBAction)buttonTouchedOutside:(id)sender;
- (IBAction)captureTouchDown:(id)sender;
- (IBAction)captureTouchCancel:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *switchBtn;
- (IBAction)switchBtnPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet GPUImageView *gpuImageView;
@property (nonatomic, assign) CGFloat outputJPEGQuality;
@property (nonatomic, assign) CGSize requestedImageSize;

//cameras

@property(strong,nonatomic)GPUImageStillCamera *stillCamera;
@property(strong,nonatomic)GPUImageVideoCamera *videoCamera;
@property(strong,nonatomic) GPUImageMovieWriter *movieWriter;

@property(strong,nonatomic)GPUImageCropFilter *cropFilter;
@property(strong,nonatomic)GPUImagePicture *staticPicture;
@property (strong, nonatomic) IBOutlet YLProgressBar *ylProgressBar;


@end
