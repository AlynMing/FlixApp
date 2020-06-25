//
//  DetailsGridViewController.m
//  FlixApp
//
//  Created by Xurxo Riesco on 6/24/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "DetailsGridViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsGridViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation DetailsGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [self.posterView setImageWithURL:posterURL];
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
    [self.backdropView setImageWithURL:backdropURL];
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpeg"]];
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
