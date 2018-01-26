//
//  Person+CoreDataProperties.m
//  CoreData
//
//  Created by user2 on 19.01.18.
//  Copyright © 2018 user2. All rights reserved.
//
//

#import "Person+CoreDataProperties.h"

@implementation Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Person"];
}

@dynamic surName;
@dynamic name;

@end
