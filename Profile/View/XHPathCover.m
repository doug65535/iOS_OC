//
//  XHPathConver.m
//  XHPathCover
//
//  Created by 曾 宪华 on 14-2-7.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHPathCover.h"


NSString *const XHUserNameKey = @"XHUserName";
NSString *const XHBirthdayKey = @"XHBirthday";

NSString *const SMFollowings = @"SMFollowings";

NSString *const tagline = @"tagline";

#import <Accelerate/Accelerate.h>
#import <float.h>
#import "UIButton+WebCache.h"

@interface UIImage (ImageEffects)
- (UIImage *)applyLightEffect;
@end

@implementation UIImage (ImageEffects)

- (UIImage *)applyLightEffect {
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    return [self applyBlurWithRadius:30 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage {
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        
        
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (unsigned int)radius, (unsigned int)radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, (unsigned int)radius, (unsigned int)radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (unsigned int)radius, (unsigned int)radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

@end

@interface XHPathCover () {
    BOOL normal, paste, hasStop;
    BOOL isrefreshed;
}

@property (nonatomic, strong) UIView *bannerView;

@property (nonatomic, strong) UIView *showView;



@property (nonatomic, assign) CGFloat showUserInfoViewOffsetHeight;

@end

@implementation XHPathCover

#pragma mark - Publish Api



// background
- (void)setBackgroundImage:(UIImage *)backgroundImage {
    if (backgroundImage) {
        _bannerImageView.image = backgroundImage;
        _bannerImageViewWithImageEffects.image = [backgroundImage applyLightEffect];
    }
}

- (void)setBackgroundImageUrlString:(NSString *)backgroundImageUrlString {
    if (backgroundImageUrlString) {
        
    }
}

// avatar
- (void)setAvatarImage:(UIImage *)avatarImage {
    if (avatarImage) {
        
        [_avatarButton setImage:avatarImage forState:UIControlStateNormal];
     
    }
}

- (void)setAvatarUrlString:(NSString *)avatarUrlString {
    if (avatarUrlString) {
        [_avatarButton sd_setImageWithURL:[NSURL URLWithString:avatarUrlString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"tab_me"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
        
    }
}

-(void)didclickavater
{
    if ([self.delegate respondsToSelector:@selector(didclickAvater)]) {
        [self.delegate didclickAvater];
    }
}


// set info
- (void)setInfo:(NSDictionary *)info {
    
    [_avatarButton addTarget:self action:@selector(didclickavater) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *userName = [info valueForKey:XHUserNameKey];
    if (userName) {
        self.userNameLabel.text = userName;
    }
    
    
    NSString *tag = [info valueForKey:tagline];
    if (tag) {
        self.taglineLaber.text = tag;
    }
    
    NSString *birthday = [info valueForKey:XHBirthdayKey];
    if (birthday) {
//        self.birthdayBtn.titleLabel.text = birthday;
        [self.birthdayBtn setTitle:birthday forState:UIControlStateNormal];
        [self.birthdayBtn addTarget:self action:@selector(fensi) forControlEvents:UIControlEventTouchUpInside];
    }
    NSString *follows = [info valueForKey:SMFollowings];
    if (follows) {
//        self.followsBtn.titleLabel.text = follows;
        [self.followsBtn setTitle:follows forState:UIControlStateNormal];
        
        [self.followsBtn addTarget:self action:@selector(guanzhu) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}

-(void)fensi
{
    if ([self.delegate respondsToSelector:@selector(didClickFensi)]) {
        [self.delegate didClickFensi];
    }
}
-(void)guanzhu
{
    if ([self.delegate respondsToSelector:@selector(didClickGuanzhu)]) {
        [self.delegate didClickGuanzhu];
    }
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.touching = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.offsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(decelerate == NO) {
        self.touching = NO;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.touching = NO;
}

#pragma mark - Propertys



- (void)setOffsetY:(CGFloat)y {
    CGFloat fixAdaptorPadding = 0;
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
        fixAdaptorPadding = 64;
    }
    y += fixAdaptorPadding;
    _offsetY = y;
    CGRect frame = _showView.frame;
     {
        if(normal && _touching && isrefreshed) {
            paste = YES;
        }
        if(frame.origin.y != self.showUserInfoViewOffsetHeight) {
            frame.origin.y = self.showUserInfoViewOffsetHeight;
            _showView.frame = frame;
        }
    }
   
    
    UIView *bannerSuper = _bannerImageView.superview;
    CGRect bframe = bannerSuper.frame;
    if(y < 0) {
        bframe.origin.y = y;
        bframe.size.height = -y + bannerSuper.superview.frame.size.height;
        bannerSuper.frame = bframe;
        
        CGPoint center =  _bannerImageView.center;
        center.y = bannerSuper.frame.size.height / 2;
        _bannerImageView.center = center;
        
        if (self.isZoomingEffect) {
            _bannerImageView.center = center;
            CGFloat scale = (CGFloat)fabs(y) / self.parallaxHeight;
            _bannerImageView.transform = CGAffineTransformMakeScale(1+scale, 1+scale);
        }
    } else {
        if(bframe.origin.y != 0) {
            bframe.origin.y = 0;
            bframe.size.height = bannerSuper.superview.frame.size.height;
            bannerSuper.frame = bframe;
        }
        if(y < bframe.size.height) {
            CGPoint center =  _bannerImageView.center;
            center.y = bannerSuper.frame.size.height/2 + 0.5 * y;
            _bannerImageView.center = center;
        }
    }
    
    if (self.isLightEffect) {
        if(y < 0 && y >= -self.lightEffectPadding) {
            float percent = (-y / (self.lightEffectPadding * self.lightEffectAlpha));
            self.bannerImageViewWithImageEffects.alpha = percent;
            
        } else if (y <= -self.lightEffectPadding) {
            self.bannerImageViewWithImageEffects.alpha = self.lightEffectPadding / (self.lightEffectPadding * self.lightEffectAlpha);
        } else if (y > self.lightEffectPadding) {
            self.bannerImageViewWithImageEffects.alpha = 0;
        }
    }
}

#pragma mark - Life cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self _setup];
    }
    return self;
}

- (void)_setup {
    
    self.parallaxHeight = 170;
    self.isLightEffect = YES;
    self.lightEffectPadding = 80;
    self.lightEffectAlpha = 1.15;
    
    _bannerView = [[UIView alloc] initWithFrame:self.bounds];
    _bannerView.clipsToBounds = YES;
    UITapGestureRecognizer *tapGestureRecongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecongnizerHandle:)];
    [_bannerView addGestureRecognizer:tapGestureRecongnizer];
    
    _bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -self.parallaxHeight, CGRectGetWidth(_bannerView.frame), CGRectGetHeight(_bannerView.frame) + self.parallaxHeight * 2)];
    _bannerImageView.contentMode = UIViewContentModeScaleAspectFit;
//    _bannerImageView.layer.cornerRadius = 250;
//    _bannerImageView.layer.masksToBounds = YES;
    [_bannerView addSubview:self.bannerImageView];
    
    _bannerImageViewWithImageEffects = [[UIImageView alloc] initWithFrame:_bannerImageView.frame];
    _bannerImageViewWithImageEffects.alpha = 0.;
 
    [_bannerView addSubview:self.bannerImageViewWithImageEffects];
    
    [self addSubview:self.bannerView];
    
    CGFloat waterDropRefreshHeight = 100;

    CGFloat avatarButtonHeight = 75;
    self.showUserInfoViewOffsetHeight = CGRectGetHeight(self.frame) - waterDropRefreshHeight / 3 - avatarButtonHeight;
    _showView = [[UIView alloc] initWithFrame:CGRectMake(0, self.showUserInfoViewOffsetHeight, CGRectGetWidth(self.bounds), waterDropRefreshHeight)];
    _showView.backgroundColor = [UIColor clearColor];
    
      _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _avatarButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, avatarButtonHeight, avatarButtonHeight)];
  
//    切圆角
    _avatarButton.layer.cornerRadius = avatarButtonHeight /2;
    _avatarButton.layer.masksToBounds = YES;
    _avatarButton.layer.borderWidth = 2;
    _avatarButton.layer.borderColor = [[UIColor orangeColor] CGColor];
    
    _avatarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(98, 0, 207, 35)];
    _userNameLabel.textColor = [UIColor whiteColor];
