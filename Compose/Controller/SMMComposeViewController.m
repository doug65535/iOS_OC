#import "SMMComposeViewController.h"
#import "SMInputTextView.h"


#import "SMInputToolbar.h"

#import "SMPhotoSelectedViewController.h"

#import "SMBiaoqianViewController.h"

#import "SMPictures.h"

#import "SMLikeFridensTableViewController.h"

#import "SMInsertLoaction.h"

#import "ZFTokenField.h"


#import "CoreEmotionView.h"
#import "NSArray+SubArray.h"
#import "EmotionModel.h"
#import "NSString+EmotionExtend.h"

@interface SMMComposeViewController ()<UITextViewDelegate,SMBiaoqianViewControllerDelegate,SMInputToolbarDelegate,SMLikeFridensTableViewControllerDelegate,SMInsertLoactionDelegate,ZFTokenFieldDelegate,ZFTokenFieldDataSource>

#define SMFinishCompose @"SMFinishCompose"
- (IBAction)loctePresent:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *locteBtn;
/**
 *  自定义输入框
 */
@property (weak, nonatomic) IBOutlet SMInputTextView *inputView;

/**
 *  自定义工具条
 */
@property (weak, nonatomic) IBOutlet ZFTokenField *ZFTokenView;
@property (nonatomic, weak) SMInputToolbar *toolbar;
/**
 *  输入框容器
 */
//@property (weak, nonatomic) IBOutlet UIView *inputViewContainer;
/**
 *  配图控制器
 */
@property (nonatomic, strong) SMPhotoSelectedViewController *photoSelectedViewController;

@property (strong, nonatomic) IBOutlet UIButton *biaoqianBtn;
- (IBAction)biaoqianBtn:(UIButton *)sender;


@property(nonatomic,strong)NSMutableArray *picIdArr;


@property (nonatomic,strong)NSMutableArray *tagArr;

//@property (nonatomic,strong)TSEmojiView *emojiView;

@property(nonatomic,copy)NSString *locateName;


@property(nonatomic,copy)NSString *biaoqianName;


@property (nonatomic,strong) CoreEmotionView *emotionView;
@end

@implementation SMMComposeViewController


-(NSMutableArray *)tagArr
{
    if (!_tagArr) {
        _tagArr = [[NSMutableArray alloc] init];
    }
    return _tagArr;
}


- (IBAction)biaoqianBtn:(UIButton *)sender {

        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"BiaoqianViewController" bundle:nil];
        SMBiaoqianViewController *biaoqian = [sb instantiateInitialViewController];
        
        biaoqian.delegate = self;
        
        //
        SMNavgationController *nav = [[SMNavgationController alloc] initWithRootViewController:biaoqian];

        // 3.弹出授权控制器
        [self presentViewController:nav animated:YES completion:nil];

}

-(NSMutableArray *)picIdArr
{
    if (!_picIdArr) {
        _picIdArr = [[NSMutableArray alloc] init];
    }
    return _picIdArr;
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
    
    
    self.biaoqianBtn.titleLabel.textColor = [UIColor blueColor];

    self.ZFTokenView.delegate = self;
    self.ZFTokenView.dataSource = self;
   
    
    if (self.isFromSuggestion) {
        [self.tagArr addObject:@"意见反馈"];
    }
    
     [self.ZFTokenView reloadData];
}

- (void)tokenDeleteButtonPressed:(UIButton *)tokenButton
{
    NSUInteger index = [self.ZFTokenView indexOfTokenView:tokenButton.superview];
    if (index != NSNotFound) {
        [self.tagArr removeObjectAtIndex:index];
        [self.ZFTokenView reloadData];
    }
}

#pragma mark - ZFTokenField DataSource

- (CGFloat)lineHeightForTokenInField:(ZFTokenField *)tokenField
{
    return 20;
}

- (NSUInteger)numberOfTokenInField:(ZFTokenField *)tokenField
{
    return self.tagArr.count;
}

