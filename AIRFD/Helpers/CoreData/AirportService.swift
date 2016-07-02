//
//  AirportService.swift
//  IRAirport
//
//  Created by Akbarzade on 6/4/16.
//  Copyright © 2016 Akbarzade. All rights reserved.
//

import Foundation
import CoreData 


/**
This is a Class to handle Airport Entities on CoreData

- Function	newAirport:
- Function	insertAirport:
- Function	insertAirports:
*/
class AirportService {
	init() {
	}
	
	// MARK: - Core Data Helper
	lazy var coreDataStore: CoreDataStore = {
		let coreDataStore = CoreDataStore()
		return coreDataStore
	}()
	
	lazy var coreDataHelper: CoreDataHelper = {
		let coreDataHelper = CoreDataHelper()
		return coreDataHelper
	}()
	
	
	var error: NSError? = nil
	
	// CREATE
	/**
	Function newAirport to insert new Airport into the CoreData
	
	-	Parameter	airport: An AirportModel with the Airport Entity properties
	*/
	
	func newAirport(airport: Airport){
		let AirportEntity: Airport = NSEntityDescription.insertNewObjectForEntityForName(
			"Airport", inManagedObjectContext: coreDataHelper.backgroundContext!) as! Airport
		
		//    if !GetAirport(airport.airportICAO) {
		AirportEntity.airportICAO = airport.airportICAO
		AirportEntity.airportCountry = airport.airportCountry
		AirportEntity.airportCity = airport.airportCity
		AirportEntity.airportName = airport.airportName
		AirportEntity.airportIATA = airport.airportIATA
		AirportEntity.airportLocationLongitude = airport.airportLocationLongitude
		AirportEntity.airportLocationLatitude = airport.airportLocationLatitude
		AirportEntity.timeStamp = NSDate()
		//    }
		print("New Airport for \(AirportEntity.airportName) added with ICAO:\(AirportEntity.airportICAO)")
	}
	
	
	/// Same as insertJSONAirports function but throws error if there is a nil value on JSON data.
	func InsertAirport(airportsFileURL: NSURL) throws {
		let data = NSData(contentsOfURL: airportsFileURL)!
		do{
			
			let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
			
			let jsonArray = jsonResult.valueForKey("Airport") as! NSArray
			
			for airport in jsonArray{
				guard (airport["airportCountry"]) != nil else { throw AirportError.InvalidData("airportCountry Key fails")}
				guard (airport["airportICAO"]) != nil else { throw AirportError.InvalidData("airportICAO Key fails")}
				guard (airport["airportName"]) != nil else { throw AirportError.InvalidData("airportName Key fails")}
				guard (airport["airportCity"]) != nil else { throw AirportError.InvalidData("airportCity Key fails")}
				guard (airport["airportIATA"]) != nil else { throw AirportError.InvalidData("airportIATA Key fails")}
				guard (airport["airportRunways"]) != nil else { throw AirportError.InvalidData("airportRunways Key fails")}
				guard (airport["airportLocationLongitude"]) != nil else { throw AirportError.InvalidData("airportLocationLongitude Key fails")}
				guard (airport["airportLocationLatitude"]) != nil else { throw AirportError.InvalidData("airportLocationLatitude Key fails")}
				
				let airportEntity = NSEntityDescription.insertNewObjectForEntityForName(
					"Airport", inManagedObjectContext: self.coreDataHelper.backgroundContext!) as! Airport
				
				airportEntity.airportCountry = airport["airportCountry"] as! String
				airportEntity.airportICAO = airport["airportICAO"] as! String
				airportEntity.airportName = airport["airportName"] as! String
				airportEntity.airportCity = airport["airportCity"] as! String
				airportEntity.airportIATA = airport["airportIATA"] as? String
				airportEntity.airportRunways = airport["airportRunways"] as? String
				airportEntity.airportLocationLongitude = airport["airportLocationLongitude"] as! NSNumber
				airportEntity.airportLocationLatitude = airport["airportLocationLatitude"] as! NSNumber
				airportEntity.timeStamp = NSDate()
				
			}
			coreDataHelper.saveContext()
			
		} catch {
			fatalError("Error in inserting Airports from JSON file.")
		}
		
		let request = NSFetchRequest(entityName: "Airport")
		let AirportCount = coreDataHelper.managedObjectContext.countForFetchRequest(request, error: nil)
		print("Total inserted Airports are: \(AirportCount)")

	}
	
	func insertAirport(airport: Airport){
		newAirport(airport)
		coreDataHelper.saveContext(self.coreDataHelper.backgroundContext!)
		
	}
	
	func insertAirports(airports: [Airport]){
		for airportItem in airports {
			newAirport(airportItem)
		}
		coreDataHelper.saveContext(self.coreDataHelper.backgroundContext!)
		print("All New Airports are imported successfully.")
	}
	
