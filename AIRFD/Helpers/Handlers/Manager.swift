//
//  Manager.swift
//  IRAirport
//
//  Created by Akbarzade on 6/8/16.
//  Copyright © 2016 Akbarzade. All rights reserved.
//

import Foundation
import UIKit


struct Manager {
	
	static var State: AppState! {
		willSet{
			print("Manager.State: State is \(State) and WillSet to \(newValue)")
		}
		didSet{
			print("Manager.State: Old value of State is  \(oldValue) and Now it's seted to \(State)")
			Defaults[.AppState] = State.rawValue
		}
	}
	
	static var AppStateValue: AppState {
		return State ?? AppState.Initiate
	}
	
	
	// MARK: - Airport
	static var AirportObject: Airport! {
		willSet {
		}
		didSet {
		}
	}
	
	static var AirportICAO: String! {
		willSet {
			print("Manager.Airport: Airport is \(AirportICAO) and WillSet to \(newValue)")
		}
		didSet{
			print("Manager.Airport: Old value of Airport is  \(oldValue) and Now it's seted to \(AirportICAO)")
			Defaults[.Airport] = AirportICAO
			
			NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.AirportSelectionNotificationKey, object: nil)
		}
	}
	
	// MARK: - TerminalChart
	static var TerminalChartsTogglingStatus: Bool! {
		willSet{
			print("Manager.TerminalChartsTogglingStatus: Status is \(TerminalChartsTogglingStatus) and WillSet to \(newValue)")
		}
		didSet{
			print("Manager.TerminalChartsTogglingStatus: Old value of Status is  \(oldValue) and Now it's seted to \(TerminalChartsTogglingStatus)")
			Defaults[.TerminalChartsTogglingStatus] = TerminalChartsTogglingStatus
		}
	}
	
	/**
	TerminalType Represented Current TerminalChartType
	
	- Note: Set it when Chart type button selected,
	- Note: Set it when the value of variable ChartId seted or changed by decoding ChartId value
	- Note: each time the value of TerminalType setedor changed it must send a notification to manage Circle Pointer to present the correct chart type on user interface.
	*/
	static var TerminalType: ChartType! {
		willSet {
			print("Manager.TerminalChartType: Airport is \(TerminalType) and WillSet to \(newValue)")
		}
		didSet{
			Defaults[.TerminalType] = TerminalType.rawValue
			
			print("Manager.TerminalChartType: Old value of Airport is  \(oldValue) and Now it's seted to \(TerminalType)")
			print("Manager: Terminal Chart Seted \(TerminalType.fullTypeName())")
		}
	}
	
	/// An Array of Chart Object with ChartType of 'REF'
	static var ChartObjects0: [Chart] = []
	
	/// An Array of Chart Object with ChartType of 'STAR'
	static var ChartObjects1: [Chart] = []
	
	/// An Array of Chart Object with ChartType of 'APP'
	static var ChartObjects2: [Chart] = []
	
	/// An Array of Chart Object with ChartType of 'TAXI'
	static var ChartObjects3: [Chart] = []
	
	/// An Array of Chart Object with ChartType of 'SID'
	static var ChartObjects4: [Chart] = []
	
	/// An Array Of Chart Objects to Hold All Chart for the current represented Airport
	static var TerminalCharts: [Chart] = []
	
	/// An Array of String to hold all the ChartId's of current represented Airport
	static var TerminalChartsId: [String] = []
	
	
	// MARK: - Chart
	/**
	Represented A Chart entity chartId properties as String value
	*/
	static var ChartObject: Chart!
	
	/**
	Represented A Chart entity 'Id' that selected or displayed right away
	*/
	static var ChartId: String! {
		willSet{
			print("Manager.ChartId: ChartId is \(ChartId) and WillSet to \(newValue)")
		}
		didSet{
			print("Manager.ChartId: Old value of ChartId is  \(oldValue) and Now it's seted to \(ChartId)")
			Defaults[.ChartId] = ChartId
			
			print("Manager.ChartId: TerminalChartSelectionNotificationKey")
			NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.TerminalChartSelectionNotificationKey, object: nil)
			
			print("Manager: ChartId StatusBarUpdateIndex")
			NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.StatusBarUpdateIndex, object: nil)
		}
	}
	
	//	static var UserLocationLatitude: Double = Double()
	//	static var UserLocationLongitude: Double = Double()
	
	static var NextChartId: String!
	static var PreviousChartId: String!
	static var CheckedCharts: [String] = []
	
	
	
	/**
	TypeOfChart: Find The Correct value of ChartType Enum for the ChartId
	- parameter ChartId: Holding the Id of terminal chart that will be calculated on
	- returns: Returning one of the cases in ChartType Enum
	
	- Precondition: No Condition
	- Postcondition: The result is 'equal' to 'ChartType.REF' or 'ChartType.STAR' or 'ChartType.APP' or 'ChartType.TAXI' or 'ChartType.SID'.
	- Requires: None
	- Note: None
	- SeeAlso: ChartType
	- Warning: None
	- Throws: Cannot do the job if chartId was incorrect.
	*/
	static func TypeOfChart(forChartId chartId: String) -> ChartType {
		LogHandler.Log()
		let chartType: String = (ChartId.componentsSeparatedByString("|"))[1]
		return ValueForStringChartType(chartType)
	}
}


