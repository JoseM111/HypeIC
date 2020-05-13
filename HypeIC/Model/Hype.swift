import Foundation
import CloudKit

// MARK: _@struct HypeStrs Keys to dictionary
/**©------------------------------------------------------------------------------©*/
struct HypeStrs {
    static let recordTypeKey = "Hype"
    static let bodyKey = "body"
    static let timeStampKey = "timeStamp"
    static let userReferenceKey = "userReference"
    
}

// MARK: _@class Hype
/**©------------------------------------------------------------------------------©*/
class Hype {
    var body: String
    var timeStamp: Date
    var recordID: CKRecord.ID
    var userRef: CKRecord.Reference?

    init(body: String, timeStamp: Date = Date(), recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), userRef: CKRecord.Reference?) {
        self.body = body
        self.timeStamp = timeStamp
        self.recordID = recordID
        self.userRef = userRef
    }
}// END OF CLASS
/**©------------------------------------------------------------------------------©*/

// MARK: _@extension Hype
/**©------------------------------------------------------------------------------©*/
    extension Hype {
        // Failable init
        convenience init?(ckRecord: CKRecord) {
            guard let body = ckRecord[HypeStrs.bodyKey] as? String,
                  let timeStamp = ckRecord[HypeStrs.timeStampKey] as? Date else { return nil }
            let userRef = ckRecord[HypeStrs.userReferenceKey] as? CKRecord.Reference
            

            self.init(body: body, timeStamp: timeStamp, recordID: ckRecord.recordID, userRef: userRef)
        }
    }

extension Hype: Equatable {
    static func ==(lhs: Hype, rhs: Hype) -> Bool {
        lhs === rhs
    }
}
/**©------------------------------------------------------------------------------©*/

// MARK: _@extension CKRecord
/**©-------------------------------------------©*/
extension CKRecord {
    convenience init(hype: Hype) {
        self.init(recordType: HypeStrs.recordTypeKey, recordID: hype.recordID)
        // Stores our props in a dictionary
        self.setValuesForKeys([
            HypeStrs.bodyKey : hype.body,
            HypeStrs.timeStampKey : hype.timeStamp,
            HypeStrs.userReferenceKey : hype.userRef ?? <#default value#>
        ])
    }
}
/**©-------------------------------------------©*/
