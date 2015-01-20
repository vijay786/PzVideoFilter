//
//  RecordViewController.h
//  PzVideoFilter
//
//  Created by necixy on 11/09/13.
//  Copyright (c) 2013 necixy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface RecordViewController : UIViewController<UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *bottomImageView;

@property(strong,nonatomic)GPUImageVideoCamera *videoCamera;
@property(strong,nonatomic)GPUImageStillCamera *stillCamera;
@property(strong,nonatomic) GPUImageFilter *filter;

- (IBAction)flipButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet GPUImageView *cameraView;
@property(strong,nonatomic)GPUImageMovieWriter *movieWriter;

@property (strong, nonatomic) IBOutlet UIButton *cameraCaptureBtn;
@property (strong, nonatomic) IBOutlet UIButton *switchBtn;

@property (strong, nonatomic) IBOutlet UIButton *bottomBackBtn;

@property (strong, nonatomic) IBOutlet UIButton *flipCameraBtn;
@property (strong, nonatomic) IBOutlet UIButton *settingsBtn;
@property (strong, nonatomic) IBOutlet UIButton *topBackBtn;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)switchBtnPressed:(id)sender;
- (IBAction)captureBtnPressed:(id)sender;


@property(assign)BOOL isRecording;

- (IBAction)fitlerBtnPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *noFilterBtn;
@property (strong, nonatomic) IBOutlet UIButton *grayScaleBtn;
@property (strong, nonatomic) IBOutlet UIButton *sepiaBtn;
@property (strong, nonatomic) IBOutlet UIButton *sketchBtn;
@property (strong, nonatomic) IBOutlet UIButton *monoColorBtn;
@property (strong, nonatomic) IBOutlet UIButton *colorInvert;
@property (strong, nonatomic) IBOutlet UIButton *toonBtn;
@property (strong, nonatomic) IBOutlet UIButton *pinchDistortBtn;
- (IBAction)filterBtnPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *filterScrollView;
@property (strong, nonatomic) IBOutlet UIButton *flashButton;
- (IBAction)flashBtnPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *topImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property(assign)BOOL isVedio;

@end
