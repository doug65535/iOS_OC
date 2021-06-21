//
//  SMPhotoCollectionViewCell.m
    
//
//  Created by lucifer on 15/8/5.
  
//

#import "SMPhotoCollectionViewCell.h"

@implementation SMPhotoCollectionViewCell

-(void)setImg:(SMImg *)img
{
    _img = img;
    
//    [self.imageview sd_setImageWithURL:[NSURL URLWithString:img.url]] ;
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:img.url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imageview.image = image;   
}


@end
