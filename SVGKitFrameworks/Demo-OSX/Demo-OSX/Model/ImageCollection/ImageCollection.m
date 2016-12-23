//
//  ImageCollection.m
//  Demo-OSX
//
//  Created by Michael Monscheuer on 17/10/16.
//  Copyright © 2016 Michael Monscheuer. All rights reserved.
//

@import Cocoa;

#import "ImageCollection.h"

#import "ImageFile.h"

@interface ImageCollection ()

/**
 The directory URL referended by the collection
 */
@property (strong) NSURL *rootURL;

/**
 Private mapping from URL to `ImageFile` used when updating with the referenced directory.
 */
@property (strong) NSMutableDictionary *imagesByURL;

@end

@implementation ImageCollection
{
    /**
     Private backing for the table view icon. When the backing is nil, `tableViewIcon`
     returns the default collection image.
     */
    NSImage *_tableViewIcon;
}

static NSOperationQueue *__imageFileFetchingQueue = nil;

+ (NSOperationQueue *)imageFileFetchingQueue
{
    if (__imageFileFetchingQueue == nil) {
        __imageFileFetchingQueue = [NSOperationQueue new];
        __imageFileFetchingQueue.name = @"ImageCollection Image Fetching Queue";
    }
    
    return __imageFileFetchingQueue;
}

#pragma mark - Life Cycle

- (instancetype)initWithRootURL:(NSURL *)rootURL
{
    self = [super init];
    if (self) {
        _rootURL = rootURL;
        
        _images = [NSMutableArray array];
        _imagesByURL = [NSMutableDictionary dictionary];
        
        _name = rootURL.lastPathComponent;
        
        [self refreshOnBackgroundThread];
    }
    return self;
}

#pragma mark - Properties

- (NSImage *)tableViewIcon
{
    return (_tableViewIcon != nil)?_tableViewIcon:[NSImage imageNamed:NSImageNameFolder];
}

- (void)setTableViewIcon:(NSImage *)tableViewIcon
{
    _tableViewIcon = tableViewIcon;
}

#pragma mark - Image List Manipulation

- (void)addImageFile:(ImageFile *)anImageFile
{
    [self insertImageFile:anImageFile atIndex:_images.count];
}

- (void)insertImageFile:(ImageFile *)anImageFile atIndex:(NSUInteger)index
{
    [_images insertObject:anImageFile atIndex:index];
    [_imagesByURL setObject:anImageFile forKey:anImageFile.URL];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ImagesDidChangeNotification object:self];
}

- (void)removeImageFile:(ImageFile *)anImageFile
{
    [_images removeObjectAtIndex:[_images indexOfObjectIdenticalTo:anImageFile]];
    [_imagesByURL removeObjectForKey:anImageFile.URL];

    [[NSNotificationCenter defaultCenter] postNotificationName:ImagesDidChangeNotification object:self];
}

#pragma mark - Equality

- (NSUInteger)hash
{
    return _rootURL.hash;
}

- (BOOL)isEqual:(id)object
{
    if (![object isMemberOfClass:[self class]])
        return NO;
    
    return self.rootURL == ((ImageCollection *)object).rootURL;
}

#pragma mark - ImageFile Fetching

- (void)refreshOnBackgroundThread
{
    [[ImageCollection imageFileFetchingQueue] addOperationWithBlock: ^{
    
        NSArray *resourceValueKeys = @[
            NSURLIsRegularFileKey,
            NSURLTypeIdentifierKey,
            NSURLContentModificationDateKey
        ];

        NSFileManager *fileManager = [NSFileManager defaultManager];

        NSDirectoryEnumerationOptions enumeratorOptions = NSDirectoryEnumerationSkipsSubdirectoryDescendants|NSDirectoryEnumerationSkipsPackageDescendants|
            NSDirectoryEnumerationSkipsHiddenFiles ;

        // Create an enumerator to enumerate all of the immediate files in the referenced directory.
        NSDirectoryEnumerator *directoryEnumerator = [fileManager enumeratorAtURL:_rootURL includingPropertiesForKeys:resourceValueKeys options:enumeratorOptions errorHandler:^BOOL(NSURL * _Nonnull url, NSError * _Nonnull error) {
            
            NSLog(@"directoryEnumerator error: %@.",error);
            
            return true;
        }];
        
        if (directoryEnumerator == nil)
            return;
        
        NSMutableArray *addedURLs = [NSMutableArray array];
        NSMutableArray *filesToRemove = [NSMutableArray arrayWithArray:self.images];
        NSMutableArray *filesChanged = [NSMutableArray array];

        for (NSURL *anURL in directoryEnumerator) {
            
            if (![anURL isKindOfClass:[NSURL class]])
                continue;
            
            NSError *error = nil;
            
            // get resource values
            NSDictionary *resourceValues = [anURL resourceValuesForKeys:resourceValueKeys error:&error];

            // Verify the URL is a file and not a directory or symlink.
            BOOL isRegularFileResource = [[resourceValues objectForKey:NSURLIsRegularFileKey] boolValue];
            if (!isRegularFileResource)
                continue;
            
            // Verify the URL is an image.
            NSString *fileUTI = [resourceValues objectForKey:NSURLTypeIdentifierKey];
            if (!UTTypeConformsTo((__bridge CFStringRef _Nonnull)(fileUTI), kUTTypeScalableVectorGraphics))
                continue;
            
            // Verify that it has a modification date.
            NSDate *modificationDate = [resourceValues objectForKey:NSURLContentModificationDateKey];
            if (modificationDate == nil)
                continue;
            
            ImageFile *existingFile = [_imagesByURL objectForKey:anURL];
            if (existingFile != nil) {
                // This URL is in the collection, check if it needs updating.
                if ([modificationDate compare:existingFile.dateLastUpdated] == NSOrderedAscending) {
                    [filesChanged addObject:existingFile];
                    
                NSUInteger existingFileIndex = [filesToRemove indexOfObject:existingFile];
                [filesToRemove removeObjectAtIndex:existingFileIndex];
                }
            } else {
                // This URL is new, put it in our the list of added URLs
                [addedURLs addObject:anURL];
            }
        }

        for (ImageFile *imageFile in filesToRemove) {
            [self removeImageFile:imageFile];
        }

        // Regenerate all changed files.
        for (ImageFile *imageFile in filesChanged) {
            
            [self removeImageFile:imageFile];

            [addedURLs addObject: imageFile.URL];
        }

        // Update the image on the main queue.
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            for (NSURL *addedURL in addedURLs) {
                ImageFile *imageFile = [[ImageFile alloc] initWithURL:addedURL];
                [self addImageFile:imageFile];
            }
        }];
    }];
}


@end
