//
//  RecordViewController.m
//  PzVideoFilter
//
//  Created by necixy on 11/09/13.
//  Copyright (c) 2013 necixy. All rights reserved.
//

#import "RecordViewController.h"

@interface RecordViewController ()

@end

@implementation RecordViewController

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
    
    
    
    [_filterScrollView setContentSize:CGSizeMake(500,63)];
    
    
    // Add Filter Button to Interface
//    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(applyImageFilter:)];
//    self.navigationItem.rightBarButtonItem = filterButton;
    
    _isVedio = FALSE;
    [self startStillCamera];
    NSLog(@"Self height is %f",self.view.frame.size.height);
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    
    
   

    
    if (screenBounds.size.height<481) {
        CGRect bottomFrame = _bottomImageView.frame;
        bottomFrame.origin.y = self.view.frame.size.height-54;
        [_bottomImageView setFrame:bottomFrame];
        
        CGRect bottomFrame1 = _cameraCaptureBtn.frame;
        bottomFrame1.origin.y = self.view.frame.size.height-54;
        [_cameraCaptureBtn setFrame:bottomFrame1];
        
        
        CGRect bottomFrame2 = _bottomBackBtn.frame;
        bottomFrame2.origin.y = self.view.frame.size.height-54;
        [_bottomBackBtn setFrame:bottomFrame2];
        
        CGRect bottomFrame3 = _switchBtn.frame;
        bottomFrame3.origin.y = self.view.frame.size.height-42;
        [_switchBtn setFrame:bottomFrame3];
        
    }
    else
    {
        CGRect bottomFrame = _bottomImageView.frame;
        bottomFrame.origin.y = 568-54;
        [_bottomImageView setFrame:bottomFrame];
        
        CGRect bottomFrame1 = _cameraCaptureBtn.frame;
        bottomFrame1.origin.y = 568-54;
        [_cameraCaptureBtn setFrame:bottomFrame1];
        
        
        CGRect bottomFrame2 = _bottomBackBtn.frame;
        bottomFrame2.origin.y = 568-54;
        [_bottomBackBtn setFrame:bottomFrame2];
        
        CGRect bottomFrame3 = _switchBtn.frame;
        bottomFrame3.origin.y = 568-42;
        [_switchBtn setFrame:bottomFrame3];
        
    }
    

    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication]setStatusBarHidden:TRUE];
    [self.navigationController setNavigationBarHidden:TRUE];
}

#pragma mark - Start Camera

-(void)startVedioCamera
{
    if (_filter !=nil) {
        
        _filter = nil;
        
    }
    
    
    if (_videoCamera !=nil) {
        
        _videoCamera = nil;
        
    }
    
    [_titleLabel setText:@"Video Capture"];
    
    _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
   
    
    [_videoCamera setOutputImageOrientation:UIInterfaceOrientationPortrait];
    _videoCamera.horizontallyMirrorFrontFacingCamera = NO;
    _videoCamera.horizontallyMirrorRearFacingCamera = NO;
    

    // Setup initial camera filter
    _filter = [[GPUImageFilter alloc] init];
    
    GPUImageView *filterView = (GPUImageView *)self.cameraView;
    [_filter addTarget:filterView];
    
    NSLog(@"Widdhtr is %f",filterView.frame.size.width);
    
    
    
    [_videoCamera addTarget:_filter];
    // Begin showing video camera stream
    
    // Record a movie for 10 s and store it in /Documents, visible via iTunes file sharing
    
    [_videoCamera startCameraCapture];
}

-(void)startStillCamera
{
    if (_filter !=nil) {
        
        _filter = nil;
        
    }
    
    [_titleLabel setText:@"Photo Capture"];
    
    _filter = [[GPUImageFilter alloc] init];
	[_filter prepareForImageCapture];
    GPUImageView *filterView = (GPUImageView *)self.cameraView;
    [_filter addTarget:filterView];
    
    if (_stillCamera !=nil) {
        
        _stillCamera = nil;
        
    }
    
    
    // Create custom GPUImage camera
    _stillCamera = [[GPUImageStillCamera alloc] init];
    _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    [_stillCamera addTarget:_filter];
    
    // Begin showing video camera stream
    [_stillCamera startCameraCapture];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)flipButtonPressed:(id)sender {
    
//    [_videoCamera rotateCamera];
    
    
    if ([UIImagePNGRepresentation(_bottomImageView.image)isEqualToData:UIImagePNGRepresentation([UIImage imageNamed:@"cameraBottomBar.png"])]) {
        
        [_stillCamera rotateCamera];
              
    }
    else if([UIImagePNGRepresentation(_bottomImageView.image)isEqualToData:UIImagePNGRepresentation([UIImage imageNamed:@"videoBottomBar.png"])]) {
        
        [_videoCamera rotateCamera];
        
    }

    
    
}

