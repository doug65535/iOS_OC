//
//  SMPingLunCustomCell.m
    
//
//  Created by lucifer on 15/8/24.
  
//

#import "SMPingLunCustomCell.h"


@interface SMPingLunCustomCell ()<MLEmojiLabelDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *pinglunTouxiang;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orginHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picHeight;

@property (weak, nonatomic) IBOutlet UILabel *pinglunUser;

@property (weak, nonatomic) IBOutlet UILabel *pinglunTime;

@property (weak, nonatomic) IBOutlet UILabel *laiyuan;
@property (weak, nonatomic) IBOutlet MLEmojiLabel *pinglunBody;



@property (weak, nonatomic) IBOutlet UIImageView *originImage;

@property (weak, nonatomic) IBOutlet UILabel *originDescrib;

@end



@implementation SMPingLunCustomCell


-(CGFloat)rowHeight:(SMPingLun *)status
{
    if (status.message.pictures.count!= 0 || status.message.map) {
        return 362;
    }else{
        return 162;
    }
}

-(void)setStatus:(SMPingLun *)status
{
    _status = status;
    
    if (self.userModel != nil) {
        

        [self.pinglunTouxiang sd_setImageWithURL:[NSURL URLWithString:self.userModel.avatar] placeholderImage:[UIImage imageNamed:@"main_mine"]];
        self.pinglunUser.text = self.userModel.login;
    }else{
    SMAccount *acount = [SMAccount accountFromSandbox];
    [self.pinglunTouxiang sd_setImageWithURL:[NSURL URLWithString:acount.avatar] placeholderImage:[UIImage imageNamed:@"main_mine"]];
    self.pinglunUser.text = acount.login;
    }
    
    self.pinglunBody.delegate = self;
    
    self.pinglunTime.text = status.created_at;
    self.laiyuan.text = status.source;
    self.pinglunBody.text = status.body;

    
    
    
    
    if (status.message.map.snapshot) {
        self.orginHeight.constant = 260;
        self.picHeight.constant = 200;
        
        NSString *strurl = [NSString stringWithFormat:@"%@@1280w_1280h_25Q",status.message.map.snapshot];
        [self.originImage sd_setImageWithURL:[NSURL URLWithString:strurl]];
   
        
    }else if(status.message.pictures.count != 0)
    {
        self.orginHeight.constant = 260;
        self.picHeight.constant = 200;
        
        for (SMPictures *pic in status.message.pictures) {
            NSString *struRl = [NSString stringWithFormat:@"%@@%@w_%@h_25Q",pic.url,pic.width,pic.height];
            [self.originImage sd_setImageWithURL:[NSURL URLWithString:struRl]];
        }
        
        self.originImage.contentMode = UIViewContentModeScaleAspectFill;
        self.originImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.originImage.clipsToBounds = YES;
    }else
    {
        self.orginHeight.constant -= self.picHeight.constant;
        self.picHeight.constant = 0;
    }
    
    
    
    self.originDescrib.text = status.message.body;
}

@end
