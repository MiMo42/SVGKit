//
//  ImageCollection.h
//  Demo-OSX
//
//  Created by Michael Monscheuer on 17/10/16.
//  Copyright © 2016 Michael Monscheuer. All rights reserved.
//

@import Foundation;

// Notifications
static NSString * const ImagesDidChangeNotification = @"ImageCollectionImagesDidChangeNotification";

@interface ImageCollection : NSObject

- (instancetype)init NS_UNAVAILABLE;

/**
 Designated initializer

 @param rootURL The root URL

 @return Inited instance
 */
- (instancetype)initWithRootURL:(NSURL *)rootURL NS_DESIGNATED_INITIALIZER;

/**
 The name of the `ImageCollection`. Defaults to the referenced directory name.
 */
@property (strong) NSString *name;

/**
 The image used as the icon in table view representations. Returns a standard
 icon by default. Setting nil will return to the default, never returns nil.
*/
@property (strong) NSImage *tableViewIcon;

/**
 The `ImageFiles` contained in the collection. Populated asynchronously
 and posts an `imagesDidChangeNotification` on updates.
 */
@property (strong) NSMutableArray *images;

@end
