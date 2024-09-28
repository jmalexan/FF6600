//
//  Comment.swift
//  Hackery
//
//  Created by Jonathan Alexander on 9/25/24.
//

import SwiftUI

let PARAGRAPH_SPACING: CGFloat = 10

struct CommentView: View {
    let comment: Comment
    
    var body: some View {
        VStack {
            Group {
                HStack {
                    Text(comment.author)
                        .font(.subheadline)
    //                Text(comment.createdAt.description)
                    Spacer()
                }
                let parsedText = parseContent(comment.text)
                VStack(spacing: PARAGRAPH_SPACING) {
                    ForEach(Array(parsedText.split(separator: "\n").enumerated()), id: \.offset) { (index, line) in
                        HStack {
                            Text(.init(String(line)))
                                .frame(alignment: .leading)
                            Spacer()
                        }
                    }
                }
            }
            if !comment.children.isEmpty {
                HStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(maxHeight: .infinity)
                        .frame(width: 2)
                    LazyVStack(spacing: 20) {
                        ForEach(Array(comment.children.enumerated()), id: \.offset) { (index, child) in
                            CommentView(comment: child)
                        }
                    }
                }
                .padding(.top, 10)
            }
        }
    }
}

#Preview {
    ScrollView {
        CommentView(comment: Comment(id: 41538924, author: "cheschire", text: "I use metaphors far too frequently in spoken conversations, and I have learned that it’s often more effective to cut bait (there’s one!) than to try to transition to a new metaphor mid stream of consciousness.<p>So they are useful, but I’ve noticed weakness in using them as well.", children: [Comment(id: 41538992, author: "quietbritishjim", text: "&gt;  more effective to cut bait (there’s one!)<p>I have no idea what you mean by this, I can&#x27;t even figure out roughly what you mean from context, so I guess that&#x27;s a weakness of them for a start.", children: [Comment(id: 41539141, author: "onethought", text: "Sometimes a metaphor doesn’t make sense so you might abandon it for another rather than trying to stretch it.<p>Sometimes when fishing you catch something your rod or skill level is not capable of reeling in. So you are better to cut the line&#x2F;bait rather than lose your whole rod.", children: [Comment(id: 41539943, author: "082349872349872", text: "That&#x27;s funny, I&#x27;d always interpreted it as you can either:<p>- fish, or<p>- cut bait (slice baitfish into bait-sized pieces)<p>Of course, the latter activity is not fishing, merely fishing-adjacent.", children: [Comment(id: 41571898, author: "onethought", text: "Two distinct expressions that happen to share words. Is how I thought of it. Certainly in the context of the OP it seems he is not presenting an either or but a change course.", children: [])]), Comment(id: 41541512, author: "giardini", text: "I was enlightened to read your interpretation, which Wikipedia indeed lists as a &quot;more modern, alternative interpretation&quot;.<p>The prevailing interpretation is a directive to make a decision rather than dally:<p><a href=\"https:&#x2F;&#x2F;en.wikipedia.org&#x2F;wiki&#x2F;Fish_or_cut_bait\" rel=\"nofollow\">https:&#x2F;&#x2F;en.wikipedia.org&#x2F;wiki&#x2F;Fish_or_cut_bait</a>", children: [])]), Comment(id: 41539270, author: "AnimalMuppet", text: "&quot;Cut bait&quot; isn&#x27;t really a metaphor by this time; it&#x27;s more an idiom that is based on a metaphor.  It comes from &quot;fish or cut bait&quot;, that is, either do one thing or the other.  It means to stop being indecisive, to come to the point.", children: [Comment(id: 41539725, author: "hunter2_", text: "Seems analogous to &quot;get off the pot&quot; although glossing over the alternative is less common for this one.", children: [])])]), Comment(id: 41538999, author: "throwbadubadu", text: "Yes.. I agree to the example and reasoning in the article, but on the other hand metaphors can simplify things too much, and even tell lies. E.g. politicians using them is the prime example. Thus, not convinced...", children: [Comment(id: 41539234, author: "k__", text: "Also, their meaning gets lost over time.<p>That&#x27;s why it&#x27;s not recommended to use them in prose. But they get buried (!) anyway.", children: [])])]))
            .padding()
    }
}
