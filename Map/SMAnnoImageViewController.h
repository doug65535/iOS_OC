//
//  SMAnnoImageViewController.h
    
//
//  Created by lucifer on 16/3/24.
   
//

#import <UIKit/UIKit.h>


@class SMAnnoImageViewController;
@protocol SMAnnoImageViewControllerDelegate <NSObject>

-(void)finalUrlPass:(NSString *)finalUrl :(NSInteger)indexItem1 :(NSInteger)indexItem2 :(NSInteger)indexItem3 :(NSInteger)selectindex;


@end

@interface SMAnnoImageViewController : UIViewController

@property(nonatomic,assign)id<SMAnnoImageViewControllerDelegate>delegate;


@property(nonatomic,assign)NSInteger indexItem1;
@property(nonatomic,assign)NSInteger indexItem2;
@property(nonatomic,assign)NSInteger indexItem3;

@property(nonatomic,copy)NSString *finalStr;
@property(nonatomic,assign)NSInteger selectindex;
@end
