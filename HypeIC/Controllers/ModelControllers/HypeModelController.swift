import Foundation
import CloudKit

class HypeModelController {

    // MARK: _@Shared-instance
    static let shared = HypeModelController()

    // MARK: _@Source of truth
    var hypeList: [Hype] = []

    let publicDB = CKContainer.default().publicCloudDatabase

        // MARK: _@Methods
        /**©------------------------------------------------------------------------------©*/
        // CREATE

        // MARK: _@saveHype
        func saveHype(with text: String, completion: @escaping (Result<Hype?, HypeError>) -> Void) {

            // 1> Create a new Hype
            let newHype = Hype(body: text)// Date has a default = Date()
            // 2> Create a new CKRecord
            let hypeRecord = CKRecord(hype: newHype)

            publicDB.save(hypeRecord) { (record, error) in
                // 3> Handling error
                if let error = error {
                    return completion(.failure(.ckError(error)))
                }

                // 4> Unwrap our record to check for nil
                guard let record = record,
                        let savedHype = Hype(ckRecord: record)
                        else { return completion(.failure(.couldNotUnwrap)) }

                // 5> If that does work
                printf("Saved Hype Successfully...")
                completion(.success(savedHype))
            }
        }/// END OF FUNC
        /**©------------------------------------------------------------------------------©*/
        // MARK: _@fetchAllHypes
        func fetchAllHypes(completion: @escaping (Result<[Hype]?, HypeError>) -> Void) {
            // Build a predicate
            let fetchAllHypePredicates = NSPredicate(value: true)// Fetch all types
            // Build out our query:--? query all queries of type hype
            let query = CKQuery(recordType: HypeStrs.recordTypeKey, predicate: fetchAllHypePredicates)

            // Searches the specified zone asynchronously for records that match the query parameters.
            publicDB.perform(query, inZoneWith: nil) { (records, error) in
                // 4> Handling error
                if let error = error {
                    return completion(.failure(.ckError(error)))
                }

                guard let records = records else { return completion(.failure(.couldNotUnwrap)) }
                printf("Fetched all hypes successfully...")
                // It is throwing away all the nils for you
                let hypes = records.compactMap { Hype(ckRecord: $0)  }

                completion(.success(hypes))
            }
        }/// END OF FUNC
        /**©------------------------------------------------------------------------------©*/
    
    // MARK: _@Update
    func updateHype(_ hype: Hype, completion: @escaping (Result<Hype?, HypeError>) -> Void) {
        // Get access to a record
        let record = CKRecord(hype: hype)

        // Build operation
        let operation = CKModifyRecordsOperation(recordsToSave: [record])
        // Properties & behaviors for our operation
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive// sort of like tableView.reloadData on the main thread
        operation.modifyRecordsCompletionBlock = { ( records, _, error ) in
            // Handling our error
            if let error = error {
                return completion(.failure(.ckError(error)))
            }

            // Unwrap our record
            guard let record = records?.first,
                  let updateHype = Hype(ckRecord: record)
                    else { return completion(.failure(.couldNotUnwrap)) }

            printf("Updated \(record.recordID) successfully in cloudkit")
            completion(.success(updateHype))
        }
        // Access our database
        publicDB.add(operation)
    }

    // MARK: _@Delete
    /**©-------------------------------------------©*/
    func deleteHype(_ hype: Hype, completion: @escaping (Result<Bool, HypeError>) -> Void) {

        let operation = CKModifyRecordsOperation(recordIDsToDelete: [hype.recordID])
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { ( record, _, error ) in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }

            if record?.count == 0 {
                printf("Successfully deleted record from cloudkit")
                completion(.success(true))
            } else {
                return completion(.failure(.unexpectedRecordsFound))
            }

        }

        publicDB.add(operation)
    }
    /**©-------------------------------------------©*/

    // MARK: Subscription method
    func subscribeToRemoteNotifications(completion : @escaping (Error?) -> Void) {

        let hypeSubPredicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: HypeStrs.recordTypeKey, predicate: hypeSubPredicate, options: [.firesOnRecordCreation, .firesOnRecordUpdate] )

        let notificationInfo = CKQuerySubscription.NotificationInfo()
        notificationInfo.title = "Alias the GREAT!!!"
        notificationInfo.alertBody = "I got you stuck off the realness"
        notificationInfo.shouldBadge = true
        notificationInfo.soundName = "default"
        subscription.notificationInfo = notificationInfo

        publicDB.save(subscription) { (_, error) in
            if let error = error {
                completion(error)
            }
            completion(nil)
        }`
    }
}/// END OF CLASS
