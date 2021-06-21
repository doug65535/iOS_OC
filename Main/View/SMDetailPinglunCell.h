//
//  SMDetailPinglunCell.h
    
//
//  Created by lucifer on 15/9/8.
  
//

#import <UIKit/UIKit.h>

@class SMDetailPinglunCell;
@protocol SMDetailPinglunCellDeleagate <NSObject>

-(void)didClickCellImage:(NSInteger)tag;

@optional
-(void)didClickUrl:(SMNavgationController *)nav;

-(void)didclickrenWu:(UIViewController *)rootVc;

-(void)didClickHuati:(UITableViewController *)huatiVc;
@end

@interface SMDetailPinglunCell : UITableViewCell

@property(nonatomic,strong)SMRepies *replayModel;


-(CGFloat)cellHeightWithRelayModel:(SMRepies *)replay;

@property(nonatomic,weak)id<SMDetailPinglunCellDeleagate>deleagete;

@end
