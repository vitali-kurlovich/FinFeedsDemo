//
//  Created by Kurlovich Vitali on 10/1/26.
//

import DataLayer
import SwiftData
import SwiftUI

struct SymbolFeedsPricesView: View {
    @Environment(\.feedSubscribtionsUpdater)
    private var feedSubscribtionsUpdater

    @State
    private var searchText: String = ""

    @State
    private var isSearchPresented: Bool = false

    @FocusState
    private var searchFocused: Bool

    var body: some View {
        SymbolFeedsPricesContentView()
            .overlay {
                if isSearchPresented {
                    SymbolFeedsPricesSearchContentView(
                        searchText: $searchText
                    )
                }
            }
            .searchable(text: $searchText, isPresented: $isSearchPresented)
            .searchFocused($searchFocused)
            .onChange(of: isSearchPresented) {
                searchFocused = isSearchPresented
                if isSearchPresented == false {
                    searchText = ""
                }
            }
            .task {
                do {
                    try await feedSubscribtionsUpdater.prefetch()
                } catch {
                    // TODO: Logging errors
                }
            }
    }
}
