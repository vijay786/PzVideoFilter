//
//  BetterRecordScreen.m
//  PzVideoFilter
//
//  Created by necixy on 23/09/13.
//  Copyright (c) 2013 necixy. All rights reserved.
//

#import "BetterRecordScreen.h"

@interface BetterRecordScreen ()
{
    
   GPUImageOutput<GPUImageInput> *filter;
    GPUImageOutput<GPUImageInput> *blurFilter;
   
    NSUserDefaults *prefs;
     UIImageOrientation staticPictureOriginalOrientation;
    BOOL isVideo;
    BOOL isStatic;
    BOOL hasBlur;
    int selectedFilter;
    BOOL isRecording;
    dispatch_once_t showLibraryOnceToken;
    NSTimer *timer;
    bool g;
    bool isTocuhCancel;
    bool isTouchDown;
    float progress;
    bool isPause;
    BOOL isComplete;
    int i;
    BOOL isFlash;
   
}

@end

@implementation BetterRecordScreen
@synthesize videoCamera,staticPicture,stillCamera,movieWriter,cropFilter;

-(void) sharedInit {
	_outputJPEGQuality = 1.0;
	_requestedImageSize = CGSizeZero;
}

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self sharedInit];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self sharedInit];
	}
	return self;
}

-(id) init {
    return [self initWithNibName:@"BetterRecordScreen" bundle:nil];
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    NSString *deviceType = [[UIDevice currentDevice]platformString];
//    NSLog(@"DEVICE TYPE %@", deviceType);
    
    // Do any additional setup after loading the view from its nib.
    
    [self setDimensions];
    
    
//    g = false;
   
   
    prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setBool:TRUE forKey:@"first"];
    [prefs synchronize];
    
    staticPictureOriginalOrientation = UIImageOrientationUp;
    
    //we need a crop filter for the live video
    cropFilter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f)];
    
    filter = [[GPUImageFilter alloc] init];
    isVideo = FALSE;
    
   [_progressBar setHidden:TRUE];
    [_ylProgressBar setHidden:TRUE];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self setUpVideoCamera:isVideo];
    });
    
}

-(void)setDimensions
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds]
    ;
    
    CGRect bottomFrame = _bottomBar.frame;
    bottomFrame.origin.y = screenBounds.size.height - 54;
    [_bottomBar setFrame:bottomFrame];
    
    
    CGRect switchFrame = _switchBtn.frame;
    switchFrame.origin.y = screenBounds.size.height - 55;
    [_switchBtn setFrame:switchFrame];

    CGRect captureFrame = _captureBtn.frame;
    captureFrame.origin.y = screenBounds.size.height - 55;
    [_captureBtn setFrame:captureFrame];
    
    CGRect backFrame = _backBtn.frame;
    backFrame.origin.y = screenBounds.size.height - 44;
    [_backBtn setFrame:backFrame];


    [_filterScrollView setContentSize:CGSizeMake(900,63)];
    
    if (screenBounds.size.height<481) {
        
        CGRect scrollFrame = _filterScrollView.frame;
        scrollFrame.origin.y = 366;
        [_filterScrollView setFrame:scrollFrame];
        
    }
    else
    {
        CGRect scrollFrame = _filterScrollView.frame;
        scrollFrame.origin.y = 406;
        [_filterScrollView setFrame:scrollFrame];
    
    }
    _ylProgressBar.type  = YLProgressBarTypeRounded;
    _ylProgressBar.progressTintColor = [UIColor colorWithRed:250/256.0 green:172/256.0 blue:48/256.0 alpha:1.0];
    _ylProgressBar.hideStripes  = YES;
    
//    // Select the images to use
//    UIImage *track = [[UIImage imageNamed:@"progressBack.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
//    UIImage *progressImage = [[UIImage imageNamed:@"progressFront.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 1, 1, 1)];
//    // Set the track and progress images
//    [self.progressBar setTrackImage:track];
//    [self.progressBar setProgressImage:progressImage];
//    [self.progressBar setProgressViewStyle:UIProgressViewStyleDefault]; // we don't need anything fancy
//    // Create a bound where you want your image. This places the attached .png bars so that the bar drains downward. I was using this as a countdown bar on the iPhone.
//    self.progressBar.frame = CGRectMake(27, 341,280/1.00, 21);
    // A normal progress bar fills up from left to right. I rotate it so that the bar drains down.
