//
//  ImageFile.h
//  Demo-OSX
//
//  Created by Michael Monscheuer on 17/10/16.
//  Copyright © 2016 Michael Monscheuer. All rights reserved.
//

@import Foundation;

// Notifications
static NSString * const ImageFileThumbnailDidLoadNotification = @"ImageFileThumbnailDidLoadNotification";
static NSString * const ImageFileImageDidLoadNotification = @"ImageFileImageDidLoadNotification";

@interface ImageFile : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithURL:(NSURL *)anURL NS_DESIGNATED_INITIALIZER;

/**
 The url the receiver references.
 */
@property (strong) NSURL *URL;

/**
 The date the ImageFile was last updated from its URL source.
 */
@property (strong) NSDate *dateLastUpdated;

/**
 The filename of the receiver, with the extension.
 */
@property (readonly) NSString *fileName;

/**
 The filename of the receiver, without the extension. Suitable for presentation names.
 */
@property (readonly) NSString *fileNameExcludingExtension;

/**
 Fetching a thubnail

 @param completionHandler Completion handler
 */
- (void)fetchThumbnailWithCompletionHandler:(void (^)(NSImage *thumbnailImage))completionHandler;

@end

/*
@interface ImageFile (SVGKitSupport)

- (SVGKSource *)svgImageSource;

@end
*/
