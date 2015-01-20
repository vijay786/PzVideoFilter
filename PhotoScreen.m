//
//  PhotoScreen.m
//  PzVideoFilter
//
//  Created by necixy on 16/09/13.
//  Copyright (c) 2013 necixy. All rights reserved.
//

#import "PhotoScreen.h"

@interface PhotoScreen ()

@end

@implementation PhotoScreen
@synthesize toolbar;

@synthesize photoImageView,saved,prefs;

@synthesize photoScrollView,imageName,linkedImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return photoImageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.navigationController.navigationBarHidden=TRUE;
    // 	[[UIApplication sharedApplication]setStatusBarHidden:TRUE];
	photoImageView.contentMode = UIViewContentModeCenter;
     [self showRemotePhoto:linkedImage];
	
//	photoScrollView.contentSize = CGSizeMake(photoImageView.frame.size.width, photoImageView.frame.size.height);
	photoScrollView.maximumZoomScale = 4.0;
	photoScrollView.minimumZoomScale = 1.0;
    photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//	photoScrollView.clipsToBounds = YES;
	
	
    
   
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    
    [self setPhotoImageView:nil];
    [self setPhotoScrollView:nil];
    
    
    [self setToolbar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)backButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) showRemotePhoto:(UIImage *)linkImage
{
    
    //  ratingBarButtonItem.title=[NSString stringWithFormat:@"%0.2f/5",rating];
    //  photoImageView.loadingWheel.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhite;
	//[photoImageView showLoadingWheel];
    
    // photoImageView.loadingWheel.center=CGPointMake(160, 160); // so that loadingwheel comes in middle
	photoImageView.image=linkImage;
    //photoImageView.url = photoURL;
    photoImageView.contentMode=UIViewContentModeScaleAspectFit;
    //photoImageView.imageView.frame=photoImageVi
	//[self.objManager manage:photoImageView];
    
}



@end