//-(void)saveImageInDocumentDirectory
//{
//    NSArray *arrayPaths =
//    NSSearchPathForDirectoriesInDomains(
//                                        NSDocumentDirectory,
//                                        NSUserDomainMask,
//                                        YES);
//    NSString *path = [arrayPaths objectAtIndex:0];
//    
//    
//    
//    NSString* pdfFileName = [path stringByAppendingPathComponent:@"1016176_538432476192659_2144585919_n"];
//    
//    
//    
//    
//}



-(void)startRecording
{

    
    if (_movieWriter!=nil) {
        
        _movieWriter = nil;
    }
    
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    
    NSLog(@"contents %@",[[NSFileManager defaultManager]contentsOfDirectoryAtPath:path error:nil]);
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    int temp = 0;
    
    if ([prefs objectForKey:@"courseID"]) {
        
        temp = [prefs integerForKey:@"courseID"];
    }
    else
    {
        temp = 0;
    }
    temp = temp+1;
    
    
    //    [courseEntity setCourseID:[NSNumber numberWithInt:temp]];
    
    NSString *comp = [NSString stringWithFormat:@"Movie%d.m4v",temp];
    
    NSString* pdfFileName = [path stringByAppendingPathComponent:comp];
    [prefs setInteger:temp forKey:@"courseID"];
    [prefs synchronize];
    if ([[NSFileManager defaultManager] fileExistsAtPath:pdfFileName]) {
        
        [[NSFileManager defaultManager]removeItemAtPath:pdfFileName error:nil];
    }
    
    
    
    NSURL *movieURL = [NSURL fileURLWithPath:pdfFileName];
    //    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(640,480.0)];
    //    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(640.0, 480.0)];
    
    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(640,960)];
        
     
    
    //    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(1080.0, 1920.0)];
    [_filter addTarget:_movieWriter];
    
    
    _videoCamera.audioEncodingTarget = _movieWriter;
    [_movieWriter startRecording];

    
    _isRecording = TRUE;
    NSLog(@"Start Recording");
    

}

-(void)stopRecording
{
    _isRecording = FALSE;
    
     NSLog(@"stop Recording");
    [_filter removeTarget:_movieWriter];
    _videoCamera.audioEncodingTarget = nil;
    [_movieWriter finishRecording];
    
    
    
    
    
    [self populateThumnailArray];
    


}
#pragma mark - Get Thumbnails


-(void)populateThumnailArray
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSError * error;
//    NSMutableArray *directoryContents =  (NSMutableArray *)[[[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error] mutableCopy];
    
  
      NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
    //Take all images in NSMutableArray
       

    
    NSString *comp1 = [NSString stringWithFormat:@"Movie%d.m4v",[prefs integerForKey:@"courseID"]];

    
    
        NSString *strVideoPath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,comp1];
        
          
      
        
        UIImage *img = [self getThumbNail:strVideoPath];
           NSString *comp = [NSString stringWithFormat:@"Thumbnail%d.png",[prefs integerForKey:@"courseID"]];
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:comp];
      // imageView is my image from camera
        NSData *imageData = UIImagePNGRepresentation(img);
    [imageData writeToFile:savedImagePath atomically:NO];
}


-(UIImage *)getThumbNail:(NSString *)stringPath
{
    
            NSURL *videoURL = [NSURL fileURLWithPath:stringPath];
        
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
        
        UIImage *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        
        //Player autoplays audio on init
        [player stop];
        player = nil;
        return thumbnail;
        
}







//-(void)viewWillLayoutSubviews
//{
//    if (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) {
//        
//        [_videoCamera setOutputImageOrientation:UIInterfaceOrientationLandscapeLeft];
//        _videoCamera.horizontallyMirrorFrontFacingCamera = NO;
//        _videoCamera.horizontallyMirrorRearFacingCamera = NO;
//
//        NSLog(@"LandScape");
//        
//    }
//    else
//    {
//             NSLog(@"Potrait");
//
//    }
//
//}


#pragma mark - Action Sheet





