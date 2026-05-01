//
//  IGInpuntField.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 30.04.2026.
//

import SwiftUI

struct IGInpuntField<E: Error>: View {
    @Binding private var error: E?
    @Binding private var text: String
    
    private let isLoading: Bool
    private let placeholder: String

    init(_ placeholder: String, text: Binding<String>) where E == Never {
        _text = text
        _error = .constant(nil)
        
        self.placeholder = placeholder
        self.isLoading = false
    }

    init(_ placeholder: String, text: Binding<String>, error: Binding<E?>, isLoading: Bool) {
        _text = text
        _error = error
        
        self.isLoading = isLoading
        self.placeholder = placeholder
    }

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .trailing) {
                TextField(placeholder, text: $text)
                    .font(.subheadline)
                    .padding(12)
                    .frame(width: 360, height: 48)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                if isLoading {
                    ProgressView()
                        .padding(.trailing)
                }
                
                if error != nil {
                    Button {
                        text = ""
                        error = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.large)
                            .fontWeight(.semibold)
                            .foregroundStyle(.red)
                            .padding(.trailing)
                    }
                }
            }
            
            if let error {
                Text(error.localizedDescription)
                    .foregroundStyle(.red)
                    .font(.footnote)
            }
        }
    }
}

#Preview {
    IGInpuntField("Test", text: .constant(""))
}
