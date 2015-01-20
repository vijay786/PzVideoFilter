//
//  SampleViewCntrl.h
//  PzVideoFilter
//
//  Created by necixy on 27/09/13.
//  Copyright (c) 2013 necixy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Addition.h"
#import "KZSxcrollView.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SampleViewCntrl : UIViewController<UITableViewDelegate,UITableViewDelegate>

@property(strong,nonatomic)NSMutableArray *thumbnailArray;
@property (strong, nonatomic) IBOutlet UITableView *sampleTableView;

@end
