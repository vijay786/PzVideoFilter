//
//  ThumnailController.m
//  PzVideoFilter
//
//  Created by necixy on 26/09/13.
//  Copyright (c) 2013 necixy. All rights reserved.
//

#import "ThumnailController.h"

@interface ThumnailController ()

@end

@implementation ThumnailController

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
    
    [self populateThumnailArray];
    
    // Do any additional setup after loading the view from its nib.
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
    
//    if (_thumbArrayOne!=nil) {
//        
//        _thumbArrayOne = nil;
//    }
//    _thumbArrayOne = [[NSMutableArray alloc] init];
//    
//    
//    if (_thumbArrayTwo!=nil) {
//        
//        _thumbArrayTwo = nil;
//    }
//     _thumbArrayTwo = [[NSMutableArray alloc] init];
//    
//    for (int i=0;i<_thumbnailArray.count;i++) {
//        
//        if (i%2==0) {
//            
//            [_thumbArrayOne addObject:[_thumbnailArray objectAtIndex:i]];
//            
//        }
//        else
//        {
//            [_thumbArrayTwo addObject:[_thumbnailArray objectAtIndex:i]];
//        
//        }
//        
//        
//    }
//    
//    NSLog(@"countone - %d and countTwo - %d",_thumbArrayOne.count,_thumbArrayTwo.count);
    
    
    [_collectionTableView reloadData];
    
    
    
}

#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSLog(@"return %d",_thumbnailArray.count/2);
    
    if (_thumbnailArray.count%2==0) {
        
        return _thumbnailArray.count/2;
    }
    else
        return _thumbnailArray.count/2+1;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,320,150)];
//        view.tag =1 ;
        
        UIImageView *imageView1 =[[UIImageView alloc] initWithFrame:CGRectMake(3,3,144,144)];
//        [imageView1 setUrl:nil];
        imageView1.tag = 2;
        [cell.contentView addSubview:imageView1];
        
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.tag =3;
//        [button1 addTarget:self action:@selector(button1Tapped:event:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button1];
       
        
        
        UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(172,3,144,144)];
     
        imageView2.tag = 4;
        [cell.contentView addSubview:imageView2];
        
        
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.tag=5;
        
        [cell.contentView addSubview:button2];
        
        
        UIImageView *thumbImageViewOne = [[UIImageView alloc]initWithFrame:CGRectMake(43,43,64,64)];
        thumbImageViewOne.tag = 6;
           [thumbImageViewOne setHidden:TRUE];
        [thumbImageViewOne setImage:[UIImage imageNamed:@"playBtn_new.png"]];
        [cell.contentView addSubview:thumbImageViewOne];
        
        
        UIImageView *thumbImageViewTwo = [[UIImageView alloc]initWithFrame:CGRectMake(211,43,64,64)];
        thumbImageViewTwo.tag = 7;
         [thumbImageViewTwo setHidden:TRUE];
        [thumbImageViewTwo setImage:[UIImage imageNamed:@"playBtn_new.png"]];
        [cell.contentView addSubview:thumbImageViewTwo];

        
        
        
        imageView1 = nil;
        imageView2  = nil;
        
//        [cell.contentView addSubview:view];
        
    }

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

//    UIView *view = (UIView *)[cell.contentView viewWithTag:1];
//    view.backgroundColor = [UIColor clearColor];
    
     
    if (indexPath.row*2<_thumbnailArray.count) {
        
        UIImageView *firstImageView = (UIImageView *)[cell.contentView viewWithTag:2];
        [firstImageView setHidden:FALSE];
        NSMutableDictionary *dict = [_thumbnailArray objectAtIndex:indexPath.row*2];
//        NSURL *url = [NSURL fileURLWithPath:[dict valueForKey:@"url"]];
        [firstImageView setContentMode:UIViewContentModeScaleAspectFit];
        [firstImageView setBackgroundColor:[UIColor clearColor]];
//        [firstImageView showLoadingWheel];
        [firstImageView setImage:[dict valueForKey:@"Image"]];
//         firstImageView.callbackOnSetImage = (id)self;
//        [_objManager manage:firstImageView];
        
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:6];
        
        
        if ([[dict valueForKey:@"url"]rangeOfString:@"Thumb"].location!=NSNotFound) {
            [imageView setHidden:false];
        }
        else
            [imageView setHidden:TRUE];
        
        
        UIButton *button1=(UIButton *)[cell.contentView viewWithTag:3];
         [button1 setHidden:FALSE];
        [button1 addTarget:self action:@selector(button1Tapped:event:) forControlEvents:UIControlEventTouchUpInside];
        [button1 setFrame: CGRectMake(3,3,144,144)];
         [button1 setAccessibilityIdentifier:@"1"];
        
        
        
      
        
        
