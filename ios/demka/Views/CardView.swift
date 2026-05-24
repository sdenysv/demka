import SwiftUI

struct CardView: View {
    let node: Node
    @EnvironmentObject var vm: DeckViewModel

    private var isActive: Bool {
        guard vm.activeIndex < vm.nodes.count else { return false }
        return vm.nodes[vm.activeIndex].id == node.id
    }
    private var isVisited: Bool { vm.visitedIds.contains(node.id) }
    private var nodeIndex: Int {
        vm.nodes.firstIndex(where: { $0.id == node.id }) ?? 0
    }
    private var isFollowing: Bool {
        vm.isPresenting && nodeIndex > vm.activeIndex
    }

    private var borderColor: Color {
        guard vm.isPresenting else { return vm.theme.line }
        if isActive  { return vm.theme.active }
        if isVisited { return vm.theme.visited }
        return vm.theme.line
    }
    private var bgColor: Color {
        guard vm.isPresenting else { return vm.theme.surface }
        if isActive  { return vm.theme.surface }
        if isVisited { return vm.theme.bg }
        return vm.theme.surface
    }
    private var borderWidth: CGFloat {
        vm.isPresenting && isActive ? 1.5 : 1.0
    }

    private var headerHeight: CGFloat { LayoutEngine.cardH * 0.28 }

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 8)
                .fill(bgColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(borderColor, lineWidth: borderWidth)
                )

            VStack(alignment: .leading, spacing: 0) {
                titleText
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: headerHeight)
                    .padding(.horizontal, 16)

                if !node.lede.isEmpty || !node.bullets.isEmpty {
                    bodyContent
                        .padding(.horizontal, 16)
                        .padding(.bottom, 10)
                }
            }
        }
        .frame(width: node.w, height: node.h)
        .scaleEffect(vm.isPresenting && isActive ? 1.02 : 1.0, anchor: .center)
        .animation(.easeInOut(duration: 0.18), value: isActive)
        .onTapGesture {
            if !vm.isPresenting {
                vm.activateNode(node)
            }
        }
    }

    @ViewBuilder
    private var titleText: some View {
        let ink = (vm.isPresenting && isVisited) ? vm.theme.ink2 : vm.theme.ink
        switch node.level {
        case 1:
            Text(node.title)
                .font(.system(size: 26, weight: .black))
                .foregroundColor(ink)
                .lineLimit(2)
        case 2:
            Text(node.title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(ink)
                .lineLimit(2)
        default:
            Text(node.title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(ink)
                .lineLimit(2)
        }
    }

    @ViewBuilder
    private var bodyContent: some View {
        VStack(alignment: .leading, spacing: 6) {
            if !node.lede.isEmpty {
                let ledeVisible: Bool = {
                    if !vm.isPresenting { return true }
                    if isFollowing      { return false }
                    return !isActive || bulletsShownCount > 0
                }()
                Text(node.lede)
                    .font(.system(size: 13))
                    .foregroundColor(vm.theme.ink2)
                    .lineLimit(2)
                    .opacity(ledeVisible ? 1 : 0)
                    .animation(.easeOut(duration: 0.18), value: bulletsShownCount)
            }

            ForEach(Array(node.bullets.enumerated()), id: \.element.id) { idx, bullet in
                let bulletOffset = node.lede.isEmpty ? 0 : 1
                let bulletVisible: Bool = {
                    if !vm.isPresenting { return true }
                    if isFollowing      { return false }
                    return !isActive || bulletsShownCount > idx + bulletOffset
                }()
                HStack(alignment: .top, spacing: 8) {
                    if let num = bullet.num {
                        Text("\(num).")
                            .font(.system(size: 11, weight: .semibold, design: .monospaced))
                            .foregroundColor(vm.theme.ink2)
                            .frame(minWidth: 18, alignment: .leading)
                    } else {
                        Rectangle()
                            .fill(vm.theme.ink2)
                            .frame(width: 8, height: 1.5)
                            .padding(.top, 8)
                    }
                    Text(bullet.text)
                        .font(.system(size: 12))
                        .foregroundColor(bulletVisible ? vm.theme.ink : vm.theme.mute)
                        .lineLimit(2)
                }
                .opacity(bulletVisible ? 1 : ((isActive || isFollowing) ? 0 : 1))
                .animation(.easeOut(duration: 0.18), value: bulletsShownCount)
            }
        }
    }

    private var bulletsShownCount: Int {
        if !vm.isPresenting    { return Int.max }
        if isFollowing         { return 0 }
        if !vm.revealEnabled   { return Int.max }
        if isActive            { return vm.bulletsShown }
        return Int.max
    }
}
