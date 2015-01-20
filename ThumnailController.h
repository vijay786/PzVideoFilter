//
//  ThumnailController.h
//  PzVideoFilter
//
//  Created by necixy on 26/09/13.
//  Copyright (c) 2013 necixy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PhotoScreen.h"
#import "NSString+Addition.h"
#import "KZSxcrollView.h"
#import "AppDelegate.h"
#import "HJObjManager.h"
#import "HJManagedImageV.h"

@interface ThumnailController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *collectionTableView;
@property(strong,nonatomic)MPMoviePlayerController *movieController;
@property(strong,nonatomic)NSMutableArray *thumbnailArray;
@property(strong,nonatomic)NSMutableArray *thumbArrayOne;
@property(strong,nonatomic)NSMutableArray *thumbArrayTwo;
@property(strong,nonatomic)HJObjManager *objManager;
@end