//    _userNameLabel.backgroundColor = [UIColor clearColor];
//    _userNameLabel.shadowColor = [UIColor orangeColor];
    _userNameLabel.shadowOffset = CGSizeMake(0, 2);
    _userNameLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    

//    添加显示签名
    UILabel *laber = [[UILabel alloc] initWithFrame:CGRectMake(98, 37, 200, 16)];
    laber.text = self.userModel.tagline;
    laber.font = [UIFont systemFontOfSize:12];
    laber.textColor = [UIColor whiteColor];
    [_showView addSubview:laber];
    
    self.taglineLaber = laber;
    
    _birthdayBtn = [[UIButton alloc] initWithFrame:CGRectMake(93, 55, 60, 24)];
    _birthdayBtn.titleLabel.textColor = [UIColor whiteColor];
//    _birthdayBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    _birthdayBtn.titleLabel.shadowColor = [UIColor blackColor];
    _birthdayBtn.titleLabel.shadowOffset = CGSizeMake(0, 2);
    _birthdayBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    
    _followsBtn = [[UIButton alloc] initWithFrame:CGRectMake(160, 55, 60, 24)];
    _followsBtn.titleLabel.textColor = [UIColor whiteColor];
//    _followsBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _followsBtn.titleLabel.shadowColor = [UIColor blackColor];
    _followsBtn.titleLabel.shadowOffset = CGSizeMake(0, 2);
    _followsBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//   白线
    UIView *view = [[UILabel alloc]initWithFrame:CGRectMake(156, 59, 1, 16)];
    view.backgroundColor = [UIColor whiteColor];
    [_showView addSubview:view];
    
    [_showView addSubview:self.avatarButton];
    [_showView addSubview:self.userNameLabel];
    [_showView addSubview:self.birthdayBtn];
    [_showView addSubview:self.followsBtn];
    
    [self addSubview:self.showView];
}

- (void)dealloc {
    self.bannerImageView = nil;
    self.bannerImageViewWithImageEffects = nil;
    
    self.avatarButton = nil;
    self.userNameLabel = nil;
    self.birthdayBtn = nil;
    self.followsBtn =nil;
    
    self.bannerView = nil;
    self.showView = nil;
    

}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];

}



#pragma mark - previte method

- (void)tapGestureRecongnizerHandle:(UITapGestureRecognizer *)tapGestureRecongnizer {
    if (self.handleTapBackgroundImageEvent) {
        self.handleTapBackgroundImageEvent();
    }
}

- (void)setIsRefreshed:(BOOL)b {
    isrefreshed = b;
}


- (void)resetTouch {
    normal = NO;
    paste = NO;
    hasStop = NO;
    isrefreshed = NO;
}

@end
