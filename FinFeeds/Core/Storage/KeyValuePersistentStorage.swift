//
//  Created by Kurlovich Vitali on 9/29/26.
//

protocol KeyValuePersistentStorage: KeyValueStorage {
    func load()
    func save()
}
