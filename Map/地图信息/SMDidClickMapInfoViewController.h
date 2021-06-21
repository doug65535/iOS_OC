//
//  SMDidClickMapInfoViewController.h
    
//
//  Created by lucifer on 15/8/3.
  
//

#import <UIKit/UIKit.h>

@class SMDidClickMapInfoViewController;

@protocol SMDidClickMapInfoViewControllerDelegate <NSObject>

-(void)willUpdateMap:(SMCreatMap *)newModel;

@end

@interface SMDidClickMapInfoViewController : UIViewController

@property (nonatomic,strong)SMCreatMap *mapmodel;

@property(nonatomic,strong)SMStatus *model;


@property (strong, nonatomic) IBOutlet UIScrollView *scollview;
@property(nonatomic,weak)id<SMDidClickMapInfoViewControllerDelegate>delegate;
@end
