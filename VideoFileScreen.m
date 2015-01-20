//
//  VideoFileScreen.m
//  PzVideoFilter
//
//  Created by necixy on 11/09/13.
//  Copyright (c) 2013 necixy. All rights reserved.
//

#import "VideoFileScreen.h"

@interface VideoFileScreen ()

@end

@implementation VideoFileScreen

static NSString * const kCellReuseIdentifier = @"collectionViewCell";


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    _objManager = [[HJObjManager alloc] init];
//	NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/flickr/"] ;
//	HJMOFileCache* fileCache = [[HJMOFileCache alloc] initWithRootPath:cacheDirectory];
//	_objManager.fileCache = fileCache;
    
    _imageCache = [[NSCache alloc] init];
    _imageLoadingQueue = [[NSOperationQueue alloc] init];
    _imageLoadingQueue.maxConcurrentOperationCount = 3;
    
    
    [self.thumbnailCollectionView registerClass:[CollectionViewImageCell class] forCellWithReuseIdentifier:kCellReuseIdentifier];
   
    
//    [self.thumbnailCollectionView registerNib:[UINib nibWithNibName:@"CollectionViewItem" bundle:nil] forCellWithReuseIdentifier:kCellReuseIdentifier];
    self.thumbnailCollectionView.backgroundColor = [UIColor clearColor];
    
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(150,150)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.thumbnailCollectionView setCollectionViewLayout:flowLayout];
    [self.thumbnailCollectionView setAllowsSelection:YES];
    self.thumbnailCollectionView.delegate=self;

    _prefs = [NSUserDefaults standardUserDefaults];
    
    
    [self populateThumnailArray];
    

    
    
//    [self getAllFiles];

}

-(void)viewWillAppear:(BOOL)animated
{
    
//    [[UIApplication sharedApplication]setStatusBarHidden:false];
   
    
    
}


#pragma mark - Get Thumbnails


-(void)populateThumnailArray
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSError * error;
    NSMutableArray *directoryContents =  (NSMutableArray *)[[[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error] mutableCopy];
    
    if (_thumbnailArray!=nil) {
        
        _thumbnailArray = nil;
    }
     NSLog(@"dIRECTORY cONTENTS %@",directoryContents);
    
    
    
    
    //Take all images in NSMutableArray
    _thumbnailArray = [[NSMutableArray alloc]init];
    for(NSString *strFile in directoryContents)
    {
        NSString *strVideoPath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,strFile];
        
        if ([strVideoPath hasSuffix:@".png"]) {
            
            UIImage *img = [UIImage imageWithContentsOfFile:strVideoPath];
            
            [img setAccessibilityIdentifier:strFile] ;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
            [dict setObject:img forKey:@"Image"];
            
            
            if ([strFile hasPrefix:@"Image"]) {
                
                NSString *str = [strFile stringBetweenString:@"Image" andString:@".png"];
                [dict setObject:strVideoPath forKey:@"url"];
                [dict setObject:[NSNumber numberWithInt:[str intValue]] forKey:@"index"];

                
            }
            else if([strFile hasPrefix:@"Thumb"])
            {
            
                NSString *str = [strFile stringBetweenString:@"Thumbnail" andString:@".png"];
                 [dict setObject:strVideoPath forKey:@"url"];
                 [dict setObject:[NSNumber numberWithInt:[str intValue]] forKey:@"index"];
                
            }
            
        [_thumbnailArray addObject:dict];
         

                       
            
                     
        }
   //        UIImage *img = [self getThumbNail:strVideoPath];
        
        
    }
    
    [_thumbnailArray sortUsingDescriptors:
     [NSArray arrayWithObjects:
      [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES],
      nil]];
    NSLog(@"thumbNail Array %@",_thumbnailArray);
    
    [_thumbnailCollectionView reloadData];



}


//-(UIImage *)getThumbNail:(NSString *)stringPath
//{
//    
//    if ([stringPath hasSuffix:@"m4v"]) {
//        NSURL *videoURL = [NSURL fileURLWithPath:stringPath];
//        
//        MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
//        
//        UIImage *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
//        
//        //Player autoplays audio on init
//        [player stop];
//        player = nil;
//        return thumbnail;
//
//    }
//    else
//        return [UIImage imageWithContentsOfFile:stringPath];
//
//    
//    
//    
//    
//    
//}


