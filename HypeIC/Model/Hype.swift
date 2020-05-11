import Foundation
import CloudKit

struct HypeStrs {
    static let recordTypeKey = "Hype"
    static let bodyKey = "body"
    static let timeStampKey = "timeStamp"

}

// MARK: _@class Hype
/**©------------------------------------------------------------------------------©*/
class Hype {
    var body: String
    var timeStamp: Date

    init(body: String, timeStamp: Date = Date()) {
        self.body = body
        self.timeStamp = timeStamp
    }
}/// END OF CLASS
/**©------------------------------------------------------------------------------©*/

// MARK: _@extension Hype
/**©------------------------------------------------------------------------------©*/
    extension Hype {
        // Failable init
        convenience init?(ckRecord: CKRecord) {
            guard let body = ckRecord[HypeStrs.bodyKey] as? String,
                  let timeStamp = ckRecord[HypeStrs.timeStampKey] as? Date else { return nil }

            self.init(body: body, timeStamp: timeStamp)
        }
    }
/**©------------------------------------------------------------------------------©*/

// MARK: _@extension CKRecord
/**©-------------------------------------------©*/
extension CKRecord {
    convenience init(hype: Hype) {
        self.init(recordType: HypeStrs.recordTypeKey)
        // Stores our props in a dictionary
        self.setValuesForKeys([
            HypeStrs.bodyKey : hype.body,
            HypeStrs.timeStampKey : hype.timeStamp
        ])
    }
}
/**©-------------------------------------------©*/
