//
//  DashBoardCard.swift
//  UserDataForms
//
//  Created by hemanth.p on 05/06/25.
//

import SwiftUI

struct DashBoardCard: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("ID Vault")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
                    .accessibilityIdentifier("title_tv")

                Spacer()
                
                Text("ID Vault")
                    .font(.headline)
                    .padding(.bottom, 5)
                    .accessibilityIdentifier("subtitle_tv")
                
                Spacer()
            }
            vaultIcon
        }
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color(.gray), radius: 2, y: 1)
        )
        .padding(.horizontal)
        .padding([.bottom], 25)
    }
    
    var vaultIcon: some View {
        Image("vault_card_setup_icon")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .accessibilityIdentifier("image_tv")
    }
}

#Preview {
    return VStack {
        DashBoardCard()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        DashBoardCard()
        DashBoardCard()
        DashBoardCard()
        DashBoardCard()
    }
}
