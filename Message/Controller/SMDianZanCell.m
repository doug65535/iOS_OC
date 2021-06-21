//
//  SMDianZanCell.m
    
//
//  Created by lucifer on 15/8/25.
  
//

#import "SMDianZanCell.h"


@interface SMDianZanCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picHeight;
@property (weak, nonatomic) IBOutlet UIImageView *pinglunTouxiang;

@property (weak, nonatomic) IBOutlet UILabel *pinglunUser;
@property (weak, nonatomic) IBOutlet UILabel *fireTime;

@property (weak, nonatomic) IBOutlet UILabel *pinglunTime;


@property (weak, nonatomic) IBOutlet UILabel *pinglunBody;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@property (weak, nonatomic) IBOutlet UIImageView *originImage;


@property (weak, nonatomic) IBOutlet MLEmojiLabel *originDescrib;



@end
@implementation SMDianZanCell

-(void)setStatus1:(SMNotifications *)status1
{
    self.originDescrib.textColor = [UIColor lightGrayColor];
    
    self.originImage.contentMode = UIViewContentModeScaleAspectFill;
    self.originImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.originImage.clipsToBounds = YES;
        _status1 = status1;
//    上面都显示@的内容
//    下面都显示帖子
      self.pinglunTime.text = status1.created_at;
    if (status1.message) {
        [self.pinglunTouxiang sd_setImageWithURL:[NSURL URLWithString:status1.message.user.avatar]];
        self.pinglunUser.text = status1.message.user.login;
        self.pinglunBody.text = status1.message.body;
         self.originDescrib.text = status1.message.body;
        self.fireTime.text = status1.message.created_at;

        
        
        if (status1.message.map) {
            self.picHeight.constant = 200;
            self.contentHeight.constant = 260;
            
            NSString *strurl = [NSString stringWithFormat:@"%@@1280w_1280h_25Q",status1.message.map.snapshot];
            [self.originImage sd_setImageWithURL:[NSURL URLWithString:strurl]];
          
            
        }else if (status1.message.pictures.count != 0)
        {
            
            self.picHeight.constant = 200;
            self.contentHeight.constant = 260;
            
            for (SMPictures *pic in status1.message.pictures) {
                
                NSString *strurl = [NSString stringWithFormat:@"%@@%@w_%@h_25Q",pic.url,pic.width,pic.height];
                [self.originImage sd_setImageWithURL:[NSURL URLWithString:strurl]];
           
            }
            
        }else{
            
            self.contentHeight.constant = self.contentHeight.constant - self.picHeight.constant;
            self.picHeight.constant = 0;
            
        }

        
    }else{
        
        
        [self.pinglunTouxiang sd_setImageWithURL:[NSURL URLWithString:status1.reply.user.avatar]];
        self.pinglunUser.text = status1.reply.user.login;
        self.pinglunBody.text = status1.reply.body;
        
        self.originDescrib.text = status1.reply.message.body;
        self.fireTime.text = status1.reply.message.created_at;

        
        
        
        if (status1.reply.message.map) {
            self.picHeight.constant = 200;
            self.contentHeight.constant = 260;
            
//         NSString *strurl = [NSString stringWithFormat:@"%@1280w_1280h_25Q",status1.reply.message.map.snapshot];
//            SMLog(@"%@",strurl);
            [self.originImage sd_setImageWithURL:[NSURL URLWithString:status1.reply.message.map.snapshot]];
         
            
        }else if (status1.reply.message.pictures.count != 0)
        {
            
            self.picHeight.constant = 200;
            self.contentHeight.constant = 260;
          
            for (SMPictures *pic in status1.reply.message.pictures) {
                NSString *strurl = [NSString stringWithFormat:@"%@@%@w_%@h_25Q",pic.url,pic.width,pic.height];
                [self.originImage sd_setImageWithURL:[NSURL URLWithString:strurl]];
           
            }
            
        }else{
            
            self.contentHeight.constant = self.contentHeight.constant - self.picHeight.constant;
            self.picHeight.constant = 0;
            
        }
    }
    
}
-(void)setStatus:(SMNotifications *)status
{
    _status = status;
     self.originDescrib.textColor = [UIColor lightGrayColor];
    
    [self.pinglunTouxiang sd_setImageWithURL:[NSURL URLWithString:status.like_user.avatar]];
    self.pinglunUser.text = status.like_user.login;
    self.pinglunTime.text = status.created_at;
  
    self.originImage.contentMode = UIViewContentModeScaleAspectFill;
    self.originImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.originImage.clipsToBounds = YES;
    
    if (status.message) {
          self.pinglunBody.text = @"赞了你的动态";
        self.originDescrib.text = status.message.body;
        self.fireTime.text = status.message.created_at;
        if (status.message.map) {
            self.picHeight.constant = 200;
            self.contentHeight.constant = 260;
            
            NSString *strurl = [NSString stringWithFormat:@"%@@1280w_1280h_25Q",status.message.map.snapshot];
        [self.originImage sd_setImageWithURL:[NSURL URLWithString:strurl]];
            
        }else if (status.message.pictures.count != 0)
        {
            
            self.picHeight.constant = 200;
            self.contentHeight.constant = 260;
            
            for (SMPictures *pic in status.message.pictures) {
                NSString *strurl = [NSString stringWithFormat:@"%@@%@w_%@h_25Q",pic.url,pic.width,pic.height];
                [self.originImage sd_setImageWithURL:[NSURL URLWithString:strurl]];
            }
            
        }else{
            
            self.contentHeight.constant = self.contentHeight.constant - self.picHeight.constant;
            self.picHeight.constant = 0;
            
        }

    }else{
        self.contentHeight.constant = self.contentHeight.constant - self.picHeight.constant;
        self.picHeight.constant = 0;
        self.originDescrib.text = status.reply.body;
        self.fireTime.text = status.reply.created_at;
          self.pinglunBody.text = @"赞了你的评论";
        
    }
}


