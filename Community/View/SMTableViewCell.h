//
//  SMTableViewCell.h
    
//
//  Created by lucifer on 15/7/20.
  
//

#import <UIKit/UIKit.h>
#import "SMPhotoCollectViewCell.h"
@class SMTableViewCell;

@protocol SMTableViewCellDelegate <NSObject>

- (void)cell:(SMTableViewCell *)cell didClickpinglun:(UIButton *)pinglunBtn status:(SMStatus *)status;

- (void)cell:(SMTableViewCell *)cell didClickfenxaing:(UIButton *)fenxiangBtn status:(SMStatus *)status icon:(SMPhotoCollectViewCell *)collectCell;


-(void)didClickUnLoginZan;

-(void)didclickunloginShoucang;

@optional
-(void)didDelegateBlog:(SMStatus *)status;

-(void)didClickMapPicture:(SMStatus *)status shareImage:(UIImage *)img;
@end


@interface SMTableViewCell : UITableViewCell



@property(nonatomic,weak)id <SMTableViewCellDelegate> delegate;


@property(nonatomic,getter=isFromBlog)BOOL isFromBlog;

@property (strong, nonatomic) IBOutlet UIView *cellContent;
@property (strong, nonatomic) IBOutlet UIView *toolView;

@property (nonatomic,strong)SMStatus *status;


//@property (strong, nonatomic) IBOutlet NSLayoutConstraint *picHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cellContentHeight;



@property (strong, nonatomic) IBOutlet UIImageView *touxiang;
@property (strong, nonatomic) IBOutlet UILabel *user_name;
@property (strong, nonatomic) IBOutlet UILabel *fireTime;

//@property (strong, nonatomic) IBOutlet UIImageView *ditu;

@property (strong, nonatomic) IBOutlet MLEmojiLabel *body;



-(CGFloat)cellHeightWithStatus:(SMStatus *)status;


@end
