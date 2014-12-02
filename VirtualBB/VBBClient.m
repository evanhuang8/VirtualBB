//
//  VBBClient.m
//  VirtualBB
//
//  Created by Evan Huang on 12/1/14.
//  Copyright (c) 2014 Washington University. All rights reserved.
//

#import "VBBClient.h"

@interface VBBClient()

@property (copy) NSString *token;

@end

@implementation VBBClient

- (id)initWithToken:(NSString *)token {
    self = [super init];
    self.token = token;
    return self;
}

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password {
    NSDictionary *response = [[NSDictionary alloc] initWithObjectsAndKeys:@"OK", "status", @"123", @"token", nil];
    NSInteger success = 0;
    @try {
        
        if([email isEqualToString:@""] || [password isEqualToString:@""] ) {
            [response setValue:@"Failed: Missing Parameter" forKey:@"status"];
            
        } else {
            //feel free to change the request data around to cater the server need.
            NSString *post =[[NSString alloc] initWithFormat:@"username=%@&password=%@",email, password];
            NSLog(@"PostData: %@",post);
            
            NSURL *url=[NSURL URLWithString:@"http://vbb.com/jsonlogin.php"];
            
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:url];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            //in case there is a certificate issue
            //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
            
            NSError *error = [[NSError alloc] init];
            NSHTTPURLResponse *response = nil;
            NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            NSLog(@"Response code: %ld", (long)[response statusCode]);
            
            if ([response statusCode] >= 200 && [response statusCode] < 300)
            {
                NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
                NSLog(@"Response ==> %@", responseData);
                NSError *error = nil;
                NSDictionary *jsonData = [NSJSONSerialization
                                          JSONObjectWithData:urlData
                                          options:NSJSONReadingMutableContainers
                                          error:&error];
                
                success = [jsonData[@"success"] integerValue];
                
                if(success == 1)
                {
                    NSLog(@"Login SUCCESS");
                    [response setValue:@"OK" forKey:@"status"];
                    NSString *token = [jsonData[@"token"] stringValue];
                    [response setValue:token forKey:@"token"];
                                                     
                } else {
                    
                    NSString *error_msg = (NSString *) jsonData[@"error_message"];
                    [response setValue:[@"Failed:" stringByAppendingString:error_msg] forKey:@"status"];
                }
                
            } else {
                [response setValue:@"Failed: Connection" forKey:@"status"];
            }
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
            [response setValue:@"Failed: Exception" forKey:@"status"];
    }
    
    

    if (self.delegate) {
        [self.delegate requestForType:VBBLogin withResponse:response];
    }
}

- (void)registerWithEmail:(NSString *)email andPassword:(NSString *)password {
    NSDictionary *response = [[NSDictionary alloc] initWithObjectsAndKeys:@"OK", "status", @"123", @"token", nil];
    if (self.delegate) {
        [self.delegate requestForType:VBBRegister withResponse:response];
    }
    
}

- (void)createSnapshotForTag:(NSString *)tag withImage:(NSData *)image {
    
}

- (void)retrieveSnapShotsForTag:(NSString *)tag {
    
}

- (void)getCommentsForSnapshot:(NSString *)snapshot {
    
}

@end