- (UIView *)tokenField:(ZFTokenField *)tokenField viewForTokenAtIndex:(NSUInteger)index
{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TokenView" owner:nil options:nil];
    UIView *view = nibContents[0];
    UILabel *label = (UILabel *)[view viewWithTag:2];
    UIButton *button = (UIButton *)[view viewWithTag:3];
    
    [button addTarget:self action:@selector(tokenDeleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    label.text = self.tagArr[index];
    CGSize size = [label sizeThatFits:CGSizeMake(1000, 20)];
    view.frame = CGRectMake(0, 0, size.width + 97, 20);
    return view;
}

#pragma mark - ZFTokenField Delegate

- (CGFloat)tokenMarginInTokenInField:(ZFTokenField *)tokenField
{
    return 5;
}


- (void)tokenField:(ZFTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index
{
    [self.tagArr removeObjectAtIndex:index];
}


- (BOOL)tokenFieldShouldEndEditing:(ZFTokenField *)textField
{
    return YES;
}

-(void)tokenFieldDidBeginEditing:(ZFTokenField *)tokenField
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}




-(NSString *)biaoqianName
{
    if (!_biaoqianName) {
        _biaoqianName = [[NSString alloc]init];
    }
    return _biaoqianName;
}
-(void)didClickSendBtnWithToken:(NSString *)token
{
    


//   self.biaoqianName =   [self.biaoqianName stringByAppendingString:@" #"];
//    
//    self.biaoqianName = [self.biaoqianName stringByAppendingString:token];
//    
//   self.biaoqianName = [self.biaoqianName stringByAppendingString:@"#"];
//    
//    
    
//    self.biaoqianBtn.titleLabel.text = self.biaoqianName;
    [self.tagArr addObject:token];
    [self.ZFTokenView reloadData];
}

//-(void)didClickSendBtnWithToken:(NSMutableArray *)token
//{
//    
//    
//    self.tagArr = token; 
//    
//    NSString *str = [[NSString alloc]init];
//    for (int i = 0; i<token.count; i++) {
//       
//        
//        
//         str = [str stringByAppendingString:@" #"];
//        
//        str = [str stringByAppendingString:token[i]];
//        
//        str = [str stringByAppendingString:@"#"];
//        
//    }
//    
////    self.biaoqianBtn.titleLabel.frame = self.biaoqianBtn.frame;
//    
//    self.biaoqianBtn.titleLabel.textColor = [UIColor blueColor];
//    
//
//    
//    self.biaoqianBtn.titleLabel.text = str;
//   
//    SMLog(@"%@",str);
//
//}



//点击了表情
//点击具体表情后的代理方法
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
    
    self.inputView.placeholder = nil;
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
    self.navigationItem.title = @"发布动态";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backup)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(compose)];
}

-(void)backup
{
      [self dismissViewControllerAnimated:YES completion:^{
          [[NSNotificationCenter defaultCenter] removeObserver:self];
      }];
}
- (void)setupInput
{
    // 2.创建输入控件
//    SMInputTextView *inputView = [[SMInputTextView alloc] init];
//    inputView.frame = CGRectMake(0, 0, self.view.width, 200);
//    // 默认清空下TextView是不能滚动的, 但是可以通过设置某些属性让其默认就可以滚动
//    inputView.alwaysBounceVertical = YES;
    _inputView.delegate = self;
    _inputView.placeholder = @"说点什么吧...";
    
    if (self.isFromSuggestion) {
        _inputView.placeholder = @"请输入您的宝贵建议……";
}
//    [self.inputViewContainer addSubview:inputView];
//     self.inputView = inputView;
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



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    SMLog(@"%@",NSStringFromCGRect(self.toolbar.frame));
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



- (void)compose
{
    // 判断是否有配图
    if (self.photoSelectedViewController.images.count > 0) {
//         发送带图片的帖子
    
    [self composeStatusUpdateImage];
    }
    else
    {
        // 发送纯文本帖子
        [self composeStatusWithoutImage];
    }
}

/**
 *  发送纯文本帖子
 */


-(void)composeStatusWithoutImage
{
   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    if (account == nil) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"您尚未登录" message:@"是否前去登录"preferredStyle:UIAlertControllerStyleAlert];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SMLoginViewController *logVc = [[UIStoryboard storyboardWithName:@"SMLoginViewController" bundle:nil]instantiateInitialViewController];
            SMNavgationController *nav = [[SMNavgationController alloc]init];
            [nav addChildViewController:logVc];
            [self presentViewController:nav animated:YES completion:nil];
        }]];
        
        
        [self presentViewController:alertVC animated:YES completion:nil];
        
        return;
    }
    
    
     [SVProgressHUD showWithStatus:@"正在发布中……"];
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    
    parameters[@"body"] =self.inputView.text;
    
    if (self.isFromSuggestion) {
        parameters[@"body"] = [NSString stringWithFormat:@"#意见反馈# %@",self.inputView.text];
    }
    
    
    if (self.locateName) {
        parameters[@"address"] = self.locateName;
    }
    if (self.tagArr) {
        parameters[@"tags"] = self.tagArr;

    }
       // 2.发送请求
    
    NSString *url = @"http://club.dituhui.com/api/v2/messages";
    
    [manager POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        // 0.关闭键盘
        [self.view endEditing:YES];
        // 1.关闭当前控制器
        [self dismissViewControllerAnimated:YES completion:nil];
        // 2.弹出提示用户
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        
//        if ([self.delegate respondsToSelector:@selector(didFinishCompose)]) {
//            [self.delegate didFinishCompose];
//        }
        [[NSNotificationCenter defaultCenter] postNotificationName:SMFinishCompose object:nil userInfo:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"发送失败"];
    }];

}


