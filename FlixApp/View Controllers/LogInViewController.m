//
//  LogInViewController.m
//  FlixApp
//
//  Created by Xurxo Riesco on 6/25/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "LogInViewController.h"
#import "MoviesViewController.h"
#import <WebKit/WebKit.h>

@interface LogInViewController ()
@property (strong, nonatomic) IBOutlet WKWebView *webView;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *sessionID;


@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/authentication/token/new?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                // Store the returned array of dictionaries in our posts property
                NSLog(@"%@", dataDictionary);
                self.token = dataDictionary[@"request_token"];
                NSLog(@"%@", self.token);
                NSString *loginURL = @"https://www.themoviedb.org/authenticate/";
                NSString *loginURL2 = [loginURL stringByAppendingString:self.token];
                NSString *urlString  = [loginURL2 stringByAppendingString: @"?redirect_to=https://www.themoviedb.org/?language=en-US"];

                NSURL *url = [NSURL URLWithString:urlString];

                // Place the URL in a URL Request.
                NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                         cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                     timeoutInterval:10.0];
                // Load Request into WebView.
                [self.webView loadRequest:request];
            }
                }];
            [task resume];
    
            // Convert the url String to a NSURL object.
            
            // Do any additional setup after loading the view.
}
                /*
                NSString *baseString = @"https://api.themoviedb.org/3/authentication/session/new?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&request_token=";
                NSString *sessionURLString = [baseString stringByAppendingString:self.token];
                NSURL *sessionurl = [NSURL URLWithString:sessionURLString];
                NSLog(@"%@", sessionURLString);
                NSURLRequest *requestSession = [NSURLRequest requestWithURL:sessionurl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
                NSURLSession *sessionID = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
                NSURLSessionDataTask *taskID = [sessionID dataTaskWithRequest:requestSession completionHandler:^(NSData *dataID, NSURLResponse *responseID, NSError *errorID) {
                        if (errorID != nil) {
                            NSLog(@"%@", [errorID localizedDescription]);
                        }
                        else {
                            NSDictionary *sessionDictionary = [NSJSONSerialization JSONObjectWithData:dataID options:NSJSONReadingMutableContainers error:nil];
                            // Store the returned array of dictionaries in our posts property
                            NSLog(@"%@", sessionDictionary);
                        }
                }];
                
                */
                
                                    /*
                NSDictionary *headers = @{ @"content-type": @"application/json;charset=utf-8",
                                           @"authorization": (self.token) };
                NSDictionary *parameters = @{ @"request_token":dataDictionary[@"request_token"]};
                NSLog(@"%@", parameters);
                NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
                if (! postData) {
                    NSLog(@"Got an error: %@", error);
                } else {
                    NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
                    NSLog(@"%@", jsonString);
                }
                NSString *baseurl = @"https://api.themoviedb.org/3/authentication/session/new?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&request_token=";
                NSString *sessionstring = [baseurl stringByAppendingString:self.token];
                NSURL *sessionurl = [NSURL URLWithString:sessionstring];
                NSMutableURLRequest *sessionrequest = [NSMutableURLRequest requestWithURL:sessionurl];
                NSLog(@"%@", sessionstring);
                NSURLSession *sessionID = [NSURLSession sharedSession];
                [sessionrequest setHTTPMethod:@"POST"];
                [sessionrequest setAllHTTPHeaderFields:headers];
                [sessionrequest setHTTPBody:postData];
                NSURL  *urlSessionID = [NSURL URLWithString:sessionstring];
                NSData *urlData = [NSData dataWithContentsOfURL:urlSessionID];
                NSLog(@"%@", urlData);
                NSString *jsonString2 = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
                NSLog(@"%@", jsonString2);
                if ( urlData )
                {
                  NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                  NSString  *documentsDirectory = [paths objectAtIndex:0];

                  NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"filename.png"];
                  [urlData writeToFile:filePath atomically:YES];
                }
                NSURLSessionDataTask *dataTask = [sessionID dataTaskWithRequest:sessionrequest
                                                            completionHandler:^(NSData *data2, NSURLResponse *response2, NSError *error2) {
                                                                if (error) {
                                                                    NSLog(@"Error message %@", error2);
                                                                } else {
                                                                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response2;
                                                                    NSLog(@"HTTP Response%@", httpResponse);
                                                                    
                                                                    NSDictionary *sessionDictionary = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableContainers error:nil];
                                                                    // Store the returned array of dictionaries in our posts property
                                                                    NSLog(@"Creates session dictionary %@", sessionDictionary);
                                                                }
                                                            }];
                 
                //[taskID resume];
                 
                
                
                
                
                
                
                
                
                
                //NSURL *sessionurl = [NSURL URLWithString:@"https://api.themoviedb.org/3/authentication/session/new?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
        
                NSString *urlString1 = @"https://api.themoviedb.org/3/authentication/session/new?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed";
                NSDictionary *jsonBodyDict = @{@"request_token":self.token};
                NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonBodyDict options:kNilOptions error:nil];
                // watch out: error is nil here, but you never do that in production code. Do proper checks!
;

                NSMutableURLRequest *sessionrequest = [NSMutableURLRequest new];
                sessionrequest.HTTPMethod = @"POST";

                // for alternative 1:
                [sessionrequest setURL:[NSURL URLWithString:urlString1]];
                [sessionrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [sessionrequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [sessionrequest setHTTPBody:jsonBodyData];


                NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
                NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                                      delegate:nil
                                                                 delegateQueue:[NSOperationQueue mainQueue]];
                NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                        completionHandler:^(NSData * _Nullable data,
                                                                            NSURLResponse * _Nullable response,
                                                                            NSError * _Nullable error) {
                                                            NSLog(@"Yay, done! Check for errors in response!");
                    NSDictionary *sessiondictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    // Store the returned array of dictionaries in our posts property
                    NSLog(@"%@", sessiondictionary);
                    

                                                            NSHTTPURLResponse *asHTTPResponse = (NSHTTPURLResponse *) response;
                                                            NSLog(@"The response is: %@", asHTTPResponse);
                                                            // set a breakpoint on the last NSLog and investigate the response in the debugger

                                                            // if you get data, you can inspect that, too. If it's JSON, do one of these:
                                                            NSDictionary *forJSONObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                          options:kNilOptions
                                                                                                                            error:nil];
                                                            // or
                                                            NSArray *forJSONArray = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                    options:kNilOptions
                                                                                                                      error:nil];

                                                            NSLog(@"One of these might exist - object: %@ \n array: %@", forJSONObject, forJSONArray);

                                                        }];
                 */
  //              [task resume];
