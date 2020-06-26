//
//  DetailsViewController.m
//  FlixApp
//
//  Created by Xurxo Riesco on 6/24/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TrailerViewController.h"
#import "LargePosterViewController.h"
#import "SimilarMoviesViewController.h"
#import "ReviewsViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsysLabel;
@property (weak, nonatomic) IBOutlet UIButton *trailerButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *similarButton;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIButton *reviewButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpeg"]];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [self.posterView setImageWithURL:posterURL];
    
    if(self.movie[@"backdrop_path"] == NULL){
        NSString *backdropURLString = self.movie[@"backdrop_path"];
        NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
        NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
        [self.backdropView setImageWithURL:backdropURL];}
    else{
        NSString *backdropURLString = self.movie[@"poster_path"];
        NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
        NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
        [self.backdropView setImageWithURL:backdropURL];
        
    }
    self.titleLabel.text = self.movie[@"title"];
    self.synopsysLabel.text = self.movie[@"overview"];
    NSString *score = [NSString stringWithFormat:@"%@",self.movie[@"vote_average"]];
    self.ratingLabel.text = score;
    
    UIImage *btnImage = [UIImage imageNamed:@"whitestar.png"];
    [self.reviewButton setImage:btnImage forState:UIControlStateNormal];
    
    [self.titleLabel sizeToFit];
    [self.synopsysLabel sizeToFit];
    
    
    // Do any additional setup after loading the view.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TrailerViewController *trailerViewController = [segue destinationViewController];
    trailerViewController.movie = self.movie;
    LargePosterViewController *largePosterViewController = [segue destinationViewController];
    largePosterViewController.movie = self.movie;
    SimilarMoviesViewController *similarMoviesViewController = [segue destinationViewController];
    similarMoviesViewController.movie = self.movie;
    ReviewsViewController *reviewsViewController = [segue destinationViewController];
    reviewsViewController.movie = self.movie;
}


@end
