//
//  InterfaceHandler.swift
//  IRAirport
//
//  Created by Akbarzade on 6/4/16.
//  Copyright © 2016 Akbarzade. All rights reserved.
//

import Foundation
import UIKit

class InterfaceHandler : NSObject {
	let airportService = AirportService()
	let chartService = ChartService()
	
	override init(){
	}
	
	
	enum ChartPointerOriginY : Int{
		case REF = 190
		case STAR = 240
		case APP = 290
		case TAXI = 340
		case SID = 390
		case MINE = 440
	}
	
	/**
	fillCharts: Read CoreData to Import All the Charts available for Airport
	- parameter AirportICAO: Holding the Airport ICAO to filtering data based on it
	- returns: Void
	
	- Precondition: No Condition
	- Postcondition: The result is 'equal' to 'void'.
	- Requires: None
	- Note: None
	- SeeAlso: None
	- Warning: None
	- Throws: Cannot do the job if AirportICAO was incorrect.
	*/
	func loadTerminalCharts(){
		LogHandler.Log()
	loadAllTerminalChartObjects(onAirport: Manager.AirportICAO)
		loadTerminalChartsId(onAirport: Manager.AirportICAO)
	}
	
	func loadAllTerminalChartObjects(onAirport AirportICAO: String){
		LogHandler.Log()
	
		Manager.ChartObjects0 = chartService.GetTypeCharts(AirportICAO, chartType: ChartType.REF)
		Manager.ChartObjects1  = chartService.GetTypeCharts(AirportICAO, chartType: ChartType.STAR)
		Manager.ChartObjects2  = chartService.GetTypeCharts(AirportICAO, chartType: ChartType.APP)
		Manager.ChartObjects3  = chartService.GetTypeCharts(AirportICAO, chartType: ChartType.TAXI)
		Manager.ChartObjects4 = chartService.GetTypeCharts(AirportICAO, chartType: ChartType.SID)
		
		
		for chart in Manager.ChartObjects0 {
			let chartItem = chart
			print("ChartItem: \(chartItem.chartId)")
		}
		for chart in Manager.ChartObjects1 {
			let chartItem = chart
			print("ChartItem: \(chartItem.chartId)")
		}
		for section in AirportApproachChartRunways {
			let sectionItem = section
			print("ChartItem: \(sectionItem)")
		}
		for chart in Manager.ChartObjects2 {
			let chartItem = chart
			print("ChartItem: \(chartItem.chartId)")
		}
		for chart in Manager.ChartObjects3 {
			let chartItem = chart
			print("ChartItem: \(chartItem.chartId)")
		}
		for chart in Manager.ChartObjects4 {
			let chartItem = chart
			print("ChartItem: \(chartItem.chartId)")
		}
		
	}
	
	func loadTerminalChartsId(onAirport AirportICAO: String){
		LogHandler.Log()
	Manager.TerminalChartsId.removeAll()
		
		Manager.TerminalChartsId.appendContentsOf(chartService.GetTypeChartsId(AirportICAO, chartType: ChartType.REF))
		Manager.TerminalChartsId.appendContentsOf(chartService.GetTypeChartsId(AirportICAO, chartType: ChartType.STAR))
		Manager.TerminalChartsId.appendContentsOf(chartService.GetTypeChartsId(AirportICAO, chartType: ChartType.APP))
		Manager.TerminalChartsId.appendContentsOf(chartService.GetTypeChartsId(AirportICAO, chartType: ChartType.TAXI))
		Manager.TerminalChartsId.appendContentsOf(chartService.GetTypeChartsId(AirportICAO, chartType: ChartType.SID))
		print(Manager.TerminalChartsId.count)
		print(Manager.TerminalChartsId)
	}
	
	
	/**
	fillCheckedCharts: Read CoreData to Import All the Charts available for Airport
	- parameter REF: Array of String
	- parameter STAR: Array of String
	- parameter APP: Array of String
	- parameter TAXI: Array of String
	- parameter SID: Array of String
	- returns: Void
	
	- Precondition: No Condition
	- Postcondition: The result is 'equal' to 'void'.
	- Requires: None
	- Note: None
	- SeeAlso: None
	- Warning: None
	- Throws: Cannot do the job if AirportICAO was incorrect.
	*/
	func fillCheckedCharts(REF: [String], STAR: [String], APP: [String], TAXI: [String], SID: [String]) {
		LogHandler.Log()
		Manager.CheckedCharts.removeAll()
		
		Manager.CheckedCharts.appendContentsOf(REF)
		Manager.CheckedCharts.appendContentsOf(STAR)
		Manager.CheckedCharts.appendContentsOf(APP)
		Manager.CheckedCharts.appendContentsOf(TAXI)
		Manager.CheckedCharts.appendContentsOf(SID)
	}
	
