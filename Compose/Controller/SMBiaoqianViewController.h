//
//  ViewController.h
//  ZFTokenFieldDemo
//
//  Created by Amornchai Kanokpullwad on 11/11/2014.
//  Copyright (c) 2014 Amornchai Kanokpullwad. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SMBiaoqianViewController;

@protocol SMBiaoqianViewControllerDelegate <NSObject>

-(void)didClickSendBtnWithToken:(NSString *)token;

@end

@interface SMBiaoqianViewController : UIViewController

@property(nonatomic,assign)id<SMBiaoqianViewControllerDelegate>delegate;

@end

