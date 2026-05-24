import SwiftUI

struct ConnectorOverlay: View {
    @EnvironmentObject var vm: DeckViewModel

    var body: some View {
        Canvas { ctx, size in
            guard let root = vm.root else { return }
            let activeId = vm.activeIndex < vm.nodes.count ? vm.nodes[vm.activeIndex].id : ""

            if vm.viewMode == .timeline {
                drawTimeline(ctx: ctx, root: root, activeId: activeId)
            } else {
                for top in root.children {
                    walkConn(ctx: ctx, parent: nil, node: top, activeId: activeId)
                }
            }
        }
        .allowsHitTesting(false)
    }

    // MARK: - Timeline
    private func drawTimeline(ctx: GraphicsContext, root: RootNode, activeId: String) {
        let h1s = root.children
        guard !h1s.isEmpty else { return }

        let spineY = h1s[0].y
        var xRight: CGFloat = 0
        for h1 in h1s {
            xRight = max(xRight, h1.x + LayoutEngine.cardW)
            for h2 in h1.children { xRight = max(xRight, h2.x + LayoutEngine.cardW) }
        }

        // Spine
        var spinePath = Path()
        spinePath.move(to: CGPoint(x: h1s[0].x, y: spineY))
        spinePath.addLine(to: CGPoint(x: xRight, y: spineY))
        ctx.stroke(spinePath, with: .color(vm.theme.line), lineWidth: 2.0)

        for h1 in h1s {
            for h2 in h1.children {
                // Horizontal branch: H1-right → H2-left along spine
                let branchY = spineY
                var branchPath = Path()
                branchPath.move(to: CGPoint(x: h1.x + LayoutEngine.cardW, y: branchY))
                branchPath.addLine(to: CGPoint(x: h2.x, y: branchY))
                let branchColor = (vm.visitedIds.contains(h2.id) || vm.visitedIds.contains(h1.id))
                    ? vm.theme.visited : vm.theme.line
                ctx.stroke(branchPath, with: .color(branchColor), lineWidth: 1.5)

                for h3 in h2.children {
                    // Vertical drop from H2 bottom-centre to H3 mid
                    var dropPath = Path()
                    let dropX = h2.x + LayoutEngine.cardW / 2
                    dropPath.move(to: CGPoint(x: dropX, y: h2.y + LayoutEngine.cardH))
                    dropPath.addLine(to: CGPoint(x: dropX, y: h3.y + LayoutEngine.cardH / 2))
                    dropPath.addLine(to: CGPoint(x: h3.x, y: h3.y + LayoutEngine.cardH / 2))
                    let dropColor = (vm.visitedIds.contains(h3.id) || vm.visitedIds.contains(h2.id))
                        ? vm.theme.visited : vm.theme.line
                    ctx.stroke(dropPath, with: .color(dropColor), lineWidth: 1.5)
                }
            }
        }
    }

    // MARK: - Map / Logic
    private func walkConn(ctx: GraphicsContext, parent: Node?, node: Node, activeId: String) {
        if let parent = parent {
            drawLine(ctx: ctx, parent: parent, child: node, activeId: activeId)
        }
        for child in node.children {
            walkConn(ctx: ctx, parent: node, node: child, activeId: activeId)
        }
    }

    private func drawLine(ctx: GraphicsContext, parent: Node, child: Node, activeId: String) {
        let isActiveConnector = (parent.id == activeId || child.id == activeId)
        let isVisited = vm.visitedIds.contains(child.id) && vm.visitedIds.contains(parent.id)
        let color: Color = isActiveConnector ? vm.theme.active
                         : isVisited ? vm.theme.visited
                         : vm.theme.line

        var path = Path()

        if vm.viewMode == .map {
            let py = parent.y + parent.h / 2
            let cy = child.y  + child.h / 2
            let childIsRight = (child.x + child.w / 2) > (parent.x + parent.w / 2)
            let px: CGFloat = childIsRight ? parent.x + parent.w : parent.x
            let cx: CGFloat = childIsRight ? child.x             : child.x + child.w
            let mx = (px + cx) / 2
            path.move(to: CGPoint(x: px, y: py))
            path.addCurve(
                to: CGPoint(x: cx, y: cy),
                control1: CGPoint(x: mx, y: py),
                control2: CGPoint(x: mx, y: cy)
            )
        } else {
            // Logic: left-to-right bezier
            let py = parent.y + parent.h / 2
            let px = parent.x + parent.w
            let cy = child.y  + child.h / 2
            let cx = child.x
            let mx = (px + cx) / 2
            path.move(to: CGPoint(x: px, y: py))
            path.addCurve(
                to: CGPoint(x: cx, y: cy),
                control1: CGPoint(x: mx, y: py),
                control2: CGPoint(x: mx, y: cy)
            )
        }

        ctx.stroke(path, with: .color(color), lineWidth: 1.5)
    }
}
