import Foundation
import CoreGraphics

enum ViewMode: String, CaseIterable, Identifiable {
    case timeline, map, logic
    var id: String { rawValue }

    var label: String {
        switch self {
        case .timeline: return "Timeline"
        case .map:      return "Map"
        case .logic:    return "Logic"
        }
    }

    var symbol: String {
        switch self {
        case .timeline: return "→"
        case .map:      return "×"
        case .logic:    return "K"
        }
    }
}

enum LayoutEngine {
    // MARK: - Constants
    static let cardW: CGFloat = 280
    static let cardH: CGFloat = 180
    static let hGap: CGFloat  = 80
    static let vGap: CGFloat  = 50

    // MARK: - Timeline
    /// Ports JS layoutTimeline exactly.
    static func layoutTimeline(_ root: RootNode) {
        let all = root.flatten()
        guard !all.isEmpty else {
            root.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
            return
        }
        for n in all { n.w = cardW; n.h = cardH }

        let HEADER_MID: CGFloat = (cardH * 0.18).rounded()
        let ROW_Y: CGFloat      = -HEADER_MID
        let CHILD_GAP: CGFloat  = (vGap * 0.55).rounded()
        let SUB_GAP: CGFloat    = (vGap * 0.35).rounded()

        var xCur: CGFloat = 0
        for h1 in root.children {
            h1.x = xCur; h1.y = ROW_Y; h1.depth = 0
            xCur += cardW + hGap

            for h2 in h1.children {
                h2.x = xCur; h2.y = ROW_Y; h2.depth = 1

                var yCur: CGFloat = ROW_Y + cardH + CHILD_GAP
                for h3 in h2.children {
                    h3.x = xCur; h3.y = yCur; h3.depth = 2
                    yCur += cardH + SUB_GAP
                }
                xCur += cardW + hGap
            }
            xCur += hGap // extra section gap after each H1 group
        }

        applyBounds(root)
    }

    // MARK: - Map
    /// Root H1 at centre, H2s split left/right, secondary H1s placed below root.
    static func layoutMap(_ root: RootNode) {
        let all = root.flatten()
        guard !all.isEmpty else {
            root.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
            return
        }
        for n in all { n.w = cardW; n.h = cardH }

        let HDIST: CGFloat = cardW * 0.4
        let MVGAP: CGFloat = vGap * 0.5
        let VDIST: CGFloat = HDIST * 2

        func placeCol(_ nodes: [Node], side: String, x: CGFloat, centerY: CGFloat, depth: Int) {
            guard !nodes.isEmpty else { return }
            let totalH = CGFloat(nodes.count) * cardH + CGFloat(nodes.count - 1) * MVGAP
            let startY = centerY - totalH / 2
            for (i, n) in nodes.enumerated() {
                n.x = x
                n.y = startY + CGFloat(i) * (cardH + MVGAP)
                n.depth = depth
                if !n.children.isEmpty {
                    let nx: CGFloat = side == "right"
                        ? n.x + cardW + HDIST
                        : n.x - HDIST - cardW
                    placeCol(n.children, side: side, x: nx, centerY: n.y + cardH / 2, depth: depth + 1)
                }
            }
        }

        let colHalf: ([Node]) -> CGFloat = { ns in
            ns.isEmpty ? 0 : (CGFloat(ns.count) * cardH + CGFloat(ns.count - 1) * MVGAP) / 2
        }

        let h1 = root.children[0]
        h1.x = -cardW / 2; h1.y = -cardH / 2; h1.depth = 0

        let h2Kids = h1.children.filter { $0.level != 1 }
        let h1Kids = h1.children.filter { $0.level == 1 }

        let rCount     = Int(ceil(Double(h2Kids.count) / 2.0))
        let rightNodes = Array(h2Kids.prefix(rCount))
        let leftNodes  = Array(h2Kids.dropFirst(rCount))
        placeCol(rightNodes, side: "right", x: cardW / 2 + HDIST,          centerY: 0, depth: 1)
        placeCol(leftNodes,  side: "left",  x: -cardW / 2 - HDIST - cardW, centerY: 0, depth: 1)

        if !h1Kids.isEmpty {
            let h2Bottom = max(cardH / 2, colHalf(rightNodes), colHalf(leftNodes))
            var yKid = h2Bottom + VDIST

            for kid in h1Kids {
                kid.x = -cardW / 2; kid.y = yKid; kid.depth = 1
                let kidH2s  = kid.children
                let kRCount = Int(ceil(Double(kidH2s.count) / 2.0))
                let kidCY   = yKid + cardH / 2
                placeCol(Array(kidH2s.prefix(kRCount)), side: "right", x: cardW / 2 + HDIST,          centerY: kidCY, depth: 2)
                placeCol(Array(kidH2s.dropFirst(kRCount)), side: "left", x: -cardW / 2 - HDIST - cardW, centerY: kidCY, depth: 2)
                let kidBottom = max(cardH / 2, colHalf(Array(kidH2s.prefix(kRCount))), colHalf(Array(kidH2s.dropFirst(kRCount))))
                yKid += cardH / 2 + kidBottom + VDIST
            }
        }

        applyBounds(root)
    }

