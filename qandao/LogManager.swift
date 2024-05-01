//
//  ck.swift
//  cktest
//
//  Created by bill donner on 10/23/23.
//

import Foundation
/*
 To set up CloudKit for your project, you'll need to follow these steps:
 
 1. Enable CloudKit in your project:
 - Open your Xcode project and navigate to the project settings.
 - Select your target and go to the "Signing & Capabilities" tab.
 - Click on the "+ Capability" button.
 - Type "CloudKit" in the search bar and add it to your project.
 
 2. Create a CloudKit container:
 - Go to the Apple Developer website and sign in to your account.
 - Go to the "Certificates, Identifiers & Profiles" section.
 - Under the "Identifiers" tab, create a new identifier for your app.
 - Select the "App IDs" section and find your app identifier.
 - Click on the identifier and enable the "CloudKit" service.
 - Save your changes and ensure that the CloudKit container is created.
 
 3. Configure CloudKit in your app:
 - Open your Xcode project and go to the "Signing & Capabilities" tab.
 - Expand the "CloudKit" section and add the container identifier.
 - Save your changes.
 
 Now that CloudKit is set up, you can write the LogManager class:
 
 ```swift
 */

import CloudKit

public enum CloudLogEntryKind:Int,Codable {
  case thumbsUp,thumbsDown,loggedOn,loggedOff
}
fileprivate  struct CloudLogRec  : Codable,Identifiable {
  public let timestamp : Date
  public let id : String
  public let kind:  CloudLogEntryKind
  public let item: String  //this is json
}

public func sendLogJSON(kind:CloudLogEntryKind,item:String,lem:LogEntryManager) {
  let ler = CloudLogRec (timestamp: Date(), id: UUID().uuidString, kind:kind, item: item)
  lem.writeLogEntry (logEntry: ler) {error in
    if let error = error {
      print(">>> Log Manager -- \(error)")
      print(">>> You can safely ignore this iCloud error")
    }
  }
}
 func sendLoginMessage (_ logManager:LogEntryManager,loginID:String,source:GameDataSource) {
  // send a login record up to Cloudkit on a best efforts basis
  sendLogin(LoginRec(datetime: Date(), processname: ProcessInfo().processName, appbundleid: AppInfoProvider.appBundleID(), containerid: logManager.container, source:GameDataSource.string(for:source), initialUUID: loginID),lem: logManager)
}
public struct LoginRec : Codable {
  public init(datetime: Date, processname: String, appbundleid: String, containerid: String, source: String, initialUUID: String) {
    self.datetime = datetime
    self.processname = processname
    self.appbundleid = appbundleid
    self.containerid = containerid
    self.source = source
    self.initialUUID = initialUUID
  }
  
  let datetime:Date
  let processname:String
  let appbundleid:String
  let containerid:String
  let source:String
  let initialUUID:String
}
public struct LogoutRec : Codable {
  let datetime:Date
  let initialUUID:String
}
public func sendLogin(_ t:LoginRec,lem:LogEntryManager) {
  if let tt = try? JSONEncoder().encode(t) ,
     let item = String(data:tt,encoding:.utf8) {
    sendLogJSON(kind:.loggedOn,item:item,lem:lem)
  }
}
public func sendLogout(_ t:LogoutRec,lem:LogEntryManager) {
  if let tt = try? JSONEncoder().encode(t) ,
     let item = String(data:tt,encoding:.utf8) {
    sendLogJSON(kind:.loggedOff,item:item,lem:lem)
  }
}
public struct ThumbsUpRec : Codable {
  init(clever: Bool, tooeasy: Bool, toohard: Bool, mindbending: Bool, irrelevant: Bool, badexplanation: Bool, freeform: String) {
    self.clever = clever
    self.tooeasy = tooeasy
    self.toohard = toohard
    self.mindbending = mindbending
    self.irrelevant = irrelevant
    self.badexplanation = badexplanation
    self.freeform = freeform
  }
  
  let clever: Bool
  let tooeasy:Bool
  let toohard:Bool
  let mindbending:Bool
  let irrelevant:Bool
  let badexplanation:Bool
  let freeform:String
}

public struct ThumbsDownRec : Codable {
  init(clever: Bool, tooeasy: Bool, toohard: Bool, mindbending: Bool, irrelevant: Bool, badexplanation: Bool, freeform: String) {
    self.clever = clever
    self.tooeasy = tooeasy
    self.toohard = toohard
    self.mindbending = mindbending
    self.irrelevant = irrelevant
    self.badexplanation = badexplanation
    self.freeform = freeform
  }
  

  let clever: Bool
  let tooeasy:Bool
  let toohard:Bool
  let mindbending:Bool
  let irrelevant:Bool
  let badexplanation:Bool
  let freeform:String
}
public func sendThumbsDown(_ t:ThumbsDownRec,lem:LogEntryManager) {
  if let tt = try? JSONEncoder().encode(t) ,
     let item = String(data:tt,encoding:.utf8) {
    sendLogJSON(kind:.thumbsDown,item:item,lem:lem)
  }
}
public func sendThumbsUp(_ t:ThumbsUpRec,lem:LogEntryManager) {
  if let tt = try? JSONEncoder().encode(t) ,
     let item = String(data:tt,encoding:.utf8) {
    sendLogJSON(kind:.thumbsUp,item:item,lem:lem)
  }
}


// use via environmentobject requires LogEntryManager to conform to observableobject

