//
//  UIImage+SSImageShadow.h
//  HoleInTheWall
//
//  Created by Stevenson on 3/4/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SSImageShadow)

/**
 *
 * Creates UIImage with a shadow effect on the 4 sides of the given uiimage's frame
 * @param UIImage an image
 * @return UIImage with shadow box
 *
**/
+ (UIImage*)createShadowBoxImageWithImage:(UIImage*) image;

/**
 *
 * Crates a new image composing all the images in the given array
 * @param NSArray containing objects of type UIImage
 * @param CGSize size of the image you want to draw. Suggested size is the maximum size of an image in the given array
 * @return UIImage, composite of all images in array
 *
 **/
+ (UIImage*)combineImages:(NSArray*)images withSize:(CGSize) size;

@end
