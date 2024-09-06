import SwiftUI
import CloudKit

// iCloud Setup Instructions:
// 1. Enable CloudKit in your project:
//    - Open your project in Xcode.
//    - Go to the project settings by selecting your project in the Project Navigator.
//    - Select your app target, then go to the "Signing & Capabilities" tab.
//    - Click the "+" button to add a capability.
//    - Select "iCloud" from the list.
//    - Check the "CloudKit" option under iCloud.
// 2. Create a CloudKit Container:
//    - Log in to the Apple Developer portal.
//    - Navigate to "Certificates, Identifiers & Profiles".
//    - Select "CloudKit Dashboard" under "Identifiers".
//    - Create a new container if you don't have one already. Use the same container identifier as in your Xcode project settings.
// 3. Set Up Record Types and Permissions in CloudKit Dashboard:
//    - In the CloudKit Dashboard, select your container.
//    - Go to the "Schema" tab.
//    - Ensure that your record type (`LogRecord`) and its fields are defined.
//    - Go to the "Permissions" tab.
//    - Under "Public Database", set the appropriate permissions for your record types. Ensure that the `LogRecord` record type has public read access.

// Testing Instructions:
// 1. Run your app on multiple devices or simulators with different iCloud accounts.
// 2. Save records from different users and verify that they are stored in the public database.
// 3. Fetch records and ensure that they include entries from multiple users.
//iCloud.com.billdonner.QandASentiments
struct LogRecord: Identifiable {
    let id: CKRecord.ID
    let message: String
    let timestamp: Date
    let userIdentifier: String
    let sentiment: String
    let predefinedFeeling: String
    let challengeIdentifier: String
}
@Observable
class CloudKitManager  {
    static let shared = CloudKitManager()
    private let container: CKContainer
    private let publicDatabase: CKDatabase
    
 var logRecords: [LogRecord] = []
  var errorMessage: String? = nil
    
    private init() {
        // Use the default container or specify your custom container identifier
        container = // CKContainer.default() // or
      CKContainer(identifier: "iCloud.com.billdonner.QandASentiments")
        publicDatabase = container.publicCloudDatabase
    }
    
    
  func saveLogRecord(message: String, sentiment: String, predefinedFeeling: String, timestamp: Date, challengeIdentifier: String, completion: @escaping (Result<CKRecord, Error>) -> Void) {
        container.fetchUserRecordID { [weak self] recordID, error in
            guard let self = self, let recordID = recordID, error == nil else {
                self?.errorMessage = error?.localizedDescription
                completion(.failure(error!))
                return
            }
            
            let record = CKRecord(recordType: "LogRecord")
            record["message"] = message as CKRecordValue
            record["timestamp"] = timestamp as CKRecordValue
            record["userIdentifier"] = recordID.recordName as CKRecordValue
            record["sentiment"] = sentiment as CKRecordValue
            record["predefinedFeeling"] = predefinedFeeling as CKRecordValue
            record["challengeIdentifier"] = challengeIdentifier as CKRecordValue
            
            self.publicDatabase.save(record) { savedRecord, error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    completion(.failure(error))
                } else if let savedRecord = savedRecord {
                    self.errorMessage = nil
                    completion(.success(savedRecord))
                }
            }
        }
    }
    
    func fetchLogRecords() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "LogRecord", predicate: predicate)
        
        publicDatabase.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                print("Error fetching records: \(error)")
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard let records = records else { return }
            
            DispatchQueue.main.async {
                self.logRecords = records.map { record in
                    LogRecord(id: record.recordID,
                              message: record["message"] as? String ?? "",
                              timestamp: record["timestamp"] as? Date ?? Date(),
                              userIdentifier: record["userIdentifier"] as? String ?? "",
                              sentiment: record["sentiment"] as? String ?? "",
                              predefinedFeeling: record["predefinedFeeling"] as? String ?? "",
                              challengeIdentifier: record["challengeIdentifier"] as? String ?? "")
                }
            }
        }
    }
}




struct FetcherView: View {
    @State  private var cloudKitManager = CloudKitManager.shared
    
    var body: some View {
        NavigationView {
            VStack {
       
                Button(action: {
                  cloudKitManager.fetchLogRecords()
                }) {
                    Text("Fetch All Log Records")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                
                List(cloudKitManager.logRecords) { record in
                    VStack(alignment: .leading) {
                        Text(record.message)
                            .font(.headline)
                        Text("\(record.timestamp)")
                            .font(.subheadline)
                      Text("\(record.challengeIdentifier)")
                          .font(.body)
                        Text("User: \(record.userIdentifier)")
                            .font(.footnote)
                        Text("Sentiment: \(record.sentiment)")
                            .font(.footnote)
                        Text("Feeling: \(record.predefinedFeeling)")
                            .font(.footnote)
                    }
                }
            }
            .navigationTitle("Sentiment Log")
        }
    }
}