-(void)setStatus0:(SMNotifications *)status0
{
    _status0  = status0;
     self.originDescrib.textColor = [UIColor lightGrayColor];
    [self.pinglunTouxiang sd_setImageWithURL:[NSURL URLWithString:status0.reply.user.avatar]];
    self.pinglunUser.text = status0.reply.user.login;
    self.pinglunTime.text = status0.created_at;
    self.pinglunBody.text = status0.reply.body;
    
    self.originImage.contentMode = UIViewContentModeScaleAspectFill;
    self.originImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.originImage.clipsToBounds = YES;
//    回复评论
    if (status0.reply.reference_reply == nil) {
  
        
        self.originDescrib.text = status0.reply.message.body;
        self.fireTime.text = status0.reply.message.created_at;
        
        if (status0.reply.message.map) {
           
            
            self.picHeight.constant = 200;
            self.contentHeight.constant = 260;
            
//             NSString *strurl = [NSString stringWithFormat:@"%@@1280w_1280h_25Q",status0.message.map.snapshot];
            [self.originImage sd_setImageWithURL:[NSURL URLWithString:status0.reply.message.map.snapshot]];
        }else if (status0.reply.message.pictures.count != 0)
        {
            
            self.picHeight.constant = 200;
            self.contentHeight.constant = 260;
            
            for (SMPictures *pic in status0.reply.message.pictures) {
//                   NSString *strurl = [NSString stringWithFormat:@"%@@%@w_%@h_25Q",pic.url,pic.width,pic.height];
                [self.originImage sd_setImageWithURL:[NSURL URLWithString:pic.url]];
            }
            
        }else{
            
            self.contentHeight.constant = self.contentHeight.constant - self.picHeight.constant;
            self.picHeight.constant = 0;
            
        }
        
    }else{
        
        
        self.contentHeight.constant = self.contentHeight.constant - self.picHeight.constant;
        self.picHeight.constant = 0;
        
        
        
        self.originDescrib.text = status0.reply.reference_reply.body;
        self.fireTime.text = status0.reply.reference_reply.created_at;
    }

}

- (CGFloat)cellHeightWithStatus:(SMNotifications *)status
{
    _status = status;
    
    [self layoutIfNeeded];
    
    if (status.message) {
        if (status.message.map.snapshot != nil || status.message.pictures.count!= 0) {
            
            self.picHeight.constant = 200;
            self.contentHeight.constant = 260;
            
            return 362;
        }else{
            
            self.contentHeight.constant = self.contentHeight.constant - self.picHeight.constant;
            self.picHeight.constant = 0;
            
            return 162;
            
        }
    }else
    {
        return 162;
    }
 
}
-(CGFloat)cellHeightWithStatus0:(SMNotifications *)status0;
{
    
    [self layoutIfNeeded];

    _status0 = status0;
    
    [self layoutIfNeeded];
    
    if (status0.reply.reference_reply) {
//        显示评论
        self.contentHeight.constant = self.contentHeight.constant - self.picHeight.constant;
        self.picHeight.constant = 0;
        
        return 162;

    }else
    {
//        显示帖子
        
        if (status0.reply.message.map.snapshot != nil || status0.reply.message.pictures.count!= 0) {
            
            self.picHeight.constant = 200;
            self.contentHeight.constant = 260;
            
            return 362;
        }else{
            
            self.contentHeight.constant = self.contentHeight.constant - self.picHeight.constant;
            self.picHeight.constant = 0;
            
            return 162;
            
        }

    }
    
    
}
-(CGFloat)cellHeightWithStatus1:(SMNotifications *)status1;
{
    [self layoutIfNeeded];
    
    _status1 = status1;
    
    [self layoutIfNeeded];
    
    if (status1.message) {
        if (status1.message.map.snapshot != nil || status1.message.pictures.count!= 0) {
            
            self.picHeight.constant = 200;
            self.contentHeight.constant = 260;
            
            return 362;
        }else{
            
            self.contentHeight.constant = self.contentHeight.constant - self.picHeight.constant;
            self.picHeight.constant = 0;
            
            return 162;
            
        }
    }else
    {
        if (status1.reply.message.map.snapshot != nil || status1.reply.message.pictures.count!= 0) {
            
            self.picHeight.constant = 200;
            self.contentHeight.constant = 260;
            
            return 362;
        }else{
            
            self.contentHeight.constant = self.contentHeight.constant - self.picHeight.constant;
            self.picHeight.constant = 0;
            
            return 162;
            
        }

    }
}
@end
