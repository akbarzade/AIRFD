//
//  ApplicationHandler.swift
//  IRAirport
//
//  Created by Akbarzade on 6/25/16.
//  Copyright © 2016 Akbarzade. All rights reserved.
//

import Foundation

class ApplicationHandler {
	func loadUserDefaults(){
		LogHandler.Log()
		let chartService = ChartService()
		Manager.State =	Defaults.hasKey("AppState") ? AppState(rawValue: Defaults[.AppState]) : AppState.Initiate
		Manager.AirportICAO = Defaults.hasKey("Airport") ?  Defaults[.Airport] : "OIII"
		Manager.ChartId = ValidateChartId()
		Manager.TerminalChartsTogglingStatus = true
		Manager.TerminalType = Defaults.hasKey("TerminalType")
			? ChartType(rawValue: Defaults[.TerminalType])
			: Manager.TypeOfChart(forChartId: Manager.ChartId)
		
		NSLog("AppDelegate Active: Manager. Airport is:\(Manager.AirportICAO) Defaults[.Airport]: \(Defaults[.Airport])")
		NSLog("AppDelegate Active: Manager. ChartId is:\(Manager.TerminalType) Defaults[.ChartId]: \(Defaults[.TerminalType])")
		NSLog("AppDelegate Active: Manager. ChartId is:\(Manager.ChartId) Defaults[.ChartId]: \(Defaults[.ChartId])")
	}
	
	func ValidateChartId() -> String{
		LogHandler.Log()
		let chartService = ChartService()
		var chartId: String = ""
		guard Defaults.hasKey("ChartId") == true else {
			
			chartId = chartService.GetDefaultChartId(onAirportICAO: Manager.AirportICAO)
//			chartId = chartService.GetTypeChartsId(Manager.AirportICAO, chartType: ChartType.TAXI).first!
			
			return chartId
		}
		
		if chartService.ValidateChart(Defaults[.ChartId]) {
			chartId =  Defaults[.ChartId]
		} else {
			chartId = chartService.GetDefaultChartId(onAirportICAO: Manager.AirportICAO)
		}
		
		
		return chartId
	}
	
	func SaveUserDefaults(){
		LogHandler.Log()
		
		//		Defaults[.AppState] = Manager.State.rawValue
		//		Defaults[.Airport] = Manager.AirportICAO
		//		Defaults[.TerminalType] = Manager.TerminalType.rawValue
		//		Defaults[.ChartId] = Manager.ChartId
		NSLog("AppDelegate Terminate: Manager. Airport is:\(Manager.AirportICAO) Defaults[.Airport]: \(Defaults[.Airport])")
		NSLog("AppDelegate Terminate: Manager. ChartId is:\(Manager.ChartId) Defaults[.ChartId]: \(Defaults[.ChartId])")
		
	}
	
	func ResetUserDefaults(){
		LogHandler.Log()
		Defaults.removeAll()
		Manager.State = AppState.Initiate
	}
}