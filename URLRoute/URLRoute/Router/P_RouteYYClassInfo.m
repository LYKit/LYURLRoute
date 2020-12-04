//
//  P_RouteYYClassInfo.m
//  YYModel <https://github.com/ibireme/YYModel>
//
//  Created by ibireme on 15/5/9.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "P_RouteYYClassInfo.h"
#import <objc/runtime.h>

P_RouteYYEncodingType P_RouteYYEncodingGetType(const char *typeEncoding) {
    char *type = (char *)typeEncoding;
    if (!type) return P_RouteYYEncodingTypeUnknown;
    size_t len = strlen(type);
    if (len == 0) return P_RouteYYEncodingTypeUnknown;
    
    P_RouteYYEncodingType qualifier = 0;
    bool prefix = true;
    while (prefix) {
        switch (*type) {
            case 'r': {
                qualifier |= P_RouteYYEncodingTypeQualifierConst;
                type++;
            } break;
            case 'n': {
                qualifier |= P_RouteYYEncodingTypeQualifierIn;
                type++;
            } break;
            case 'N': {
                qualifier |= P_RouteYYEncodingTypeQualifierInout;
                type++;
            } break;
            case 'o': {
                qualifier |= P_RouteYYEncodingTypeQualifierOut;
                type++;
            } break;
            case 'O': {
                qualifier |= P_RouteYYEncodingTypeQualifierBycopy;
                type++;
            } break;
            case 'R': {
                qualifier |= P_RouteYYEncodingTypeQualifierByref;
                type++;
            } break;
            case 'V': {
                qualifier |= P_RouteYYEncodingTypeQualifierOneway;
                type++;
            } break;
            default: { prefix = false; } break;
        }
    }

    len = strlen(type);
    if (len == 0) return P_RouteYYEncodingTypeUnknown | qualifier;

    switch (*type) {
        case 'v': return P_RouteYYEncodingTypeVoid | qualifier;
        case 'B': return P_RouteYYEncodingTypeBool | qualifier;
        case 'c': return P_RouteYYEncodingTypeInt8 | qualifier;
        case 'C': return P_RouteYYEncodingTypeUInt8 | qualifier;
        case 's': return P_RouteYYEncodingTypeInt16 | qualifier;
        case 'S': return P_RouteYYEncodingTypeUInt16 | qualifier;
        case 'i': return P_RouteYYEncodingTypeInt32 | qualifier;
        case 'I': return P_RouteYYEncodingTypeUInt32 | qualifier;
        case 'l': return P_RouteYYEncodingTypeInt32 | qualifier;
        case 'L': return P_RouteYYEncodingTypeUInt32 | qualifier;
        case 'q': return P_RouteYYEncodingTypeInt64 | qualifier;
        case 'Q': return P_RouteYYEncodingTypeUInt64 | qualifier;
        case 'f': return P_RouteYYEncodingTypeFloat | qualifier;
        case 'd': return P_RouteYYEncodingTypeDouble | qualifier;
        case 'D': return P_RouteYYEncodingTypeLongDouble | qualifier;
        case '#': return P_RouteYYEncodingTypeClass | qualifier;
        case ':': return P_RouteYYEncodingTypeSEL | qualifier;
        case '*': return P_RouteYYEncodingTypeCString | qualifier;
        case '^': return P_RouteYYEncodingTypePointer | qualifier;
        case '[': return P_RouteYYEncodingTypeCArray | qualifier;
        case '(': return P_RouteYYEncodingTypeUnion | qualifier;
        case '{': return P_RouteYYEncodingTypeStruct | qualifier;
        case '@': {
            if (len == 2 && *(type + 1) == '?')
                return P_RouteYYEncodingTypeBlock | qualifier;
            else
                return P_RouteYYEncodingTypeObject | qualifier;
        }
        default: return P_RouteYYEncodingTypeUnknown | qualifier;
    }
}

@implementation P_RouteYYClassIvarInfo

- (instancetype)initWithIvar:(Ivar)ivar {
    if (!ivar) return nil;
    self = [super init];
    _ivar = ivar;
    const char *name = ivar_getName(ivar);
    if (name) {
        _name = [NSString stringWithUTF8String:name];
    }
    _offset = ivar_getOffset(ivar);
    const char *typeEncoding = ivar_getTypeEncoding(ivar);
    if (typeEncoding) {
        _typeEncoding = [NSString stringWithUTF8String:typeEncoding];
        _type = P_RouteYYEncodingGetType(typeEncoding);
    }
    return self;
}

