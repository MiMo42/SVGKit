//
//  ImageListViewController.m
//  Demo-OSX
//
//  Created by Michael Monscheuer on 20/10/16.
//  Copyright © 2016 Michael Monscheuer. All rights reserved.
//

#import "ImageListViewController.h"

#import "ImageCollectionViewItem.h"

#import "ImageCollection.h"
#import "ImageFile.h"

@interface ImageListViewController () <NSCollectionViewDataSource, NSCollectionViewDelegate>

@property (weak) IBOutlet NSCollectionView *collectionView;

@end

@implementation ImageListViewController
{
    NSArray *_imageCollections;
}

static NSString * ImageCollectionViewItemIdentifier = @"ImageItem";

#pragma mark - Life Cycle

- (void)viewDidLoad {

    // Tell the CollectionView to use the ImageCollectionViewItem nib for its items.
    NSNib *nib = [[NSNib alloc] initWithNibNamed:@"ImageCollectionViewItem" bundle:nil];

    [_collectionView registerNib:nib forItemWithIdentifier:ImageCollectionViewItemIdentifier];
        
    _collectionView.dataSource = self;
    _collectionView.delegate = self;

    // Create a grid layout that is somewhat flexible for the various widths it might have.
    NSCollectionViewGridLayout *gridLayout = [NSCollectionViewGridLayout new];
    gridLayout.minimumItemSize = NSMakeSize(100, 100);
    gridLayout.maximumItemSize = NSMakeSize(175, 175);
    gridLayout.minimumInteritemSpacing = 10;
    gridLayout.margins = NSEdgeInsetsMake(10, 10, 10, 10);

    _collectionView.collectionViewLayout = gridLayout;

    [self _reloadCollectionViewAndSelectFirstItemIfNecessary];

    [super viewDidLoad];
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - Properties

- (NSArray *)imageCollections
{
    @synchronized (self) {
        return _imageCollections;
    }
}

- (void)setImageCollections:(NSArray *)collections
{
    @synchronized (self) {
    
        NSArray *oldValue = _imageCollections;
        
        _imageCollections = collections;
        
        // Observe the new collections for changes, and unobserve the old collections.
        for (ImageCollection *collection in oldValue) {
        
            [NSNotificationCenter.defaultCenter removeObserver:self name:ImagesDidChangeNotification object:collection];
        }

        for (ImageCollection *collection in collections) {
            [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(imageCollectionDidChange:) name:ImagesDidChangeNotification object:collection];
        }
    }
    
    if (![self isViewLoaded])
        return;
    
    [self _reloadCollectionViewAndSelectFirstItemIfNecessary];
}

#pragma mark - Change Handlers

- (void)imageCollectionDidChange:(NSNotification *)note
{
    [self _reloadCollectionViewAndSelectFirstItemIfNecessary];
}

#pragma mark - <NSCollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView
{
    return _imageCollections.count;
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_imageCollections[section] images].count;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath
{
    NSCollectionViewItem *item = [_collectionView makeItemWithIdentifier:ImageCollectionViewItemIdentifier forIndexPath:indexPath];
    
    ImageCollectionViewItem *imageItem = (ImageCollectionViewItem *)item;
    if ([imageItem isKindOfClass:[ImageCollectionViewItem class]]) {
        ImageCollection *imageCollection = _imageCollections[indexPath.section];
        
        imageItem.imageFile = imageCollection.images[indexPath.item];
    }
    
    return item;
}

#pragma mark - <NSCollectionViewDelegate>

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths
{
    [self _handleSelectionChanged];
}

- (void)collectionView:(NSCollectionView *)collectionView didDeselectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths
{
    [self _handleSelectionChanged];
}

#pragma mark - Private Methods

- (void)_handleSelectionChanged
{
    if (_imageSelectionHandler == nil) {
        return;
    }
    
    /*
        The collection view does not support multiple selection, so just check
        the first index.
    */
    ImageFile *selectedImage = nil;

    NSIndexPath *selectedIndexPath = [_collectionView.selectionIndexPaths anyObject];
    
    if (selectedIndexPath != nil && selectedIndexPath.section != -1 && [selectedIndexPath item] != -1) {
        // There is a selected index path, get the image at that path.
        selectedImage = [_imageCollections[selectedIndexPath.section] images][[selectedIndexPath item]];
    } else {
        selectedImage = nil;
    }
    
    _imageSelectionHandler(selectedImage);
}

- (void)_reloadCollectionViewAndSelectFirstItemIfNecessary
{
    [_collectionView reloadData];

    // If the `collectionView` has no selection, attempt to select the first available item.
    if (_collectionView.selectionIndexPaths.count > 0)
        return;
    
    // Get the collections that contain images.
    NSPredicate *filterPredicate = [NSPredicate predicateWithBlock:
        ^BOOL(id _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            if (![evaluatedObject isKindOfClass:[ImageCollection class]])
                return NO;
    
            ImageCollection *collection = (ImageCollection *)evaluatedObject;
            if (collection.images.count == 0)
                return NO;
            
            return YES;
        }];

    // Find the first `ImageCollection` that actually has images displayed.
    NSArray <ImageCollection *> *populatedCollections = [_imageCollections filteredArrayUsingPredicate:filterPredicate];
    ImageCollection *firstPopulatedCollection = populatedCollections.firstObject;
    if (firstPopulatedCollection == nil)
        return;

    /*
        Get the index path to that collection's first image -- section is the 
        index of the collection, item index is 0.
    */
    NSUInteger firstPopulatedIndex = [_imageCollections indexOfObject:firstPopulatedCollection];

    // Programmatically change the selection, and handle the changed selection.
    _collectionView.selectionIndexPaths = [NSSet setWithObject:[NSIndexPath indexPathForItem:0 inSection:firstPopulatedIndex]];

    [self _handleSelectionChanged];
}

@end
