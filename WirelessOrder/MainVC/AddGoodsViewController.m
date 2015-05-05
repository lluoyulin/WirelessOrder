//
//  AddGoodsViewController.m
//  WirelessOrder
//
//  Created by eteng on 15/1/16.
//  Copyright (c) 2015年 etenginfo. All rights reserved.
//

#import "AddGoodsViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLSessionManager.h"
#import "GoodsInfoModel.h"
#import "sys/utsname.h"

@interface AddGoodsViewController ()

@end

@implementation AddGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化NavigationBar
    [self initNavigationBar];
    
    //初始化视图
    [self initView];
    
    _hudProgress=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hudProgress];
}

//初始化NavigationBar
-(void)initNavigationBar
{
    self.view.backgroundColor=kUIColorFromRGB(0xeaeaea);
    
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame=CGRectMake(0, (44-36)/2, 50.25, 36);
    [btnBack setBackgroundImage:[UIImage imageNamed:@"bluetooth_back"] forState:UIControlStateNormal];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"bluetooth_back_select"] forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(pressBtnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton=[[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem=leftBarButton;
}

//返回
-(void)pressBtnBack:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

//打开相册
-(void)pressImagePicker:(UITapGestureRecognizer *)tap
{
    /*注：使用，需要实现以下协议：UIImagePickerControllerDelegate,
     UINavigationControllerDelegate
     */
    if (_picker==nil) {
        _picker = [[UIImagePickerController alloc]init];
    }
    
    //设置图片源(相簿)
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //设置代理
    _picker.delegate = self;
    //设置可以编辑
    _picker.allowsEditing = YES;
    if ([[self deviceString] isEqualToString:@"iPhone4"] || [[self deviceString] isEqualToString:@"iPhone4S"]) {
        _picker.allowsEditing = NO;
    }
    //打开拾取器界面
    [self presentViewController:_picker animated:YES completion:nil];
}

//初始化视图
-(void)initView
{
    KeyboardToolBar *keyboardTopView =[[KeyboardToolBar alloc] init];
    keyboardTopView.delegateKeyboard=self;
    
    UIView *picView=[[UIView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 100)];
    picView.tag=101;
    picView.backgroundColor=kUIColorFromRGB(0xffffff);
    [self.view addSubview:picView];
    
    UIImageView *cameraBGImage=[[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 105, 67)];
    [cameraBGImage setImage:ImageNamed(@"camera_bg")];
    [picView addSubview:cameraBGImage];
    
    UIImageView *cameraImage=[[UIImageView alloc] initWithFrame:CGRectMake((cameraBGImage.frame.size.width-36)/2, 5, 36, 36)];
    [cameraImage setImage:ImageNamed(@"camera")];
    [cameraBGImage addSubview:cameraImage];
    
    UILabel *lblText=[[UILabel alloc] initWithFrame:CGRectMake((cameraBGImage.frame.size.width-70)/2, cameraImage.frame.size.height+cameraImage.frame.origin.y, 70, 20)];
    lblText.text=@"添加图片";
    lblText.textColor=kUIColorFromRGB(0xa7a7a7);
    [cameraBGImage addSubview:lblText];
    
    _picImage=[[UIImageView alloc] initWithFrame:cameraBGImage.frame];
    _picImage.userInteractionEnabled=YES;
    _picImage.layer.masksToBounds=YES;
    _picImage.layer.cornerRadius=5.0;
    [_picImage setAccessibilityValue:@""];
    [picView addSubview:_picImage];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressImagePicker:)];
    [_picImage addGestureRecognizer:tap];
    
    UIImageView *topLineImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, picView.frame.size.width, 1)];
    [topLineImage setImage:ImageNamed(@"remarkline")];
    [picView addSubview:topLineImage];
    
    UIImageView *bottomLineImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, picView.frame.size.height-1, picView.frame.size.width, 1)];
    [bottomLineImage setImage:ImageNamed(@"remarkline")];
    [picView addSubview:bottomLineImage];
    
    UITextField *nameText=[[UITextField alloc] initWithFrame:CGRectMake(10,picView.frame.size.height+picView.frame.origin.y+20, ScreenWidth-20, 30)];
    nameText.tag=201;
    nameText.placeholder=@"请输入菜品名";
    nameText.clearButtonMode=UITextFieldViewModeWhileEditing;
    nameText.borderStyle = UITextBorderStyleRoundedRect;
    nameText.inputAccessoryView=keyboardTopView;
    nameText.delegate=self;
    [self.view addSubview:nameText];
    
    UITextField *priceText=[[UITextField alloc] initWithFrame:CGRectMake(nameText.frame.origin.x,nameText.frame.size.height+nameText.frame.origin.y+10, nameText.frame.size.width, nameText.frame.size.height)];
    priceText.tag=202;
    priceText.placeholder=@"请输入价格";
    priceText.keyboardType=UIKeyboardTypeDecimalPad;
    priceText.clearButtonMode=UITextFieldViewModeWhileEditing;
    priceText.borderStyle = UITextBorderStyleRoundedRect;
    priceText.inputAccessoryView=keyboardTopView;
    priceText.delegate=self;
    [self.view addSubview:priceText];
    
    UITextField *goodsTypeText=[[UITextField alloc] initWithFrame:CGRectMake(priceText.frame.origin.x,priceText.frame.size.height+priceText.frame.origin.y+10, priceText.frame.size.width, priceText.frame.size.height)];
    goodsTypeText.tag=203;
    goodsTypeText.keyboardType=UIKeyboardTypeDecimalPad;
    goodsTypeText.clearButtonMode=UITextFieldViewModeWhileEditing;
    goodsTypeText.borderStyle = UITextBorderStyleRoundedRect;
    goodsTypeText.inputAccessoryView=keyboardTopView;
    goodsTypeText.delegate=self;
    goodsTypeText.text=@"正品";
    [goodsTypeText setAccessibilityValue:@"1"];
    [self.view addSubview:goodsTypeText];
    
    UIButton *btnSave=[[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-10-110,goodsTypeText.frame.size.height+goodsTypeText.frame.origin.y+20, 110, 35)];
    [btnSave setTitle:@"提交" forState:UIControlStateNormal];
    [btnSave setBackgroundImage:ImageNamed(@"btnbg") forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(saveGoodsInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSave];

}

