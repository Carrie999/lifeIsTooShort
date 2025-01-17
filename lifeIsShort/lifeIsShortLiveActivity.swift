//
//  lifeIsShortLiveActivity.swift
//  lifeIsShort
//
//  Created by  玉城 on 2024/11/15.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct lifeIsShortAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct lifeIsShortLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: lifeIsShortAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension lifeIsShortAttributes {
    fileprivate static var preview: lifeIsShortAttributes {
        lifeIsShortAttributes(name: "World")
    }
}

extension lifeIsShortAttributes.ContentState {
    fileprivate static var smiley: lifeIsShortAttributes.ContentState {
        lifeIsShortAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: lifeIsShortAttributes.ContentState {
         lifeIsShortAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: lifeIsShortAttributes.preview) {
   lifeIsShortLiveActivity()
} contentStates: {
    lifeIsShortAttributes.ContentState.smiley
    lifeIsShortAttributes.ContentState.starEyes
}
