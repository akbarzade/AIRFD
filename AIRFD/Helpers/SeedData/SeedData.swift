//
//  SeedData.swift
//  IRAirport
//
//  Created by Akbarzade on 6/4/16.
//  Copyright © 2016 Akbarzade. All rights reserved.
//

import Foundation
import CoreData



/**
This is a simple method to counting the Airport Objects

- Parameter entityToCount: Counting the entities
- Returns: Count of Airport's Entities
*/
func checkDataStore(entityToCount: String) -> Int{
	LogHandler.Log()
	let coreDataHelper = CoreDataHelper()
	let request = NSFetchRequest(entityName: entityToCount)
	let entityCount = coreDataHelper.managedObjectContext.countForFetchRequest(request, error: NSErrorPointer.init())
	print("Total \(entityToCount): \(entityCount)")
	return entityCount
}

/**

Checking the CoreData for Airport Entitie's
If DataStore Hasn't any Airport Object then reading the Special JSON File and import's all Airport available.

*/
func SeedAirports(){
	LogHandler.Log()
	let entity: String  = "Airport"
	if checkDataStore(entity) == 0 {
		let airportService = AirportService()
		let airportsFileURL = NSBundle.mainBundle().URLForResource("Airports", withExtension: "json")
		airportService.insertJSONAirports(airportsFileURL!)
	}
}

/**

Checking the CoreData for Chart Entitie's
If DataStore Hasn't any Chart Object then reading the Special JSON File and import's all Chart available.

*/
func SeedCharts(){
	LogHandler.Log()
	let entity: String  = "Chart"
	if checkDataStore(entity) == 0 {
		let chartsFileURL = NSBundle.mainBundle().URLForResource("OIII", withExtension: "json")
		let chartService = ChartService()
		
		chartService.insertJSONCharts(chartsFileURL!)
	}
}

func RemoveCoreDataEntities(){
	LogHandler.Log()
	let airportService = AirportService()
	let chartService = ChartService()
	chartService.DeleteCharts()
	airportService.DeleteAirports()
}


