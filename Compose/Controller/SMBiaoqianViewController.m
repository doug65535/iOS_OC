//
//  ViewController.m
//  ZFTokenFieldDemo
//
//  Created by Amornchai Kanokpullwad on 11/11/2014.
//  Copyright (c) 2014 Amornchai Kanokpullwad. All rights reserved.
//

#import "SMBiaoqianViewController.h"

#import "SMBallScroViewController.h"

@interface SMBiaoqianViewController () < UIScrollViewDelegate,SMBallScroViewControllerDelegate>
//@property (weak, nonatomic) IBOutlet ZFTokenField *tokenField;
@property (strong, nonatomic) IBOutlet UIView *container;
//@property (nonatomic, strong) NSMutableArray *tokens;
//@property (weak, nonatomic) IBOutlet UITextField *textFiled;
//
//- (IBAction)didFinishBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)didFinishBtnClick:(id)sender;


@property(nonatomic,strong)SMBallScroViewController *ballVC;
@end

@implementation SMBiaoqianViewController


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    SMBallScroViewController *tablVC = segue.destinationViewController;
    
    //设置代理
    tablVC.delegate = self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textField.placeholder = @"请输入自定义标签";
//    self.tokens = [NSMutableArray array];
//
//    self.tokenField.dataSource = self;
//    self.tokenField.delegate = self;
//    self.tokenField.textField.placeholder = @"请输入自定义标签";
//    [self.tokenField reloadData];
    
    
//    [self.tokenField.textField becomeFirstResponder];
    

    
    UIBarButtonItem *composeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    self.navigationItem.leftBarButtonItem = composeItem;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}



-(void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



//- (IBAction)sendButtonPressed:(id)sender
//{
////    SMLog(@"%@",self.tokens);
////    SMLog(@"%tu",self.tokens.count);
//    
//
//    
//}

//点击删除按钮
//- (void)tokenDeleteButtonPressed:(UIButton *)tokenButton
//{
//    NSUInteger index = [self.tokenField indexOfTokenView:tokenButton.superview];
//    if (index != NSNotFound) {
//        [self.tokens removeObjectAtIndex:index];
//        [self.tokenField reloadData];
//    }
//}

//#pragma mark - ZFTokenField DataSource
////行高
//- (CGFloat)lineHeightForTokenInField:(ZFTokenField *)tokenField
//{
//    return 40;
//}


//个数
//- (NSUInteger)numberOfTokenInField:(ZFTokenField *)tokenField
//{
//    if (self.tokens.count >6) {
//        return 5;
//    }else{
//    return self.tokens.count;
//    }
//}

//- (UIView *)tokenField:(ZFTokenField *)tokenField viewForTokenAtIndex:(NSUInteger)index
//{
//    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TokenView" owner:nil options:nil];
//    UIView *view = nibContents[0];
//    UILabel *label = (UILabel *)[view viewWithTag:2];
////    UIButton *button = (UIButton *)[view viewWithTag:3];
//    
////    [button addTarget:self action:@selector(tokenDeleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    
//    label.text = self.tokens[index];
//    CGSize size = [label sizeThatFits:CGSizeMake(1000, 40)];
//    view.frame = CGRectMake(0, 0, size.width + 97, 40);
//    return view;
//}

#pragma mark - ZFTokenField Delegate

//- (CGFloat)tokenMarginInTokenInField:(ZFTokenField *)tokenField
//{
//    return 5;
//}

//- (void)tokenField:(ZFTokenField *)tokenField didReturnWithText:(NSString *)text
//{
//    
////    if (self.tokens.count >4) {
////        return;
////    }
////    
////    
////    [self.tokens addObject:text];
////    [tokenField reloadData];
//    if ([self.delegate respondsToSelector:@selector(didClickSendBtnWithToken:)]) {
//        [self.delegate didClickSendBtnWithToken:self.tokens];
//    }
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

//- (void)tokenField:(ZFTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index
//{
//    [self.tokens removeObjectAtIndex:index];
//}

//- (BOOL)tokenFieldShouldEndEditing:(ZFTokenField *)textField
//{
//    return YES;
//}



- (void)keyboardDidShow:(NSNotification *)note
{
    
    // 1.取出键盘的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 取出键盘高度
    CGFloat keyboardHeigth = keyboardFrame.size.height;
    
    // 获取动画时间
    NSTimeInterval time = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animationCurve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    // 2.设置工具条的Y值向上移动键盘的高度
    [UIView animateWithDuration:time delay:0 options:animationCurve << 16 animations:^{
        self.textField.transform = CGAffineTransformMakeTranslation(0, -keyboardHeigth);
        
        
    self.container.transform = CGAffineTransformMakeTranslation(0, -keyboardHeigth);
        
    } completion:nil];
    
}


- (void)keyboardDidHide:(NSNotification *)note
{
    
    // 获取动画时间
    NSTimeInterval time = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animationCurve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    // 2.设置工具条的Y值向上移动键盘的高度
    [UIView animateWithDuration:time delay:0 options:animationCurve << 16 animations:^{
        self.textField.transform = CGAffineTransformIdentity;
        
        self.container.transform = CGAffineTransformIdentity;
    } completion:nil];
    
}

-(void)didbuttonPressed:(UIButton *)btn
{
//    if (self.tokens.count <5) {
//        [self.tokens addObject:btn.titleLabel.text];
//        [self.tokenField reloadData];
//    }else
//    {
//        return;
//    }
    if ([self.delegate respondsToSelector:@selector(didClickSendBtnWithToken:)]) {
        [self.delegate didClickSendBtnWithToken:btn.titleLabel.text];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didFinishBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickSendBtnWithToken:)]) {
                [self.delegate didClickSendBtnWithToken:self.textField.text];
            }
        
        [self dismissViewControllerAnimated:YES completion:nil];
}
@end


