import Foundation

class BlockSaver {
    static let shared = BlockSaver()

    let realmFactory: RealmFactory

    init(realmFactory: RealmFactory = .shared) {
        self.realmFactory = realmFactory
    }

    func create(withHeight height: Int, fromItems items: [BlockHeaderItem]) {
        let realm = realmFactory.realm

        var currentHeight = height
        var blocks = [Block]()

        for item in items {
            currentHeight += 1

            let rawHeader = item.serialized()
            let hash = Crypto.sha256sha256(rawHeader)

            let block = Block()
            block.reversedHeaderHashHex = hash.reversedHex
            block.headerHash = hash
            block.rawHeader = rawHeader
            block.height = currentHeight

            blocks.append(block)
        }

        try? realm.write {
            realm.add(blocks, update: true)
        }
    }

    func update(block: Block, withMerkleBlock merkleBlock: MerkleBlockMessage) {

    }

}