struct currentCharts{
	//static var chartHelper = ChartHelper()
	static let chartService = ChartService()
	
	
	static var REF = [Chart]()
	static  var STAR = [Chart]()
	static  var APP = [Chart]()
	static  var TAXI = [Chart]()
	static  var SID = [Chart]()
	
	
	static var CurrentChartType: String = "REF"
	
	static var CurrentTypeChartsCount: Int = 0
	static var CurrentTypeVisibleChartsCount: Int = 0
	
	static var presentationIndexForCurrentChart: Int = 0
	static var NextVisibleChartIndex: Int = 0
	static var PreviousVisibleChartIndex: Int = 0
	static var CurrentChart: Chart!
	static var NextVisibleChart: AnyObject!
	static var PreviousVisibleChart: AnyObject!
	
	
	static var ChartBeforeCurrentChart: AnyObject!
	static var ChartAfterCurrentChart: AnyObject!
	
	
	static  func load(ref: [Chart], star: [Chart], app: [Chart] ,taxi: [Chart] ,sid: [Chart]) {
		LogHandler.Log()
		REF = ref
		STAR = star
		APP = app
		TAXI = taxi
		SID = sid
	}
	
	static func GetCurrentChartById(chartId: String){
		LogHandler.Log()
		
		currentCharts.CurrentChart = chartService.GetChart(chartId)
		print(currentCharts.CurrentChart.chartId)
		print(currentCharts.CurrentChart.chartIndex)
		print(currentCharts.CurrentChart.chartDescription)
		
		
	}
	//		static var airportCharts = (1:REF,2:STAR,3:APP,4:TAXI,5:SID)
	
	//static var airportCharts = (REF,STAR,APP,TAXI,SID)
	
	
	static func ReloadCharts()
	{
		LogHandler.Log()
		
	}
	
	static func GetSelectedChart(chartId: String) -> Chart
	{
		LogHandler.Log()
		
		let selectedChart: Chart =	chartService.GetChart(chartId)
		return selectedChart
	}
	
	static func printCharts() -> String{
		LogHandler.Log()
		var returnLog: String = ""
		
		returnLog += "\nREFs [\(REF.count)]:"
		for chart in REF{
			returnLog += "\n\t\(REF.indexOf(chart)!) : \(chart.chartChecked as Bool) : \(chart.chartIndex)"
		}
		
		returnLog += "\nSTARs [\(STAR.count)]:"
		for chart in STAR{
			returnLog += "\n\t\(STAR.indexOf(chart)!) : \(chart.chartChecked as Bool) : \(chart.chartIndex)"
		}
		
		returnLog += "\nAPPs [\(APP.count)]:"
		for chart in APP{
			returnLog += "\n\t\(APP.indexOf(chart)!) : \(chart.chartChecked as Bool) : \(chart.chartIndex)"
		}
		
		returnLog += "\nTAXIs [\(TAXI.count)]:"
		for chart in TAXI{
			returnLog += "\n\t\(TAXI.indexOf(chart)!) : \(chart.chartChecked as Bool) : \(chart.chartIndex)"
		}
		
		returnLog += "\nSIDs [\(SID.count)]:"
		for chart in SID{
			returnLog += "\n\t\(SID.indexOf(chart)!) : \(chart.chartChecked as Bool) : \(chart.chartIndex)"
		}
		
		return returnLog
	}
	static func printCheckedCharts() -> String{
		LogHandler.Log()
		var returnLog: String = ""
		
		returnLog += "\nREFs [\(REF.count)]:"
		for chart in REF{
			if chart.chartChecked as Bool{
				returnLog += "\n\t\(REF.indexOf(chart)!) : \(chart.chartChecked as Bool) : \(chart.chartIndex)"
			}
		}
		
		returnLog += "\nSTARs [\(STAR.count)]:"
		for chart in STAR{
			if chart.chartChecked as Bool{
				returnLog += "\n\t\(STAR.indexOf(chart)!) : \(chart.chartChecked as Bool) : \(chart.chartIndex)"
			}
		}
		
		returnLog += "\nAPPs [\(APP.count)]:"
		for chart in APP{
			if chart.chartChecked as Bool{
				returnLog += "\n\t\(APP.indexOf(chart)!) : \(chart.chartChecked as Bool) : \(chart.chartIndex)"
			}
		}
		
		returnLog += "\nTAXIs [\(TAXI.count)]:"
		for chart in TAXI{
			if chart.chartChecked as Bool{	returnLog += "\n\t\(TAXI.indexOf(chart)!) : \(chart.chartChecked as Bool) : \(chart.chartIndex)"
			}
		}
		
		returnLog += "\nSIDs [\(SID.count)]:"
		for chart in SID{
			if chart.chartChecked as Bool{returnLog += "\n\t\(SID.indexOf(chart)!) : \(chart.chartChecked as Bool) : \(chart.chartIndex)"
			}
		}
		
		return returnLog
	}
}
