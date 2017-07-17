//
//  DataStore.h
//  AV Storybook
//
//  Created by Errol Cheong on 2017-07-14.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;
@import UIKit;

@interface DataStore : NSObject

@property (strong, nonatomic) NSURL *audioFileURL;
@property (strong, nonatomic) AVAudioRecorder *avRecorder;
@property (strong, nonatomic) AVAudioPlayer *avPlayer;
@property (strong, nonatomic) UIImage *image;

- (instancetype)initWithFilename:(NSString*)filename;

@end
