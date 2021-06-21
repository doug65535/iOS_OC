//
//  SMSegmentViewController.h
    
//
//  Created by lucifer on 15/7/30.
  
//

#import <UIKit/UIKit.h>

@class SMSegmentViewController;


@protocol SMSegmentViewControllerDelegate <NSObject>

-(void)didChangeViewAtIndex:(NSInteger)index sender:(UISegmentedControl *)sender;

@end


@interface SMSegmentViewController : UIViewController

@property(nonatomic,assign)id<SMSegmentViewControllerDelegate>delegate;


@property (strong, nonatomic) IBOutlet UISegmentedControl *segement;
- (IBAction)segementChange:(UISegmentedControl *)sender;
@end
