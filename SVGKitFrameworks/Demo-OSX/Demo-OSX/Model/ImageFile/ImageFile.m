//
//  ImageFile.m
//  Demo-OSX
//
//  Created by Michael Monscheuer on 17/10/16.
//  Copyright © 2016 Michael Monscheuer. All rights reserved.
//

@import Cocoa;
@import QuickLook;

#import "ImageFile.h"

@interface ImageFile ()

@property (strong) NSImage *thumbnail;

@end

/**
 `ImageFile` represents an image on disk. It can create thumbnail and full image representations.
 */
@implementation ImageFile
{
}

static NSOperationQueue *__thumbnailLoadingOperationQueue = nil;
static NSOperationQueue *__imageLoadingOperationQueue = nil;

+ (NSOperationQueue *)thumbnailLoadingOperationQueue
{
    if (__thumbnailLoadingOperationQueue == nil) {
        __thumbnailLoadingOperationQueue = [NSOperationQueue new];
        __thumbnailLoadingOperationQueue.name = @"ImageFile Thumbnail Loading Queue";
    }
    
    return __thumbnailLoadingOperationQueue;
}

+ (NSOperationQueue *)imageLoadingOperationQueue
{
    if (__imageLoadingOperationQueue == nil) {
        __imageLoadingOperationQueue = [NSOperationQueue new];
        __imageLoadingOperationQueue.name = @"ImageFile Image Loading Queue";
    }
    
    return __imageLoadingOperationQueue;
}

#pragma mark - Life Cycle

- (instancetype)initWithURL:(NSURL *)anURL;
{
    self = [super init];
    if (self) {
        _dateLastUpdated = [NSDate date];
        _URL = anURL;
    }
    return self;
}

#pragma mark - Properties

- (NSString *)fileName
{
    return _URL.lastPathComponent;
}

- (NSString *)fileNameExcludingExtension
{
    NSString *lastPathComponent = _URL.lastPathComponent;
    return [lastPathComponent stringByDeletingPathExtension];
}

#pragma mark - Fetching Thumbnail

- (void)fetchThumbnailWithCompletionHandler:(void (^)(NSImage *thumbnailImage))completionHandler
{
    if (self.thumbnail != nil) {
        completionHandler(self.thumbnail);
    } else {
    
        [[ImageFile thumbnailLoadingOperationQueue] addOperationWithBlock:
            ^{
                /*
                    Create Thumbnail 
                */
                NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kQLThumbnailOptionIconModeKey];
            
                CGImageRef ref = QLThumbnailImageCreate(kCFAllocatorDefault, (__bridge CFURLRef)self.URL, CGSizeMake(300,300), (__bridge CFDictionaryRef)options);
        
                if (ref == NULL) {
                
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        completionHandler(nil);
                    }];
                    
                    return;
                }

                NSImage *image = [[NSImage alloc] initWithCGImage:ref size:NSZeroSize];
                CGImageRelease(ref);
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                    self.thumbnail = image;
                    
                    completionHandler(image);
                    
                }];
            }];
    }
}

@end

/*
@implementation ImageFile (SVGKitSupport)

- (SVGKSource *)svgImageSource
{
    if (self.URL == nil)
        return nil;

    if (self.URL.isFileURL == NO)
        return nil;
    
    return [SVGKSourceLocalFile sourceFromFilename:self.URL.path];
}

@end
*/
