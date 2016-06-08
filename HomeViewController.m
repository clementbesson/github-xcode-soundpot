//
//  HomeViewController.m
//  ChatSC
//
//  Created by Clément Besson on 28/09/2014.
//  Copyright (c) 2014 Clement Besson. All rights reserved.
//

#import "HomeViewController.h"

@implementation HomeViewController
@synthesize inbox;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self
                                   selector:@selector(updateNowPlayingInfo) userInfo:nil repeats:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        
        [query whereKey:@"recipientsIds" equalTo:[currentUser objectId] ];
        [query orderByDescending:@"CreatedAt"];
        
        // start the query
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
                
            }
            else {
                // there are new messages
                long newmessage;
                newmessage = [objects count];
                if (newmessage != 0) {
                   inbox.text = [NSString stringWithFormat:@"%ld",newmessage];
                }
                else {
                    inbox.text = @"";
                }
            }
        }];
    }
    else
    {
        
    }

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)updateNowPlayingInfo
{
    
    //Query now playing
    MPMusicPlayerController *MyPlayer= [[MPMusicPlayerController alloc] init ];
    MPMediaItem * Now = [MyPlayer nowPlayingItem];
    
    if (Now==NULL) {
        return;
    }
    else {
        NSString *track;
        NSString *artist;
        NSString *album;
        MPMediaItemArtwork *artwork;
        
        track=[Now valueForProperty:MPMediaItemPropertyTitle];
        artist=[Now valueForProperty:MPMediaItemPropertyArtist];
        album=[Now valueForProperty:MPMediaItemPropertyAlbumTitle];
        artwork=[Now valueForProperty:MPMediaItemPropertyArtwork];
        
        UIImage *artworkImage;
        artworkImage=[artwork imageWithSize: CGSizeMake(300, 300)];
        
        _artworkImage.image=artworkImage;
        _track.text=track;
        _artist.text=artist;
        _album.text=album;
        _track.textColor= [UIColor whiteColor];
        _album.textColor= [UIColor whiteColor];
        _artist.textColor= [UIColor whiteColor];
        
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"recu");
}


@end
