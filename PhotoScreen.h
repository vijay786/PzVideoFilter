//
//  PhotoScreen.h
//  PzVideoFilter
//
//  Created by necixy on 16/09/13.
//  Copyright (c) 2013 necixy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoScreen : UIViewController<UIScrollViewDelegate>
{
    
}
@property (retain, nonatomic) IBOutlet UIToolbar *toolbar;



@property (retain, nonatomic) IBOutlet UIImageView *photoImageView;
@property (retain, nonatomic) IBOutlet UIScrollView *photoScrollView;
- (IBAction)backButtonPressed:(id)sender;
@property(retain,nonatomic)NSString *imageName;

-(void) showRemotePhoto:(UIImage *)imageName;
@property(retain,nonatomic)UIImage *linkedImage;
@property(retain,nonatomic)NSUserDefaults *prefs;

@property(assign)BOOL saved;

@end