    // MARK: - Logic
    /// Ports JS layoutLogic exactly.
    static func layoutLogic(_ root: RootNode) {
        let all = root.flatten()
        guard !all.isEmpty else {
            root.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
            return
        }
        for n in all { n.w = cardW; n.h = cardH }

        let HDIST: CGFloat = cardW * 0.9

        func subH(_ n: Node) -> CGFloat {
            if n.children.isEmpty { return cardH }
            let total = n.children.reduce(CGFloat(0)) { $0 + subH($1) } + vGap * CGFloat(n.children.count - 1)
            return max(cardH, total)
        }

        func place(_ n: Node, x: CGFloat, centerY: CGFloat, depth: Int) {
            n.depth = depth
            n.x = x
            n.y = centerY - cardH / 2
            guard !n.children.isEmpty else { return }
            let totalH = n.children.reduce(CGFloat(0)) { $0 + subH($1) } + vGap * CGFloat(n.children.count - 1)
            var cy = centerY - totalH / 2
            for c in n.children {
                let sh = subH(c)
                place(c, x: x + cardW + HDIST, centerY: cy + sh / 2, depth: depth + 1)
                cy += sh + vGap
            }
        }

        var yOff: CGFloat = 0
        for h1 in root.children {
            let sh = subH(h1)
            place(h1, x: 0, centerY: yOff + sh / 2, depth: 0)
            yOff += sh + vGap * 2
        }

        applyBounds(root)
    }

    // MARK: - applyBounds
    static func applyBounds(_ root: RootNode) {
        let all = root.flatten()
        guard !all.isEmpty else {
            root.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
            return
        }
        var minX = CGFloat.infinity, minY = CGFloat.infinity
        var maxX = -CGFloat.infinity, maxY = -CGFloat.infinity
        for n in all {
            minX = min(minX, n.x); minY = min(minY, n.y)
            maxX = max(maxX, n.x + n.w); maxY = max(maxY, n.y + n.h)
        }
        let PAD: CGFloat = cardW * 0.18
        let offX = -minX + PAD
        let offY = -minY + PAD
        for n in all {
            n.x += offX
            n.y += offY
        }
        root.bounds = CGRect(x: 0, y: 0,
                             width:  (maxX - minX) + PAD * 2,
                             height: (maxY - minY) + PAD * 2)
    }

    // MARK: - promoteFirstAsRoot
    /// If map or logic and multiple H1s, make first H1 the parent of all others.
    static func promoteFirstAsRoot(_ root: RootNode) {
        guard root.children.count > 1 else { return }
        let first = root.children[0]
        let rest  = Array(root.children.dropFirst())
        for n in rest { n.parent = first }
        first.children = first.children + rest
        root.children = [first]
    }
}
