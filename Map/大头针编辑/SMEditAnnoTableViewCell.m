//
//  SMEditAnnoTableViewCell.m
    
//
//  Created by lucifer on 16/1/29.
   
//

#import "SMEditAnnoTableViewCell.h"
@interface SMEditAnnoTableViewCell()
- (IBAction)end:(id)sender;

@end

@implementation SMEditAnnoTableViewCell

- (IBAction)end1:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)awakeFromNib {
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





- (IBAction)end:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
@end
