//
//  EasyNSURLConnectionClass.m
//
//  Created by Nanoha Takamachi on 2014/11/25.
//  Copyright (c) 2014年 Atelier Shiori. Licensed under MIT License.
//
//  This class allows easy creation of synchronous and asynchronous request using NSURLSession.
//

#import "EasyNSURLConnection.h"
#import "EasyNSURLResponse.h"

@interface EasyNSURLConnection ()
@property (strong) NSMutableURLRequest *request;
@end

@implementation EasyNSURLConnection

#pragma Post Methods Constants
NSString * const EasyNSURLPostMethod = @"POST";
NSString * const EasyNSURLHeadMethod = @"HEAD";
NSString * const EasyNSURLPutMethod = @"PUT";
NSString * const EasyNSURLPatchMethod = @"PATCH";
NSString * const EasyNSURLDeleteMethod = @"DELETE";

#pragma constructors
-(id)init {
    // Set Default User Agent
    _useragent = [NSString stringWithFormat:@"%@ %@ (Macintosh; Mac OS X %@; %@)", [NSBundle mainBundle].infoDictionary[@"CFBundleName"],[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"], [NSDictionary dictionaryWithContentsOfFile:@"/System/Library/CoreServices/SystemVersion.plist"][@"ProductVersion"], [NSLocale currentLocale].localeIdentifier];
    return [super init];
}
-(id)initWithURL:(NSURL *)address {
    _URL = address;
    return [self init];
}
#pragma getters
-(NSString *)getResponseDataString {
    return [_response getResponseDataString];
}
-(id)getResponseDataJsonParsed {
    return [_response getResponseDataJsonParsed];
}
-(long)getStatusCode {
    return [_response getStatusCode];
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
    [self setuprequest];
    _request.HTTPMethod = @"GET";
    [self setrequestheaders];
    // Send Request
    _response = [self performNSURLSessionRequest];
}
-(void)startFormRequest {
    // Send a synchronous request
    [self setuprequest];
    // Set Method
    if (_postmethod.length != 0) {
        _request.HTTPMethod = _postmethod;
    }
    else {
        _request.HTTPMethod = EasyNSURLPostMethod;
    }
    [self setFormRequestData];
    // Set Other headers, if any
    [self setrequestheaders];
    // Send Request
    _response = [self performNSURLSessionRequest];
}
- (void)startJSONRequest:(NSString *)body type:(int)bodytype {
    _jsonbody = body;
    _jsontype = bodytype;
    [self startFormRequest];
}
- (void)startJSONFormRequest:(int)bodytype {
    _usejson = true;
    _jsontype = bodytype;
    [self startFormRequest];
}

#pragma mark Async Request Methods
- (void)GET:(NSString *)url headers:(NSDictionary *)headers completion:(void (^)(EasyNSURLResponse *response))completion error:(void (^)(NSError *error, int statuscode))error {
    _URL = [NSURL URLWithString:url];
    [self setuprequest];
    _request.HTTPMethod = @"GET";
    [_headers addEntriesFromDictionary:headers];
    [self setrequestheaders];
    [self performasyncrequest:^(EasyNSURLResponse *response) {
        completion(response);
    } error:^(NSError *eerror, int statuscode) {
        error(eerror, statuscode);
    }];
}
- (void)HEAD:(NSString *)url parameters:(NSDictionary *)param headers:(NSDictionary *)headers completion:(void (^)(EasyNSURLResponse *response))completion error:(void (^)(NSError *error, int statuscode))error {
    _URL = [NSURL URLWithString:url];
    [self setuprequest];
    _request.HTTPMethod = EasyNSURLHeadMethod;
    [_headers addEntriesFromDictionary:headers];
    [_formdata addEntriesFromDictionary:param];
    [self setFormRequestData];
    [self setrequestheaders];
    [self performasyncrequest:^(EasyNSURLResponse *response) {
        completion(response);
    } error:^(NSError *eerror, int statuscode) {
        error(eerror, statuscode);
    }];
}
- (void)POST:(NSString *)url parameters:(NSDictionary *)param headers:(NSDictionary *)headers completion:(void (^)(EasyNSURLResponse *response))completion error:(void (^)(NSError *error, int statuscode))error {
    _URL = [NSURL URLWithString:url];
    [self setuprequest];
    _request.HTTPMethod = EasyNSURLPostMethod;
    [_headers addEntriesFromDictionary:headers];
    [_formdata addEntriesFromDictionary:param];
    [self setFormRequestData];
    [self setrequestheaders];
    [self performasyncrequest:^(EasyNSURLResponse *response) {
        completion(response);
    } error:^(NSError *eerror, int statuscode) {
        error(eerror, statuscode);
    }];
}
- (void)PATCH:(NSString *)url parameters:(NSDictionary *)param headers:(NSDictionary *)headers completion:(void (^)(EasyNSURLResponse *response))completion error:(void (^)(NSError *error, int statuscode))error {
    _URL = [NSURL URLWithString:url];
    [self setuprequest];
    _request.HTTPMethod = EasyNSURLPatchMethod;
    [_headers addEntriesFromDictionary:headers];
    [_formdata addEntriesFromDictionary:param];
    [self setFormRequestData];
    [self setrequestheaders];
    [self performasyncrequest:^(EasyNSURLResponse *response) {
        completion(response);
    } error:^(NSError *eerror, int statuscode) {
        error(eerror, statuscode);
    }];
}
- (void)DELETE:(NSString *)url parameters:(NSDictionary *)param headers:(NSDictionary *)headers completion:(void (^)(EasyNSURLResponse *response))completion error:(void (^)(NSError *error, int statuscode))error {
    _URL = [NSURL URLWithString:url];
    [self setuprequest];
    _request.HTTPMethod = EasyNSURLDeleteMethod;
    [_headers addEntriesFromDictionary:headers];
    [_formdata addEntriesFromDictionary:param];
    [self setFormRequestData];
    [self setrequestheaders];
    [self performasyncrequest:^(EasyNSURLResponse *response) {
        completion(response);
    } error:^(NSError *eerror, int statuscode) {
        error(eerror, statuscode);
    }];
}

#pragma helpers
- (NSData *)encodeDictionaries:(NSDictionary *)dic {
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
- (void)performasyncrequest:(void (^)(EasyNSURLResponse *response))completion error:(void (^)(NSError *error, int statuscode))error {
    NSURLSession *session = [NSURLSession sharedSession];
    [session dataTaskWithRequest:_request completionHandler:^(NSData *taskData, NSURLResponse *rresponse, NSError *eerror) {
        if (!eerror) {
            completion([[EasyNSURLResponse alloc] initWithData:taskData withResponse:(NSHTTPURLResponse *)rresponse withError:eerror]);
        }
        else {
            error(eerror, (int)((NSHTTPURLResponse *)rresponse).statusCode);
        }
    }];
}
- (void)setAllHeaders {
    if (_headers != nil) {
        _request.allHTTPHeaderFields = _headers;
    }
    // Set User Agent
    [_request setValue:_useragent forHTTPHeaderField:@"User-Agent"];
    // Set Body Type
    if (_usejson) {
        switch (_jsontype){
            case 0:
                [_request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                break;
            case 1:
                [_request setValue:@"application/vnd.api+json" forHTTPHeaderField:@"Content-Type"];
                break;
        }
    }
    else {
        [_request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
}
- (void)setuprequest {
    // Send a synchronous request
    _request = [NSMutableURLRequest requestWithURL:_URL];
    // Do not use Cookies
    _request.HTTPShouldHandleCookies = _usecookies;
    // Set Timeout
    _request.timeoutInterval = 15;
}
- (void)setrequestheaders {
    NSLock * lock = [NSLock new]; // NSMutableArray is not Thread Safe, lock before performing operation
    [lock lock];
    // Set Other headers, if any
    [self setAllHeaders];
    [lock unlock];
}
- (void)setFormRequestData {
    NSLock * lock = [NSLock new]; // NSMutableArray is not Thread Safe, lock before performing operation
    // Set content type to form data
    if (_usejson) {
        // Set content type to form data
        if (_jsonbody) {
            [lock lock];
            //Set Post Data
            _request.HTTPBody = [_jsonbody dataUsingEncoding:NSUTF8StringEncoding];
            [lock unlock];
        }
        else {
            [lock lock];
            //Set Post Data
            NSError *jerror;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_formdata options:0 error:&jerror];
            if (!jsonData) {}
            else{
                NSString *JSONString = [[NSString alloc] initWithBytes:jsonData.bytes length:jsonData.length encoding:NSUTF8StringEncoding];
                _request.HTTPBody = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
            }
            [lock unlock];
        }
    }
    else {
        //Set Post Data
        [lock lock];
        _request.HTTPBody = [self encodeDictionaries:_formdata];
        [lock unlock];
    }
}
@end
