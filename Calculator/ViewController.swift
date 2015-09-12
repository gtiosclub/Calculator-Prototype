//
//  ViewController.swift
//  Calculator
//
//  Created by Cal on 9/11/15.
//  Copyright (c) 2015 Georgia Tech's iOS Club. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - User Interaction
    
    var calculation: CalculationProtocol = DefaultCalculation()
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var expressionLabel: UILabel!
    
    
    @IBAction func numberButtonPressed(sender: UIButton) {
        let number = sender.titleLabel!.text!.toInt()!
        calculation.handleInput(number)
        updateLabels()
    }
    
    @IBAction func additionPressed(sender: AnyObject) {
        setOperator("+", withFunction: +)
    }

    @IBAction func subtractPressed(sender: AnyObject) {
        setOperator("-", withFunction: -)
    }
    
    @IBAction func multiplyPressed(sender: AnyObject) {
        setOperator("x", withFunction: *)
    }
    
    @IBAction func dividePressed(sender: AnyObject) {
        setOperator("÷", withFunction: { left, right in
            if right == 0.0 { return right }
            return left / right
        })
    }
    
    func updateLabels() {
        expressionLabel.text = calculation.expressionString
        resultLabel.text = calculation.resultNumber.roundedString
    }
    
    func setOperator(character: String, withFunction function: (Double, Double) -> Double) {
        calculation.setOperator(DefaultOperator(forCharacter: character, withFunction: function))
        updateLabels()
        reloadTable()
    }

    @IBAction func clearPressed(sender: AnyObject) {
        calculation.clearInputAndSave(false)
        updateLabels()
        reloadTable()
    }
    
    @IBAction func equalsPressed(sender: AnyObject) {
        expressionLabel.text = ""
        let result = calculation.resultNumber
        resultLabel.text = result.roundedString
        calculation.clearInputAndSave(true)
        calculation.leftNumber = result
        reloadTable()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //MARK: - UITableViewController Delegate
    @IBOutlet weak var tableView: UITableView!
    
    func reloadTable() {
        tableView.reloadData()
        let lastIndex = NSIndexPath(forItem: calculation.previousExpressions.count - 1, inSection: 0)
        if lastIndex.item >= 0 {
            tableView.scrollToRowAtIndexPath(lastIndex, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calculation.previousExpressions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("expressionCell") as! ExpressionCell
        let index = indexPath.item
        let (expression, result) = calculation.previousExpressions[indexPath.item]
        cell.decorateForExpression(expression, result: result)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40.0
    }
    

}

//MARK: - UITableView Custom Cell

class ExpressionCell : UITableViewCell {
    
    @IBOutlet weak var expressionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    func decorateForExpression(expression: String, result: String) {
        expressionLabel.text = expression
        resultLabel.text = result
    }
    
}
