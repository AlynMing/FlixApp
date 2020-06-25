//
//  MoviesViewController.m
//  FlixApp
//
//  Created by Xurxo Riesco on 6/24/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import "SVProgressHUD.h"

@interface MoviesViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{
    BOOL isFiltered;
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSArray *searchMovies;
@property (nonatomic, strong) NSArray *unsearchMovies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;





@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isFiltered = false;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    
    [self.activityIndicator startAnimating];
    //[SVProgressHUD show];
    [self fetchMovies];
    
    //Refresh and fetch
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];

}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
-(void)searchBar:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

- (void)fetchMovies {
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
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert
                 animated:YES
               completion:^{
                       // optional code for what happens after the alert controller has finished presenting
               }];
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               self.movies = dataDictionary[@"results"];
               NSLog(@"%@", self.movies);
               self.searchMovies = self.movies;
               [self.tableView reloadData];
               
               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
           }
        [self.refreshControl endRefreshing];
        [self.activityIndicator stopAnimating];
        //[SVProgressHUD dismiss];
       }];
    [task resume];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchMovies.count;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
     if (searchText.length != 0) {
            
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [NSLocalizedString(evaluatedObject[@"title"],nil) containsString:searchText];
            }];
            self.searchMovies = [self.movies filteredArrayUsingPredicate:predicate];
            
            
        }
        else {
            self.searchMovies = self.movies;
        }
        
        [self.tableView reloadData];
     
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    //UITableViewCell *cell = [[UITableViewCell alloc] init];
             NSDictionary *movie = self.searchMovies[indexPath.row];
             cell.titleLabel.text = movie[@"title"];
             cell.synopsisLabel.text = movie[@"overview"];
             NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
             NSString *posterURLString = movie[@"poster_path"];
             NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
             NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
             cell.posterView.image = nil;
            //[cell.posterView setImageWithURL:posterURL];
            NSURLRequest *request = [NSURLRequest requestWithURL:posterURL];
            [cell.posterView setImageWithURLRequest:request placeholderImage:nil
            success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                
                // imageResponse will be nil if the image is cached
                if (imageResponse) {
                    NSLog(@"Image was NOT cached, fade in image");
                    cell.posterView.alpha = 0.0;
                    cell.posterView.image = image;
                    
                    //Animate UIImageView back to alpha 1 over 0.3sec
                    [UIView animateWithDuration:0.5 animations:^{
                        cell.posterView.alpha = 1.0;
                    }];
                }
                else {
                    NSLog(@"Image was cached so just update the image");
                    cell.posterView.image = image;
                }
            }
            failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                // do something for the failure condition
            }];
    
/*
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:posterURL];
    
    }
*/
    //cell.textLabel.text = movie[@"title"];
    
    //NSLog(@"%@",[NSString stringWithFormat:@"row: %d, section:%d", indexPath.row, indexPath.section]);
    //cell.textLabel.text = [NSString stringWithFormat:@"row: %d, section:%d", indexPath.row, indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.searchMovies[indexPath.row];
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
}

@end
