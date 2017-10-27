# EasyNSURLConnection

EasyNSURLConnection is a lightweight HTTP request framework that allows one to easily create synchronous and asynchronous http requests. While this is not recommended to use a synchronous request since it freezes the application while a request is being made, sometimes making an asynchronous connection can make things too complicated.

This class uses NSURLSession as a replacement for "sendSynchronousRequest:returningResponse:error:".


## How to Build
1. You will need Xcode 8 or later to build this project
2. Clone the repo
3. Type xcodebuild to build the project

## How to use 
### Objective C
1. Copy the framework to your XCode Project
2. Add this to the header file.
```objective-c
#import <EasyNSURLConnection/EasyNSURLConnectionClass.h>
```

To use, simply do the following:
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
## Documentation
Documentation can be viewed [here](https://developer.ateliershiori.moe/easynsurlconnection/index.html)

## License

EasyNSURLConnection is licensed under MIT License.