//    self.progressBar.transform = CGAffineTransformMakeRotation((90) * M_PI / 180.0);

}



-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = TRUE;
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [super viewWillAppear:animated];
}


#pragma mark - setUp Camera


-(void)setUpVideoCamera:(BOOL)isVid {
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        // Has camera
        
        if (isVid) {
            
            
            NSLog(@"Stetp 6");
            
            videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
            videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
             [self.flashBtn setEnabled:NO];
            runOnMainQueueWithoutDeadlocking(^{
                
                NSLog(@"Step 7");
                
                [videoCamera startCameraCapture];
                [self prepareFilter];
            });

            
        }
        else
        {
          
            stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack];
            stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
            runOnMainQueueWithoutDeadlocking(^{
                [stillCamera startCameraCapture];
                if([stillCamera.inputCamera hasTorch]){
                    
                    if (isFlash) {
                         [_topImageVIEW setImage:[UIImage imageNamed:@"TopPart.png"]];
                    }
                    else
                    {
                         [_topImageVIEW setImage:[UIImage imageNamed:@"TopOnPart.png"]];
                    
                    }
                    
                    [self.flashBtn setEnabled:YES];
                }else{
                    [_topImageVIEW setImage:[UIImage imageNamed:@"TopPart.png"]];
                    [self.flashBtn setEnabled:NO];
                }
                [self prepareFilter];
            });

        
        
        }
    
    
    } else {
        runOnMainQueueWithoutDeadlocking(^{
      
        });
    }
    
}


-(void) prepareFilter {
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        isStatic = YES;
    }
    
    
    
    
    if (!isStatic) {
        NSLog(@"Step 8");
        
       
        if (![prefs boolForKey:@"first"]) {
            
            [UIView beginAnimations:@"Shutter" context:Nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(stopAnimation)];
            CGRect frame = _topShutterView.frame;
            frame.origin.y = -63;
            [_topShutterView setFrame:frame];
            
            
            CGRect bottomFrame = _BottomShutterView.frame;
            bottomFrame.origin.y=169;
            [_BottomShutterView setFrame:bottomFrame];
            
            [UIView commitAnimations];

            
            
        }
        else
        {
        
             [self prepareLiveFilter:isVideo ];
        }
        [prefs setBool:false forKey:@"first"];
        [prefs synchronize];

        
       
    } else {
          NSLog(@"camera  not Available");
        [self prepareStaticFilter];
    }
}

-(void)stopAnimation
{
    
    NSLog(@"Step 9");

    
    [_topShutterView setHidden:true];
     [_BottomShutterView setHidden:true];
    [_switchBtn setEnabled:YES];
    [_captureBtn setEnabled:YES];
    
     [self prepareLiveFilter:isVideo ];
    
//    CGRect frame = _topShutterView.frame;
//    frame.origin.y+=102;
//    [_topShutterView setFrame:frame];
//    
//    
//    CGRect bottomFrame = _BottomShutterView.frame;
//    bottomFrame.origin.y-=102;
//    [_BottomShutterView setFrame:bottomFrame];

}


-(void)prepareLiveFilter:(BOOL)isVid {
    
    if (isVid) {
       [videoCamera addTarget:filter];
       


        
        
              
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(targetmethod:) userInfo:nil repeats:YES];
        //        progress = 0.0;

    }
    else
        [stillCamera addTarget:cropFilter];
    
    [cropFilter addTarget:filter];
    //blur is terminal filter
    if (hasBlur) {
//        [filter addTarget:blurFilter];
//        [blurFilter addTarget:self.imageView];
        //regular filter is terminal
    } else {
        [filter addTarget:self.gpuImageView];
    }
    
    [filter prepareForImageCapture];
    
}

