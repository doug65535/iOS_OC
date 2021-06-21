//
//  SMPingLunViewController.m
    
//
//  Created by lucifer on 15/7/28.
  
//


#import "SMInputTextView.h"
#import "SMInputToolbar.h"

//#import "TSEmojiView.h"

#import "SMLikeFridensTableViewController.h"
#import "SMPingLunViewController.h"


#import "CoreEmotionView.h"
#import "NSArray+SubArray.h"
#import "EmotionModel.h"
#import "NSString+EmotionExtend.h"
@interface SMPingLunViewController ()<UITextViewDelegate,SMInputToolbarDelegate,SMLikeFridensTableViewControllerDelegate>
@property (nonatomic,strong) CoreEmotionView *emotionView;
@end

@implementation SMPingLunViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    


    // 1.设置导航条
    [self setupNav];
    // 2.设置输入控件
    [self setupInput];
    // 3.设置工具条
    [self setupToolbar];

    
}




////点击了表情
//-(void)didClickEmoji
//{
//    
//    if (!_emojiView) {
//        _emojiView = [[TSEmojiView alloc] initWithFrame:CGRectMake(0, self.toolbar.y - 216, 320, 216)];
//        _emojiView.delegate = self;
//        
//        _emojiView.backgroundColor = [UIColor darkGrayColor];
//        
//        [self.view addSubview:_emojiView];
//    }else{
//        [_emojiView removeFromSuperview];
//        
//        _emojiView = nil;
//    }
//    
//}
////点击具体表情后的代理方法
//- (void)didTouchEmojiView:(TSEmojiView*)emojiView touchedEmoji:(NSString*)str
//{
//    self.inputView.placeholder = nil;
//    
//    self.inputView.text = [NSString stringWithFormat:@"%@%@", self.inputView.text, str];
//    
//    [emojiView removeFromSuperview];
//    
//    emojiView = nil;
//}
//

//点击了表情
-(void)didClickEmoji
{
    
    //视图准备
    [self viewPrepare];
    
    //事件
    [self event];
    
    [_inputView resignFirstResponder];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _inputView.inputView=_inputView.inputView?nil:self.emotionView;
        
        
        
        [_inputView becomeFirstResponder];
    });
    if (!_inputView.inputView) {
        [_toolbar.subviews[0] setImage:[UIImage imageNamed:@"face_jianpan"] forState:UIControlStateNormal];
    }else
    {
        [_toolbar.subviews[0] setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
    }
    
    
}


-(CoreEmotionView *)emotionView{
    
    if(_emotionView==nil){
        _emotionView = [CoreEmotionView emotionView];
    }
    
    return _emotionView;
}
/*
 *  视图准备
 */
-(void)viewPrepare{
    
    self.emotionView.textView=self.inputView;
    
    //设置代理
    self.inputView.delegate=self;
    //    //监听通知
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNoti:) name:UIKeyboardWillShowNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}



/*
 *  事件
 */
-(void)event{
    
    //删除按钮点击事件
    __weak typeof(self) weakSelf=self;
    self.emotionView.deleteBtnClickBlock=^(){
        
        [weakSelf.inputView deleteBackward];
    };
}

//点击了 @关联按钮

-(void)didclickmentionbutton
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SMLikeFirends" bundle:nil];
    SMLikeFridensTableViewController *mentionVc = [sb instantiateInitialViewController];
    
    mentionVc.delegate = self;
    
    //
    SMNavgationController *nav = [[SMNavgationController alloc] init];
    
    [nav addChildViewController:mentionVc];
    
    
    // 3.弹出授权控制器
    [self presentViewController:nav animated:YES completion:nil];
}

//点击@好友 的回调
-(void)didClickdidSelectWithLikerName:(NSString *)name
{
    
    
    self.inputView.placeholder = nil;
    self.inputView.text = [NSString stringWithFormat:@"%@ @%@", self.inputView.text, name];
}




- (void)setupNav
{
    // 1.设置导航条标题/ 左右按钮
    self.navigationItem.title = @"发布评论";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(composePingLun)];
}



- (void)setupInput
{
    
    // 2.创建输入控件
    SMInputTextView *inputView = [[SMInputTextView alloc] init];
    
    
    
    inputView.frame = CGRectMake(0, 0, self.view.width, 200);
    
    [inputView becomeFirstResponder];
    // 默认清空下TextView是不能滚动的, 但是可以通过设置某些属性让其默认就可以滚动
    inputView.alwaysBounceVertical = YES;
    inputView.delegate = self;
    

    
    if (self.reply.floor) {
        inputView.placeholder = [NSString stringWithFormat:@"回复%@L:",self.reply.floor];
    }else
    {
          inputView.placeholder = @"说点什么吧...";
    }
    
    [self.inputViewContainer addSubview:inputView];
    self.inputView = inputView;
}
- (void)setupToolbar
{
    // 3.创建自定义工具条
    SMInputToolbar *toolbar = [[SMInputToolbar alloc] init];
    toolbar.backgroundColor = [UIColor colorWithRed:1 green:231/255.0 blue:204/255.0 alpha:1];
    toolbar.frame = CGRectMake(0, self.view.height - 44, self.view.width, 44);
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
    
    toolbar.delegate = self;
    
    // 监听键盘的弹出和收起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, -keyboardHeigth);
    } completion:nil];
    
    
}
- (void)keyboardDidHide:(NSNotification *)note
{
    
    // 获取动画时间
    NSTimeInterval time = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animationCurve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    // 2.设置工具条的Y值向上移动键盘的高度
    [UIView animateWithDuration:time delay:0 options:animationCurve << 16 animations:^{
        self.toolbar.transform = CGAffineTransformIdentity;
    } completion:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 设置发送按钮默认不能点击
    self.navigationItem.rightBarButtonItem.enabled = (self.inputView.text.length > 0);
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



/**
 *  发送评论
 */


-(void)composePingLun
{
    [SVProgressHUD showWithStatus:@"正在发布评论"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    
    
    
    if (self.reply.Lid) {
        parameters[@"body"] = [NSString stringWithFormat:@"回复%@楼: %@",self.reply.floor,self.inputView.text];
    }else{
    parameters[@"body"] = self.inputView.text;
    }
    
    
    parameters[@"message_id"] = self.modle.Lid;
    
    
    if (self.reply.Lid) {
      parameters[@"reference_id"] = self.reply.Lid;
    }
   
    
    // 2.发送请求
    
    NSString *url = @"http://club.dituhui.com/api/v2/replies";
    
    [manager POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        // 0.关闭键盘
        [self.view endEditing:YES];
        
        
        if ([self.delegate respondsToSelector:@selector(didFinishPinglun)]) {
            [self.delegate didFinishPinglun];
        }
        
        
        // 1.关闭当前控制器
        [self dismissViewControllerAnimated:YES completion:nil];
        // 2.弹出提示用户
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"发送失败,您是否已登录？"];
        
    }];
    
}



#pragma mark - UITextViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 关闭键盘
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView
{
    // 设置发送按钮的状态
    self.navigationItem.rightBarButtonItem.enabled = (textView.text.length > 0);
}



@end
