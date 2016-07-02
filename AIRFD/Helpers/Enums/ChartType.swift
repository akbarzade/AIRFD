//
//  ChartType.swift
//  IRAirport
//
//  Created by Akbarzade on 6/19/16.
//  Copyright © 2016 Akbarzade. All rights reserved.
//

import Foundation

enum ChartType : String {
	case REF = "REF"
	case STAR = "STAR"
	case APP = "APP"
	case TAXI = "TAXI"
	case SID = "SID"
	/**
	Converting the ChartType Type into the String value
	
	- Returns: A String value of the enum ChartType
	*/
	//	func stringValue() -> String {
	//		switch self {
	//		case .REF:
	//			return "REF"
	//		case .STAR:
	//			return "STAR"
	//		case .APP:
	//			return "APP"
	//		case .TAXI:
	//			return "TAXI"
	//		case .SID:
	//			return "SID"
	//		default:
	//			break
	//		}
	//	}
	func TypeOfHashValue(index: Int) -> ChartType {
		LogHandler.Log()
		switch index {
		case 0:
			return ChartType.REF
		case 1:
			return ChartType.STAR
		case 2:
			return ChartType.APP
		case 3:
			return ChartType.TAXI
		case 4:
			return ChartType.SID
		default:
			break
		}
		return ChartType.TAXI
	}
	func TypeOfRawValue(typeValue: String) -> ChartType {
		LogHandler.Log()
	var chartType: ChartType = ChartType.TAXI
		switch typeValue {
		case "REF":
			chartType = ChartType.REF
		case "STAR":
			chartType = ChartType.STAR
		case "APP":
			chartType = ChartType.APP
		case "TAXI":
			chartType = ChartType.TAXI
		case "SID":
			chartType = ChartType.SID
		default:
			break
		}
		return chartType
	}
	func fullTypeName() -> String {
		LogHandler.Log()
	switch self {
		case .REF:
			return "REFERENCE Charts"
		case .STAR:
			return "ARRIVALS Charts"
		case .APP:
			return "APPROACH Charts"
		case .TAXI:
			return "TAXI Charts"
		case .SID:
			return "DEPARTURES Charts"
		}
	}
}



func ValueForStringChartType(chartStringValue: String) -> ChartType {
	LogHandler.Log()
	var FoundedChartType = ChartType.REF
	switch chartStringValue {
	case "REF":
		FoundedChartType = ChartType.REF
	case "STAR":
		FoundedChartType = ChartType.STAR
	case "APP":
		FoundedChartType = ChartType.APP
	case "TAXI":
		FoundedChartType = ChartType.TAXI
	case "SID":
		FoundedChartType = ChartType.SID
	default:
		break
	}
	
	return FoundedChartType
}