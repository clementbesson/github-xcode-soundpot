//
//  TrackInfoLibray.h
//  SoundPot
//
//  Created by Clement Besson on 6/8/16.
//  Copyright © 2016 Clement Besson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface TrackingInfoLibrary : NSObject

//@property (strong, nonatomic) id someProperty;
@property (readonly) NSString *trackValue;
@property (readonly) NSString *artistValue;
@property (readonly) NSString *albumValue;
@property (readonly) MPMediaItemArtwork *artwork;

- (void) getNowPlayingInfo;

@end