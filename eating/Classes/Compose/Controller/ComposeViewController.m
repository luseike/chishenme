//
//  UploadViewController.m
//  eating
//
//  Created by iMac2011 on 14/11/12.
//  Copyright (c) 2014年 Neo. All rights reserved.
//

#import "ComposeViewController.h"
#import "AFNetworking.h"
#import "JYLComposeToolbar.h"
#import "JYLComposePhotosView.h"
#import "JYLTextView.h"
//#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"

@interface ComposeViewController ()<UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,JYLComposeToolbarDelegate>
@property(nonatomic,weak) JYLComposePhotosView *photosView;
@property(nonatomic,weak) JYLComposeToolbar *toolbar;
@property(nonatomic,weak) JYLTextView *textView;
@end

@implementation ComposeViewController
#pragma mark - 初始化方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavBar];

    [self setupTextView];

    [self setupToolbar];

    [self setupPhotosView];
}

// 添加显示图片的相册控件
- (void)setupPhotosView
{
    JYLComposePhotosView *photosView = [[JYLComposePhotosView alloc] init];
    photosView.width = self.textView.width;
    photosView.height = self.textView.height;
    photosView.y = 70;
    [self.textView addSubview:photosView];
    self.photosView = photosView;
}

// 添加工具条
- (void)setupToolbar
{
    JYLComposeToolbar *toolbar = [[JYLComposeToolbar alloc] init];
    toolbar.width = self.view.width;
    toolbar.delegate = self;
    toolbar.height = 44;
    self.toolbar = toolbar;
    
    toolbar.y = self.view.height - toolbar.height;
    [self.view addSubview:toolbar];
}

// 添加输入控件
- (void)setupTextView
{
    JYLTextView *textView = [[JYLTextView alloc] init];
    textView.alwaysBounceVertical = YES; // 垂直方向上拥有有弹簧效果
    textView.frame=CGRectMake(0, 70, 320, 300);
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
    // 2.设置提醒文字（占位文字）
    textView.placehoder = @"爆美食...";
    textView.font = [UIFont systemFontOfSize:15];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}

// 设置导航条内容
- (void)setupNavBar
{
    self.title = @"爆美食";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleBordered target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark - 私有方法
- (void)cancel
{
    [self.tabBarController setSelectedIndex:0];
}

- (void)send
{
    NSLog(@"发送");
    [self sendStatusWithImage];
    [self.tabBarController setSelectedIndex:0];
}

- (void)sendStatusWithImage
{
    // 1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    // 3.发送POST请求
#warning 还没有写完发送功能
}


#pragma mark - 键盘处理
/**
 *  键盘即将隐藏
 */
- (void)keyboardWillHide:(NSNotification *)note
{
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.transform = CGAffineTransformIdentity;
    }];
}

/**
 *  键盘即将弹出
 */
- (void)keyboardWillShow:(NSNotification *)note
{
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [UIView animateWithDuration:duration animations:^{
        CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
    }];
}

#pragma mark - UITextViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = textView.text.length != 0;
}

#pragma mark - JYLComposeToolbarDelegate
/**
 *  监听toolbar内部按钮的点击
 */
- (void)composeTool:(JYLComposeToolbar *)toolbar didClickedButton:(JYLComposeToolbarButtonType)buttonType
{
    switch (buttonType) {
        case JYLComposeToolbarButtonTypeCamera: // 照相机
            [self openCamera];
            break;
            
        case JYLComposeToolbarButtonTypePicture: // 相册
            [self openAlbum];
            break;
            
        case JYLComposeToolbarButtonTypeEmotion: // 表情
            [self openEmotion];
            break;
            
        default:
            break;
    }
}

/**
 *  打开照相机
 */
- (void)openCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

/**
 *  打开相册
 */
- (void)openAlbum
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

/**
 *  打开表情
 */
- (void)openEmotion
{
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.photosView addImage:image];
}
@end
