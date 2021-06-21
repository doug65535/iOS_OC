//
//  SMPingLunViewController.h
    
//
//  Created by lucifer on 15/7/28.
  
//

#import <UIKit/UIKit.h>
#import "SMRepies.h"

#import "SMInputToolbar.h"


#import "SMInputTextView.h"

@class SMPingLunViewController;

@protocol SMPingLunViewControllerDelegate <NSObject>

-(void)didFinishPinglun;

@end


@interface SMPingLunViewController : UIViewController

@property (nonatomic,strong)SMStatus *modle;

/**
 *  自定义输入框
 */
@property (nonatomic, weak) SMInputTextView *inputView;
/**
 *  自定义工具条
 */
@property (nonatomic, weak) SMInputToolbar *toolbar;
/**
 *  输入框容器
 */
@property (weak, nonatomic) IBOutlet UIView *inputViewContainer;





@property(nonatomic,assign)id<SMPingLunViewControllerDelegate>delegate;




@property(nonatomic,strong)SMRepies *reply;



@end
