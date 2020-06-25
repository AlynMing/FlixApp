//
//  ReviewsViewController.m
//  FlixApp
//
//  Created by Xurxo Riesco on 6/25/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "ReviewsViewController.h"
#import <WebKit/WebKit.h>

@interface ReviewsViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation ReviewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.movie[@"id"]);
     NSLog(@"Movie ID %ld", self.movie[@"id"]);
     NSString *movieId = [NSString stringWithFormat:@"%@",self.movie[@"id"]];
     NSString *baseUrl = @"https://api.themoviedb.org/3/movie/";
     NSLog(@"%@", baseUrl);
     NSLog(@"%@", movieId);
     NSString *prefinalURL = [baseUrl stringByAppendingString:movieId];
     //a07e22bc18f5cb106bfe4cc1f83ad8ed
     NSString *apiKey = @"/reviews?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1";
     NSString *finalUrl = [prefinalURL stringByAppendingString:apiKey];
     NSLog(@"%@",finalUrl);
     NSURL *url = [NSURL URLWithString:finalUrl];
     NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
     NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
     NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
             if (error != nil) {
                 NSLog(@"%@", [error localizedDescription]);
             }
             else {
                 
                 NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                 NSArray *reviewMovies = dataDictionary[@"results"];
                 NSLog(@"%@", reviewMovies);
                 NSDictionary *review = reviewMovies[0];
                 NSString *urlString = review[@"url"];
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
