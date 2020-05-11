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
        // MARK: _@saveHype
        // CREATE
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
        // MARK: _@
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
}/// END OF CLASS