//关闭键盘
- (void)resignKeyboard
{
    UITextField *nameText=(UITextField *)[self.view viewWithTag:201];
    UITextField *priceText=(UITextField *)[self.view viewWithTag:202];
    [nameText resignFirstResponder];
    [priceText resignFirstResponder];
    
    self.view.frame=CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width, self.view.frame.size.height);
}

//关闭类型选择器
-(void)pressPopBtn:(UIButton *)btn
{
    [[[btn superview] superview] removeFromSuperview];
}

//保存菜品信息
-(void)saveGoodsInfo:(UIButton *)btn
{
    UITextField *nameText=(UITextField *)[self.view viewWithTag:201];
    UITextField *priceText=(UITextField *)[self.view viewWithTag:202];
    UITextField *goodsTypeText=(UITextField *)[self.view viewWithTag:203];
    NSCharacterSet *whitespace =[NSCharacterSet whitespaceAndNewlineCharacterSet];

    if ([_picImage.accessibilityValue isEqualToString:@""]) {
        [self alertMessage:@"请为该菜品提供图片"];
        return;
    }
    if ([[nameText.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""]) {
        [nameText becomeFirstResponder];
        return;
    }
    if ([[priceText.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""]) {
        [priceText becomeFirstResponder];
        return;
    }
    
    _hudProgress.labelText=@"正在提交数据...";
    [_hudProgress show:YES];
    showNetLogoYES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"goodsName":nameText.text,@"goodsPrice":priceText.text,@"sellerId":[UserData objectForKey:@"sellerId"],@"classId":self.goodsclassid,@"goodsType":goodsTypeText.accessibilityValue};
    NSURL *filePath = [NSURL fileURLWithPath:_picImage.accessibilityValue];
    [manager POST:[HttpUrl stringByAppendingString:@"uploadFileByForm"] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        /**
         *  appendPartWithFileURL   //  指定上传的文件
         *  name                    //  指定在服务器中获取对应文件或文本时的key
         *  fileName                //  指定上传文件的原始文件名
         *  mimeType                //  指定商家文件的MIME类型
         */
        [formData appendPartWithFileURL:filePath name:@"file" fileName:[_picImage.accessibilityValue substringFromIndex:_picImage.accessibilityValue.length-17] mimeType:@"image/png" error:nil];
//        [formData appendPartWithFileURL:filePath name:@"file" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [_hudProgress hide:YES];
        showNetLogoNO;
        
        NSDictionary *result=(NSDictionary *)responseObject;
        if ([[result objectForKey:@"code"] isEqualToString:@"0"]) {
            GoodsInfoModel *model=[GoodsInfoModel GoodsModelFromDictionary:[result objectForKey:@"goods"]];
            [GoodsInfoModel saveGoods:model];
            
            [_picImage setImage:nil];
            [_picImage setAccessibilityValue:@""];
            nameText.text=@"";
            priceText.text=@"";
            goodsTypeText.text=@"正品";
            [goodsTypeText setAccessibilityValue:@"1"];
            
            [self showMsg:@"提交成功"];
        }
        else{
            [self alertMessage:[result objectForKey:@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hudProgress hide:YES];
        showNetLogoNO;
        
        [self alertMessage:@"提交失败"];
        NSLog(@"Error: %@", error);
    }];
}

//弹出系统提示框
-(void)alertMessage:(NSString *)msg
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

//提示语
-(void)showMsg:(NSString *)msg
{
    _hudShowMsg=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hudShowMsg];
    
    _hudShowMsg.labelText=msg;
    _hudShowMsg.mode=MBProgressHUDModeText;
    
    [_hudShowMsg showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [_hudShowMsg removeFromSuperview];
        _hudShowMsg=nil;
    }];
}