//                [dataTask resume];

                // Create a simple dictionary with numbers.
                //NSDictionary *dictionary = @{ @"request_token": self.token };
                //NSString *parameter = [NSString stringWithFormat:@"\"request_token\": %@", self.token];
                //NSData *parameterData = [parameter dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                //NSLog(@"%@", dictionary);
                
                /*
                NSString *post = [NSString stringWithFormat:@"{\n  \"request_token\": \"%@\"\n}", self.token];
                NSLog(@"%@", post);
                NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
                
                // Convert the dictionary into JSON data.
                //NSData *JSONData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                                //options:0
                                                                  //   error:nil];
                
                // Create a POST request with our JSON as a request body.
                NSMutableURLRequest *requestsession = [NSMutableURLRequest requestWithURL:sessionurl];
                requestsession.HTTPMethod = @"POST";
                requestsession.HTTPBody = postData;
                [requestsession setValue:postLength forHTTPHeaderField:@"Content-Length"];
                
                // Create a task.
                NSURLSessionDataTask *task2 = [[NSURLSession sharedSession] dataTaskWithRequest:requestsession
                                                                             completionHandler:^(NSData *data2,
                                                                                                 NSURLResponse *response2,
                                                                                                 NSError *error2)
                                              {
                                                  if (!error2)
                                                  {
                                                      NSLog(@"Status code: %li", (long)((NSHTTPURLResponse *)response2).statusCode);
                                                      NSDictionary *sessionDictionary = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableContainers error:nil];
                                                      NSLog(@"%@", sessionDictionary);
                                                      self.token = sessionDictionary[@"session_id"];
                                                      NSLog(@"%@", self.sessionID);
                                                      
                                                  }
                                                  else
                                                  {
                                                      NSLog(@"Error: %@", error2.localizedDescription);
                                                  }
                                              }];
                [task2 resume];
                 */
       //         }
    //                    }];
   // [task resume];//
                    // Convert the url String to a NSURL object.
                    
                    // Do any additional setup after loading the view.
                //}
                
                
            // Convert the url String to a NSURL object.
            
            // Do any additional setup after loading the view.
