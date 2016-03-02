//
//  FWProperty.h
//  Framework
//
//  Created by 吴勇 on 16/2/23.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#ifndef FWProperty_h
#define FWProperty_h


#pragma mark - property
//@prop
#if __has_feature(objc_arc)

#define	prop_readonly( type, name )	\
    property (nonatomic, readonly) type name;

#define	prop_dynamic( type, name ) \
    property (nonatomic, strong) type name;

#define	prop_assign( type, name ) \
    property (nonatomic, assign) type name;

#define	prop_strong( type, name ) \
    property (nonatomic, strong) type name;

#define	prop_weak( type, name )	\
    property (nonatomic, weak) type name;

#define	prop_copy( type, name )	\
    property (nonatomic, copy) type name;

#define	prop_unsafe( type, name ) \
    property (nonatomic, unsafe_unretained) type name;

#else

#define	prop_readonly( type, name )	\
    property (nonatomic, readonly) type name;

#define	prop_dynamic( type, name ) \
    property (nonatomic, retain) type name;

#define	prop_assign( type, name ) \
    property (nonatomic, assign) type name;

#define	prop_strong( type, name ) \
    property (nonatomic, retain) type name;

#define	prop_weak( type, name )	\
    property (nonatomic, assign) type name;

#define	prop_copy( type, name )	\
    property (nonatomic, copy) type name;

#define	prop_unsafe( type, name ) \
    property (nonatomic, assign) type name;

#endif

#pragma mark -
//@def_prop
#define def_prop_readonly( type, name ) \
    synthesize name = _##name;

#define def_prop_assign( type, name ) \
    synthesize name = _##name;

#define def_prop_strong( type, name ) \
    synthesize name = _##name;

#define def_prop_weak( type, name ) \
    synthesize name = _##name;

#define def_prop_unsafe( type, name ) \
    synthesize name = _##name;

#define def_prop_copy( type, name ) \
    synthesize name = _##name;

#define def_prop_dynamic( type, name ) \
    dynamic name;

#define def_prop_dynamic_copy( type, name, setName ) \
    def_prop_custom( type, name, setName, copy )

#define def_prop_dynamic_strong( type, name, setName ) \
    def_prop_custom( type, name, setName, retain )

#define def_prop_dynamic_unsafe( type, name, setName ) \
    def_prop_custom( type, name, setName, assign )

#define def_prop_dynamic_weak( type, name, setName ) \
    def_prop_custom( type, name, setName, assign )

#define def_prop_dynamic_pod( type, name, setName, pod_type ) \
    dynamic name; \
    - (type)name { return (type)[[self getAssociatedObjectForKey:#name] pod_type##Value]; } \
    - (void)setName:(type)obj { [self assignAssociatedObject:@((pod_type)obj) forKey:#name]; }

#define def_prop_custom( type, name, setName, attr ) \
    dynamic name; \
    - (type)name { return [self getAssociatedObjectForKey:#name]; } \
    - (void)setName:(type)obj { [self attr##AssociatedObject:obj forKey:#name]; }

#pragma mark -
//@static_property
#undef  static_property
#define static_property( __name ) \
    property (nonatomic, readonly) NSString * __name; \
    - (NSString *)__name; \
    + (NSString *)__name;

#undef	def_static_property
#define def_static_property( __name ) \
    dynamic __name; \
    - (NSString *)__name { return [[self class] __name]; } \
    + (NSString *)__name { return [NSString stringWithFormat:@"%s", #__name]; }

#undef	def_static_property2
#define def_static_property2( __name, prefix ) \
    dynamic __name; \
    - (NSString *)__name { return [[self class] __name]; } \
    + (NSString *)__name { return [NSString stringWithFormat:@"%@.%s", prefix, #__name]; }

#undef	def_static_property3
#define def_static_property3( __name, group, prefix ) \
    dynamic __name; \
    - (NSString *)__name { return [[self class] __name]; } \
    + (NSString *)__name { return [NSString stringWithFormat:@"%@.%@.%s", group, prefix, #__name]; }

#pragma mark -
//@static_type
#undef	static_integer
#define static_integer( __name ) \
    property (nonatomic, readonly) NSInteger __name; \
    - (NSInteger)__name; \
    + (NSInteger)__name;

#undef	def_static_integer
#define def_static_integer( __name, __value ) \
    dynamic __name; \
    - (NSInteger)__name { return [[self class] __name]; } \
    + (NSInteger)__name { return __value; }

#undef	static_number
#define static_number( __name ) \
    property (nonatomic, readonly) NSNumber * __name; \
    - (NSNumber *)__name; \
    + (NSNumber *)__name;

#undef	def_static_number
#define def_static_number( __name, __value ) \
    dynamic __name; \
    - (NSNumber *)__name { return [[self class] __name]; } \
    + (NSNumber *)__name { return @(__value); }

#undef	static_string
#define static_string( __name ) \
    property (nonatomic, readonly) NSString * __name; \
    - (NSString *)__name; \
    + (NSString *)__name;

#undef	def_static_string
#define def_static_string( __name, __value ) \
    dynamic __name; \
    - (NSString *)__name { return [[self class] __name]; } \
    + (NSString *)__name { return __value; }


#endif /* FWProperty_h */
