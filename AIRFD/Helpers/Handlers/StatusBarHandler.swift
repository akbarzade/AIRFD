//
//  statusBarHandler.swift
//  IRAirport
//
//  Created by Akbarzade on 6/8/16.
//  Copyright © 2016 Akbarzade. All rights reserved.
//

import Foundation


class StatusBarHandler{
	let interfaceHandler = InterfaceHandler()
	var chartService = ChartService()
	var ChartsArray: [CheckedCharts] = []
	
	var TerminalChartIndex: Int!
	var ChartIndex: Int!
	
	func load(){
		LogHandler.Log()
	let Item0 = chartService.GetCheckedTypeChartsId(Manager.AirportICAO, chartType: ChartType.REF)
		let Item1 = chartService.GetCheckedTypeChartsId(Manager.AirportICAO, chartType: ChartType.STAR)
		let Item2 = chartService.GetCheckedTypeChartsId(Manager.AirportICAO, chartType: ChartType.APP)
		let Item3 = chartService.GetCheckedTypeChartsId(Manager.AirportICAO, chartType: ChartType.TAXI)
		let Item4 = chartService.GetCheckedTypeChartsId(Manager.AirportICAO, chartType: ChartType.SID)
		
		ChartsArray = [
			CheckedCharts(ChartsCount: Item0.count, CheckedCharts: Item0),
			CheckedCharts(ChartsCount: Item1.count, CheckedCharts: Item1),
			CheckedCharts(ChartsCount: Item2.count, CheckedCharts: Item2),
			CheckedCharts(ChartsCount: Item3.count, CheckedCharts: Item3),
			CheckedCharts(ChartsCount: Item4.count, CheckedCharts: Item4)
		]
		
		interfaceHandler.fillCheckedCharts(Item0, STAR: Item1, APP: Item2, TAXI: Item3, SID: Item4)
	}
	
	func updateSelectedChart(chartId: String) -> Int{
		LogHandler.Log()
		for index in 0...4 {
			if  ChartsArray[index].ChartsCount != 0 {
				let charts = ChartsArray[index].CheckedCharts
				let chartIndex = charts.indexOf(chartId)
				if chartIndex != nil {
					TerminalChartIndex = index
					ChartIndex = chartIndex!
					return ChartIndex
				}
			}
		}
		return -1
	}
	
}