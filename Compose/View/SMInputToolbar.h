
#import <UIKit/UIKit.h>


@class SMInputToolbar;

@protocol SMInputToolbarDelegate <NSObject>



-(void)didClickEmoji;


-(void)didclickmentionbutton;

@end

@interface SMInputToolbar : UIView

@property (nonatomic,retain) id<SMInputToolbarDelegate>delegate;

@end
