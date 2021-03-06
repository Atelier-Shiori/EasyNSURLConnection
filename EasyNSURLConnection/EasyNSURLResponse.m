//
//  EasyNSURLResponse.m
//  EasyNSURLConnection
//
//  Created by 桐間紗路 on 2017/03/03.
//  Copyright © 2017 Atelier Shiori. All rights reserved. Licensed under MIT License.
//

#import "EasyNSURLResponse.h"

@implementation EasyNSURLResponse
- (id)initWithData:(NSData *)rdata withResponse:(NSHTTPURLResponse *)rresponse withError:(NSError*)eerror{
    self = [super init];
    if (self){
        self.responsedata = rdata;
        self.response = rresponse;
        self.error = eerror;
    }
    return self;
}
- (NSString *)getResponseDataString {
    NSString *datastring = [[NSString alloc] initWithData:_responsedata encoding:NSUTF8StringEncoding];
    return datastring;
}
- (id)getResponseDataJsonParsed {
    return [NSJSONSerialization JSONObjectWithData:_responsedata options:0 error:nil];
}
- (long)getStatusCode {
    return _response.statusCode;
}
@end
