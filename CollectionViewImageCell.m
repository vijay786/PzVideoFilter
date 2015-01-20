//
//  CollectionViewImageCell.m
//  PzVideoFilter
//
//  Created by necixy on 26/09/13.
//  Copyright (c) 2013 necixy. All rights reserved.
//

#import "CollectionViewImageCell.h"



@implementation CollectionViewImageCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupImageView];
    }
    return self;
}

#pragma mark - Create Subviews

- (void)setupImageView {
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(3, 3,144,144)];
    
   
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.thumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(43,43,63,64)];
    [self.thumbImageView setImage:[UIImage imageNamed:@"playBtn_new.png"]];
 
    // Configure the image view here
    [self addSubview:self.imageView];
    [self addSubview:self.thumbImageView];
    
}


@end