//        button1.tag = indexPath.row*2;
    
    }
    else
    {
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:6];
        [imageView setHidden:TRUE];
        HJManagedImageV *secondImageView = (HJManagedImageV *)[cell.contentView viewWithTag:2];
        [secondImageView setHidden:TRUE];
        UIButton *button3=(UIButton *)[cell.contentView viewWithTag:3];
        [button3 setHidden:TRUE];
    }

  

    
    if (indexPath.row*2+1<_thumbnailArray.count) {
    
    
        UIImageView *secondImageView = (UIImageView *)[cell.contentView viewWithTag:4];
        [secondImageView setHidden:FALSE];

        NSMutableDictionary *dict1 = [_thumbnailArray objectAtIndex:indexPath.row*2+1];
//        NSURL *url = [NSURL fileURLWithPath:[dict1 valueForKey:@"url"]];        
        [secondImageView setBackgroundColor:[UIColor clearColor]];
         [secondImageView setImage:[dict1 valueForKey:@"Image"]];
//        [secondImageView showLoadingWheel];
//        [secondImageView setUrl:url];
//        secondImageView.callbackOnSetImage = (id)self;
//        [_objManager manage:secondImageView];
        
        
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:7];
        
        
        if ([[dict1 valueForKey:@"url"]rangeOfString:@"Thumb"].location!=NSNotFound) {
            [imageView setHidden:false];
        }
        else
            [imageView setHidden:TRUE];

        
        
       //        [button2 setAccessibilityIdentifier:@"buttonTwo"];
//          button2.tag = indexPath.row*2+1;
        UIButton *button3=(UIButton *)[cell.contentView viewWithTag:5];
        [button3 addTarget:self action:@selector(button1Tapped:event:) forControlEvents:UIControlEventTouchUpInside];
        [button3 setHidden:FALSE];
         [button3 setAccessibilityIdentifier:@"2"];
        [button3 setFrame: CGRectMake(172,3,144,144)];

    }
    else
    {
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:7];
        [imageView setHidden:TRUE];
        HJManagedImageV *secondImageView = (HJManagedImageV *)[cell.contentView viewWithTag:4];
        [secondImageView setHidden:TRUE];
        UIButton *button3=(UIButton *)[cell.contentView viewWithTag:5];
           [button3 setHidden:TRUE];
        
    }

  
    
  
 
    
    
    return cell;
}

- (void)button1Tapped:(id)sender event:(id)event
{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
    UIButton *btn= (UIButton*)sender;
    
	CGPoint currentTouchPosition = [touch locationInView:self.collectionTableView];
	NSIndexPath *indexPath = [self.collectionTableView indexPathForRowAtPoint: currentTouchPosition];
    
    
    NSMutableDictionary *dict;
    if ([btn.accessibilityIdentifier intValue]==1) {
        dict = [_thumbnailArray objectAtIndex:indexPath.row*2];
    }
    else
    {
        dict = [_thumbnailArray objectAtIndex:indexPath.row*2+1];
    
    
    }
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


-(void) managedImageSet:(HJManagedImageV*)mi
{
    mi.imageView.contentMode = UIViewContentModeScaleAspectFill;
    mi.imageView.clipsToBounds=YES;
}



-(void)dealloc
{
    NSLog(@"dealloc ");
    _collectionTableView = nil;
    _thumbnailArray = nil;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
