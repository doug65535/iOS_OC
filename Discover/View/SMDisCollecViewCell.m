//
//  PictureCell.m
//  99Art
//

//

#import "SMDisCollecViewCell.h"
#import "SMDetailViewController.h"

@interface SMDisCollecViewCell ()
@property (nonatomic, weak) UIImageView *picture;
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UILabel *commentCount;
@property (nonatomic, weak) UILabel *likeCount;

@property (nonatomic,strong)UILabel *likelaber;

@property (nonatomic, copy) NSString *witch;
@property (nonatomic, copy) NSString *height;

@end

@implementation SMDisCollecViewCell
#define kLabelFont [UIFont systemFontOfSize:13];

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius =2;
        self.clipsToBounds =YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *picture = [[UIImageView alloc] init];
     [picture setContentMode:UIViewContentModeScaleAspectFill];
        [self.contentView addSubview:picture];
        self.picture = picture;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];

        [self.contentView addSubview:bgView];
        self.bgView = bgView;
        
        UILabel *likeLabel = [[MLEmojiLabel alloc]
                              initWithFrame:CGRectMake(8, 0, (kWidth -8 -8 -8 )/2 -8, 50)];
        likeLabel.font = kLabelFont;
        
        likeLabel.numberOfLines =0;
        [bgView addSubview:likeLabel];
        
        self.likelaber = likeLabel;
    }
    return self;
}

- (void)setModel:(SMStatus *)model {
    _model = model;
   
    self.likelaber.text = model.body;
    
    if (model.pictures.count!= 0) {
        for (SMPictures *pic in model.pictures) {
            NSString *strurl = [NSString stringWithFormat:@"%@@%@w_%@h_25Q",pic.url,pic.width,pic.height];
          
   [self.picture sd_setImageWithURL:[NSURL URLWithString:strurl]placeholderImage:[UIImage imageNamed:@"loding_dynamic"]];
//            解决重用问题
        }
       
        for (UIImageView *imageview in self.picture.subviews) {
            [imageview removeFromSuperview];
        }
        }else if(model.map.snapshot != nil)
    {
        NSString *strUrl = [NSString stringWithFormat:@"%@@%@w_%@h_25Q",model.map.snapshot,@1280,@1280];

        [self.picture sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"loding_map"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if ([model.map.app isEqual:@"marker"]) {
                
                UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"events map"]];
                CGFloat w = 55;
                CGFloat h = 24;
                //            self.picture 没生成出来会造成标签图片位移
            imageview.frame = CGRectMake(self.picture.width -w , 0, w, h);
            [self.picture addSubview:imageview];
        }else
        {
            for (UIImageView *imageview in self.picture.subviews) {
                [imageview removeFromSuperview];
            }
        }
        }];
    }else{
        [self.picture removeFromSuperview];
    }
    [self settingFrame:model];
}

- (void)settingFrame:(SMStatus *)model {
    _model = model;
    if (model.pictures.count!= 0) {
        for (SMPictures *pic in model.pictures) {

            self.height = pic.height;
            self.witch = pic.width;
    }
        
        CGFloat height = [model cellHeightWithImageHeight:self.height andImageWidth:[NSNumber numberWithFloat:[self.witch floatValue]]];
        [self.picture setFrame:CGRectMake(0, 0, (kWidth-8 -8 -8 )/2, height)];
        [self.bgView setFrame:CGRectMake(0, CGRectGetMaxY(self.picture.frame), self.picture.frame.size.width, 50)];
    }else{
        
        [self.picture setFrame:CGRectMake(0, 0,(kWidth -8 -8 -8 )/2 , 160)];
        [self.bgView setFrame:CGRectMake(0, CGRectGetMaxY(self.picture.frame), self.picture.frame.size.width, 50)];
    }
}

@end