	//	init(){
	//			if let ICAO = defaults.valueForKey("SelectedAirportICAO") {
	//		SelectedChartAirport = ICAO as! String
	//			} else {
	//				SelectedChartAirport = "OIII"
	//		}
	////
	//		if let chartType = 	defaults.valueForKey("SelectedChartType"){
	//			SelectedTerminalChart = ValueForStringChartType(chartType as! String)
	//		}
	
	//		DisplayedChartRunawy = "General"
	//		SelectedChartType = ChartType.REF
	//		DisplayedChartId = ""
	//		DisplayedChartIndex = ""
	//	}
	
	//	let mainView: MainViewController = MainViewController()
	
	//let chartHelper = ChartHelper()
	
	
	//var isAirportSelected: Bool = false
	//var isTerminalChartSelected: Bool = false
	//var TerminalChartsTogglingStatus: Bool = false
	
	/// Returned Current Selected Airport Entity
	var SelectedAirportEntity: Airport!
	
	/// Returned Current Displaying Airport ICAO Property
	//var DisplayedAirport: String!
	
	/// Returned Current Selected Airport ICAO Property
	//var SelectedAirport: String!
	var DisplayedTerminalChart: ChartType!
	/**
	Holding the current selected Terminal Chart Type
	- returns: ChartType for Selected Terminal Chart Type as ChartType
	*/
	var SelectedTerminalChart: ChartType!
	
	
	/**
	Holding the current selected Airport Runways for the Approach Chart
	- returns: An Array of strings represented the Runways of Selected Airport Approach Chart
	*/
	var AirportApproachChartRunways: [String] = []
	
	/// Returned Current Selected And Displayed Chart ChartId
	var SelectedChartId: String!
	
	/// Returned Current Selected Chart ICAO of Airport
	var SelectedChartAirport: String!
	
	
	
	/// Returned Current Selected Chart ChartType
	//var SelectedChartType: ChartType!
	
	/// Returned Current Selected Chart Chart Runway value in String
	var SelectedChartRunawy: String?
	
	/// Returned Current Selected Chart Index Property value in String
	var SelectedChartIndex: String?
	
	var CurrentAirportCheckedCharts = [[String]]()
	
	/// Returned Current Toggling Status of TerminalCharts TableView Controller as a Boolean Value
	var currentTogglingStatus : Bool = true
	
	
	func HandleAirportApproachRunways() -> [String]{
		LogHandler.Log()
		if SelectedTerminalChart == ChartType.APP{
//			AirportApproachChartRunways = SelectedAirportEntity.airportRunways!.componentsSeparatedByString("|")
			AirportApproachChartRunways = Manager.AirportObject.airportRunways!.componentsSeparatedByString("|")
			for section in AirportApproachChartRunways {
				print("Decoed Approach Chart Runway: \(section)")
			}
		}
		return AirportApproachChartRunways as [String]
	}
	
	
	func handleCurrentSelectedChart(forChartId chartId: String){
		LogHandler.Log()
		var splitedChartId: [String] = chartId.componentsSeparatedByString("|")
		SelectedChartAirport = splitedChartId[0]
		SelectedTerminalChart = ValueForStringChartType(splitedChartId[1])
		//		SelectedChartRunawy = splitedChartId[2]
		SelectedChartIndex = splitedChartId[2]
		print("Decoed chartId: \(SelectedChartId)  are Airport: \(SelectedChartAirport) ChartType: \(SelectedTerminalChart) ChartIndex: \(SelectedChartIndex)")
	}
	
	func NextChart() -> String{
		LogHandler.Log()
		
	var NextChartId: String = ""
		/*
		if var	ChartIndex: Int = Manager.TerminalChartsId.indexOf(Manager.ChartId) {
				while(ChartIndex < Manager.TerminalChartsId.count && NextChartId == ""){
					if Manager.TerminalChartsId[ChartIndex].characters.last == "1" {
						NextChartId = Manager.TerminalChartsId[ChartIndex]
						ChartIndex += 1
					}
			}
		}
		if NextChartId == "" {
			NextChartId = Manager.ChartId
		}
		Manager.NextChartId = NextChartId
*/
return NextChartId

	}
	
	func PreviousChart() -> String {
		LogHandler.Log()
	var PreviousChartId: String = ""
		/*
		if var	ChartIndex: Int = Manager.TerminalChartsId.indexOf(Manager.ChartId){
			if ChartIndex >= 0 {
				while(ChartIndex > 0 && PreviousChartId == ""){
					if Manager.TerminalChartsId[ChartIndex].characters.last == "1" {
						PreviousChartId = Manager.TerminalChartsId[ChartIndex]
						ChartIndex -= 1
					}
				}
			}
		}
		if PreviousChartId == "" {
			PreviousChartId = Manager.ChartId
		}
		Manager.PreviousChartId = PreviousChartId
		*/
		return PreviousChartId
	}
}