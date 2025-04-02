//
//  CategoryCollectionViewCell.swift
//  Haystek
//
//  Created by Tirumala on 01/04/25.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var categoryImg: UIImageView!
    
    
    @IBOutlet weak var categoryLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

class GCOneColumnLeftAlignedFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var y: CGFloat = sectionInset.top
        attributes?.forEach { layoutAttribute in
            layoutAttribute.frame.origin.x = sectionInset.left
            layoutAttribute.frame.origin.y = y
            y = y + layoutAttribute.frame.height + minimumLineSpacing
        }

        return attributes
    }
}

func layout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let groupSize = NSCollectionLayoutSize(
        widthDimension: .absolute(75),
        heightDimension: .absolute(75))
    let group = NSCollectionLayoutGroup.vertical(
        layoutSize: groupSize, subitem: item, count: 1) // *
    group.edgeSpacing = NSCollectionLayoutEdgeSpacing(
        leading: nil, top: .flexible(0),
        trailing: nil, bottom: .flexible(0))
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 65
    let config = UICollectionViewCompositionalLayoutConfiguration()
    config.scrollDirection = .horizontal
    let layout = UICollectionViewCompositionalLayout(
        section: section, configuration:config)
    return layout
}
