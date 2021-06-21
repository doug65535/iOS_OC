//
//  SMPhotoCollectViewCell.m
    
//
//  Created by lucifer on 15/10/9.
 
//

#import "SMPhotoCollectViewCell.h"

@implementation SMPhotoCollectViewCell


-(void)setPhoto:(NSString *)photo
{

    _photo = photo;
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:photo]placeholderImage:[UIImage imageNamed:@"loding_dynamic"] options:SDWebImageRetryFailed|SDWebImageLowPriority];

}

@end
