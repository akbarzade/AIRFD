//
//  UserDefaultsKeys.swift
//  IRAirport
//
//  Created by Akbarzade on 6/19/16.
//  Copyright © 2016 Akbarzade. All rights reserved.
//

import Foundation

let defaults = NSUserDefaults.standardUserDefaults()
extension DefaultsKeys{
	static let AppState = DefaultsKey<Int>("AppState")
		static let Airport = DefaultsKey<String>("Airport")
	static let TerminalType = DefaultsKey<String>("TerminalType")
	static let ChartId = DefaultsKey<String>("ChartId")
	
	//	static let SelectedChartAirport = DefaultsKey<String>("SelectedChartAirport")
	static let isAirportSelected = DefaultsKey<Bool>("isAirportSelected")
	static let DisplayedAirport = DefaultsKey<String>("DisplayedAirport")
	static let DisplayedTerminalChartAirport = DefaultsKey<String>("DisplayedTerminalChartAirport")
	static let SelectedAirport = DefaultsKey<String>("SelectedAirport")
	static let isTerminalChartSelected = DefaultsKey<Bool>("isTerminalChartSelected")
	static let TerminalChartsTogglingStatus = DefaultsKey<Bool>("TerminalChartsTogglingStatus")
	static let DisplayedTerminalChart = DefaultsKey<Int>("DisplayedTerminalChart")
	static let SelectedTerminalChart = DefaultsKey<Int>("SelectedTerminalChart")
	
	static let DisplayedChartId = DefaultsKey<String>("DisplayedChartId")
	static let isDisplayedTerminalChartLocationaled = DefaultsKey<Bool>("isDisplayedTerminalChartLocationaled")
	
	static let SelectedChartId = DefaultsKey<String>("SelectedChartId")
	
	static let DisplayedChartContentWidth = DefaultsKey<Double>("DisplayedChartContentWidth")
	static let DisplayedChartContentHeight = DefaultsKey<Double>("DisplayedChartContentHeight")
	static let DisplayedChartScaledContentWidth = DefaultsKey<Double>("DisplayedChartScaledContentWidth")
	static let DisplayedChartScaledContentHeight = DefaultsKey<Double>("DisplayedChartScaledContentHeight")
	static let DisplayedChartContentFrameWidth = DefaultsKey<Double>("DisplayedChartContentFrameWidth")
	static let DisplayedChartContentFrameHeight = DefaultsKey<Double>("DisplayedChartContentFrameHeight")
	static let DisplayedChartContentBoundsWidth = DefaultsKey<Double>("DisplayedChartContentBoundsWidth")
	static let DisplayedChartContentBoundsHeight = DefaultsKey<Double>("DisplayedChartContentBoundsHeight")
	
	static let DisplayedChartContentLatitudeTop = DefaultsKey<Double>("DisplayedChartContentLatitudeTop")
	static let DisplayedChartContentLatitudeButton = DefaultsKey<Double>("DisplayedChartContentLatitudeButton")
	static let DisplayedChartContentLongitudeLeft = DefaultsKey<Double>("DisplayedChartContentLongitudeLeft")
	static let DisplayedChartContentLongitudeRight = DefaultsKey<Double>("DisplayedChartContentLongitudeRight")
	
	
	//	static let CurrentLocationLatitude = DefaultsKey<Double>("CurrentLocationLatitude")
	//	static let CurrentLocationLongitude = DefaultsKey<Double>("CurrentLocationLongitude")
	
	
	//static let NAME = DefaultsKey<TYPE?>("")
	
}