-(void) prepareStaticFilter {
    
    [staticPicture addTarget:filter];
    
    // blur is terminal filter
    if (hasBlur) {
//        [filter addTarget:blurFilter];
//        [blurFilter addTarget:self.imageView];
        //regular filter is terminal
    } else {
        [filter addTarget:self.gpuImageView];
    }
    
    GPUImageRotationMode imageViewRotationMode = kGPUImageNoRotation;
    switch (staticPictureOriginalOrientation) {
        case UIImageOrientationLeft:
            imageViewRotationMode = kGPUImageRotateLeft;
            break;
        case UIImageOrientationRight:
            imageViewRotationMode = kGPUImageRotateRight;
            break;
        case UIImageOrientationDown:
            imageViewRotationMode = kGPUImageRotate180;
            break;
        default:
            imageViewRotationMode = kGPUImageNoRotation;
            break;
    }
    
    // seems like atIndex is ignored by GPUImageView...
    [self.gpuImageView setInputRotation:imageViewRotationMode atIndex:0];
    
    
    [staticPicture processImage];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Image Capture

- (IBAction)captureBtnPressed:(id)sender {
    
//    if (isRecording && isVideo ) {
//        
//        [self stopRecording];
//    }
//    else 
//    {
    
    NSLog(@"called once or regular");
    
    if (!isVideo) {
        [self.captureBtn setEnabled:NO];
        
        [self.flipCamera setEnabled:NO];
        [self.flashBtn setEnabled:NO];
        [self prepareForCapture];
    }
       

    
//    }
    
    g = false;
    
    
}

- (IBAction)buttonTouchedOutside:(id)sender {

     g = false;


}

- (IBAction)captureTouchDown:(id)sender {
    
    if (isVideo) {
        
        NSLog(@"are you coming in this");
        
        [self.captureBtn setEnabled:NO];
        
        [self.flipCamera setEnabled:NO];
        [self.flashBtn setEnabled:NO];
        [self prepareForCapture];

    }
    
     isTouchDown = true;
    isTocuhCancel = false;
   
    
}

- (IBAction)captureTouchCancel:(id)sender {
    
    isTouchDown = false;
    isTocuhCancel = TRUE;

    
}

-(void)targetmethod:(id)sender {
    if (isTouchDown == true) {
        //This is for "Touch and Hold"
      
        NSLog(@"recording %f",CMTimeGetSeconds(movieWriter.duration));
        

            if (CMTimeGetSeconds(movieWriter.duration)<30.0) {
                
                
//                progress = progress + CMTimeGetSeconds(movieWriter.duration);
                [_ylProgressBar setProgress:CMTimeGetSeconds(movieWriter.duration)/29.0 animated:YES];
                
                
            }
            else
            {
                isComplete = TRUE;
                [timer invalidate];
                timer = nil;
                [self stopRecording];
                
            }

             
    }
    else if(isTocuhCancel){
        //This is for the person is off the button.
       
        
        if (isRecording) {
            isPause = TRUE;
            isTocuhCancel = false;
            [self stopRecording];
           
        }
        
    }
}



-(void) prepareForCapture {
    
    if (isVideo) {
        
        [videoCamera.inputCamera lockForConfiguration:nil];
        [self.captureBtn setEnabled:YES];
        if(self.flashBtn.selected &&
           [videoCamera.inputCamera hasTorch]){
//            [videoCamera.inputCamera setTorchMode:AVCaptureTorchModeOn];
            [self performSelector:@selector(captureImage)
                       withObject:nil
                       afterDelay:0.25];
        }else{
            
            
            NSLog(@"else capture image");
            
            [self captureImage];
        }

        
    }
    else
    {
        isStatic = YES;
        
        [stillCamera.inputCamera lockForConfiguration:nil];
        if(self.flashBtn.selected &&
           [stillCamera.inputCamera hasTorch]){
                     [self performSelector:@selector(captureImage)
                       withObject:nil
                       afterDelay:0.25];
        }else{
            [self captureImage];
        }

    
    }


}

-(void)captureImage {
    
    if(!isVideo)
    {
        
        if (isFlash) {
            [stillCamera.inputCamera lockForConfiguration:nil];
            [stillCamera.inputCamera setFlashMode:AVCaptureFlashModeOn];
        }
        
        void (^completion)(UIImage *, NSError *) = ^(UIImage *img, NSError *error) {
            
            [stillCamera.inputCamera unlockForConfiguration];
            [stillCamera stopCameraCapture];
            [self removeAllTargets];
            
            staticPicture = [[GPUImagePicture alloc] initWithImage:img smoothlyScaleOutput:NO];
            staticPictureOriginalOrientation = img.imageOrientation;
            
            [self prepareFilter];
            [self donePressed];
            
        };
        
        
        AVCaptureDevicePosition currentCameraPosition = stillCamera.inputCamera.position;
        Class contextClass = NSClassFromString(@"GPUImageContext") ?: NSClassFromString(@"GPUImageOpenGLESContext");
        if ((currentCameraPosition != AVCaptureDevicePositionFront) || (![contextClass supportsFastTextureUpload])) {
            // Image full-resolution capture is currently possible just on the final (destination filter), so
            // create a new paralel chain, that crops and resizes our image
            [self removeAllTargets];
            
            GPUImageCropFilter *captureCrop = [[GPUImageCropFilter alloc] initWithCropRegion:cropFilter.cropRegion];
            [stillCamera addTarget:captureCrop];
            GPUImageFilter *finalFilter = captureCrop;
            
            if (!CGSizeEqualToSize(_requestedImageSize, CGSizeZero)) {
                GPUImageFilter *captureResize = [[GPUImageFilter alloc] init];
                [captureResize forceProcessingAtSize:_requestedImageSize];
                [captureCrop addTarget:captureResize];
                finalFilter = captureResize;
            }
            
            [finalFilter prepareForImageCapture];
            
            [stillCamera capturePhotoAsImageProcessedUpToFilter:finalFilter withCompletionHandler:completion];
        } else {
            // A workaround inside capturePhotoProcessedUpToFilter:withImageOnGPUHandler: would cause the above method to fail,
            // so we just grap the current crop filter output as an aproximation (the size won't match trough)
            UIImage *img = [cropFilter imageFromCurrentlyProcessedOutput];
            completion(img, nil);
        }

      
    }
    else
    {
//        [videoCamera.inputCamera lockForConfiguration:nil];
//        [videoCamera.inputCamera setFlashMode:AVCaptureFlashModeOn];
//        [videoCamera.inputCamera setTorchMode:AVCaptureTorchModeOn];
        
        if (movieWriter!=nil) {
            
            movieWriter = nil;
        }
        
        
        NSArray *arrayPaths =
        NSSearchPathForDirectoriesInDomains(
                                            NSDocumentDirectory,
                                            NSUserDomainMask,
                                            YES);
        NSString *path = [arrayPaths objectAtIndex:0];
        
        NSLog(@"contents %@",[[NSFileManager defaultManager]contentsOfDirectoryAtPath:path error:nil]);
        
        
        int temp = 0;
        
        if ([prefs objectForKey:@"courseID"]) {
            
            temp = [prefs integerForKey:@"courseID"];
        }
        else
        {
            temp = 0;
        }
          NSLog(@"temp before incrementing  is %d",temp);
        temp = temp+1;
        
        NSLog(@"temp is %d",temp);
        //    [courseEntity setCourseID:[NSNumber numberWithInt:temp]];
        
        NSString *comp = [NSString stringWithFormat:@"Movie%d.m4v",temp];
        
        NSString *folderName1 = @"Originals/";
        
//        NSString *folderName2 = @"Thumbnails/";
        
        
        NSString *dataPath1 = [path stringByAppendingPathComponent:folderName1];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath1])
            [[NSFileManager defaultManager] createDirectoryAtPath:dataPath1 withIntermediateDirectories:NO attributes:nil error:nil];
        
       
        
        
        NSString* pdfFileName = [dataPath1 stringByAppendingPathComponent:comp];
        [prefs setInteger:temp forKey:@"courseID"];
        [prefs synchronize];
        if ([[NSFileManager defaultManager] fileExistsAtPath:pdfFileName]) {
            
            [[NSFileManager defaultManager]removeItemAtPath:pdfFileName error:nil];
        }

        NSURL *movieURL = [NSURL fileURLWithPath:pdfFileName];

        movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0,640.0)];

        [filter addTarget:movieWriter];
        
        videoCamera.audioEncodingTarget = movieWriter;
        [movieWriter startRecording];
        isRecording = TRUE;
        NSLog(@"Start Recording");
    }
}

