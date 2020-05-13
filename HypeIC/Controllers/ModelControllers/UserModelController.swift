import Foundation
import CloudKit

class UserModelController {
    // MARK: _@shared instance
    static let shared = UserModelController()

    // MARK: _@source of truth
    var currentUser: User?

    // Public Database CKContainer
    let pubicDB = CKContainer.default().publicCloudDatabase

    // MARK: _@CRUD
        /**©------------------------------------------------------------------------------©*/

        // MARK: -CREATE Add method signatures
        func createUser(username: String, bio: String, completion: @escaping (Result<Bool, HypeError>) -> Void) {
            // - fetchAppleUserRef
            fetchAppleUserRef { [weak self] reference in
                // - fetching the user reference to use to create a new user
                guard let reference = reference else { return completion(.failure(.noUserFound)) }
                // - create new user with the users reference
                let newUser = User(username: username, bio: bio, appleUserRef: reference)
                // - record create the record to be saved from that new user
                let record = CKRecord(user: newUser)
                // - Save the newly created CKRecord
                self?.pubicDB.save(record) { (record, error) in
                    // - Handling error
                    if let error = error {
                        printf("\(error) -->> \(error.localizedDescription)")
                        return completion(.failure(.ckError(error)))
                    }
                    // - UnWrap saved record & insure we can init from that record
                    guard let record = record,
                          let saveUser = User(ckRecord: record) else { return completion(.failure(.couldNotUnwrap)) }
                    // - Set currentUser(Source of truth) to our saveUser
                    self?.currentUser = saveUser
                    // - Complete with success
                    completion(.success(true))
                }
            }
        }

        /// READ() if we have data to read
        func fetchUser(completion: @escaping (Result<Bool, HypeError>) -> Void) {

            fetchAppleUserRef { [weak self] reference in
                guard let reference = reference else { return completion(.failure(.noUserFound)) }
                // Define the predicate for the query
                let predicate = NSPredicate(format: "%K == %@", argumentArray: [UserKeys.AppleUserRefKey, reference])
                // - Define the query to perform
                let query = CKQuery(recordType: UserKeys.RecordTypeKey, predicate: predicate)
                // - Perform a query
                self?.pubicDB.perform(query, inZoneWith: nil) { records, error in
                    // handling error
                    if let error = error {
                        printf("\(error) -->> \(error.localizedDescription)")
                        return completion(.failure(.ckError(error)))
                    }
                    // - Get the first record from the returned records, & unwrap it. Then create a user from the record
                    guard let record = records?.first,
                          let foundUser = User(ckRecord: record) else  { return completion(.failure(.couldNotUnwrap)) }
                    // - Set currentUser(Source of truth) to our foundUser
                    self?.currentUser = foundUser
                    // - Complete with success
                    completion(.success(true))
                }
            }
        }

        // MARK: -UPDATE Add method signatures
        func updateUser(userToUpdate user: User) {
            // EXAMPLE: Object.foo = foo

        }

        // MARK: -DELETE Add method signatures
        func deleteUser(userToDelete user: User) {
            // You need to remove the object from your source of truth
            // You access it through your shared static instance singleton
            // from our MOC Use your subclassed NSManagedObject
        }
    /**©------------------------------------------------------------------------------©*/
    // MARK: -Helper func
    private func fetchAppleUserRef(completion: @escaping (CKRecord.Reference?) -> Void) {
        // - Access Users container and fetch their recordID
        CKContainer.default().fetchUserRecordID { recordID, error in
            // Handling error
            if let error = error {
                printf("\(error) -->> \(error.localizedDescription)")
                return completion(nil)
            }
            // UnWrap the returnID
            guard let recordID = recordID else { return completion(nil) }
            // - Create a CKRecord.Reference using the unwrapped recordID
            let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
            // - Complete with the reference
            completion(reference)
        }
    }
}
