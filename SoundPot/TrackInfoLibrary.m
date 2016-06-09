//
//  TrackInfoLibrary.m
//  SoundPot
//
//  Created by Clement Besson on 6/8/16.
//  Copyright © 2016 Clement Besson. All rights reserved.
//

#import "TrackInfoLibray.h"

@implementation TrackingInfoLibrary

- (void) someMethod {
    NSLog(@"SomeMethod Ran");
    MPMusicPlayerController *MyPlayer= [[MPMusicPlayerController alloc] init ];
    MPMediaItem * Now = [MyPlayer nowPlayingItem];
    if (Now==NULL) {
        _trackValue = @"No song currently played";
        _artistValue= @"" ;
        _albumValue= @"" ;
    }
    else {
        _trackValue=[Now valueForProperty:MPMediaItemPropertyTitle];
        _artistValue=[Now valueForProperty:MPMediaItemPropertyArtist];
        _albumValue=[Now valueForProperty:MPMediaItemPropertyAlbumTitle];
        _artwork=[Now valueForProperty:MPMediaItemPropertyArtwork];
    }
}


- (void)getNowPlayingInfo
{

}


@end