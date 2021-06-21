

#import <UIKit/UIKit.h>
//@class SMMComposeViewController;
//@protocol SMMComposeViewControllerDelegate <NSObject>
//
//-(void)didFinishCompose;

//@end


@interface SMMComposeViewController : UIViewController

//@property(nonatomic,weak)id<SMMComposeViewControllerDelegate>delegate;

#define SMFinishCompose @"SMFinishCompose"


@property(nonatomic,getter=isFromSuggestion) BOOL isFromSuggestion;



@end
