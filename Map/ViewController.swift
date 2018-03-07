//
//  ViewController.swift
//  Map
//
//  Created by Kazama Ryusei on 2018/03/07.
//  Copyright © 2018年 Kazama Ryusei. All rights reserved.
//

import UIKit
// 今回mapViewを扱うのでMapKitをインポートする
import MapKit

class ViewController: UIViewController, UITextFieldDelegate {

    // IBOutletで紐付け
    @IBOutlet weak var inputText: UITextField!
    
    @IBOutlet weak var dispMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        inputText.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // textField外を押したときの処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        // 定数でtextFieldの中身を宣言
        let searchKeyword = textField.text
        // 入力された文字列をコンソールに出力
        print(searchKeyword!) // オプショナル型のためアンラップしなければならない
        
        // 住所から座標に変換するオブジェクトを生成
        let geocoder = CLGeocoder()
        
        //  searchKeywordに入っている値から座標を返す
        geocoder.geocodeAddressString(searchKeyword!, completionHandler: { (placemarks: [CLPlacemark]?, error: Error?) in
            // placemarksに緯度の値が入ってたら実行する
            if let placemark = placemarks?[0] {
                // placemarkに値が入っていたらmapViewにピンを指す
                if let targetCoordinate = placemark.location?.coordinate {
                    print(targetCoordinate)
                    // ピンを生成
                    let myPin: MKPointAnnotation = MKPointAnnotation()
                    // ピンに座標を設定
                    myPin.coordinate = targetCoordinate
                    // searchKeywordをそのままタイトルにする
                    myPin.title = searchKeyword
                    // ピンをmapViewに追加
                    self.dispMap.addAnnotation(myPin)
                    // 画面にピンが刺されたらそこの場所に移動する
                    self.dispMap.region = MKCoordinateRegionMakeWithDistance(targetCoordinate, 500.0, 500.0)
                }
            }
            
        })
        
        // boolean型で返す
        return true
    }


}

