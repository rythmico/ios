import SwiftUI

extension VectorImage {
    init(
        asset: ImageAsset,
        resizeable: Bool = false,
        renderingMode: Image.TemplateRenderingMode? = .template,
        aspectRatio: ContentMode = .fit
    ) {
        self.init(
            name: asset.name,
            resizeable: resizeable,
            renderingMode: renderingMode,
            aspectRatio: aspectRatio
        )
    }
}
