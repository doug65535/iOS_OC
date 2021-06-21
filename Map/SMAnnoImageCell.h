//
//  SMAnnoImageCell.h
    
//
//  Created by lucifer on 16/3/24.
   
//

#import <UIKit/UIKit.h>

@interface SMAnnoImageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *annoImage;


@property(nonatomic,assign,getter=select1)BOOL select1;

@end
