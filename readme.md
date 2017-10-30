# EasyNSURLConnection

EasyNSURLConnection is a lightweight HTTP request framework that allows one to easily create synchronous and asynchronous http requests. While this is not recommended to use a synchronous request since it freezes the application while a request is being made, sometimes making an asynchronous connection can make things too complicated.

This class uses NSURLSession as a replacement for "sendSynchronousRequest:returningResponse:error:". For asynchronous requests, it uses NSURLSessions with completion and error blocks.


## How to Build
1. You will need Xcode 8 or later to build this project
2. Clone the repo
3. Type xcodebuild to build the project

## How to use 
### Objective C
1. Copy the framework to your XCode Project
2. Add this to the header file.
```objective-c
#import <EasyNSURLConnection/EasyNSURLConnection.h>
```

To use, simply do the following for a sychronous request:
```objective-c
	// Create a request
	NSURL *url = [NSURL URLWithString:@"https://google.com"];
    EasyNSURLConnection *request = [[EasyNSURLConnection alloc] initWithURL:url];
    //Ignore Cookies
    [request setUseCookies:NO];
	// Add Form Data
	[request addFormData:@"SomeData" forKey:@"Data"];
	// Start Form Request
	[request startFormRequest];
	if ([request getStatusCode] == 200){
		NSLog(@"%@", [request getResponseData]);
	}
	else{
		NSLog(@"Error: %@", [request getError]);
	}
	
```

For an Async request (get request, but other methods are simular, but have a param argument:
```objective-c
    EasyNSURLConnection *request = [EasyNSURLConnection new];
    [request GET:@"https://raw.githubusercontent.com/Atelier-Shiori/anime-season-json/master/data/2017-fall.json" headers:nil completion:^(EasyNSURLResponse *response) {
    _output.string = [NSString stringWithFormat:@"%@",response.getResponseDataJsonParsed];
    } error:^(NSError *error, int statuscode) {
    NSLog(@"%@",error);
    }];

```

## Documentation
Documentation can be viewed [here](https://developer.ateliershiori.moe/easynsurlconnection/index.html)

## License

EasyNSURLConnection is licensed under MIT License.