@end

@implementation P_RouteYYClassMethodInfo

- (instancetype)initWithMethod:(Method)method {
    if (!method) return nil;
    self = [super init];
    _method = method;
    _sel = method_getName(method);
    _imp = method_getImplementation(method);
    const char *name = sel_getName(_sel);
    if (name) {
        _name = [NSString stringWithUTF8String:name];
    }
    const char *typeEncoding = method_getTypeEncoding(method);
    if (typeEncoding) {
        _typeEncoding = [NSString stringWithUTF8String:typeEncoding];
    }
    char *returnType = method_copyReturnType(method);
    if (returnType) {
        _returnTypeEncoding = [NSString stringWithUTF8String:returnType];
        free(returnType);
    }
    unsigned int argumentCount = method_getNumberOfArguments(method);
    if (argumentCount > 0) {
        NSMutableArray *argumentTypes = [NSMutableArray new];
        for (unsigned int i = 0; i < argumentCount; i++) {
            char *argumentType = method_copyArgumentType(method, i);
            NSString *type = argumentType ? [NSString stringWithUTF8String:argumentType] : nil;
            [argumentTypes addObject:type ? type : @""];
            if (argumentType) free(argumentType);
        }
        _argumentTypeEncodings = argumentTypes;
    }
    return self;
}

@end

@implementation P_RouteYYClassPropertyInfo

- (instancetype)initWithProperty:(objc_property_t)property {
    if (!property) return nil;
    self = [super init];
    _property = property;
    const char *name = property_getName(property);
    if (name) {
        _name = [NSString stringWithUTF8String:name];
    }
    
    P_RouteYYEncodingType type = 0;
    unsigned int attrCount;
    objc_property_attribute_t *attrs = property_copyAttributeList(property, &attrCount);
    for (unsigned int i = 0; i < attrCount; i++) {
        switch (attrs[i].name[0]) {
            case 'T': { // Type encoding
                if (attrs[i].value) {
                    _typeEncoding = [NSString stringWithUTF8String:attrs[i].value];
                    type = P_RouteYYEncodingGetType(attrs[i].value);
                    
                    if ((type & P_RouteYYEncodingTypeMask) == P_RouteYYEncodingTypeObject && _typeEncoding.length) {
                        NSScanner *scanner = [NSScanner scannerWithString:_typeEncoding];
                        if (![scanner scanString:@"@\"" intoString:NULL]) continue;
                        
                        NSString *clsName = nil;
                        if ([scanner scanUpToCharactersFromSet: [NSCharacterSet characterSetWithCharactersInString:@"\"<"] intoString:&clsName]) {
                            if (clsName.length) _cls = objc_getClass(clsName.UTF8String);
                        }
                        
                        NSMutableArray *protocols = nil;
                        while ([scanner scanString:@"<" intoString:NULL]) {
                            NSString* protocol = nil;
                            if ([scanner scanUpToString:@">" intoString: &protocol]) {
                                if (protocol.length) {
                                    if (!protocols) protocols = [NSMutableArray new];
                                    [protocols addObject:protocol];
                                }
                            }
                            [scanner scanString:@">" intoString:NULL];
                        }
                        _protocols = protocols;
                    }
                }
            } break;
            case 'V': { // Instance variable
                if (attrs[i].value) {
                    _ivarName = [NSString stringWithUTF8String:attrs[i].value];
                }
            } break;
            case 'R': {
                type |= P_RouteYYEncodingTypePropertyReadonly;
            } break;
            case 'C': {
                type |= P_RouteYYEncodingTypePropertyCopy;
            } break;
            case '&': {
                type |= P_RouteYYEncodingTypePropertyRetain;
            } break;
            case 'N': {
                type |= P_RouteYYEncodingTypePropertyNonatomic;
            } break;
            case 'D': {
                type |= P_RouteYYEncodingTypePropertyDynamic;
            } break;
            case 'W': {
                type |= P_RouteYYEncodingTypePropertyWeak;
            } break;
            case 'G': {
                type |= P_RouteYYEncodingTypePropertyCustomGetter;
                if (attrs[i].value) {
                    _getter = NSSelectorFromString([NSString stringWithUTF8String:attrs[i].value]);
                }
            } break;
            case 'S': {
                type |= P_RouteYYEncodingTypePropertyCustomSetter;
                if (attrs[i].value) {
                    _setter = NSSelectorFromString([NSString stringWithUTF8String:attrs[i].value]);
                }
            } // break; commented for code coverage in next line
            default: break;
        }
    }
    if (attrs) {
        free(attrs);
        attrs = NULL;
    }
    
    _type = type;
    if (_name.length) {
        if (!_getter) {
            _getter = NSSelectorFromString(_name);
        }
        if (!_setter) {
            _setter = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", [_name substringToIndex:1].uppercaseString, [_name substringFromIndex:1]]);
        }
    }
    return self;
}

