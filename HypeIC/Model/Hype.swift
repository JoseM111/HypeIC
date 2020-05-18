import UIKit
import CloudKit

// MARK: _@struct HypeStrs Keys to dictionary
/**©------------------------------------------------------------------------------©*/
struct HypeStrs {
    static let recordTypeKey = "Hype"
    static let bodyKey = "body"
    static let timeStampKey = "timeStamp"
    static let userReferenceKey = "userReference"
    static let photoAssetKey = "photoAsset"
    
}

// MARK: _@class Hype
/**©------------------------------------------------------------------------------©*/
class Hype {
    var body: String
    var timeStamp: Date
    var hypePhoto: UIImage? {
        get {
            guard let photoData = self.photoData else { return nil }
            return UIImage(data: photoData)
        }
        set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    var photoData: Data?
    
    var recordID: CKRecord.ID
    var userRef: CKRecord.Reference?
    var photoAsset: CKAsset? {
        get {
            guard photoData != nil else { return nil }
            let tempDir = NSTemporaryDirectory()
            let tempDirURL = URL(fileURLWithPath: tempDir)
            let fileURL = tempDirURL.appendingPathComponent(UUID().uuidString).appendingPathComponent("jpg")
            
            do {
                try photoData?.write(to: fileURL)
            } catch  {
                printf(error)
            }
            return CKAsset(fileURL: fileURL)
        }
    }

    init(body: String, timeStamp: Date = Date(), hypePhoto: UIImage? = nil, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), userRef: CKRecord.Reference?) {
        self.body = body
        self.timeStamp = timeStamp
        self.recordID = recordID
        self.userRef = userRef
        self.hypePhoto = hypePhoto
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
            
            var foundPhoto: UIImage?
            if let photoAsset = ckRecord[HypeStrs.photoAssetKey] as? CKAsset {
                do {
                    let data = try Data(contentsOf: photoAsset.fileURL!)
                    foundPhoto = UIImage(data: data)
                } catch  {
                    printf(error)
                    printf(error.localizedDescription)
                }
            }

            self.init(body: body, timeStamp: timeStamp, hypePhoto: foundPhoto, recordID: ckRecord.recordID, userRef: userRef)
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
            HypeStrs.userReferenceKey : hype.userRef as Any,
            HypeStrs.photoAssetKey : hype.photoAsset as Any
        ])
    }
}
/**©-------------------------------------------©*/
