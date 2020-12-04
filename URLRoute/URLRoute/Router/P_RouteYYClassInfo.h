//
//  P_RouteYYClassInfo.h
//  YYModel <https://github.com/ibireme/YYModel>
//
//  Created by ibireme on 15/5/9.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Type encoding's type.
 */
typedef NS_OPTIONS(NSUInteger, P_RouteYYEncodingType) {
    P_RouteYYEncodingTypeMask       = 0xFF, ///< mask of type value
    P_RouteYYEncodingTypeUnknown    = 0, ///< unknown
    P_RouteYYEncodingTypeVoid       = 1, ///< void
    P_RouteYYEncodingTypeBool       = 2, ///< bool
    P_RouteYYEncodingTypeInt8       = 3, ///< char / BOOL
    P_RouteYYEncodingTypeUInt8      = 4, ///< unsigned char
    P_RouteYYEncodingTypeInt16      = 5, ///< short
    P_RouteYYEncodingTypeUInt16     = 6, ///< unsigned short
    P_RouteYYEncodingTypeInt32      = 7, ///< int
    P_RouteYYEncodingTypeUInt32     = 8, ///< unsigned int
    P_RouteYYEncodingTypeInt64      = 9, ///< long long
    P_RouteYYEncodingTypeUInt64     = 10, ///< unsigned long long
    P_RouteYYEncodingTypeFloat      = 11, ///< float
    P_RouteYYEncodingTypeDouble     = 12, ///< double
    P_RouteYYEncodingTypeLongDouble = 13, ///< long double
    P_RouteYYEncodingTypeObject     = 14, ///< id
    P_RouteYYEncodingTypeClass      = 15, ///< Class
    P_RouteYYEncodingTypeSEL        = 16, ///< SEL
    P_RouteYYEncodingTypeBlock      = 17, ///< block
    P_RouteYYEncodingTypePointer    = 18, ///< void*
    P_RouteYYEncodingTypeStruct     = 19, ///< struct
    P_RouteYYEncodingTypeUnion      = 20, ///< union
    P_RouteYYEncodingTypeCString    = 21, ///< char*
    P_RouteYYEncodingTypeCArray     = 22, ///< char[10] (for example)
    
    P_RouteYYEncodingTypeQualifierMask   = 0xFF00,   ///< mask of qualifier
    P_RouteYYEncodingTypeQualifierConst  = 1 << 8,  ///< const
    P_RouteYYEncodingTypeQualifierIn     = 1 << 9,  ///< in
    P_RouteYYEncodingTypeQualifierInout  = 1 << 10, ///< inout
    P_RouteYYEncodingTypeQualifierOut    = 1 << 11, ///< out
    P_RouteYYEncodingTypeQualifierBycopy = 1 << 12, ///< bycopy
    P_RouteYYEncodingTypeQualifierByref  = 1 << 13, ///< byref
    P_RouteYYEncodingTypeQualifierOneway = 1 << 14, ///< oneway
    
    P_RouteYYEncodingTypePropertyMask         = 0xFF0000, ///< mask of property
    P_RouteYYEncodingTypePropertyReadonly     = 1 << 16, ///< readonly
    P_RouteYYEncodingTypePropertyCopy         = 1 << 17, ///< copy
    P_RouteYYEncodingTypePropertyRetain       = 1 << 18, ///< retain
    P_RouteYYEncodingTypePropertyNonatomic    = 1 << 19, ///< nonatomic
    P_RouteYYEncodingTypePropertyWeak         = 1 << 20, ///< weak
    P_RouteYYEncodingTypePropertyCustomGetter = 1 << 21, ///< getter=
    P_RouteYYEncodingTypePropertyCustomSetter = 1 << 22, ///< setter=
    P_RouteYYEncodingTypePropertyDynamic      = 1 << 23, ///< @dynamic
};

/**
 Get the type from a Type-Encoding string.
 
 @discussion See also:
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
 
 @param typeEncoding  A Type-Encoding string.
 @return The encoding type.
 */
P_RouteYYEncodingType P_RouteYYEncodingGetType(const char *typeEncoding);


/**
 Instance variable information.
 */
@interface P_RouteYYClassIvarInfo : NSObject
@property (nonatomic, assign, readonly) Ivar ivar;              ///< ivar opaque struct
@property (nonatomic, strong, readonly) NSString *name;         ///< Ivar's name
@property (nonatomic, assign, readonly) ptrdiff_t offset;       ///< Ivar's offset
@property (nonatomic, strong, readonly) NSString *typeEncoding; ///< Ivar's type encoding
@property (nonatomic, assign, readonly) P_RouteYYEncodingType type;    ///< Ivar's type

