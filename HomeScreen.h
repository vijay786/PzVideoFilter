//
//  HomeScreen.h
//  PzVideoFilter
//
//  Created by necixy on 11/09/13.
//  Copyright (c) 2013 necixy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordViewController.h"
#import "VideoFileScreen.h"
#import "BetterRecordScreen.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import "KZSxcrollView.h"
#import "ThumnailController.h"
#import "SampleViewCntrl.h"

@class ThumnailController;
//#import <MBProgressHUD/MBProgressHUD.h>

@interface HomeScreen : UIViewController<BRSDelegate>

- (IBAction)recordBtnPressed:(id)sender;
- (IBAction)playVideoPressed:(id)sender;

@property(strong,nonatomic)NSUserDefaults *prefs;
@property(strong,nonatomic)ThumnailController *thunCntrl;

@end
