

#import <UIKit/UIKit.h>

@class SMBallScroViewController;

@protocol SMBallScroViewControllerDelegate <NSObject>

- (void)didbuttonPressed:(UIButton *)btn;

@end



@interface SMBallScroViewController : UIViewController


@property(nonatomic,assign)id<SMBallScroViewControllerDelegate>delegate;


@end

