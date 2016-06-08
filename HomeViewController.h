//
//  HomeViewController.h
//  ChatSC
//
//  Created by Clément Besson on 28/09/2014.
//  Copyright (c) 2014 Clement Besson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>


@interface HomeViewController : UIViewController
@property (nonatomic, strong) PFUser *currentUser;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImage;
@property (weak, nonatomic) IBOutlet UITextView *track;
@property (weak, nonatomic) IBOutlet UITextView *artist;
@property (weak, nonatomic) IBOutlet UITextView *album;
@property (weak, nonatomic) IBOutlet UILabel *inbox;

@end
