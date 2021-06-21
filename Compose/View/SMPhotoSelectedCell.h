
#import <UIKit/UIKit.h>



@class SMPhotoSelectedCell;
@protocol SMPhotoSelectedCellDelegate <NSObject>

-(void)addPhoto;
-(void)deletePhoto:(SMPhotoSelectedCell *)cell;

@end

@interface SMPhotoSelectedCell : UICollectionViewCell

/**
 *  接受外界传入的数据
 */
@property (nonatomic, strong) UIImage *iconImage;
/**
 *  当前cell对应的索引
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

@property(nonatomic,weak)id<SMPhotoSelectedCellDelegate>delegate;

@end
