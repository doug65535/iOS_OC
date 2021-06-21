//
//  TableViewController.h
//  ARSegmentPager
//
//  Created by August on 15/3/28.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARSegmentPageController.h"

@interface SMPofileMapCreatVc : UITableViewController<ARSegmentControllerDelegate>


@property(nonatomic,strong)SMUser *userModel;
@end
