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
#import <CoreLocation/CoreLocation.h>

@interface ComposeViewController ()<UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,JYLComposeToolbarDelegate,CLLocationManagerDelegate>
@property(nonatomic,weak) JYLComposePhotosView *photosView;
@property(nonatomic,weak) JYLComposeToolbar *toolbar;
@property(nonatomic,weak) JYLTextView *textView;

@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) CLGeocoder *geocoder;
@end

@implementation ComposeViewController
#pragma mark - 初始化方法

//-(CLLocationManager *)locMgr{
//    if (!_locMgr) {
//        self.locMgr=[[CLLocationManager alloc] init];
//        self.locMgr.delegate=self;
//        [self.locMgr requestAlwaysAuthorization];
//    }
//    return _locMgr;
//}
-(CLGeocoder *)geocoder{
    if (!_geocoder) {
        self.geocoder=[[CLGeocoder alloc] init];
    }
    return _geocoder;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    //定位用户所在位置
//    if ([CLLocationManager locationServicesEnabled]) {
//        //开始定位
//        [self.locMgr startUpdatingLocation];
//    }else{
//        //提醒用户检查网络状况
//        //提醒用户打开定位开关
//    }
    
    
    CLLocationManager  *locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager requestAlwaysAuthorization];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager=locationManager;
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];
    
    [self setupNavBar];

    [self setupTextView];

    [self setupToolbar];

    [self setupPhotosView];
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *loc=[locations lastObject];
    NSLog(@"纬度=%f经度=%f",loc.coordinate.latitude, loc.coordinate.longitude);
    [manager stopUpdatingLocation];
    
//    [self.geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
//        if (error||placemarks.count==0) {
//            //可能在火星上
//            NSLog(@"可能在火星上");
//        }else{
//            CLPlacemark *firstPlacemark=[placemarks firstObject];
////            NSString *name=firstPlacemark.name;
//            NSLog(@"firstPlacemark.name=%@",firstPlacemark.name);
//        }
//    }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        break;
        
        default:
        break;
    }
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
    toolbar.height = 64;
    self.toolbar = toolbar;
    
    toolbar.y = self.view.height - toolbar.height;
    [self.view addSubview:toolbar];
}

// 添加输入控件
- (void)setupTextView
{
    JYLTextView *textView = [[JYLTextView alloc] init];
    textView.alwaysBounceVertical = YES; // 垂直方向上拥有有弹簧效果
    textView.frame=CGRectMake(0, 0, 320, 300);
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
    //[[self.photosView subviews] performSelector:@selector(removeFromSuperview) withObject:self];
    [self.photosView removeAllPhotos];
    self.textView.text=nil;
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
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 上传图片，返回图片名
    NSArray *uploadImgNames = [self uploadImages:self.photosView.images];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"statususerid"]=@"statususerid";
    params[@"statustitle"]=self.textView.text;
    for (int i=0; i<uploadImgNames.count; i++) {
        params[[NSString stringWithFormat:@"statuspic%d",i+1]]=uploadImgNames[i];
    }
    
    // 3.发送POST请求
#warning 还没有写完发送功能
}

-(NSArray *)uploadImages:(NSArray *)images{
    NSMutableArray *imgNames=[NSMutableArray array];
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = @"zhangsan";
    
    
    [mgr POST:@"http://chishenme.cc/index.php/index/uploadImgs" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        mgr.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
        
        for (int i=0; i<images.count; i++) {
            UIImage *img=images[i];
            NSData *imgData=UIImageJPEGRepresentation(img, 1.0);
            [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"pic%d",i] fileName:[NSString stringWithFormat:@"status%d.jpg",i] mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        NSLog(@"上传成功----%@", statusDict);
        for (int i=0; i<statusDict.count-1; i++) {
            NSString *imgName=statusDict[[NSString stringWithFormat:@"img%d",i]];
            [imgNames addObject:imgName];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败----%@", error);
    }];
    return imgNames;
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
