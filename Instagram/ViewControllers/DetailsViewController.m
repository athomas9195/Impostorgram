//
//  DetailsViewController.m
//  Instagram
//
//  Created by Anna Thomas on 7/7/21.
//

#import "DetailsViewController.h"
#import <Parse/ParseUIConstants.h>
#import <Parse/PFInstallation.h>
#import <Parse/Parse.h>
#import <Parse/PFImageView.h>
#import "NSDate+DateTools.h"
#import "CommentViewController.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet PFImageView *profileImage;

@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
 
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;  //like button
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;  //username
@property (weak, nonatomic) IBOutlet UILabel *smallUsernameLabel; //other username
@property (weak, nonatomic) IBOutlet UILabel *captionLabel; //caption
@property (weak, nonatomic) IBOutlet UILabel *dateLabel; //date ago
@property (weak, nonatomic) IBOutlet UIImageView *heartImage; //the like icon


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setup
    Post *post = self.post;
    
    
    //like icon setup ui
    self.heartImage.alpha =0;
    self.heartImage.hidden = NO;
    
    
    //set custom details display
    self.profileImage.layer.cornerRadius = 20;
    self.profileImage.clipsToBounds = YES;
    
    //get the image
    PFUser *user = [PFUser currentUser];
    if(user[@"image"]) {
        PFFileObject *picFile =user[@"image"];
        [picFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if(error==nil) {
                self.profileImage.image = [UIImage imageWithData:data];
            }
        }];

    }
     
    //set up the view
    self.usernameLabel.text = post.author.username;
    
    self.smallUsernameLabel.text =post.author.username;
    
    self.captionLabel.text = post.caption;
    
    self.postImageView.file = post.image;
    
    self.dateLabel.text = post.createdAt.timeAgoSinceNow;
    
    //double tap action 
    self.postImageView.userInteractionEnabled = YES;
 
    //makes the post double tap likeable
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture:)];

    tapGesture1.numberOfTapsRequired = 2;

    tapGesture1.delegate = self;

    [self.postImageView addGestureRecognizer:tapGesture1];
        
}

//the double tap action animation
- (void) tapGesture: (id)sender
{
    [UIView animateWithDuration:3.00
      delay: 1.0
      options: 0
      animations:^{
       self.heartImage.alpha = 1.0;
      }
      completion: nil
    ];
    [UIView animateWithDuration:1.0
      delay: 0.0
      options: 0
      animations:^{
       self.heartImage.alpha = 0;
      }
      completion: nil
    ];
    [self refreshDataFavorite];
 }
 

//when user taps favorite 
- (IBAction)didTapFavorite:(id)sender {
      
    //favorite
    if(self.favoriteButton.selected ==NO) {
        NSNumber *likes = self.post.likeCount;
        likes = [NSNumber numberWithInt:likes.intValue + 1];
        self.post.likeCount = likes;

        [self refreshDataFavorite];

 
    //unfavorite
    } else if (self.favoriteButton.selected ==YES) {
        NSNumber *likes = self.post.likeCount;
        likes = [NSNumber numberWithInt:likes.intValue - 1];
        self.post.likeCount = likes;

        [self refreshDataFavoriteUnfavorite];

    }
}



//reloads cell view
-(void) refreshDataFavorite {
   
//    self.favoriteLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.favoriteButton.selected = YES;
     
}

//reloads cell view
-(void) refreshDataFavoriteUnfavorite {
   
    //self.favoriteLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.favoriteButton.selected = NO;
     
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"toComments"]){
        //comemnts details segue
        
        CommentViewController *commentsViewController = [segue destinationViewController];
        
        commentsViewController.post = self.post;
    
        
    }
}


@end
