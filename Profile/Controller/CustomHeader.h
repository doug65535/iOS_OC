//
//  CustomHeader.h
//  ARSegmentPager
//
//  Created by August on 15/5/20.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARSegmentPageControllerHeaderProtocol.h"
@interface CustomHeader : UIView<ARSegmentPageControllerHeaderProtocol>

@property UIImageView *imageView;

@end
