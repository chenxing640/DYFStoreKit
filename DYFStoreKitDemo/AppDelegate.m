//
//  AppDelegate.m
//
//  Created by Tenfay on 2014/11/4. ( https://github.com/itenfay/DYFStoreKit )
//  Copyright © 2014 Tenfay. All rights reserved.
//

#import "AppDelegate.h"
#import "SKIAPManager.h"

@interface AppDelegate () <DYFStoreAppStorePaymentDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self displayStartupPage];
    [self initIAPSDK];
    
    return YES;
}

- (void)displayStartupPage
{
    [NSThread sleepForTimeInterval:2.0];
}

- (void)initIAPSDK
{
    [SKIAPManager.shared addStoreObserver];
    
    // Adds an observer that responds to updated transactions to the payment queue.
    // If an application quits when transactions are still being processed, those transactions are not lost. The next time the application launches, the payment queue will resume processing the transactions. Your application should always expect to be notified of completed transactions.
    // If more than one transaction observer is attached to the payment queue, no guarantees are made as to the order they will be called in. It is recommended that you use a single observer to process and finish the transaction.
    [DYFStore.defaultStore addPaymentTransactionObserver];
    
    // Sets the delegate processes the purchase which was initiated by user from the App Store.
    DYFStore.defaultStore.delegate = self;
}

// Processes the purchase which was initiated by user from the App Store.
- (void)didReceiveAppStorePurchaseRequest:(SKPaymentQueue *)queue payment:(SKPayment *)payment forProduct:(SKProduct *)product
{
    if (![DYFStore canMakePayments]) {
        [self sk_showTipsMessage:@"Your device is not able or allowed to make payments!"];
        return;
    }
    
    // Get account name from your own user system.
    NSString *accountName = @"Handsome Jon";
    // This algorithm is negotiated with server developer.
    NSString *userIdentifier = DYFCryptoSHA256(accountName);
    DYFStoreLog(@"userIdentifier: %@", userIdentifier);
    
    [SKIAPManager.shared addPayment:product.productIdentifier userIdentifier:userIdentifier];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [SKIAPManager.shared removeStoreObserver];
    [DYFStore.defaultStore removePaymentTransactionObserver];
}

@end
