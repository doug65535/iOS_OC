//
//  DockMenuSubView.m
//  abcd
//
//  Created by leonshi on 6/20/14.
//  Copyright (c) 2014 leonshi. All rights reserved.
//

#import "DockMenuSubView.h"

@implementation DockMenuSubView


-(void) setHidden:(BOOL)hidden
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    
    [self.layer addAnimation:animation forKey:@"View Flip"];
    
    if (hidden) {
        [self animationStop];
    }
    else
    {
        [super setHidden:hidden];
    }
}

-(void) setHidden:(BOOL)hidden withDirection:(BOOL) fromRightFlag
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionPush;
    if (fromRightFlag) {
        animation.subtype = kCATransitionFromRight;
    }
    else
    {
        animation.subtype = kCATransitionFromLeft;
    }
    
    [self.layer addAnimation:animation forKey:@"View Flip"];
    if (hidden) {
        [self animationStop];
    }
    else
    {
        [super setHidden:hidden];
    }
}

-(void)animationStop
{
    [super setHidden:!self.hidden];
}



@end
