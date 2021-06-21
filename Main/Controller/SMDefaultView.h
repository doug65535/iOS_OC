//
//  SMDefaultView.h
    
//
//  Created by lucifer on 15/7/19.
  
//

#import <UIKit/UIKit.h>


@class SMDefaultView;

@protocol SMDefaultViewDelegate <NSObject>

- (void)defaultViewDidClickRegister;
@optional

- (void)defaultViewDidCLickLogin;


-(void)defaultViewDidCLickWeiboLogin:(UIView *)View;
-(void)defaultViewDidCLickweiXinLogin;
-(void)defaultViewDidCLickQQLogin;
//



@end


@interface SMDefaultView : UIView

@property(nonatomic,weak)id <SMDefaultViewDelegate> delegate;



+(instancetype) defaultView;


@end
