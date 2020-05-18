import UIKit
import CloudKit

// TODO: Make Dictionary Keys
struct UserKeys {
    static let RecordTypeKey = "User"
    static let UsernameKey = "username"
    static let BioKey = "bio"
    static let AppleUserRefKey = "appleUserReference"
    static let photoAssetKey = "photoasset"
}

class User {
    // MARK: _@Class-Properties
    var username: String
    var bio: String
    var profilePhoto: UIImage? {
        get {
            guard let photoData = self.photoData else { return nil }
            return UIImage(data: photoData)
        }
        set {
            self.photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    // Anytime we set a profile photo, photoData gets updated
    var photoData: Data?
    
    // MARK: _@CloudKit-
    var recordID: CKRecord.ID
    var appleUserRef: CKRecord.Reference
    var photoAsset: CKAsset? {
        
        get {
            // Trying to properly get back an asset
                 let tempDir = NSTemporaryDirectory()
                 let TempDirURL = URL(fileURLWithPath: tempDir)
                 let fileURL = TempDirURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
                 
                 do {
                     try photoData?.write(to: fileURL)
                 } catch {
                    printf("\(error.localizedDescription) \(error) in function: \(#function)")
                 }
                 
                 return CKAsset(fileURL: fileURL)
        }
     
        
    }
    

    // MARK: _@init
    /**©------------------------------------------------------------------------------©*/
    init(username: String, bio: String = "", profilePhoto: UIImage? = nil, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserRef: CKRecord.Reference) {
        self.username = username
        self.bio = bio
        self.recordID = recordID
        self.appleUserRef = appleUserRef
        self.profilePhoto = profilePhoto
        
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
        
        var foundPhoto: UIImage?
        
        if let photoAsset = ckRecord[UserKeys.photoAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: photoAsset.fileURL!)
                foundPhoto = UIImage(data: data)
            } catch  {
                printf("\(error.localizedDescription) \(error) in function: \(#function)")

            }
        }

        self.init(username: username, bio: bio,  profilePhoto: foundPhoto,recordID: ckRecord.recordID, appleUserRef: appleUserRef)
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
            UserKeys.photoAssetKey : user.photoAsset as Any
        ])
    }
}
/**©------------------------------------------------------------------------------©*/
