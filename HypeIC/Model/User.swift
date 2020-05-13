import Foundation
import CloudKit

// TODO: Make Dictionary Keys
struct UserKeys {
    static let RecordTypeKey = "User"
    static let UsernameKey = "username"
    static let BioKey = "bio"
    static let AppleUserRefKey = "appleUserReference"
}

class User {
    // MARK: _@Properties
    var username: String
    var bio: String
    var recordID: CKRecord.ID
    var appleUserRef: CKRecord.Reference

    // MARK: _@init
    /**©------------------------------------------------------------------------------©*/
    init(username: String, bio: String, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserRef: CKRecord.Reference) {
        self.username = username
        self.bio = bio
        self.recordID = recordID
        self.appleUserRef = appleUserRef
    }
    /**©------------------------------------------------------------------------------©*/
}// END OF CLASS

// MARK: _@
/**©------------------------------------------------------------------------------©*/
 extension User {
     convenience init?(ckRecord: CKRecord) {
         guard let username = ckRecord[UserKeys.UsernameKey] as? String,
               let bio = ckRecord[UserKeys.BioKey] as? String,
               let appleUserRef = ckRecord[UserKeys.AppleUserRefKey] as? CKRecord.Reference
                 else { return nil }

         self.init(username: username, bio: bio, recordID: ckRecord.recordID, appleUserRef: appleUserRef)
     }
 }
/**©------------------------------------------------------------------------------©*/

// MARK: _@extension CKRecord
/**©------------------------------------------------------------------------------©*/
extension CKRecord {
    convenience init(user: User) {
        self.init(recordType: UserKeys.RecordTypeKey, recordID: user.recordID)

        setValuesForKeys([
            UserKeys.UsernameKey : user.username,
            UserKeys.BioKey : user.bio,
            UserKeys.AppleUserRefKey : user.appleUserRef,
        ])
    }
}
/**©------------------------------------------------------------------------------©*/
