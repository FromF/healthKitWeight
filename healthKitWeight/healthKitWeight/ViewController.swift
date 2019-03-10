//
//  ViewController.swift
//  healthKitWeight
//
//  Created by 藤　治仁 on 2019/03/11.
//  Copyright © 2019 FromF.github.com. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var writeButton: UIButton!
    
    private let myHealthStore : HKHealthStore = HKHealthStore()
    private var weightArray:[weight] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let path = Bundle.main.path(forResource: "database", ofType:"weightlog" ) {
            if let dictArray = NSArray(contentsOfFile: path) {
                for item in dictArray {
                    if let dict = item as? NSDictionary {
                        let d = dict["date"] as! String
                        let w = dict["weight"] as! String
                        let value = weight(date: d, value: w)
                        weightArray.append(value)
                    }
                }
            }
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        
        requestAuthorization()
    }
    
    //MARK:- Button
    @IBAction func writeButtonAction(_ sender: Any) {
        for w in weightArray {
            writeData(weight: w.value!, date: w.date!)
        }
    }
    
    //MARK:- UITableViewDelegate , UITableViewDataSource
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Cellの総数を返すdatasourceメソッド、必ず記述する必要があります
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = weightArray.count
        return count
    }
    
    // Cellに値を設定するdatasourceメソッド。必ず記述する必要があります
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let section = indexPath.section
        let index = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .none

        cell.textLabel?.text = f.string(from: weightArray[index].date!)
        cell.detailTextLabel?.text = "\(weightArray[index].value!)"
        
        return cell
    }
    
    //MARK:- HealthKit
    private func requestAuthorization() {
        // 書き込みを許可する型.
        let typeOfWrites: Set<HKSampleType> = [HKSampleType.quantityType(forIdentifier: .bodyMass)!]
        // 読み込みを許可する型.
        let typeOfReads: Set<HKSampleType> = [HKSampleType.quantityType(forIdentifier: .bodyMass)!]

        //  HealthStoreへのアクセス承認をおこなう.
        myHealthStore.requestAuthorization(toShare: typeOfWrites, read: typeOfReads, completion: { (success, error) in
            if let e = error {
                print("Error: \(e.localizedDescription)")
                return
            }
            print(success ? "Success!" : " Failure!")
        })
    }
    
    /*
     体重データを保存.
     */
    private func writeData(weight: Double , date:Date) {
        // 体重のタイプ.
        let typeOfWeight = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
        // 体重データを作成(Kg->gに変換する).
        let myWeight = HKQuantity(unit: HKUnit.gram(), doubleValue: weight * 1000)
        // StoreKit保存用データを作成.
        let myWeightData = HKQuantitySample(type: typeOfWeight!, quantity: myWeight, start: date, end: date)
        
        // データの保存.
        myHealthStore.save(myWeightData, withCompletion: { (success, error) in
            if let e = error {
                print("Error: \(e.localizedDescription)")
            }
            print(success ? "Success!" : " Failure!")
        })
    }
}