-(void)stopRecording
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Preparing Video";
    
    
    videoCamera.audioEncodingTarget = nil;
    [movieWriter finishRecordingWithCompletionHandler:^{
        NSLog(@"finished %f",CMTimeGetSeconds(movieWriter.duration));
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    [filter removeTarget:movieWriter];
    [videoCamera stopCameraCapture];
    [videoCamera removeTarget:filter];
    videoCamera = nil;
    
    
    NSLog(@"stop Recording");
    
    isRecording = false;

    NSLog(@"isCompleter");
    
    [self populateThumnailArray];
    
}
#pragma mark - Get Thumbnails


-(void)populateThumnailArray
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    NSError * error;
    //    NSMutableArray *directoryContents =  (NSMutableArray *)[[[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error] mutableCopy];
    
    //Take all images in NSMutableArray
    
    NSString *comp1 = [NSString stringWithFormat:@"Movie%d.m4v",[prefs integerForKey:@"courseID"]];
    
     NSString *folderName1 = @"Originals/";
    NSString *folderName2 = @"Thumbnails/";
    
    
    NSString *dataPath1 = [documentsDirectory stringByAppendingPathComponent:folderName1];

    
    NSString *strVideoPath = [NSString stringWithFormat:@"%@/%@",dataPath1,comp1];
    
    NSString *dataPath2 = [documentsDirectory stringByAppendingPathComponent:folderName2];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath2])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath2 withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSLog(@"URL : %@",[NSURL URLWithString:strVideoPath]);
    NSData *data = [NSData dataWithContentsOfFile:strVideoPath];
    NSLog(@"%@",[NSByteCountFormatter stringFromByteCount:data.length countStyle:NSByteCountFormatterCountStyleFile]);
    
    
    
    UIImage *img = [self getThumbNail:strVideoPath];
    NSString *comp = [NSString stringWithFormat:@"Thumbnail%d.png",[prefs integerForKey:@"courseID"]];
    NSString *savedImagePath = [dataPath2 stringByAppendingPathComponent:comp];
    // imageView is my image from camera
    NSData *imageData = UIImageJPEGRepresentation(img,0.5);
    [imageData writeToFile:savedImagePath atomically:NO];
    img = nil;
    [self.delegate getVideoFromPath:strVideoPath];
}

