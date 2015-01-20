//
//  HomeScreen.m
//  PzVideoFilter
//
//  Created by necixy on 11/09/13.
//  Copyright (c) 2013 necixy. All rights reserved.
//

#import "HomeScreen.h"

@interface HomeScreen ()

@end

@implementation HomeScreen

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
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{

//      [[UIApplication sharedApplication]setStatusBarHidden:false];
    [self.navigationController setNavigationBarHidden:false];


}
-(void)viewWillDisappear:(BOOL)animated
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(buttonPressed:)];
    [backButton setTintColor:[UIColor colorWithRed:46/256.0 green:46/256.0 blue:46/256.0 alpha:1.0]];
    self.navigationItem.backBarButtonItem = backButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordBtnPressed:(id)sender {
    
//    RecordViewController *rvc = [[RecordViewController alloc]initWithNibName:@"RecordViewController" bundle:nil];
//    rvc.title = @"Camera";
//    [self.navigationController pushViewController:rvc animated:YES
//     ];
    
    BetterRecordScreen *br = [[BetterRecordScreen alloc]init];
    br.delegate  = self;
    [self.navigationController presentViewController:br animated:YES completion:nil];
    
    
}
// When the movie is done, release the controller.
-(void)myMovieFinishedCallback:(NSNotification*)aNotification
{
    [self dismissMoviePlayerViewControllerAnimated];
    
    MPMoviePlayerController* theMovie = [aNotification object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
}

-(void)getVideoFromPath:(NSString *)videoPath
{
    [self dismissViewControllerAnimated:YES completion:^{
    
        // for iOS7
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }

        NSURL * movieURL = [NSURL fileURLWithPath:videoPath];
        // Now set up the movie player controller and play the movie.
        MPMoviePlayerViewController *theMovie = [[MPMoviePlayerViewController alloc]initWithContentURL:movieURL];
        
        [self presentMoviePlayerViewControllerAnimated:theMovie];
        // 4 - Register for the playback finished notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:)name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];

    
    }];
}

-(void) imagePickerControllerDidCancel:(BetterRecordScreen *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) imagePickerController:(BetterRecordScreen *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    // for iOS7
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        KZSxcrollView *pps = [[KZSxcrollView alloc]initWithNibName:@"KZSxcrollView" bundle:nil];
        pps.title = @"Photos";
        UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:pps];
        
        
        pps.linkedImage = [UIImage imageWithData:[info objectForKey:@"Largedata"]];
        
        [self presentViewController:nv animated:YES completion:nil];

        
    }];
    
    if (info) {
        
       _prefs = [NSUserDefaults standardUserDefaults];
        
        int temp = 0;
        
        if ([_prefs objectForKey:@"courseID"]) {
            
            temp = [_prefs integerForKey:@"courseID"];
        }
        else
        {
            temp = 0;
        }
        temp = temp+1;
        
        NSString *comp = [NSString stringWithFormat:@"Image%d.png",temp];
       
        [_prefs setInteger:temp forKey:@"courseID"];
        [_prefs synchronize];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSLog(@"count ios %d",paths.count);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *folderName1 = @"Originals/";
        
        NSString *folderName2 = @"Thumbnails/";
        
        
        NSString *dataPath1 = [documentsDirectory stringByAppendingPathComponent:folderName1];
        NSString *dataPath2 = [documentsDirectory stringByAppendingPathComponent:folderName2];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath1])
            [[NSFileManager defaultManager] createDirectoryAtPath:dataPath1 withIntermediateDirectories:NO attributes:nil error:nil];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath2])
            [[NSFileManager defaultManager] createDirectoryAtPath:dataPath2 withIntermediateDirectories:NO attributes:nil error:nil];

              
        NSString *savedImagePath = [dataPath1 stringByAppendingPathComponent:comp];
        NSString *savedImagePath2 = [dataPath2 stringByAppendingPathComponent:comp];
      
        if ([[NSFileManager defaultManager] fileExistsAtPath:savedImagePath]) {
            
            [[NSFileManager defaultManager]removeItemAtPath:savedImagePath error:nil];
        }
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:savedImagePath2]) {
            
            [[NSFileManager defaultManager]removeItemAtPath:savedImagePath2 error:nil];
        }

        [[info objectForKey:@"Largedata"] writeToFile:savedImagePath atomically:NO];
        [[info objectForKey:@"Smalldata"] writeToFile:savedImagePath2 atomically:NO];
        
    }
}



- (IBAction)playVideoPressed:(id)sender
{
    
//    VideoFileScreen *vfs  = [[VideoFileScreen alloc]initWithNibName:@"VideoFileScreen" bundle:nil];
//    [self.navigationController pushViewController:vfs animated:YES];
    
    SampleViewCntrl *svc = [[SampleViewCntrl alloc]initWithNibName:@"SampleViewCntrl" bundle:nil];
    [self.navigationController pushViewController:svc animated:YES];
    
}
@end