/**
 *  发送带图片的帖子
 */
- (void)composeStatusWithImage
{

    // 1.封装请求参数
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    
    if (account == nil) {
        UIAlertController *alertVC =  [UIAlertController alertControllerWithTitle:@"您尚未登录" message:@"是否前去登录"preferredStyle:UIAlertControllerStyleAlert];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SMLoginViewController *logVc = [[UIStoryboard storyboardWithName:@"SMLoginViewController" bundle:nil]instantiateInitialViewController];
            SMNavgationController *nav = [[SMNavgationController alloc]init];
            [nav addChildViewController:logVc];
            [self presentViewController:nav animated:YES completion:nil];
        }]];
        
        
        [self presentViewController:alertVC animated:YES completion:nil];
        
        return;
    }
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    
    parameters[@"body"] =self.inputView.text;
    
    if (self.isFromSuggestion) {
        parameters[@"body"] = [NSString stringWithFormat:@"#意见反馈# %@",self.inputView.text];
    }
    

    parameters[@"pictures"] =self.picIdArr;
    
    
    
    if (self.tagArr) {
         parameters[@"tags"] = self.tagArr;
    }
   
    if (self.locateName) {
        parameters[@"address"] = self.locateName;
    }
    
     // 2.发送请求
    
    NSString *url = @"http://club.dituhui.com/api/v2/messages";
    
    [manager POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        // 0.关闭键盘
        [self.view endEditing:YES];
        // 1.关闭当前控制器
        [self dismissViewControllerAnimated:YES completion:nil];
        // 2.弹出提示用户
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
//        if ([self.delegate respondsToSelector:@selector(didFinishCompose)]) {
//            [self.delegate didFinishCompose];
        
//        }
        [[NSNotificationCenter defaultCenter] postNotificationName:SMFinishCompose object:nil userInfo:nil];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
          [SVProgressHUD showSuccessWithStatus:@"发送失败"];
    }];
    
    
}
/**
 *  上传图片
 */
- (void)composeStatusUpdateImage
{
    [SVProgressHUD showWithStatus:@"正在发布……"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    SMAccount *account = [SMAccount accountFromSandbox];
    
    [manager.requestSerializer setValue:account.token   forHTTPHeaderField:@"token"];

    NSString *url = @"http://club.dituhui.com/api/v2/pictures";
    
    
    
    for (UIImage *image in self.photoSelectedViewController.images) {
        
        [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
          
            
            // 2.将图片转换为二进制
            NSData *iamgeData = UIImageJPEGRepresentation(image, 0.5);
    
           [ formData appendPartWithFileData:iamgeData name:@"file" fileName:@"filename" mimeType:@"image/jpeg"];
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSArray *newArr = responseObject[@"pictures"];
            
            NSArray *model = [SMPictures objectArrayWithKeyValuesArray:newArr];
            
            for (SMPictures *pic in model) {
                [self.picIdArr addObject:pic.Lid];
            }
            
            // 判断是否加载完毕
            if (self.picIdArr.count == self.photoSelectedViewController.images.count) {
                [self composeStatusWithImage];
            }
            
//            SMLog(@"%@",responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            SMLog(@"%@",error);
        }];
    }

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.photoSelectedViewController = segue.destinationViewController;
    
}


-(void)finishLocate:(NSString *)locateStr
{
//  用此方法文字只能和以前一样长
//    self.locteBtn.titleLabel.text = locateStr;
    
    [self.locteBtn setTitle:locateStr forState:UIControlStateNormal];

    self.locateName = locateStr;
}

- (IBAction)loctePresent:(UIButton *)sender {
    SMInsertLoaction *locatVc = [[UIStoryboard storyboardWithName:@"SMInsertLocation" bundle:nil]instantiateInitialViewController];
    locatVc.delegate = self;
    
    SMNavgationController *nav = [[SMNavgationController alloc] initWithRootViewController:locatVc];
    [self presentViewController:nav animated:YES completion:nil];
}
@end
