

#import "SMPhotoSelectedCell.h"

@interface SMPhotoSelectedCell()
/**
 *  显示图片的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
/**
 *  删除按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
/**
 *  添加图片
 */
- (IBAction)addPhoto:(UIButton *)sender;
/**
 *  删除图片
 */
- (IBAction)deletePhoto:(UIButton *)sender;
@end

@implementation SMPhotoSelectedCell

- (IBAction)addPhoto:(UIButton *)sender
{
    // 发送添加的通知
    if ([self.delegate respondsToSelector:@selector(addPhoto)]) {
        [self.delegate addPhoto];
    }
}
- (IBAction)deletePhoto:(UIButton *)sender
{
    // 发送删除的通知
    if ([self.delegate respondsToSelector:@selector(deletePhoto:)]) {
        [self.delegate deletePhoto:self];
    }
}

- (void)setIconImage:(UIImage *)iconImage
{
    _iconImage = iconImage;
    


    
    // 如果等于nil代表当前是添加按钮
    if (iconImage == nil) {
        // 隐藏删除按钮
        self.deleteBtn.hidden = YES;
        
        [self.iconBtn setBackgroundImage:[UIImage imageNamed:@"compose_pic_add"] forState:UIControlStateNormal];
        [self.iconBtn setBackgroundImage:[UIImage imageNamed:@"compose_pic_add_highlighted"] forState:UIControlStateHighlighted];
        
    }else
    {
        // 显示删除按钮
        self.deleteBtn.hidden = NO;

        // 设置传入的图片
        [self.iconBtn setBackgroundImage:_iconImage forState:UIControlStateNormal];
    }
}

@end
