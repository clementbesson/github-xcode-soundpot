//
//  UploadLibrary.m
//  SoundPot
//
//  Created by Clement Besson on 6/8/16.
//  Copyright © 2016 Clement Besson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadLibrary.h"

@implementation UploadLibrary

- (void) getTrackData {
    MPMusicPlayerController *MyPlayer= [[MPMusicPlayerController alloc] init ];
    MPMediaItem * Now = [MyPlayer nowPlayingItem];
    if (Now==NULL) {
        return;
    }
    else {
        _trackValue=[Now valueForProperty:MPMediaItemPropertyTitle];
        _artistValue=[Now valueForProperty:MPMediaItemPropertyArtist];
        _albumValue=[Now valueForProperty:MPMediaItemPropertyAlbumTitle];
        _artwork=[Now valueForProperty:MPMediaItemPropertyArtwork];
        NSURL *songURL=[Now valueForProperty:MPMediaItemPropertyAssetURL];
        // Creating a filename
        NSString *fileName = [NSString stringWithFormat:@"%@", @"exported.m4a"];
        // Creating the exportURLString from filename and Temporary Directory
        NSString* exportFileURLString=[NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        // Creating the exportURL from exportURLString
        NSURL *exportFileURL = [NSURL fileURLWithPath:exportFileURLString];
        
        if (songURL != nil) {
            AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:songURL options:nil];
        
            AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
                                          initWithAsset: songAsset
                                          presetName: AVAssetExportPresetAppleM4A];
        
            // create trim time range - 20 seconds starting from 00 seconds into the asset
            //Start time
            CMTime startTime = CMTimeMake(20, 1);
            //Stop time
            CMTime stopTime = CMTimeMake(50, 1);
            CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime);
        
            // Deleting the file if it previously existed
            myDeleteFile(exportFileURLString);
        
            // Setting export session parameters
            exporter.outputURL = exportFileURL;
            exporter.outputFileType = @"com.apple.m4a-audio";
            exporter.timeRange=exportTimeRange; // Setting export time range
        
            // do the export
            [exporter exportAsynchronouslyWithCompletionHandler:^{
                int exportStatus = exporter.status;
                switch (exportStatus) {
                    case AVAssetExportSessionStatusFailed: {
                        NSError *exportError = exporter.error;
                        break;
                    }
                    //Export completed so send the message to parse
                    case AVAssetExportSessionStatusCompleted: {
                        _audioURL = exportFileURL;
                        break;
                    
                    }
                    default: {
                        break;
                    }
                }
            }];
        }
        else {
            _audioURL = nil;
        }
    }
}

void myDeleteFile (NSString* path){
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *deleteErr = nil;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&deleteErr];
        if (deleteErr) {
        }
    }
    
}

@end