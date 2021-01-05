//
//  FLEXArgumentInputDataView.m
//  Flipboard
//
//  Created by Daniel Rodriguez Troitino on 2/14/15.
//  Copyright (c) 2020 FLEX Team. All rights reserved.
//

#import "FLEXArgumentInputDateView.h"
#import "FLEXRuntimeUtility.h"
#import "fakes.h"
#import <TargetConditionals.h>

@interface FLEXArgumentInputDateView ()

#if TARGET_OS_TV
@property (nonatomic) KBDatePickerView *datePicker;
#else
@property (nonatomic) UIDatePicker *datePicker;
#endif
@end

@implementation FLEXArgumentInputDateView

- (instancetype)initWithArgumentTypeEncoding:(const char *)typeEncoding {
    self = [super initWithArgumentTypeEncoding:typeEncoding];
    if (self) {
#if !TARGET_OS_TV
        self.datePicker = [UIDatePicker new];
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        
        // Using UTC, because that's what the NSDate description prints
        self.datePicker.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        self.datePicker.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
#else
        self.datePicker = [[KBDatePickerView alloc] init];
#endif
        
        [self addSubview:self.datePicker];
    }
    return self;
}

- (void)setInputValue:(id)inputValue {
    if ([inputValue isKindOfClass:[NSDate class]]) {
        self.datePicker.date = inputValue;
    }
}

- (id)inputValue {
    return self.datePicker.date;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.datePicker.frame = self.bounds;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat height = [self.datePicker sizeThatFits:size].height;
    return CGSizeMake(size.width, height);
}

+ (BOOL)supportsObjCType:(const char *)type withCurrentValue:(id)value {
    NSParameterAssert(type);
    return strcmp(type, FLEXEncodeClass(NSDate)) == 0;
}

@end
