//
//  DataStore.m
//  AV Storybook
//
//  Created by Errol Cheong on 2017-07-14.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "DataStore.h"

@implementation DataStore

- (instancetype)initWithFilename:(NSString*)filename
{
    self = [super init];
    if (self) {
        NSString* docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        _audioFileURL = [NSURL URLWithString:[docsDir stringByAppendingPathComponent:filename]];
//        NSURL *docDir = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
//        _audioFileURL = [docDir URLByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", @"AvStoryData", filename]];
        
    }
    return self;
}

@end