#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ([UIImagePNGRepresentation(_bottomImageView.image)isEqualToData:UIImagePNGRepresentation([UIImage imageNamed:@"cameraBottomBar.png"])]) {
        [_stillCamera removeAllTargets];
               
    }
    else if([UIImagePNGRepresentation(_bottomImageView.image)isEqualToData:UIImagePNGRepresentation([UIImage imageNamed:@"videoBottomBar.png"])]) {
        [_videoCamera removeAllTargets];
        
       
    }
    
    // Bail if the cancel button was tapped
    if(actionSheet.cancelButtonIndex == buttonIndex)
    {
        return;
    }
    
    GPUImageFilter *selectedFilter;
    
    
    [_filter removeAllTargets];
    
    
    switch (buttonIndex) {
        case 0:
            selectedFilter = [[GPUImageGrayscaleFilter alloc] init];
            break;
        case 1:
            selectedFilter = [[GPUImageSepiaFilter alloc] init];
            break;
        case 2:
            selectedFilter = [[GPUImageSketchFilter alloc] init];
            break;
        case 3:
            selectedFilter = [[GPUImageMonochromeFilter alloc] init];
            break;
        case 4:
            selectedFilter = [[GPUImageColorInvertFilter alloc] init];
            break;
        case 5:
            selectedFilter = [[GPUImageToonFilter alloc] init];
            break;
        case 6:
            selectedFilter = [[GPUImagePinchDistortionFilter alloc] init];
            break;
        case 7:
            selectedFilter = [[GPUImageFilter alloc] init];
            break;
        default:
            break;
    }
    
    _filter = selectedFilter;
    GPUImageView *filterView = (GPUImageView *)self.cameraView;
    [_filter addTarget:filterView];
    if ([UIImagePNGRepresentation(_bottomImageView.image)isEqualToData:UIImagePNGRepresentation([UIImage imageNamed:@"cameraBottomBar.png"])]) {
        [_stillCamera addTarget:_filter];
        
    }
    else if([UIImagePNGRepresentation(_bottomImageView.image)isEqualToData:UIImagePNGRepresentation([UIImage imageNamed:@"videoBottomBar.png"])]) {
        [_videoCamera addTarget:_filter];

        
        
    }
  
    //     [filter addTarget:movieWriter];
       
}


- (void)viewWillDisappear:(BOOL)animated
{
    // Note: I needed to stop camera capture before the view went off the screen in order to prevent a crash from the camera still sending frames
    [_videoCamera stopCameraCapture];
    
    [super viewWillDisappear:animated];
}

- (IBAction)backButtonPressed:(id)sender {
    
    if (_isRecording) {
        [self stopRecording];
    }
    
    if (!_isRecording) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (IBAction)switchBtnPressed:(id)sender {
    
    if ([UIImagePNGRepresentation(_bottomImageView.image)isEqualToData:UIImagePNGRepresentation([UIImage imageNamed:@"cameraBottomBar.png"])]) {
        
        _isVedio  = TRUE;
          [_bottomImageView setImage:[UIImage imageNamed:@"videoBottomBar.png"]];
        [self startVedioCamera];
        
    }
    else if([UIImagePNGRepresentation(_bottomImageView.image)isEqualToData:UIImagePNGRepresentation([UIImage imageNamed:@"videoBottomBar.png"])]) {
    
    
        _isVedio = FALSE;
        [_bottomImageView setImage:[UIImage imageNamed:@"cameraBottomBar.png"]];
         [self startStillCamera];
    }
}

- (IBAction)captureBtnPressed:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    int temp = 0;
    
    if ([prefs objectForKey:@"courseID"]) {
        
        temp = [prefs integerForKey:@"courseID"];
    }
    else
    {
        temp = 0;
    }
    temp = temp+1;
    
    
    //    [courseEntity setCourseID:[NSNumber numberWithInt:temp]];
    
   //Previous if Condtition
    
   /*
    [UIImagePNGRepresentation(_bottomImageView.image)isEqualToData:UIImagePNGRepresentation([UIImage imageNamed:@"cameraBottomBar.png"])]
    */
    
    if (!_isVedio) {
        
       
         NSString *comp = [NSString stringWithFormat:@"Image%d.png",temp];
        [prefs setInteger:temp forKey:@"courseID"];
        [prefs synchronize];

        UIButton *captureButton = (UIButton *)sender;
        captureButton.enabled = NO;
        
        // Snap Image from GPU camera, send back to main view controller
        [_stillCamera capturePhotoAsJPEGProcessedUpToFilter:_filter withCompletionHandler:^(NSData *processedJPEG, NSError *error)
         {
             
             NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
             NSLog(@"count ios %d",paths.count);
             
             NSString *documentsDirectory = [paths objectAtIndex:0];
             NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:comp];
             if ([[NSFileManager defaultManager] fileExistsAtPath:savedImagePath]) {
                 
                 [[NSFileManager defaultManager]removeItemAtPath:savedImagePath error:nil];
             }
             
             
             [processedJPEG writeToFile:savedImagePath atomically:NO];
            
//             [prefs setInteger:[image1 imageOrientation] forKey:@"kImageOrientation"];
//             [prefs synchronize];
             
             runOnMainQueueWithoutDeadlocking(^{
                 
                 NSLog(@"Clicked");
                 captureButton.enabled = YES;

                 
             });
         }];

    }
    else if(_isVedio) {
        
        /*
         
         [UIImagePNGRepresentation(_bottomImageView.image)isEqualToData:UIImagePNGRepresentation([UIImage imageNamed:@"videoBottomBar.png"])] || [UIImagePNGRepresentation(_bottomImageView.image)isEqualToData:UIImagePNGRepresentation([UIImage imageNamed:@"stopBottomBar.png"])] 
         
         
         */
        
        
        if (!_isRecording) {
            
            [_bottomImageView setImage:[UIImage imageNamed:@"stopBottomBar.png"]];

            [self startRecording];
           
            
        }
        else
        {
            [_bottomImageView setImage:[UIImage imageNamed:@"videoBottomBar.png"]];

            [self stopRecording];
          
        }
        
    }
}