/**
 Creates and returns an ivar info object.
 
 @param ivar ivar opaque struct
 @return A new object, or nil if an error occurs.
 */
- (instancetype)initWithIvar:(Ivar)ivar;
@end


/**
 Method information.
 */
@interface P_RouteYYClassMethodInfo : NSObject
@property (nonatomic, assign, readonly) Method method;                  ///< method opaque struct
@property (nonatomic, strong, readonly) NSString *name;                 ///< method name
@property (nonatomic, assign, readonly) SEL sel;                        ///< method's selector
@property (nonatomic, assign, readonly) IMP imp;                        ///< method's implementation
@property (nonatomic, strong, readonly) NSString *typeEncoding;         ///< method's parameter and return types
@property (nonatomic, strong, readonly) NSString *returnTypeEncoding;   ///< return value's type
@property (nullable, nonatomic, strong, readonly) NSArray<NSString *> *argumentTypeEncodings; ///< array of arguments' type

/**
 Creates and returns a method info object.
 
 @param method method opaque struct
 @return A new object, or nil if an error occurs.
 */
- (instancetype)initWithMethod:(Method)method;
@end


/**
 Property information.
 */
@interface P_RouteYYClassPropertyInfo : NSObject
@property (nonatomic, assign, readonly) objc_property_t property; ///< property's opaque struct
@property (nonatomic, strong, readonly) NSString *name;           ///< property's name
@property (nonatomic, assign, readonly) P_RouteYYEncodingType type;      ///< property's type
@property (nonatomic, strong, readonly) NSString *typeEncoding;   ///< property's encoding value
@property (nonatomic, strong, readonly) NSString *ivarName;       ///< property's ivar name
@property (nullable, nonatomic, assign, readonly) Class cls;      ///< may be nil
@property (nullable, nonatomic, strong, readonly) NSArray<NSString *> *protocols; ///< may nil
@property (nonatomic, assign, readonly) SEL getter;               ///< getter (nonnull)
@property (nonatomic, assign, readonly) SEL setter;               ///< setter (nonnull)

/**
 Creates and returns a property info object.
 
 @param property property opaque struct
 @return A new object, or nil if an error occurs.
 */
- (instancetype)initWithProperty:(objc_property_t)property;
@end


/**
 Class information for a class.
 */
@interface P_RouteYYClassInfo : NSObject
@property (nonatomic, assign, readonly) Class cls; ///< class object
@property (nullable, nonatomic, assign, readonly) Class superCls; ///< super class object
@property (nullable, nonatomic, assign, readonly) Class metaCls;  ///< class's meta class object
@property (nonatomic, readonly) BOOL isMeta; ///< whether this class is meta class
@property (nonatomic, strong, readonly) NSString *name; ///< class name
@property (nullable, nonatomic, strong, readonly) P_RouteYYClassInfo *superClassInfo; ///< super class's class info
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, P_RouteYYClassIvarInfo *> *ivarInfos; ///< ivars
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, P_RouteYYClassMethodInfo *> *methodInfos; ///< methods
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, P_RouteYYClassPropertyInfo *> *propertyInfos; ///< properties

/**
 If the class is changed (for example: you add a method to this class with
 'class_addMethod()'), you should call this method to refresh the class info cache.
 
 After called this method, `needUpdate` will returns `YES`, and you should call 
 'classInfoWithClass' or 'classInfoWithClassName' to get the updated class info.
 */
- (void)setNeedUpdate;

/**
 If this method returns `YES`, you should stop using this instance and call
 `classInfoWithClass` or `classInfoWithClassName` to get the updated class info.
 
 @return Whether this class info need update.
 */
- (BOOL)needUpdate;

/**
 Get the class info of a specified Class.
 
 @discussion This method will cache the class info and super-class info
 at the first access to the Class. This method is thread-safe.
 
 @param cls A class.
 @return A class info, or nil if an error occurs.
 */
+ (nullable instancetype)classInfoWithClass:(Class)cls;

/**
 Get the class info of a specified Class.
 
 @discussion This method will cache the class info and super-class info
 at the first access to the Class. This method is thread-safe.
 
 @param className A class name.
 @return A class info, or nil if an error occurs.
 */
+ (nullable instancetype)classInfoWithClassName:(NSString *)className;

@end

NS_ASSUME_NONNULL_END