-(UIImage *)getThumbNail:(NSString *)stringPath
{
    
    NSURL *videoURL = [NSURL fileURLWithPath:stringPath];
    
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    
    UIImage *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    UIImage *resizeImage = [thumbnail resizedImageToSize:CGSizeMake(144,144)];
    thumbnail  = nil;
    //Player autoplays audio on init
    [player stop];
    player = nil;
    return resizeImage;
    
}



-(void)donePressed
{
    GPUImageOutput<GPUImageInput> *processUpTo;
    
    if (hasBlur) {
        processUpTo = blurFilter;
    } else {
        processUpTo = filter;
    }
    
    [staticPicture processImage];
    
    UIImage *currentFilteredVideoFrame = [processUpTo imageFromCurrentlyProcessedOutputWithOrientation:staticPictureOriginalOrientation];
    
    UIImage *resizeImage = [currentFilteredVideoFrame resizedImageToSize:CGSizeMake(144,144)];
    
    
    NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:
                          UIImageJPEGRepresentation(currentFilteredVideoFrame, self.outputJPEGQuality), @"Largedata",UIImageJPEGRepresentation(resizeImage,0.5),@"Smalldata", nil];
    
    resizeImage = nil;
    
    [self.delegate imagePickerController:self didFinishPickingMediaWithInfo:info];
    
}

-(void) dealloc {
    [self removeAllTargets];
    videoCamera = nil;
    stillCamera = nil;
    cropFilter = nil;
    filter = nil;
    blurFilter = nil;
    staticPicture = nil;
//    self.blurOverlayView = nil;
//    self.focusView = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [stillCamera stopCameraCapture];
    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}