@end

@implementation P_RouteYYClassInfo {
    BOOL _needUpdate;
}

- (instancetype)initWithClass:(Class)cls {
    if (!cls) return nil;
    self = [super init];
    _cls = cls;
    _superCls = class_getSuperclass(cls);
    _isMeta = class_isMetaClass(cls);
    if (!_isMeta) {
        _metaCls = objc_getMetaClass(class_getName(cls));
    }
    _name = NSStringFromClass(cls);
    [self _update];

    _superClassInfo = [self.class classInfoWithClass:_superCls];
    return self;
}

- (void)_update {
    _ivarInfos = nil;
    _methodInfos = nil;
    _propertyInfos = nil;
    
    Class cls = self.cls;
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(cls, &methodCount);
    if (methods) {
        NSMutableDictionary *methodInfos = [NSMutableDictionary new];
        _methodInfos = methodInfos;
        for (unsigned int i = 0; i < methodCount; i++) {
            P_RouteYYClassMethodInfo *info = [[P_RouteYYClassMethodInfo alloc] initWithMethod:methods[i]];
            if (info.name) methodInfos[info.name] = info;
        }
        free(methods);
    }
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(cls, &propertyCount);
    if (properties) {
        NSMutableDictionary *propertyInfos = [NSMutableDictionary new];
        _propertyInfos = propertyInfos;
        for (unsigned int i = 0; i < propertyCount; i++) {
            P_RouteYYClassPropertyInfo *info = [[P_RouteYYClassPropertyInfo alloc] initWithProperty:properties[i]];
            if (info.name) propertyInfos[info.name] = info;
        }
        free(properties);
    }
    
    unsigned int ivarCount = 0;
    Ivar *ivars = class_copyIvarList(cls, &ivarCount);
    if (ivars) {
        NSMutableDictionary *ivarInfos = [NSMutableDictionary new];
        _ivarInfos = ivarInfos;
        for (unsigned int i = 0; i < ivarCount; i++) {
            P_RouteYYClassIvarInfo *info = [[P_RouteYYClassIvarInfo alloc] initWithIvar:ivars[i]];
            if (info.name) ivarInfos[info.name] = info;
        }
        free(ivars);
    }
    
    if (!_ivarInfos) _ivarInfos = @{};
    if (!_methodInfos) _methodInfos = @{};
    if (!_propertyInfos) _propertyInfos = @{};
    
    _needUpdate = NO;
}

- (void)setNeedUpdate {
    _needUpdate = YES;
}

- (BOOL)needUpdate {
    return _needUpdate;
}

+ (instancetype)classInfoWithClass:(Class)cls {
    if (!cls) return nil;
    static CFMutableDictionaryRef classCache;
    static CFMutableDictionaryRef metaCache;
    static dispatch_once_t onceToken;
    static dispatch_semaphore_t lock;
    dispatch_once(&onceToken, ^{
        classCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        metaCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        lock = dispatch_semaphore_create(1);
    });
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    P_RouteYYClassInfo *info = CFDictionaryGetValue(class_isMetaClass(cls) ? metaCache : classCache, (__bridge const void *)(cls));
    if (info && info->_needUpdate) {
        [info _update];
    }
    dispatch_semaphore_signal(lock);
    if (!info) {
        info = [[P_RouteYYClassInfo alloc] initWithClass:cls];
        if (info) {
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            CFDictionarySetValue(info.isMeta ? metaCache : classCache, (__bridge const void *)(cls), (__bridge const void *)(info));
            dispatch_semaphore_signal(lock);
        }
    }
    return info;
}

+ (instancetype)classInfoWithClassName:(NSString *)className {
    Class cls = NSClassFromString(className);
    return [self classInfoWithClass:cls];
}

@end
