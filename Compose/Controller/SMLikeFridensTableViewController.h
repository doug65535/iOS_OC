//
//  SMLikeFridensTableViewController.h
    
//
//  Created by lucifer on 15/7/28.
  
//

#import <UIKit/UIKit.h>

@class SMLikeFridensTableViewController;

@protocol SMLikeFridensTableViewControllerDelegate <NSObject>

-(void)didClickdidSelectWithLikerName:(NSString *)name;



@end


@interface SMLikeFridensTableViewController : UITableViewController


@property(nonatomic,assign)id<SMLikeFridensTableViewControllerDelegate>delegate;

@end
