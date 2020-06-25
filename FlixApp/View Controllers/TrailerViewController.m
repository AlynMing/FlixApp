//
//  TrailerViewController.m
//  FlixApp
//
//  Created by Xurxo Riesco on 6/25/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "TrailerViewController.h"
#import <WebKit/WebKit.h>


@interface TrailerViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *webView;



@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.movie[@"id"]);
    NSLog(@"Movie ID %ld", self.movie[@"id"]);
    NSString *movieId = [NSString stringWithFormat:@"%@",self.movie[@"id"]];
    NSString *baseUrl = @"https://api.themoviedb.org/3/movie/";
    NSLog(@"%@", baseUrl);
    NSLog(@"%@", movieId);
    NSString *prefinalURL = [baseUrl stringByAppendingString:movieId];
    NSString *apiKey = @"/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US";
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
                NSArray *trailerMovies = dataDictionary[@"results"];
                
                NSDictionary *trailer = trailerMovies[0];
                NSString *key = trailer[@"key"];
                NSLog(@"%@", key);
                NSString *youtubeURL = @"https://www.youtube.com/watch?v=";
                NSString *urlString = [youtubeURL stringByAppendingString:key];
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