public class LogEntryManager : ObservableObject {
  static var mock: LogEntryManager =  {
    LogEntryManager(container: "iCloud.com.billdonner.gentest",zone: "_defaultZone")
  }()
  internal init(container: String, zone: String) {
    self.container = container
    self.zone = zone
    self.logDatabase =  CKContainer(identifier: container).publicCloudDatabase
    self.zoneID =   CKRecordZone.ID(zoneName: zone, ownerName: CKCurrentUserDefaultName)
    print("============= CLOUDKIT INFO =============")
    print("time: \(Date())")
    print("process named: ",ProcessInfo().processName)
    print("app bundle id: ", AppInfoProvider.appBundleID())
    print("cloudkit container id: ",  container)
    print("zone: ",zone)
    print("=========================================")
  }
  
  var container:String
  var zone: String
  var logDatabase: CKDatabase
  var zoneID: CKRecordZone.ID
  
 
 fileprivate  func writeLogEntry(logEntry: CloudLogRec, completion: @escaping (Error?) -> Void) {
    let record = CKRecord(recordType: "LogEntry",
                          recordID: CKRecord.ID(recordName: logEntry.id, zoneID: zoneID))
    record["timestamp"] = logEntry.timestamp as CKRecordValue
    record["item"] = logEntry.item as CKRecordValue
    record["kind"] = logEntry.kind.rawValue as CKRecordValue
    
    logDatabase.save(record) { (record, error) in
      DispatchQueue.main.async {
        completion(error)
      }
    }
  }
  
//  func readAllRecordsInContainer(container: CKContainer) {
//    let database = container.publicCloudDatabase
//    let query = CKQuery(recordType: "LogEntry", predicate: NSPredicate(value: true))
//    let queryOperation = CKQueryOperation(query: query)
//    
//    queryOperation.recordMatchedBlock = { recordID, record in
//        // Process each record here
//        print(record)
//    }
//    
//    queryOperation.queryCompletionBlock = { cursor, error in
//        if let error = error {
//            print("Error querying records: \(error)")
//        } else {
//            if let cursor = cursor {
//                // There are more records to fetch, so call the function again recursively
//                let nextQueryOperation = CKQueryOperation(cursor: cursor)
//                nextQueryOperation.recordMatchedBlock = queryOperation.recordMatchedBlock
//                nextQueryOperation.queryCompletionBlock = queryOperation.queryCompletionBlock
//                database.add(nextQueryOperation)
//            } else {
//                // All records have been fetched
//                print("Finished reading all records")
//            }
//        }
//    }
//    
//    database.add(queryOperation)
//}
//
//  
//  func readAllRecords() {
//      let container = CKContainer.default()
//      let database = container.publicCloudDatabase
//
//      // Define the query to retrieve all records
//      let query = CKQuery(recordType: "YourRecordType", predicate: NSPredicate(value: true))
//      
//      // Create query operation
//      let operation = CKQueryOperation(query: query)
//      operation.resultsLimit = CKQueryOperation.maximumResults
//      operation.recordMatchedBlock = { recordID, record in
//          // Handle each matched record here
//          print("Matched record with ID: \(recordID)")
//      }
//      operation.queryCompletionBlock = { cursor, error in
//          if let error = error {
//              // Handle query completion error
//              print("Query completion error: \(error)")
//              return
//          }
//          
//          if let cursor = cursor {
//              // There are more records, so perform the query again with the cursor
//              let nextOperation = CKQueryOperation(cursor: cursor)
//              nextOperation.resultsLimit = CKQueryOperation.maximumResults
//              
//              // Recursive call to read the remaining records
//              self.readMoreRecords(operation: nextOperation)
//          } else {
//              // All records have been read
//              print("All records read successfully")
//          }
//      }
//      
//      // Start the query operation
//      database.add(operation)
//  }
fileprivate  func readLogEntries(completion: @escaping ([CloudLogRec]?, Error?) -> Void) {
    //let query:CKQuery = CKQuery(recordType: "LogEntry", predicate: NSPredicate(value: true))
/***
    logDatabase.perform(query, inZoneWith: zoneID) { (records, error) in
      if let error = error {
        DispatchQueue.main.async {
          completion(nil, error)
        }
        return
      }
      
      var logEntries: [LogEntry] = []
      
      for record in records ?? [] {
        if let timestamp = record["timestamp"] as? Date,
           let item = record["item"] as? String ,
           let kind = record["kind"] as? Int {
          let logEntry = LogEntry(timestamp: timestamp, id: record.recordID.recordName, kind: LogEntryKind(rawValue: kind) ?? .thumbsUp, item: item)
          logEntries.append(logEntry)
        }
      }
      
      DispatchQueue.main.async {
        completion(logEntries, nil)
      }
      
    }
 */
  }
  
}

/** cant get this to compile new style
 privateDatabase.fetch(withQuery:query,inZoneWith:zoneID,resultsLimit:100)
 { result in
 switch result {
 case .success(let matchResults,let queryCursor):
 var logEntries: [LogEntry] = []
 
 for record in matchResults ?? [] {
 if let timestamp = record["timestamp"] as? Date,
 let item = record["item"] as? String {
 let logEntry = LogEntry(timestamp: timestamp, id: record.recordID.recordName, item: item)
 logEntries.append(logEntry)
 }
 }
 
 DispatchQueue.main.async {
 completion(logEntries, nil)
 }
 case .failure(let error):
 DispatchQueue.main.async {
 completion(nil, error)
 }
 }
 }
 }
 }
 */
