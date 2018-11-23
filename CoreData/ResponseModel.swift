//
//  ResponseModel.swift
//  CoreDataDemo
//
//  Created by Apple on 15/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//


import Foundation
public enum leadStatus : String{
    case CLAIMED = "CLAIMED"
    case FRESH = "FRESH"
    case JUNK = "JUNK"
    case ARCHIVE = "ARCHIVE"
}

public class ResponseGetLeads : BaseResponseModel{
    public var id : Int?
    public var name : String?
    public var email : String?
    public var mobile : String?
    public var username : String?
    public var password : String?
    public var businessId : Int?
    
    public var leads : [ResponseLeads]?
    public var projects : [ResponseProjects]?
    public var adsChannel : [ResponseAdsChannel]?
    public var flatBudgetList : [String]?
    public var flatConfigList : [String]?
    public var possesionList : [String]?
    
    
}

public class ResponseAdsChannel : BaseResponseModel{
    public var businessId : Int?
    public  var channelType : String?
    public  var password : String?
    public  var id : Int?
    public  var webhookurl : String?
    public  var username : String?
    public  var name : String?
}

public class ResponseProjects : BaseResponseModel{
    public var id : Int?
    public  var name : String?
    public  var project_name : String? = ""
    public  var rera_number : String?
    public  var address1 : String?
    public  var address2 : String?
    public  var city : String?
    public  var state : String?
    public  var pin : Int?
    public  var country : String?
    public  var businessId : Int?
    public var documnets : [ResponseProjectDocs]?
}

public class ResponseProjectDocs : BaseResponseModel{
    public var id : Int?
    public var docName : String?
    public var docType : String?
    public var docURL : String?
    public var docDate : String?
}
public class ResponseLeads : BaseResponseModel{
    public var id : Int?
    public var name : String?
    public var channel : String?
    public var project : String?
    public var status : String?
    public var createdDate : String?
    public var updatedDate : String?
    public var sms : Bool?
    public var mail : Bool?
    public var mobile : String?
    public var email : String?
    public var address : String?
    public var configuration : String?
    public var budget : String?
    public var hotness : String?
    public var junkreason : String?
    public var interestText : String?
    public var projects_id : Int?
    public var salesPerson : Int?
    public var businessId : Int?
    public var channelId : Int?
    public var followUpConnector_id : Int?
    public var deleted : Bool?
    public var possession : String?
    public var projects : [ResponseProjects]?
}

public class ResponseUpdateLeadStatus : BaseResponseModel{
    public var id : Int?
}

public protocol BaseResponseModel:Decodable{
    //   var id:String?{get set}
    //    var created: Int?{get set}
    //    var modified: Int?{get set}
    //    var deleted: Bool?{get set}
    //    var updated: Bool?{get set}
    //    var companyId:String?{get set}
}
