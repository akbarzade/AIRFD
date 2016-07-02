//
//  ChartService.swift
//  IRAirport
//
//  Created by Akbarzade on 6/4/16.
//  Copyright © 2016 Akbarzade. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class ChartService {
	
	let airportService = AirportService()
	//	internal var fetchedResultController = NSFetchedResultsController()
	// #pragma mark - Core Data Helper
	lazy var coreDataStore: CoreDataStore = {
		let coreDataStore = CoreDataStore()
		return coreDataStore
	}()
	
	lazy var coreDataHelper: CoreDataHelper = {
		let coreDataHelper = CoreDataHelper()
		return coreDataHelper
	}()
	// #pragma mark - Demo
	var error: NSError? = nil
	
	
	//
	// MARK: - Initiate and Declratation's
	init() {
	}
	
	
	/**
	Inserting Method to import Airports List from passed JSON file.
	
	- parameters:
	- returns: NoReturn.
 */
	func insertJSONCharts(chartsFileURL: NSURL){
		LogHandler.Log()
	
		let data = NSData(contentsOfURL: chartsFileURL)
		do{
			
			
			let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
			
			let jsonArray = jsonResult.valueForKey("Chart") as! NSArray
			
			for chart in jsonArray{
				let chartEntity = NSEntityDescription.insertNewObjectForEntityForName(
					"Chart", inManagedObjectContext: self.coreDataHelper.backgroundContext!) as! Chart
				
				let airportICAO = chart["airportICAO"] as! String
				let chartType = chart["chartType"] as! String
				//let chartRunway = chart["chartRunway"] as! String
				let chartIndex = chart["chartIndex"] as! String
				let chartChecked = NSNumber(bool: chart["chartChecked"] as! Bool)
				let chartId: String = "\(airportICAO)|\(chartType)|\(chartIndex)|\(chartChecked)"
				let chartImageName = "\(airportICAO)\(chartType)\(chartIndex)"
				let chartImage = UIImage(named: chartImageName)
				let imageData = UIImagePNGRepresentation(chartImage!)
				
				
				/*
				"chartInfo": {
				"chartImageWidth": 530,
				"chartImageHeight": 900,
				"locationDegreeLeftSide": 0,
				"locationDegreeRightSide": 0,
				"locationDegreeTopSide": 0,
				"locationDegreeButtonSide": 0
				*/
				
				chartEntity.chartId = chartId as String
				chartEntity.airportICAO = airportICAO as String
				chartEntity.chartType = chartType as String
				chartEntity.chartIndex = chartIndex as String
				chartEntity.chartDescription = chart["chartDescription"] as!  String
				chartEntity.isLocational = NSNumber(bool: chart["isLocational"] as! Bool)
				chartEntity.chartChecked = chartChecked
				//chartEntity.chartImage = imageData
				chartEntity.timeStamp = NSDate()
				
				// MARK: - Fetching and Adding Airport to Chart From Available Airport on CoreData
				let airportsFetchRequest = NSFetchRequest(entityName: "Airport")
				let airports = (try self.coreDataHelper.backgroundContext!.executeFetchRequest(airportsFetchRequest)) as! [Airport]
				let airport = airports.filter({ (a: Airport) -> Bool in
					return a.airportICAO == airportICAO
				}).first
				
				chartEntity.airport = airport
				
				
				// MARK: - Fetching and Adding ChartContent to Chart From JSON
				let chartContentEntity = NSEntityDescription.insertNewObjectForEntityForName(
					"ChartContent", inManagedObjectContext: self.coreDataHelper.backgroundContext!) as! ChartContent
				
				
				chartContentEntity.chartImage  = imageData!
				//(chart["chartContent"] as! NSDictionary)["chartImage"] as? NSData
				
				chartEntity.chartContent = chartContentEntity
				
				
				// MARK: - Fetching and Adding ChartInfo to Chart From JSON
				let chartInfoEntity = NSEntityDescription.insertNewObjectForEntityForName(
					"ChartInfo", inManagedObjectContext: self.coreDataHelper.backgroundContext!) as! ChartInfo
				
				chartInfoEntity.chartRunway = (chart["chartInfo"] as! NSDictionary)["chartRunway"] as? String
				chartInfoEntity.chartImageWidth = (chart["chartInfo"] as! NSDictionary)["chartImageWidth"] as? NSNumber
				chartInfoEntity.chartImageHeight = (chart["chartInfo"] as! NSDictionary)["chartImageHeight"] as? NSNumber
				chartInfoEntity.locationDegreeLeftSide = (chart["chartInfo"] as! NSDictionary)["locationDegreeLeftSide"] as? NSNumber
				chartInfoEntity.locationDegreeRightSide = (chart["chartInfo"] as! NSDictionary)["locationDegreeRightSide"] as? NSNumber
				chartInfoEntity.locationDegreeTopSide = (chart["chartInfo"] as! NSDictionary)["locationDegreeTopSide"] as? NSNumber
				chartInfoEntity.locationDegreeButtonSide = (chart["chartInfo"] as! NSDictionary)["locationDegreeButtonSide"] as? NSNumber
				
				chartEntity.chartInfo = chartInfoEntity
				
			}
			coreDataHelper.saveContext()
			
		} catch {
			fatalError("Error in inserting Airports from JSON file.")
		}
		
		let chartRequest = NSFetchRequest(entityName: "Chart")
		let chartInfoRequest = NSFetchRequest(entityName: "ChartInfo")
		let chartContentRequest = NSFetchRequest(entityName: "ChartContent")
		
		let ChartCount = coreDataHelper.backgroundContext!.countForFetchRequest(chartRequest, error: NSErrorPointer.init())
		
		let ChartContentCount = coreDataHelper.managedObjectContext.countForFetchRequest(chartContentRequest, error: NSErrorPointer.init())
		
		let ChartInfoCount = coreDataHelper.managedObjectContext.countForFetchRequest(chartInfoRequest, error: NSErrorPointer.init())
		
		print("Total Charts: \(ChartCount) \nwith Total ChartContents: \(ChartContentCount) \nwith Total ChartInfos: \(ChartInfoCount)")
		
	}
	
	
	//
	// MARK: - READ
	func GetDefaultChartId(onAirportICAO airportICAO: String) -> String {
		LogHandler.Log()
		let GetDefaultChartIdFetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Chart")
		
		let airportPredicate  = NSPredicate(format:"airportICAO == %@", airportICAO)
		let chartTypePredicate  = NSPredicate(format:"chartType == %@" , "TAXI")
		GetDefaultChartIdFetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [airportPredicate , chartTypePredicate])
		
		let sorterIndex: NSSortDescriptor = NSSortDescriptor(key: "chartIndex" , ascending: true)
		GetDefaultChartIdFetchRequest.sortDescriptors = [sorterIndex]
		
		//GetDefaultChartIdFetchRequest.fetchLimit = 1
		
		//GetChartByIdFetchRequest.returnsObjectsAsFaults = false
		
		// TODO: - MUST Be handle for good performance
		
		var ChartResult: [Chart]!
		do {
			ChartResult = try self.coreDataHelper.managedObjectContext.executeFetchRequest(GetDefaultChartIdFetchRequest) as! [Chart]
		} catch let nserror1 as NSError{
			error = nserror1
		}
		return ChartResult.first!.chartId ?? ""
	}
	
	
	func ValidateChart(chartId: String) ->  Bool {
		LogHandler.Log()
		let GetChartByIdFetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Chart")
		GetChartByIdFetchRequest.predicate = NSPredicate(format:"chartId == %@", chartId)
		GetChartByIdFetchRequest.returnsObjectsAsFaults = false
		
		// TODO: - MUST Be handle for good performance
		
		var ChartResult: [AnyObject]?
		do {
			ChartResult = try self.coreDataHelper.managedObjectContext.executeFetchRequest(GetChartByIdFetchRequest)
		} catch let nserror1 as NSError{
			error = nserror1
			ChartResult = nil
		}
		if ChartResult?.count == 0 {
			return false
		} else {
			
			if let chart: Chart = ChartResult![0] as? Chart{
				if chart.chartId == chartId {
					return true
				}
			}
		}
		
		return false
	}
	
	func GetChart(chartId: String) -> Chart {
		LogHandler.Log()
	
				let ChartId: String = String(chartId.characters.dropLast())
		let GetChartByIdFetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Chart")
		GetChartByIdFetchRequest.predicate = NSPredicate(format:"chartId == %@", chartId)
//		GetChartByIdFetchRequest.predicate = NSPredicate(format:"chartId contains %@", ChartId)
//		GetChartByIdFetchRequest.returnsObjectsAsFaults = false
		
		// TODO: - MUST Be handle for good performance
		
		var ChartResult: [AnyObject]?
		do {
			ChartResult = try self.coreDataHelper.managedObjectContext.executeFetchRequest(GetChartByIdFetchRequest)
		} catch let nserror1 as NSError{
			error = nserror1
			ChartResult = nil
		}
		return ChartResult![0] as! Chart
	}
	
	func GetCharts(onAirportICAO AirportICAO: String) -> [Chart] {
		LogHandler.Log()
		var airportCharts: [Chart] = Array()
		
		airportCharts.appendContentsOf(GetTypeCharts(AirportICAO, chartType: ChartType.REF.rawValue))
		airportCharts.appendContentsOf(GetTypeCharts(AirportICAO, chartType: ChartType.STAR.rawValue))
		airportCharts.appendContentsOf(GetTypeCharts(AirportICAO, chartType: ChartType.APP.rawValue))
		airportCharts.appendContentsOf(GetTypeCharts(AirportICAO, chartType: ChartType.TAXI.rawValue))
		airportCharts.appendContentsOf(GetTypeCharts(AirportICAO, chartType: ChartType.SID.rawValue))
		
		return airportCharts
	}
	
	func GetAirportCharts(onAirportICAO DisplayedAirport: String) -> [Chart] {
		LogHandler.Log()
		let GetChartsFetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Chart")
		GetChartsFetchRequest.predicate = NSPredicate(format:"airportICAO == %@", DisplayedAirport)
		GetChartsFetchRequest.returnsObjectsAsFaults = false
		
		var ChartsResult: [AnyObject]?
		do {
			ChartsResult = try self.coreDataHelper.managedObjectContext.executeFetchRequest(GetChartsFetchRequest)
		} catch let nserror1 as NSError{
			error = nserror1
			ChartsResult = nil
		}
		
		var airportCharts = [Chart]()
		for ChartsResultItem in ChartsResult! {
			let approachChartItem = ChartsResultItem as! Chart
			print("All Charts : \(approachChartItem.chartIndex): \(approachChartItem.chartDescription) returned")
			airportCharts.append(approachChartItem)
		}
		return airportCharts
	}
	
	
	func ChartsCount() -> Int {
		LogHandler.Log()
		let ChartCountRequest = NSFetchRequest(entityName: "Chart")
		let chartCount = self.coreDataHelper.backgroundContext!.countForFetchRequest(ChartCountRequest, error: NSErrorPointer.init())
		return chartCount
	}
	
	func ChartsCountForAirport(forAirport airportICAO: String) -> Int {
		LogHandler.Log()
		let ChartCountRequest = NSFetchRequest(entityName: "Chart")
		
		let airportPredicate  = NSPredicate(format:"airportICAO == %@", airportICAO)
		ChartCountRequest.predicate = airportPredicate
		
		let chartCount = self.coreDataHelper.managedObjectContext.countForFetchRequest(ChartCountRequest, error: NSErrorPointer.init())
		return chartCount
	}
	
	func GetChartCountByType(forAirport airportICAO: String, forChartType chartType: String) -> Int{
		LogHandler.Log()
		let ChartCountRequest = NSFetchRequest(entityName: "Chart")
		
		let airportPredicate  = NSPredicate(format:"airportICAO == %@", airportICAO)
		let chartTypePredicate  = NSPredicate(format:"chartType == %@" , chartType)
		ChartCountRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [airportPredicate , chartTypePredicate])
		
		let chartCount = self.coreDataHelper.managedObjectContext.countForFetchRequest(ChartCountRequest, error: NSErrorPointer.init())
		return chartCount
	}
	
	func GetChartRunwayCountByType(forAirport ICAO: String, forChartType chartType: String ,forChartRunway Runway: String) -> Int {
		LogHandler.Log()
		let ChartCountRequest = NSFetchRequest(entityName: "Chart")
		
		let airportPredicate  = NSPredicate(format:"airportICAO == %@", ICAO)
		let chartTypePredicate  = NSPredicate(format:"chartType == %@" , chartType)
		let chartRunwayPredicate  = NSPredicate(format:"chartInfo.chartRunway == %@" , Runway)
		ChartCountRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [airportPredicate , chartTypePredicate, chartRunwayPredicate])
		
		
		let chartCount = self.coreDataHelper.managedObjectContext.countForFetchRequest(ChartCountRequest, error: NSErrorPointer.init())
		return chartCount
	}
	
	func GetTypeChartsId(ICAO: String ,chartType: ChartType) -> [String] {
		LogHandler.Log()
	let GetChartsChartFetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Chart")
		let airportPredicate	= NSPredicate(format:"airportICAO == %@", ICAO)
		let chartTypePredicate = NSPredicate(format:"chartType == %@" , chartType.rawValue)
		GetChartsChartFetchRequest.predicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: [ airportPredicate , chartTypePredicate ])
		let sorterRunway: NSSortDescriptor = NSSortDescriptor(key: "chartInfo.chartRunway" , ascending: true)
		let sorterIndex: NSSortDescriptor = NSSortDescriptor(key: "chartIndex" , ascending: true)
		GetChartsChartFetchRequest.sortDescriptors = [sorterRunway, sorterIndex]
		
		GetChartsChartFetchRequest.returnsObjectsAsFaults = false
		
		var ChartResult: [AnyObject]?
		do {
			ChartResult = try self.coreDataHelper.managedObjectContext.executeFetchRequest(GetChartsChartFetchRequest)
		} catch let nserror1 as NSError{
			error = nserror1
			ChartResult = nil
		}
		
		var CheckedCharts = [String]()
		for ChartResultItem in ChartResult! {
			let ChartItem = ChartResultItem as! Chart
			CheckedCharts.append(ChartItem.chartId)
		}
		return CheckedCharts
	}
	
	
	func GetCheckedTypeChartsId(ICAO: String ,chartType: ChartType) -> [String] {
		LogHandler.Log()
		let GetChartsChartFetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Chart")
		let airportPredicate	= NSPredicate(format:"airportICAO == %@", ICAO)
		let chartTypePredicate = NSPredicate(format:"chartType == %@" , chartType.rawValue)
		let chartCheckedPredicate = NSPredicate(format:"chartChecked == true")
		GetChartsChartFetchRequest.predicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: [ airportPredicate , chartTypePredicate , chartCheckedPredicate ])
		let sorterRunway: NSSortDescriptor = NSSortDescriptor(key: "chartInfo.chartRunway" , ascending: true)
		let sorterIndex: NSSortDescriptor = NSSortDescriptor(key: "chartIndex" , ascending: true)
		GetChartsChartFetchRequest.sortDescriptors = [sorterRunway, sorterIndex]
		
		GetChartsChartFetchRequest.returnsObjectsAsFaults = false
		
		var ChartResult: [AnyObject]?
		do {
			ChartResult = try self.coreDataHelper.managedObjectContext.executeFetchRequest(GetChartsChartFetchRequest)
		} catch let nserror1 as NSError{
			error = nserror1
			ChartResult = nil
		}
		
		var CheckedCharts = [String]()
		for ChartResultItem in ChartResult! {
			let ChartItem = ChartResultItem as! Chart
			CheckedCharts.append(ChartItem.chartId)
		}
		return CheckedCharts
	}
	
	
	func GetChartsCountByType(ICAO: String, ChartType: String) -> Int{
		LogHandler.Log()
		let ChartCountRequest = NSFetchRequest(entityName: "Chart")
		ChartCountRequest.predicate = NSPredicate(format:"airportICAO == %@ AND chartType == %@", ICAO, ChartType)
		
		let chartCount = self.coreDataHelper.managedObjectContext.countForFetchRequest(ChartCountRequest, error: NSErrorPointer.init())
		return chartCount
	}
	
	func GetCheckedChartsCountByType(ICAO: String, ChartType: String) -> Int{
		LogHandler.Log()
		let ChartCountRequest = NSFetchRequest(entityName: "Chart")
		ChartCountRequest.predicate = NSPredicate(format:"airportICAO == %@ AND chartType == %@ AND chartChecked == true", ICAO, ChartType)
		
		let chartCount = self.coreDataHelper.managedObjectContext.countForFetchRequest(ChartCountRequest, error: NSErrorPointer.init())
		return chartCount
	}
	
	
	func GetCheckedTypeCharts(ICAO: String , chartType: String) -> [Chart]{
		LogHandler.Log()
		let GetChartsChartFetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Chart")
		GetChartsChartFetchRequest.predicate = NSPredicate(format:"airportICAO == %@ AND chartType == %@ AND chartChecked == true", ICAO, chartType)
		let sorter: NSSortDescriptor = NSSortDescriptor(key: "airportICAO" , ascending: true)
		GetChartsChartFetchRequest.sortDescriptors = [sorter]
		GetChartsChartFetchRequest.returnsObjectsAsFaults = false
		
		var ChartResult: [AnyObject]?
		do {
			ChartResult = try self.coreDataHelper.managedObjectContext.executeFetchRequest(GetChartsChartFetchRequest)
		} catch let nserror1 as NSError{
			error = nserror1
			ChartResult = nil
		}
		
		var charts = [Chart]()
		for ChartResultItem in ChartResult! {
			let ChartItem = ChartResultItem as! Chart
			print("Chart [\(ChartItem.chartId)] Type: \(ChartItem.chartType) Index: \(ChartItem.chartIndex) Description: \(ChartItem.chartDescription) returned")
			charts.append(ChartItem)
		}
		return charts
	}
	
	//
	// MARK: - Sections
	/**
	Available Section's in ChartType as Runways
	
	- Parameter ICAO: Current Selected Airport ICAO as Strign
	- Parameter chartType: ChartType to fetch section's as StringValue
	- Return: An array of Strings
	*/
	func GetTypeCharts(ICAO: String , chartType: String) -> [Chart]{
		LogHandler.Log()
		let GetChartsFetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Chart")
		
		let airportPredicate  = NSPredicate(format:"airportICAO == %@", ICAO)
		let chartTypePredicate  = NSPredicate(format:"chartType == %@" , chartType)
		GetChartsFetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [airportPredicate , chartTypePredicate])
		
		let sorterRunway: NSSortDescriptor = NSSortDescriptor(key: "chartInfo.chartRunway" , ascending: true)
		let sorterIndex: NSSortDescriptor = NSSortDescriptor(key: "chartIndex" , ascending: true)
		GetChartsFetchRequest.sortDescriptors = [sorterRunway, sorterIndex]
		
		var ChartsResult: [AnyObject]?
		do {
			ChartsResult = try self.coreDataHelper.managedObjectContext.executeFetchRequest(GetChartsFetchRequest)
		} catch let nserror1 as NSError{
			error = nserror1
			ChartsResult = nil
		}
		
		var Charts = [Chart]()
		for chartsItem in ChartsResult! {
			let chart = chartsItem as! Chart
			Charts.append(chart)
		}
		
		return Charts
	}
	/**
	Available Section's in ChartType as Runways
	
	- Parameter ICAO: Current Selected Airport ICAO as Strign
	- Parameter chartType: ChartType to fetch section's as StringValue
	- Return: An array of Strings
	*/
	func GetTypeCharts(ICAO: String , chartType: ChartType) -> [Chart]{
		LogHandler.Log()
	let GetChartsFetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Chart")
		
		let airportPredicate  = NSPredicate(format:"airportICAO == %@", ICAO)
		let chartTypePredicate  = NSPredicate(format:"chartType == %@" , chartType.rawValue)
		GetChartsFetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [airportPredicate , chartTypePredicate])
		
		let sorterRunway: NSSortDescriptor = NSSortDescriptor(key: "chartInfo.chartRunway" , ascending: true)
		let sorterIndex: NSSortDescriptor = NSSortDescriptor(key: "chartIndex" , ascending: true)
		GetChartsFetchRequest.sortDescriptors = [sorterRunway, sorterIndex]
		
		var ChartsResult: [AnyObject]?
		do {
			ChartsResult = try self.coreDataHelper.managedObjectContext.executeFetchRequest(GetChartsFetchRequest)
		} catch let nserror1 as NSError{
			error = nserror1
			ChartsResult = nil
		}
		
		var Charts = [Chart]()
		for chartsItem in ChartsResult! {
			let chart = chartsItem as! Chart
			Charts.append(chart)
		}
		
		return Charts
	}
	
	func GetTypeCharts(ICAO: String , chartType: String, sectionName: String) -> [Chart]{
		LogHandler.Log()
	let GetChartsFetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Chart")
		
		let airportPredicate  = NSPredicate(format:"airportICAO == %@", ICAO)
		let chartTypePredicate  = NSPredicate(format:"chartType == %@" , chartType)
		let chartRunwayPredicate  = NSPredicate(format:"chartInfo.chartRunway == %@" , sectionName)
		GetChartsFetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [airportPredicate , chartTypePredicate ,chartRunwayPredicate])
		
		let sorterRunway: NSSortDescriptor = NSSortDescriptor(key: "chartInfo.chartRunway" , ascending: true)
		let sorterIndex: NSSortDescriptor = NSSortDescriptor(key: "chartIndex" , ascending: true)
		GetChartsFetchRequest.sortDescriptors = [sorterRunway, sorterIndex]
		
		var ChartsResult: [AnyObject]?
		do {
			ChartsResult = try self.coreDataHelper.managedObjectContext.executeFetchRequest(GetChartsFetchRequest)
		} catch let nserror1 as NSError{
			error = nserror1
			ChartsResult = nil
		}
		
		var Charts = [Chart]()
		for chartsItem in ChartsResult! {
			let chart = chartsItem as! Chart
			Charts.append(chart)
		}
		
		return Charts
	}
	
	func loadCharts(ICAO: String , chartType: String) -> [Chart] {
		LogHandler.Log()
	let GetChartsFetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Chart")
		
		
		let airportPredicate  = NSPredicate(format:"airportICAO == %@", ICAO)
		let chartTypePredicate  = NSPredicate(format:"chartType == %@" , chartType)
		GetChartsFetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [airportPredicate , chartTypePredicate])
		
		let sorterRunway: NSSortDescriptor = NSSortDescriptor(key: "chartRunway" , ascending: true)
		let sorterIndex: NSSortDescriptor = NSSortDescriptor(key: "chartIndex" , ascending: true)
		GetChartsFetchRequest.sortDescriptors = [sorterRunway, sorterIndex]
		GetChartsFetchRequest.returnsObjectsAsFaults = false
		
		var ChartsResult: [AnyObject]?
		do {
			ChartsResult = try self.coreDataHelper.managedObjectContext.executeFetchRequest(GetChartsFetchRequest)
		} catch let nserror1 as NSError{
			error = nserror1
			ChartsResult = nil
		}
		
		var airportCharts = [Chart]()
		for ChartsResultItem in ChartsResult! {
			let approachChartItem = ChartsResultItem as! Chart
			print("All Charts : \(approachChartItem.chartIndex): \(approachChartItem.chartDescription) returned")
			airportCharts.append(approachChartItem)
		}
		return airportCharts
	}
	
	
	
	//
	// MARK: - UPDATE
	
	func updateChartCheckStatus(onChartId chartId: String, setCheckStatusTo checkStatus: Bool){
		LogHandler.Log()
	let ChartEntity: Chart = GetChart(chartId)
		let chartId: String = "\(ChartEntity.airportICAO)|\(ChartEntity.chartType)|\(ChartEntity.chartIndex)|\(NSNumber(bool: checkStatus))"
		ChartEntity.chartId = chartId
		ChartEntity.chartChecked = checkStatus
		//		ChartEntity.setValue(checkStatus, forKey: "chartChecked")
		
		do {
			try ChartEntity.managedObjectContext?.save()
		} catch let nserror1 as NSError{
			error = nserror1
		}
	}
	
	//
	// MARK: - DELETE
	
	func DeleteChart(ICAO: String , chartType: String){
		LogHandler.Log()
		
	}
	
	func DeleteCharts(){
		LogHandler.Log()
		let fetchMyRequest: NSFetchRequest = NSFetchRequest(entityName: "Chart")
		var results: [AnyObject]?
		
		do {
			results = try self.coreDataHelper.backgroundContext!.executeFetchRequest(fetchMyRequest)
		} catch let nserror1 as NSError{
			error = nserror1
			results = nil
		} catch {
		}
		
		for resultItem in results! {
			let ChartItem = resultItem as! Chart
			self.coreDataHelper.backgroundContext!.deleteObject(ChartItem)
			print("\(ChartItem.chartDescription) with Index:\(ChartItem.chartIndex) on Airport: \(ChartItem.airportICAO) was Deleted!")
		}
		self.coreDataHelper.saveContext(self.coreDataHelper.backgroundContext!)
	}
	
}