//
//  OPMKeyButton.m
//  OptimusPopularisManager
//
//  Created by Khaos Tian on 2/4/14.
//  Copyright (c) 2014 Oltica. All rights reserved.
//

#import "OPMKeyButton.h"
#import "OPMUpdateQueue.h"

@interface OPMKeyButton (){
    OPMPlugin    *_plugin;
    NSSize       _size;
    NSString     *_currentText;
    NSImage      *_currentImage;
    
    NSInteger    _dataSize;
}

@property (readwrite,nonatomic) NSInteger index;

@end

@implementation OPMKeyButton

-(OPMKeyButton *)initWithButtonIndex:(NSInteger)index size:(NSSize)size dataSize:(NSInteger)dataSize
{
    if (self = [super init]) {
        _index = index;
        _size = size;
        _dataSize = dataSize;
    }
    return self;
}

-(void)setDisplayPlugin:(OPMPlugin *)plugin
{
    if (_plugin) {
        [_plugin deactivate];
    }
    _plugin = plugin;
    [_plugin activate];
}

-(void)setText:(NSString *)text
{
    _currentText = text;
    NSImage *image = [[NSImage alloc]initWithSize:_size];
    [image lockFocus];
    //// Abstracted Attributes
    NSString* textContent = text;
    NSFont* font = [NSFont boldSystemFontOfSize: 20];
    
    //// Text Drawing
    NSRect textRect = NSMakeRect(0, 0, _size.width, _size.height);
    NSBezierPath* textPath = [NSBezierPath bezierPathWithRect: textRect];
    [[NSColor blackColor] setFill];
    [textPath fill];
    NSMutableParagraphStyle* textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    [textStyle setAlignment: NSCenterTextAlignment];
    
    NSDictionary* textFontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        font, NSFontAttributeName,
                                        [NSColor whiteColor], NSForegroundColorAttributeName,
                                        textStyle, NSParagraphStyleAttributeName, nil];
    CGFloat fontHeight = font.pointSize;
    CGFloat yOffset = (textRect.size.height - fontHeight) / 2.0;
    textRect = CGRectMake(0, yOffset, textRect.size.width, fontHeight+6.0);
    
    [textContent drawInRect: NSOffsetRect(textRect, 0, 1) withAttributes: textFontAttributes];
    [image unlockFocus];
    [self setImage:image];
}

-(NSImage *)currentImage
{
    return _currentImage;
}

-(void)setImage:(NSImage *)newImage
{
    if (!newImage) {
        return;
    }
    _currentImage = newImage;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSImage *image = [self prepareImageForDisplay:newImage size:_size];
        NSBitmapImageRep *bitmapImageRep = [[NSBitmapImageRep alloc] initWithData:[image TIFFRepresentation]];
        NSData *data = [NSData dataWithBytes:bitmapImageRep.bitmapData length:[bitmapImageRep pixelsWide]*[bitmapImageRep pixelsHigh]*[bitmapImageRep samplesPerPixel]*sizeof(unsigned char)];
        NSMutableData *imageData = [[NSMutableData alloc]initWithLength:_dataSize];
        
        if (bitmapImageRep.hasAlpha) {
            NSData *myData = data;
            const char *bytes = [myData bytes];
            char *newBytes = malloc(sizeof(char) * [myData length]);
            unsigned long index = 0;
            for (int i = 0; i < [myData length]; i++)
            {
                if (i%4 != 3) {
                    newBytes[index] = bytes[i];
                    index ++;
                }
            }
            [imageData replaceBytesInRange:NSMakeRange(0, index) withBytes:newBytes];
            free(newBytes);
        }else{
            imageData = (NSMutableData *)data;
        }
        
        [[OPMUpdateQueue sharedQueue]addOperationWithBlock:^{
            NSError *err;
            
            [[NSFileManager defaultManager]removeItemAtPath:[NSString stringWithFormat:@"/Volumes/OptimusDisk/VOPTIMUS/dynamic/%03ld.sys",(long)_index] error:&err];
            if (err) {
                NSLog(@"%@",err);
            }
            if (![imageData writeToFile:[NSString stringWithFormat:@"/Volumes/OptimusDisk/VOPTIMUS/dynamic/%03ld.sys",(long)_index] atomically:YES]) {
                NSLog(@"WriteFailed");
            }
        }];
    });
}

- (NSImage*)prepareImageForDisplay:(NSImage *)sourceImage size:(NSSize)size
{
    NSRect targetFrame = NSMakeRect(0, 0, size.width, size.height);
    NSImage* targetImage = nil;
    
    NSImageRep *sourceImageRep =
    [sourceImage bestRepresentationForRect:targetFrame
                                   context:nil
                                     hints:nil];

    
    targetImage = [[NSImage alloc] initWithSize:size];
    
    float degrees = 180.0;
    NSSize maxSize = size;

    NSAffineTransform *rot = [NSAffineTransform transform];
    [rot rotateByDegrees:degrees];
    NSAffineTransform *center = [NSAffineTransform transform];
    [center translateXBy:maxSize.width / 2. yBy:maxSize.height / 2.];
    [rot appendTransform:center];
    
    [targetImage lockFocus];
    [rot concat];
    
    NSPoint corner = NSMakePoint(-size.width / 2., -size.height / 2.);
    NSRect rect = NSMakeRect(corner.x, corner.y, size.width, size.height);

    [[NSColor whiteColor]setFill];
    NSRectFill(targetFrame);
    [sourceImageRep drawInRect: rect];
    [targetImage unlockFocus];
    
    return targetImage;
}

@end