#pragma mark - Filter Btn Pressed

- (IBAction)filterBtnPressed:(id)sender {
    
    int myTag = [(UIButton *)sender tag];
    
    [self removeAllTargets];
    
    selectedFilter = myTag;
    [self setFilter:myTag];
    [self prepareFilter];

}

-(void) removeAllTargets {
    [stillCamera removeAllTargets];
    [videoCamera removeAllTargets];
    [staticPicture removeAllTargets];
    [cropFilter removeAllTargets];
    
    //regular filter
    [filter removeAllTargets];
    
    //blur
//    [blurFilter removeAllTargets];
}

-(void) setFilter:(int) index {
    switch (index) {
        case 1:
            filter = [[GPUImageFilter alloc] init];
            break;
        case 2:
            filter = [[GPUImageGrayscaleFilter alloc] init];
            break;
        case 3:
            filter = [[GPUImageSepiaFilter alloc] init];
            break;
        case 4:
            filter = [[GPUImageSketchFilter alloc] init];
            break;
        case 5:
            filter = [[GPUImageMonochromeFilter alloc] init];
            break;
        case 6:
            filter = [[GPUImageColorInvertFilter alloc] init];
            break;
        case 7:
            filter = [[GPUImageToonFilter alloc] init];
            break;
        case 8:
            filter = [[GPUImagePinchDistortionFilter alloc] init];
            break;
        case 9:
            filter = [[GPUImageDilationFilter alloc] init];
            break;
        case 10:
            filter = [[GPUImageEmbossFilter alloc] init];
            break;
        case 11:
            filter = [[GPUImageBulgeDistortionFilter alloc] init];
            break;
        case 12:
            filter = [[GPUImagePosterizeFilter alloc] init];
            break;
        case 13:
            filter = [[GPUImageHalftoneFilter alloc] init];
            break;
        case 14:
            filter = [[GPUImagePolkaDotFilter alloc] init];
            break;
        case 15:
            filter = [[GPUImageSwirlFilter alloc] init];
            break;
        default:
            break;
    }
}


#pragma mark - Camera Tools

- (IBAction)switchBtnPressed:(id)sender
{
    NSLog(@"Step Ist");
    [_captureBtn setEnabled:NO];

    [_switchBtn setEnabled:NO];
    [self removeAllTargets];
    
    NSLog(@"Step 2nd");
    
    videoCamera = nil;
    movieWriter = nil;
    stillCamera = nil;
    cropFilter = nil;
    filter = nil;
    blurFilter = nil;
    staticPicture = nil;
    
    NSLog(@"Step 3");
    
    if ([UIImagePNGRepresentation(_bottomBar.image)isEqualToData:UIImagePNGRepresentation([UIImage imageNamed:@"cameraBottomBar.png"])]) {
        
        [_topImageVIEW setImage:[UIImage imageNamed:@"TopPart.png"]];
        [_flashBtn setEnabled:NO];
        isVideo  = TRUE;
            [_ylProgressBar setHidden:false];
        [_topShutterView setHidden:false];
        [_BottomShutterView setHidden:false];
        
        [_bottomBar setImage:[UIImage imageNamed:@"videoBottomBar.png"]];
        
    }
    else if([UIImagePNGRepresentation(_bottomBar.image)isEqualToData:UIImagePNGRepresentation([UIImage imageNamed:@"videoBottomBar.png"])] || [UIImagePNGRepresentation(_bottomBar.image)isEqualToData:UIImagePNGRepresentation([UIImage imageNamed:@"stopBottomBar.png"])]) {
        
        if (timer.isValid) {
            [timer invalidate];
            timer = nil;
        }
        isVideo = FALSE;
        progress = 0;
        [_topShutterView setHidden:false];
        [_BottomShutterView setHidden:false];

//        [UIView beginAnimations:@"Shutter" context:Nil];
//        [UIView setAnimationDuration:0.3];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationDidStopSelector:@selector(setUp)];
//        CGRect frame = _topShutterView.frame;
//        frame.origin.y=63;
//        [_topShutterView setFrame:frame];
//        
//        
//        CGRect bottomFrame = _BottomShutterView.frame;
//        bottomFrame.origin.y= 57 ;
//        [_BottomShutterView setFrame:bottomFrame];
//        
//        [UIView commitAnimations];

        
        
        [_ylProgressBar setHidden:TRUE];
        [_bottomBar setImage:[UIImage imageNamed:@"cameraBottomBar.png"]];
        
        
        
    }
    [UIView beginAnimations:@"Shutter" context:Nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(setUp)];
    CGRect frame = _topShutterView.frame;
    frame.origin.y = 63;
    [_topShutterView setFrame:frame];
    
    
    CGRect bottomFrame = _BottomShutterView.frame;
    bottomFrame.origin.y=57;
    [_BottomShutterView setFrame:bottomFrame];
    
    [UIView commitAnimations];
    
}