#pragma UITextField委托
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==203) {
        UIView *popView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        popView.backgroundColor=[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"pop_bg"]];
        [self.view addSubview:popView];
        
        UIPickerView *goodsTypePickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0, popView.frame.size.height-256, 0, 0)];
        goodsTypePickerView.delegate=self;
        goodsTypePickerView.dataSource=self;
        goodsTypePickerView.backgroundColor=kUIColorFromRGB(0xffffff);
        [popView addSubview:goodsTypePickerView];
        
        UIView *btnView=[[UIView alloc] initWithFrame:CGRectMake(0,goodsTypePickerView.frame.origin.y-35, ScreenWidth, 40)];
        btnView.backgroundColor=kUIColorFromRGB(0xedecec);
        [popView addSubview:btnView];
        
        UIButton *submitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.frame=CGRectMake(btnView.frame.size.width-60, (btnView.frame.size.height-30)/2, 50, 30);
        [submitBtn setTitle:@"完成" forState:UIControlStateNormal];
        [submitBtn setTitleColor:kUIColorFromRGB(0xf33637) forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(pressPopBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:submitBtn];
        
        UITextField *goodsTypeText=(UITextField *)[self.view viewWithTag:203];
        if ([goodsTypeText.accessibilityValue isEqualToString:@"1"]) {
            [goodsTypePickerView selectRow:0 inComponent:0 animated:YES];
        }
        else if([goodsTypeText.accessibilityValue isEqualToString:@"2"]){
            [goodsTypePickerView selectRow:1 inComponent:0 animated:YES];
        }
        else{
            goodsTypeText.text=@"正品";
            [goodsTypeText setAccessibilityValue:@"1"];
        }
        
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==201 ||textField.tag==202) {
        CGRect frame = textField.frame;
        
        CGFloat textToView=frame.origin.y+frame.size.height;
        CGFloat keybordToView=self.view.frame.size.height-256.0;
        
        if (textToView>=keybordToView) {
            self.view.frame=CGRectMake(self.view.frame.origin.x, keybordToView-textToView, self.view.frame.size.width, self.view.frame.size.height);
        }
    }
}

#pragma pickerview委托
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row==0) {
        return @"正品";
    }
    else{
        return @"附加";
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UITextField *goodsTypeText=(UITextField *)[self.view viewWithTag:203];
    if (row==0) {
        goodsTypeText.text=@"正品";
        [goodsTypeText setAccessibilityValue:@"1"];
    }
    else if(row==1)
    {
        goodsTypeText.text=@"附加";
        [goodsTypeText setAccessibilityValue:@"2"];
    }
}

#pragma mark UIImagePickerControllerDelegate methods
//完成选择图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    //选择框消失
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHMMssSSS"];
    
    [self saveImage:image withName:[[formatter stringFromDate:[NSDate date]] stringByAppendingString:@".png"]];
    
    //加载图片
    [_picImage setImage:image];
}

//取消选择图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.1);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    
    [_picImage setAccessibilityValue:fullPath];
    
    [imageData writeToFile:fullPath atomically:NO];
}

//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

#pragma mark 判断设备型号
- (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone5";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}

@end
