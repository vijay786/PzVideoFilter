//
//  VideoFileScreen.h
//  PzVideoFilter
//
//  Created by necixy on 11/09/13.
//  Copyright (c) 2013 necixy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PhotoScreen.h"
#import "NSString+Addition.h"
#import "KZSxcrollView.h"
#import "CollectionViewImageCell.h"
#import "HJObjManager.h"
#import "AppDelegate.h"
@class CollectionViewImageCell;
@interface VideoFileScreen : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
@property(strong,nonatomic)MPMoviePlayerController *movieController;
@property (strong, nonatomic) IBOutlet UICollectionView *thumbnailCollectionView;
@property(strong,nonatomic)NSMutableArray *thumbnailArray;
@property(strong,nonatomic)NSUserDefaults *prefs;
@property(strong,nonatomic)HJObjManager *objManager;
@property(strong,nonatomic)NSCache *imageCache;
@property(strong,nonatomic)NSOperationQueue *imageLoadingQueue;
@end
