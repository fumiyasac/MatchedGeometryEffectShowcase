import Foundation
import UIKit

// MARK: - サムネイル画像が浮き上がる表現を実現するためのプロトコル
// 画面遷移元・画面遷移先の両方が準拠し、トランジションアニメータへ必要な情報を提供する

protocol PastaDetailTransitionAnimatorDelegate: AnyObject {

    // 画面遷移処理が開始した際に実行される処理（対象要素を非表示にする想定）
    func transitionWillStart()

    // 画面遷移処理が終了した際に実行される処理（非表示にした要素を元に戻す）
    func transitionDidEnd()

    // 画面遷移実行時にスナップショットとなるUIImageViewに割り当てる画像
    func referenceImage() -> UIImage?

    // 画面遷移実行時にスナップショットとなるUIImageViewの元の矩形
    func imageFrame() -> CGRect?
}
