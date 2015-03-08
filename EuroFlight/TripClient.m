//
//  TripClient.m
//  EuroFlight
//
//  Created by Ken Szubzda on 3/7/15.
//  Copyright (c) 2015 OkStupid. All rights reserved.
//

#import "TripClient.h"
#import "Trip.h"

@implementation TripClient

+ (TripClient *)sharedInstance {
    static TripClient *instance = nil;
    
    if (instance == nil) {
        instance = [[TripClient alloc] init];
    }
    
    return instance;
}

- (void)tripsWithParams:(NSDictionary *)params completion:(void (^)(NSArray *trips, NSError *error))completion {
    NSArray *trips = [Trip tripsWithArray:[TripClient getSampleResponse][@"trips"][@"tripOption"]];
    completion(trips, nil);
}


+ (id)getSampleResponse {
    NSString *jsonString = @"{\
    \"kind\": \"qpxExpress#tripsSearch\",\
    \"trips\": {\
    \"kind\": \"qpxexpress#tripOptions\",\
    \"requestId\": \"l5Rqk4SPvPveOxqNY0LiH5\",\
    \"data\": {\
    \"kind\": \"qpxexpress#data\",\
    \"airport\": [\
    {\
    \"kind\": \"qpxexpress#airportData\",\
    \"code\": \"CDG\",\
    \"city\": \"PAR\",\
    \"name\": \"Paris Charles de Gaulle\"\
    },\
    {\
    \"kind\": \"qpxexpress#airportData\",\
    \"code\": \"LHR\",\
    \"city\": \"LON\",\
    \"name\": \"London Heathrow\"\
    }\
    ],\
    \"city\": [\
    {\
    \"kind\": \"qpxexpress#cityData\",\
    \"code\": \"LON\",\
    \"name\": \"London\"\
    },\
    {\
    \"kind\": \"qpxexpress#cityData\",\
    \"code\": \"PAR\",\
    \"name\": \"Paris\"\
    }\
    ],\
    \"aircraft\": [\
    {\
    \"kind\": \"qpxexpress#aircraftData\",\
    \"code\": \"320\",\
    \"name\": \"Airbus A320\"\
    }\
    ],\
    \"carrier\": [\
    {\
    \"kind\": \"qpxexpress#carrierData\",\
    \"code\": \"AF\",\
    \"name\": \"Air France\"\
    }\
    ]\
    },\
    \"tripOption\": [\
    {\
    \"kind\": \"qpxexpress#tripOption\",\
    \"saleTotal\": \"GBP189.11\",\
    \"id\": \"YG3ljufg6IUMwl1TxWalc5001\",\
    \"slice\": [\
    {\
    \"kind\": \"qpxexpress#sliceInfo\",\
    \"duration\": 75,\
    \"segment\": [\
    {\
    \"kind\": \"qpxexpress#segmentInfo\",\
    \"duration\": 75,\
    \"flight\": {\
    \"carrier\": \"AF\",\
    \"number\": \"1781\"\
    },\
    \"id\": \"GzYgYyKHNvpDB5ZB\",\
    \"leg\": [\
    {\
    \"kind\": \"qpxexpress#legInfo\",\
    \"id\": \"LpJzx3hLNJpo309w\",\
    \"aircraft\": \"320\",\
    \"arrivalTime\": \"2015-03-27T18:15+01:00\",\
    \"departureTime\": \"2015-03-27T16:00+00:00\",\
    \"origin\": \"LHR\",\
    \"destination\": \"CDG\",\
    \"originTerminal\": \"4\",\
    \"destinationTerminal\": \"2E\",\
    \"duration\": 75,\
    \"mileage\": 216,\
    \"meal\": \"Snack or Brunch\"\
    }\
    ]\
    }\
    ]\
    },\
    {\
    \"kind\": \"qpxexpress#sliceInfo\",\
    \"duration\": 75,\
    \"segment\": [\
    {\
    \"kind\": \"qpxexpress#segmentInfo\",\
    \"duration\": 75,\
    \"flight\": {\
    \"carrier\": \"AF\",\
    \"number\": \"1380\"\
    },\
    \"id\": \"GCV6ouHJH177kLX-\",\
    \"leg\": [\
    {\
    \"kind\": \"qpxexpress#legInfo\",\
    \"id\": \"Le2pEwWNMX6YGdAE\",\
    \"aircraft\": \"320\",\
    \"arrivalTime\": \"2015-03-29T20:30+01:00\",\
    \"departureTime\": \"2015-03-29T20:15+02:00\",\
    \"origin\": \"CDG\",\
    \"destination\": \"LHR\",\
    \"originTerminal\": \"2E\",\
    \"destinationTerminal\": \"4\",\
    \"duration\": 75,\
    \"mileage\": 216,\
    \"meal\": \"Meal\"\
    }\
    ]\
    }\
    ]\
    }\
    ],\
    \"pricing\": [\
    {\
    \"kind\": \"qpxexpress#pricingInfo\",\
    \"fare\": [\
    {\
    \"kind\": \"qpxexpress#fareInfo\",\
    \"id\": \"A4yM7xvjvQ3RqG2U+gJ9AFw7hA5wsS9r4KydSVW5CTuY\",\
    \"carrier\": \"AF\",\
    \"origin\": \"LON\",\
    \"destination\": \"PAR\",\
    \"basisCode\": \"KSRGB\"\
    },\
    {\
    \"kind\": \"qpxexpress#fareInfo\",\
    \"id\": \"AOPGovcSRMbYTL+0qOinh4yV3dbaz8dLmRiwiNmCvEws\",\
    \"carrier\": \"AF\",\
    \"origin\": \"PAR\",\
    \"destination\": \"LON\",\
    \"basisCode\": \"VSR6GB\"\
    }\
    ],\
    \"segmentPricing\": [\
    {\
    \"kind\": \"qpxexpress#segmentPricing\",\
    \"fareId\": \"A4yM7xvjvQ3RqG2U+gJ9AFw7hA5wsS9r4KydSVW5CTuY\",\
    \"segmentId\": \"GzYgYyKHNvpDB5ZB\"\
    },\
    {\
    \"kind\": \"qpxexpress#segmentPricing\",\
    \"fareId\": \"AOPGovcSRMbYTL+0qOinh4yV3dbaz8dLmRiwiNmCvEws\",\
    \"segmentId\": \"GCV6ouHJH177kLX-\"\
    }\
    ],\
    \"baseFareTotal\": \"GBP68.00\",\
    \"saleFareTotal\": \"GBP68.00\",\
    \"saleTaxTotal\": \"GBP121.11\",\
    \"saleTotal\": \"GBP189.11\",\
    \"passengers\": {\
    \"kind\": \"qpxexpress#passengerCounts\",\
    \"adultCount\": 1\
    },\
    \"fareCalculation\": \"LON AF PAR 101.79KSRGB AF LON 4.69VSR6GB NUC 106.48 END ROE 0.638555 FARE GBP 68.00 XT 13.00GB 30.11UB 12.50FR 0.80IZ 9.70QX 55.00YR\",\
    \"latestTicketingTime\": \"2015-03-10T23:59-05:00\",\
    \"ptc\": \"ADT\"\
    }\
    ]\
    }\
    ]\
    }\
    }";
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    return json;
}



@end
