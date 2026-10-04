//
//  Created by Kurlovich Vitali on 10/1/26.
//

import SwiftUI

struct FeedsView: View {
    var body: some View {
          NavigationStack {
        SymbolFeedsSubscriptionsView { binding in
            SymbolFeedsPricesView(binding)
        }
         }
    }
}
