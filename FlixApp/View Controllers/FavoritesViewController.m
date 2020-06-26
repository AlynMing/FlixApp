//
//  FavoritesViewController.m
//  FlixApp
//
//  Created by Xurxo Riesco on 6/26/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "FavoritesViewController.h"
#import "FavoritesCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface FavoritesViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) NSString *listID;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation FavoritesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.delegate.self;
    self.searchBar.searchTextField.textColor = [UIColor whiteColor];
    self.navigationItem.title = @"Favorites";
       UINavigationBar *navigationBar = self.navigationController.navigationBar;
       [navigationBar setBackgroundImage:[UIImage imageNamed:@"background.jpeg"] forBarMetrics:UIBarMetricsDefault];
       navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:24],
    NSForegroundColorAttributeName : [UIColor colorWithRed:1 green:1 blue:1 alpha:1]};
    
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpeg"]];
    
    self.searchBar.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpeg"]];
    self.listID = @"25";

    [self fetchMovies];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = self.collectionView.frame.size.width / postersPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    // Do any additional setup after loading the view.
    [self.collectionView reloadData];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.listID = searchBar.text;
    [self fetchMovies];
    [self.collectionView reloadData];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if(searchText !=0){
        self.listID = searchText;
        [self fetchMovies];
        
    }
    else{
        self.listID = @"25";
        [self fetchMovies];
        
    }
        [self.collectionView reloadData];
        
    
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
    
    NSString *baseUrl = @"https://api.themoviedb.org/3/list/";
    NSString *listNumber = self.listID;
    NSString *prefinalURL = [baseUrl stringByAppendingString:listNumber];
    NSString *apiKey =@"?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US";
    NSString *finalUrl = [prefinalURL stringByAppendingString:apiKey];
    NSLog(@"%@",finalUrl);
    NSURL *url = [NSURL URLWithString:finalUrl];
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
            self.movies = dataDictionary[@"items"];
            NSLog(@"%@", self.movies);
            [self.collectionView reloadData];
            
            // TODO: Get the array of movies
            // TODO: Store the movies in a property to use elsewhere
            // TODO: Reload your table view data
        }
        //[SVProgressHUD dismiss];
    }];
    [task resume];
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FavoritesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FavoritesCollectionViewCell" forIndexPath: indexPath];
    
    NSDictionary *movie = self.movies[indexPath.item];
    
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
            [UIView animateWithDuration:0.3 animations:^{
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
        return cell;
}
     
     - (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        return self.movies.count;
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