- (IBAction)fitlerBtnPressed:(id)sender {
    
    UIActionSheet *filterActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Filter" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Grayscale", @"Sepia", @"Sketch", @"Mono Color", @"Color Invert", @"Toon", @"Pinch Distort", @"None", nil];
    //    holisgnr@gmail.com  -->janam,10th,vid rashan card,
    [filterActionSheet showFromRect:_settingsBtn.frame inView:self.view animated:YES];
}

- (IBAction)filterBtnPressed:(id)sender {
    
    if (_isVedio) {
        
        
        if (!_isRecording) {
             [_videoCamera removeAllTargets];
            
            int myTag = [(UIButton *)sender tag];
            
            
            GPUImageFilter *selectedFilter;
            
            
            [_filter removeAllTargets];
            
            
            switch (myTag) {
                case 1:
                    selectedFilter = [[GPUImageFilter alloc] init];
                    break;
                    
                case 2:
                    selectedFilter = [[GPUImageGrayscaleFilter alloc] init];
                    break;
                case 3:
                    selectedFilter = [[GPUImageSepiaFilter alloc] init];
                    break;
                case 4:
                    selectedFilter = [[GPUImageSketchFilter alloc] init];
                    break;
                case 5:
                    selectedFilter = [[GPUImageMonochromeFilter alloc] init];
                    break;
                case 6:
                    selectedFilter = [[GPUImageColorInvertFilter alloc] init];
                    break;
                case 7:
                    selectedFilter = [[GPUImageToonFilter alloc] init];
                    break;
                case 8:
                    selectedFilter = [[GPUImagePinchDistortionFilter alloc] init];
                    break;
                default:
                    break;
            }
            
            _filter = selectedFilter;
            GPUImageView *filterView = (GPUImageView *)self.cameraView;
            [_filter addTarget:filterView];

            [_videoCamera addTarget:_filter];

        }
        
        
    }
    else
    {
        [_stillCamera removeAllTargets];
        
        int myTag = [(UIButton *)sender tag];
        
        
        GPUImageFilter *selectedFilter;
        
        
        [_filter removeAllTargets];
        
        
        switch (myTag) {
            case 1:
                selectedFilter = [[GPUImageFilter alloc] init];
                break;
                
            case 2:
                selectedFilter = [[GPUImageGrayscaleFilter alloc] init];
                break;
            case 3:
                selectedFilter = [[GPUImageSepiaFilter alloc] init];
                break;
            case 4:
                selectedFilter = [[GPUImageSketchFilter alloc] init];
                break;
            case 5:
                selectedFilter = [[GPUImageMonochromeFilter alloc] init];
                break;
            case 6:
                selectedFilter = [[GPUImageColorInvertFilter alloc] init];
                break;
            case 7:
                selectedFilter = [[GPUImageToonFilter alloc] init];
                break;
            case 8:
                selectedFilter = [[GPUImagePinchDistortionFilter alloc] init];
                break;
            default:
                break;
        }
        
        _filter = selectedFilter;
        GPUImageView *filterView = (GPUImageView *)self.cameraView;
        [_filter addTarget:filterView];
        
        [_stillCamera addTarget:_filter];

    
    }
}
- (IBAction)flashBtnPressed:(id)sender {
    
    if ([UIImagePNGRepresentation(_topImageView.image)isEqualToData:UIImagePNGRepresentation([UIImage imageNamed:@"TopPart.png"])]) {
       
        
        [_topImageView setImage:[UIImage imageNamed:@"TopOnPart.png"]];
    }
    else if([UIImagePNGRepresentation(_topImageView.image)isEqualToData:UIImagePNGRepresentation([UIImage imageNamed:@"TopOnPart.png"])]) {
        [_topImageView setImage:[UIImage imageNamed:@"TopPart.png"]];

        
        
        
    }

    
}
@end
