import FoundationEncore

extension ImageReference {
    static func asset(_ asset: ImageAsset) -> Self {
        .assetName(asset.name)
    }
}
