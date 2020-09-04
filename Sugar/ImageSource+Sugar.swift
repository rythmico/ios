import Foundation

extension ImageSource {
    static func asset(_ asset: ImageAsset) -> Self {
        .assetName(asset.name)
    }
}
