import Combine

final class Repository<Item>: ObservableObject {
    @Published var items: [Item] = [] {
        willSet {
            previousItems = items
        }
    }

    private(set) var previousItems: [Item]?
}

extension Repository {
    func setItems(_ items: [Item]) {
        self.items = items
    }

    func insertItem(_ item: Item, at index: Int) {
        items.insert(item, at: index)
    }

    func insertItem(_ item: Item) {
        insertItem(item, at: 0)
    }

    func reset() {
        items.removeAll()
    }
}

extension Repository where Item: Identifiable {
    func firstById(_ id: Item.ID) -> Item? {
        items.first { $0.id == id }
    }

    func replaceById(_ item: Item) {
        for (index, element) in items.enumerated() where element.id == item.id {
            items[index] = item
        }
    }
}