	/**
	Inserting Method to import Airports List from passed JSON file.
	
	- parameter airportsFileURL: String Address of JSON file.
	
	- returns: NO RETURNS
	*/
	
	func insertJSONAirports(airportsFileURL: NSURL){
		let data = NSData(contentsOfURL: airportsFileURL)!
		do{

			let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
			
			let jsonArray = jsonResult.valueForKey("Airport") as! NSArray
			
			for airport in jsonArray{
				let airportEntity = NSEntityDescription.insertNewObjectForEntityForName(
					"Airport", inManagedObjectContext: self.coreDataHelper.backgroundContext!) as! Airport
				
				
				airportEntity.airportCountry = airport["airportCountry"] as! String
				airportEntity.airportICAO = airport["airportICAO"] as! String
				airportEntity.airportName = airport["airportName"] as! String
				airportEntity.airportCity = airport["airportCity"] as! String
				airportEntity.airportIATA = airport["airportIATA"] as? String
				airportEntity.airportRunways = airport["airportRunways"] as? String
				airportEntity.airportLocationLongitude = airport["airportLocationLongitude"] as! NSNumber
				airportEntity.airportLocationLatitude = airport["airportLocationLatitude"] as! NSNumber
				airportEntity.timeStamp = NSDate()
				
			}
			coreDataHelper.saveContext()
			
		} catch {
			fatalError("Error in inserting Airports from JSON file.")
		}
		
		let request = NSFetchRequest(entityName: "Airport")
		let AirportCount = coreDataHelper.managedObjectContext.countForFetchRequest(request, error: NSErrorPointer.init())
		print("Total Airports: \(AirportCount)")
	}
	
	//
	// MARK: -READ
	
	func GetAirport(airportICAO: String) -> Airport {
		var airport: Airport
		var airports: [Airport]
		let GetAirportFetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Airport")
		GetAirportFetchRequest.returnsObjectsAsFaults = false
		
		do {
			airports = try coreDataHelper.managedObjectContext.executeFetchRequest(GetAirportFetchRequest) as! [Airport]
			airport = airports.filter({(a: Airport) -> Bool in
				return a.airportICAO == airportICAO
			}).first!
			
		} catch {
			fatalError("Error on getting airport")
		}
		
		return airport
	}
	
	func GetAirports() -> [Airport] {
		let GetAirportsFetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Airport")
		
		let sorterCountry: NSSortDescriptor = NSSortDescriptor(key: "airportCountry" , ascending: true)
		let sorterICAO: NSSortDescriptor = NSSortDescriptor(key: "airportICAO" , ascending: true)
		GetAirportsFetchRequest.sortDescriptors = [sorterCountry , sorterICAO]
		GetAirportsFetchRequest.returnsObjectsAsFaults = false
		
		var airportsResult: [AnyObject]?
		do {
			airportsResult = try self.coreDataHelper.managedObjectContext.executeFetchRequest(GetAirportsFetchRequest)
		} catch let nserror1 as NSError{
			error = nserror1
			airportsResult = nil
		}catch{
			
		}
		
		var airports = [Airport]()
		for resultAirportItem in airportsResult! {
			let airportItem = resultAirportItem as! Airport
			airports.append(airportItem)
		}
		return airports
	}
	
	func AirportsCount() -> Int {
		let AirportsCountRequest = NSFetchRequest(entityName: "Airport")
		let airportsCount = self.coreDataHelper.managedObjectContext.countForFetchRequest(AirportsCountRequest, error: NSErrorPointer.init())
		return airportsCount
	}
	
	func AirportsCount(forCountry CountryName: String) -> Int {
		let CountryAirportsCountRequest = NSFetchRequest(entityName: "Airport")
		let countryPredicate  = NSPredicate(format:"airportCountry == %@", CountryName)
		CountryAirportsCountRequest.predicate = countryPredicate

		
		let countryAirportsCount = self.coreDataHelper.managedObjectContext.countForFetchRequest(CountryAirportsCountRequest, error: NSErrorPointer.init())
		return countryAirportsCount
	}
	
	//
	// MARK: -DELETE
	
	func DeleteAirport(ICAO: String){
		
	}
	
	func DeleteAirports()
	{
		let fetchMyRequest: NSFetchRequest = NSFetchRequest(entityName: "Airport")
		var results: [AnyObject]?
		
		do {
			results = try self.coreDataHelper.backgroundContext!.executeFetchRequest(fetchMyRequest)
		} catch let nserror1 as NSError{
			error = nserror1
			results = nil
		} catch {
		}
		
		for resultItem in results! {
			let airportItem = resultItem as! Airport
			self.coreDataHelper.backgroundContext!.deleteObject(airportItem)
			print("\(airportItem.airportName) with ICAO:\(airportItem.airportICAO) was Deleted!")
		}
		self.coreDataHelper.saveContext(self.coreDataHelper.backgroundContext!)
	}
}