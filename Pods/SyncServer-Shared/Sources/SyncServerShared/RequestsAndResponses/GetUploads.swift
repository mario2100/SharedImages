//
//  GetUploads.swift
//  Server
//
//  Created by Christopher Prince on 2/18/17.
//
//

import Foundation
import Gloss

#if SERVER
import Kitura
#endif

// Request an index of file uploads (UploadFile) and upload deletions (UploadDeleletion) -- queries the meta data on the sync server. The uploads are specific both to the user and the deviceUUID of the user.

public class GetUploadsRequest : NSObject, RequestMessage {
    // MARK: Properties for use in request message.

    public var sharingGroupUUID: String!

    public func nonNilKeys() -> [String] {
        return [ServerEndpoint.sharingGroupUUIDKey]
    }
    
    public func allKeys() -> [String] {
        return self.nonNilKeys()
    }
    
    public required init?(json: JSON) {
        super.init()
        
        self.sharingGroupUUID = ServerEndpoint.sharingGroupUUIDKey <~~ json
        
#if SERVER
        if !nonNilKeysHaveValues(in: json) {
            return nil
        }
#endif
    }
    
#if SERVER
    public required convenience init?(request: RouterRequest) {
        self.init(json: request.queryParameters)
    }
#endif

    public func toJSON() -> JSON? {
        return jsonify([
            ServerEndpoint.sharingGroupUUIDKey ~~> self.sharingGroupUUID
        ])
    }
}

public class GetUploadsResponse : ResponseMessage {
    public var responseType: ResponseType {
        return .json
    }
    
    // FileInfo objects don't contain `cloudStorageType`.
    public static let uploadsKey = "uploads"
    public var uploads:[FileInfo]?
    
    public required init?(json: JSON) {
        self.uploads = GetUploadsResponse.uploadsKey <~~ json
    }
    
    public convenience init?() {
        self.init(json:[:])
    }
    
    // MARK: - Serialization
    public func toJSON() -> JSON? {
        return jsonify([
            GetUploadsResponse.uploadsKey ~~> self.uploads
        ])
    }
}
