//
//  ARLabelSubclasses.m
//  Artsy
//
//  Created by Orta Therox on 17/11/2012.
//  Copyright (c) 2012 Artsy. All rights reserved.
//

#import "ARLabelSubclasses.h"
#import "UIView+ARDrawing.h"
#import "NSNumberFormatter+ARCurrency.h"
#import <Artsy+UIColors/UIColor+ArtsyColors.h>
#import <Artsy+UIFonts/UIFont+ArtsyFonts.h>

static const CGSize ChevronSize = { 8, 13 };

@interface ARLabelWithChevron ()
@property (readonly, nonatomic, strong) UIImageView *chevron;
@end

@implementation ARLabel

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self setup];
    
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    self.numberOfLines = 0;
    self.preferredMaxLayoutWidth = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 728 : 280;
    self.backgroundColor = [UIColor whiteColor];
    self.opaque = YES;
}

@end


@implementation ARLabelWithChevron

- (void)setup
{
    [super setup];
    self.font = [UIFont sansSerifFontWithSize:14];
    self.chevronDelta = 6;
    self.clipsToBounds = NO;
}

- (void)setText:(NSString *)text
{
    [super setText:text];

    if (!self.chevron) {
        NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"Chevron_Gray" ofType:@"png"];
        UIImage *chevronImage = [UIImage imageWithContentsOfFile:path];
        UIImageView *chevron = [[UIImageView alloc] initWithImage:chevronImage];
        [self addSubview:chevron];
        _chevron = chevron;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat yPosition = (CGRectGetHeight(self.bounds) / 2) - self.chevronDelta;
    self.chevron.frame = CGRectMake(self.intrinsicContentSize.width + 8, yPosition, ChevronSize.width, ChevronSize.height);
}

- (void)setHidesChevron:(BOOL)hide
{
    self.chevron.hidden = hide;
}

@end

@implementation ARSerifLabel

- (void)setup
{
    [super setup];
    self.font = [UIFont serifFontWithSize:self.font.pointSize];
}

@end

@implementation ARItalicsSerifLabel

- (void)setup
{
    [super setup];
    self.font = [UIFont serifItalicFontWithSize:self.font.pointSize];
}

@end

@implementation ARSansSerifLabel

- (void)setup
{
    [super setup];
    self.font = [UIFont sansSerifFontWithSize:self.font.pointSize];
}

- (void)setText:(NSString *)text {
    [super setText:text.uppercaseString];
}

@end

@implementation ARItalicsSerifLabelWithChevron

@end

@implementation ARArtworkTitleLabel

- (void)setTitle:(NSString *)artworkTitle date:(NSString *)date;
{
    NSAssert(artworkTitle, @"Artwork With no title given to an ARArtworkTitleLabel");

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];

    NSMutableAttributedString *titleAndDate = [[NSMutableAttributedString alloc] initWithString:artworkTitle attributes:@{
        NSParagraphStyleAttributeName: paragraphStyle
    }];

    if (date.length > 0) {
        NSString *formattedTitleDate = [@", " stringByAppendingString:date];
        NSAttributedString *andDate = [[NSAttributedString alloc] initWithString:formattedTitleDate attributes:@{
             NSFontAttributeName : [UIFont serifFontWithSize:16]
        }];
        [titleAndDate appendAttributedString:andDate];
    }

    self.font = [UIFont serifItalicFontWithSize:16];
    self.numberOfLines = 0;
    self.attributedText = titleAndDate;
}

@end

@interface ARSerifLineHeightLabel()
@end

@implementation ARSerifLineHeightLabel

- (instancetype)initWithLineSpacing:(CGFloat)lineHeight
{
    self = [super init];
    if (!self) { return nil; }

    _lineHeight = lineHeight;

    return self;
}

- (void)setText:(NSString *)text
{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:self.lineHeight];
    [paragraphStyle setAlignment:self.textAlignment];

    [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];

    self.numberOfLines = 0;
    self.attributedText = attr;
}

@end

static const CGFloat ARBorderLabelInset = 10;

@implementation ARBorderLabel

- (id)init
{
    if ((self = [super initWithLineSpacing:4])) {
        self.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self drawSolidBordersWithColor:self.textColor];
}

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {ARBorderLabelInset, 0, ARBorderLabelInset, 0};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    return CGSizeMake(size.width, size.height + ARBorderLabelInset * 2);
}

@end

@implementation ARSerifLabelWithChevron

@end