//@end
                                  
                /*
                NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.themoviedb.org/3/authentication/session/new?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"]];
                
                NSString *userUpdate =[NSString stringWithFormat:@"request_token: %@",self.token];
                NSLog(@"%@",userUpdate);
                //create the Method "GET" or "POST"
                [urlRequest setHTTPMethod:@"POST"];
                 NSData *data1 = [userUpdate dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                
                [urlRequest setHTTPMethod:@"POST"];
                //Convert the String to Data
                NSDictionary *tmp = @{@"request_token": self.token};
                //NSString *tmp =  [NSString stringWithFormat:@"%@", ((void)(@"\"request_token\": \"%@\""), self.token)];
                NSData *postData = [NSJSONSerialization dataWithJSONObject:tmp options:kNilOptions error:nil];
                //NSData *postData = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
                NSLog(@"%@", postData);
                NSDictionary *printTest = [NSJSONSerialization JSONObjectWithData:postData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@", printTest);
                [urlRequest setHTTPBody:postData];

                //Apply the data to the body
                //[urlRequest setHTTPBody:data1];
                


                NSURLSession *session2 = [NSURLSession sharedSession];
                NSURLSessionDataTask *dataTask = [session2 dataTaskWithRequest:urlRequest completionHandler:^(NSData *logindata, NSURLResponse *response, NSError *error) {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                    if(httpResponse.statusCode == 200)
                    {
                        NSError *parseError = nil;
                        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:logindata options:0 error:&parseError];
                        NSLog(@"The response is - %@",responseDictionary);
                        NSInteger success = [[responseDictionary objectForKey:@"success"] integerValue];
                        if(success == 1)
                        {
                            NSLog(@"Login SUCCESS");
                        }
                        else
                        {
                            NSLog(@"Login FAILURE");
                        }
                    }
                    else
                    {
                        NSLog(@"Error");
                    }
                }];
                [dataTask resume];
            }
        }];
    [task resume];
    */

    /*
    NSURL *successUrl = [NSURL URLWithString:@"https://api.themoviedb.org/3/authentication/session/new?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *successRequest = [NSURLRequest requestWithURL:successUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *successSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task2 = [successSession dataTaskWithRequest:successRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                // Store the returned array of dictionaries in our posts property
                NSLog(@"%@", dataDictionary);
                NSString *sessionID = dataDictionary[@"session_id"];
                NSLog(@"%@", sessionID);
            }
        }];
    [task2 resume];
     */


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    MoviesViewController *moviesViewController = [segue destinationViewController];
    moviesViewController.token = self.token;
}
- (void)fetchID {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Error"
                                                                   message:@"Couldn't fetch movies, please check your connection and retry"
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancelAction];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:okAction];
    
    NSString *baseurl = @"https://api.themoviedb.org/3/authentication/session/new?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&request_token=";
    NSString *sessionstring = [baseurl stringByAppendingString:self.token];
    NSURL *url = [NSURL URLWithString:sessionstring];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert
                                                                                         animated:YES
                                                                                       completion:^{
            }];
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@", dataDictionary);
            
            // TODO: Get the array of movies
            // TODO: Store the movies in a property to use elsewhere
            // TODO: Reload your table view data
        }
        //[SVProgressHUD dismiss];
    }];
    [task resume];
}
@end

