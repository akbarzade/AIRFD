//
//  InterfaceManager.swift
//  IRAirport
//
//  Created by Akbarzade on 6/8/16.
//  Copyright © 2016 Akbarzade. All rights reserved.
//

import Foundation
import UIKit

struct UIManager {
	static var Airport: String! {
		didSet{
			print("InterfaceManager: Airport Seted \(Airport)")
		}
	}
	static var TerminalChartType: ChartType! {
		didSet{
			print("InterfaceManager: Terminal Chart Seted \(TerminalChartType.fullTypeName())")
		}
	}
	static var ChartId: String! {
		didSet{
			print("InterfaceManager: ChartId Seted \(ChartId)")
			
			print("InterfaceManager: TerminalChartSelectionNotificationKey")
			NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.TerminalChartSelectionNotificationKey, object: nil)
			
			print("InterfaceManager: ChartId StatusBarUpdateIndex")
			NSNotificationCenter.defaultCenter().postNotificationName(NotificationKey.StatusBarUpdateIndex, object: nil)
		}
	}
	static var NextChartId: String!
	static var PreviousChartId: String!
//	static var Charts: [String]!
	static var CheckedCharts: [String] = []
	static var TerminalCharts: [String] = []
//	
//	static func NextChart() -> String {
//		var	ChartIndex = InterfaceManager.CheckedCharts.indexOf(InterfaceManager.ChartId)
//		var NextChart: String = InterfaceManager.ChartId
//		if ChartIndex < InterfaceManager.CheckedCharts.count {
//			NextChart = InterfaceManager.CheckedCharts[ChartIndex! + 1]
//		}
//		return NextChart
//	}
//	
//	static func PreviousChart() -> String{
//		var ChartIndex = InterfaceManager.CheckedCharts.indexOf(InterfaceManager.ChartId)
//		var PreviousChart: String = InterfaceManager.ChartId
//		if ChartIndex > 0 {
//			PreviousChart = InterfaceManager.CheckedCharts[ChartIndex! - 1]
//		}
//		return PreviousChart
//	}
}