//- (NSString *) platformString
//{
//    NSString *platform =  [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
//    NSLog(@"type ...%@", platform);
//    
//    
//    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
//    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
//    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
//    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
//    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
//    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
//    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
//    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
//    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
//    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
//    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
//    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
//    if ([platform isEqualToString:@"i386"])         return @"Simulator";
//    return platform;
//}

-(void)setUp
{
    NSLog(@"Step 4");
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkTime) userInfo:Nil repeats:NO];

}



-(void)checkTime
{
    if (!isVideo) {
        cropFilter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.0f,0.0f,1.0f,1.0f)];
        
    }
    
    filter = [[GPUImageFilter alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSLog(@"Step 5");
        
        [self setUpVideoCamera:isVideo];
    });

    
}

- (IBAction)backBtnPressed:(id)sender {
    
    [self.delegate imagePickerControllerDidCancel:self];

    
}
- (IBAction)flipCameraPressed:(id)sender {
    

    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] && stillCamera && !isVideo) {
        
        [self.flipCamera setEnabled:NO];
        [stillCamera rotateCamera];
        [self.flipCamera setEnabled:YES];
        
        if ([stillCamera.inputCamera hasFlash] && [stillCamera.inputCamera hasTorch]) {
        
            [self.flashBtn setEnabled:YES];
//            [_topImageVIEW setImage:[UIImage imageNamed:@"TopOnPart.png"]];
            [self.flipCamera setEnabled:YES];
        } else {
               [_topImageVIEW setImage:[UIImage imageNamed:@"TopPart.png"]];
            [self.flashBtn setEnabled:NO];
            [self.flipCamera setEnabled:YES];
        }
    }
    else if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] && videoCamera && isVideo)
    {
        
        [self.flipCamera setEnabled:NO];
        [videoCamera rotateCamera];
        [self.flipCamera setEnabled:YES];
        
        [_flashBtn setEnabled:false];
        [_topImageVIEW setImage:[UIImage imageNamed:@"TopPart.png"]];
//        if ([videoCamera.inputCamera hasFlash] && [videoCamera.inputCamera hasTorch]) {
//            [_topImageVIEW setImage:[UIImage imageNamed:@"TopOnPart.png"]];
//            [self.flipCamera setEnabled:YES];
//        } else {
//               [_topImageVIEW setImage:[UIImage imageNamed:@"TopPart.png"]];
//             [self.flipCamera setEnabled:YES];
//        }
    
    }

    
}
- (IBAction)flashBtnPressed:(id)sender {
    
//    UIButton *button = (UIButton *)sender;
//      [button setSelected:!button.selected];
    
   
    
    
     if ([UIImagePNGRepresentation(_topImageVIEW.image)isEqualToData:UIImagePNGRepresentation([UIImage imageNamed:@"TopPart.png"])]) {
         
         isFlash = TRUE;
          [_topImageVIEW setImage:[UIImage imageNamed:@"TopOnPart.png"]];
         
     }
    else if([UIImagePNGRepresentation(_topImageVIEW.image)isEqualToData:UIImagePNGRepresentation([UIImage imageNamed:@"TopOnPart.png"])])
    {
        isFlash = false;
         [_topImageVIEW setImage:[UIImage imageNamed:@"TopPart.png"]];
    
    }
}


@end
