//
//  LocationHandler.swift
//  IRAirport
//
//  Created by Akbarzade on 6/19/16.
//  Copyright © 2016 Akbarzade. All rights reserved.
//

import Foundation
import CoreLocation

struct UserLocation {
	static var Latitude: Double = Double()
	static var Longitude: Double = Double()
}

class LocationHandler {
	let airportService = AirportService()
	let chartService = ChartService()
	
	func SetUserLocation(ForLocationCoordinate Coordinate: CLLocationCoordinate2D) {
		LogHandler.Log()
		UserLocation.Latitude = Coordinate.latitude
		UserLocation.Longitude = Coordinate.longitude
	}
	
	
	/**
	IsInArea: Read CoreData to Import All the Charts available for Airport
	- parameter ChartId: Holding the Id of terminal chart that will be calculated on
	- returns: Bool value on return, if the location is in Chart return true , else return false
	
	- Precondition: No Condition
	- Postcondition: The result is 'equal' to 'true' or 'false'.
	- Requires: None
	- Note: None
	- SeeAlso: None
	- Warning: None
	- Throws: Cannot do the job if AirportICAO was incorrect.
	*/
	func IsInArea(onTerminalChart ChartId: String) -> Bool{
		LogHandler.Log()
		let chart = chartService.GetChart(ChartId)
		if(UserLocation.Latitude < Double(chart.chartInfo!.locationDegreeTopSide!) &&
			UserLocation.Latitude > Double(chart.chartInfo!.locationDegreeButtonSide!) &&
			UserLocation.Longitude < Double(chart.chartInfo!.locationDegreeRightSide!) &&
			UserLocation.Longitude > Double(chart.chartInfo!.locationDegreeLeftSide!) ){
			return true
		} else {
			return false
		}
	}
}