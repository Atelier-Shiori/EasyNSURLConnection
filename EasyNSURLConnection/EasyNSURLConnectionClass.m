//
//  EasyNSURLConnectionClass.m
//
//  Created by Nanoha Takamachi on 2014/11/25.
//  Copyright (c) 2014年 Atelier Shiori. Licensed under MIT License.
//
//  This class allows easy creation of synchronous request using NSURLSession
//

#import "EasyNSURLConnection.h"
#import "EasyNSURLResponse.h"

@interface EasyNSURLConnection ()
@property (strong) NSMutableURLRequest *request;
@end

@implementation EasyNSURLConnection

#pragma Post Methods Constants
NSString * const EasyNSURLPostMethod = @"POST";
NSString * const EasyNSURLPutMethod = @"PUT";
NSString * const EasyNSURLPatchMethod = @"PATCH";
NSString * const EasyNSURLDeleteMethod = @"DELETE";

#pragma constructors
-(id)init {
    // Set Default User Agent
    _useragent =[NSString stringWithFormat:@"%@ %@ (Macintosh; Mac OS X %@; %@)", [NSBundle mainBundle].infoDictionary[@"CFBundleName"],[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"], [NSDictionary dictionaryWithContentsOfFile:@"/System/Library/CoreServices/SystemVersion.plist"][@"ProductVersion"], [NSLocale currentLocale].localeIdentifier];
    return [super init];
}
-(id)initWithURL:(NSURL *)address {
    _URL = address;
    return [self init];
}
#pragma getters
-(NSString *)getResponseDataString {
    NSString *datastring = [[NSString alloc] initWithData:_responsedata encoding:NSUTF8StringEncoding];
    return datastring;
}
-(id)getResponseDataJsonParsed {
    return [NSJSONSerialization JSONObjectWithData:_responsedata options:0 error:nil];
}
-(long)getStatusCode {
    return _response.statusCode;
}
#pragma mutators
-(void)addHeader:(id)object
          forKey:(NSString *)key {
    NSLock * lock = [NSLock new]; // NSMutableArray is not Thread Safe, lock before performing operation
    [lock lock];
    if (_formdata == nil) {
        //Initalize Header Data Array
        _headers = [NSMutableDictionary new];
    }
    [_headers setObject:object forKey:key];
    [lock unlock]; //Finished operation, unlock
}
-(void)addFormData:(id)object
            forKey:(NSString *)key{
    NSLock * lock = [NSLock new]; // NSMutableArray is not Thread Safe, lock before performing operation
    [lock lock];
    if (_formdata == nil) {
        //Initalize Form Data Array
        _formdata = [NSMutableDictionary new];
    }
    [_formdata setObject:object forKey:key];
    [lock unlock]; //Finished operation, unlock
}
#pragma request functions
-(void)startRequest {
    // Send a synchronous request
    _request = [NSMutableURLRequest requestWithURL:_URL];
    // Do not use Cookies
    _request.HTTPShouldHandleCookies = _usecookies;
    // Set Timeout
    _request.timeoutInterval = 15;
    // Set User Agent
    [_request setValue:_useragent forHTTPHeaderField:@"User-Agent"];
    NSLock * lock = [NSLock new]; // NSMutableArray is not Thread Safe, lock before performing operation
    [lock lock];
    // Set Other headers, if any
    [self setAllHeaders];
    [lock unlock];
    // Send Request
    EasyNSURLResponse * urlsessionresponse = [self performNSURLSessionRequest];
    _responsedata = urlsessionresponse.responsedata;
    _error = urlsessionresponse.error;
    _response = urlsessionresponse.response;
}
-(void)startFormRequest {
    // Send a synchronous request
    _request = [NSMutableURLRequest requestWithURL:_URL];
    // Set Method
    if (_postmethod.length != 0) {
        _request.HTTPMethod = _postmethod;
    }
    else {
        _request.HTTPMethod = @"POST";
    }
    // Set content type to form data
    [_request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    // Do not use Cookies
    _request.HTTPShouldHandleCookies = _usecookies;
    // Set User Agent
    [_request setValue:_useragent forHTTPHeaderField:@"User-Agent"];
    // Set Timeout
    _request.timeoutInterval = 15;
    NSLock * lock = [NSLock new]; // NSMutableArray is not Thread Safe, lock before performing operation
    [lock lock];
    //Set Post Data
    _request.HTTPBody = [self encodeDictionaries:_formdata];
    // Set Other headers, if any
    [self setAllHeaders];
    [lock unlock];
    // Send Request
    EasyNSURLResponse * urlsessionresponse = [self performNSURLSessionRequest];
    _responsedata = urlsessionresponse.responsedata;
    _error = urlsessionresponse.error;
    _response = urlsessionresponse.response;
}
-(void)startJSONRequest:(NSString *)body type:(int)bodytype {
    // Send a synchronous request
    _request = [NSMutableURLRequest requestWithURL:_URL];
    // Set Method
    if (_postmethod.length != 0) {
        _request.HTTPMethod = _postmethod;
    }
    else {
        _request.HTTPMethod = @"POST";
    }
    // Set content type to form data
    switch (bodytype){
        case 0:
            [_request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            break;
        case 1:
            [_request setValue:@"application/vnd.api+json" forHTTPHeaderField:@"Content-Type"];
            break;
    }
    // Do not use Cookies
    _request.HTTPShouldHandleCookies = _usecookies;
    // Set User Agent
    [_request setValue:_useragent forHTTPHeaderField:@"User-Agent"];
    // Set Timeout
    _request.timeoutInterval = 5;
    NSLock * lock = [NSLock new]; // NSMutableArray is not Thread Safe, lock before performing operation
    [lock lock];
    //Set Post Data
    _request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    // Set Other headers, if any
    [self setAllHeaders];
    [lock unlock];
    // Send Request
    EasyNSURLResponse * urlsessionresponse = [self performNSURLSessionRequest];
    _responsedata = urlsessionresponse.responsedata;
    _error = urlsessionresponse.error;
    _response = urlsessionresponse.response;
}
-(void)startJSONFormRequest:(int)bodytype {
    // Send a synchronous request
    _request = [NSMutableURLRequest requestWithURL:_URL];
    // Set Method
    if (_postmethod.length != 0) {
        _request.HTTPMethod = _postmethod;
    }
    else {
        _request.HTTPMethod = @"POST";
    }
    // Set content type to form data
    switch (bodytype){
        case 0:
            [_request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            break;
        case 1:
            [_request setValue:@"application/vnd.api+json" forHTTPHeaderField:@"Content-Type"];
            break;
    }
    // Do not use Cookies
    _request.HTTPShouldHandleCookies = _usecookies;
    // Set User Agent
    [_request setValue:_useragent forHTTPHeaderField:@"User-Agent"];
    // Set Timeout
    _request.timeoutInterval = 5;
    NSLock * lock = [NSLock new]; // NSMutableArray is not Thread Safe, lock before performing operation
    [lock lock];
    //Set Post Data
    NSError *jerror;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_formdata options:0 error:&jerror];
    if (!jsonData) {}
    else{
        NSString *JSONString = [[NSString alloc] initWithBytes:jsonData.bytes length:jsonData.length encoding:NSUTF8StringEncoding];
        _request.HTTPBody = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    }
    // Set Other headers, if any
    [self setAllHeaders];
    [lock unlock];
    // Send Request
    EasyNSURLResponse * urlsessionresponse = [self performNSURLSessionRequest];
    _responsedata = urlsessionresponse.responsedata;
    _error = urlsessionresponse.error;
    _response = urlsessionresponse.response;
}

#pragma helpers
- (NSData*)encodeDictionaries:(NSDictionary *)dic {
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dic.allKeys) {
        NSString *encodedValue = [dic[key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        NSString *encodedKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}
-(EasyNSURLResponse *)performNSURLSessionRequest {
    // Based on http://demianturner.com/2016/08/synchronous-nsurlsession-in-obj-c/
    __block NSHTTPURLResponse *urlresponse = nil;
    __block NSData *data = nil;
    __block NSError * error2 = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:_request completionHandler:^(NSData *taskData, NSURLResponse *rresponse, NSError *eerror) {
        data = taskData;
        urlresponse = (NSHTTPURLResponse *)rresponse;
        error2 = eerror;
        dispatch_semaphore_signal(semaphore);
        
    }];
    [dataTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return [[EasyNSURLResponse alloc] initWithData:data withResponse:urlresponse withError:error2];
}
- (void)setAllHeaders {
    if (_headers != nil) {
        for (NSString *key in _headers.allKeys ) {
            //Set any headers
            [_request setValue:_headers[key] forHTTPHeaderField:key];
        }
    }
}
@end
