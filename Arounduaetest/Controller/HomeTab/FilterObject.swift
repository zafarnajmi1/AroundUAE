//
//  FilterObject.swift
//  Arounduaetest
//
//  Created by Apple on 6/13/19.
//  Copyright © 2019 MyComedy. All rights reserved.
//

import UIKit

class FilterObject: NSObject {
    
    var min : String? = ""
    var max : String? = ""
    var searchKeyword : String?
    var groupid: String?
    var divisionid: String?
    var sectionid: String?
    var manufactorid: String?
    var characteristicsid : String?
    var skip: Int?
    var Location: Array<Double>?
    var neartofar: Bool?
    
    
    static func filterParams() -> [String : Any]{
        
        let object = SharedData.sharedUserInfo.filter
        
        
        return [:]
    }
}

/* searchKeyword = txtfiledEnterKeyword.text!
 vc.groupid = self.testgroupid  //filterdata[self.groupIndex]._id ?? ""
 vc.divisionid = self.selectedDivision?._id ?? ""
 print(self.selectedDivision?._id!)
 vc.sectionid = self.selectedSection?._id ?? ""
 vc.manufactorid = selectedManufactorId ?? ""
 vc.characteristicsid = self.selectedCharacterticts ?? ""
 
 vc.min = min
 vc.max = max
 vc.skip = self.skip
 vc.totalPage = self.totalPage
 vc.Location = location
 vc.neartofar = neartofar*/
