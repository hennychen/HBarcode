//
//  PluginBarScan.m
//  HBuilder-Integrate
//
//  Created by hennychen on 9/20/16.
//  Copyright © 2016 DCloud. All rights reserved.
//

#import "PGPluginBarScan.h"
#import "PDRCoreAppFrame.h"
#import "H5WEEngineExport.h"
#import "PDRToolSystemEx.h"

#import "ZFScanViewController.h"
@interface PGPluginBarScan()
{
    
}

@property(nonatomic, copy)NSString* cbId;

@end

@implementation PGPluginBarScan
#pragma mark 这个方法在使用WebApp方式集成时触发，WebView集成方式不触发

/*
 * WebApp启动时触发
 * 需要在PandoraApi.bundle/feature.plist/注册插件里添加autostart值为true，global项的值设置为true
 */
- (void) onAppStarted:(NSDictionary*)options{
    
    NSLog(@"5+ WebApp启动时触发");
    // 可以在这个方法里向Core注册扩展插件的JS
    
}

// 监听基座事件事件
// 应用退出时触发
- (void) onAppTerminate{
    //
    NSLog(@"APPDelegate applicationWillTerminate 事件触发时触发");
}

// 应用进入后台时触发
- (void) onAppEnterBackground{
    //
    NSLog(@"APPDelegate applicationDidEnterBackground 事件触发时触发");
}

// 应用进入前天时触发
- (void) onAppEnterForeground{
    //
    NSLog(@"APPDelegate applicationWillEnterForeground 事件触发时触发");
}

#pragma mark 以下为插件方法，由JS触发， WebView集成和WebApp集成都可以触发


- (void)PluginBarScanFunction:(PGMethod*)commands
{
    if ( commands ) {
        
        // CallBackid 异步方法的回调id，H5+ 会根据回调ID通知JS层运行结果成功或者失败
        self.cbId = [commands.arguments objectAtIndex:0];
        NSLog(@"cbid---%@",_cbId);

        [self scanAction:nil];
    }
}
-(void)callbackToJs:(NSString *)barcodestring{
    NSArray* pResultString = [NSArray arrayWithObjects:barcodestring, nil];
    PDRPluginResult * result = [PDRPluginResult resultWithStatus:PDRCommandStatusOK messageAsArray:pResultString];
    [self toCallback:self.cbId withReslut:[result toJSONString]];
}
/**
 *  扫描事件
 */
- (void)scanAction:(UIButton *)sender{
    ZFScanViewController * vc = [[ZFScanViewController alloc] init];
    UINavigationController * navscan = [[UINavigationController alloc] initWithRootViewController:vc];
    __block PGPluginBarScan * weakSelf = self;
    vc.returnScanBarCodeValue = ^(NSString * barCodeString){
        
        NSLog(@"扫描结果的字符串======%@",barCodeString);

        
        [weakSelf callbackToJs:barCodeString];
        
    };
    
    [self presentViewController:navscan animated:YES completion:^{
        
    }];
}


@end
