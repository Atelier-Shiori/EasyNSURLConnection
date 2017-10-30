//
//  AppDelegate.m
//  EasyNSURLConnectionSample
//
//  Created by 桐間紗路 on 2017/10/30.
//  Copyright © 2017年 Atelier Shiori. All rights reserved.
//

#import "AppDelegate.h"
#import <EasyNSURLConnection/EasyNSURLConnection.h>

@interface AppDelegate ()
@property (unsafe_unretained) IBOutlet NSTextView *output;

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)testasync:(id)sender {
    EasyNSURLConnection *request = [EasyNSURLConnection new];
    [request GET:@"https://raw.githubusercontent.com/Atelier-Shiori/anime-season-json/master/data/2017-fall.json" headers:nil completion:^(EasyNSURLResponse *response) {
        _output.string = [NSString stringWithFormat:@"%@",response.getResponseDataJsonParsed];
    } error:^(NSError *error, int statuscode) {
        NSLog(@"%@",error);
    }];
}

@end
