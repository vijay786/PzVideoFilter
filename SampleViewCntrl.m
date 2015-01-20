//
//  SampleViewCntrl.m
//  PzVideoFilter
//
//  Created by necixy on 27/09/13.
//  Copyright (c) 2013 necixy. All rights reserved.
//

#import "SampleViewCntrl.h"

@interface SampleViewCntrl ()

@end

@implementation SampleViewCntrl

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
     [self populateThumnailArray];
    // Do any additional setup after loading the view from its nib.
}

-(void)populateThumnailArray
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSError * error;
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Thumbnails/"];
    
    NSMutableArray *directoryContents =  (NSMutableArray *)[[[NSFileManager defaultManager] contentsOfDirectoryAtPath:dataPath error:&error] mutableCopy];
    
    if (_thumbnailArray!=nil) {
        
        _thumbnailArray = nil;
    }
    NSLog(@"dIRECTORY cONTENTS %@",directoryContents);
    
    //Take all images in NSMutableArray
    _thumbnailArray = [[NSMutableArray alloc]init];
    for(NSString *strFile in directoryContents)
    {
        NSString *strVideoPath = [NSString stringWithFormat:@"%@/%@",dataPath,strFile];
        
       if ([strVideoPath hasSuffix:@".png"]) {
        
           UIImage *img = [UIImage imageWithContentsOfFile:strVideoPath];
            
            [img setAccessibilityIdentifier:strFile] ;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
            NSLog(@"img.size = %f %f",img.size.width,img.size.height);
            
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
            
            img = nil;
            
            
            
            
       }
        //        UIImage *img = [self getThumbNail:strVideoPath];
        
        
    }
    
    [_thumbnailArray sortUsingDescriptors:
     [NSArray arrayWithObjects:
      [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES],
      nil]];
    NSLog(@"thumbNail Array %@",_thumbnailArray);
}

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
        
        NSLog(@"cell created");
        
        UIImageView *imageVew = [[UIImageView alloc] initWithFrame:CGRectMake(3,3,144,144)];
        [imageVew setBackgroundColor:[UIColor redColor]];
        imageVew.tag = 1;
        [cell.contentView addSubview:imageVew];
        imageVew = nil;
        
        
        UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(172,3,144,144)];
        
        imageView2.tag = 2;
        [cell.contentView addSubview:imageView2];
        imageView2= nil;
        
        UIImageView *thumbImageViewOne = [[UIImageView alloc]initWithFrame:CGRectMake(43,43,64,64)];
        thumbImageViewOne.tag = 6;
        [thumbImageViewOne setHidden:TRUE];
        [thumbImageViewOne setImage:[UIImage imageNamed:@"playBtn_new.png"]];
        [cell.contentView addSubview:thumbImageViewOne];
        thumbImageViewOne = nil;
        
        UIImageView *thumbImageViewTwo = [[UIImageView alloc]initWithFrame:CGRectMake(211,43,64,64)];
        thumbImageViewTwo.tag = 7;
        [thumbImageViewTwo setHidden:TRUE];
        [thumbImageViewTwo setImage:[UIImage imageNamed:@"playBtn_new.png"]];
        [cell.contentView addSubview:thumbImageViewTwo];
        thumbImageViewTwo = nil;
        
        
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.tag =3;
        [button1 addTarget:self action:@selector(button1Tapped:event:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button1];
        
        
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button2 addTarget:self action:@selector(button1Tapped:event:) forControlEvents:UIControlEventTouchUpInside];
        button2.tag=5;
        
        [cell.contentView addSubview:button2];
        
        
    }
    else
    {
        NSLog(@"cell recycled");
    
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.row*2<_thumbnailArray.count) {
        
        UIImageView *firstImageView = (UIImageView *)[cell.contentView viewWithTag:1];
        [firstImageView setHidden:FALSE];
        NSMutableDictionary *dict = [_thumbnailArray objectAtIndex:indexPath.row*2];
        [firstImageView setContentMode:UIViewContentModeScaleAspectFit];
        [firstImageView setBackgroundColor:[UIColor clearColor]];
        //        [firstImageView showLoadingWheel];
        [firstImageView setImage:[dict valueForKey:@"Image"]];
  
        
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:6];
        
        
        if ([[dict valueForKey:@"url"]rangeOfString:@"Image"].location!=NSNotFound) {
            [imageView setHidden:TRUE];
        }
        else
            [imageView setHidden:false];
        
        UIButton *button1=(UIButton *)[cell.contentView viewWithTag:3];
        [button1 setHidden:FALSE];
        [button1 addTarget:self action:@selector(button1Tapped:event:) forControlEvents:UIControlEventTouchUpInside];
        [button1 setFrame: CGRectMake(3,3,144,144)];
        [button1 setAccessibilityIdentifier:@"1"];
        
        dict = nil;
    }
    else
    {
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:6];
        [imageView setHidden:TRUE];
        UIImageView *firstImageView = (UIImageView *)[cell.contentView viewWithTag:1];
        [firstImageView setHidden:TRUE];
        UIButton *button3=(UIButton *)[cell.contentView viewWithTag:3];
        [button3 setHidden:TRUE];
    }
  
    
    
    
    
    if (indexPath.row*2+1<_thumbnailArray.count) {
        
        
        UIImageView *secondImageView = (UIImageView *)[cell.contentView viewWithTag:2];
        [secondImageView setHidden:FALSE];
        
        NSMutableDictionary *dict1 = [_thumbnailArray objectAtIndex:indexPath.row*2+1];
        //        NSURL *url = [NSURL fileURLWithPath:[dict1 valueForKey:@"url"]];
        [secondImageView setBackgroundColor:[UIColor clearColor]];
        [secondImageView setImage:[dict1 valueForKey:@"Image"]];
     
        
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:7];
        
        
        if ([[dict1 valueForKey:@"url"]rangeOfString:@"Image"].location!=NSNotFound) {
            [imageView setHidden:TRUE];
        }
        else
            [imageView setHidden:false];
       
        UIButton *button3=(UIButton *)[cell.contentView viewWithTag:5];
        [button3 addTarget:self action:@selector(button1Tapped:event:) forControlEvents:UIControlEventTouchUpInside];
        [button3 setHidden:FALSE];
        [button3 setAccessibilityIdentifier:@"2"];
        [button3 setFrame: CGRectMake(172,3,144,144)];

        
        
        dict1 = nil;
        
    }
    else
    {
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:7];
        [imageView setHidden:TRUE];
        UIImageView *secondImageView = (UIImageView *)[cell.contentView viewWithTag:2];
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
    
	CGPoint currentTouchPosition = [touch locationInView:self.sampleTableView];
	NSIndexPath *indexPath = [self.sampleTableView indexPathForRowAtPoint: currentTouchPosition];
    
    
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
        
        NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:@"Originals/"];
        
        NSError * error;
        NSArray *directoryContents =  [[NSFileManager defaultManager]contentsOfDirectoryAtPath:folderPath error:&error];
        
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
                    
                    strVideoPath  = [NSString stringWithFormat:@"%@/%@",folderPath,strFile];
                    break;
                }
                
            }
            // return only that portion of 'string' up to where '<a href' was found
            
            
            
            
        }
        
        NSLog(@"strVideoPath %@",strVideoPath);
        
        NSURL * movieURL = [NSURL fileURLWithPath:strVideoPath];
        // Now set up the movie player controller and play the movie.
        MPMoviePlayerViewController *theMovie = [[MPMoviePlayerViewController alloc]initWithContentURL:movieURL];
        
        thumbImage = nil;
        
        [self presentMoviePlayerViewControllerAnimated:theMovie];
        // 4 - Register for the playback finished notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:)name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
        
        
    }
    else
    {
        
        NSString *movieNo = [imgName stringBetweenString:@"Image" andString:@".png"];
        
        NSLog(@"moview No is %@",movieNo);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:@"Originals/"];
        
        NSError * error;
        NSArray *directoryContents =  [[NSFileManager defaultManager]contentsOfDirectoryAtPath:folderPath error:&error];
        
        NSString *strVideoPath;
        
        for (NSString *strFile in directoryContents) {
            
            
            
            NSLog(@"subStr %@",strFile);
            
            
            NSRange rangeOfSubstring = [strFile rangeOfString:@".png"];
            
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
                    
                    strVideoPath  = [NSString stringWithFormat:@"%@/%@",folderPath,strFile];
                    break;
                }
                
            }

        }
        
        KZSxcrollView *pps = [[KZSxcrollView alloc]initWithNibName:@"KZSxcrollView" bundle:nil];
        pps.title = @"Photos";
        UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:pps];
        
        
        pps.linkedImage = [UIImage imageWithContentsOfFile:strVideoPath];
        
        thumbImage = nil;
        
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



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    

}



-(void)dealloc
{

    [self setThumbnailArray:nil];
    NSLog(@"dealloc");

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