#pragma mark - CollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_thumbnailArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CollectionViewImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    
    
    NSMutableDictionary *dict = [_thumbnailArray objectAtIndex:indexPath.row];
//    UIImage *img = (UIImage *)[dict valueForKey:@"Image"];

    
    NSString *imagePath = [dict valueForKey:@"url"];
    
    if([_imageCache objectForKey:imagePath])
    {
        cell.imageView.image = [_imageCache objectForKey:imagePath];
          
    
    }
    else
    {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            
            if ([collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
                
                [_imageCache setObject:image forKey:imagePath];
                cell.imageView.image = image;
            }
        }];
        
        [_imageLoadingQueue addOperation:operation];
        
        
        
//        el\
//            @operation = NSBlockOperation.blockOperationWithBlock lambda {
//                @image = UIImage.imageWithContentsOfFile(image_path)
//                Dispatch::Queue.main.async do
//                    return unless collectionView.indexPathsForVisibleItems.containsObject(index_path)
//                    @images_cache.setObject(@image, forKey: image_path)
//                    cell = collectionView.cellForItemAtIndexPath(index_path)
//                    cell.image = @image
//                    end
//                    }
//        @image_loading_queue.addOperation(@operation)
//        end
//        end
    
    
    }
    
        
     
//    [cell.imageView setImage:img];
//   
//     NSString *imgName = img.accessibilityIdentifier;
//    
//
//    if ([imgName hasPrefix:@"Thumb"]) {
//        
//        [cell.thumbImageView setHidden:false];
//       
//    }
//    else
//    {
//        [cell.thumbImageView setHidden:TRUE];
//    
//    }
//    img = nil;
  
    
    return cell;
    
}

#pragma mark - delegate methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // First, get the URL for the video file you want to play.  For example, if you have an array of the movie file URLs, you'd do this:
    NSMutableDictionary *dict = [_thumbnailArray objectAtIndex:indexPath.row];
    
    
    UIImage *thumbImage = (UIImage *)[dict valueForKey:@"Image"];
    
     
    NSString *imgName = thumbImage.accessibilityIdentifier;
    NSLog(@"Name si %@",imgName);
    
    
    if ([imgName hasPrefix:@"Thumb"]) {
        
         
        NSString *movieNo = [imgName stringBetweenString:@"Thumbnail" andString:@".png"];
        
        NSLog(@"moview No is %@",movieNo);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSError * error;
        NSArray *directoryContents =  [[NSFileManager defaultManager]contentsOfDirectoryAtPath:documentsDirectory error:&error];
        
        NSString *strVideoPath;
        
        for (NSString *strFile in directoryContents) {
            
            
            
            NSLog(@"subStr %@",strFile);
            
            
            NSRange rangeOfSubstring = [strFile rangeOfString:@".m4v"];
            
            if(rangeOfSubstring.location == NSNotFound)
            {
                // error condition — the text '<a href' wasn't in 'string'
            }
            else
            {
                NSString *subStr = [strFile substringToIndex:rangeOfSubstring.location];
                 NSLog(@"subStr %@",subStr);
                
                if ([subStr rangeOfString:movieNo].location == NSNotFound) {
                    
                }
                else
                {
                    
                    strVideoPath  = [NSString stringWithFormat:@"%@/%@",documentsDirectory,strFile];
                    break;
                }
                
            }
            // return only that portion of 'string' up to where '<a href' was found
                        
            
            
            
        }
        
        NSLog(@"strVideoPath %@",strVideoPath);
        
        NSURL * movieURL = [NSURL fileURLWithPath:strVideoPath];
        // Now set up the movie player controller and play the movie.
        MPMoviePlayerViewController *theMovie = [[MPMoviePlayerViewController alloc]initWithContentURL:movieURL];
        
        [self presentMoviePlayerViewControllerAnimated:theMovie];
        // 4 - Register for the playback finished notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:)name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
        
        
    }
    else
    {
        KZSxcrollView *pps = [[KZSxcrollView alloc]initWithNibName:@"KZSxcrollView" bundle:nil];
       pps.title = @"Photos";
        UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:pps];
        
        
        pps.linkedImage = thumbImage;
        
        [self presentViewController:nv animated:YES completion:nil];
    
    }
    
    
    
   
}




// When the movie is done, release the controller.
-(void)myMovieFinishedCallback:(NSNotification*)aNotification {
    [self dismissMoviePlayerViewControllerAnimated];
    
    MPMoviePlayerController* theMovie = [aNotification object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
