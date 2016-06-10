//
//  UploadLibray.h
//  SoundPot
//
//  Created by Clement Besson on 6/8/16.
//  Copyright © 2016 Clement Besson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface UploadLibrary : NSObject

@property (readonly) NSString *trackValue;
@property (readonly) NSString *artistValue;
@property (readonly) NSString *albumValue;
@property (readonly) MPMediaItemArtwork *artwork;
@property (nonatomic, retain) NSURL *audioURL;
- (void) getTrackData;

@end