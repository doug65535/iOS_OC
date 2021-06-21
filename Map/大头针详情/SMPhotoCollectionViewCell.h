//
//  SMPhotoCollectionViewCell.h
    
//
//  Created by lucifer on 15/8/5.
  
//

#import <UIKit/UIKit.h>
#import "SMImg.h"
@interface SMPhotoCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageview;


@property (nonatomic,strong)SMImg *img;

@property(nonatomic,strong)UIImage *image;


@end
