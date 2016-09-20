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
        NSString* cbId = [commands.arguments objectAtIndex:0];
        
        // 用户的参数会在第二个参数传回
        NSString* pArgument1 = [commands.arguments objectAtIndex:1];
        NSString* pArgument2 = [commands.arguments objectAtIndex:2];
        NSString* pArgument3 = [commands.arguments objectAtIndex:3];
        NSString* pArgument4 = [commands.arguments objectAtIndex:4];
        
    
        
        // 如果使用Array方式传递参数
        NSArray* pResultString = [NSArray arrayWithObjects:pArgument1, pArgument2, pArgument3, pArgument4, nil];
        
        // 运行Native代码结果和预期相同，调用回调通知JS层运行成功并返回结果
        // PDRCommandStatusOK 表示触发JS层成功回调方法
        // PDRCommandStatusError 表示触发JS层错误回调方法
        
        // 如果方法需要持续触发页面回调，可以通过修改 PDRPluginResult 对象的keepCallback 属性值来表示当前是否可重复回调， true 表示可以重复回调   false 表示不可重复回调  默认值为false
        
        PDRPluginResult *result = [PDRPluginResult resultWithStatus:PDRCommandStatusOK messageAsArray: pResultString];
        
        // 如果Native代码运行结果和预期不同，需要通过回调通知JS层出现错误，并返回错误提示
        //PDRPluginResult *result = [PDRPluginResult resultWithStatus:PDRCommandStatusError messageAsString:@"惨了! 出错了！ 咋(wu)整(liao)"];
        
        // 通知JS层Native层运行结果
        [self toCallback:cbId withReslut:[result toJSONString]];
    }
}


@end
