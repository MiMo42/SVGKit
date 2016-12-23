//
//  ImageCollectionViewItem.m
//  Demo-OSX
//
//  Created by Michael Monscheuer on 20/10/16.
//  Copyright © 2016 Michael Monscheuer. All rights reserved.
//

#import "ImageCollectionViewItem.h"

/**
    The KVO context used for all `ImageCollectionViewItem` instances. This provides
    a stable address to use as the context parameter for the KVO observation methods.
*/
static void *ImageCollectionViewItemKVOContext;

@interface ImageCollectionViewItem ()

@end

@implementation ImageCollectionViewItem
{
    ImageFile *_imageFile;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _updateImageViewWithImageFile:self.imageFile];
    
    self.view.layer.cornerRadius = 2.0;

    /*
        Watch for when the containing `collectionView` changes in order to 
        observe its `firstResponder`. Include the old and new `collectionView` 
        in the change dictionary to be able to unobserve the old one.
    */
    [self addObserver:self forKeyPath:@"collectionView" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:ImageCollectionViewItemKVOContext];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"collectionView" context:ImageCollectionViewItemKVOContext];
    
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    
    // Observe the window for `keyWindow` state changes.
    NSWindow *window = self.view.window;
    if (window != nil) {
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(windowDidChangeKeyState:) name:NSWindowDidBecomeKeyNotification object:window];

        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(windowDidChangeKeyState:) name:NSWindowDidResignKeyNotification object:window];
    }

    // Update the selection appearance now that the item is in a window
    [self _updateAppearanceFromKeyState];
}

- (void)viewWillDisappear
{
    [super viewWillDisappear];
    
    // Stop observing the window for `keyWindow` state changes.
    NSWindow *window = self.view.window;
    if (window != nil) {
        [NSNotificationCenter.defaultCenter removeObserver:self name:NSWindowDidBecomeKeyNotification object:window];
        [NSNotificationCenter.defaultCenter removeObserver:self name:NSWindowDidResignKeyNotification object:window];
    }
}

#pragma mark - Properties

- (ImageFile *)imageFile
{
    @synchronized (self) {
        return _imageFile;
    }
}

- (void)setImageFile:(ImageFile *)imageFile
{
    @synchronized (self) {
        _imageFile = imageFile;
        
        [self _updateImageViewWithImageFile:imageFile];
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    [self _updateAppearanceFromKeyState];
}

- (void)setHighlightState:(NSCollectionViewItemHighlightState)highlightState
{
    [super setHighlightState:highlightState];
    
    [self _updateAppearanceFromKeyState];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context != ImageCollectionViewItemKVOContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    NSCollectionView *newCollectionView = (NSCollectionView *)object;
    if ([newCollectionView isKindOfClass:[NSCollectionView class]] &&
        newCollectionView == self.collectionView &&
        [keyPath isEqualToString:@"isFirstResponder"]) {

        /*
            If the item's collection view changed first responder state, the
            selection appearance may have changed.
        */
        
        [self _updateAppearanceFromKeyState];
        
    } else if ([object isKindOfClass:[NSCollectionViewItem class]] &&
                object == self &&
                [keyPath isEqualToString:@"collectionView"]) {
        
        NSCollectionView *oldCollectionView = (NSCollectionView *)change[NSKeyValueChangeOldKey];
    
        if (oldCollectionView != nil && [oldCollectionView isKindOfClass:[NSCollectionView class]]) {
        
            // Stop observing the containing collection view for first responder changes.
            [oldCollectionView removeObserver:self forKeyPath:@"isFirstResponder" context:ImageCollectionViewItemKVOContext];
        }
        
        NSCollectionView *newCollectionView = (NSCollectionView *)change[NSKeyValueChangeNewKey];
        
        if (newCollectionView != nil && [newCollectionView isKindOfClass:[NSCollectionView class]]) {
            // Observe the containing collection view for `firstResponder` state changes
            [newCollectionView addObserver:self forKeyPath:@"isFirstResponder" options:NSKeyValueObservingOptionNew context:ImageCollectionViewItemKVOContext];
        }
    }
}

#pragma mark - Private Methods

- (void)_updateImageViewWithImageFile:(ImageFile *)imageFile
{
    if (imageFile == nil) {
        self.imageView.image = nil;
        return;
    }
    
    [imageFile fetchThumbnailWithCompletionHandler:
        ^(NSImage *thumbnailImage) {
            if (self.imageFile == imageFile) {
                self.imageView.image = thumbnailImage;
            }
        }];
}

- (void)_updateAppearanceFromKeyState
{
    /*
        If the containing collection view is the first responder in a window
        that is key, then its items have a key appearance.
    */
    BOOL hasKeyAppearance = self.collectionView.isFirstResponder && (self.collectionView.window.isKeyWindow);

    /*
        If the item has key appearance, it uses the user's set selection color, 
        otherwise uses the standard inactive selection color.
    */
    NSColor *baseHighlightColor = hasKeyAppearance ? [NSColor alternateSelectedControlColor]: [NSColor secondarySelectedControlColor];
    
    CGColorRef backgroundColor;

    switch(self.highlightState) {
        case NSCollectionViewItemHighlightForSelection:
            backgroundColor = [baseHighlightColor colorWithAlphaComponent:0.4].CGColor;
            break;
        case NSCollectionViewItemHighlightAsDropTarget:
            backgroundColor = [baseHighlightColor colorWithAlphaComponent:1.0].CGColor;
            
        default:
            if (self.isSelected) {
                backgroundColor = [baseHighlightColor colorWithAlphaComponent:0.8].CGColor;
            } else {
                backgroundColor = [NSColor clearColor].CGColor;
            }
    }
    
    self.view.layer.backgroundColor = backgroundColor;
}

- (void)windowDidChangeKeyState:(NSNotification *)notification
{
    // When the window changes key state, the selection appearance may have changed.
    [self _updateAppearanceFromKeyState];
}

@end
