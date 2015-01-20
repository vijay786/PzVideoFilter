//
//  KZSxcrollView.m
//  PzVideoFilter
//
//  Created by necixy on 16/09/13.
//  Copyright (c) 2013 necixy. All rights reserved.
//

#import "KZSxcrollView.h"

@interface KZSxcrollView ()

@end

@implementation KZSxcrollView

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
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
     [backButton setTintColor:[UIColor colorWithRed:46/256.0 green:46/256.0 blue:46/256.0 alpha:1.0]];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    
    [_theImageView setImage:_linkedImage];
    [_theImageView setContentMode:UIViewContentModeScaleAspectFit];
    [_theScrollView setContentSize:_theImageView.frame.size];
    
    self.theScrollView.minimumZoomScale = self.theScrollView.frame.size.width / self.theImageView.frame.size.width;
    self.theScrollView.maximumZoomScale = 4.0;
    [self.theScrollView setZoomScale:self.theScrollView.minimumZoomScale];
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _theImageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
