//
//  BlueToothViewController.m
//  WirelessOrder
//
//  Created by eteng on 14/12/29.
//  Copyright (c) 2014年 etenginfo. All rights reserved.
//

#import "BlueToothViewController.h"
//#import "MBProgressHUD.h"

@interface BlueToothViewController ()
@end

@implementation BlueToothViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_bg"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor=kUIColorFromRGB(0xeaeaea);
    NSDictionary *dic=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes=dic;
    
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame=CGRectMake(0, (44-36)/2, 50.25, 36);
    [btnBack setBackgroundImage:[UIImage imageNamed:@"bluetooth_back"] forState:UIControlStateNormal];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"bluetooth_back_select"] forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(pressBtnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton=[[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem=leftBarButton;
    
    UIButton *refreshBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.frame=CGRectMake(10, 10, 150, 40);
    [refreshBtn setBackgroundColor:[UIColor redColor]];
    [refreshBtn setTitle:@"刷新设备列表" forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refreshDevice:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshBtn];
    
//    UIButton *printTextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    printTextBtn.frame=CGRectMake(210, 10, 100, 40);
//    [printTextBtn setBackgroundColor:[UIColor redColor]];
//    [printTextBtn setTitle:@"打印测试" forState:UIControlStateNormal];
//    [printTextBtn addTarget:self action:@selector(printText:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:printTextBtn];
    
    _printerTalbe=[[UITableView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth, ScreenHeight-60)];
    _printerTalbe.delegate=self;
    _printerTalbe.dataSource=self;
    _printerTalbe.backgroundColor=kUIColorFromRGB(0xeaeaea);
    [self.view addSubview:_printerTalbe];
    
    _hudProgress=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hudProgress];
    _hudProgress.labelText=@"正在寻找设备...";
    [_hudProgress show:YES];
    
    _defaultBTServer = [BTServer defaultBTServer];
    _defaultBTServer.delegate = (id)self;
    [_defaultBTServer disConnect];
    [_defaultBTServer startScan];
}

-(void)pressBtnBack:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshDevice:(UIButton *)sender
{
    _hudProgress.labelText=@"正在寻找设备...";
    [_hudProgress show:YES];
    
    [_defaultBTServer stopScan:TRUE];
    _defaultBTServer.delegate = (id)self;
    [_defaultBTServer startScan];
    [_printerTalbe reloadData];
}

- (void)printText:(UIButton *)sender {
    
    _hudProgress.labelText=@"正在打印...";
    [_hudProgress show:YES];
    
    _defaultBTServer.printString=@"蓝牙小票机测试打印\n\n\n\n";
    
    [_defaultBTServer stopScan:YES];
    
    if ([_defaultBTServer.discoveredPeripherals count] > 0) {
        
    }
//    _pi = _defaultBTServer.discoveredPeripherals[0];
    [_defaultBTServer connect:_pi withFinishCB:^(CBPeripheral *peripheral, BOOL status, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_hudProgress hide:YES];
            if (status) {
                NSLog(@"connected success!");
                _timer= [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(requestService) userInfo:nil repeats:YES];
                
            }else{
                NSLog(@"connected failed!");
            }
        });
    }];
    
}


#pragma mark ----BTDelegate

-(void)didStopScan
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_defaultBTServer.discoveredPeripherals.count==0) {
            [_hudProgress hide:YES];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请确保蓝牙小票机和手机蓝牙已打开" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    });
}

-(void)didDisconnect
{
//    [_hudProgress hide:YES];
}

-(void)didFoundPeripheral
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_printerTalbe reloadData];
        [_hudProgress hide:YES];
    });
}

#pragma mark ----tableDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger n = [_defaultBTServer.discoveredPeripherals count];
    return n; 
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _hudProgress.labelText=@"正在连接设备...";
    [_hudProgress show:YES];
    
    [_defaultBTServer stopScan:YES];
    _pi = _defaultBTServer.discoveredPeripherals[indexPath.row];
    [_defaultBTServer connect:_defaultBTServer.discoveredPeripherals[indexPath.row] withFinishCB:^(CBPeripheral *peripheral, BOOL status, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status) {
                _hudProgress.labelText=@"连接成功";
                
                NSUserDefaults *userData=[NSUserDefaults standardUserDefaults];
                [userData setObject:@"1" forKey:@"printstate"];
                [userData synchronize];
                
                NSLog(@"connected success!");
                
//                _timer= [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(requestService) userInfo:nil repeats:YES];
                
            }else{
                _hudProgress.labelText=@"连接失败";
                
                NSUserDefaults *userData=[NSUserDefaults standardUserDefaults];
                [userData setObject:@"0" forKey:@"printstate"];
                [userData synchronize];
                
                NSLog(@"connected failed!");
            }
            [_hudProgress hide:YES];
        });
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"PeripheralCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    PeriperalInfo *pi = _defaultBTServer.discoveredPeripherals[indexPath.row];
    
    cell.textLabel.text= pi.name;
    return cell;
}


#pragma mark ----connection service
- (void)requestService
{
    
    for (CBService* ser  in _defaultBTServer.selectPeripheral.services) {
        
        [_defaultBTServer discoverService:ser];
        
        for (CBCharacteristic *ch in _defaultBTServer.discoveredSevice.characteristics) {
            
            NSString *s = [self getPropertiesString:ch.properties];
            
            if ([s isEqualToString:@" Read Write Notify Indicate"]) {
                
                [_timer invalidate];
                _timer=nil;
                
                [_defaultBTServer readValue:ch];
                
            }
        }
    }
}

-(NSString *)getPropertiesString:(CBCharacteristicProperties)properties
{
    NSMutableString *s = [[NSMutableString alloc]init];
    [s appendString:@""];
    
    if ((properties & CBCharacteristicPropertyBroadcast) == CBCharacteristicPropertyBroadcast) {
        [s appendString:@" Broadcast"];
    }
    if ((properties & CBCharacteristicPropertyRead) == CBCharacteristicPropertyRead) {
        [s appendString:@" Read"];
    }
    if ((properties & CBCharacteristicPropertyWriteWithoutResponse) == CBCharacteristicPropertyWriteWithoutResponse) {
        [s appendString:@" WriteWithoutResponse"];
    }
    if ((properties & CBCharacteristicPropertyWrite) == CBCharacteristicPropertyWrite) {
        [s appendString:@" Write"];
    }
    if ((properties & CBCharacteristicPropertyNotify) == CBCharacteristicPropertyNotify) {
        [s appendString:@" Notify"];
    }
    if ((properties & CBCharacteristicPropertyIndicate) == CBCharacteristicPropertyIndicate) {
        [s appendString:@" Indicate"];
    }
    if ((properties & CBCharacteristicPropertyAuthenticatedSignedWrites) == CBCharacteristicPropertyAuthenticatedSignedWrites) {
        [s appendString:@" AuthenticatedSignedWrites"];
    }
    if ((properties & CBCharacteristicPropertyExtendedProperties) == CBCharacteristicPropertyExtendedProperties) {
        [s appendString:@" ExtendedProperties"];
    }
    if ((properties & CBCharacteristicPropertyNotifyEncryptionRequired) == CBCharacteristicPropertyNotifyEncryptionRequired) {
        [s appendString:@" NotifyEncryptionRequired"];
    }
    if ((properties & CBCharacteristicPropertyIndicateEncryptionRequired) == CBCharacteristicPropertyIndicateEncryptionRequired) {
        [s appendString:@" IndicateEncryptionRequired"];
    }
    
    if ([s length]<2) {
        [s appendString:@"unknow"];
    }
    return s;
}


@end
