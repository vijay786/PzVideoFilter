//
//  KZSxcrollView.h
//  PzVideoFilter
//
//  Created by necixy on 16/09/13.
//  Copyright (c) 2013 necixy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZSxcrollView : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *theScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *theImageView;
- (IBAction)backButtonPressed:(id)sender;
@property(strong,nonatomic)UIImage *linkedImage;

@end
